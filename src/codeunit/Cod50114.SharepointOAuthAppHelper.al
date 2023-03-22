codeunit 50114 "Sharepoint OAuth App. Helper"
{

    var
        DrivesUrl: Label 'https://graph.microsoft.com/v1.0%1/drives', Locked = true;
        DrivesItemsUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/root/children', Comment = '%1 = Drive ID', Locked = true;
        DrivesChildItemsUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2/children', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;
        DrivesChildItemsNameUrl: Label '?$filter=name eq ''%1''', Comment = '%1 = name file', Locked = true;
        UploadUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/root:/%2:/content', Comment = '%1 = Drive ID, %2 = File Name', Locked = true;
        DownloadUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2/content', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;
        DeleteUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;
        CreateFolderUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2/children', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;
        CreateRootFolderUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/root/children', Comment = '%1 = Drive ID', Locked = true;

    procedure GetAccessToken(AppCode: Code[20]): Text
    var
        OAuth20Application: Record "ZM OAuth 2.0 Application";
        OAuth20AppHelper: Codeunit "Sharepoint OAuth App. Helper";
        MessageText: Text;
    begin
        OAuth20Application.Get(AppCode);
        if not OAuth20AppHelper.RequestAccessToken(OAuth20Application, MessageText) then
            Error(MessageText);
        Commit();

        exit(OAuth20AppHelper.GetAccessToken(OAuth20Application));
    end;

    procedure UploadFileStreeam(FileName: text; var Stream: InStream; MimeType: text; var WebUrl: text): Boolean
    var
        OAuth20Application: Record "ZM OAuth 2.0 Application";
        TempOnlineDriveItem: Record "Online Drive Item" temporary;
        AccessToken: Text;
        FolderID: text;
        FolderPath: text;
        MessageText: Text;
    begin
        OAuth20Application.Get('ERPLINK');
        AccessToken := GetAccessToken(OAuth20Application.Code);

        //obtenemos el id del fichero        
        FolderPath := 'Documentos/Otros';
        FolderID := OAuth20Application.OtersFolderID;
        case MimeType of
            'jpg', 'image/png':
                begin
                    FileName := FileName + '.png';
                    FolderPath := 'Documentos/jpg';
                    FolderID := OAuth20Application.jpgFolderID;
                end;
            'jpeg', 'image/jpeg':
                begin
                    FileName := FileName + '.jpg';
                    FolderPath := 'Documentos/jpg';
                end;
            'gif', 'image/gif':
                begin
                    FileName := FileName + '.gif';
                    FolderPath := 'Documentos/jpg';
                end;
            'pdf', 'application/pdf':
                begin
                    FileName := FileName + '.pdf';
                    FolderPath := 'Documentos/pdf';
                    FolderID := OAuth20Application.pdfFolderID;
                end;
            'xml', 'application/xml':
                begin
                    FileName := FileName + '.xml';
                end;
            'mpg', 'audio/mpeg':
                begin
                    FileName := FileName + '.mp3';
                end;
            'x-wav', 'audio/x-wav':
                begin
                    FileName := FileName + '.wav';
                end;
            'mp4', 'video/mp4':
                begin
                    FileName := FileName + '.mp4';
                end;
            'msvideo', 'video/x-msvideo':
                begin
                    FileName := FileName + '.avi';
                end;
            'html', 'text/html':
                begin
                    FileName := FileName + '.html';
                end;
            'txt', 'text/plain':
                begin
                    FileName := FileName + '.txt';
                end;
            'dxf', 'application/dxf':
                begin
                    FileName := FileName + '.dxf';
                    FolderPath := 'Documentos/dxf';
                    FolderID := OAuth20Application.dxfFolderID;
                end;
            'step', 'application/step':
                begin
                    FileName := FileName + '.step';
                    FolderPath := 'Documentos/step';
                    FolderID := OAuth20Application.StepFolderID;
                end;
            else begin
                FileName := FileName;
                FolderPath := 'Documentos/Otros';
                FolderID := OAuth20Application.OtersFolderID;
            end;
        end;

        // if FetchDrivesChildItemsName(AccessToken, OAuth20Application.RootFolderID, FolderID, TempOnlineDriveItem, name) then begin

        if UploadFile(AccessToken, OAuth20Application.RootFolderID, FolderID, FolderPath, FileName, Stream, TempOnlineDriveItem) then begin
            WebUrl := TempOnlineDriveItem.webUrl;
            exit(true);
        end;
        //DownloadFromStream(Stream, '', '', '', name);   
    end;

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


    procedure DownloadFileName(name: text; var Stream: InStream; FileExt: text): Boolean
    var
        OAuth20Application: Record "ZM OAuth 2.0 Application";
        TempOnlineDriveItem: Record "Online Drive Item" temporary;
        AccessToken: Text;
        FolderID: text;
        MessageText: Text;
    begin
        OAuth20Application.Get('ERPLINK');
        AccessToken := GetAccessToken(OAuth20Application.Code);


        //obtenemos el id del fichero
        case FileExt of
            'pdf':
                FolderID := OAuth20Application.pdfFolderID;
            'jpg':
                FolderID := OAuth20Application.jpgFolderID;
            'dxf':
                FolderID := OAuth20Application.dxfFolderID;
            'step':
                FolderID := OAuth20Application.StepFolderID;
        end;

        if FetchDrivesChildItemsName(AccessToken, OAuth20Application.RootFolderID, FolderID, TempOnlineDriveItem, name) then begin

            // bajamos el fichero
            if DownloadFile(AccessToken, OAuth20Application.RootFolderID, TempOnlineDriveItem.id, Stream) then
                exit(true);
            //DownloadFromStream(Stream, '', '', '', name);
        end;
    end;

    procedure DownloadFile(AccessToken: Text; DriveID: Text; ItemID: Text; var Stream: InStream): Boolean
    var
        TempBlob: Record TempBlob;
        OStream: OutStream;
        JsonResponse: JsonObject;
        Content: Text;
        NewDownloadUrl: Text;
    begin
        NewDownloadUrl := StrSubstNo(DownloadUrl, DriveID, ItemID);
        if GetResponse(AccessToken, NewDownloadUrl, Stream) then
            exit(true);
    end;

    // procedure CreateDriveFolder(
    //     AccessToken: Text;
    //     DriveID: Text;
    //     ItemID: Text;
    //     FolderName: Text;
    //     var OnlineDriveItem: Record "Online Drive Item"): Boolean
    // var
    //     HttpClient: HttpClient;
    //     Headers: HttpHeaders;
    //     ContentHeaders: HttpHeaders;
    //     RequestMessage: HttpRequestMessage;
    //     RequestContent: HttpContent;
    //     ResponseMessage: HttpResponseMessage;
    //     ResponseText: Text;
    //     JsonBody: JsonObject;
    //     RequestText: Text;
    //     EmptyObject: JsonObject;
    //     JsonResponse: JsonObject;
    // begin
    //     Headers := HttpClient.DefaultRequestHeaders();
    //     Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));
    //     if ItemID = '' then
    //         RequestMessage.SetRequestUri(StrSubstNo(CreateRootFolderUrl, DriveID))
    //     else
    //         RequestMessage.SetRequestUri(StrSubstNo(CreateFolderUrl, DriveID, ItemID));
    //     RequestMessage.Method := 'POST';

    //     // Body
    //     JsonBody.Add('name', FolderName);
    //     JsonBody.Add('folder', EmptyObject);
    //     JsonBody.WriteTo(RequestText);
    //     RequestContent.WriteFrom(RequestText);

    //     // Content Headers
    //     RequestContent.GetHeaders(ContentHeaders);
    //     ContentHeaders.Remove('Content-Type');
    //     ContentHeaders.Add('Content-Type', 'application/json');

    //     RequestMessage.Content := RequestContent;

    //     if HttpClient.Send(RequestMessage, ResponseMessage) then
    //         if ResponseMessage.IsSuccessStatusCode() then begin
    //             if ResponseMessage.Content.ReadAs(ResponseText) then begin
    //                 if JsonResponse.ReadFrom(ResponseText) then
    //                     ReadDriveItem(JsonResponse, DriveID, ItemID, OnlineDriveItem);

    //                 exit(true);
    //             end;
    //         end
    //         else begin
    //             ResponseMessage.Content.ReadAs(ResponseText);
    //             exit(false);
    //         end;
    // end;
    procedure DeleteDriveItemName(Name: text; FileExt: Text): Boolean
    var
        OAuth20Application: Record "ZM OAuth 2.0 Application";
        TempOnlineDriveItem: Record "Online Drive Item" temporary;
        AccessToken: Text;
        FolderID: text;
    begin
        OAuth20Application.Get('ERPLINK');
        AccessToken := GetAccessToken(OAuth20Application.Code);


        //obtenemos el id del fichero
        case FileExt of
            'pdf':
                FolderID := OAuth20Application.pdfFolderID;
            'jpg':
                FolderID := OAuth20Application.jpgFolderID;
            'dxf':
                FolderID := OAuth20Application.dxfFolderID;
            'step':
                FolderID := OAuth20Application.StepFolderID;
        end;

        if FetchDrivesChildItemsName(AccessToken, OAuth20Application.RootFolderID, FolderID, TempOnlineDriveItem, name) then begin

            // borramos el fichero
            if DeleteDriveItem(AccessToken, OAuth20Application.RootFolderID, TempOnlineDriveItem.id) then
                exit(true);
            //DownloadFromStream(Stream, '', '', '', name);
        end;
    end;

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

    // procedure FetchDrives(AccessToken: Text; var Drive: Record "Online Drive"; DrivesId: text): Boolean
    // var
    //     JsonResponse: JsonObject;
    //     JToken: JsonToken;
    //     Url: text;
    // begin
    //     if DrivesId = '' then
    //         Url := StrSubstNo(DrivesUrl, '')
    //     else
    //         Url := StrSubstNo(DrivesUrl, '/' + DrivesId);
    //     if HttpGet(AccessToken, Url, JsonResponse) then begin
    //         if JsonResponse.Get('value', JToken) then
    //             ReadDrives(JToken.AsArray(), Drive);

    //         exit(true);
    //     end;
    // end;

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

    procedure FetchDrivesChildItemsName(
         AccessToken: Text;
         DriveID: Text;
         ItemID: Text;
         var DriveItem: Record "Online Drive Item";
         Name: text): Boolean
    var
        JsonResponse: JsonObject;
        JToken: JsonToken;
        IsSucces: Boolean;
    begin
        if HttpGet(AccessToken, StrSubstNo(DrivesChildItemsUrl + StrSubstNo(DrivesChildItemsNameUrl, Name), DriveID, ItemID), JsonResponse) then begin
            if JsonResponse.Get('value', JToken) then
                ReadDriveItems(JToken.AsArray(), DriveID, ItemID, DriveItem);

            if DriveItem.FindFirst() then
                exit(true);
        end;
    end;
    // local procedure GetDriveID(var Drive: Record "Online Drive"; Name: Text): Text
    // begin
    //     Drive.SetRange(Name, Name);
    //     if Drive.FindFirst() then
    //         exit(Drive.Id);
    // end;

    // local procedure GetItemID(var DriveItem: Record "Online Drive Item"; DriveID: Text; Name: Text): Text
    // begin
    //     exit(GetItemID(DriveItem, DriveID, '', Name));
    // end;

    // local procedure GetItemID(
    //     var DriveItem: Record "Online Drive Item";
    //     DriveID: Text;
    //     ItemID: Text;
    //     Name: Text): Text
    // begin
    //     DriveItem.SetRange(driveID, DriveID);
    //     DriveItem.SetRange(parentId, ItemID);
    //     DriveItem.SetRange(Name, Name);
    //     if DriveItem.FindFirst() then
    //         exit(DriveItem.Id);
    // end;

    // local procedure ReadDrives(JDrives: JsonArray; var Drive: Record "Online Drive")
    // var
    //     JDriveItem: JsonToken;
    //     JDrive: JsonObject;
    //     JToken: JsonToken;
    // begin
    //     foreach JDriveItem in JDrives do begin
    //         JDrive := JDriveItem.AsObject();

    //         Drive.Init();
    //         if JDrive.Get('id', JToken) then
    //             Drive.Id := JToken.AsValue().AsText();
    //         if JDrive.Get('name', JToken) then
    //             Drive.Name := JToken.AsValue().AsText();
    //         if JDrive.Get('description', JToken) then
    //             Drive.description := JToken.AsValue().AsText();
    //         if JDrive.Get('driveType', JToken) then
    //             Drive.driveType := JToken.AsValue().AsText();
    //         if JDrive.Get('createdDateTime', JToken) then
    //             Drive.createdDateTime := JToken.AsValue().AsDateTime();
    //         if JDrive.Get('lastModifiedDateTime', JToken) then
    //             Drive.lastModifiedDateTime := JToken.AsValue().AsDateTime();
    //         if JDrive.Get('webUrl', JToken) then
    //             Drive.webUrl := JToken.AsValue().AsText();
    //         Drive.Insert();
    //     end;
    // end;

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

    local procedure ReadDriveItem(JDriveItem: JsonObject; DriveID: Text; ParentID: Text; var DriveItem: Record "Online Drive Item")
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

    local procedure GetResponse(AccessToken: Text; Url: Text; var Stream: InStream): Boolean
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        IsSucces: Boolean;
    begin
        Headers := Client.DefaultRequestHeaders();
        Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));

        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method := 'GET';

        if Client.Send(RequestMessage, ResponseMessage) then
            if ResponseMessage.IsSuccessStatusCode() then begin
                if ResponseMessage.Content.ReadAs(Stream) then
                    IsSucces := true;
            end else
                ResponseMessage.Content.ReadAs(Stream);

        exit(IsSucces);
    end;

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


    procedure RequestAccessToken(var Application: Record "Zm OAuth 2.0 Application"; var MessageTxt: Text): Boolean
    var
        IsSuccess: Boolean;
        JAccessToken: JsonObject;
        RefreshToken: Text;
        ElapsedSecs: Integer;
    begin
        /*if Application.Status = Application.Status::Connected then begin
            ElapsedSecs := Round((CurrentDateTime() - Application."Authorization Time") / 1000, 1, '>');
            if ElapsedSecs < Application."Expires In" then
                exit(true)
            else
                if RefreshAccessToken(Application, MessageTxt) then
                    exit(true);
        end;
*/
        Application."Authorization Time" := CurrentDateTime();
        IsSuccess := AcquireAuthorizationToken(
            Application."Grant Type",
            Application."User Name",
            Application.Password,
            Application."Client ID",
            Application."Client Secret",
            Application."Authorization URL",
            Application."Access Token URL",
            Application."Redirect URL",
            Application."Auth. URL Parms",
            Application.Scope,
            JAccessToken);

        if IsSuccess then begin
            ReadTokenJson(Application, JAccessToken);
            Application.Status := Application.Status::Connected;
        end else begin
            MessageTxt := GetErrorDescription(JAccessToken);
            Application.Status := Application.Status::Error;
        end;

        Application.Modify();
        exit(IsSuccess);
    end;

    procedure RefreshAccessToken(var Application: Record "ZM OAuth 2.0 Application"; var MessageTxt: Text): Boolean
    var
        JAccessToken: JsonObject;
        RefreshToken: Text;
        IsSuccess: Boolean;
    begin
        RefreshToken := GetRefreshToken(Application);
        if RefreshToken = '' then
            exit;

        Application."Authorization Time" := CurrentDateTime();
        IsSuccess := AcquireTokenByRefreshToken(
            Application."Access Token URL",
            Application."Client ID",
            Application."Client Secret",
            Application."Redirect URL",
            RefreshToken,
            JAccessToken);

        if IsSuccess then begin
            ReadTokenJson(Application, JAccessToken);
            Application.Status := Application.Status::Connected;
        end else begin
            MessageTxt := GetErrorDescription(JAccessToken);
            Application.Status := Application.Status::Error;
        end;

        Application.Modify();
        exit(IsSuccess);
    end;

    procedure GetAccessToken(var Application: Record "ZM OAuth 2.0 Application"): Text
    var
        IStream: InStream;
        Buffer: TextBuilder;
        Line: Text;
    begin
        Application.CalcFields("Access Token");
        if Application."Access Token".HasValue then begin
            Application."Access Token".CreateInStream(IStream, TextEncoding::UTF8);
            while not IStream.EOS do begin
                IStream.ReadText(Line, 1024);
                Buffer.Append(Line);
            end;
        end;

        exit(Buffer.ToText())
    end;

    procedure GetRefreshToken(var Application: Record "ZM OAuth 2.0 Application"): Text
    var
        IStream: InStream;
        Buffer: TextBuilder;
        Line: Text;
    begin
        Application.CalcFields("Refresh Token");
        if Application."Refresh Token".HasValue then begin
            Application."Refresh Token".CreateInStream(IStream, TextEncoding::UTF8);
            while not IStream.EOS do begin
                IStream.ReadText(Line, 1024);
                Buffer.Append(Line);
            end;
        end;

        exit(Buffer.ToText())
    end;

    local procedure GetErrorDescription(JAccessToken: JsonObject): Text
    var
        JToken: JsonToken;
    begin
        if (JAccessToken.Get('error_description', JToken)) then
            exit(JToken.AsValue().AsText());
    end;

    local procedure ReadTokenJson(var Application: Record "ZM OAuth 2.0 Application"; JAccessToken: JsonObject)
    var
        TempBlob: Record TempBlob;
        JToken: JsonToken;
        Property: Text;
        OStream: OutStream;
    begin
        foreach Property in JAccessToken.Keys() do begin
            JAccessToken.Get(Property, JToken);
            case Property of
                'token_type',
                'scope':
                    ;
                'expires_in':
                    Application."Expires In" := JToken.AsValue().AsInteger();
                'ext_expires_in':
                    Application."Ext. Expires In" := JToken.AsValue().AsInteger();
                'access_token':
                    begin
                        Application."Access Token".CreateOutStream(OStream, TextEncoding::UTF8);
                        OStream.WriteText(JToken.AsValue().AsText());
                    end;
                'refresh_token':
                    begin
                        Application."Refresh Token".CreateOutStream(OStream, TextEncoding::UTF8);
                        OStream.WriteText(JToken.AsValue().AsText());
                    end;
                else
                    Error('Invalid Access Token Property %1, Value:  %2', Property, JToken.AsValue().AsText());
            end;
        end;
    end;

    procedure AcquireAuthorizationToken(
     GrantType: Enum "Auth. Grant Type";
     UserName: Text;
     Password: Text;
     ClientId: Text;
     ClientSecret: Text;
     AuthorizationURL: Text;
     AccessTokenURL: Text;
     RedirectURL: Text;
     AuthURLParms: Text;
     Scope: Text;
     JAccessToken: JsonObject): Boolean
    var
        AuthRequestURL: Text;
        AuthCode: Text;
        State: Text;
        IsSuccess: Boolean;
    begin

        exit(
            AcquireToken(
                GrantType,
                AuthCode,
                UserName,
                Password,
                ClientId,
                ClientSecret,
                Scope,
                RedirectURL,
                AccessTokenURL,
                JAccessToken));
    end;

    local procedure AcquireToken(
        GrantType: Enum "Auth. Grant Type";
        AuthorizationCode: Text;
        UserName: Text;
        Password: Text;
        ClientId: Text;
        ClientSecret: Text;
        Scope: Text;
        RedirectURL: Text;
        TokenEndpointURL: Text;
        JAccessToken: JsonObject): Boolean;
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ContentText: Text;
        ResponseText: Text;
        IsSuccess: Boolean;
    begin
        //        UserName := 'sothis@quilinox.com';
        //        Password := 'Sihtos2021&';
        case GrantType of
            GrantType::"Authorization Code":
                ContentText := 'grant_type=authorization_code' +
                    '&code=' + AuthorizationCode +
                    '&redirect_uri=' + RedirectURL + // UriBuilder.EscapeDataString(RedirectURL) +
                    '&client_id=' + ClientId + //UriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + ClientSecret; // UriBuilder.EscapeDataString(ClientSecret);
            GrantType::"Password Credentials":
                ContentText := 'grant_type=password' +
                    '&username=' + UserName + //riBuilder.EscapeDataString(UserName) +
                    '&password=' + Password + //UriBuilder.EscapeDataString(Password) +
                    '&client_id=' + ClientId +//UriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + ClientSecret + //UriBuilder.EscapeDataString(ClientSecret) +
                    '&scope=' + Scope; // UriBuilder.EscapeDataString(Scope);
            GrantType::"Client Credentials":
                ContentText := 'grant_type=client_credentials' +
                    '&client_id=' + ClientId + // UriBuilder.EscapeDataString(ClientId) +
                    '&client_secret=' + ClientSecret + // UriBuilder.EscapeDataString(ClientSecret) +
                    '&scope=' + Scope; //UriBuilder.EscapeDataString(Scope);
        end;
        Content.WriteFrom(ContentText);

        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Method := 'POST';
        Request.SetRequestUri(TokenEndpointURL);
        Request.Content(Content);

        if Client.Send(Request, Response) then
            if Response.IsSuccessStatusCode() then begin
                if Response.Content.ReadAs(ResponseText) then
                    IsSuccess := JAccessToken.ReadFrom(ResponseText);
            end else
                if Response.Content.ReadAs(ResponseText) then
                    JAccessToken.ReadFrom(ResponseText);

        exit(IsSuccess);
    end;


    procedure AcquireTokenByRefreshToken(
        TokenEndpointURL: Text;
        ClientId: Text;
        ClientSecret: Text;
        RedirectURL: Text;
        RefreshToken: Text;
        JAccessToken: JsonObject): Boolean
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ContentText: Text;
        ResponseText: Text;
        IsSuccess: Boolean;
    begin
        ContentText := 'grant_type=refresh_token' +
            '&refresh_token=' + RefreshToken + // UriBuilder.EscapeDataString(RefreshToken) +
            '&redirect_uri=' + RedirectURL + //UriBuilder.EscapeDataString(RedirectURL) +
            '&client_id=' + ClientId + //UriBuilder.EscapeDataString(ClientId) +
            '&client_secret=' + ClientSecret; //UriBuilder.EscapeDataString(ClientSecret);
        Content.WriteFrom(ContentText);

        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Method := 'POST';
        Request.SetRequestUri(TokenEndpointURL);
        Request.Content(Content);

        if Client.Send(Request, Response) then
            if Response.IsSuccessStatusCode() then begin
                if Response.Content.ReadAs(ResponseText) then
                    IsSuccess := JAccessToken.ReadFrom(ResponseText);
            end else
                if Response.Content.ReadAs(ResponseText) then
                    JAccessToken.ReadFrom(ResponseText);

        exit(IsSuccess);
    end;

    procedure GetOAuthProperties(AuthorizationCode: Text; var CodeOut: Text; var StateOut: Text)
    begin
        if AuthorizationCode = '' then begin
            exit;
        end;

        ReadAuthCodeFromJson(AuthorizationCode);
        CodeOut := GetPropertyFromCode(AuthorizationCode, 'code');
        StateOut := GetPropertyFromCode(AuthorizationCode, 'state');
    end;

    local procedure GetAuthRequestURL(
        ClientId: Text;
        ClientSecret: Text;
        AuthRequestURL: Text;
        RedirectURL: Text;
        State: Text;
        Scope: Text;
        AuthURLParms: Text): Text
    begin
        if (ClientId = '') or (RedirectURL = '') or (state = '') then
            exit('');

        AuthRequestURL := AuthRequestURL + '?' +
            'client_id=' + ClientId + // UriBuilder.EscapeDataString(ClientId) +
            '&redirect_uri=' + RedirectURL + // UriBuilder.EscapeDataString(RedirectURL) +
            '&state=' + State + //UriBuilder.EscapeDataString(State) +
            '&scope=' + Scope + //UriBuilder.EscapeDataString(Scope) +
            '&response_type=code';

        if AuthURLParms <> '' then
            AuthRequestURL := AuthRequestURL + '&' + AuthURLParms;

        exit(AuthRequestURL);
    end;

    local procedure ReadAuthCodeFromJson(var AuthorizationCode: Text)
    var
        JObject: JsonObject;
        JToken: JsonToken;
    begin
        if not JObject.ReadFrom(AuthorizationCode) then
            exit;

        if not JObject.Get('code', JToken) then
            exit;

        if not JToken.IsValue() then
            exit;

        if not JToken.WriteTo(AuthorizationCode) then
            exit;

        AuthorizationCode := AuthorizationCode.TrimStart('"').TrimEnd('"');
    end;

    local procedure GetPropertyFromCode(CodeTxt: Text; Property: Text): Text
    var
        PosProperty: Integer;
        PosValue: Integer;
        PosEnd: Integer;
    begin
        PosProperty := StrPos(CodeTxt, Property);
        if PosProperty = 0 then
            exit('');

        PosValue := PosProperty + StrPos(CopyStr(Codetxt, PosProperty), '=');
        PosEnd := PosValue + StrPos(CopyStr(CodeTxt, PosValue), '&');

        if PosEnd = PosValue then
            exit(CopyStr(CodeTxt, PosValue, StrLen(CodeTxt) - 1));

        exit(CopyStr(CodeTxt, PosValue, PosEnd - PosValue - 1));
    end;
}
