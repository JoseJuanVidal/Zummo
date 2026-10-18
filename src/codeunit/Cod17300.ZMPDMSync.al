codeunit 17300 "ZM PDM Sync"
{
    // =============ZM PDM Sync====================
    // ==
    // ==  Lectura del PDM SolidWorks (SQL, solo lectura) -> documentos aprobados, histórico y relación con productos.
    // ==  Apertura de ficheros del almacén del PDM: los lee el servicio de BC y los envía al cliente,
    // ==  así los usuarios no necesitan licencia ni acceso al PDM.
    // ==  Cola de proyectos: ejecutar esta codeunit (sincronización incremental).
    // ==
    // ======================================================================================================
    trigger OnRun()
    begin
        Synchronize(false);
    end;

    var
        InventorySetup: Record "Inventory Setup";
        TempAffectedItem: Record Item temporary;
        TempSyncedDocument: Record "Integer" temporary;
        FileMgt: Codeunit "File Management";
        Window: Dialog;
        SyncTime: DateTime;
        LiveSearchFailed: Boolean;
        LiveFileName: Text;
        LiveStatus: Text;
        PasswordKeyTok: Label 'ZMPDMSQLPassword', Locked = true;
        ApprovedStatusTok: Label 'N''Aprobado'',N''Aprobado Librería'',N''Publicado'',N''Publicado PDF'',N''Publicado PDF_DXF_X_T'',N''Publicado produccion''', Locked = true;

    // ======================================================================================================
    // ==  Sincronización
    // ======================================================================================================
    procedure Synchronize(FullReload: Boolean)
    var
        PDMDocument: Record "ZM PDM Document";
        PDMHistory: Record "ZM PDM History";
        PDMItemLink: Record "ZM PDM Item Link";
        SQLConnection: DotNet SqlConnection;
        Since: Text;
        NewMark: Text;
        NoDocs: Integer;
        NoHist: Integer;
        lblWindow: Label 'Synchronizing PDM\#1##############################\#2##########', comment = 'ESP="Sincronizando PDM\#1##############################\#2##########"';
        NoRequests: Integer;
        lblDone: Label 'PDM synchronization finished.\Documents: %1\History entries: %2\Updated item requests: %3', comment = 'ESP="Sincronización PDM terminada.\Documentos: %1\Líneas de histórico: %2\Solicitudes de alta actualizadas: %3"';
    begin
        InventorySetup.Get();
        CheckSetup();
        SyncTime := CurrentDateTime();
        TempAffectedItem.Reset();
        TempAffectedItem.DeleteAll();
        TempSyncedDocument.Reset();
        TempSyncedDocument.DeleteAll();
        if GuiAllowed() then
            Window.Open(lblWindow);
        SQLConnect(SQLConnection);
        NewMark := GetServerTime(SQLConnection);
        if FullReload or (InventorySetup."PDM Sync Mark" = '') then begin
            Since := 'NULL';
            PDMItemLink.DeleteAll();
            PDMHistory.DeleteAll();
            PDMDocument.DeleteAll();
        end else
            // margen de 10 minutos sobre la marca anterior, por si alguna transacción del PDM quedó a caballo
            Since := StrSubstNo('DATEADD(minute, -10, CONVERT(datetime, ''%1'', 120))', InventorySetup."PDM Sync Mark");

        NoDocs := SyncDocuments(SQLConnection, Since);
        NoHist := SyncHistory(SQLConnection, Since);
        SQLConnection.Close();
        AddCurrentLinks();
        UpdateMainLinks();
        NoRequests := UpdateOpenRequests();

        InventorySetup.Get();
        InventorySetup."PDM Sync Mark" := CopyStr(NewMark, 1, MaxStrLen(InventorySetup."PDM Sync Mark"));
        InventorySetup."PDM Last Sync" := SyncTime;
        InventorySetup.Modify();
        if GuiAllowed() then begin
            Window.Close();
            Message(lblDone, NoDocs, NoHist, NoRequests);
        end;
    end;

    local procedure SyncDocuments(var SQLConnection: DotNet SqlConnection; Since: Text) NoDocs: Integer
    var
        PDMDocument: Record "ZM PDM Document";
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        lblDocuments: Label 'Documents', comment = 'ESP="Documentos"';
    begin
        UpdateWindow(1, lblDocuments);
        SQLCommand := SQLConnection.CreateCommand();
        SQLCommand.CommandTimeout := 600;
        SQLCommand.CommandText := DocumentsQuery(Since);
        SQLReader := SQLCommand.ExecuteReader();
        while SQLReader.Read() do begin
            if PDMDocument.Get(GetInt(SQLReader, 'DocumentID')) then begin
                AddAffectedItems(PDMDocument."Document ID");
                PDMDocument.Delete(true);
            end;
            if (GetInt(SQLReader, 'Deleted') = 0) and (GetInt(SQLReader, 'ApprovedVersion') <> 0) then begin
                InsertDocument(SQLReader);
                TempSyncedDocument.Number := GetInt(SQLReader, 'DocumentID');
                TempSyncedDocument.Insert();
                NoDocs += 1;
                if NoDocs mod 200 = 0 then
                    UpdateWindow(2, Format(NoDocs));
            end;
        end;
        SQLReader.Close();
    end;

    local procedure InsertDocument(var SQLReader: DotNet SqlDataReader)
    var
        PDMDocument: Record "ZM PDM Document";
    begin
        PDMDocument.Init();
        PDMDocument."Document ID" := GetInt(SQLReader, 'DocumentID');
        PDMDocument."File Name" := CopyStr(GetText(SQLReader, 'Filename'), 1, MaxStrLen(PDMDocument."File Name"));
        PDMDocument.Extension := CopyStr(LowerCase(GetText(SQLReader, 'Extension')), 1, MaxStrLen(PDMDocument.Extension));
        PDMDocument.Folder := CopyStr(GetText(SQLReader, 'Folder'), 1, MaxStrLen(PDMDocument.Folder));
        PDMDocument."PDM Code" := CopyStr(GetText(SQLReader, 'Code'), 1, MaxStrLen(PDMDocument."PDM Code"));
        PDMDocument.Description := CopyStr(GetText(SQLReader, 'Descr'), 1, MaxStrLen(PDMDocument.Description));
        PDMDocument."Description ENG" := CopyStr(GetText(SQLReader, 'DescrENG'), 1, MaxStrLen(PDMDocument."Description ENG"));
        PDMDocument."Description FRA" := CopyStr(GetText(SQLReader, 'DescrFRA'), 1, MaxStrLen(PDMDocument."Description FRA"));
        PDMDocument.Revision := CopyStr(GetText(SQLReader, 'Rev'), 1, MaxStrLen(PDMDocument.Revision));
        PDMDocument.Machine := CopyStr(GetText(SQLReader, 'Machine'), 1, MaxStrLen(PDMDocument.Machine));
        PDMDocument.Material := CopyStr(GetText(SQLReader, 'Material'), 1, MaxStrLen(PDMDocument.Material));
        PDMDocument.Weight := CopyStr(GetText(SQLReader, 'Weight'), 1, MaxStrLen(PDMDocument.Weight));
        PDMDocument.Modification := CopyStr(GetText(SQLReader, 'Modif'), 1, MaxStrLen(PDMDocument.Modification));
        PDMDocument."Approved Version" := GetInt(SQLReader, 'ApprovedVersion');
        PDMDocument."Approval Date" := ParseDateTime(GetText(SQLReader, 'ApprovedDate'));
        PDMDocument."Approval User" := CopyStr(GetText(SQLReader, 'ApprovedUser'), 1, MaxStrLen(PDMDocument."Approval User"));
        PDMDocument."Approved By" := CopyStr(GetText(SQLReader, 'ApprovedBy'), 1, MaxStrLen(PDMDocument."Approved By"));
        PDMDocument."Latest Version" := GetInt(SQLReader, 'LatestRevisionNo');
        PDMDocument."Current Status" := CopyStr(GetText(SQLReader, 'StatusName'), 1, MaxStrLen(PDMDocument."Current Status"));
        PDMDocument.Obsolete := GetInt(SQLReader, 'IsObsolete') = 1;
        // vuelto a diseño después de aprobado: en BC se sigue mostrando la versión aprobada
        PDMDocument."In Modification" := (GetInt(SQLReader, 'IsApprovedNow') = 0) and not PDMDocument.Obsolete;
        PDMDocument."Last Sync" := SyncTime;
        PDMDocument.Insert();
    end;

    local procedure SyncHistory(var SQLConnection: DotNet SqlConnection; Since: Text) NoHist: Integer
    var
        PDMDocument: Record "ZM PDM Document";
        PDMHistory: Record "ZM PDM History";
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        DocumentID: Integer;
        lblHistory: Label 'History', comment = 'ESP="Histórico"';
    begin
        UpdateWindow(1, lblHistory);
        SQLCommand := SQLConnection.CreateCommand();
        SQLCommand.CommandTimeout := 600;
        SQLCommand.CommandText := HistoryQuery(Since);
        SQLReader := SQLCommand.ExecuteReader();
        while SQLReader.Read() do begin
            DocumentID := GetInt(SQLReader, 'DocumentID');
            if PDMDocument."Document ID" <> DocumentID then
                if not PDMDocument.Get(DocumentID) then
                    Clear(PDMDocument);
            if PDMDocument."Document ID" = DocumentID then begin
                PDMHistory.Init();
                PDMHistory."Document ID" := DocumentID;
                PDMHistory."Entry Type" := GetInt(SQLReader, 'EntryType');
                PDMHistory."Entry No." := GetInt(SQLReader, 'EntryNo');
                PDMHistory.Version := GetInt(SQLReader, 'Version');
                PDMHistory."Date" := ParseDateTime(GetText(SQLReader, 'Date'));
                PDMHistory."User Name" := CopyStr(GetText(SQLReader, 'Username'), 1, MaxStrLen(PDMHistory."User Name"));
                PDMHistory.Transition := CopyStr(GetText(SQLReader, 'Transition'), 1, MaxStrLen(PDMHistory.Transition));
                PDMHistory."To Status" := CopyStr(GetText(SQLReader, 'ToStatus'), 1, MaxStrLen(PDMHistory."To Status"));
                PDMHistory.Approval := GetInt(SQLReader, 'IsApproval') = 1;
                PDMHistory.Comment := CopyStr(GetText(SQLReader, 'Comment'), 1, MaxStrLen(PDMHistory.Comment));
                PDMHistory."PDM Code" := CopyStr(GetText(SQLReader, 'Code'), 1, MaxStrLen(PDMHistory."PDM Code"));
                PDMHistory.Revision := CopyStr(GetText(SQLReader, 'Rev'), 1, MaxStrLen(PDMHistory.Revision));
                PDMHistory.Insert();
                // cada aprobación relaciona el código de esa versión con los productos de BC
                if PDMHistory.Approval then
                    AddItemLinks(PDMDocument, PDMHistory);
                NoHist += 1;
                if NoHist mod 1000 = 0 then
                    UpdateWindow(2, Format(NoHist));
            end;
        end;
        SQLReader.Close();
    end;

    // ======================================================================================================
    // ==  Relación producto <-> documento
    // ======================================================================================================
    local procedure AddItemLinks(PDMDocument: Record "ZM PDM Document"; PDMHistory: Record "ZM PDM History")
    var
        Item: Record Item;
        PDMCode: Text;
        BaseCode: Text;
    begin
        PDMCode := UpperCase(DelChr(PDMHistory."PDM Code", '<>', ' '));
        if PDMCode = '' then
            exit;
        if StrLen(PDMCode) <= MaxStrLen(Item."No.") then
            if Item.Get(PDMCode) then
                InsertItemLink(Item."No.", PDMDocument, PDMHistory, PDMCode);
        // variantes de color: el PDM usa "-X" (250502B-X -> 250502B-18, 250502B-15...)
        // (AL evalúa los dos lados del "and": la longitud se comprueba antes, en un if aparte)
        if StrLen(PDMCode) <= 2 then
            exit;
        if CopyStr(PDMCode, StrLen(PDMCode) - 1) = '-X' then begin
            BaseCode := CopyStr(PDMCode, 1, StrLen(PDMCode) - 1);  // incluye el guion
            if StrLen(BaseCode) < MaxStrLen(Item."No.") then begin
                Item.Reset();
                Item.SetRange("No.", BaseCode + '0', CopyStr(BaseCode + '99999999', 1, MaxStrLen(Item."No.")));
                if Item.FindSet() then
                    repeat
                        if IsDigits(CopyStr(Item."No.", StrLen(BaseCode) + 1)) then
                            InsertItemLink(Item."No.", PDMDocument, PDMHistory, PDMCode);
                    until Item.Next() = 0;
            end;
        end;
    end;

    local procedure AddCurrentLinks()
    var
        PDMDocument: Record "ZM PDM Document";
        TempPDMHistory: Record "ZM PDM History" temporary;
    begin
        // código vigente del documento con su versión actual (puede ser posterior a la última transición
        // de aprobación). Va después del histórico para que prevalezca sobre las aprobaciones anteriores.
        if TempSyncedDocument.FindSet() then
            repeat
                if PDMDocument.Get(TempSyncedDocument.Number) then begin
                    TempPDMHistory.Init();
                    TempPDMHistory."PDM Code" := PDMDocument."PDM Code";
                    TempPDMHistory.Version := PDMDocument."Approved Version";
                    TempPDMHistory.Revision := PDMDocument.Revision;
                    TempPDMHistory."Date" := PDMDocument."Approval Date";
                    TempPDMHistory."User Name" := PDMDocument."Approval User";
                    AddItemLinks(PDMDocument, TempPDMHistory);
                end;
            until TempSyncedDocument.Next() = 0;
    end;

    local procedure InsertItemLink(ItemNo: Code[20]; PDMDocument: Record "ZM PDM Document"; PDMHistory: Record "ZM PDM History"; PDMCode: Text)
    var
        PDMItemLink: Record "ZM PDM Item Link";
    begin
        // las aprobaciones llegan en orden: la última de un mismo producto/documento es la que queda
        if not PDMItemLink.Get(ItemNo, PDMDocument."Document ID") then begin
            PDMItemLink.Init();
            PDMItemLink."Item No." := ItemNo;
            PDMItemLink."Document ID" := PDMDocument."Document ID";
            PDMItemLink.Insert();
        end;
        PDMItemLink."PDM Code" := CopyStr(PDMHistory."PDM Code", 1, MaxStrLen(PDMItemLink."PDM Code"));
        PDMItemLink."Approved Version" := PDMHistory.Version;
        PDMItemLink.Revision := PDMHistory.Revision;
        PDMItemLink."Approval Date" := PDMHistory."Date";
        PDMItemLink."Approved By" := PDMHistory."User Name";
        PDMItemLink.Extension := PDMDocument.Extension;
        PDMItemLink.Current := PDMCode = UpperCase(DelChr(PDMDocument."PDM Code", '<>', ' '));
        PDMItemLink."In Modification" := PDMDocument."In Modification" and PDMItemLink.Current;
        PDMItemLink.Main := false;
        PDMItemLink.Modify();
        AddAffectedItem(ItemNo);
    end;

    local procedure AddAffectedItems(DocumentID: Integer)
    var
        PDMItemLink: Record "ZM PDM Item Link";
    begin
        PDMItemLink.SetCurrentKey("Document ID");
        PDMItemLink.SetRange("Document ID", DocumentID);
        if PDMItemLink.FindSet() then
            repeat
                AddAffectedItem(PDMItemLink."Item No.");
            until PDMItemLink.Next() = 0;
    end;

    local procedure AddAffectedItem(ItemNo: Code[20])
    begin
        if TempAffectedItem.Get(ItemNo) then
            exit;
        TempAffectedItem.Init();
        TempAffectedItem."No." := ItemNo;
        TempAffectedItem.Insert();
    end;

    local procedure UpdateMainLinks()
    var
        PDMItemLink: Record "ZM PDM Item Link";
        BestLink: Record "ZM PDM Item Link";
        lblItems: Label 'Items', comment = 'ESP="Productos"';
        Cont: Integer;
    begin
        // documento principal de cada producto: vigente antes que sustituido, plano > ensamblaje > pieza > resto,
        // y a igualdad, el de aprobación más reciente
        UpdateWindow(1, lblItems);
        TempAffectedItem.Reset();
        if TempAffectedItem.FindSet() then
            repeat
                Cont += 1;
                if Cont mod 200 = 0 then
                    UpdateWindow(2, Format(Cont));
                Clear(BestLink);
                PDMItemLink.Reset();
                PDMItemLink.SetRange("Item No.", TempAffectedItem."No.");
                PDMItemLink.ModifyAll(Main, false);
                if PDMItemLink.FindSet() then
                    repeat
                        if (BestLink."Item No." = '') or IsBetterLink(PDMItemLink, BestLink) then
                            BestLink := PDMItemLink;
                    until PDMItemLink.Next() = 0;
                if BestLink."Item No." <> '' then begin
                    BestLink.Main := true;
                    BestLink.Modify();
                end;
            until TempAffectedItem.Next() = 0;
    end;

    local procedure IsBetterLink(PDMItemLink: Record "ZM PDM Item Link"; BestLink: Record "ZM PDM Item Link"): Boolean
    begin
        if PDMItemLink.Current <> BestLink.Current then
            exit(PDMItemLink.Current);
        if ExtensionPriority(PDMItemLink.Extension) <> ExtensionPriority(BestLink.Extension) then
            exit(ExtensionPriority(PDMItemLink.Extension) < ExtensionPriority(BestLink.Extension));
        exit(PDMItemLink."Approval Date" > BestLink."Approval Date");
    end;

    local procedure ExtensionPriority(Extension: Text): Integer
    begin
        case LowerCase(Extension) of
            'slddrw':
                exit(1);
            'sldasm':
                exit(2);
            'sldprt':
                exit(3);
            'pdf':
                exit(4);
        end;
        exit(9);
    end;

    local procedure IsDigits(Value: Text): Boolean
    begin
        exit((Value <> '') and (DelChr(Value, '=', '0123456789') = ''));
    end;

    // ======================================================================================================
    // ==  Consultas SQL al PDM
    // ======================================================================================================
    local procedure CandidatesCTE(Since: Text) SQL: Text
    begin
        // documentos a tratar: todos (recarga completa) o los que han cambiado desde la última sincronización
        SQL := 'SET NOCOUNT ON; DECLARE @desde datetime = ' + Since + '; ';
        SQL += 'WITH ap AS (SELECT StatusID FROM Status WHERE Name IN (' + ApprovedStatusTok + ')), ';
        SQL += 'cand AS (SELECT DocumentID FROM Documents WHERE @desde IS NULL ';
        SQL += ' UNION SELECT DocumentID FROM TransitionHistory WHERE Date >= @desde ';
        SQL += ' UNION SELECT DocumentID FROM Revisions WHERE Date >= @desde ';
        SQL += ' UNION SELECT DocumentID FROM HistoryDelete WHERE Time >= @desde ';
        SQL += ' UNION SELECT DocumentId FROM HistoryMove WHERE Time >= @desde ';
        SQL += ' UNION SELECT DocumentId FROM HistoryRename WHERE Time >= @desde) ';
    end;

    local procedure DocumentsQuery(Since: Text) SQL: Text
    begin
        // datos de la versión de la última aprobación de cada documento
        SQL := CandidatesCTE(Since);
        SQL += ', vars AS (SELECT VariableID, VariableName FROM Variable WHERE VariableName IN (N''CodigodeProducto'',N''DescripcionProducto'',';
        SQL += 'N''DescripcionProductoIngles'',N''DescripcionProductoFrances'',N''Revision'',N''Maquina'',N''Material'',N''Weight'',N''Modificacion'',N''AprobadoPor'')) ';
        SQL += 'SELECT d.DocumentID, CAST(d.Deleted AS int) Deleted, d.Filename, e.Extension, ISNULL(p.Path, N'''') Folder, ISNULL(s.Name, N'''') StatusName, ';
        SQL += 'CASE WHEN d.CurrentStatusID IN (SELECT StatusID FROM ap) THEN 1 ELSE 0 END IsApprovedNow, ';
        SQL += 'CASE WHEN s.Name LIKE N''Obsoleto%'' THEN 1 ELSE 0 END IsObsolete, ';
        SQL += 'd.LatestRevisionNo, av.Ver ApprovedVersion, CONVERT(varchar(19), av.Date, 120) ApprovedDate, av.Username ApprovedUser, ';
        SQL += 'v.Code, v.Descr, v.DescrENG, v.DescrFRA, v.Rev, v.Machine, v.Material, v.Weight, v.Modif, v.ApprovedBy ';
        SQL += 'FROM cand c JOIN Documents d ON d.DocumentID = c.DocumentID ';
        SQL += 'JOIN FileExtension e ON e.ExtensionID = d.ExtensionID ';
        SQL += 'LEFT JOIN Status s ON s.StatusID = d.CurrentStatusID ';
        SQL += 'OUTER APPLY (SELECT TOP 1 pr.Path FROM DocumentsInProjects dp JOIN Projects pr ON pr.ProjectID = dp.ProjectID ';
        SQL += ' WHERE dp.DocumentID = d.DocumentID AND dp.Deleted = 0 AND pr.Deleted = 0 ORDER BY dp.ProjectID) p ';
        SQL += 'OUTER APPLY (SELECT TOP 1 th.RevNr, th.Date, u.Username FROM TransitionHistory th JOIN Transitions t ON t.TransitionID = th.TransitionID ';
        SQL += ' LEFT JOIN Users u ON u.UserID = th.UserID WHERE th.DocumentID = d.DocumentID AND t.Destination IN (SELECT StatusID FROM ap) ';
        SQL += ' ORDER BY th.TransitionNr DESC) a ';
        // si sigue aprobado/publicado, la vigente es la última versión: el Task Add-in del PDM regenera
        // PDF/DXF/X_T sin transición. Si está en modificación, la de la última aprobación.
        SQL += 'OUTER APPLY (SELECT TOP 1 r.RevNr Ver, r.Date, u.Username FROM Revisions r LEFT JOIN Users u ON u.UserID = r.UserID ';
        SQL += ' WHERE r.DocumentID = d.DocumentID AND d.CurrentStatusID IN (SELECT StatusID FROM ap) AND r.RevNr > a.RevNr ';
        SQL += ' ORDER BY r.RevNr DESC) lv ';
        SQL += 'OUTER APPLY (SELECT ISNULL(lv.Ver, a.RevNr) Ver, CASE WHEN lv.Ver IS NULL THEN a.Date ELSE lv.Date END Date, ';
        SQL += ' CASE WHEN lv.Ver IS NULL THEN a.Username ELSE lv.Username END Username) av ';
        SQL += 'OUTER APPLY (SELECT ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''CodigodeProducto'' THEN x.Val END) Code, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''DescripcionProducto'' THEN x.Val END) Descr, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''DescripcionProductoIngles'' THEN x.Val END) DescrENG, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''DescripcionProductoFrances'' THEN x.Val END) DescrFRA, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''Revision'' THEN x.Val END) Rev, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''Maquina'' THEN x.Val END) Machine, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''Material'' THEN x.Val END) Material, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''Weight'' THEN x.Val END) Weight, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''Modificacion'' THEN x.Val END) Modif, ';
        SQL += ' MAX(CASE WHEN x.VariableName = N''AprobadoPor'' THEN x.Val END) ApprovedBy ';
        SQL += ' FROM (SELECT vr.VariableName, LTRIM(RTRIM(COALESCE(NULLIF(vv.ValueText, N''''), vv.ValueCache))) Val, ';
        SQL += '  ROW_NUMBER() OVER (PARTITION BY vv.VariableID ORDER BY vv.RevisionNo DESC, CASE vv.ConfigurationID WHEN 2 THEN 0 WHEN 1 THEN 1 ELSE 2 END) rn ';
        SQL += '  FROM VariableValue vv JOIN vars vr ON vr.VariableID = vv.VariableID ';
        SQL += '  WHERE vv.DocumentID = d.DocumentID AND vv.RevisionNo <= av.Ver) x WHERE x.rn = 1) v ';
        SQL += 'WHERE (a.RevNr IS NOT NULL AND d.Deleted = 0) OR @desde IS NOT NULL ';
        SQL += 'ORDER BY d.DocumentID';
    end;

    local procedure HistoryQuery(Since: Text) SQL: Text
    begin
        // versiones y transiciones de los documentos aprobados, con el código y la revisión de cada versión
        SQL := CandidatesCTE(Since);
        SQL += ', apd AS (SELECT DISTINCT th.DocumentID FROM TransitionHistory th JOIN Transitions t ON t.TransitionID = th.TransitionID ';
        SQL += ' JOIN cand c ON c.DocumentID = th.DocumentID JOIN Documents d ON d.DocumentID = th.DocumentID AND d.Deleted = 0 ';
        SQL += ' WHERE t.Destination IN (SELECT StatusID FROM ap)), ';
        SQL += 'cv AS (SELECT VariableID FROM Variable WHERE VariableName = N''CodigodeProducto''), ';
        SQL += 'rv AS (SELECT VariableID FROM Variable WHERE VariableName = N''Revision''), ';
        SQL += 'h AS (SELECT r.DocumentID, 0 EntryType, r.RevNr EntryNo, r.RevNr Version, r.Date, u.Username, ';
        SQL += ' CAST(N'''' AS nvarchar(255)) Transition, CAST(N'''' AS nvarchar(255)) ToStatus, 0 IsApproval, CAST(r.Comment AS nvarchar(250)) Comment ';
        SQL += ' FROM Revisions r JOIN apd ON apd.DocumentID = r.DocumentID LEFT JOIN Users u ON u.UserID = r.UserID ';
        SQL += ' UNION ALL ';
        SQL += ' SELECT th.DocumentID, 1, th.TransitionNr, th.RevNr, th.Date, u.Username, t.Name, ISNULL(s.Name, N''''), ';
        SQL += ' CASE WHEN t.Destination IN (SELECT StatusID FROM ap) THEN 1 ELSE 0 END, CAST(th.Comment AS nvarchar(250)) ';
        SQL += ' FROM TransitionHistory th JOIN apd ON apd.DocumentID = th.DocumentID JOIN Transitions t ON t.TransitionID = th.TransitionID ';
        SQL += ' LEFT JOIN Status s ON s.StatusID = t.Destination LEFT JOIN Users u ON u.UserID = th.UserID) ';
        SQL += 'SELECT h.DocumentID, h.EntryType, h.EntryNo, h.Version, CONVERT(varchar(19), h.Date, 120) Date, h.Username, h.Transition, h.ToStatus, ';
        SQL += 'h.IsApproval, h.Comment, ';
        SQL += '(SELECT TOP 1 LTRIM(RTRIM(vv.ValueCache)) FROM VariableValue vv WHERE vv.VariableID = (SELECT VariableID FROM cv) ';
        SQL += ' AND vv.DocumentID = h.DocumentID AND vv.RevisionNo <= h.Version ';
        SQL += ' ORDER BY vv.RevisionNo DESC, CASE vv.ConfigurationID WHEN 2 THEN 0 WHEN 1 THEN 1 ELSE 2 END) Code, ';
        SQL += '(SELECT TOP 1 LTRIM(RTRIM(vv.ValueCache)) FROM VariableValue vv WHERE vv.VariableID = (SELECT VariableID FROM rv) ';
        SQL += ' AND vv.DocumentID = h.DocumentID AND vv.RevisionNo <= h.Version ';
        SQL += ' ORDER BY vv.RevisionNo DESC, CASE vv.ConfigurationID WHEN 2 THEN 0 WHEN 1 THEN 1 ELSE 2 END) Rev ';
        SQL += 'FROM h ORDER BY h.DocumentID, h.EntryType, h.EntryNo';
    end;

    local procedure GetServerTime(var SQLConnection: DotNet SqlConnection) ServerTime: Text
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
    begin
        SQLCommand := SQLConnection.CreateCommand();
        SQLCommand.CommandText := 'SELECT CONVERT(varchar(19), GETDATE(), 120) T';
        SQLReader := SQLCommand.ExecuteReader();
        if SQLReader.Read() then
            ServerTime := GetText(SQLReader, 'T');
        SQLReader.Close();
    end;

    // ======================================================================================================
    // ==  Conexión
    // ======================================================================================================
    local procedure CheckSetup()
    begin
        InventorySetup.TestField("PDM SQL Server");
        InventorySetup.TestField("PDM SQL Database");
    end;

    local procedure SQLConnect(var SQLConnection: DotNet SqlConnection)
    var
        ConnStr: Text;
        Password: Text;
    begin
        // sin usuario: seguridad integrada con la cuenta del servicio de BC
        ConnStr := StrSubstNo('Data Source=%1;Initial Catalog=%2;Application Name=BC PDM Sync;Connect Timeout=30;',
            InventorySetup."PDM SQL Server", InventorySetup."PDM SQL Database");
        if InventorySetup."PDM SQL User" = '' then
            ConnStr += 'Integrated Security=SSPI;'
        else begin
            if IsolatedStorage.Contains(PasswordKeyTok, DataScope::Company) then
                IsolatedStorage.Get(PasswordKeyTok, DataScope::Company, Password);
            ConnStr += StrSubstNo('User Id=%1;Password=%2;', InventorySetup."PDM SQL User", Password);
        end;
        SQLConnection := SQLConnection.SqlConnection(ConnStr);
        SQLConnection.Open();
    end;

    procedure SetPassword(NewPassword: Text)
    begin
        if NewPassword = '' then begin
            if IsolatedStorage.Contains(PasswordKeyTok, DataScope::Company) then
                IsolatedStorage.Delete(PasswordKeyTok, DataScope::Company);
        end else
            IsolatedStorage.Set(PasswordKeyTok, NewPassword, DataScope::Company);
    end;

    procedure HasPassword(): Boolean
    begin
        exit(IsolatedStorage.Contains(PasswordKeyTok, DataScope::Company));
    end;

    procedure TestConnection()
    var
        SQLConnection: DotNet SqlConnection;
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        NoDocs: Integer;
        PathOK: Boolean;
        lblOK: Label 'Connection to the PDM is correct.\Documents in the PDM: %1\Vault path accessible: %2', comment = 'ESP="Conexión con el PDM correcta.\Documentos en el PDM: %1\Ruta del almacén accesible: %2"';
    begin
        InventorySetup.Get();
        CheckSetup();
        SQLConnect(SQLConnection);
        SQLCommand := SQLConnection.CreateCommand();
        SQLCommand.CommandText := 'SELECT COUNT(*) N FROM Documents WHERE Deleted = 0';
        SQLReader := SQLCommand.ExecuteReader();
        if SQLReader.Read() then
            NoDocs := GetInt(SQLReader, 'N');
        SQLReader.Close();
        SQLConnection.Close();
        if InventorySetup."PDM Vault Path" <> '' then
            PathOK := FileMgt.ServerDirectoryExists(InventorySetup."PDM Vault Path");
        Message(lblOK, NoDocs, PathOK);
    end;

    local procedure GetText(var SQLReader: DotNet SqlDataReader; FieldName: Text): Text
    var
        Index: Integer;
    begin
        Index := SQLReader.GetOrdinal(FieldName);
        if SQLReader.IsDBNull(Index) then
            exit('');
        exit(SQLReader.GetString(Index));
    end;

    local procedure GetInt(var SQLReader: DotNet SqlDataReader; FieldName: Text): Integer
    var
        Index: Integer;
    begin
        Index := SQLReader.GetOrdinal(FieldName);
        if SQLReader.IsDBNull(Index) then
            exit(0);
        exit(SQLReader.GetInt32(Index));
    end;

    local procedure ParseDateTime(Value: Text): DateTime
    var
        Year: Integer;
        Month: Integer;
        Day: Integer;
        Hour: Integer;
        Minute: Integer;
        Second: Integer;
    begin
        // formato 120 de SQL: aaaa-mm-dd hh:mi:ss (independiente del idioma del servicio)
        if StrLen(Value) < 19 then
            exit(0DT);
        Evaluate(Year, CopyStr(Value, 1, 4));
        Evaluate(Month, CopyStr(Value, 6, 2));
        Evaluate(Day, CopyStr(Value, 9, 2));
        Evaluate(Hour, CopyStr(Value, 12, 2));
        Evaluate(Minute, CopyStr(Value, 15, 2));
        Evaluate(Second, CopyStr(Value, 18, 2));
        exit(CreateDateTime(DMY2Date(Day, Month, Year), 000000T + ((Hour * 3600 + Minute * 60 + Second) * 1000)));
    end;

    local procedure UpdateWindow(Number: Integer; Value: Text)
    begin
        if GuiAllowed() then
            Window.Update(Number, Value);
    end;

    // ======================================================================================================
    // ==  Ficheros del almacén
    // ======================================================================================================
    procedure GetVaultFilePath(PDMDocument: Record "ZM PDM Document"; Version: Integer): Text
    var
        HexID: Text;
    begin
        // <almacén>\<último dígito hex del ID>\<ID hex 8>\<versión hex 8>.<extensión>
        InventorySetup.Get();
        InventorySetup.TestField("PDM Vault Path");
        HexID := IntToHex(PDMDocument."Document ID");
        exit(DelChr(InventorySetup."PDM Vault Path", '>', '\') + '\' + CopyStr(HexID, 8, 1) + '\' + HexID + '\' +
            IntToHex(Version) + '.' + PDMDocument.Extension);
    end;

    local procedure IntToHex(Value: Integer) Hex: Text
    var
        HexDigitsTok: Label '0123456789abcdef', Locked = true;
        i: Integer;
    begin
        for i := 1 to 8 do begin
            Hex := CopyStr(HexDigitsTok, (Value mod 16) + 1, 1) + Hex;
            Value := Value div 16;
        end;
    end;

    procedure OpenDocumentFile(PDMDocument: Record "ZM PDM Document")
    begin
        // versión aprobada (en BC nunca se muestra una versión en diseño)
        OpenVaultFile(PDMDocument, PDMDocument."Approved Version", PDMDocument.Revision);
    end;

    procedure OpenHistoryFile(PDMHistory: Record "ZM PDM History")
    var
        PDMDocument: Record "ZM PDM Document";
        lblNotApproval: Label 'Only versions that were approved can be opened.', comment = 'ESP="Solo se pueden abrir las versiones que fueron aprobadas."';
    begin
        if not PDMHistory.Approval then
            Error(lblNotApproval);
        PDMDocument.Get(PDMHistory."Document ID");
        OpenVaultFile(PDMDocument, PDMHistory.Version, PDMHistory.Revision);
    end;

    local procedure OpenVaultFile(PDMDocument: Record "ZM PDM Document"; Version: Integer; Revision: Text)
    var
        ServerFile: Text;
        ClientFileName: Text;
        ClientFile: Text;
        lblNotFound: Label 'File %1 (version %2) not found in the PDM vault:\%3', comment = 'ESP="No se encuentra el fichero %1 (versión %2) en el almacén del PDM:\%3"';
        FileVersion: Integer;
    begin
        // las versiones en las que solo cambian datos de la ficha no tienen fichero propio en el almacén:
        // el contenido es el de la versión anterior más cercana que sí lo tiene
        FileVersion := Version;
        ServerFile := GetVaultFilePath(PDMDocument, FileVersion);
        while (FileVersion > 1) and not FileMgt.ServerFileExists(ServerFile) do begin
            FileVersion -= 1;
            ServerFile := GetVaultFilePath(PDMDocument, FileVersion);
        end;
        if not FileMgt.ServerFileExists(ServerFile) then
            Error(lblNotFound, PDMDocument."File Name", Version, GetVaultFilePath(PDMDocument, Version));
        ClientFileName := GetClientFileName(PDMDocument, Revision);
        if FileMgt.IsWindowsClient() then begin
            // carpeta temporal nueva: el fichero puede seguir abierto de una consulta anterior
            ClientFile := FileMgt.CreateClientTempSubDirectory() + '\' + ClientFileName;
            FileMgt.DownloadToFile(ServerFile, ClientFile);
            Hyperlink(ClientFile);
        end else
            FileMgt.DownloadHandler(ServerFile, '', '', '', ClientFileName);
    end;

    local procedure GetClientFileName(PDMDocument: Record "ZM PDM Document"; Revision: Text) FileName: Text
    begin
        // 260525B.pdf -> "260525B rev05.pdf"
        FileName := FileMgt.GetFileNameWithoutExtension(PDMDocument."File Name");
        if Revision <> '' then
            FileName += ' rev' + Revision;
        FileName := FileMgt.GetSafeFileName(FileName + '.' + PDMDocument.Extension);
    end;

    // ======================================================================================================
    // ==  Navegación desde el producto
    // ======================================================================================================
    procedure ShowItemDocuments(ItemNo: Code[20])
    var
        PDMDocument: Record "ZM PDM Document";
    begin
        PDMDocument.SetFilter("Document ID", GetItemDocumentFilter(ItemNo));
        Page.Run(Page::"ZM PDM Documents", PDMDocument);
    end;

    procedure ShowItemHistory(ItemNo: Code[20])
    var
        PDMHistory: Record "ZM PDM History";
    begin
        PDMHistory.SetCurrentKey("Date");
        PDMHistory.Ascending(false);
        PDMHistory.SetFilter("Document ID", GetItemDocumentFilter(ItemNo));
        Page.Run(Page::"ZM PDM History", PDMHistory);
    end;

    procedure OpenItemPDF(ItemNo: Code[20])
    var
        PDMItemLink: Record "ZM PDM Item Link";
        BestLink: Record "ZM PDM Item Link";
        PDMDocument: Record "ZM PDM Document";
        lblNoPDF: Label 'There is no approved PDF in the PDM for item %1.', comment = 'ESP="No hay ningún PDF aprobado en el PDM para el producto %1."';
        lblNoPDFReplaced: Label 'Item %1 has no approved PDF (replaced by %2).', comment = 'ESP="El producto %1 no tiene PDF aprobado (sustituido por %2)."';
    begin
        // PDF publicado del código vigente (si no hay, el más reciente)
        PDMItemLink.SetRange("Item No.", ItemNo);
        PDMItemLink.SetRange(Extension, 'pdf');
        if PDMItemLink.FindSet() then
            repeat
                if (BestLink."Item No." = '') or IsBetterLink(PDMItemLink, BestLink) then
                    BestLink := PDMItemLink;
            until PDMItemLink.Next() = 0;
        if BestLink."Item No." = '' then begin
            // producto sustituido: se indica el código vigente del plano
            PDMItemLink.SetRange(Extension);
            PDMItemLink.SetRange(Main, true);
            if PDMItemLink.FindFirst() and not PDMItemLink.Current then
                if PDMDocument.Get(PDMItemLink."Document ID") then
                    Error(lblNoPDFReplaced, ItemNo, PDMDocument."PDM Code");
            Error(lblNoPDF, ItemNo);
        end;
        PDMDocument.Get(BestLink."Document ID");
        OpenDocumentFile(PDMDocument);
    end;

    procedure ShowDocumentItems(PDMDocument: Record "ZM PDM Document")
    var
        Item: Record Item;
        PDMItemLink: Record "ZM PDM Item Link";
    begin
        PDMItemLink.SetCurrentKey("Document ID");
        PDMItemLink.SetRange("Document ID", PDMDocument."Document ID");
        if PDMItemLink.FindSet() then
            repeat
                if Item.Get(PDMItemLink."Item No.") then
                    Item.Mark(true);
            until PDMItemLink.Next() = 0;
        Item.MarkedOnly(true);
        Page.Run(Page::"Item List", Item);
    end;

    local procedure GetItemDocumentFilter(ItemNo: Code[20]) DocFilter: Text
    var
        PDMItemLink: Record "ZM PDM Item Link";
    begin
        PDMItemLink.SetRange("Item No.", ItemNo);
        if PDMItemLink.FindSet() then
            repeat
                if DocFilter <> '' then
                    DocFilter += '|';
                DocFilter += Format(PDMItemLink."Document ID");
            until PDMItemLink.Next() = 0;
        // sin documentos: filtro que no devuelve nada
        if DocFilter = '' then
            DocFilter := '-1';
    end;

    // ======================================================================================================
    // ==  Solicitud de alta de producto (fase 2)
    // ==  - la solicitud se relaciona con el plano por código (o por ID desde la API)
    // ==  - planos aprobados: se rellenan los datos vacíos de la solicitud
    // ==  - planos sin aprobar (consulta directa al PDM): solo se informa el estado y se avisa al lanzar
    // ======================================================================================================
    procedure LinkRequest(var Request: Record "ZM PL Items Temporary"; LiveSearch: Boolean)
    var
        PDMDocument: Record "ZM PDM Document";
        TempPDMDocument: Record "ZM PDM Document" temporary;
    begin
        LiveSearchFailed := false;
        LiveFileName := '';
        LiveStatus := '';
        if Request."Item No." = '' then begin
            if LiveSearch then
                ClearRequestLink(Request);
            exit;
        end;
        if FindApprovedDocument(Request."Item No.", '', PDMDocument) then begin
            SetRequestLink(Request, PDMDocument);
            exit;
        end;
        if not LiveSearch then
            exit;
        if SearchPDM(GetCodeFilter(Request."Item No."), '', 0, TempPDMDocument) then
            if TempPDMDocument.FindFirst() then begin
                SetRequestPending(Request, TempPDMDocument, GetBestDocumentID(TempPDMDocument));
                exit;
            end;
        ClearRequestLink(Request);
    end;

    procedure ValidateRequestDocument(var Request: Record "ZM PL Items Temporary")
    var
        PDMDocument: Record "ZM PDM Document";
        TempPDMDocument: Record "ZM PDM Document" temporary;
        DocumentID: Integer;
        lblNotFound: Label 'Document %1 does not exist in the PDM.', comment = 'ESP="El documento %1 no existe en el PDM."';
    begin
        if Request."PDM Document ID" = 0 then begin
            ClearRequestLink(Request);
            exit;
        end;
        if PDMDocument.Get(Request."PDM Document ID") then begin
            SetRequestLink(Request, PDMDocument);
            exit;
        end;
        if SearchPDM('', '', Request."PDM Document ID", TempPDMDocument) then
            if TempPDMDocument.FindFirst() then begin
                DocumentID := TempPDMDocument."Document ID";
                // resto de documentos del mismo código (la pieza tiene material y peso)
                if TempPDMDocument."PDM Code" <> '' then
                    if not SearchPDM(GetCodeFilter(TempPDMDocument."PDM Code"), '', 0, TempPDMDocument) or not TempPDMDocument.Get(DocumentID) then
                        if SearchPDM('', '', DocumentID, TempPDMDocument) then;
                SetRequestPending(Request, TempPDMDocument, DocumentID);
                exit;
            end;
        if LiveSearchFailed then
            exit;  // sin conexión: se guarda el ID y se resolverá en la sincronización
        Error(lblNotFound, Request."PDM Document ID");
    end;

    procedure LookupRequestDocument(var Request: Record "ZM PL Items Temporary")
    var
        PDMSearch: Page "ZM PDM Search";
        SearchText: Text;
    begin
        SearchText := Request."Item No.";
        if Request."PDM Code" <> '' then
            SearchText := Request."PDM Code";
        PDMSearch.SetSearchText(SearchText);
        PDMSearch.LookupMode(true);
        if PDMSearch.RunModal() = Action::LookupOK then
            Request.Validate("PDM Document ID", PDMSearch.GetSelectedDocumentID());
    end;

    procedure FillRequestFromPDM(var Request: Record "ZM PL Items Temporary")
    var
        lblNotFound: Label 'No drawing has been found in the PDM for %1.', comment = 'ESP="No se ha encontrado ningún plano en el PDM para %1."';
        lblDone: Label 'PDM data updated (only the empty fields are filled in). Drawing status: %1.', comment = 'ESP="Datos del PDM actualizados (solo se rellenan los campos vacíos). Estado del plano: %1."';
    begin
        LinkRequest(Request, true);
        Request.Modify();
        if Request."PDM Status" = Request."PDM Status"::" " then
            Message(lblNotFound, Request."Item No.")
        else
            Message(lblDone, Request."PDM Status");
    end;

    procedure CheckRequestBeforeLaunch(var Request: Record "ZM PL Items Temporary"): Boolean
    var
        lblPending: Label 'The drawing %1 (%2) is in status ''%3'' in the PDM and has not been approved yet.\Do you want to continue?', comment = 'ESP="El plano %1 (%2) está en estado ''%3'' en el PDM y todavía no está aprobado.\¿Desea continuar?"';
        lblInModification: Label 'The drawing %1 is being modified in the PDM (approved revision: %2).\Do you want to continue?', comment = 'ESP="El plano %1 se está modificando en el PDM (revisión aprobada: %2).\¿Desea continuar?"';
        lblNoConnection: Label 'The PDM could not be checked. The request continues without checking the drawing.', comment = 'ESP="No se ha podido consultar el PDM. La solicitud continúa sin comprobar el plano."';
    begin
        // estado al día justo antes de lanzar; solo avisa, nunca bloquea
        LinkRequest(Request, true);
        if Request.Modify() then;
        if not GuiAllowed() then
            exit(true);
        if LiveSearchFailed then
            Message(lblNoConnection);
        case Request."PDM Status" of
            Request."PDM Status"::"Pending Approval":
                exit(Confirm(lblPending, false, LiveFileName, Request."PDM Code", LiveStatus));
            Request."PDM Status"::"In Modification":
                exit(Confirm(lblInModification, false, Request."PDM Code", Request."PDM Revision"));
        end;
        exit(true);
    end;

    procedure OpenRequestPDF(Request: Record "ZM PL Items Temporary")
    var
        PDMDocument: Record "ZM PDM Document";
        lblNoPDF: Label 'There is no approved PDF in the PDM for %1.', comment = 'ESP="No hay ningún PDF aprobado en el PDM para %1."';
    begin
        if Request."Item No." <> '' then
            if FindApprovedDocument(Request."Item No.", 'pdf', PDMDocument) then begin
                OpenDocumentFile(PDMDocument);
                exit;
            end;
        Error(lblNoPDF, Request."Item No.");
    end;

    procedure OpenCodePDF(PDMCode: Text)
    var
        PDMDocument: Record "ZM PDM Document";
        lblNoPDF: Label 'There is no approved PDF in the PDM for %1.', comment = 'ESP="No hay ningún PDF aprobado en el PDM para %1."';
    begin
        if PDMCode <> '' then
            if FindApprovedDocument(PDMCode, 'pdf', PDMDocument) then begin
                OpenDocumentFile(PDMDocument);
                exit;
            end;
        Error(lblNoPDF, PDMCode);
    end;

    procedure ShowRequestHistory(Request: Record "ZM PL Items Temporary")
    var
        PDMHistory: Record "ZM PDM History";
    begin
        Request.TestField("PDM Document ID");
        PDMHistory.SetCurrentKey("Date");
        PDMHistory.Ascending(false);
        PDMHistory.SetRange("Document ID", Request."PDM Document ID");
        Page.Run(Page::"ZM PDM History", PDMHistory);
    end;

    local procedure SetRequestLink(var Request: Record "ZM PL Items Temporary"; PDMDocument: Record "ZM PDM Document")
    var
        PartDocument: Record "ZM PDM Document";
    begin
        Request."PDM Document ID" := PDMDocument."Document ID";
        Request."PDM Code" := PDMDocument."PDM Code";
        Request."PDM Revision" := PDMDocument.Revision;
        Request."PDM Approval Date" := PDMDocument."Approval Date";
        if PDMDocument."In Modification" then
            Request."PDM Status" := Request."PDM Status"::"In Modification"
        else
            Request."PDM Status" := Request."PDM Status"::Approved;
        FillRequestFromDocument(Request, PDMDocument, PartDocument, FindApprovedDocument(PDMDocument."PDM Code", 'sldprt', PartDocument));
    end;

    local procedure SetRequestPending(var Request: Record "ZM PL Items Temporary"; var TempPDMDocument: Record "ZM PDM Document" temporary; DocumentID: Integer)
    var
        TempPartDocument: Record "ZM PDM Document" temporary;
    begin
        // plano aún no aprobado: datos de su última versión (al aprobarse se revisan otra vez los campos vacíos)
        TempPartDocument.Copy(TempPDMDocument, true);
        TempPartDocument.SetRange(Extension, 'sldprt');
        TempPDMDocument.Get(DocumentID);
        Request."PDM Document ID" := TempPDMDocument."Document ID";
        Request."PDM Code" := TempPDMDocument."PDM Code";
        Request."PDM Revision" := TempPDMDocument.Revision;
        Request."PDM Approval Date" := 0DT;
        Request."PDM Status" := Request."PDM Status"::"Pending Approval";
        LiveFileName := TempPDMDocument."File Name";
        LiveStatus := TempPDMDocument."Current Status";
        FillRequestFromDocument(Request, TempPDMDocument, TempPartDocument, TempPartDocument.FindFirst());
    end;

    local procedure ClearRequestLink(var Request: Record "ZM PL Items Temporary")
    begin
        Request."PDM Document ID" := 0;
        Request."PDM Code" := '';
        Request."PDM Revision" := '';
        Request."PDM Approval Date" := 0DT;
        Request."PDM Status" := Request."PDM Status"::" ";
    end;

    local procedure FillRequestFromDocument(var Request: Record "ZM PL Items Temporary"; PDMDocument: Record "ZM PDM Document"; PartDocument: Record "ZM PDM Document"; HasPart: Boolean)
    var
        Weight: Decimal;
        ReplacesItemNo: Code[20];
    begin
        // solo campos vacíos: nunca se sobrescribe lo que haya puesto el usuario
        if (Request.Description = '') and (PDMDocument.Description <> '') then
            Request.Description := CopyStr(PDMDocument.Description, 1, MaxStrLen(Request.Description));
        if Request."No." <> '' then begin
            SetRequestTranslation(Request."No.", 'ENG', PDMDocument."Description ENG");
            SetRequestTranslation(Request."No.", 'FRA', PDMDocument."Description FRA");
        end;
        Request.CalcFields(Reason);
        if (not Request.Reason.HasValue()) and (PDMDocument.Modification <> '') then
            SetRequestReason(Request, PDMDocument.Modification);
        // material y peso están en la pieza (en el plano vienen vacíos)
        if HasPart then begin
            if (Request.Material = '') and IsValidPDMValue(PartDocument.Material) then
                Request.Material := CopyStr(PartDocument.Material, 1, MaxStrLen(Request.Material));
            if IsValidPDMValue(PartDocument.Weight) then
                if Evaluate(Weight, PartDocument.Weight, 9) then
                    if Weight > 0 then begin
                        // el PDM guarda la masa de SolidWorks en gramos; en BC el peso va en kg
                        Weight := Round(Weight / 1000, 0.00001);
                        if Request."Net Weight" = 0 then
                            Request."Net Weight" := Weight;
                        if Request."Gross Weight" = 0 then
                            Request."Gross Weight" := Weight;
                    end;
        end;
        if (Request."Replaces Item No." = '') and (Request."Request Type" = Request."Request Type"::New) then begin
            ReplacesItemNo := GetPreviousItemNo(PDMDocument, Request."Item No.");
            if ReplacesItemNo <> '' then
                Request."Replaces Item No." := ReplacesItemNo;
        end;
    end;

    local procedure SetRequestTranslation(RequestNo: Code[20]; LanguageCode: Code[10]; TranslatedText: Text)
    var
        ItemTranslationTemporary: Record "ZM Item Translation temporary";
    begin
        if TranslatedText = '' then
            exit;
        if not ItemTranslationTemporary.Get(RequestNo, '', LanguageCode) then begin
            ItemTranslationTemporary.Init();
            ItemTranslationTemporary."Item No." := RequestNo;
            ItemTranslationTemporary."Language Code" := LanguageCode;
            ItemTranslationTemporary.Insert();
        end;
        if ItemTranslationTemporary.Description <> '' then
            exit;
        ItemTranslationTemporary.Description := CopyStr(TranslatedText, 1, MaxStrLen(ItemTranslationTemporary.Description));
        ItemTranslationTemporary.Modify();
    end;

    local procedure SetRequestReason(var Request: Record "ZM PL Items Temporary"; ReasonText: Text)
    var
        TempBlob: Record TempBlob;
    begin
        // sin Modify: la solicitud puede no estar insertada todavía (alta desde la página o la API)
        TempBlob.WriteAsText(ReasonText, TextEncoding::UTF8);
        Request.Reason := TempBlob.Blob;
    end;

    local procedure IsValidPDMValue(Value: Text): Boolean
    begin
        // descarta valores vacíos, fórmulas de SolidWorks ("SW-Masa@...") y "Material <sin especificar>"
        if Value = '' then
            exit(false);
        if (StrPos(Value, '"') > 0) or (StrPos(Value, '@') > 0) or (StrPos(Value, '<') > 0) then
            exit(false);
        exit(true);
    end;

    local procedure GetPreviousItemNo(PDMDocument: Record "ZM PDM Document"; ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
        PDMHistory: Record "ZM PDM History";
        CurrentCode: Text;
        PreviousCode: Text;
        Candidate: Text;
    begin
        // código aprobado anterior del mismo plano que exista como producto: 260525B -> 260525A
        // con colores se mantiene el sufijo: 250510B-18 (plano 250510B-X) -> 250510A-18
        CurrentCode := UpperCase(DelChr(PDMDocument."PDM Code", '<>', ' '));
        PDMHistory.SetCurrentKey("Date");
        PDMHistory.Ascending(false);
        PDMHistory.SetRange("Document ID", PDMDocument."Document ID");
        PDMHistory.SetRange(Approval, true);
        if PDMHistory.FindSet() then
            repeat
                PreviousCode := UpperCase(DelChr(PDMHistory."PDM Code", '<>', ' '));
                if (PreviousCode <> '') and (PreviousCode <> CurrentCode) then begin
                    Candidate := PreviousCode;
                    if IsColorCode(PreviousCode) and IsColorCode(CurrentCode) then
                        if CopyStr(ItemNo, 1, StrLen(CurrentCode) - 1) = CopyStr(CurrentCode, 1, StrLen(CurrentCode) - 1) then
                            Candidate := CopyStr(PreviousCode, 1, StrLen(PreviousCode) - 1) + CopyStr(ItemNo, StrLen(CurrentCode));
                    if StrLen(Candidate) <= MaxStrLen(Item."No.") then
                        if Item.Get(Candidate) then
                            exit(Item."No.");
                end;
            until PDMHistory.Next() = 0;
    end;

    local procedure FindApprovedDocument(ItemNo: Text; Extension: Text; var PDMDocument: Record "ZM PDM Document"): Boolean
    var
        CandidateDocument: Record "ZM PDM Document";
        CodeList: List of [Text];
        PDMCode: Text;
        Found: Boolean;
    begin
        // por código exacto o, para variantes de color (250502B-18), por el código "-X" del PDM (250502B-X)
        CodeList.Add(UpperCase(ItemNo));
        if GetColorCode(ItemNo) <> '' then
            CodeList.Add(GetColorCode(ItemNo));
        CandidateDocument.SetCurrentKey("PDM Code");
        CandidateDocument.SetRange(Obsolete, false);
        if Extension <> '' then
            CandidateDocument.SetRange(Extension, Extension);
        foreach PDMCode in CodeList do begin
            CandidateDocument.SetRange("PDM Code", PDMCode);
            if CandidateDocument.FindSet() then
                repeat
                    if (not Found) or IsBetterDocument(CandidateDocument, PDMDocument) then begin
                        PDMDocument := CandidateDocument;
                        Found := true;
                    end;
                until CandidateDocument.Next() = 0;
        end;
        exit(Found);
    end;

    local procedure GetBestDocumentID(var TempPDMDocument: Record "ZM PDM Document" temporary): Integer
    var
        TempBestDocument: Record "ZM PDM Document" temporary;
        Found: Boolean;
    begin
        // la tabla temporal va por ID: se elige plano > ensamblaje > pieza > resto
        if TempPDMDocument.FindSet() then
            repeat
                if (not Found) or IsBetterDocument(TempPDMDocument, TempBestDocument) then begin
                    TempBestDocument := TempPDMDocument;
                    Found := true;
                end;
            until TempPDMDocument.Next() = 0;
        exit(TempBestDocument."Document ID");
    end;

    local procedure IsBetterDocument(CandidateDocument: Record "ZM PDM Document"; BestDocument: Record "ZM PDM Document"): Boolean
    begin
        if ExtensionPriority(CandidateDocument.Extension) <> ExtensionPriority(BestDocument.Extension) then
            exit(ExtensionPriority(CandidateDocument.Extension) < ExtensionPriority(BestDocument.Extension));
        exit(CandidateDocument."Approval Date" > BestDocument."Approval Date");
    end;

    local procedure GetColorCode(ItemNo: Text): Text
    var
        Position: Integer;
    begin
        // 250502B-18 -> 250502B-X (último guion seguido solo de dígitos)
        ItemNo := UpperCase(ItemNo);
        Position := StrLen(ItemNo);
        while (Position > 1) and (CopyStr(ItemNo, Position, 1) <> '-') do
            Position -= 1;
        if Position <= 1 then
            exit('');
        if not IsDigits(CopyStr(ItemNo, Position + 1)) then
            exit('');
        exit(CopyStr(ItemNo, 1, Position) + 'X');
    end;

    local procedure IsColorCode(PDMCode: Text): Boolean
    begin
        if StrLen(PDMCode) <= 2 then
            exit(false);
        exit(CopyStr(PDMCode, StrLen(PDMCode) - 1) = '-X');
    end;

    local procedure GetCodeFilter(ItemNo: Text) CodeFilter: Text
    begin
        // lista SQL de códigos a buscar en el PDM: N'250502B-18',N'250502B-X'
        CodeFilter := 'N''' + SQLText(UpperCase(ItemNo)) + '''';
        if GetColorCode(ItemNo) <> '' then
            CodeFilter += ',N''' + SQLText(GetColorCode(ItemNo)) + '''';
    end;

    local procedure SQLText(Value: Text): Text
    begin
        exit(DelChr(Value, '=', ''''));
    end;

    local procedure UpdateOpenRequests() NoRequests: Integer
    var
        Request: Record "ZM PL Items Temporary";
        OldStatus: Integer;
        OldDocumentID: Integer;
    begin
        // las solicitudes abiertas se relacionan solas cuando llega la aprobación del plano
        Request.SetFilter("State Creation", '<>%1', Request."State Creation"::Finished);
        Request.SetFilter("Item No.", '<>%1', '');
        if Request.FindSet(true) then
            repeat
                OldStatus := Request."PDM Status";
                OldDocumentID := Request."PDM Document ID";
                LinkRequest(Request, false);
                Request.Modify();
                if (OldStatus <> Request."PDM Status") or (OldDocumentID <> Request."PDM Document ID") then
                    NoRequests += 1;
            until Request.Next() = 0;
    end;

    // ======================================================================================================
    // ==  Consulta directa al PDM (cualquier estado): por códigos, por texto o por ID de documento
    // ======================================================================================================
    procedure SearchPDM(CodeFilter: Text; SearchText: Text; DocumentID: Integer; var TempPDMDocument: Record "ZM PDM Document" temporary): Boolean
    begin
        TempPDMDocument.Reset();
        TempPDMDocument.DeleteAll();
        InventorySetup.Get();
        if InventorySetup."PDM SQL Server" = '' then
            exit(false);  // PDM sin configurar
        ClearLastError();
        if not TrySearchPDM(CodeFilter, SearchText, DocumentID, TempPDMDocument) then begin
            LiveSearchFailed := true;
            exit(false);
        end;
        exit(true);
    end;

    [TryFunction]
    local procedure TrySearchPDM(CodeFilter: Text; SearchText: Text; DocumentID: Integer; var TempPDMDocument: Record "ZM PDM Document" temporary)
    var
        PDMDocument: Record "ZM PDM Document";
        SQLConnection: DotNet SqlConnection;
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
    begin
        SQLConnect(SQLConnection);
        SQLCommand := SQLConnection.CreateCommand();
        SQLCommand.CommandTimeout := 60;
        SQLCommand.CommandText := SearchQuery(CodeFilter, SearchText, DocumentID);
        SQLReader := SQLCommand.ExecuteReader();
        while SQLReader.Read() do begin
            TempPDMDocument.Init();
            TempPDMDocument."Document ID" := GetInt(SQLReader, 'DocumentID');
            TempPDMDocument."File Name" := CopyStr(GetText(SQLReader, 'Filename'), 1, MaxStrLen(TempPDMDocument."File Name"));
            TempPDMDocument.Extension := CopyStr(LowerCase(GetText(SQLReader, 'Extension')), 1, MaxStrLen(TempPDMDocument.Extension));
            TempPDMDocument.Folder := CopyStr(GetText(SQLReader, 'Folder'), 1, MaxStrLen(TempPDMDocument.Folder));
            TempPDMDocument."PDM Code" := CopyStr(GetText(SQLReader, 'Code'), 1, MaxStrLen(TempPDMDocument."PDM Code"));
            TempPDMDocument.Description := CopyStr(GetText(SQLReader, 'Descr'), 1, MaxStrLen(TempPDMDocument.Description));
            TempPDMDocument.Revision := CopyStr(GetText(SQLReader, 'Rev'), 1, MaxStrLen(TempPDMDocument.Revision));
            TempPDMDocument."Description ENG" := CopyStr(GetText(SQLReader, 'DescrENG'), 1, MaxStrLen(TempPDMDocument."Description ENG"));
            TempPDMDocument."Description FRA" := CopyStr(GetText(SQLReader, 'DescrFRA'), 1, MaxStrLen(TempPDMDocument."Description FRA"));
            TempPDMDocument.Modification := CopyStr(GetText(SQLReader, 'Modif'), 1, MaxStrLen(TempPDMDocument.Modification));
            TempPDMDocument.Material := CopyStr(GetText(SQLReader, 'Material'), 1, MaxStrLen(TempPDMDocument.Material));
            TempPDMDocument.Weight := CopyStr(GetText(SQLReader, 'Weight'), 1, MaxStrLen(TempPDMDocument.Weight));
            TempPDMDocument."Current Status" := CopyStr(GetText(SQLReader, 'StatusName'), 1, MaxStrLen(TempPDMDocument."Current Status"));
            TempPDMDocument."Latest Version" := GetInt(SQLReader, 'LatestRevisionNo');
            // si ya está aprobado (sincronizado), se indican los datos de la aprobación
            if PDMDocument.Get(TempPDMDocument."Document ID") then begin
                TempPDMDocument."Approved Version" := PDMDocument."Approved Version";
                TempPDMDocument."Approval Date" := PDMDocument."Approval Date";
                TempPDMDocument."Approved By" := PDMDocument."Approved By";
                TempPDMDocument."In Modification" := PDMDocument."In Modification";
            end;
            if TempPDMDocument.Insert() then;
        end;
        SQLReader.Close();
        SQLConnection.Close();
    end;

    local procedure SearchQuery(CodeFilter: Text; SearchText: Text; DocumentID: Integer) SQL: Text
    var
        LikeText: Text;
    begin
        SQL := 'SET NOCOUNT ON; ';
        SQL += 'WITH cv AS (SELECT VariableID FROM Variable WHERE VariableName = N''CodigodeProducto''), ';
        SQL += 'c AS (';
        case true of
            DocumentID <> 0:
                SQL += 'SELECT ' + Format(DocumentID, 0, 9) + ' DocumentID';
            CodeFilter <> '':
                SQL += 'SELECT DISTINCT vv.DocumentID FROM VariableValue vv WHERE vv.VariableID = (SELECT VariableID FROM cv) AND UPPER(LTRIM(RTRIM(vv.ValueCache))) IN (' + CodeFilter + ')';
            else begin
                LikeText := 'N''%' + SQLText(SearchText) + '%''';
                // código, descripción (p. ej. prototipos AC... que aún no tienen el código definitivo) o nombre de fichero
                SQL += 'SELECT DISTINCT vv.DocumentID FROM VariableValue vv JOIN Variable vr ON vr.VariableID = vv.VariableID ';
                SQL += 'WHERE vr.VariableName IN (N''CodigodeProducto'', N''DescripcionProducto'') AND vv.ValueCache LIKE ' + LikeText;
                SQL += ' UNION SELECT DocumentID FROM Documents WHERE Filename LIKE ' + LikeText;
            end;
        end;
        SQL += ') ';
        SQL += 'SELECT TOP 200 d.DocumentID, d.Filename, e.Extension, ISNULL(s.Name, N'''') StatusName, d.LatestRevisionNo, x.Code, x.Rev, x.Descr, ';
        SQL += 'x.DescrENG, x.DescrFRA, x.Modif, x.Material, x.Weight, ISNULL(p.Path, N'''') Folder ';
        SQL += 'FROM c JOIN Documents d ON d.DocumentID = c.DocumentID AND d.Deleted = 0 ';
        SQL += 'JOIN FileExtension e ON e.ExtensionID = d.ExtensionID LEFT JOIN Status s ON s.StatusID = d.CurrentStatusID ';
        SQL += 'OUTER APPLY (SELECT TOP 1 pr.Path FROM DocumentsInProjects dp JOIN Projects pr ON pr.ProjectID = dp.ProjectID ';
        SQL += ' WHERE dp.DocumentID = d.DocumentID AND dp.Deleted = 0 AND pr.Deleted = 0 ORDER BY dp.ProjectID) p ';
        // datos de la última versión (la que está en curso en el PDM)
        SQL += 'OUTER APPLY (SELECT ';
        SQL += ' MAX(CASE WHEN y.VariableName = N''CodigodeProducto'' THEN y.Val END) Code, ';
        SQL += ' MAX(CASE WHEN y.VariableName = N''Revision'' THEN y.Val END) Rev, ';
        SQL += ' MAX(CASE WHEN y.VariableName = N''DescripcionProducto'' THEN y.Val END) Descr, ';
        SQL += ' MAX(CASE WHEN y.VariableName = N''DescripcionProductoIngles'' THEN y.Val END) DescrENG, ';
        SQL += ' MAX(CASE WHEN y.VariableName = N''DescripcionProductoFrances'' THEN y.Val END) DescrFRA, ';
        SQL += ' MAX(CASE WHEN y.VariableName = N''Modificacion'' THEN y.Val END) Modif, ';
        SQL += ' MAX(CASE WHEN y.VariableName = N''Material'' THEN y.Val END) Material, ';
        SQL += ' MAX(CASE WHEN y.VariableName = N''Weight'' THEN y.Val END) Weight ';
        SQL += ' FROM (SELECT vr.VariableName, LTRIM(RTRIM(COALESCE(NULLIF(vv.ValueText, N''''), vv.ValueCache))) Val, ';
        SQL += '  ROW_NUMBER() OVER (PARTITION BY vv.VariableID ORDER BY vv.RevisionNo DESC, CASE vv.ConfigurationID WHEN 2 THEN 0 WHEN 1 THEN 1 ELSE 2 END) rn ';
        SQL += '  FROM VariableValue vv JOIN Variable vr ON vr.VariableID = vv.VariableID ';
        SQL += '  WHERE vv.DocumentID = d.DocumentID AND vr.VariableName IN (N''CodigodeProducto'', N''Revision'', N''DescripcionProducto'', ';
        SQL += '  N''DescripcionProductoIngles'', N''DescripcionProductoFrances'', N''Modificacion'', N''Material'', N''Weight'')) y WHERE y.rn = 1) x ';
        if CodeFilter <> '' then
            SQL += 'WHERE UPPER(x.Code) IN (' + CodeFilter + ') ';
        SQL += 'ORDER BY CASE LOWER(e.Extension) WHEN ''slddrw'' THEN 1 WHEN ''sldasm'' THEN 2 WHEN ''sldprt'' THEN 3 WHEN ''pdf'' THEN 4 ELSE 9 END, d.DocumentID DESC';
    end;

    // ======================================================================================================
    // ==  Bandeja: planos aprobados sin producto ni solicitud
    // ======================================================================================================
    procedure BuildPendingTray(var TempPDMDocument: Record "ZM PDM Document" temporary)
    var
        PDMDocument: Record "ZM PDM Document";
        TempByCode: Record "ZM PDM Document" temporary;
        PDMCode: Text;
    begin
        TempPDMDocument.Reset();
        TempPDMDocument.DeleteAll();
        InventorySetup.Get();
        InventorySetup.TestField("PDM Pending From Date");
        PDMDocument.SetFilter("Approval Date", '>=%1', CreateDateTime(InventorySetup."PDM Pending From Date", 0T));
        PDMDocument.SetRange(Obsolete, false);
        PDMDocument.SetFilter(Extension, '%1|%2|%3', 'slddrw', 'sldasm', 'sldprt');
        if PDMDocument.FindSet() then
            repeat
                PDMCode := UpperCase(DelChr(PDMDocument."PDM Code", '<>', ' '));
                if IsItemCode(PDMCode) then begin
                    // un documento por código: plano > ensamblaje > pieza
                    TempByCode.SetRange("PDM Code", PDMDocument."PDM Code");
                    if TempByCode.FindFirst() then begin
                        if IsBetterDocument(PDMDocument, TempByCode) then begin
                            TempByCode.Delete();
                            TempByCode := PDMDocument;
                            TempByCode.Insert();
                        end;
                    end else begin
                        TempByCode := PDMDocument;
                        TempByCode.Insert();
                    end;
                end;
            until PDMDocument.Next() = 0;
        TempByCode.Reset();
        if TempByCode.FindSet() then
            repeat
                PDMCode := UpperCase(DelChr(TempByCode."PDM Code", '<>', ' '));
                if not ItemOrRequestExists(PDMCode) then begin
                    TempPDMDocument := TempByCode;
                    TempPDMDocument.Insert();
                end;
            until TempByCode.Next() = 0;
    end;

    local procedure IsItemCode(PDMCode: Text): Boolean
    var
        i: Integer;
    begin
        // fuera: vacíos, largos, con espacios, prototipos (AC0358-..., PM23-...) y componentes (-C1, C1-...)
        if (PDMCode = '') or (StrLen(PDMCode) > 20) or (StrPos(PDMCode, ' ') > 0) then
            exit(false);
        if (StrLen(PDMCode) > 2) and (CopyStr(PDMCode, 1, 2) in ['AC', 'PM']) and IsDigits(CopyStr(PDMCode, 3, 1)) then
            exit(false);
        if (StrLen(PDMCode) > 2) and (CopyStr(PDMCode, 1, 1) = 'C') and IsDigits(CopyStr(PDMCode, 2, 1)) and (CopyStr(PDMCode, 3, 1) = '-') then
            exit(false);
        for i := 1 to StrLen(PDMCode) - 2 do
            if (CopyStr(PDMCode, i, 2) = '-C') and IsDigits(CopyStr(PDMCode, i + 2, 1)) then
                exit(false);
        exit(true);
    end;

    local procedure ItemOrRequestExists(PDMCode: Text): Boolean
    var
        Item: Record Item;
        Request: Record "ZM PL Items Temporary";
        PostedRequest: Record "Posted PL Items temporary";
        BaseCode: Text;
    begin
        Request.SetRange("PDM Code", PDMCode);
        if not Request.IsEmpty() then
            exit(true);
        PostedRequest.SetRange("PDM Code", PDMCode);
        if not PostedRequest.IsEmpty() then
            exit(true);
        if not IsColorCode(PDMCode) then begin
            if Item.Get(PDMCode) then
                exit(true);
            Request.Reset();
            Request.SetRange("Item No.", PDMCode);
            if not Request.IsEmpty() then
                exit(true);
            PostedRequest.Reset();
            PostedRequest.SetRange("Item No.", PDMCode);
            exit(not PostedRequest.IsEmpty());
        end;
        // variantes de color: basta con que exista alguna (250510B-15, 250510B-18...)
        BaseCode := CopyStr(PDMCode, 1, StrLen(PDMCode) - 1);
        Item.SetRange("No.", BaseCode + '0', CopyStr(BaseCode + '99999999', 1, MaxStrLen(Item."No.")));
        if not Item.IsEmpty() then
            exit(true);
        Request.Reset();
        Request.SetRange("Item No.", BaseCode + '0', CopyStr(BaseCode + '99999999', 1, MaxStrLen(Request."Item No.")));
        if not Request.IsEmpty() then
            exit(true);
        PostedRequest.Reset();
        PostedRequest.SetRange("Item No.", BaseCode + '0', CopyStr(BaseCode + '99999999', 1, MaxStrLen(PostedRequest."Item No.")));
        exit(not PostedRequest.IsEmpty());
    end;

    procedure GetNewItemNumbers(PDMDocument: Record "ZM PDM Document"; var ItemNumbers: List of [Text])
    var
        Item: Record Item;
        PDMHistory: Record "ZM PDM History";
        CurrentCode: Text;
        PreviousCode: Text;
        PreviousBase: Text;
    begin
        // sin colores: el propio código. Con colores (250510B-X): un producto por cada color de la
        // revisión anterior (250510A-15, 250510A-18 -> 250510B-15, 250510B-18)
        Clear(ItemNumbers);
        CurrentCode := UpperCase(DelChr(PDMDocument."PDM Code", '<>', ' '));
        if not IsColorCode(CurrentCode) then begin
            ItemNumbers.Add(CurrentCode);
            exit;
        end;
        PDMHistory.SetCurrentKey("Date");
        PDMHistory.Ascending(false);
        PDMHistory.SetRange("Document ID", PDMDocument."Document ID");
        PDMHistory.SetRange(Approval, true);
        if PDMHistory.FindSet() then
            repeat
                PreviousCode := UpperCase(DelChr(PDMHistory."PDM Code", '<>', ' '));
                if (PreviousCode <> CurrentCode) and IsColorCode(PreviousCode) then begin
                    PreviousBase := CopyStr(PreviousCode, 1, StrLen(PreviousCode) - 1);
                    Item.SetRange("No.", PreviousBase + '0', CopyStr(PreviousBase + '99999999', 1, MaxStrLen(Item."No.")));
                    if Item.FindSet() then
                        repeat
                            if IsDigits(CopyStr(Item."No.", StrLen(PreviousBase) + 1)) then
                                if StrLen(CurrentCode) - 1 + StrLen(Item."No.") - StrLen(PreviousBase) <= MaxStrLen(Item."No.") then
                                    ItemNumbers.Add(CopyStr(CurrentCode, 1, StrLen(CurrentCode) - 1) + CopyStr(Item."No.", StrLen(PreviousBase) + 1));
                        until Item.Next() = 0;
                    if ItemNumbers.Count() > 0 then
                        exit;
                end;
            until PDMHistory.Next() = 0;
        // sin revisión anterior con colores: una solicitud sin Nº producto, para completarla a mano
        ItemNumbers.Add('');
    end;

    procedure CreateRequestsFromTray(var TempPDMDocument: Record "ZM PDM Document" temporary)
    var
        Request: Record "ZM PL Items Temporary";
        ItemNumbers: List of [Text];
        ItemNo: Text;
        RequestList: Text;
        ConfirmList: Text;
        NoRequests: Integer;
        lblNoItemNo: Label '(without item no., %1)', comment = 'ESP="(sin nº producto, %1)"';
        lblConfirm: Label 'The following requests will be created:\%1\Do you want to continue?', comment = 'ESP="Se van a crear las siguientes solicitudes:\%1\¿Desea continuar?"';
        lblDone: Label '%1 requests have been created: %2', comment = 'ESP="Se han creado %1 solicitudes: %2"';
    begin
        if TempPDMDocument.FindSet() then
            repeat
                GetNewItemNumbers(TempPDMDocument, ItemNumbers);
                foreach ItemNo in ItemNumbers do
                    if ItemNo = '' then
                        ConfirmList += '\' + StrSubstNo(lblNoItemNo, TempPDMDocument."PDM Code")
                    else
                        ConfirmList += '\' + ItemNo;
            until TempPDMDocument.Next() = 0;
        if ConfirmList = '' then
            exit;
        if not Confirm(lblConfirm, false, CopyStr(ConfirmList, 2)) then
            exit;
        if TempPDMDocument.FindSet() then
            repeat
                GetNewItemNumbers(TempPDMDocument, ItemNumbers);
                foreach ItemNo in ItemNumbers do begin
                    Clear(Request);
                    Request.Init();
                    Request.Insert(true);
                    Request."Request Type" := Request."Request Type"::New;
                    if ItemNo <> '' then
                        Request.Validate("Item No.", CopyStr(ItemNo, 1, MaxStrLen(Request."Item No.")))
                    else
                        Request.Validate("PDM Document ID", TempPDMDocument."Document ID");
                    Request.Modify(true);
                    NoRequests += 1;
                    RequestList += ', ' + Request."No.";
                end;
            until TempPDMDocument.Next() = 0;
        Message(lblDone, NoRequests, CopyStr(RequestList, 3));
    end;
}
