codeunit 50114 "ZM Sharepoint Functions"
{
    trigger OnRun()
    begin

    end;

    var
        lbloAut: Label 'sharepoint';

    procedure GetAccessToken(AppCode: Code[20]): Text
    var
        OAuth20Application: Record "OAuth 2.0 Setup";//"OAuth 2.0 Application";
        OAuth20AppHelper: Codeunit "OAuth 2.0 Mgt."; // "OAuth 2.0 App. Helper";
        MessageText: Text;  // var
        AuthorizationCode: Text;
        ClientID: Text;
        ClientSecret: Text;
        AccessToken: Text; // var
        RefreshToken: Text;  // var
    begin
        GetOautSetup(OAuth20Application);

        if not OAuth20AppHelper.RequestAccessToken(OAuth20Application, MessageText, AuthorizationCode, ClientID, ClientSecret, AccessToken, RefreshToken) then
            Error(MessageText);

        exit(AccessToken);
    end;

    local procedure GetOautSetup(var OAuth20Application: Record "OAuth 2.0 Setup")
    var
        ClientIdTxt: Label 'bbaebd13-7b64-4a79-806f-1c928c9f41c9', Locked = true;
        ClientSecret: Label 'acacbbb6-3305-4b91-a580-c523b448d612', Locked = true;
        //ResourceUrlTxt: Label 'https://graph.microsoft.com', Locked = true;
        ResourceUrlTxt: Label 'https://login.microsoftonline.com/', Locked = true;
        //https://login.microsoftonline.com/
        OAuthAuthorityUrlTxt: Label 'https://login.microsoftonline.com/acacbbb6-3305-4b91-a580-c523b448d612/oauth2/v2.0/authorize', Locked = true;
        RedirectURLTxt: Label 'http://localhost:8080/BC160/OAuthLanding.htm', Locked = true;
        //https://login.microsoftonline.com/
        AccessTokenURLTxt: Label 'acacbbb6-3305-4b91-a580-c523b448d612/oauth2/v2.0/token', Locked = true;
        OneDriveRootQueryUri: Label 'https://graph.microsoft.com/v1.0/me/drive/root/children', Locked = true;
    begin
        if OAuth20Application.Get(lbloAut) then
            OAuth20Application.Delete();
        if not OAuth20Application.Get(lbloAut) then begin
            OAuth20Application.Init();
            OAuth20Application.Code := lbloAut;
            OAuth20Application."Service URL" := ResourceUrlTxt;
            OAuth20Application."Client ID" := ClientIdTxt;
            OAuth20Application."Client Secret" := ClientSecret;
            OAuth20Application."Redirect URL" := RedirectURLTxt;
            OAuth20Application."Authorization URL Path" := OAuthAuthorityUrlTxt;
            OAuth20Application."Access Token URL Path" := AccessTokenURLTxt;
            OAuth20Application.Insert();
        end;
    end;

    procedure SW_REST(urlBase: Text; metodo: Text; metodoREST: Text; parametros: Text; requiereAutenticacion: Boolean; var statusCode: Integer; var respuestaJSON: JsonObject; indicarEmpresa: Boolean)
    var
        Client: HttpClient;
        ContentHeaders: HttpHeaders;
        ClientHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        ResultJsonToken: JsonToken;

        TempBlob: Record TempBlob;
        Url: Text;
        StringAuthorization: Text;
        ResponseText: Text;
        Texto: Text;
        User: text;
        PassWebServKey: Text;
        StringAuth: Text;

    begin
        //Obtenemos los datos de configuración web
        // regCon.GET();

        //Creamos una url
        Url := urlBase + metodo;
        //Añadimos los headers de petición

        RequestContent.GetHeaders(ContentHeaders);

        //Obtenemos los headers por defecto
        ClientHeaders := Client.DefaultRequestHeaders();

        //Si la variable indicar empresa es true entonces entra y un header tendrá company y su id
        /*   if indicarEmpresa then begin
              ClientHeaders.Add('company', Format('ZUMMO'));
          end;
   */

        TempBlob.WriteTextLine(User + ':' + PassWebServKey);
        StringAuth := TempBlob.ToBase64String();

        //Si se requiere autenticacion(menos para pedir token de acceso siempre será true) entra
        if requiereAutenticacion then begin

            StringAuthorization := 'Basic ' + StringAuth;
            //Creamos la cabecera de athorization
            ClientHeaders.Add('Authorization', StringAuthorization);
        end;

        //Si el metodo es de tipo Post o Patch entra para configurar los contentheaders
        if metodoREST in ['POST', 'PATCH'] then begin

            RequestContent.WriteFrom(parametros);
            ContentHeaders.Remove('Content-Type');
            ContentHeaders.Add('Content-Type', 'application/json');

        end;

        ClientHeaders.Add('Accept', 'application/json');

        //Asignamos el metodo rest para la petición http
        RequestMessage.Method(metodoREST);
        //Asignamos la url para la peticion http 
        RequestMessage.SetRequestUri(Url);
        if metodoREST <> 'GET' then
            RequestMessage.Content := RequestContent;

        //Si se puede enviar los datos
        if Client.Send(RequestMessage, ResponseMessage) then begin
            //si esun codigo exitoso(200, 201)
            if (ResponseMessage.IsSuccessStatusCode()) then begin
                ResponseMessage.Content.ReadAs(ResponseText);//Leemos el contenido de la respuesta http
            end
            else begin
                ResponseMessage.Content.ReadAs(ResponseText);
                //Message('%1', ResponseText);
            end;
        end
        else begin
            ResponseMessage.Content.ReadAs(ResponseText);
        end;

        //Procesamos el json de la peticion y su status code para posteriormente pasarla por el valor de referencia
        respuestaJSON.ReadFrom(ResponseText);
        statusCode := ResponseMessage.HttpStatusCode;

    end;
    /*
      TESTFIELD("Service URL");
  TESTFIELD("Access Token URL Path");
  TESTFIELD("Client ID");
  TESTFIELD("Client Secret");
  TESTFIELD("Redirect URL");
        procedure CreateRequest(RequestUrl: Text; AccessToken: Text): Text
        var
            TempBlob: Record TempBlob;
            Client: HttpClient;
            RequestHeaders: HttpHeaders;
            MailContentHeaders: HttpHeaders;
            MailContent: HttpContent;
            ResponseMessage: HttpResponseMessage;
            RequestMessage: HttpRequestMessage;
            JObject: JsonObject;
            ResponseStream: InStream;
            APICallResponseMessage: Text;
            StatusCode: Integer;
            IsSuccessful: Boolean;
        begin

            RequestMessage.GetHeaders(RequestHeaders);
            RequestHeaders.Add('Authorization', 'Bearer ' + AccessToken);
            RequestMessage.SetRequestUri(RequestUrl);
            RequestMessage.Method('GET');

            Clear(TempBlob);
            TempBlob.Blob.CreateInStream(ResponseStream);

            IsSuccessful := Client.Send(RequestMessage, ResponseMessage);

            if not IsSuccessful then
                exit('An API call with the provided header has failed.');

            if not ResponseMessage.IsSuccessStatusCode() then begin
                StatusCode := ResponseMessage.HttpStatusCode();
                exit('The request has failed with status code ' + Format(StatusCode));
            end;

            if not ResponseMessage.Content().ReadAs(ResponseStream) then
                exit('The response message cannot be processed.');


            if not JObject.ReadFrom(ResponseStream) then
                exit('Cannot read JSON response.');

            JObject.WriteTo(APICallResponseMessage);
            APICallResponseMessage := APICallResponseMessage.Replace(',', '\');
            exit(APICallResponseMessage);
        end;

        var
            DrivesUrl: Label 'https://graph.microsoft.com/v1.0/drives', Locked = true;

        procedure FetchDrives(AccessToken: Text; var Drive: Record "Online Drive"): Boolean
        var
            JsonResponse: JsonObject;
            JToken: JsonToken;
        begin
            if HttpGet(AccessToken, DrivesUrl, JsonResponse) then begin
                if JsonResponse.Get('value', JToken) then
                    ReadDrives(JToken.AsArray(), Drive);

                exit(true);
            end;
        end;

    Online Drive (table 50115)
    table 50115 "Online Drive"
    {
        DataClassification = CustomerContent;

        fields
        {
            field(1; id; Text[250])
            {
                DataClassification = CustomerContent;
            }
            field(2; name; Text[250])
            {
                DataClassification = CustomerContent;
            }
            field(3; description; Text[250])
            {
                DataClassification = CustomerContent;
            }
            field(4; driveType; Text[80])
            {
                DataClassification = CustomerContent;
            }
            field(5; createdDateTime; DateTime)
            {
                DataClassification = CustomerContent;
            }
            field(6; lastModifiedDateTime; DateTime)
            {
                DataClassification = CustomerContent;
            }
            field(7; webUrl; Text[250])
            {
                DataClassification = CustomerContent;
            }
        }

        keys
        {
            key(PK; id)
            {
                Clustered = true;
            }
        }
    }

    HttpGet method
    Following is a helper function to get json object response from the given Url using AccessToken.

    local procedure HttpGet(AccessToken: Text; Url: Text; var JResponse: JsonObject): Boolean
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        ResponseText: Text;
        IsSucces: Boolean;
    begin
        Headers := Client.DefaultRequestHeaders();
        Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));

        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method := 'GET';

        if Client.Send(RequestMessage, ResponseMessage) then
            if ResponseMessage.IsSuccessStatusCode() then begin
                if ResponseMessage.Content.ReadAs(ResponseText) then
                    IsSucces := true;
            end else
                ResponseMessage.Content.ReadAs(ResponseText);

        JResponse.ReadFrom(ResponseText);
        exit(IsSucces);
    end;


    ReadDrives method
    This function reads JsonArray and inserts data into "Online Drive" table.

    local procedure ReadDrives(JDrives: JsonArray; var Drive: Record "Online Drive")
    var
        JDriveItem: JsonToken;
        JDrive: JsonObject;
        JToken: JsonToken;
    begin
        foreach JDriveItem in JDrives do begin
            JDrive := JDriveItem.AsObject();

            Drive.Init();
            if JDrive.Get('id', JToken) then
                Drive.Id := JToken.AsValue().AsText();
            if JDrive.Get('name', JToken) then
                Drive.Name := JToken.AsValue().AsText();
            if JDrive.Get('description', JToken) then
                Drive.description := JToken.AsValue().AsText();
            if JDrive.Get('driveType', JToken) then
                Drive.driveType := JToken.AsValue().AsText();
            if JDrive.Get('createdDateTime', JToken) then
                Drive.createdDateTime := JToken.AsValue().AsDateTime();
            if JDrive.Get('lastModifiedDateTime', JToken) then
                Drive.lastModifiedDateTime := JToken.AsValue().AsDateTime();
            if JDrive.Get('webUrl', JToken) then
                Drive.webUrl := JToken.AsValue().AsText();
            Drive.Insert();
        end;
    end;

    Fetch Drive's Items 
    The following code can fetch files and folders from a Drive (Document Library). DriveID is the value of the id property in Drive JsonObject (saved in "Online Drive" table).

    var
        DrivesItemsUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/root/children', Comment = '%1 = Drive ID', Locked = true;

    procedure FetchDrivesItems(AccessToken: Text; DriveID: Text; var DriveItem: Record "Online Drive Item"): Boolean
    var
        JsonResponse: JsonObject;
        JToken: JsonToken;
        IsSucces: Boolean;
    begin
        if HttpGet(AccessToken, StrSubstNo(DrivesItemsUrl, DriveID), JsonResponse) then begin
            if JsonResponse.Get('value', JToken) then
                ReadDriveItems(JToken.AsArray(), DriveID, '', DriveItem);

            exit(true);
        end;
    end;
    Online Drive Item (table 50115)
    To store Files and Folder information

    table 50116 "Online Drive Item"
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
        }

        keys
        {
            key(PK; id)
            {
                Clustered = true;
            }
        }
    }

    ReadDriveItems
    Read JDriveItems JsonArray and saves in "Online Drive Item" table.

    local procedure ReadDriveItems(
        JDriveItems: JsonArray;
        DriveID: Text;
        ParentID: Text;
        var DriveItem: Record "Online Drive Item")
    var
        JToken: JsonToken;
    begin
        foreach JToken in JDriveItems do
            ReadDriveItem(JToken.AsObject(), DriveID, ParentID, DriveItem);
    end;

    local procedure ReadDriveItem(
        JDriveItem: JsonObject;
        DriveID: Text;
        ParentID: Text;
        var DriveItem: Record "Online Drive Item")
    var
        JFile: JsonObject;
        JToken: JsonToken;
    begin

        DriveItem.Init();
        DriveItem.driveId := DriveID;
        DriveItem.parentId := ParentID;

        if JDriveItem.Get('id', JToken) then
            DriveItem.Id := JToken.AsValue().AsText();
        if JDriveItem.Get('name', JToken) then
            DriveItem.Name := JToken.AsValue().AsText();

        if JDriveItem.Get('size', JToken) then
            DriveItem.size := JToken.AsValue().AsBigInteger();

        if JDriveItem.Get('file', JToken) then begin
            DriveItem.IsFile := true;
            JFile := JToken.AsObject();
            if JFile.Get('mimeType', JToken) then
                DriveItem.mimeType := JToken.AsValue().AsText();
        end;

        if JDriveItem.Get('createdDateTime', JToken) then
            DriveItem.createdDateTime := JToken.AsValue().AsDateTime();
        if JDriveItem.Get('webUrl', JToken) then
            DriveItem.webUrl := JToken.AsValue().AsText();
        DriveItem.Insert();
    end;


    Fetch Drive's Child Items
    Following is the code to read Folders and Files from a Folder in a Document Library. ItemID is the value of the id property in DriveItem JsonObject (saved in "Online Drive Item" table).


    var
        DrivesChildItemsUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2/children', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;

    procedure FetchDrivesChildItems(
        AccessToken: Text;
        DriveID: Text;
        ItemID: Text;
        var DriveItem: Record "Online Drive Item"): Boolean
    var
        JsonResponse: JsonObject;
        JToken: JsonToken;
        IsSucces: Boolean;
    begin
        if HttpGet(AccessToken, StrSubstNo(DrivesChildItemsUrl, DriveID, ItemID), JsonResponse) then begin
            if JsonResponse.Get('value', JToken) then
                ReadDriveItems(JToken.AsArray(), DriveID, ItemID, DriveItem);

            exit(true);
        end;
    end;

    Upload a File
    The following code uploads a file into a Document Library and save newly created Drive Item (file) details in "Online Drive Item" table.


    ParentID: Folder's Drive Item ID (should be blank for a file to be uploaded to the root drive)

    FolderPath: Name of the target folder (ex: "/personal/documents"  means file will be saved in documents folder which is a subfolder of personal folder)

    FileName: Name of the file with extension (ex: "readme.pdf")

    Stream: File Content


    var
        UploadUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/root:/%2:/content', Comment = '%1 = Drive ID, %2 = File Name', Locked = true;

    procedure UploadFile(
        AccessToken: Text;
        DriveID: Text;
        ParentID: Text;
        FolderPath: Text;
        FileName: Text;
        var Stream: InStream;
        var OnlineDriveItem: Record "Online Drive Item"): Boolean
    var
        HttpClient: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        JsonResponse: JsonObject;
        IsSucces: Boolean;
        ResponseText: Text;
    begin
        Headers := HttpClient.DefaultRequestHeaders();
        Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));

        RequestMessage.SetRequestUri(
            StrSubstNo(
                UploadUrl,
                DriveID,
                StrSubstNo('%1/%2', FolderPath, FileName)));
        RequestMessage.Method := 'PUT';

        RequestContent.WriteFrom(Stream);
        RequestMessage.Content := RequestContent;

        if HttpClient.Send(RequestMessage, ResponseMessage) then
            if ResponseMessage.IsSuccessStatusCode() then begin
                if ResponseMessage.Content.ReadAs(ResponseText) then begin
                    IsSucces := true;
                    if JsonResponse.ReadFrom(ResponseText) then
                        ReadDriveItem(JsonResponse, DriveID, ParentID, OnlineDriveItem);
                end;
            end else
                if ResponseMessage.Content.ReadAs(ResponseText) then
                    JsonResponse.ReadFrom(ResponseText);

        exit(IsSucces);
    end;

    Download a File
    The following code downloads a file from a Document Library. ItemID is the value of the id property in DriveItem JsonObject (saved in "Online Drive Item" table).

    var
        DownloadUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2/content', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;

    procedure DownloadFile(AccessToken: Text; DriveID: Text; ItemID: Text; var Stream: InStream): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        JsonResponse: JsonObject;
        Content: Text;
        NewDownloadUrl: Text;
    begin
        NewDownloadUrl := StrSubstNo(DownloadUrl, DriveID, ItemID);
        if GetResponse(AccessToken, NewDownloadUrl, Stream) then
            exit(true);
    end;

    Create a Folder
    The following code creates a new Folder in a Document Library.

    ItemID: id of the Parent Folder (optional)

    var
        CreateFolderUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2/children', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;
        CreateRootFolderUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/root/children', Comment = '%1 = Drive ID', Locked = true;

    procedure CreateDriveFolder(
        AccessToken: Text;
        DriveID: Text;
        ItemID: Text;
        FolderName: Text;
        var OnlineDriveItem: Record "Online Drive Item"): Boolean
    var
        HttpClient: HttpClient;
        Headers: HttpHeaders;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        JsonBody: JsonObject;
        RequestText: Text;
        EmptyObject: JsonObject;
        JsonResponse: JsonObject;
    begin
        Headers := HttpClient.DefaultRequestHeaders();
        Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));
        if ItemID = '' then
            RequestMessage.SetRequestUri(StrSubstNo(CreateRootFolderUrl, DriveID))
        else
            RequestMessage.SetRequestUri(StrSubstNo(CreateFolderUrl, DriveID, ItemID));
        RequestMessage.Method := 'POST';

        // Body
        JsonBody.Add('name', FolderName);
        JsonBody.Add('folder', EmptyObject);
        JsonBody.WriteTo(RequestText);
        RequestContent.WriteFrom(RequestText);

        // Content Headers
        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content := RequestContent;

        if HttpClient.Send(RequestMessage, ResponseMessage) then
            if ResponseMessage.IsSuccessStatusCode() then begin
                if ResponseMessage.Content.ReadAs(ResponseText) then begin
                    if JsonResponse.ReadFrom(ResponseText) then
                        ReadDriveItem(JsonResponse, DriveID, ItemID, OnlineDriveItem);

                    exit(true);
                end;
            end;
    end;

    Delete a Drive Item
    The following code deletes a folder or a file from a Document Library. ItemID is the id of the Drive Item (file or folder) saved in "Online Drive Item" table.


    var
        DeleteUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;

    procedure DeleteDriveItem(AccessToken: Text; DriveID: Text; ItemID: Text): Boolean
    var
        HttpClient: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
    begin
        Headers := HttpClient.DefaultRequestHeaders();
        Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));

        RequestMessage.SetRequestUri(StrSubstNo(DeleteUrl, DriveID, ItemID));
        RequestMessage.Method := 'DELETE';

        if HttpClient.Send(RequestMessage, ResponseMessage) then
            if ResponseMessage.IsSuccessStatusCode() then
                exit(true);
    end;

    */

}


