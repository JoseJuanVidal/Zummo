table 17377 "ZM OAuth20Application Folders"
{
    DataClassification = CustomerContent;
    LookupPageId = "ZM OAuth20Application Folders";
    DrillDownPageId = "ZM OAuth20Application Folders";

    fields
    {
        field(1; "Application Code"; Code[20])
        {
            Caption = 'Application Code', Comment = 'ES==Código Application';
            NotBlank = true;
            TableRelation = "ZM OAuth 2.0 Application".Code;
        }
        field(2; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description', Comment = 'ES==Descripción';
        }
        field(10; FolderID; Text[250])
        {
            Caption = 'Folder Id', Comment = 'ES==Id Carpeta';
        }
    }

    keys
    {
        key(Key1; "Application Code", Code)
        {
            Clustered = true;
        }
    }

    var
        OAuth20AppHelper: Codeunit "Sharepoint OAuth App. Helper";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure OpenDriveItems(FolderID: Text)
    var
        OAuthApplication: Record "ZM OAuth 2.0 Application";
        OnlineDriveItems: page "Sharepont Drive Items";
        AccessToken: text;
    begin
        OAuthApplication.Get(Rec."Application Code");

        AccessToken := OAuth20AppHelper.GetAccessToken(OAuthApplication.Code);

        OnlineDriveItems.SetProperties(rec."Application Code", AccessToken, '', FolderID, OAuthApplication.RootFolderID);
        OnlineDriveItems.RunModal();
    end;
}