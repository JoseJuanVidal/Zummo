codeunit 50104 "Zummo Inn. IC Functions"
{

    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SendMailOnCreateQuote(Rec)
    end;

    procedure GetJSONItemField(Token: JsonToken; keyname: Text): Text
    var
        JObject: JsonObject;
        jToken: JsonToken;
        jvalue: JsonValue;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            jvalue := jToken.AsValue();
            if not jvalue.IsNull then
                exit(jToken.AsValue().AsText());
        end;

        exit('');
    end;

    procedure GetJSONItemFieldBoolean(Token: JsonToken; keyname: Text): Boolean
    var
        JObject: JsonObject;
        jToken: JsonToken;
        jvalue: JsonValue;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            jvalue := jToken.AsValue();
            if not jvalue.IsNull then
                exit(jToken.AsValue().AsBoolean());
        end;

        exit(false);
    end;

    procedure GetJSONItemFieldDecimal(Token: JsonToken; keyname: Text): Decimal
    var
        JObject: JsonObject;
        jToken: JsonToken;
        jvalue: JsonValue;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            jvalue := jToken.AsValue();
            if not jvalue.IsNull then
                exit(jToken.AsValue().AsDecimal());
        end;

        exit(0);
    end;

    procedure GetJSONItemFieldInteger(Token: JsonToken; keyname: Text): Integer
    var
        JObject: JsonObject;
        jToken: JsonToken;
        jvalue: JsonValue;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            jvalue := jToken.AsValue();
            if not jvalue.IsNull then
                exit(jToken.AsValue().AsInteger());
        end;

        exit(0);
    end;

    procedure GetJSONItemFieldCode(Token: JsonToken; keyname: Text): Code[50]
    var
        JObject: JsonObject;
        jToken: JsonToken;
        jvalue: JsonValue;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            jvalue := jToken.AsValue();
            if not jvalue.IsNull then
                exit(jToken.AsValue().AsCode());
        end;

        exit('');
    end;

    procedure GetJSONItemFieldText(Token: JsonToken; keyname: Text): Text
    var
        JObject: JsonObject;
        jToken: JsonToken;
        jvalue: JsonValue;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            jvalue := jToken.AsValue();
            if not jvalue.IsNull then
                exit(jToken.AsValue().AsText());
        end;

        exit('');
    end;

    procedure GetJSONItemFieldDate(Token: JsonToken; keyname: Text): Date
    var
        JObject: JsonObject;
        jToken: JsonToken;
        jvalue: JsonValue;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            jvalue := jToken.AsValue();
            if not jvalue.IsNull then
                exit(jToken.AsValue().AsDate());
        end;
        exit(0D);
    end;

    procedure GetJSONItemFieldDateTime(Token: JsonToken; keyname: Text): DateTime
    var
        JObject: JsonObject;
        jToken: JsonToken;
        jvalue: JsonValue;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            jvalue := jToken.AsValue();
            if not jvalue.IsNull then
                exit(jToken.AsValue().AsDateTime());
        end;

        exit(0DT);
    end;

    procedure GetJSONItemFieldObject(Token: JsonToken; keyname: Text): JsonObject
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then begin
            if jToken.IsObject then
                exit(jToken.AsObject());
        end;
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
    begin
        if not TryUpdateOrderNoPurchaseOrderIC(SalesHeader, SalesOrderHeader) then
            Message(StrSubstNo(GetLastErrorCode, GetLastErrorText()));
    end;


    [TryFunction]
    procedure TryUpdateOrderNoPurchaseOrderIC(VAR SalesHeader: Record "Sales Header"; VAR SalesOrderHeader: Record "Sales Header")
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
        SubjectLbl: Label 'Update Purchase Order Zummo Inc.';
        BodyLbl1: Label 'Sales order %1 has been deleted';
        BodyLbl2: Label 'Sales order %1 has been created from offer %2. Purchase Order %3';
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
                SendMailIC(SubjectLbl, StrSubstNo(BodyLbl1, SalesHeader."No."), '', '')
            else
                SendMailIC(SubjectLbl, StrSubstNo(BodyLbl2, SalesOrderHeader."No.", SalesHeader."No.", SalesHeader."Source Purch. Order No"), '', '');
        end;

    end;

    procedure UpdateReservationPurchaseOrderIC(var Rec: Record "Sales Header")
    var
        PurchaseHeader: Record "Purchase Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ReservationEntry: Record "Reservation Entry";
        CreatedLbl: Label 'Proceso finalizado. Se han actualizado las lineas del pedido %1';
        SubjectLbl: Label 'Update Purchase Order Zummo Inc.';
        BodyLbl: Label 'Quantities and tracking for purchase order %1 have been updated from sales order %2';//'Se han actualizado las cantidades y el seguimiento del pedido de compra %1 desde el pedido de venta %2';
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
        SendMailIC(SubjectLbl, StrSubstNo(BodyLbl, Rec."Source Purch. Order No", Rec."No."), '', '');
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
        JsonBody.Add('Quantity', SalesLine."Qty. to Ship");
        JsonBody.Add('SerialNo', '');
        JsonBody.WriteTo(Body);
        SW_REST(SalesReceivablesSetup."WS Base URL IC Zummo Innc.", SalesReceivablesSetup."WS Name - Purch. Order Line", 'POST', Body, true, StatusCode, JsonResponse, false);

        if JsonResponse.Get('error', JsonTokResponse) then begin
            JsonTokResponse.WriteTo(ErrorText);
            Error(ErrorText);
        end;
    end;

    procedure TaskSendMailOnCreateQuote(var SalesHeader: Record "Sales Header")
    begin
        TaskScheduler.CreateTask(Codeunit::"Zummo Inn. IC Functions", Codeunit::"Error Zummo Inn. IC Functions", true, CompanyName, CURRENTDATETIME + 1000, SalesHeader.RecordId);
    end;

    var
    procedure SendMailOnCreateQuote(var SalesHeader: Record "Sales Header")
    var
        SalesHeader2: Record "Sales Header";
        Quotepdf: Report PedidoCliente;
        FileMgt: Codeunit "File Management";
        FileName: Text;
        XmlParameters: text;
        SubjectLbl: Label 'Create Quote in Zummo Innovaciones';
        BodyLbl: Label 'Sales Quote %1 generated, from purchase order %2 in Zummo INC.';
    begin
        // primero obtenemos el PDF de la oferta
        FileName := FileMgt.ServerTempFileName('pdf');
        Clear(Quotepdf);
        SalesHeader2.Reset();
        SalesHeader2.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeader2.SetRange("No.", SalesHeader."No.");
        Quotepdf.SetTableView(SalesHeader2);
        Quotepdf.Pvalorado(true);
        Quotepdf.Pneto(true);
        Quotepdf.SaveAsPdf(FileName);

        // enviamos el email 
        SendMailIC(SubjectLbl, GetSalesHeaderBodyMail(SalesHeader), SalesHeader."No.", FileName);
    end;

    local procedure GetSalesHeaderBodyMail(SalesHeader: Record "Sales Header") BodyMail: text
    var
        Item: Record Item;
        SalesLine: Record "Sales Line";

        lblHdr1: Label '<h3 style="text-align: left; color: #3f7320;"><span style="border-bottom: 4px solid #c82828;">%1 No.:&nbsp;</span>%2</h3>';
        lblHdr2: Label '<p><strong>Nº %1: </strong>%2</p>';
        lblHdr3: Label '<p><strong>Fecha: </strong>%1</p>';
        lblBlank: Label '<p></p>';
        lblTableHdrIni: Label '<table class="header" style="height: 54px;width: 1000px;"><thead><tr style="background-color: #999999;">';
        lblTableHdr: Label '<td><strong><span style="width: %1px;"color: #c82828;text-align: left;">%2</span></strong></td>';
        lblTableHdrFin: Label '</tr></thead>';
        lblTableBodyIni: Label '<tbody><tr>';
        lblTableBodyLeft: Label '<td style="text-align: left;">%2%1%3</td>';
        lblTableBodyright: Label '<td style="text-align: right;">%2%1%3</td>';
        lblTableBodycenter: Label '<td style="text-align: center;">%2%1%3</td>';
        lblTableBodyFin: Label '</tr></tbody>';
        lblTableFin: Label '</table>';
        lblTableComment: Label '<p><strong>%1</strong>%2</p>';
        Rojo: Label '<span style="color: #ff0000;">';
        RojoFin: Label '</span>';
        color: text;
        Colorfin: text;
    begin
        BodyMail := '';
        BodyMail += StrSubstNo(lblHdr1, SalesHeader."Document Type", SalesHeader."No.");
        BodyMail += lblBlank;
        BodyMail += StrSubstNo(lblHdr2, SalesHeader.FieldCaption("Sell-to Customer Name"), SalesHeader."Sell-to Customer Name");
        BodyMail += StrSubstNo(lblHdr3, SalesHeader."Document Date");
        BodyMail += lblBlank;
        BodyMail += lblBlank;
        BodyMail += lblTableHdrIni;
        BodyMail += StrSubstNo(lblTableHdr, 200, SalesLine.FieldCaption("No."));
        BodyMail += StrSubstNo(lblTableHdr, 500, SalesLine.FieldCaption(Description));
        BodyMail += StrSubstNo(lblTableHdr, 75, SalesLine.FieldCaption(Quantity));
        BodyMail += StrSubstNo(lblTableHdr, 75, SalesLine.FieldCaption("Unit Price"));
        BodyMail += StrSubstNo(lblTableHdr, 75, SalesLine.FieldCaption("Line Amount"));
        BodyMail += StrSubstNo(lblTableHdr, 75, 'Bloqueado');
        BodyMail += lblTableHdrFin;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst() then
            repeat
                color := '';
                Colorfin := '';
                if Item.Get(SalesLine."No.") then;
                if item.Blocked or Item."Sales Blocked" then begin
                    color := Rojo;
                    Colorfin := RojoFin;
                end;
                BodyMail += lblTableBodyIni;
                BodyMail += StrSubstNo(lblTableBodyLeft, SalesLine."No.", color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodyleft, SalesLine.Description, color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodyright, SalesLine.Quantity, color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodyright, SalesLine."Unit Price", color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodyright, SalesLine."Line Amount", color, Colorfin);
                BodyMail += StrSubstNo(lblTableBodycenter, Item.Blocked or Item."Sales Blocked", color, Colorfin);
                BodyMail += lblTableBodyFin;
            Until SalesLine.next() = 0;
        BodyMail += lblTableFin;
        BodyMail += StrSubstNo(lblTableComment, 'comentario:', '');


        exit(BodyMail);
    end;

    procedure SendMailOnPostShipment(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20])
    var
        SubjectLbl: Label 'Posted Sales Shipment in Zummo Inc.';
        BodyLbl: Label 'Sales shipment %1 generated from sales order %2, from purchase order %3 in Zummo INC.';
    begin
        SendMailIC(SubjectLbl, StrSubstNo(BodyLbl, SalesShptHdrNo, SalesHeader."No.", SalesHeader."Source Purch. Order No"), '', '');
    end;

    procedure SendMailIC(Subject: Text; Body: Text; FileNo: text; FileName: Text)
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
            SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", Recipients, Subject, Body, true);
            if (FileName <> '') and (Exists(FileName)) then
                SMTPMail.AddAttachment(FileName, StrSubstNo('Oferta Venta %1.pdf', FileNo));
            SMTPMail.Send();
        end;
    end;


    // =============     Funciones para actualizar JIRA          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    procedure JIRA_SW_REST(urlBase: Text; metodo: Text; metodoREST: Text; parametros: Text; requiereAutenticacion: Boolean; var statusCode: Integer;
        var ResponseText: text; User: text; PassWebServKey: Text)
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
        Texto: Text;
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

        statusCode := ResponseMessage.HttpStatusCode;

    end;

    procedure JIRAGetAllTickets(project: text; subKey: code[50])
    var
        JiraTicket: Record "ZM IT JIRA Tickets";
        metodo: Label 'search?maxResults=100&jql=project = %1 ORDER by ID&fields=key,summary,status,assignee&startAt=%2';
        Body: text;
        ErrorText: text;
        FieldValue: text;
        ResponseText: text;
        StatusCode: Integer;
        JsonResponse: JsonObject;
        JsonTokResponse: JsonToken;
        JsonIssues: JsonArray;
        JsonIssue: JsonToken;
        JsonIssueFields: JsonObject;
        JsonIssueState: JsonObject;
        JsonIssueassigned: JsonObject;
        TotalIssues: Integer;
        IssuesCount: Integer;
        Window: Dialog;
        lblName: Label 'Ticket #1###################', comment = 'ESP="Ticket #1###################"';
    begin
        Window.Open(lblName);
        JobsSetup.Get();
        JobsSetup.TestField("url Base");
        JobsSetup.TestField(user);
        JobsSetup.TestField(token);
        JIRA_SW_REST(JobsSetup."url Base", StrSubstNo(metodo, project, IssuesCount), 'GET', Body, true, StatusCode, ResponseText, JobsSetup.user, JobsSetup.token);

        JsonResponse.ReadFrom(ResponseText);

        if JsonResponse.Get('error', JsonTokResponse) then begin
            JsonTokResponse.WriteTo(ErrorText);
            Error(ErrorText);
        end else begin
            FieldValue := GetJSONItemFieldCode(JsonResponse.AsToken(), 'total');

            Evaluate(TotalIssues, FieldValue);

            JsonIssues := GetJSONItemFieldArray(JsonResponse.AsToken(), 'issues');

            repeat
                foreach JsonIssue in JsonIssues do begin

                    IssuesCount += 1;
                    FieldValue := GetJSONItemFieldText(JsonIssue, 'key');
                    Window.Update(1, FieldValue);
                    JiraTicket.Reset();
                    if not JiraTicket.Get(FieldValue) then begin
                        JiraTicket.Init();
                        JiraTicket."key" := FieldValue;
                        JiraTicket.id := GetJSONItemFieldInteger(JsonIssue, 'id');
                        if not (subKey = '') then
                            JiraTicket.Project := subKey;
                    end;
                    JsonIssueFields := GetJSONItemFieldObject(JsonIssue, 'fields');
                    JiraTicket.summary := CopyStr(GetJSONItemFieldText(JsonIssueFields.AsToken(), 'summary'), 1, MaxStrLen(JiraTicket.summary));
                    JsonIssueState := GetJSONItemFieldObject(JsonIssueFields.AsToken(), 'status');
                    JiraTicket.State := GetJSONItemFieldText(JsonIssueState.AsToken(), 'name');
                    JiraTicket."Description Status" := copystr(GetJSONItemFieldText(JsonIssueState.AsToken(), 'description'), 1, MaxStrLen(JiraTicket."Description Status"));
                    JsonIssueassigned := GetJSONItemFieldObject(JsonIssueFields.AsToken(), 'assignee');
                    JiraTicket.Assignee := copystr(GetJSONItemFieldText(JsonIssueassigned.AsToken(), 'displayName'), 1, MaxStrLen(JiraTicket.Assignee));
                    if not JiraTicket.Insert() then
                        JiraTicket.Modify();
                end;
                if IssuesCount < TotalIssues then begin
                    JIRA_SW_REST(JobsSetup."url Base", StrSubstNo(metodo, project, IssuesCount), 'GET', Body, true, StatusCode, ResponseText, JobsSetup.user, JobsSetup.token);
                    JsonResponse.ReadFrom(ResponseText);
                    if JsonResponse.Get('error', JsonTokResponse) then begin
                        JsonTokResponse.WriteTo(ErrorText);
                        Error(ErrorText);
                    end else begin
                        JsonIssues := GetJSONItemFieldArray(JsonResponse.AsToken(), 'issues');
                    end;
                end;
            until IssuesCount >= TotalIssues;
        end;
        Window.Close();
    end;

    procedure JIRAGetAllProjects()
    var
        JiraProjects: Record "ZM IT JIRA Projects";
        metodo: Label 'project?fields=key,name';
        Body: text;
        ErrorText: text;
        ResponseText: text;
        FieldValue: Text;
        StatusCode: Integer;
        JsonResponse: JsonObject;
        JsonTokResponse: JsonToken;
        JsonProjects: JsonArray;
        JsonProject: JsonToken;
    begin
        JobsSetup.Get();
        JobsSetup.TestField("url Base");
        JobsSetup.TestField(user);
        JobsSetup.TestField(token);
        JIRA_SW_REST(JobsSetup."url Base", metodo, 'GET', Body, true, StatusCode, ResponseText, JobsSetup.user, JobsSetup.token);

        if JsonProjects.ReadFrom(ResponseText) then begin
            foreach JsonProject in JsonProjects do begin
                FieldValue := GetJSONItemFieldText(JsonProject, 'key');
                JiraProjects.Reset();
                if not JiraProjects.Get(FieldValue) then begin
                    JiraProjects.Init();
                    JiraProjects."key" := FieldValue;
                    JiraProjects.id := GetJSONItemFieldInteger(JsonProject, 'id');
                    JiraProjects.name := GetJSONItemFieldText(JsonProject, 'name');
                    JiraProjects.Insert();

                end;
                // actualizar sub tickets
                JIRAGetAllTickets(JiraProjects."key", JiraProjects."key");

            end;
        end;
    end;


    // =============     CONSULTIA TRAVEL           ====================
    // ==  
    // ==  Aplicacion de gestion de viajes 
    // ==  
    // ==  API REST de acceso  https://documenter.getpostman.com/view/9746760/TzY1hwbE#2bcc1021-1db7-4a03-81fc-eecedad77db6
    // ==  
    // ==  server:  https://api-destinux.consultiatravel.es/B2B.Test
    // ==  
    // ==  Listar viajeros         GET     {{server}}/api/ListaViajeros
    // ==  Alta usuarios           POST    {{server}}/api/v1/SincronizarClientes/Procesar
    // ==  Alta usuarios Simular   POST    {{server}}/api/v1/SincronizarClientes/Simular
    // ==  Alta usuarios Archivo   POST    {{server}}/api/v1/AltaClientesArchivo/Procesar
    // ==        crear alta de usuarios desde un archivo excel o XML
    // ==        Puede encontrar la plantilla en el siguiente link: http://login.consultiatravel.es/recursos/octopus/b2b/Plantilla_Alta_Clientes.xlsx
    // ==  Consumos                 GET     {{server}}/api/Consumos?FechaIni=01/05/2023&FechaFin=31/05/2023
    // ==  Facturas por fecha       GET     {{server}}/api/Facturas?FechaIni=01/05/2023&FechaFin=31/05/2023&DetalleConsumos=true
    // ==  Facturas por numero      GET     {{server}}/api/Facturas?Numero=F1-4/327&DetalleConsumos=true
    // ==  Facturas PDF por numero  GET     {{server}}/api/Facturas/ObtenerPDF?IdFactura=240877
    // ==  
    // ==  
    // ==  

    procedure REST_CONSULTIA(metodo: Text; metodoREST: Text; parametros: Text; requiereAutenticacion: Boolean; var statusCode: Integer; var respuestaJSON: JsonObject; indicarEmpresa: Boolean)
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
        PurchasesPayablesSetup.Get();
        PurchasesPayablesSetup.TestField("CONSULTIA Url");
        PurchasesPayablesSetup.TestField("CONSULTIA User");
        PurchasesPayablesSetup.TestField("CONSULTIA Password");
        //Creamos una url
        Url := PurchasesPayablesSetup."CONSULTIA Url" + metodo;
        //Añadimos los headers de petición
        RequestContent.GetHeaders(ContentHeaders);

        //Obtenemos los headers por defecto
        ClientHeaders := Client.DefaultRequestHeaders();


        User := PurchasesPayablesSetup."CONSULTIA User"; // 'zummo_test';
        PassWebServKey := PurchasesPayablesSetup."CONSULTIA Password"; // 'zummo_test';

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
        statusCode := ResponseMessage.HttpStatusCode;
        if statusCode = 200 then
            respuestaJSON.ReadFrom(ResponseText)
        else
            Error(ResponseText);


    end;

    // ======================================================================================================
    // =============     Get Lista Viajeros          ====================
    // ==  
    // ==  Detalle de los empleados de su organización registrados en nuestros sistemas. 
    // ==  
    // ======================================================================================================
    procedure GetListaViajeros()
    var
        JsonBody: JsonObject;
        JsonResponse: JsonObject;
        JsonTokResponse: JsonToken;
        ErrorText: Text;
        StatusCode: Integer;
    begin
        REST_CONSULTIA(lblListaViajero, 'GET', '', true, StatusCode, JsonResponse, false);
        Message(format(JsonResponse));

    end;

    // ======================================================================================================
    // =============     GetInvoicebyDate          ====================
    // ==  
    // ==  Detalle de servicios facturados en un intervalo de fechas.
    // ==  
    // ==  PARAMS
    // ==  FechaIni 01/01/2018
    // ==  Fecha de inicio de la búsqueda. Formato aceptado (dd/MM/yyyy). Campo obligatorio
    // ==  
    // ==  FechaFin 31/01/2018
    // ==  Fecha fin de la búsqueda. Formato aceptado (dd/MM/yyyy). Campo obligatorio
    // ==  
    // ==  DetalleConsumos true
    // ==  Flag que permite indicar si se desea obtener el detalle de consumos de las facturas
    // ==  
    // ==  
    // ==  
    // ======================================================================================================
    procedure GetInvoicebyDate(Startdate: Date; EndDate: date)
    var
        Vendor: Record Vendor;
        CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header";
        JsonBody: JsonObject;
        JsonResponse: JsonObject;
        JsonTokResponse: JsonToken;
        JsonEmisor: JsonObject;
        JsonReceptor: JsonObject;
        JsonFacturas: JsonArray;
        JsonFactura: JsonToken;
        JsonFacturaDetails: JsonArray;
        JsonFacturaDetail: JsonToken;
        ErrorText: Text;
        Metodo: text;
        Valuetext: text;
        VendorName: text;
        StatusCode: Integer;
        Window: Dialog;
        lblDlg: Label 'Invoice No. #1################', comment = 'ESP="Nº Factura #1################"';
    begin
        Window.Open(lblDlg);
        Metodo := lblInvoice + StrSubstNo(lblDate, format(Startdate, 0, '<day,2>/<Month,2>/<Year4>'), format(EndDate, 0, '<day,2>/<Month,2>/<Year4>'));

        REST_CONSULTIA(Metodo, 'GET', '', true, StatusCode, JsonResponse, false);


        JsonEmisor := GetJSONItemFieldObject(JsonResponse.AsToken(), 'Emisor');
        JsonReceptor := GetJSONItemFieldObject(JsonResponse.AsToken(), 'Receptor');
        JsonFacturas := GetJSONItemFieldArray(JsonResponse.AsToken(), 'Facturas');

        Valuetext := GetJSONItemFieldText(JsonEmisor.AsToken(), 'CIF');
        VendorName := GetJSONItemFieldText(JsonEmisor.AsToken(), 'Razon_social');
        Vendor.Reset();
        Vendor.SetRange("VAT Registration No.", Valuetext);
        if vendor.FindFirst() then;
        // ValueText := GetJSONItemFieldText(JsonReceptor.AsToken(), 'Razon_social');

        foreach JsonFactura in JsonFacturas do begin
            AddInvoiceHeader(CONSULTIAInvoiceHeader, JsonFactura, Vendor."No.", VendorName, Valuetext);
            Window.Update(1, CONSULTIAInvoiceHeader.N_Factura);

            JsonFacturaDetails := GetJSONItemFieldArray(JsonFactura, 'Detalles');

            foreach JsonFacturaDetail in JsonFacturaDetails do begin
                AddInvoiceDetails(CONSULTIAInvoiceHeader, JsonFacturaDetail);
            end;

            CreateRecordLinkPDF(CONSULTIAInvoiceHeader);

            Commit();
        end;
        Window.Close();
    end;

    local procedure CreateRecordLinkPDF(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header")
    var
        DocumentAttachment: Record "Document Attachment";
        TempBlob: Record TempBlob;
        FileManagement: Codeunit "File Management";
        Instr: InStream;
        FileName: text;
    begin
        if CallGetInvoicePdf(CONSULTIAInvoiceHeader.Id, InStr) then begin
            FileName := CONSULTIAInvoiceHeader.N_Factura + '.pdf';
            DocumentAttachment.Reset();
            DocumentAttachment.SetRange("Table ID", Database::"ZM CONSULTIA Invoice Header");
            DocumentAttachment.SetRange("No.", CONSULTIAInvoiceHeader.N_Factura);
            if DocumentAttachment.FindFirst() then
                exit;
            DocumentAttachment.Init();
            DocumentAttachment."Table ID" := Database::"ZM CONSULTIA Invoice Header";
            DocumentAttachment."No." := CONSULTIAInvoiceHeader.N_Factura;
            DocumentAttachment."Attached Date" := CreateDateTime(Today, time);
            DocumentAttachment."Attached By" := UserSecurityId();
            DocumentAttachment.Validate("File Extension", FileManagement.GetExtension(FileName));
            DocumentAttachment.Validate("File Name", CONSULTIAInvoiceHeader.N_Factura);
            DocumentAttachment."Document Reference ID".ImportStream(Instr, FileName);
            DocumentAttachment.Insert(true)
        end
    end;

    local procedure AddInvoiceHeader(var CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; JsonFactura: JsonToken; VendorNo: text;
        VendorName: Text; VatRegistrationNo: text[20])
    var
        FieldValue: text;
        FieldValueInt: Integer;
    begin
        FieldValue := GetJSONItemFieldText(JsonFactura, 'ID_Factura');
        Evaluate(FieldValueInt, FieldValue);
        if CONSULTIAInvoiceHeader.Get(FieldValueInt) then
            exit;
        CONSULTIAInvoiceHeader.Init();
        CONSULTIAInvoiceHeader.Id := FieldValueInt;
        CONSULTIAInvoiceHeader.N_Factura := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(N_Factura));
        CONSULTIAInvoiceHeader."N_Pedido" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(N_Pedido));
        CONSULTIAInvoiceHeader."F_Factura" := DT2Date(GetJSONItemFieldDateTime(JsonFactura, CONSULTIAInvoiceHeader.FieldName(F_Factura)));
        CONSULTIAInvoiceHeader."Descripcion" := GetJSONItemFieldText(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Descripcion));
        CONSULTIAInvoiceHeader."IdCorp_Sol" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(IdCorp_Sol));
        CONSULTIAInvoiceHeader."Nombre_Sol" := GetJSONItemFieldText(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Nombre_Sol));
        CONSULTIAInvoiceHeader."Proyecto" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Proyecto));
        CONSULTIAInvoiceHeader."Ref_Ped_Cl" := GetJSONItemFieldText(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Ref_Ped_Cl));
        CONSULTIAInvoiceHeader."Responsable_compra" := GetJSONItemFieldText(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Responsable_compra));
        CONSULTIAInvoiceHeader."Tipo" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Tipo));
        CONSULTIAInvoiceHeader."FacturaRectificada" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(FacturaRectificada));
        CONSULTIAInvoiceHeader."Total_Base" := GetJSONItemFieldDecimal(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Total_Base));
        CONSULTIAInvoiceHeader."Total_Impuesto" := GetJSONItemFieldDecimal(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Total_Impuesto));
        CONSULTIAInvoiceHeader."Total_Tasas_Exentas" := GetJSONItemFieldDecimal(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Total_Tasas_Exentas));
        CONSULTIAInvoiceHeader."Total" := GetJSONItemFieldDecimal(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Total));
        CONSULTIAInvoiceHeader."Vendor No." := CopyStr(VendorNo, 1, MaxStrLen(CONSULTIAInvoiceHeader."Vendor No."));
        CONSULTIAInvoiceHeader."Vendor Name" := CopyStr(VendorName, 1, MaxStrLen(CONSULTIAInvoiceHeader."Vendor Name"));
        CONSULTIAInvoiceHeader."Vat Registration No." := VatRegistrationNo;
        CONSULTIAInvoiceHeader.Insert();
    end;

    local procedure AddInvoiceDetails(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; JsonFacturaDetail: JsonToken)
    var
        CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
        FieldValue: text;
        FieldValueInt: Integer;
    begin
        FieldValue := GetJSONItemFieldText(JsonFacturaDetail, 'Numero');
        Evaluate(FieldValueInt, FieldValue);
        if CONSULTIAInvoiceLine.Get(CONSULTIAInvoiceHeader.id, FieldValueInt) then
            exit;
        CONSULTIAInvoiceLine.Init();
        CONSULTIAInvoiceLine.Id := CONSULTIAInvoiceHeader.Id;
        CONSULTIAInvoiceLine.N_Factura := CONSULTIAInvoiceHeader.N_Factura;
        CONSULTIAInvoiceLine.Numero := GetJSONItemFieldInteger(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Numero));
        CONSULTIAInvoiceLine."Desc_servicio" := GetJSONItemFieldtext(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Desc_servicio));
        CONSULTIAInvoiceLine."Proveedor" := GetJSONItemFieldtext(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Proveedor));
        CONSULTIAInvoiceLine."F_Ini" := DT2Date(GetJSONItemFieldDateTime(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(F_Ini)));
        CONSULTIAInvoiceLine."F_Fin" := DT2Date(GetJSONItemFieldDateTime(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(F_Fin)));
        CONSULTIAInvoiceLine."IdCorp_Usuario" := GetJSONItemFieldcode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(IdCorp_Usuario));
        CONSULTIAInvoiceLine."Usuario" := GetJSONItemFieldtext(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Usuario));
        CONSULTIAInvoiceLine."Ref_Usuario" := GetJSONItemFieldtext(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Ref_Usuario));
        CONSULTIAInvoiceLine."Ref_DPTO" := GetJSONItemFieldText(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Ref_DPTO));
        CONSULTIAInvoiceLine."Producto" := GetJSONItemFieldCode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Producto));
        CONSULTIAInvoiceLine."Base" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Base));
        CONSULTIAInvoiceLine."Porc_IVA" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Porc_IVA));
        CONSULTIAInvoiceLine."Porc_IVA" := CONSULTIAInvoiceLine."Porc_IVA" * 100;
        CONSULTIAInvoiceLine."Imp_IVA" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Imp_IVA));
        CONSULTIAInvoiceLine."Tasas" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Tasas));
        CONSULTIAInvoiceLine."PVP" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(PVP));
        CONSULTIAInvoiceLine."IdCorp_Sol" := GetJSONItemFieldCode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(IdCorp_Sol));
        GetEmployeeDimensionsValue(CONSULTIAInvoiceLine);
        CONSULTIAInvoiceLine."IdServicio" := GetJSONItemFieldCode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(IdServicio));
        CONSULTIAInvoiceLine."NumeroLineaServicio" := GetJSONItemFieldInteger(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(NumeroLineaServicio));
        CONSULTIAInvoiceLine."CodigoProducto" := GetJSONItemFieldCode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(CodigoProducto));
        CONSULTIAInvoiceLine.Insert();
    end;

    procedure GetEmployeeDimensionsValue(var CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line")
    var
        GLSetup: record "General Ledger Setup";
        DefaultDimension: Record "Default Dimension";
        DimSetEntry: Record "Dimension Set Entry" temporary;
        DimensionMgt: Codeunit DimensionManagement;
        DimensionSetIDArr: ARRAY[10] OF Integer;
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        GlobalDim1Code: code[20];
        GlobalDim2Code: code[20];
        DimSetID: Integer;
    begin
        // CECO - Partida - Detalle - Depart
        // 1       8           3         4
        GLSetup.Get();
        TableID[1] := Database::Employee;
        No[1] := CONSULTIAInvoiceLine.IdCorp_Usuario;
        DimSetID := DimensionMgt.GetDefaultDimID(TableID, No, '', GlobalDim1Code, GlobalDim2Code, DimSetID, 0);
        DimensionMgt.GetDimensionSet(DimSetEntry, DimSetID);
        DimSetEntry.Reset();
        DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntry.FindFirst() then
            CONSULTIAInvoiceLine.Detalle := DimSetEntry."Dimension Value Code";
        DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
        if DimSetEntry.FindFirst() then
            CONSULTIAInvoiceLine.Partida := DimSetEntry."Dimension Value Code";
        DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
        if DimSetEntry.FindFirst() then
            CONSULTIAInvoiceLine.DEPART := DimSetEntry."Dimension Value Code";

    end;

    procedure GetGLAccountDimensionsValue(var CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line")
    var
        GLSetup: record "General Ledger Setup";
        CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header";
        DefaultDimension: Record "Default Dimension";
        DimSetEntry: Record "Dimension Set Entry" temporary;
        DimensionMgt: Codeunit DimensionManagement;
        GLAccount: code[20];
        DimensionSetIDArr: ARRAY[10] OF Integer;
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        GlobalDim1Code: code[20];
        GlobalDim2Code: code[20];
        DimSetID: Integer;
    begin
        GLSetup.Get();
        if CONSULTIAInvoiceHeader."G/L Account Fair" = '' then
            GLAccount := CONSULTIAInvoiceLine.Ref_DPTO
        else
            GLAccount := CONSULTIAInvoiceHeader."G/L Account Fair";
        TableID[1] := Database::"G/L Account";
        No[1] := GLAccount;
        DimSetID := DimensionMgt.GetDefaultDimID(TableID, No, '', GlobalDim1Code, GlobalDim2Code, DimSetID, 0);
        DimensionMgt.GetDimensionSet(DimSetEntry, DimSetID);
        DimSetEntry.Reset();
        DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
        if DimSetEntry.FindFirst() then
            CONSULTIAInvoiceLine.Partida := DimSetEntry."Dimension Value Code";
    end;

    procedure GetInvoicePdf(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header")
    var
        Instr: InStream;
        FileName: text;
        lblConfirm: Label '¿Would you like to download the PDF of invoice %1?', comment = 'ESP="¿Desea descargar el PDF de la factura %1?"';
    begin
        if Confirm(lblConfirm, false, CONSULTIAInvoiceHeader.N_Factura) then
            if CallGetInvoicePdf(CONSULTIAInvoiceHeader.Id, Instr) then begin
                FileName := CONSULTIAInvoiceHeader.N_Factura + '.pdf';
                DownloadFromStream(Instr, lblDownload, '', '', FileName);
            end;
    end;

    local procedure CallGetInvoicePdf(Id: integer; var Instr: InStream): Boolean
    var
        JsonResponse: JsonObject;
        Metodo: text;
        FileName: Text;
        StatusCode: Integer;

    begin
        Metodo := StrSubstNo(lblGetInvoicePDF, format(Id));

        if GetResponsePDF(Metodo, Instr) then
            exit(true);

    end;

    local procedure GetResponsePDF(metodo: text; var Stream: InStream): Boolean
    var
        TempBlob: Record TempBlob;
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestContent: HttpContent;
        Url: text;
        StringAuthorization: text;
        User: text;
        PassWebServKey: text;
        StringAuth: text;
        IsSucces: Boolean;
    begin
        PurchasesPayablesSetup.Get();
        PurchasesPayablesSetup.TestField("CONSULTIA Url");
        PurchasesPayablesSetup.TestField("CONSULTIA User");
        PurchasesPayablesSetup.TestField("CONSULTIA Password");
        //Creamos una url
        Url := PurchasesPayablesSetup."CONSULTIA Url" + metodo;


        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method := 'GET';

        User := PurchasesPayablesSetup."CONSULTIA User";
        PassWebServKey := PurchasesPayablesSetup."CONSULTIA Password";
        TempBlob.WriteTextLine(User + ':' + PassWebServKey);
        StringAuth := TempBlob.ToBase64String();
        StringAuthorization := 'Basic ' + StringAuth;

        //Creamos la cabecera de athorization
        Headers := Client.DefaultRequestHeaders();
        Headers.Add('Authorization', StringAuthorization);

        if Client.Send(RequestMessage, ResponseMessage) then
            if ResponseMessage.IsSuccessStatusCode() then begin
                if ResponseMessage.Content.ReadAs(Stream) then
                    IsSucces := true;
            end else
                ResponseMessage.Content.ReadAs(Stream);

        exit(IsSucces);
    end;

    procedure CreatePurchaseInvoice(var CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header")
    var
        PurchaseHeader: Record "Purchase Header";
        lblInvoice: Label 'Create la %1 %2.', comment = 'ESP="Creada la %1 %2."';
    begin
        CONSULTIAInvoiceHeader.TestField("Pre Invoice No.", '');
        CONSULTIAInvoiceHeader.TestField("Invoice Header No.", '');
        case true of
            CONSULTIAInvoiceHeader.Total >= 0:
                CONSULTIAInvoiceHeader."Document Type" := CONSULTIAInvoiceHeader."Document Type"::Invoice;
            else
                CONSULTIAInvoiceHeader."Document Type" := CONSULTIAInvoiceHeader."Document Type"::"Credit Memo";
        end;

        AddPurchaseHeaderfromCONSULTIA(CONSULTIAInvoiceHeader, PurchaseHeader);

        AddPurchaseLinefromCONSULTIA(CONSULTIAInvoiceHeader, PurchaseHeader);

        CopyDocumentAttachment(CONSULTIAInvoiceHeader, PurchaseHeader);

        CONSULTIAInvoiceHeader."Pre Invoice No." := PurchaseHeader."No.";
        CONSULTIAInvoiceHeader.Modify();

        Message(lblInvoice, PurchaseHeader."Document Type", PurchaseHeader."No.");
    end;

    local procedure AddPurchaseHeaderfromCONSULTIA(var CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; var PurchaseHeader: Record "Purchase Header")
    var
        Vendor: Record Vendor;
    begin
        if CONSULTIAInvoiceHeader."Vendor No." = '' then begin
            Vendor.Get(GetVendorNoByVatRegistrationNo(CONSULTIAInvoiceHeader."Vat Registration No."));
            CONSULTIAInvoiceHeader."Vendor No." := Vendor."No.";
        end;

        PurchaseHeader.Init();
        case CONSULTIAInvoiceHeader."Document Type" of
            CONSULTIAInvoiceHeader."Document Type"::Invoice:
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
            CONSULTIAInvoiceHeader."Document Type"::"Credit Memo":
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
        end;
        PurchaseHeader.InitInsert();
        PurchaseHeader.Validate("Buy-from Vendor No.", CONSULTIAInvoiceHeader."Vendor No.");
        PurchaseHeader.Validate("Posting Date", WorkDate());
        PurchaseHeader.Validate("Document Date", CONSULTIAInvoiceHeader.F_Factura);
        PurchaseHeader."Vendor Invoice No." := CONSULTIAInvoiceHeader.N_Factura;
        PurchaseHeader."Vendor Shipment No." := CopyStr(CONSULTIAInvoiceHeader.N_Pedido, 1, MaxStrLen(PurchaseHeader."Vendor Shipment No."));
        PurchaseHeader."Your Reference" := CopyStr(CONSULTIAInvoiceHeader.N_Pedido, 1, MaxStrLen(PurchaseHeader."Your Reference"));
        PurchaseHeader."CONSULTIA ID Factura" := CONSULTIAInvoiceHeader.Id;
        PurchaseHeader.Insert();
    end;

    local procedure GetVendorNoByVatRegistrationNo(VatRegistrationNo: Text): code[20]
    var
        Vendor: Record Vendor;
    begin
        Vendor.Reset();
        Vendor.SetRange("VAT Registration No.", copystr(VatRegistrationNo, 1, MaxStrLen(Vendor."VAT Registration No.")));
        Vendor.FindFirst();
        exit(Vendor."No.");
    end;

    local procedure AddPurchaseLinefromCONSULTIA(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; PurchaseHeader: Record "Purchase Header")
    var
        CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
        LineNo: Integer;
    begin
        CONSULTIAInvoiceLine.Reset();
        CONSULTIAInvoiceLine.SetRange(Id, CONSULTIAInvoiceHeader.Id);
        if CONSULTIAInvoiceLine.FindFirst() then
            repeat
                LineNo += 10000;
                AddPurchaseLine(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine, PurchaseHeader, LineNo);
            Until CONSULTIAInvoiceLine.next() = 0;
    end;

    local procedure AddPurchaseLine(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"; PurchaseHeader: Record "Purchase Header"; LineNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Init();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
        PurchaseLine."Line No." := LineNo;
        PurchaseLine.Insert();
        PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
        if CONSULTIAInvoiceHeader."G/L Account Fair" = '' then
            PurchaseLine.Validate("No.", CONSULTIAInvoiceLine.Ref_DPTO)
        else
            PurchaseLine.Validate("No.", CONSULTIAInvoiceHeader."G/L Account Fair");

        PurchaseLine.Description := copystr(CONSULTIAInvoiceLine.Desc_servicio, 1, 100);
        PurchaseLine."Description 2" := copystr(CONSULTIAInvoiceLine.Desc_servicio, 101, 100);
        PurchaseLine.Validate(Quantity, 1);
        PurchaseLine.Validate("VAT Bus. Posting Group", PurchaseHeader."VAT Bus. Posting Group");
        PurchaseLine.Validate("VAT Prod. Posting Group", GetVATProdPostingGroup(CONSULTIAInvoiceLine, PurchaseHeader));
        PurchaseLine.Validate("Direct Unit Cost", CONSULTIAInvoiceLine.Base);
        PurchaseLine.Validate("Shortcut Dimension 1 Code", CONSULTIAInvoiceLine.Ref_Usuario);
        PurchaseLine.IdCorp_Sol := CONSULTIAInvoiceLine.IdCorp_Sol;
        PurchaseLine.Modify();
        SetPurchaseLineDimensiones(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine, PurchaseLine);
        // controlar que si hay tasas, hay que poner dos lineas y una exenta
        if CONSULTIAInvoiceLine.Tasas <> 0 then begin
            PurchaseLine.Init();
            PurchaseLine."Document Type" := PurchaseHeader."Document Type";
            PurchaseLine."Document No." := PurchaseHeader."No.";
            PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
            PurchaseLine."Line No." := LineNo + 5000;
            PurchaseLine.Insert();
            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
            if CONSULTIAInvoiceHeader."G/L Account Fair" = '' then
                PurchaseLine.Validate("No.", CONSULTIAInvoiceLine.Ref_DPTO)
            else
                PurchaseLine.Validate("No.", CONSULTIAInvoiceHeader."G/L Account Fair");

            PurchaseLine.Description := copystr(CONSULTIAInvoiceLine.Desc_servicio, 1, 100);
            PurchaseLine."Description 2" := copystr(CONSULTIAInvoiceLine.Desc_servicio, 101, 100);
            PurchaseLine.Validate(Quantity, 1);
            PurchaseLine.Validate("VAT Bus. Posting Group", PurchaseHeader."VAT Bus. Posting Group");
            PurchaseLine.Validate("VAT Prod. Posting Group", 'EXENTOSERV');
            PurchaseLine.Validate("Direct Unit Cost", CONSULTIAInvoiceLine.Tasas);
            PurchaseLine.Validate("Shortcut Dimension 1 Code", CONSULTIAInvoiceLine.Ref_Usuario);
            PurchaseLine.IdCorp_Sol := CONSULTIAInvoiceLine.IdCorp_Sol;
            PurchaseLine.Modify();
            SetPurchaseLineDimensiones(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine, PurchaseLine);
        end;
    end;

    local procedure GetVATProdPostingGroup(CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"; PurchaseHeader: Record "Purchase Header"): code[20]
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        // TODO, cambiar por configuracion de porcentaje iva
        VATPostingSetup.Reset();
        VATPostingSetup.SetFilter("VAT Prod. Posting Group", '%1', '*SERV');
        VATPostingSetup.SetRange("VAT Bus. Posting Group", PurchaseHeader."VAT Bus. Posting Group");
        VATPostingSetup.SetRange("VAT %", CONSULTIAInvoiceLine.Porc_IVA);
        if VATPostingSetup.FindFirst() then
            exit(VATPostingSetup."VAT Prod. Posting Group");
    end;

    local procedure SetPurchaseLineDimensiones(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
                            var PurchaseLine: Record "Purchase Line")
    var
        GLSetup: Record "General Ledger Setup";
        recNewDimSetEntry: record "Dimension Set Entry" temporary;
        cduDimMgt: Codeunit DimensionManagement;
        cduCambioDim: Codeunit CambioDimensiones;
        GlobalDim1: code[20];
        GlobalDim2: code[20];
        intDimSetId: Integer;
    begin
        GLSetup.Get();
        // CECO
        // Empleado y Unico por feria MK (campo proyecto de cabecera)
        GlobalDim1 := GetCONSULTIAInvoiceLineCECO(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
        recNewDimSetEntry.Init();
        recNewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 1 Code";
        recNewDimSetEntry.Validate("Dimension Value Code", GlobalDim1);
        recNewDimSetEntry.Insert();

        // PROYECTO
        CONSULTIAInvoiceLine.CalcFields(Proyecto);
        if CONSULTIAInvoiceLine."Proyecto Manual" = '' then
            CONSULTIAInvoiceLine.TestField(Proyecto);
        recNewDimSetEntry.Init();
        recNewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 2 Code";
        recNewDimSetEntry.Validate("Dimension Value Code", GetCONSULTIAInvoiceLineProyecto(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));
        recNewDimSetEntry.Insert();
        // PARTIDA
        CONSULTIAInvoiceLine.TestField(Partida);
        recNewDimSetEntry.Init();
        recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
        recNewDimSetEntry.Validate("Dimension Value Code", GetCONSULTIAInvoiceLinePARTIDA(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));
        recNewDimSetEntry.Insert();
        // DETALLE
        recNewDimSetEntry.Init();
        recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 3 Code";
        recNewDimSetEntry.Validate("Dimension Value Code", GetCONSULTIAInvoiceLineDETALLE(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));
        recNewDimSetEntry.Insert();
        // DEPART CODIGO (APROBACIONES)
        if CONSULTIAInvoiceLine.DEPART <> '' then begin
            recNewDimSetEntry.Init();
            recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 4 Code";
            recNewDimSetEntry.Validate("Dimension Value Code", CONSULTIAInvoiceLine.DEPART);
            recNewDimSetEntry.Insert();
        end;
        Clear(cduDimMgt);
        intDimSetId := cduDimMgt.GetDimensionSetID(recNewDimSetEntry);
        clear(cduCambioDim);

        GlobalDim1 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 1 Code", intDimSetId);
        GlobalDim2 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 2 Code", intDimSetId);

        PurchaseLine."Dimension Set ID" := intDimSetId;
        PurchaseLine."Shortcut Dimension 1 Code" := GlobalDim1;
        PurchaseLine."Shortcut Dimension 2 Code" := GlobalDim2;
        PurchaseLine.Modify();
    end;

    local procedure GetCONSULTIAInvoiceLineCECO(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"): code[50]
    begin
        if CONSULTIAInvoiceHeader."Global Dimension 1 code Fair" = '' then begin
            CONSULTIAInvoiceLine.TestField(Ref_Usuario);
            exit(CONSULTIAInvoiceLine.Ref_Usuario);
        end else begin
            exit(CONSULTIAInvoiceHeader."Global Dimension 1 code Fair");
        end;
    end;

    local procedure GetCONSULTIAInvoiceLineProyecto(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"): code[50]
    begin
        if CONSULTIAInvoiceHeader.Proyecto = '' then begin
            if CONSULTIAInvoiceLine."Proyecto Manual" <> '' then
                exit(CONSULTIAInvoiceLine."Proyecto Manual");
            CONSULTIAInvoiceLine.TestField(Proyecto);
            exit(CONSULTIAInvoiceLine.Proyecto);
        end else begin
            exit(CONSULTIAInvoiceHeader.Proyecto);
        end;
    end;

    local procedure GetCONSULTIAInvoiceLineDETALLE(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"): code[50]
    begin
        if CONSULTIAInvoiceHeader."Dimension Detalle Fair" = '' then begin
            CONSULTIAInvoiceLine.TestField(Detalle);
            exit(CONSULTIAInvoiceLine.Detalle)
        end else begin
            exit(CONSULTIAInvoiceHeader."Dimension Detalle Fair");
        end;
    end;

    local procedure GetCONSULTIAInvoiceLinePARTIDA(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"): code[50]
    begin
        if CONSULTIAInvoiceHeader."Dimension Partida Fair" = '' then begin
            CONSULTIAInvoiceLine.TestField(Partida);
            exit(CONSULTIAInvoiceLine.Partida)
        end else begin
            exit(CONSULTIAInvoiceHeader."Dimension Partida Fair");
        end;
    end;

    local procedure CopyDocumentAttachment(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; PurchaseHeader: Record "Purchase Header")
    var
        DocumentAttachment: Record "Document Attachment";
        TargetDocumentAttachment: Record "Document Attachment";
    begin
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("Table ID", Database::"ZM CONSULTIA Invoice Header");
        DocumentAttachment.SetRange("No.", CONSULTIAInvoiceHeader.N_Factura);
        if DocumentAttachment.FindFirst() then
            repeat
                TargetDocumentAttachment.Init();
                TargetDocumentAttachment := DocumentAttachment;
                TargetDocumentAttachment.id := 0;
                TargetDocumentAttachment."Table ID" := Database::"Purchase Header";
                TargetDocumentAttachment."Document Type" := PurchaseHeader."Document Type";
                TargetDocumentAttachment."No." := PurchaseHeader."No.";
                TargetDocumentAttachment.Insert(true);
            until DocumentAttachment.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterDeleteEvent', '', true, true)]
    local procedure PurchaseHeader_OnAfterDeleteEvent(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var
        CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header";
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo":
                begin
                    CONSULTIAInvoiceHeader.Reset();
                    CONSULTIAInvoiceHeader.SetRange("Pre Invoice No.", Rec."No.");
                    if CONSULTIAInvoiceHeader.FindFirst() then begin
                        CONSULTIAInvoiceHeader."Pre Invoice No." := '';
                        CONSULTIAInvoiceHeader.Modify();
                    end;

                end;
        end;
    end;

    procedure AssingEmployeeIdCorp(var Rec: Record "ZM CONSULTIA Invoice Line")
    var
        Employee: Record Employee;
        EmployeeList: Page "Employee List";
    begin
        Rec.TestField(IdCorp_Usuario, '');
        EmployeeList.LookupMode := true;
        if EmployeeList.RunModal() = Action::LookupOK then begin
            EmployeeList.GetRecord(Employee);
            Rec.IdCorp_Usuario := Employee."No.";
            GetEmployeeDimensionsValue(Rec);
            Rec.Modify();
        end;
    end;

    procedure UpdateDimensions(var Rec: Record "ZM CONSULTIA Invoice Line")
    begin
        GetProjectDimension(Rec);
        GetEmployeeDimensionsValue(Rec);
        GetGLAccountDimensionsValue(Rec);
        Rec.Modify();
    end;

    procedure AssingProject(var Rec: Record "ZM CONSULTIA Invoice Line")
    var
        ProductProject: Record "ZM CONSULTIA Producto-Proyecto";
        DimensionValue: Record "Dimension Value";
        DimensionValues: Page "Dimension Values";
        lblConfirm: Label '¿Desea Cambiar el proyecto %1 del producto %2 a %3?', comment = 'ESP="¿Desea Cambiar el proyecto %1 del producto %2 a %3?"';
    begin
        ProductProject.Reset();
        CreateProductoProject(Rec.CodigoProducto, Rec.Producto);
        ProductProject.Get(Rec.CodigoProducto);
        DimensionValue.Reset();
        DimensionValue.SetRange("Global Dimension No.", 2);
        DimensionValues.LookupMode := true;
        DimensionValues.SetTableView(DimensionValue);
        if DimensionValues.RunModal() = Action::LookupOK then begin
            DimensionValues.GetRecord(DimensionValue);
            if ProductProject.Proyecto <> '' then
                if not Confirm(lblConfirm, true, ProductProject.Proyecto, ProductProject.Proyecto, DimensionValue.Code) then
                    exit;
            ProductProject.Proyecto := DimensionValue.Code;
            ProductProject.Modify();
        end;
    end;

    local procedure GetProjectDimension(var Rec: Record "ZM CONSULTIA Invoice Line"): Boolean
    var
        ProductProject: Record "ZM CONSULTIA Producto-Proyecto";
    begin
        if Rec.Proyecto <> '' then
            exit;
        ProductProject.Reset();
        ProductProject.SetRange(CodigoProducto, Rec.CodigoProducto);
        if ProductProject.FindFirst() then
            if ProductProject.Proyecto <> '' then
                Rec.Proyecto := ProductProject.Proyecto;
    end;

    local procedure CreateProductoProject(CodigoProducto: code[50]; Producto: text[100])
    var
        ProductProject: Record "ZM CONSULTIA Producto-Proyecto";
    begin
        if ProductProject.Get(CodigoProducto) then
            exit;
        ProductProject.Init();
        ProductProject.CodigoProducto := CodigoProducto;
        ProductProject.Description := CopyStr(Producto, 1, MaxStrLen(ProductProject.Description));
        ProductProject.Insert();
        Commit();
    end;

    // =============     CREAR DIARIO DE APROVISIONAMIENTO          ====================
    // ==  
    // ==  funciones para crear diario de aprovisionamiento de facturas de CONSULTIA
    // ==  
    // ======================================================================================================

    procedure CreateJNLAprovisionamiento(var CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; DesProvisioning: Boolean)
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
        BudgetBuffer: record "Budget Buffer" temporary;
        GenJnlManagement: Codeunit GenJnlManagement;

    begin
        PurchasesPayablesSetup.Get();
        GenJournalBatch.Get(PurchasesPayablesSetup."CONSULTIA Gen. Jnl. Template", PurchasesPayablesSetup."CONSULTIA Gen. Journal Batch");
        PurchasesPayablesSetup.TestField("CONSULTIA G/L Provide");
        PurchasesPayablesSetup.TestField("CONSULTIA Gen. Jnl. Template");
        PurchasesPayablesSetup.TestField("CONSULTIA Gen. Journal Batch");
        BudgetBuffer.DeleteAll();
        if not DesProvisioning then
            CONSULTIAInvoiceHeader.TestField("Invoice Header No.", '');
        if DesProvisioning then begin
            CONSULTIAInvoiceHeader.TestField(Provisioning, true);
            CONSULTIAInvoiceHeader.TestField("Des Provisioning", false);
        end else begin
            CONSULTIAInvoiceHeader.TestField(Provisioning, false);
        end;
        CONSULTIAInvoiceLine.Reset();
        CONSULTIAInvoiceLine.SetRange(id, CONSULTIAInvoiceHeader.Id);
        if CONSULTIAInvoiceLine.FindFirst() then
            repeat

                AddAprovisionamientoBuffer(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine, BudgetBuffer, DesProvisioning);

            Until CONSULTIAInvoiceLine.next() = 0;

        CreateJNLLineAprovisionamiento(CONSULTIAInvoiceHeader, BudgetBuffer);
        case DesProvisioning of
            true:
                begin
                    CONSULTIAInvoiceHeader."Des Provisioning" := true;
                    CONSULTIAInvoiceHeader."Des Provisioning Date" := WorkDate();

                end;
            else begin
                CONSULTIAInvoiceHeader.Provisioning := true;
                CONSULTIAInvoiceHeader."Provisioning Date" := WorkDate();
            end;
        end;
        CONSULTIAInvoiceHeader.Modify();

        Commit();
        GenJnlManagement.TemplateSelectionFromBatch(GenJournalBatch)

    end;


    local procedure AddAprovisionamientoBuffer(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header";
                CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"; var BudgetBuffer: record "Budget Buffer"; DesProvisioning: Boolean)
    var
        myInt: Integer;
    begin
        BudgetBuffer.Reset();
        BudgetBuffer.SetRange("G/L Account No.");
        BudgetBuffer.SetRange("Dimension Value Code 1", GetCONSULTIAInvoiceLineCECO(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));  // CECO
        BudgetBuffer.SetRange("Dimension Value Code 2", GetCONSULTIAInvoiceLineProyecto(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));  // PROYECTO
        BudgetBuffer.SetRange("Dimension Value Code 3", GetCONSULTIAInvoiceLinePARTIDA(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));  // Partida
        BudgetBuffer.SetRange("Dimension Value Code 4", GetCONSULTIAInvoiceLineDETALLE(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));  // DETALLE
        if not BudgetBuffer.FindFirst() then begin
            BudgetBuffer.Init();
            BudgetBuffer."G/L Account No." := CONSULTIAInvoiceLine.Ref_DPTO;
            BudgetBuffer."Dimension Value Code 1" := GetCONSULTIAInvoiceLineCECO(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
            BudgetBuffer."Dimension Value Code 2" := GetCONSULTIAInvoiceLineProyecto(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
            BudgetBuffer."Dimension Value Code 3" := GetCONSULTIAInvoiceLinePARTIDA(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
            BudgetBuffer."Dimension Value Code 4" := GetCONSULTIAInvoiceLineDETALLE(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
            BudgetBuffer.Insert();
        end;
        case DesProvisioning of
            true:
                BudgetBuffer.Amount -= CONSULTIAInvoiceLine.PVP;
            else
                BudgetBuffer.Amount += CONSULTIAInvoiceLine.PVP;
        end;
        BudgetBuffer.Modify();
    end;

    local procedure CreateJNLLineAprovisionamiento(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; var BudgetBuffer: record "Budget Buffer")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        LastLine: Integer;
    begin
        PurchasesPayablesSetup.Get();
        GenJournalBatch.Get(PurchasesPayablesSetup."CONSULTIA Gen. Jnl. Template", PurchasesPayablesSetup."CONSULTIA Gen. Journal Batch");
        // primero miramos si existen líneas y obtenemos la ultima línea
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if GenJnlLine.FindLast() then
            LastLine := GenJnlLine."Line No." + 10000
        else
            LastLine := 10000;
        BudgetBuffer.Reset();
        if BudgetBuffer.FindFirst() then
            repeat
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := GenJournalBatch."Journal Template Name";
                GenJnlLine."Journal Batch Name" := GenJournalBatch.Name;
                GenJnlLine."Line No." := LastLine;
                GenJnlLine."Posting Date" := Workdate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
                GenJnlLine."Document Date" := CONSULTIAInvoiceHeader.F_Factura;
                GenJnlLine.Insert();
                GenJnlLine."Document No." := CopyStr(CONSULTIAInvoiceHeader.N_Factura, 1, MaxStrLen(GenJnlLine."Document No."));
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.validate("Account No.", BudgetBuffer."G/L Account No.");
                GenJnlLine.Description := CopyStr(StrSubstNo('%1 %2', CONSULTIAInvoiceHeader.N_Factura, CONSULTIAInvoiceHeader.Descripcion), 1, MaxStrLen(GenJnlLine.Description));
                GenJnlLine."External Document No." := CopyStr(CONSULTIAInvoiceHeader.N_Factura, 1, MaxStrLen(GenJnlLine."External Document No."));
                GenJnlLine.Validate(Amount, BudgetBuffer.Amount);
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine.Validate("Bal. Account No.", PurchasesPayablesSetup."CONSULTIA G/L Provide");
                GenJnlLine.Modify();
                LastLine += 10000;
            Until BudgetBuffer.next() = 0;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        JobsSetup: Record "Jobs Setup";
        // lblurlConsultia: Label 'https://api-destinux.consultiatravel.es/B2B.Test';
        lblListaViajero: Label '/api/ListaViajeros';
        lblInvoice: Label '/api/facturas';
        lblDate: Label '?FechaIni=%1&FechaFin=%2';
        lblGetInvoicePDF: Label '/api/Facturas/ObtenerPDF?IdFactura=%1';
        lblDownload: Label 'Descarga de fichero', comment = 'ESP="Descarga de fichero"';

}