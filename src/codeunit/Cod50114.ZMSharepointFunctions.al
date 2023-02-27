codeunit 50114 "ZM Sharepoint Functions"
{
    trigger OnRun()
    begin

    end;

    // var
    //     ZummoIncFunctions: Codeunit "Zummo Inn. IC Functions";
    //     lbloAut: Label 'sharepoint';
    //     SitesUrl: Label 'https://graph.microsoft.com/v1.0/sites', Locked = true;
    //     DrivesUrl: Label 'https://graph.microsoft.com/v1.0//%1/drives', Locked = true;
    //     DrivesItemsUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/root/children', Comment = '%1 = Drive ID', Locked = true;
    //     DrivesChildItemsUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/%2/children', Comment = '%1 = Drive ID, %2 = Item ID', Locked = true;
    //     UploadUrl: Label 'https://graph.microsoft.com/v1.0/drives/%1/items/root:/%2:/content', Comment = '%1 = Drive ID, %2 = File Name', Locked = true;

    // procedure UploadFileOne(var OnlineDriveItem: Record "ZM Online Drive")
    // var
    //     DriveId: Label 'b!Cu8nOuEVwkeC04vs82WUBO-FdIVavSVEj1wihPBO4qgAm_JGdqzGQIlTwVXIUMpK/items/012ST4ANJPBBRNWHNSIRFYOZWZBDYRYPWT';
    //     ParentId: Label '';
    //     FileinStr: InStream;
    //     FileName: text;
    // begin
    //     UploadIntoStream('Dialog', '', '', FileName, FileinStr);
    //     UploadFile(DriveId, ParentId, 'C.\Zummo\', FileName, FileinStr, OnlineDriveItem);
    // end;

    // procedure FetchSite(var Site: Record File): Boolean
    // var
    //     JsonResponse: JsonObject;
    //     JToken: JsonToken;
    //     AccessToken: Text;
    // begin
    //     if GetAccessToken(AccessToken) then begin
    //         if HttpGet(AccessToken, SitesUrl, JsonResponse) then begin
    //             if JsonResponse.Get('value', JToken) then
    //                 readSites(JToken.AsArray(), Site);

    //             exit(true);
    //         end;
    //     end;
    // end;

    // procedure FetchDrives(var Drive: Record "ZM Online Drive"): Boolean
    // var
    //     JsonResponse: JsonObject;
    //     JToken: JsonToken;
    //     AccessToken: Text;
    // //https://zummoinnovaciones.sharepoint.com/sites/ERPLiNK/_api/site obtener id sharepoint
    // begin
    //     if GetAccessToken(AccessToken) then begin
    //         if HttpGet(AccessToken, StrSubstNo(DrivesUrl, '3a27ef0a-15e1-47c2-82d3-8becf3659404'), JsonResponse) then begin
    //             if JsonResponse.Get('value', JToken) then
    //                 ReadDrives(JToken.AsArray(), Drive);

    //             exit(true);
    //         end;
    //     end;
    // end;

    // procedure FetchDrivesItems(var DriveItem: Record "ZM Online Drive"): Boolean
    // var
    //     JsonResponse: JsonObject;
    //     JToken: JsonToken;
    //     IsSucces: Boolean;
    //     AccessToken: Text;
    //     DriveId: Label '424ef0a3-de4f-45e9-b562-a3792abc71ad';
    // begin
    //     if GetAccessToken(AccessToken) then begin
    //         if HttpGet(AccessToken, StrSubstNo(DrivesItemsUrl, DriveId), JsonResponse) then begin
    //             if JsonResponse.Get('value', JToken) then
    //                 ReadDriveItems(JToken.AsArray(), DriveId, '', DriveItem);

    //             exit(true);
    //         end;
    //     end;
    // end;

    // local procedure ReadDriveItems(JDriveItems: JsonArray; DriveID: Text; ParentID: Text; var DriveItem: Record "ZM Online Drive")
    // var
    //     JToken: JsonToken;
    // begin
    //     foreach JToken in JDriveItems do
    //         ReadDriveItem(JToken.AsObject(), DriveID, ParentID, DriveItem);
    // end;

    // local procedure ReadDriveItem(JDriveItem: JsonObject; DriveID: Text; ParentID: Text; var DriveItem: Record "ZM Online Drive")
    // var
    //     JFile: JsonObject;
    //     JToken: JsonToken;
    // begin

    //     DriveItem.Init();
    //     DriveItem.driveId := DriveID;
    //     DriveItem.parentId := ParentID;
    //     if JDriveItem.Get('name', JToken) then
    //         DriveItem.Name := JToken.AsValue().AsText();

    //     if JDriveItem.Get('size', JToken) then
    //         DriveItem.size := JToken.AsValue().AsBigInteger();

    //     if JDriveItem.Get('file', JToken) then begin
    //         DriveItem.isFile := true;
    //     end;

    //     if JDriveItem.Get('createdDateTime', JToken) then begin
    //         DriveItem.createdDateTime := JToken.AsValue().AsDateTime();
    //     end;
    //     if JDriveItem.Get('webUrl', JToken) then
    //         DriveItem.webUrl := JToken.AsValue().AsText();
    //     DriveItem.Insert();
    // end;

    // procedure FetchDrivesChildItems(DriveID: Text; ItemID: Text; var DriveItem: record "ZM Online Drive"): Boolean
    // var
    //     JsonResponse: JsonObject;
    //     JToken: JsonToken;
    //     AccessToken: Text;
    //     IsSucces: Boolean;
    // begin
    //     if GetAccessToken(AccessToken) then begin
    //         if HttpGet(AccessToken, StrSubstNo(DrivesChildItemsUrl, DriveID, ItemID), JsonResponse) then begin
    //             if JsonResponse.Get('value', JToken) then
    //                 ReadDriveItems(JToken.AsArray(), DriveID, ItemID, DriveItem);

    //             exit(true);
    //         end;
    //     end;
    // end;

    // local procedure ReadSites(JSites: JsonArray; var Sites: Record File)
    // var
    //     JDriveItem: JsonToken;
    //     JDrive: JsonObject;
    //     JToken: JsonToken;
    // begin
    //     foreach JDriveItem in JSites do begin
    //         JDrive := JDriveItem.AsObject();

    //         Sites.Init();
    //         if JDrive.Get('displayName', JToken) then
    //             Sites.Name := JToken.AsValue().AsText();
    //         if JDrive.Get('webUrl', JToken) then
    //             Sites.Path := JToken.AsValue().AsText();
    //         Sites.Insert();
    //     end;
    // end;

    // local procedure ReadDrives(JDrives: JsonArray; var Drive: Record "ZM Online Drive")
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

    // procedure UploadFile(DriveID: Text; ParentID: Text; FolderPath: Text; FileName: Text; var Stream: InStream; var OnlineDriveItem: Record "ZM Online Drive"): Boolean
    // var
    //     HttpClient: HttpClient;
    //     Headers: HttpHeaders;
    //     ContentHeaders: HttpHeaders;
    //     RequestMessage: HttpRequestMessage;
    //     RequestContent: HttpContent;
    //     ResponseMessage: HttpResponseMessage;
    //     JsonResponse: JsonObject;
    //     IsSucces: Boolean;
    //     AccessToken: Text;
    //     ResponseText: Text;
    //     parametros: text;
    // begin
    //     if GetAccessToken(AccessToken) then begin
    //         Headers := HttpClient.DefaultRequestHeaders();
    //         Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));

    //         RequestContent.GetHeaders(ContentHeaders);

    //         RequestMessage.SetRequestUri(StrSubstNo(UploadUrl, DriveID, StrSubstNo('%1/%2', FolderPath, FileName)));
    //         RequestMessage.Method := 'PUT';

    //         RequestContent.WriteFrom(Stream);
    //         RequestMessage.Content := RequestContent;

    //         RequestContent.WriteFrom(parametros);
    //         ContentHeaders.Remove('Content-Type');
    //         ContentHeaders.Add('Content-Type', 'application/json');


    //         if HttpClient.Send(RequestMessage, ResponseMessage) then
    //             if ResponseMessage.IsSuccessStatusCode() then begin
    //                 if ResponseMessage.Content.ReadAs(ResponseText) then begin
    //                     IsSucces := true;
    //                     if JsonResponse.ReadFrom(ResponseText) then
    //                         ReadDriveItem(JsonResponse, DriveID, ParentID, OnlineDriveItem);
    //                 end;
    //             end else
    //                 if ResponseMessage.Content.ReadAs(ResponseText) then
    //                     JsonResponse.ReadFrom(ResponseText);

    //         exit(IsSucces);
    //     end;
    // end;

    // // procedure DownloadFile(AccessToken: Text; DriveID: Text; ItemID: Text; var Stream: InStream): Boolean
    // // var
    // //     TempBlob: Codeunit "Temp Blob";
    // //     OStream: OutStream;
    // //     JsonResponse: JsonObject;
    // //     Content: Text;
    // //     NewDownloadUrl: Text;
    // // begin
    // //     NewDownloadUrl := StrSubstNo(DownloadUrl, DriveID, ItemID);
    // //     if GetResponse(AccessToken, NewDownloadUrl, Stream) then
    // //         exit(true);
    // // end;

    // local procedure HttpGet(AccessToken: Text; Url: Text; var JResponse: JsonObject): Boolean
    // var
    //     Client: HttpClient;
    //     Headers: HttpHeaders;
    //     RequestMessage: HttpRequestMessage;
    //     ResponseMessage: HttpResponseMessage;
    //     RequestContent: HttpContent;
    //     ResponseText: Text;
    //     IsSucces: Boolean;
    // begin
    //     Headers := Client.DefaultRequestHeaders();
    //     Headers.Add('Authorization', StrSubstNo('Bearer %1', AccessToken));

    //     RequestMessage.SetRequestUri(Url);
    //     RequestMessage.Method := 'GET';

    //     if Client.Send(RequestMessage, ResponseMessage) then
    //         if ResponseMessage.IsSuccessStatusCode() then begin
    //             if ResponseMessage.Content.ReadAs(ResponseText) then
    //                 IsSucces := true;
    //         end else
    //             ResponseMessage.Content.ReadAs(ResponseText);

    //     JResponse.ReadFrom(ResponseText);
    //     exit(IsSucces);
    // end;


    // procedure GetAccessToken(var AccesToekn: Text): Boolean
    // var
    //     HttpClient: HttpClient;
    //     HttpContent: HttpContent;
    //     HttpResponseMessage: HttpResponseMessage;
    //     HttpHeaders: HttpHeaders;
    //     respuestaJSON: JsonObject;
    //     Url: Text;
    //     formdata: Text;
    //     ResponseText: Text;
    //     StatusCodeErr: Label 'Status code: %1\ Description: %2 \%3', comment = 'ESP="Status code: %1\ Description: %2 \%3"';
    //     ResourceUrlTxt: Label 'https://login.microsoftonline.com/', Locked = true;
    //     RedirectURLTxt: Label 'http://localhost:8080/BC160/OAuthLanding.htm', Locked = true;
    //     AccessTokenURLTxt: Label 'acacbbb6-3305-4b91-a580-c523b448d612/oauth2/v2.0/token', Locked = true;

    // begin
    //     Url := ResourceUrlTxt + AccessTokenURLTxt;
    //     formdata := FormData_Oauth2Token();
    //     HttpContent.WriteFrom(formdata);
    //     HttpContent.GetHeaders(HttpHeaders);
    //     HttpHeaders.Clear();
    //     HttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
    //     HttpClient.Post(Url, HttpContent, HttpResponseMessage);
    //     If not HttpResponseMessage.IsSuccessStatusCode() then begin
    //         HttpResponseMessage.Content.ReadAs(formdata);
    //         Error(StatusCodeErr, HttpResponseMessage.HttpStatusCode(), HttpResponseMessage.ReasonPhrase(), formdata);
    //         exit(false);
    //     end;
    //     HttpResponseMessage.Content().ReadAs(ResponseText);

    //     respuestaJSON.ReadFrom(ResponseText);

    //     AccesToekn := ZummoIncFunctions.GetJSONItemFieldText(respuestaJSON.AsToken(), 'access_token');
    //     exit(true);

    // end;

    // local procedure FormData_Oauth2Token() FormDataOauth2Token: Text
    // var
    //     OAuthAuthorityUrlTxt: Label 'https://graph.microsoft.com/.default', Locked = true;
    //     ClientID: Text;
    //     ClientSecret: Text;
    //     scope: Text;
    //     grant_type: Text;
    //     tb: TextBuilder;
    //     ClientIdTxt: Label 'bbaebd13-7b64-4a79-806f-1c928c9f41c9', Locked = true;
    //     ClientSecrettxt: Label 'Ar48Q~CqI~dJmbkBliS2dQNY2juzHa1yNcvo3bKa', Locked = true;

    // begin
    //     scope := OAuthAuthorityUrlTxt;
    //     grant_type := 'client_credentials';
    //     ClientID := ClientIdTxt;
    //     ClientSecret := ClientSecrettxt;
    //     tb.AppendLine('grant_type=' + grant_type);
    //     tb.AppendLine('&' + 'client_id=' + ClientID);
    //     tb.AppendLine('&' + 'client_secret=' + ClientSecret);
    //     tb.Append('&' + 'scope=' + scope);
    //     FormDataOauth2Token := tb.ToText();
    // end;

    procedure DownloadPDFfromURL()
    var
        Instr: InStream;
        Filename: Text;
        Response: HttpResponseMessage;
        Content: HttpContent;
        RequestHeaders: Dictionary of [Text, Text];
        Method: Enum "Web Request Method";
        SaveFileDialogFilterMsg: Label 'PDF Files (*.pdf)|*.pdf';
        SaveFileDialogTitleMsg: Label 'Save PDF file';
    begin
        Filename := 'BEYONDCloudConnector.pdf';
        PerformWebRequest('https://en.beyond-cloudconnector.de/_files/ugd/96eaf6_16d4b7b24ce249339594fb661dbb7f48.pdf', Method::GET, RequestHeaders, Content, Response);
        ResponseAsInStr(Instr, Response);
        DownloadFromStream(Instr, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, Filename);
    end;

    procedure PerformWebRequest(Url: Text; Method: Enum "Web Request Method"; RequestHeaders: Dictionary of [Text, Text]; var Content: HttpContent; var Response: HttpResponseMessage)
    var
        Client: HttpClient;

        HeaderKey: Text;
        HeaderValue: Text;
    begin
        foreach HeaderKey in RequestHeaders.Keys() do begin
            RequestHeaders.Get(HeaderKey, HeaderValue);
            Client.DefaultRequestHeaders.Add(HeaderKey, HeaderValue);
        end;

        case Method of
            Method::GET:
                Client.Get(Url, Response);
            Method::POST:
                Client.Post(Url, Content, Response);
            Method::PUT:
                Client.Put(Url, Content, Response);
            Method::DELETE:
                Client.Delete(Url, Response);
        end;
    end;

    procedure ResponseAsInStr(var InStr: InStream; Response: HttpResponseMessage)
    begin
        Response.Content.ReadAs(InStr);
    end;

    /*

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
