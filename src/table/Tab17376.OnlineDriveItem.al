table 17376 "Online Drive Item"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; id; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(2; driveId; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; parentId; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; name; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; isFile; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; mimeType; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(7; size; BigInteger)
        {
            DataClassification = CustomerContent;
        }
        field(8; createdDateTime; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(9; webUrl; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(10; FolderName; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Folder Name', comment = 'ESP="Nombre Carpeta"';
        }
        field(20; "Application Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Application Code', comment = 'ESP="Cód. Aplicación"';
        }
    }

    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
    var
        OAuth20AppHelper: Codeunit "Sharepoint OAuth App. Helper";

    procedure OpenDriveItems()
    var
        OAuthApplication: Record "ZM OAuth 2.0 Application";
        OnlineDriveItems: Page "Sharepont Drive Items";
        AccessToken: text;
        Stream: InStream;
    begin
        OAuthApplication.Get(Rec."Application Code");

        AccessToken := OAuth20AppHelper.GetAccessToken(OAuthApplication.Code);

        if not isFile then begin
            OnlineDriveItems.SetProperties(Rec."Application Code", AccessToken, '', driveId, Id);
            OnlineDriveItems.Run();
        end else begin
            if OAuth20AppHelper.DownloadFile(AccessToken, driveId, id, Stream) then
                DownloadFromStream(Stream, '', '', '', name);
        end;
    end;
}