/*

page 50100 "Test OAuth2 Flows"
{
    ApplicationArea = All;
    Caption = 'E2E Authentication Flows';
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                Caption = 'Setup';

                field(ClientId; ClientId)
                {
                    ApplicationArea = All;
                    Caption = 'Application (client) ID';
                }
                field(ClientSecret; ClientSecret)
                {
                    ApplicationArea = All;
                    Caption = 'Client secret';
                    ExtendedDatatype = Masked;
                }
                field(RedirectURL; RedirectURL)
                {
                    ApplicationArea = All;
                    Caption = 'Redirect URI';
                    ToolTip = 'When not Redirect Url is specified, the default Redirect Url is used instead.';
                }
                field(AuthorityURL; MicrosoftOAuth2Url)
                {
                    ApplicationArea = All;
                    Caption = 'Authorization Endpoint';
                }
                field(TenantId; AadTenantId)
                {
                    ApplicationArea = All;
                    Caption = 'Directory (tenant) ID';
                    trigger OnValidate()
                    begin
                        OAuthAdminConsentUrl := ReplaceCommonTenant(OAuthAdminConsentUrl);
                        MicrosoftOAuth2Url := ReplaceCommonTenant(MicrosoftOAuth2Url);
                    end;
                }
                field(UserEmail; UserEmail)
                {
                    ApplicationArea = All;
                    Caption = 'User Email';
                }
            }
            group("Authentication")
            {
                Caption = 'Authentication';
                field(GrantType; GrantType)
                {
                    ApplicationArea = All;
                    Caption = 'Grant Type';
                    OptionCaption = 'Client Credentials(v1.0),Authorization Code(v1.0),On-Behalf-Of(v1.0),Authorization Code From Cache(v1.0),On-Behalf-Of Token and Token Cache(v1.0),On-Behalf-Of New Token and Token Cache(v1.0),Client Credentials(v2.0),Authorization Code(v2.0),On-Behalf-Of(v2.0),Authorization Code From Cache(v2.0),On-Behalf-Of Token and Token Cache(v2.0),On-Behalf-Of New Token and Token Cache(v2.0)';

                    trigger OnValidate()
                    begin
                        AuthError := '';
                        AccessToken := '';
                        APICallResponse := '';
                        Result := 'Success';
                        ErrorMessage := '';
                    end;
                }
            }
            group(Results)
            {
                Caption = 'Results';
                Editable = false;
                field(Status; Result)
                {
                    ApplicationArea = All;
                    Caption = 'Result';
                    StyleExpr = ResultStyleExpr;
                }

                field(AccessToken; AccessToken)
                {
                    ApplicationArea = All;
                    Caption = 'Access Token';
                }
                field(TokenCache; TokenCache)
                {
                    ApplicationArea = All;
                    Caption = 'Token Cache';
                }
                field(ErrorMessage; ErrorMessage)
                {
                    ApplicationArea = All;
                    Caption = 'Error Message';
                }
            }
            group(APICall)
            {
                Caption = 'Graph API';
                field(APICallResponse; APICallResponse)
                {
                    ApplicationArea = All;
                    Caption = 'API Call Response';
                    trigger OnAssistEdit()
                    begin
                        if APICallResponse = '' then
                            exit;
                        Message(APICallResponse);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GetToken)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Get Token';
                Image = ServiceSetup;

                trigger OnAction()
                begin
                    case GrantType of
                        GrantType::ClientCredsV1:
                            ClientCredentialsV1();
                        GrantType::AuthCodeV1:
                            AuthorizationCodeV1();
                        GrantType::AuthCodeCacheV1:
                            AcquireAuthCodeTokenFromCacheV1();
                        GrantType::ClientCredsV2:
                            ClientCredentialsV2();
                        GrantType::AuthCodeV2:
                            AuthorizationCodeV2();
                        GrantType::AuthCodeCacheV2:
                            AcquireAuthCodeTokenFromCacheV2();
                    end;
                end;
            }
            action(CallApi)
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Call API';
                Image = ChangeStatus;
                trigger OnAction()
                begin
                    if AccessToken = '' then
                        Error('No Access Token has been acquired');
                    if GrantType in [GrantType::ClientCredsV1, GrantType::ClientCredsV2] then
                        APICallResponse := APICalls.CreateRequest('https://graph.microsoft.com/v1.0/users', AccessToken)
                    else
                        APICallResponse := APICalls.CreateRequest('https://graph.microsoft.com/v1.0/me', AccessToken);
                end;
            }
            action(AdminPermissions)
            {
                ApplicationArea = All;
                Caption = 'Admin Consent';
                Image = Administration;

                trigger OnAction()
                var
                    HasGrantCOnsentFlowSucceeded: Boolean;
                begin
                    OAuth2.RequestClientCredentialsAdminPermissions(ClientId, OAuthAdminConsentUrl, RedirectURL, HasGrantCOnsentFlowSucceeded, AccessToken);

                    if HasGrantCOnsentFlowSucceeded then
                        Message('Admin grant consent has succeeded.')
                    else begin
                        Message('Admin grant consent has failed with the error: ' + AuthError);
                        Result := 'Error';
                    end;
                end;
            }
        }
    }


    var
        OAuth2: Codeunit Oauth2;
        APICalls: Codeunit APICalls;
        GrantType: Option ClientCredsV1,AuthCodeV1,AuthCodeCacheV1,ClientCredsV2,AuthCodeV2,AuthCodeCacheV2;
        ClientId: Text;
        ClientSecret: Text;
        MicrosoftOAuth2Url: Text;
        OAuthAdminConsentUrl: Text;
        ResourceURL: Label 'https://graph.microsoft.com/';
        AadTenantId: Text;
        Result: Text;
        ResultStyleExpr: Text;
        APICallResponse: Text;
        ErrorMessage: Text;
        UserEmail: Text;
        RedirectURL: Text;
        AccessToken: Text;
        TokenCache: Text;
        NewTokenCache: Text;
        AuthError: Text;

    local procedure ClientCredentialsV1()
    begin
        OAuth2.AcquireTokenWithClientCredentials(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, ResourceURL, AccessToken);

        if AccessToken = '' then
            DisplayErrorMessage('')
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure AuthorizationCodeV1()
    var
        PromptInteraction: Enum "Prompt Interaction";
    begin
        OAuth2.AcquireTokenByAuthorizationCode(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, ResourceURL, PromptInteraction::"Admin Consent", AccessToken, AuthError);

        if AccessToken = '' then
            DisplayErrorMessage(AuthError)
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure AcquireAuthCodeTokenFromCacheV1()
    begin
        OAuth2.AcquireAuthorizationCodeTokenFromCache(ClientId, ClientSecret, RedirectURL, MicrosoftOAuth2Url, ResourceURL, AccessToken);

        if AccessToken = '' then
            DisplayErrorMessage('')
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure ClientCredentialsV2()
    var
        Scopes: List of [Text];
    begin
        Scopes.Add(ResourceURL + '.default');

        OAuth2.AcquireTokenWithClientCredentials(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, Scopes, AccessToken);

        if AccessToken = '' then
            DisplayErrorMessage('')
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure AuthorizationCodeV2()
    var
        PromptInteraction: Enum "Prompt Interaction";
        Scopes: List of [Text];
        Scope: Text;
    begin
        Scopes.Add(ResourceURL + 'user.read');
        OAuth2.AcquireTokenByAuthorizationCode(ClientId, ClientSecret, MicrosoftOAuth2Url, RedirectURL, Scopes, PromptInteraction::Consent, AccessToken, AuthError);

        if AccessToken = '' then
            DisplayErrorMessage(AuthError)
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure AcquireAuthCodeTokenFromCacheV2()
    var
        Scopes: List of [Text];
    begin
        Scopes.Add(ResourceURL + 'user.read');
        OAuth2.AcquireAuthorizationCodeTokenFromCache(ClientId, ClientSecret, RedirectURL, MicrosoftOAuth2Url, Scopes, AccessToken);

        if AccessToken = '' then
            DisplayErrorMessage('')
        else
            Result := 'Success';
        SetResultStyle();
    end;

    local procedure ClientCredentialsAdminPermissions()
    var
        HasGrantCOnsentFlowSucceeded: Boolean;
    begin
        OAuth2.RequestClientCredentialsAdminPermissions(ClientId, OAuthAdminConsentUrl, RedirectURL, HasGrantCOnsentFlowSucceeded, AccessToken);

        if HasGrantCOnsentFlowSucceeded then
            Result := 'Success'
        else begin
            ErrorMessage := 'Admin grant consent has failed with the error: ' + AuthError;
            Result := 'Error';
        end;
        SetResultStyle();
    end;

    trigger OnOpenPage()
    var
    begin
        // This function is coming up with 17.1
        // OAuth2.GetDefaultRedirectURL(RedirectURL);
        MicrosoftOAuth2Url := 'https://login.microsoftonline.com/common/oauth2/';
        OAuthAdminConsentUrl := 'https://login.microsoftonline.com/common/adminconsent'
    end;

    local procedure SetResultStyle()
    begin
        if Result = 'Success' then
            ResultStyleExpr := 'Favorable';

        if Result = 'Error' then
            ResultStyleExpr := 'Unfavorable';
    end;

    local procedure DisplayErrorMessage(AuthError: Text)
    begin
        Result := 'Error';
        if AuthError = '' then
            ErrorMessage := 'Authorization has failed.'
        else
            ErrorMessage := StrSubstNo('Authorization has failed with the error: %1.', AuthError);
    end;

    local procedure ReplaceCommonTenant(Authority: Text): Text;
    var
        TenantStartPos: Integer;
        TenantEndPos: Integer;
        AuthorityAfterTenant: Text;
    begin
        TenantStartPos := StrPos(Authority, '.com/') + 5;
        TenantEndPos := TenantStartPos + StrPos(CopyStr(Authority, TenantStartPos), '/') - 1;
        AuthorityAfterTenant := CopyStr(Authority, TenantEndPos);
        if (TenantStartPos > 0) and (TenantEndPos > 0) then
            exit(CopyStr(Authority, 1, TenantStartPos - 1) + AadTenantId + AuthorityAfterTenant)
    end;
}
*/
