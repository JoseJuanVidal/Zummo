table 17380 "ZM SH Record Link Sharepoint"
{
    DataClassification = CustomerContent;
    Caption = 'Documents', comment = 'ESP="Documentos"';
    LookupPageId = "ZM SH Record Link Sharep. list";
    DrillDownPageId = "ZM SH Record Link Sharep. list";

    fields
    {
        field(1; id; Guid)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Link Id"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Link Id', comment = 'ESP="Id. vínculo"';
            AutoIncrement = true;
        }
        field(3; "Record ID"; RecordID)
        {
            DataClassification = CustomerContent;
            Caption = 'Record ID', comment = 'ESP="Id. del registro"';
            Editable = false;
        }
        field(10; URL; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'URL', comment = 'ESP="URL"';
        }
        field(12; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name', comment = 'ESP="Nombre"';
        }
        field(20; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(30; "Application Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Application Code', comment = 'ESP="Cód. Aplicación"';
            TableRelation = "ZM OAuth 2.0 Application".Code;
        }
        field(40; driveId; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(50; fileId; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(60; "Document No."; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.', comment = 'ESP="Nº Documento"';
        }
        field(70; "File Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'File Name', comment = 'ESP="Nombre Fichero"';
        }
    }

    keys
    {
        key(Key1; id)
        {
            Clustered = true;
        }
    }

    var
        PurchaseSetup: Record "Purchases & Payables Setup";
        OAuth20Application: Record "ZM OAuth 2.0 Application";
        OAuth20ApplicationFolders: Record "ZM OAuth20Application Folders";
        OnlineDriveItem: Record "Online Drive Item" temporary;
        SharepointAppHelper: Codeunit "Sharepoint OAuth App. Helper";
        AccessToken: Text;
        lblSelectFile: Label 'Select a File', comment = 'ESP="Seleccione Archivo"';
        lblNofFound: Label 'File not found in Sharepoint.', comment = 'ESP="Archivo no encontrado Sharepoint."';

    trigger OnInsert()
    begin
        if IsNullGuid(Rec.Id) then
            Rec.Id := CreateGuid();
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        // tenemos que eliminar el fichero del Sharepoint
        DeleteSharepointfile();
    end;

    trigger OnRename()
    begin

    end;

    procedure UploadFile(Record_id: RecordId; prefixFileName: text; ExtDocNo: text; Name: Text)
    var
        RecordLinkSharepoint: Record "ZM SH Record Link Sharepoint";
        FromFile: Text;
        FileName: text;
        Stream: InStream;
        lblError: Label 'No se ha podido subir el fichero %1, %2, %3', comment = 'ESP="No se ha podido subir el fichero %1, %2, %3"';
    begin
        OnlineDriveItem.DeleteAll();
        PurchaseSetup.Get();
        OAuth20Application.Get(PurchaseSetup."Sharepoint Connection");
        OAuth20ApplicationFolders.Get(OAuth20Application.Code, PurchaseSetup."Sharepoint Folder");
        AccessToken := SharepointAppHelper.GetAccessToken(PurchaseSetup."Sharepoint Connection");
        if UploadIntoStream(lblSelectFile, '', '', FromFile, Stream) then begin
            FileName := SharepointAppHelper.ExtractFileNameFromPath(FromFile);
            FileName := StrSubstNo('%1 %2', prefixFileName, FileName);
            if SharepointAppHelper.UploadFile(AccessToken, OAuth20Application.RootFolderID, '', OAuth20ApplicationFolders.FolderName
                        , FileName, Stream, OnlineDriveItem) then begin
                RecordLinkSharepoint.Init();
                RecordLinkSharepoint.id := CreateGuid();
                RecordLinkSharepoint."Application Code" := PurchaseSetup."Sharepoint Connection";
                RecordLinkSharepoint."Record ID" := Record_id;
                RecordLinkSharepoint.URL := copystr(OnlineDriveItem.webUrl, 1, MaxStrLen(RecordLinkSharepoint.URL));
                RecordLinkSharepoint.Name := FileName;
                RecordLinkSharepoint.Description := ExtDocNo;
                RecordLinkSharepoint.driveId := OnlineDriveItem.driveId;
                RecordLinkSharepoint.fileId := OnlineDriveItem.id;
                RecordLinkSharepoint."Document No." := copystr(Name, 1, MaxStrLen(RecordLinkSharepoint."Document No."));
                RecordLinkSharepoint.Insert(true);
            end else
                Error(lblError, FileName, OAuth20Application.RootFolderID, OAuth20ApplicationFolders.FolderName);
        end;
    end;

    procedure UploadFilefromStream(Record_id: RecordId; prefixFileName: text; ExtDocNo: text; Name: Text; DocumentNo: text; idFileName: text; Stream: InStream)
    var
        RecordLinkSharepoint: Record "ZM SH Record Link Sharepoint";
        FileManagement: Codeunit "File Management";
        FromFile: Text;
        FileName: text;
        lblError: Label 'No se ha podido subir el fichero %1, %2, %3', comment = 'ESP="No se ha podido subir el fichero %1, %2, %3"';
    begin
        PurchaseSetup.Get();
        OnlineDriveItem.DeleteAll();
        OAuth20Application.Get(PurchaseSetup."Sharepoint Connection");
        OAuth20ApplicationFolders.Get(OAuth20Application.Code, PurchaseSetup."Sharepoint Folder");
        AccessToken := SharepointAppHelper.GetAccessToken(PurchaseSetup."Sharepoint Connection");
        FileName := StrSubstNo('%1 %2', Name, DocumentNo);
        FileName := StrSubstNo('%1 %2.%3', prefixFileName, FileName, FileManagement.GetExtension(idFileName));
        if SharepointAppHelper.UploadFile(AccessToken, OAuth20Application.RootFolderID, '', OAuth20ApplicationFolders.FolderName
                    , FileName, Stream, OnlineDriveItem) then begin
            RecordLinkSharepoint.Init();
            RecordLinkSharepoint.id := CreateGuid();
            RecordLinkSharepoint."Application Code" := PurchaseSetup."Sharepoint Connection";
            RecordLinkSharepoint."Record ID" := Record_id;
            RecordLinkSharepoint.URL := copystr(OnlineDriveItem.webUrl, 1, MaxStrLen(RecordLinkSharepoint.URL));
            RecordLinkSharepoint.Name := FileName;
            RecordLinkSharepoint.Description := ExtDocNo;
            RecordLinkSharepoint.driveId := OnlineDriveItem.driveId;
            RecordLinkSharepoint.fileId := OnlineDriveItem.id;
            RecordLinkSharepoint."Document No." := copystr(Name, 1, MaxStrLen(RecordLinkSharepoint."Document No."));
            RecordLinkSharepoint."File Name" := idFileName;
            RecordLinkSharepoint.Insert(true);
        end else
            Error(lblError, FileName, OAuth20Application.RootFolderID, OAuth20ApplicationFolders.FolderName);
    end;

    procedure UploadFilefromStreamOAut(Record_id: RecordId; SharepointConnection: text; RootFolderID: text; FolderID: text; FileName: Text;
        INStream: InStream; var FileURL: text): Boolean
    var
        RecordLinkSharepoint: Record "ZM SH Record Link Sharepoint";
        FileManagement: Codeunit "File Management";
        lblError: Label 'No se ha podido subir el fichero %1, %2, %3', comment = 'ESP="No se ha podido subir el fichero %1, %2, %3"';
    begin
        OnlineDriveItem.DeleteAll();
        OAuth20Application.Get(SharepointConnection);
        AccessToken := SharepointAppHelper.GetAccessToken(SharepointConnection);
        if SharepointAppHelper.UploadFolderFile(AccessToken, OAuth20Application.RootFolderID, '', FolderID, FileName, INStream, OnlineDriveItem) then begin
            // RecordLinkSharepoint.Init();
            // RecordLinkSharepoint.id := CreateGuid();
            // RecordLinkSharepoint."Application Code" := SharepointConnection;
            // RecordLinkSharepoint."Record ID" := Record_id;
            // RecordLinkSharepoint.URL := copystr(OnlineDriveItem.webUrl, 1, MaxStrLen(RecordLinkSharepoint.URL));
            // RecordLinkSharepoint.Name := FileName;
            // RecordLinkSharepoint.Description := FileName;
            // RecordLinkSharepoint.driveId := OnlineDriveItem.driveId;
            // RecordLinkSharepoint.fileId := OnlineDriveItem.id;
            // RecordLinkSharepoint."Document No." := copystr(Name, 1, MaxStrLen(RecordLinkSharepoint."Document No."));
            // RecordLinkSharepoint."File Name" := FileName;
            // RecordLinkSharepoint.Insert(true);
            FileURL := OnlineDriveItem.webUrl;
        end;
    end;

    procedure UPloadFetchDrivesOAut(PurchaseHeader: Record "Purchase Header"; SharepointConnection: code[20]; SharepointFolder: code[20]; FileName: Text; INStream: InStream): Boolean
    var
        TempOnlineDriveItem: Record "Online Drive Item" temporary;
        YearFolderDriveId: Text;
        VendorFolderDriveId: Text;
        YearFolder: text;
        VendorFolder: text;
        FileURL: Text;
    begin
        OAuth20Application.Get(SharepointConnection);
        OAuth20ApplicationFolders.Get(OAuth20Application.Code, SharepointFolder);
        AccessToken := SharepointAppHelper.GetAccessToken(SharepointConnection);
        // YEAR
        TempOnlineDriveItem.DeleteAll();
        YearFolder := format(Date2DMY(PurchaseHeader."Document Date", 3));
        YearFolderDriveId := '';
        if SharepointAppHelper.FetchDrivesChildItems(SharepointConnection, AccessToken, OAuth20Application.RootFolderID, OAuth20ApplicationFolders.FolderID, TempOnlineDriveItem) then
            if TempOnlineDriveItem.FindFirst() then
                repeat
                    if TempOnlineDriveItem.name = YearFolder then
                        YearFolderDriveId := TempOnlineDriveItem.id;
                Until TempOnlineDriveItem.next() = 0;
        if YearFolderDriveId = '' then begin
            if not SharepointAppHelper.CreateDriveFolder(SharepointConnection, AccessToken, OAuth20Application.RootFolderID, OAuth20ApplicationFolders.FolderID,
                    YearFolder, TempOnlineDriveItem) then
                exit;
            YearFolderDriveId := TempOnlineDriveItem.id;
        end;
        // Vendor code + Name
        TempOnlineDriveItem.DeleteAll();
        VendorFolder := StrSubstNo('%1', DelChr(PurchaseHeader."Buy-from Vendor Name", '=', '\/.'));
        VendorFolderDriveId := '';
        if SharepointAppHelper.FetchDrivesChildItems(SharepointConnection, AccessToken, OAuth20Application.RootFolderID, YearFolderDriveId, TempOnlineDriveItem) then
            if TempOnlineDriveItem.FindFirst() then
                repeat
                    if TempOnlineDriveItem.name = VendorFolder then
                        VendorFolderDriveId := TempOnlineDriveItem.id;
                Until TempOnlineDriveItem.next() = 0;
        if VendorFolderDriveId = '' then begin
            if not SharepointAppHelper.CreateDriveFolder(SharepointConnection, AccessToken, OAuth20Application.RootFolderID, YearFolderDriveId,
                    VendorFolder, TempOnlineDriveItem) then
                exit;
            VendorFolderDriveId := TempOnlineDriveItem.id;
        end;
        TempOnlineDriveItem.DeleteAll();
        if not UploadFilefromStreamOAut(PurchaseHeader.RecordId, SharepointConnection, OAuth20Application.RootFolderID, VendorFolderDriveId, FileName, INStream, FileURL) then begin
            UpdateRecordLinkPurchaseHeader(PurchaseHeader, FileURL, Filename);
            exit(true);
        end;
    end;

    local procedure UpdateRecordLinkPurchaseHeader(PurchaseHeader: Record "Purchase Header"; WebUrl: Text; Filename: Text)
    var
        RecordLink: Record "Record Link";
    begin
        RecordLink.Reset();
        RecordLink.SetRange("Record ID", PurchaseHeader.RecordId);
        RecordLink.SetRange(Description, Filename);
        if RecordLink.FindFirst() then
            RecordLink.Delete();
        PurchaseHeader.AddLink(WebUrl, Filename);
    end;

    procedure DownloadFile()
    var
        FileName: text;
        Stream: InStream;
    begin
        PurchaseSetup.Get();
        FileName := Rec.name;
        OAuth20Application.Get(PurchaseSetup."Sharepoint Connection");
        AccessToken := SharepointAppHelper.GetAccessToken(OAuth20Application.Code);
        if SharepointAppHelper.DownloadFile(AccessToken, Rec.driveId, Rec.Fileid, Stream) then
            DownloadFromStream(Stream, '', '', '', FileName)
        else
            error(lblNofFound);

    end;

    local procedure DeleteSharepointfile()
    begin
        PurchaseSetup.Get();
        OAuth20Application.Get(PurchaseSetup."Sharepoint Connection");
        AccessToken := SharepointAppHelper.GetAccessToken(OAuth20Application.Code);
        SharepointAppHelper.DeleteDriveItem(AccessToken, OAuth20Application.RootFolderID, Rec.fileId);

    end;

    procedure ShowDocument()
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PostedPurchaseReceipts: page "Posted Purchase Receipts";
    begin
        PurchRcptHeader.Reset();
        PurchRcptHeader.SetRange("No.", Rec."Document No.");
        PostedPurchaseReceipts.SetTableView(PurchRcptHeader);
        PostedPurchaseReceipts.RunModal();
    end;
}