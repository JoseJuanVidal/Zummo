table 17375 "ZM OAuth 2.0 Application"
{
    Caption = 'OAuth 2.0 Application', Comment = 'ES="Aplicación OAuth 2.0"';
    DrillDownPageId = "OAuth 2.0 Applications";
    LookupPageId = "OAuth 2.0 Applications";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code', Comment = 'ES="Código"';
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description', Comment = 'ES="Descripción"';
        }
        field(3; "Client ID"; Text[250])
        {
            Caption = 'Client ID', Comment = 'ES="Identificación del cliente"';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret', Comment = 'ES="Secreto del cliente"';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Redirect URL"; Text[250])
        {
            Caption = 'Redirect URL', Comment = 'ES="Redireccionar URL"';
        }
        field(6; "Auth. URL Parms"; Text[250])
        {
            Caption = 'Auth. URL Parms', Comment = 'ES="Auth. Url parms"';
        }
        field(7; Scope; Text[250])
        {
            Caption = 'Scope', Comment = 'ES="Alcance"';
        }
        field(8; "Authorization URL"; Text[250])
        {
            Caption = 'Authorization URL', Comment = 'ES="URL de autorización"';

            trigger OnValidate()
            var
                WebRequestHelper: Codeunit "Web Request Helper";
            begin
                if "Authorization URL" <> '' then
                    WebRequestHelper.IsSecureHttpUrl("Authorization URL");
            end;
        }
        field(9; "Access Token URL"; Text[250])
        {
            Caption = 'Access Token URL', Comment = 'ES="URL de token de acceso"';

            trigger OnValidate()
            var
                WebRequestHelper: Codeunit "Web Request Helper";
            begin
                if "Access Token URL" <> '' then
                    WebRequestHelper.IsSecureHttpUrl("Access Token URL");
            end;
        }
        field(10; Status; Option)
        {
            Caption = 'Status', Comment = 'ES="Estado"';
            OptionCaption = ' ,Enabled,Disabled,Connected,Error', Comment = 'ES=",Habilitado,Deshabilitado,Conectado,Error"';
            OptionMembers = " ",Enabled,Disabled,Connected,Error;
        }
        field(11; "Access Token"; Blob)
        {
            Caption = 'Access Token', Comment = 'ES="Token de acceso"';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12; "Refresh Token"; Blob)
        {
            Caption = 'Refresh Token', Comment = 'ES="Actualización"';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(13; "Authorization Time"; DateTime)
        {
            Caption = 'Authorization Time', Comment = 'ES="Tiempo de autorización"';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(14; "Expires In"; Integer)
        {
            Caption = 'Expires In', Comment = 'ES="Expira en"';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(15; "Ext. Expires In"; Integer)
        {
            Caption = 'Ext. Expires In', Comment = 'ES="Ext. Expira en"';
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
        }
        field(16; "Grant Type"; Enum "Auth. Grant Type")
        {
            Caption = 'Grant Type', Comment = 'ES="Tipo de subvención"';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(17; "User Name"; Text[80])
        {
            Caption = 'User Name', Comment = 'ES="Nombre de usuario"';
        }
        field(18; Password; Text[20])
        {
            Caption = 'Password', Comment = 'ES="Clave"';
        }
        field(20; IDDrive; Text[250])
        {
            Caption = 'Drive Id', Comment = 'ES="Id Sharepoint"';
        }
        field(25; RootFolderID; Text[250])
        {
            Caption = 'Root Folder Id', Comment = 'ES="Id Carpeta root"';
        }
        field(26; jpgFolderID; Text[250])
        {
            Caption = 'jpg Folder Id', Comment = 'ES="Id Carpeta jpg"';
        }
        field(27; pdfFolderID; Text[250])
        {
            Caption = 'pdf Folder Id', Comment = 'ES="Id Carpeta pdf"';
        }
        field(28; dxfFolderID; Text[250])
        {
            Caption = 'dxf Folder Id', Comment = 'ES="Id Carpeta dxf"';
        }
        field(29; StepFolderID; Text[250])
        {
            Caption = 'step Folder Id', Comment = 'ES="Id Carpeta step"';
        }
        field(30; OtersFolderID; Text[250])
        {
            Caption = 'Oters Folder Id', Comment = 'ES="Id Carpeta otros"';
        }
        field(50; RootFolderName; Text[250])
        {
            Caption = 'Root Folder Name', Comment = 'ES="Nombre Carpeta root"';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        Status := Status::" ";
        Clear("Access Token");
        Clear("Refresh Token");
        "Expires In" := 0;
        "Ext. Expires In" := 0;
        "Authorization Time" := 0DT;
    end;
}
