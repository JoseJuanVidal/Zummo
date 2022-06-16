codeunit 50104 "Zummo Inn. IC Functions"
{
    procedure GetJSONItemField(Token: JsonToken; keyname: Text): Text
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then exit(jToken.AsValue().AsText());

        exit('');
    end;

    procedure GetJSONItemFieldBoolean(Token: JsonToken; keyname: Text): Boolean
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then exit(jToken.AsValue().AsBoolean());

        exit(false);
    end;

    procedure GetJSONItemFieldDecimal(Token: JsonToken; keyname: Text): Decimal
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then exit(jToken.AsValue().AsDecimal());

        exit(0);
    end;

    procedure GetJSONItemFieldInteger(Token: JsonToken; keyname: Text): Integer
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then exit(jToken.AsValue().AsInteger());

        exit(0);
    end;

    procedure GetJSONItemFieldCode(Token: JsonToken; keyname: Text): Code[50]
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then exit(jToken.AsValue().AsCode());

        exit('');
    end;

    procedure GetJSONItemFieldObject(Token: JsonToken; keyname: Text): JsonObject
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then exit(jToken.AsObject());
    end;

    procedure GetJSONItemFieldArray(Token: JsonToken; keyname: Text): JsonArray
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then exit(jToken.AsArray());
    end;

    procedure ConvertJSONTextToDate(pText: Text): Date
    var
        day: integer;
        month: integer;
        year: integer;
    begin
        if pText = '' then exit(0D);

        Evaluate(day, CopyStr(pText, 9, 2));
        Evaluate(month, CopyStr(pText, 6, 2));
        Evaluate(year, CopyStr(pText, 1, 4));
        exit(DMY2Date(day, month, year));
    end;

    //Funcion para convertir un campo BLOB en texto 
    /*   procedure ReadAsText(InputQueueAux: Record "STH Input Queue"; LineSeparator: Text; Encoding: TextEncoding) Content: Text
      var
          InStream: InStream;
          ContentLine: Text;
      begin
          InputQueueAux.JsonBlob.CREATEINSTREAM(InStream, Encoding);

          InStream.READTEXT(Content);
          WHILE not InStream.EOS DO BEGIN
              InStream.READTEXT(ContentLine);
              Content += LineSeparator + ContentLine;
          END;
      end; */

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
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.TestField("WS User Id");
        SalesReceivablesSetup.TestField("WS Key");

        User := SalesReceivablesSetup."WS User Id";
        PassWebServKey := SalesReceivablesSetup."WS Key";

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

    procedure GetBody(Url: Text; var ResponseMsg: HttpResponseMessage; var ResponseContent: HttpContent): Text
    var
        Client: HttpClient;
        Content: HttpContent;
        RequestHeader: httpHeaders;
        HeaderContent: HttpHeaders;
        stringContent: Text;
    begin

        if Client.Get(Url, ResponseMsg) then begin
            ResponseMsg.Content().ReadAs(stringContent);
            ResponseContent := ResponseMsg.Content;
        end;

        exit(stringContent);
    end;

    procedure UpdateOrderNoPurchaseOrderIC(VAR SalesHeader: Record "Sales Header"; VAR SalesOrderHeader: Record "Sales Header")
    var
        Response: HttpResponseMessage;
        JsonBody: JsonObject;
        ResponseText: Text;
        Body: Text;
        ErrorText: Text;
        DocumentNo: Code[20];
        StatusCode: Integer;
        JsonResponse: JsonObject;
        JsonTokResponse: JsonToken;
        MsgLbl: Label 'Se ha actualizado el pedido de compra ';
        SubjectLbl: Label 'Actualización Pedido Compra Zummo Inc.';
        BodyLbl1: Label 'Se ha eliminado el pedido de venta %1';
        BodyLbl2: Label 'Se ha creado el pedido de venta %1 desde la oferta %2';
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.TestField("WS Base URL IC Zummo Innc.");
        SalesReceivablesSetup.TestField("WS Name - Purch. Order Header");

        Clear(JsonBody);
        Clear(Body);
        JsonBody.Add('DocumentNo', SalesHeader."Source Purch. Order No");
        JsonBody.Add('SourceDocumentNo', SalesOrderHeader."No.");

        JsonBody.WriteTo(Body);
        SW_REST(SalesReceivablesSetup."WS Base URL IC Zummo Innc.", SalesReceivablesSetup."WS Name - Purch. Order Header", 'POST', Body, true, StatusCode, JsonResponse, false);

        if JsonResponse.Get('error', JsonTokResponse) then begin
            JsonTokResponse.WriteTo(ErrorText);
            Error(ErrorText);
        end else begin
            DocumentNo := GetJSONItemFieldCode(JsonResponse.AsToken(), 'DocumentNo');
            Message(MsgLbl + DocumentNo);
            if SalesOrderHeader."No." = '' then
                SendMailIC(SubjectLbl, StrSubstNo(BodyLbl1, SalesHeader."No."))
            else
                SendMailIC(SubjectLbl, StrSubstNo(BodyLbl2, SalesOrderHeader."No.", SalesHeader."No."));
        end;

    end;

    procedure UpdateReservationPurchaseOrderIC(var Rec: Record "Sales Header")
    var
        PurchaseHeader: Record "Purchase Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ReservationEntry: Record "Reservation Entry";
        CreatedLbl: Label 'Proceso finalizado. Se han actualizado las lineas del pedido %1';
        SubjectLbl: Label 'Actualización Pedido Compra Zummo Inc.';
        BodyLbl: Label 'Se han actualizado las cantidades y el seguimiento del pedido de compra %1 desde el pedido de venta %2';
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange("Document Type", Rec."Document Type");
        if SalesLine.FindSet() then
            repeat
                if Item.Get(SalesLine."No.") then begin
                    if Item."Item Tracking Code" <> '' then begin
                        ReservationEntry.Reset();
                        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
                        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
                        ReservationEntry.SetRange("Source Subtype", 1);
                        ReservationEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
                        if ReservationEntry.FindSet() then
                            repeat
                                SendReservationEntryUpdateIC(ReservationEntry);
                            until ReservationEntry.Next() = 0;
                    end else begin
                        SendUpdateQtyIC(SalesLine);
                    end;
                end;
            until SalesLine.Next() = 0;

        Rec."Source Purch. Order Updated" := true;
        Rec.Modify();
        SendMailIC(SubjectLbl, StrSubstNo(BodyLbl, Rec."Source Purch. Order No", Rec."No."));
        Message(StrSubstNo(CreatedLbl, Rec."Source Purch. Order No"));
    end;

    local procedure SendReservationEntryUpdateIC(ReservationEntry: Record "Reservation Entry")
    var
        SalesHeader: Record "Sales Header";
        Response: HttpResponseMessage;
        JsonBody: JsonObject;
        ResponseText: Text;
        Body: Text;
        ErrorText: Text;
        DocumentNo: Code[20];
        StatusCode: Integer;
        JsonResponse: JsonObject;
        JsonTokResponse: JsonToken;
    begin
        SalesReceivablesSetup.Get;
        SalesReceivablesSetup.TestField("WS Base URL IC Zummo Innc.");
        SalesReceivablesSetup.TestField("WS Name - Purch. Order Line");
        SalesHeader.Get(SalesHeader."Document Type"::Order, ReservationEntry."Source ID");
        Clear(JsonBody);
        Clear(Body);
        JsonBody.Add('DocumentNo', SalesHeader."Source Purch. Order No");
        JsonBody.Add('ItemNo', ReservationEntry."Item No.");
        JsonBody.Add('Quantity', Abs(ReservationEntry.Quantity));
        JsonBody.Add('SerialNo', ReservationEntry."Serial No.");
        JsonBody.WriteTo(Body);
        SW_REST(SalesReceivablesSetup."WS Base URL IC Zummo Innc.", SalesReceivablesSetup."WS Name - Purch. Order Line", 'POST', Body, true, StatusCode, JsonResponse, false);

        if JsonResponse.Get('error', JsonTokResponse) then begin
            JsonTokResponse.WriteTo(ErrorText);
            Error(ErrorText);
        end;
    end;

    local procedure SendUpdateQtyIC(SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
        Response: HttpResponseMessage;
        JsonBody: JsonObject;
        ResponseText: Text;
        Body: Text;
        ErrorText: Text;
        DocumentNo: Code[20];
        StatusCode: Integer;
        JsonResponse: JsonObject;
        JsonTokResponse: JsonToken;
    begin
        SalesReceivablesSetup.Get;
        SalesReceivablesSetup.TestField("WS Base URL IC Zummo Innc.");
        SalesReceivablesSetup.TestField("WS Name - Purch. Order Line");
        SalesHeader.Get(SalesHeader."Document Type"::Order, SalesLine."Document No.");
        Clear(JsonBody);
        Clear(Body);
        JsonBody.Add('DocumentNo', SalesHeader."Source Purch. Order No");
        JsonBody.Add('ItemNo', SalesLine."No.");
        JsonBody.Add('Quantity', SalesLine.Quantity);
        JsonBody.Add('SerialNo', '');
        JsonBody.WriteTo(Body);
        SW_REST(SalesReceivablesSetup."WS Base URL IC Zummo Innc.", SalesReceivablesSetup."WS Name - Purch. Order Line", 'POST', Body, true, StatusCode, JsonResponse, false);

        if JsonResponse.Get('error', JsonTokResponse) then begin
            JsonTokResponse.WriteTo(ErrorText);
            Error(ErrorText);
        end;
    end;

    procedure SendMailIC(Subject: Text; Body: Text)
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Recipients: Text;
        InStrReport: InStream;
        OutStrReport: OutStream;
    begin
        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."Send Mail Notifications" then begin
            Clear(SMTPMail);
            SMTPMailSetup.Get();
            Recipients := SalesReceivablesSetup."Recipient Mail Notifications";
            SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", Recipients, Subject, Body, false);
            SMTPMail.Send();
        end;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";

}