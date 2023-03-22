page 17376 "OAuth 2.0 Application"
{
    Caption = 'OAuth 2.0 Application', Comment = 'ES="Aplicación OAuth 2.0"';
    LinksAllowed = false;
    ShowFilter = false;
    SourceTable = "ZM OAuth 2.0 Application";
    PromotedActionCategories = 'New,Process,Report,Navigate', Comment = 'ESP="Nuevo,Procesar,Informe,Información"';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ES="General"';
                field(Code; Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description.';
                }
                field("Client ID"; "Client ID")
                {
                    Caption = 'Application / Client ID', Comment = 'ES="Aplicación / ID de cliente"';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the client id.';
                }
                field("Client Secret"; "Client Secret")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDataType = Masked;
                    ToolTip = 'Specifies the client secret.';
                }
                field("Grant Type"; "Grant Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the grant type.';
                }
                field("Redirect URL"; "Redirect URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the redirect url.';
                }
                field(Scope; Scope)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the scope.';
                }

            }
            group("Password Credentials")
            {
                Caption = 'Password Credentials', Comment = 'ES="Credenciales de contraseña"';
                Visible = "Grant Type" = "Grant Type"::"Password Credentials";

                field("User Name"; "User Name")
                {
                    Caption = 'User Name', Comment = 'ES="Nombre de usuario"';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the user name.';
                }
                field("Password"; "Password")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDataType = Masked;
                    ToolTip = 'Specifies the password.';
                }
            }
            group("Endpoints")
            {
                Caption = 'Endpoints', Comment = 'ES="Puntos finales"';

                field("Authorization URL"; "Authorization URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the authorization url.';
                }
                field("Access Token URL"; "Access Token URL")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the access token url.';
                }
                field("Auth. URL Parms"; "Auth. URL Parms")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the resource url.';
                }
                field(IDDrive; IDDrive)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sharepoint ID';
                }
                field(RootFolderID; RootFolderID)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sharepoint ID';
                }
                field(RootFolderName; RootFolderName)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sharepoint Name (Documentos)';
                }
                field(jpgFolderID; jpgFolderID)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sharepoint ID';
                    trigger OnDrillDown()
                    begin
                        OpenDriveItems(Rec.jpgFolderID)
                    end;
                }
                field(pdfFolderID; pdfFolderID)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sharepoint ID';
                    trigger OnDrillDown()
                    begin
                        OpenDriveItems(Rec.pdfFolderID)
                    end;
                }
                field(dxfFolderID; dxfFolderID)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sharepoint ID';
                    trigger OnDrillDown()
                    begin
                        OpenDriveItems(Rec.dxfFolderID)
                    end;
                }
                field(StepFolderID; StepFolderID)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sharepoint ID';

                    trigger OnDrillDown()
                    begin
                        OpenDriveItems(Rec.StepFolderID)
                    end;
                }
                field(OtersFolderID; OtersFolderID)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Sharepoint ID';

                    trigger OnDrillDown()
                    begin
                        OpenDriveItems(Rec.OtersFolderID)
                    end;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RequestAccessToken)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Request Access Token', Comment = 'ES="Solicitar el token de acceso"';
                Image = EncryptionKeys;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the service authorization web page. Login credentials will be prompted. The authorization code must be copied into the Enter Authorization Code field.';

                trigger OnAction()
                var
                    MessageTxt: Text;
                begin
                    if not OAuth20AppHelper.RequestAccessToken(Rec, MessageTxt) then begin
                        Commit(); // save new "Status" value
                        Error(MessageTxt);
                    end else
                        Message(SuccessfulMsg);
                end;
            }
            action(RefreshAccessToken)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Refresh Access Token', Comment = 'ES="Actualizar el token de acceso"';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Refresh the access and refresh tokens.';

                trigger OnAction()
                var
                    MessageText: Text;
                begin
                    if OAuth20AppHelper.GetRefreshToken(Rec) = '' then
                        Error(NoRefreshTokenErr);

                    if not OAuth20AppHelper.RefreshAccessToken(Rec, MessageText) then begin
                        Commit(); // save new "Status" value
                        Error(MessageText);
                    end else
                        Message(SuccessfulMsg);
                end;
            }
        }
        area(Navigation)
        {
            action(Folders)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Folders', Comment = 'ES="Carpetas"';
                Image = SelectField;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Refresh the access and refresh tokens.';

                RunObject = page "ZM OAuth20Application Folders";
                RunPageLink = "Application Code" = field(Code);

            }
        }
    }

    var
        OAuth20AppHelper: Codeunit "Sharepoint OAuth App. Helper";
        SuccessfulMsg: Label 'Access Token updated successfully.';
        NoRefreshTokenErr: Label 'No Refresh Token avaiable';


    local procedure OpenDriveItems(FolderID: Text)
    var
        OnlineDriveItems: page "Sharepont Drive Items";
        AccessToken: text;
    begin
        AccessToken := OAuth20AppHelper.GetAccessToken(Rec.Code);

        OnlineDriveItems.SetProperties(Rec.Code, AccessToken, '', FolderID, RootFolderID);
        OnlineDriveItems.RunModal();
    end;
}

