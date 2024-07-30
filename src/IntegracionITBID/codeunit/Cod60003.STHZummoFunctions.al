codeunit 60003 "STH Zummo Functions"
{
    procedure GetJSON_Item(productos: Record Item) JsonTextReturn: Text
    var
        JsonArrayItem: JsonArray;
        JsonObjectItem: JsonObject;
        JsonObjectItem2: JsonObject;
        JsonText: Text;
        comments: Record "Comment Line";
        artobs: Text[255];
        notasInternas: Text[255];
    begin
        productos.CalcFields(Inventory);

        comments.SetRange("Table Name", comments."Table Name"::Item);
        comments.SetRange("No.", productos."No.");

        if comments.FindFirst() then
            repeat
                if Text.StrLen(artobs) <= Text.MaxStrLen(artobs) - Text.StrLen(comments.Comment) then begin
                    artobs += comments.Comment;
                end else
                    if Text.StrLen(notasInternas) <= Text.MaxStrLen(notasInternas) - Text.StrLen(comments.Comment) then begin
                        notasInternas += comments.Comment;
                    end;
            until comments.Next() = 0;

        JsonObjectItem.Add('artcodigo', productos."No.");
        JsonObjectItem.Add('sapCode', productos."No.");
        JsonObjectItem.Add('artconcepto', productos.Description);
        JsonObjectItem.Add('artobs', artobs);
        JsonObjectItem.Add('notasInternas', notasInternas);
        JsonObjectItem.Add('subcategoria', 'Auditoría');//productos."Purch. SubCategory");
        JsonObjectItem.Add('subcategoriasAdicionales', '');
        JsonObjectItem.Add('unidad', 1);
        JsonObjectItem.Add('unidadMedidaDefault', productos."Base Unit of Measure");
        JsonObjectItem.Add('precioReferencia', productos."Unit Cost");
        JsonObjectItem.Add('stock', productos.Inventory);
        JsonObjectItem.Add('stockMinimoProveedor', productos."Safety Stock Quantity");

        JsonObjectItem2.Add('producto', JsonObjectItem);
        JsonObjectItem2.WriteTo(JsonText);
        Message(JsonText);
        exit(JsonText);
    end;

    procedure GetJSON_ItemTemporay(Itemstemporary: Record "ZM PL Items temporary") JsonTextReturn: Text
    var
        JsonArrayItem: JsonArray;
        JsonObjectItem: JsonObject;
        JsonObjectItem2: JsonObject;
        JsonText: Text;
        comments: Record "Comment Line";
        artobs: Text[255];
        notasInternas: Text[255];
    begin
        comments.SetRange("Table Name", comments."Table Name"::Item);
        comments.SetRange("No.", Itemstemporary."No.");

        if comments.FindFirst() then
            repeat
                if Text.StrLen(artobs) <= Text.MaxStrLen(artobs) - Text.StrLen(comments.Comment) then begin
                    artobs += comments.Comment;
                end else
                    if Text.StrLen(notasInternas) <= Text.MaxStrLen(notasInternas) - Text.StrLen(comments.Comment) then begin
                        notasInternas += comments.Comment;
                    end;
            until comments.Next() = 0;

        JsonObjectItem.Add('artcodigo', Itemstemporary."No.");
        JsonObjectItem.Add('sapCode', Itemstemporary."No.");
        JsonObjectItem.Add('artconcepto', Itemstemporary.Description);
        JsonObjectItem.Add('artobs', artobs);
        JsonObjectItem.Add('notasInternas', notasInternas);
        JsonObjectItem.Add('subcategoria', 'Auditoría');//productos."Purch. SubCategory");
        JsonObjectItem.Add('subcategoriasAdicionales', '');
        JsonObjectItem.Add('unidad', 1);
        JsonObjectItem.Add('unidadMedidaDefault', Itemstemporary."Base Unit of Measure");
        JsonObjectItem.Add('precioReferencia', Itemstemporary."Unit Cost");
        JsonObjectItem.Add('stock', 0);
        JsonObjectItem.Add('stockMinimoProveedor', Itemstemporary."Safety Stock Quantity");
        JsonObjectItem2.Add('producto', JsonObjectItem);
        JsonObjectItem2.WriteTo(JsonText);
        exit(JsonText);
    end;

    procedure PutBody(body: Text; productoNo: code[20]; var ISUpdate: Boolean)
    var
        IsSuccess: Boolean;
        Client: HttpClient;
        ClientHeaders: HttpHeaders;
        ClientContent: HttpContent;
        ClientResponse: HttpResponseMessage;
        ClientResponseText: Text;
        ClientRequest: HttpRequestMessage;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ContentText: Text;
        ResponseText: Text;
        UriBuilder: Codeunit DotNet_Uri;
        JsonAccess: JsonObject;
        JsonAccessToken: JsonToken;
        AccessToken: TexT;
        ItbidSetup: Record "Sales & Receivables Setup";
        smtp: Codeunit SMTP_Trampa;
    begin
        ItbidSetup.Get();

        ContentText := 'grant_type=' + UriBuilder.EscapeDataString(ItbidSetup.STHgrant_type) +
        '&username=' + UriBuilder.EscapeDataString(ItbidSetup.STHusername) +
        '&password=' + UriBuilder.EscapeDataString(ItbidSetup.STHpassword) +
        '&client_id=' + UriBuilder.EscapeDataString(ItbidSetup.STHclient_id) +
        '&client_secret=' + UriBuilder.EscapeDataString(ItbidSetup.STHclient_secret) +
        '&scope=' + UriBuilder.EscapeDataString('');

        Content.WriteFrom(ContentText);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

        Request.Method := 'POST';
        Request.SetRequestUri(ItbidSetup.STHurlAccessToken);
        Request.Content(Content);

        //RECOGEMOS EL ACCESS TOKEN
        if Client.Send(Request, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                if Response.Content.ReadAs(ResponseText) then begin
                    IsSuccess := JsonAccess.ReadFrom(ResponseText);
                    JsonAccess.Get('access_token', JsonAccessToken);
                    AccessToken := JsonAccessToken.AsValue().AsText();
                end;
            end else
                if Response.Content.ReadAs(ResponseText) then
                    JsonAccess.ReadFrom(ResponseText);
        end else begin
            // ENVIAR CORREO CON EL MENSAJE DE ERROR
            Response.Content.ReadAs(ResponseText);
            sendEmailErrorPUT(Format(Response.HttpStatusCode), Response.ReasonPhrase, ResponseText, 'ERROR: Access Token');
        end;

        AccessToken := 'Bearer ' + AccessToken;
        Client.DefaultRequestHeaders.Add('Authorization', AccessToken);


        ClientContent.WriteFrom(body);
        ClientContent.GetHeaders(ClientHeaders);
        ClientHeaders.Remove('Content-Type');
        ClientHeaders.Add('Content-Type', 'application/json');

        ClientRequest.Method := 'PUT';
        ClientRequest.SetRequestUri(ItbidSetup.STHurlPut + productoNo);
        ClientRequest.Content(ClientContent);

        //LLAMADA PUT WEBSERVICE ITBID
        if Client.Send(ClientRequest, ClientResponse) then begin
            if ClientResponse.IsSuccessStatusCode() then begin
                if ClientResponse.Content.ReadAs(ClientResponseText) then begin
                    ISUpdate := true;
                end else
                    Error(ClientResponseText);
            end;
        end else begin
            // ENVIAR CORREO CON EL MENSAJE DE ERROR
            ClientResponse.Content.ReadAs(ClientResponseText);
            sendEmailErrorPUT(Format(ClientResponse.HttpStatusCode), ClientResponse.ReasonPhrase, ClientResponseText, 'ERROR: PUT');
        end;
    end;

    local procedure sendEmailErrorPUT(HttpStatusCode: Text; ReasonPhrase: Text; ResponeText: Text; ErrorDescription: Text)
    var
        cduSmtp: Codeunit "SMTP Mail";
        txtCuerpo: Text;
        txtAsunto: Text;
        recCompanyInfo: Record "Company Information";
        recSMTPSetup: Record "SMTP Mail Setup";
        itbidSetup: Record "Sales & Receivables Setup";
    begin
        if not recSMTPSetup.Get() then
            exit;
        recCompanyInfo.Get();
        itbidSetup.Get();

        txtCuerpo += HttpStatusCode + ' ' + ReasonPhrase + '<br>' + ErrorDescription + '<br>' + ResponeText;
        txtCuerpo += '<br><br>Para cualquier consulta contacte con el Departamento de Administración.';
        txtCuerpo += '<br><br>Sin otro particular, reciba un cordial saludo. <br><br>';
        txtAsunto := 'Fallo en intregración de compras ITBID';

        clear(cduSmtp);
        cduSmtp.CreateMessage(recCompanyInfo.Name, recSMTPSetup."User ID", itbidSetup.STHemail, txtAsunto, txtCuerpo, true);

        if not cduSmtp.TrySend() then
            Message(cduSmtp.GetLastSendMailErrorText());
    end;

    local procedure updateItemsWebService()
    var
        productos: Record Item;
        IsUpdate: Boolean;
        JsonText: Text;
    begin
        productos.SetRange("STH To Update", true);
        if productos.FindFirst() then begin
            repeat
                JsonText := GetJSON_Item(productos);
                PutBody(JsonText, productos."No.", IsUpdate);
                if IsUpdate then begin
                    productos."STH To Update" := false;
                    productos."STH Last Update Date" := Today;
                    productos.Modify();
                end;
            until productos.Next() = 0;
        end;
    end;

    trigger OnRun()
    begin
        updateItemsWebService();
    end;
}
