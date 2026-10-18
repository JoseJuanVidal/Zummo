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
        lblDone: Label 'PDM synchronization finished.\Documents: %1\History entries: %2', comment = 'ESP="Sincronización PDM terminada.\Documentos: %1\Líneas de histórico: %2"';
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

        InventorySetup.Get();
        InventorySetup."PDM Sync Mark" := CopyStr(NewMark, 1, MaxStrLen(InventorySetup."PDM Sync Mark"));
        InventorySetup."PDM Last Sync" := SyncTime;
        InventorySetup.Modify();
        if GuiAllowed() then begin
            Window.Close();
            Message(lblDone, NoDocs, NoHist);
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
}
