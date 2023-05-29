table 17380 "ZM SH Record Link Sharepoint"
{
    DataClassification = CustomerContent;
    Caption = 'Documents', comment = 'ESP="Documentos"';
    LookupPageId = "ZM SH Record Link Sharepoints";
    DrillDownPageId = "ZM SH Record Link Sharepoints";

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
        lblSelectFile: Label 'Select a File', comment = 'ESP="Seleccione Fichero"';

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
            DownloadFromStream(Stream, '', '', '', FileName);
    end;

    local procedure DeleteSharepointfile()
    begin
        PurchaseSetup.Get();
        OAuth20Application.Get(PurchaseSetup."Sharepoint Connection");
        AccessToken := SharepointAppHelper.GetAccessToken(OAuth20Application.Code);
        SharepointAppHelper.DeleteDriveItem(AccessToken, OAuth20Application.RootFolderID, Rec.fileId);

    end;
}