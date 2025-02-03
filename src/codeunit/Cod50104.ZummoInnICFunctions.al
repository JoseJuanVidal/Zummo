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
        if metodoREST <> ' ' then
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
        //TaskScheduler.CreateTask(Codeunit::"Zummo Inn. IC Functions", Codeunit::"Error Zummo Inn. IC Functions", true, CompanyName, CURRENTDATETIME + 1000, SalesHeader.RecordId);
        TaskScheduler.CreateTask(Codeunit::"Zummo Inn. IC Functions", Codeunit::"Zummo Inn. IC Functions", true, CompanyName, CURRENTDATETIME + 1000, SalesHeader.RecordId);
    end;

    var
    procedure SendMailOnCreateQuote(var SalesHeader: Record "Sales Header")
    var
        SalesHeader2: Record "Sales Header";
        Quotepdf: Report PedidoCliente;
        FileMgt: Codeunit "File Management";
        FileName: Text;
        XmlParameters: text;
        SubjectLbl: Label 'Create Quote in Zummo Innovaciones - %1 (%2)';
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
        SendMailIC(StrSubstNo(SubjectLbl, SalesHeader."No.", SalesHeader."External Document No."), GetSalesHeaderBodyMail(SalesHeader), SalesHeader."No.", FileName);
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
        // %2 2023-10-10 
        metodo: Label 'search?maxResults=100&jql=project = %1 AND created >= %2 ORDER by ID&fields=key,summary,status,assignee,created&startAt=%3';
        Body: text;
        fecha: date;
        txtFecha: text;
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
        fecha := CalcDate('-1M', WorkDate());
        txtfecha := StrSubstNo('%1-%2-%3', Date2DMY(fecha, 3), Date2DMY(fecha, 2), Date2DMY(fecha, 1));
        JIRA_SW_REST(JobsSetup."url Base", StrSubstNo(metodo, project, txtFecha, IssuesCount), 'GET', Body, true, StatusCode, ResponseText, JobsSetup.user, JobsSetup.token);

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
                    JIRA_SW_REST(JobsSetup."url Base", StrSubstNo(metodo, project, txtFecha, IssuesCount), 'GET', Body, true, StatusCode, ResponseText, JobsSetup.user, JobsSetup.token);
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
    // =============     BCD Travel          ====================
    // ==  
    // ==  importar de Excel del portal de BCD Travel de los albaranes de viajes.
    // ==  
    // ======================================================================================================

    procedure ImportExcelBCDTravelCon07()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        FileName: text;
        Sheetname: text;
        NroAlbaran: code[20];
        OldAlbaran: code[20];
        LineNo: Integer;
        NVInStream: InStream;
        UploadResult: Boolean;
        Rows: Integer;
        i: Integer;
        Text000: label 'Cargar Fichero de Excel';
        lblDialog: Label 'Nro. albarán: #1######################\Fecha:#2########################', comment = 'ESP="Nro. albarán: #1######################\Fecha:#2########################"';
        Window: Dialog;
    begin
        ExcelBuffer.DeleteAll();
        UploadResult := UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream);
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 1);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";
        // primero miramos si existen líneas y obtenemos la ultima línea
        Window.Open(lblDialog);
        for i := 4 to rows do begin  //rows
            NroAlbaran := '';
            ExcelBuffer.SetRange("Row No.", i);
            ExcelBuffer.SetRange("Column No.", 9);
            if ExcelBuffer.FindSet() then
                NroAlbaran := ExcelBuffer."Cell Value as Text";
            Window.Update(1, NroAlbaran);
            if NroAlbaran <> '' then begin
                if OldAlbaran <> NroAlbaran then begin
                    // cerramos el albaran y Dimension proyecto los ponemos igual que el servicio
                    UpdateProyectoNroalbaran(OldAlbaran);

                    OldAlbaran := NroAlbaran;
                    LineNo := 0;
                end;
                LineNo += 10000;
                UpdateBCDTravelHdr(ExcelBuffer, NroAlbaran, i, LineNo);
            end;
        end;
        Window.Close();
    end;

    procedure UpdateProyectoNroalbaran(Nroalbaran: code[20])
    var
        BCDTravelLine: record "ZM BCD Travel Invoice line";
        BCDTravelLine2: record "ZM BCD Travel Invoice line";
        BCDTravelProyecto: record "ZM BCD Travel Proyecto";
    begin
        BCDTravelLine.SetRange("Nro_Albarán", Nroalbaran);
        if BCDTravelLine.FindFirst() then
            repeat
                if not BCDTravelProyecto.Get(BCDTravelLine."Tipo Servicio") then begin
                    BCDTravelLine2.SetRange("Nro_Albarán", Nroalbaran);
                    BCDTravelLine2.SetRange("Nº Billete o Bono", BCDTravelLine."Nº Billete o Bono");
                    if BCDTravelLine2.FindFirst() then
                        repeat
                            if BCDTravelLine2.Proyecto <> '' then begin
                                BCDTravelLine.Proyecto := BCDTravelLine2.Proyecto;
                                BCDTravelLine.Modify();
                            end;
                        Until BCDTravelLine2.next() = 0;
                end;
            Until BCDTravelLine.next() = 0;
    end;

    local procedure UpdateBCDTravelHdr(var ExcelBuffer: Record "Excel Buffer" temporary; NroAlbaran: code[20]; RowNo: Integer; LineNo: Integer)
    var
        BCDTravelHdr: record "ZM BCD Travel Invoice Header";
    begin
        if not BCDTravelHdr.Get(NroAlbaran) then
            CreateBCDTravelHdr(ExcelBuffer, NroAlbaran, RowNo);
        CreateBCDTravelLine(ExcelBuffer, NroAlbaran, RowNo, LineNo);
    end;

    local procedure CreateBCDTravelHdr(var ExcelBuffer: Record "Excel Buffer" temporary; NroAlbaran: code[20]; RowNo: Integer)
    var
        BCDTravelHdr: record "ZM BCD Travel Invoice Header";
        BCDTravelLine: record "ZM BCD Travel Invoice line";
        ValueText: Text;
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        ExcelBuffer.SetRange("Row No.", RowNo);
        BCDTravelHdr.Init();
        BCDTravelHdr."Nro_Albarán" := NroAlbaran;
        ExcelBuffer.SetRange("Column No.", 10);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(Day, copystr(ValueText, 1, 2));
        Evaluate(Month, copystr(ValueText, 4, 2));
        Evaluate(Year, copystr(ValueText, 7, 4));
        BCDTravelHdr."Fecha Albarán" := DMY2Date(Day, Month, Year);
        ExcelBuffer.SetRange("Column No.", 27);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelHdr."Descripcion" := copystr(ValueText, 1, MaxStrLen(BCDTravelHdr.Descripcion));
        ExcelBuffer.SetRange("Column No.", 5);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelHdr."Cod. Centro Coste" := ValueText;
        ExcelBuffer.SetRange("Column No.", 12);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(Day, copystr(ValueText, 1, 2));
        Evaluate(Month, copystr(ValueText, 4, 2));
        Evaluate(Year, copystr(ValueText, 7, 4));
        BCDTravelHdr."Fec Inicio Srv" := DMY2Date(Day, Month, Year);
        ExcelBuffer.SetRange("Column No.", 13);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(Day, copystr(ValueText, 1, 2));
        Evaluate(Month, copystr(ValueText, 4, 2));
        Evaluate(Year, copystr(ValueText, 7, 4));
        BCDTravelHdr."Fec Fin Srv" := DMY2Date(Day, Month, Year);
        ExcelBuffer.SetRange("Column No.", 15);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelHdr."Ciudad Destino" := copystr(ValueText, 1, MaxStrLen(BCDTravelHdr."Ciudad Destino"));
        ExcelBuffer.SetRange("Column No.", 29);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelHdr."Cod Empleado" := ValueText;
        ExcelBuffer.SetRange("Column No.", 30);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelHdr."Nombre Empleado" := copystr(ValueText, 1, MaxStrLen(BCDTravelHdr."Nombre Empleado"));
        BCDTravelHdr.Insert()
    end;

    local procedure CreateBCDTravelLine(var ExcelBuffer: Record "Excel Buffer" temporary; NroAlbaran: code[20]; RowNo: Integer; LineNo: Integer)
    var
        BCDTravelLine: record "ZM BCD Travel Invoice line";
        ValueText: Text;
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        ExcelBuffer.SetRange("Row No.", RowNo);
        BCDTravelLine.Init();
        BCDTravelLine."Nro_Albarán" := NroAlbaran;
        BCDTravelLine."Line No." := LineNo;
        ExcelBuffer.SetRange("Column No.", 10);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(Day, copystr(ValueText, 1, 2));
        Evaluate(Month, copystr(ValueText, 4, 2));
        Evaluate(Year, copystr(ValueText, 7, 4));
        BCDTravelLine."Fecha Albarán" := DMY2Date(Day, Month, Year);
        ExcelBuffer.SetRange("Column No.", 27);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelLine."Descripcion" := ValueText;
        ExcelBuffer.SetRange("Column No.", 28);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelLine."Trayecto Servicio" := ValueText;
        ExcelBuffer.SetRange("Column No.", 5);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelLine."Cod. Centro Coste" := ValueText;
        ExcelBuffer.SetRange("Column No.", 12);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(Day, copystr(ValueText, 1, 2));
        Evaluate(Month, copystr(ValueText, 4, 2));
        Evaluate(Year, copystr(ValueText, 7, 4));
        BCDTravelLine."Fec Inicio Srv" := DMY2Date(Day, Month, Year);
        ExcelBuffer.SetRange("Column No.", 13);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(Day, copystr(ValueText, 1, 2));
        Evaluate(Month, copystr(ValueText, 4, 2));
        Evaluate(Year, copystr(ValueText, 7, 4));
        BCDTravelLine."Fec Fin Srv" := DMY2Date(Day, Month, Year);
        ExcelBuffer.SetRange("Column No.", 15);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelLine."Ciudad Destino" := ValueText;
        ExcelBuffer.SetRange("Column No.", 29);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelLine."Cod Empleado" := ValueText;
        ExcelBuffer.SetRange("Column No.", 30);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelLine."Nombre Empleado" := ValueText;
        ExcelBuffer.SetRange("Column No.", 16);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelLine."Tipo Servicio" := ValueText;
        ExcelBuffer.SetRange("Column No.", 17);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        BCDTravelLine."Nº Billete o Bono" := ValueText;
        ExcelBuffer.SetRange("Column No.", 20);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(BCDTravelLine."%Impuesto", ValueText);
        ExcelBuffer.SetRange("Column No.", 21);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(BCDTravelLine."Imp Base Imponible", ValueText);
        ExcelBuffer.SetRange("Column No.", 22);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(BCDTravelLine."Imp Cuota Impuesto", ValueText);
        ExcelBuffer.SetRange("Column No.", 23);
        if ExcelBuffer.FindSet() then
            ValueText := ExcelBuffer."Cell Value as Text";
        Evaluate(BCDTravelLine."Imp Total", ValueText);
        BCDTravelLine.UpdateProyecto();
        BCDTravelLine.Insert();
        GetEmployeeDimensionsValue(BCDTravelLine);
    end;

    procedure CrearPedidoCompraDesdeBCDTravel(var BCDTravelInvoiceHeader: record "ZM BCD Travel Invoice Header")
    var
        PurchaseSetup: record "Purchases & Payables Setup";
        BCDTravelLine: record "ZM BCD Travel Invoice Line";
        PurchaseHeader: record "Purchase Header";
        PurchRcptHeader: record "Purch. Rcpt. Header";
        PurchPost: Codeunit "Purch.-Post";
        LineNo: Integer;
        lblCreate: Label 'Order %1 and Receipt %2 have been created.\¿Do you want to open the Receipt?', comment = 'ESP="Se ha creado el pedido %1 y albarán %2.\¿Desea Abrir el albarán?"';
    begin
        PurchaseSetup.Get();
        PurchaseSetup.TestField("BCD Travel Vendor No.");
        BCDTravelInvoiceHeader.SetRange("Receipt created", false);
        BCDTravelDimension(BCDTravelInvoiceHeader);

        if not BCDTravelInvoiceHeader.FindFirst() then
            exit;
        BCDTravelCreatePurchaseHeader(PurchaseHeader, PurchaseSetup."BCD Travel Vendor No.", BCDTravelInvoiceHeader);
        // primero chequeamos los datos de empleados y dimensiones

        if BCDTravelInvoiceHeader.FindFirst() then
            repeat
                BCDTravelLine.Reset();
                BCDTravelLine.SetRange("Nro_Albarán", BCDTravelInvoiceHeader."Nro_Albarán");
                if BCDTravelLine.FindFirst() then
                    repeat
                        LineNo += 10000;
                        BCDTravelCreatePurchaseLine(PurchaseHeader, BCDTravelLine, LineNo);
                    Until BCDTravelLine.next() = 0;
                BCDTravelInvoiceHeader."Receipt created" := true;
                BCDTravelInvoiceHeader."Purchase Order" := PurchaseHeader."No.";
                BCDTravelInvoiceHeader.Modify();
            Until BCDTravelInvoiceHeader.next() = 0;

        PurchaseHeader.Receive := true;
        PurchaseHeader.Invoice := false;
        PurchPost.Run(PurchaseHeader);
        PurchRcptHeader.SetRange("Order No.", PurchaseHeader."No.");
        if PurchRcptHeader.FindFirst() then begin
            BCDTravelInvoiceHeader.SetRange("Purchase Order", PurchaseHeader."No.");
            BCDTravelInvoiceHeader.ModifyAll("Purch. Rcpt. Order", PurchRcptHeader."No.");
        end;
        page.Run(Page::"Purchase Order", PurchaseHeader);

    end;

    procedure BCDTravelCreatePurchaseOrderFromNroAlbaran(var BCDTravelHeader: record "ZM BCD Travel Invoice Header")
    var
        PurchaseSetup: record "Purchases & Payables Setup";
        BCDTravelLine: record "ZM BCD Travel Invoice Line";
        PurchaseHeader: record "Purchase Header";
        PurchRcptHeader: record "Purch. Rcpt. Header";
        PurchPost: Codeunit "Purch.-Post";
        LineNo: Integer;
        lblCreate: Label 'Order %1 and Receipt %2 have been created.\¿Do you want to open the Receipt?', comment = 'ESP="Se ha creado el pedido %1 y albarán %2.\¿Desea Abrir el albarán?"';
    begin
        PurchaseSetup.Get();
        PurchaseSetup.TestField("BCD Travel Vendor No.");
        BCDTravelCreatePurchaseHeader(PurchaseHeader, PurchaseSetup."BCD Travel Vendor No.", BCDTravelHeader);
        BCDTravelLine.Reset();
        BCDTravelLine.SetRange("Nro_Albarán", BCDTravelHeader."Nro_Albarán");
        if BCDTravelLine.FindFirst() then
            repeat
                LineNo += 10000;
                BCDTravelCreatePurchaseLine(PurchaseHeader, BCDTravelLine, LineNo);
            Until BCDTravelLine.next() = 0;

        BCDTravelHeader."Receipt created" := true;
        BCDTravelHeader."Purchase Order" := PurchaseHeader."No.";
        PurchaseHeader.Receive := true;
        PurchaseHeader.Invoice := false;
        BCDTravelHeader.Modify();
        PurchPost.Run(PurchaseHeader);
        PurchRcptHeader.SetRange("Order No.", PurchaseHeader."No.");
        if PurchRcptHeader.FindFirst() then begin
            BCDTravelHeader."Purch. Rcpt. Order" := PurchRcptHeader."No.";
            BCDTravelHeader.Modify();
        end;
        page.Run(Page::"Purchase Order", PurchaseHeader);
        // PurchRcptHeader.Reset();
        // PurchRcptHeader.SetRange("Order No.", PurchaseHeader."No.");
        // if PurchRcptHeader.FindLast() then
        //     if confirm(lblCreate, false, PurchaseHeader."No.", PurchRcptHeader) then
        //         ShowPurchRcptOrder(PurchRcptHeader."No.");
    end;

    procedure BCDTravelDimension(var BCDTravelInvoiceHeader: record "ZM BCD Travel Invoice Header")
    var
        PurchaseSetup: record "Purchases & Payables Setup";
    begin
        PurchaseSetup.Get();
        PurchaseSetup.TestField("BCD Travel Vendor No.");
        // primero chequeamos los datos de empleados y dimensiones
        if BCDTravelInvoiceHeader.FindFirst() then
            repeat
                if not BCDTravelInvoiceHeader."Receipt created" then
                    CheckBCDTravelHeaderDimensions(BCDTravelInvoiceHeader);
            Until BCDTravelInvoiceHeader.next() = 0;

    end;

    procedure CheckBCDTravelHeaderDimensions(BCDTravelHeader: record "ZM BCD Travel Invoice Header")
    var
        BCDTravelLine: record "ZM BCD Travel Invoice Line";
        DimensionValue: text;
        lblError: Label 'Debe tener valor la dimension %1 del empleado %2.', comment = 'ESP="Debe tener valor la dimension %1 del empleado %2."';
    begin
        BCDTravelLine.SetRange("Nro_Albarán", BCDTravelHeader."Nro_Albarán");
        if BCDTravelLine.FindFirst() then
            repeat
                GetEmployeeDimensionsValue(BCDTravelLine);

                DimensionValue := GetBCDTravelLineCECO(BCDTravelHeader, BCDTravelLine);
                // PROYECTO
                DimensionValue := GetBCDTravelLineProyecto(BCDTravelHeader, BCDTravelLine);
                // PARTIDA
                DimensionValue := GetBCDTravelLinePartida(BCDTravelHeader, BCDTravelLine);
                // DETALLE
                DimensionValue := GetBCDTravelLineDetalle(BCDTravelHeader, BCDTravelLine);
                // DEPART CODIGO (APROBACIONES)
                BCDTravelLine.TestField(DEPART);
            Until BCDTravelLine.next() = 0;
    end;

    local procedure BCDTravelCreatePurchaseHeader(var PurchaseHeader: record "Purchase Header"; VendorNo: code[20]; BCDTravelInvoiceHeader: Record "ZM BCD Travel Invoice Header")
    var
        myInt: Integer;
    begin
        // Crear la cabecera del pedido de compra
        PurchaseHeader.Init();
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.InitInsert();
        PurchaseHeader.Validate("Buy-from Vendor No.", VendorNo);
        PurchaseHeader.Validate("Posting Date", WorkDate());
        PurchaseHeader."Vendor Shipment No." := BCDTravelInvoiceHeader."Nro_Albarán";
        PurchaseHeader.Insert();
    end;

    local procedure BCDTravelCreatePurchaseLine(PurchaseHeader: Record "Purchase Header"; BCDTravelLine: record "ZM BCD Travel Invoice Line"; LineNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
        BCDTravelHeader: record "ZM BCD Travel Invoice Header";
        BCDTravelEmpleado: record "ZM BCD Travel Empleado";
        txtDescription: text;
        lblDescription: Label 'EnglishText', comment = 'ESP="%1 %2 %3 %4 %5"';
    begin
        BCDTravelHeader.Get(BCDTravelLine."Nro_Albarán");
        BCDTravelEmpleado.Get(BCDTravelLine."Cod Empleado");
        PurchaseLine.Init();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
        PurchaseLine."Line No." := LineNo;
        PurchaseLine.Insert();
        PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
        if BCDTravelHeader."G/L Account Fair" = '' then
            PurchaseLine.Validate("No.", BCDTravelEmpleado."G/L Account")
        else
            PurchaseLine.Validate("No.", BCDTravelHeader."G/L Account Fair");
        txtDescription := StrSubstNo(lblDescription, BCDTravelLine."Tipo Servicio", BCDTravelLine."Trayecto Servicio", BCDTravelLine."Nombre Empleado",
                BCDTravelLine."Fec Inicio Srv", BCDTravelLine."Fec Fin Srv");
        PurchaseLine.Description := copystr(txtDescription, 1, 100);
        PurchaseLine."Description 2" := copystr(txtDescription, 101, MaxStrLen(PurchaseLine."Description 2"));
        PurchaseLine.Validate(Quantity, 1);
        PurchaseLine.Validate("VAT Bus. Posting Group", PurchaseHeader."VAT Bus. Posting Group");
        PurchaseLine.Validate("VAT Prod. Posting Group", GetVATProdPostingGroup(BCDTravelLine, PurchaseHeader));
        PurchaseLine.Validate("Direct Unit Cost", BCDTravelLine."Imp Base Imponible");
        PurchaseLine.Validate("Shortcut Dimension 1 Code", BCDTravelLine."Cod. Centro Coste");
        // PurchaseLine.IdCorp_Sol := CONSULTIAInvoiceLine.IdCorp_Sol;
        PurchaseLine.Validate("Qty. to Receive", PurchaseLine.Quantity);
        PurchaseLine.Modify();
        BCDTravelSetPurchaseLineDimensiones(BCDTravelLine, PurchaseLine);
    end;

    local procedure GetVATProdPostingGroup(BCDTravelLine: record "ZM BCD Travel Invoice Line"; PurchaseHeader: Record "Purchase Header"): code[20]
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        VATPostingSetup.Reset();
        VATPostingSetup.SetFilter("VAT Prod. Posting Group", '%1', '*SERV');
        VATPostingSetup.SetRange("VAT Bus. Posting Group", PurchaseHeader."VAT Bus. Posting Group");
        VATPostingSetup.SetRange("VAT %", BCDTravelLine."%Impuesto");
        if VATPostingSetup.FindFirst() then
            exit(VATPostingSetup."VAT Prod. Posting Group");
    end;

    local procedure BCDTravelSetPurchaseLineDimensiones(BCDTravelLine: record "ZM BCD Travel Invoice Line"; var PurchaseLine: Record "Purchase Line")
    var
        GLSetup: Record "General Ledger Setup";
        BCDTravelHeader: record "ZM BCD Travel Invoice Header";
        recNewDimSetEntry: record "Dimension Set Entry" temporary;
        cduDimMgt: Codeunit DimensionManagement;
        cduCambioDim: Codeunit CambioDimensiones;
        GlobalDim1: code[20];
        GlobalDim2: code[20];
        intDimSetId: Integer;
    begin
        GLSetup.Get();
        BCDTravelHeader.Get(BCDTravelLine."Nro_Albarán");
        // CECO
        // Empleado y Unico por feria MK (campo proyecto de cabecera)
        GlobalDim1 := GetBCDTravelLineCECO(BCDTravelHeader, BCDTravelLine);
        recNewDimSetEntry.Init();
        recNewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 1 Code";
        recNewDimSetEntry.Validate("Dimension Value Code", GlobalDim1);
        recNewDimSetEntry.Insert();

        // PROYECTO
        recNewDimSetEntry.Init();
        recNewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 2 Code";
        recNewDimSetEntry.Validate("Dimension Value Code", GetBCDTravelLineProyecto(BCDTravelHeader, BCDTravelLine));
        recNewDimSetEntry.Insert();
        // PARTIDA
        recNewDimSetEntry.Init();
        recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
        recNewDimSetEntry.Validate("Dimension Value Code", GetBCDTravelLinePartida(BCDTravelHeader, BCDTravelLine));
        recNewDimSetEntry.Insert();
        // DETALLE
        recNewDimSetEntry.Init();
        recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 3 Code";
        recNewDimSetEntry.Validate("Dimension Value Code", GetBCDTravelLineDetalle(BCDTravelHeader, BCDTravelLine));
        recNewDimSetEntry.Insert();
        // DEPART CODIGO (APROBACIONES)
        if BCDTravelLine.DEPART <> '' then begin
            recNewDimSetEntry.Init();
            recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 4 Code";
            recNewDimSetEntry.Validate("Dimension Value Code", BCDTravelLine.DEPART);
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

    local procedure GetBCDTravelLineCECO(BCDTravelHeader: record "ZM BCD Travel Invoice Header"; BCDTravelLine: record "ZM BCD Travel Invoice Line"): code[50]
    begin
        if BCDTravelHeader."Global Dimension 1 code Fair" <> '' then
            exit(BCDTravelHeader."Global Dimension 1 code Fair");
        BCDTravelLine.TestField("Cod. Centro Coste");
        exit(BCDTravelLine."Cod. Centro Coste");
    end;

    local procedure GetBCDTravelLineProyecto(BCDTravelHeader: record "ZM BCD Travel Invoice Header"; BCDTravelLine: record "ZM BCD Travel Invoice Line"): code[50]
    begin
        BCDTravelLine.CalcFields(Proyecto);
        BCDTravelLine.TestField(Proyecto);
        exit(BCDTravelLine.Proyecto);
    end;

    local procedure GetBCDTravelLinePartida(BCDTravelHeader: record "ZM BCD Travel Invoice Header"; BCDTravelLine: record "ZM BCD Travel Invoice Line"): code[50]
    begin
        if BCDTravelHeader."Dimension Partida Fair" <> '' then
            exit(BCDTravelHeader."Dimension Partida Fair");
        BCDTravelLine.TestField(Partida);
        exit(BCDTravelLine.Partida);
    end;

    local procedure GetBCDTravelLineDetalle(BCDTravelHeader: record "ZM BCD Travel Invoice Header"; BCDTravelLine: record "ZM BCD Travel Invoice Line"): code[50]
    begin
        if BCDTravelHeader."Dimension Detalle Fair" <> '' then
            exit(BCDTravelHeader."Dimension Detalle Fair");
        BCDTravelLine.TestField(Detalle);
        exit(BCDTravelLine.Detalle);
    end;

    procedure BCDTravelAssingEmployee(var BCDTravelLine: record "ZM BCD Travel Invoice Line")
    var
        Employee: Record Employee;
        EmployeeList: Page "Employee List";
        BCDTravelEmpleado: record "ZM BCD Travel Empleado";
        BCDTravelEmpleados: page "ZM BCD Travel Empleado";
    begin
        BCDTravelLine.TestField("Cod Empleado");
        if not BCDTravelEmpleado.Get(BCDTravelLine."Cod Empleado") then begin
            BCDTravelEmpleado.Init();
            BCDTravelEmpleado.Codigo := BCDTravelLine."Cod Empleado";
            BCDTravelEmpleado.Nombre := BCDTravelLine."Nombre Empleado";
            BCDTravelEmpleado.Insert();
            Commit();
            BCDTravelEmpleado.SetRange(Codigo, BCDTravelLine."Cod Empleado");
            BCDTravelEmpleados.LookupMode := true;
            BCDTravelEmpleados.SetTableView(BCDTravelEmpleado);
            if not (BCDTravelEmpleados.RunModal() = Action::LookupOK) then
                exit;
            BCDTravelEmpleados.GetRecord(BCDTravelEmpleado);
        end;

        BCDTravelEmpleado.TestField("Employee Code");
        GetEmployeeDimensionsValue(BCDTravelLine);

    end;

    procedure GetEmployeeDimensionsValue(var BCDTravelLine: record "ZM BCD Travel Invoice Line")
    var
        GLSetup: record "General Ledger Setup";
        DimensionValue: record "Dimension Value";
        DefaultDimension: Record "Default Dimension";
        DimSetEntry: Record "Dimension Set Entry" temporary;
        Employee: Record Employee;
        BCDTravelEmpleado: record "ZM BCD Travel Empleado";
        DimensionMgt: Codeunit DimensionManagement;
        DimensionSetIDArr: ARRAY[10] OF Integer;
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
        GlobalDim1Code: code[20];
        GlobalDim2Code: code[20];
        DimSetID: Integer;
    begin
        if not BCDTravelEmpleado.Get(BCDTravelLine."Cod Empleado") then
            exit;
        if Employee.Get(BCDTravelEmpleado."Employee Code") then begin
            // CECO - Partida - Detalle - Depart
            // 1       8           3         4
            GLSetup.Get();
            TableID[1] := Database::Employee;
            No[1] := Employee."No.";
            DimSetID := DimensionMgt.GetDefaultDimID(TableID, No, '', GlobalDim1Code, GlobalDim2Code, DimSetID, 0);
            DimensionMgt.GetDimensionSet(DimSetEntry, DimSetID);
            DimSetEntry.Reset();
            if BCDTravelLine.Detalle = '' then begin
                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                if DimSetEntry.FindFirst() then begin
                    BCDTravelLine.Detalle := DimSetEntry."Dimension Value Code";
                    DimensionValueBlocked(DimSetEntry);
                end;
            end;
            if BCDTravelLine.Partida = '' then begin
                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                if DimSetEntry.FindFirst() then begin
                    BCDTravelLine.Partida := DimSetEntry."Dimension Value Code";
                    DimensionValueBlocked(DimSetEntry);
                end;
            end;
            if BCDTravelLine.DEPART = '' then begin
                DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                if DimSetEntry.FindFirst() then begin
                    BCDTravelLine.DEPART := DimSetEntry."Dimension Value Code";
                    DimensionValueBlocked(DimSetEntry);
                end;
            end;
            BCDTravelLine.Modify();
        end;
    end;

    local procedure DimensionValueBlocked(DimSetEntry: Record "Dimension Set Entry")
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.SetRange("Dimension Code", DimSetEntry."Dimension Code");
        DimensionValue.SetRange(Code, DimSetEntry."Dimension Value Code");
        DimensionValue.FindFirst();
        DimensionValue.TestField(Blocked, false);
    end;

    local procedure ShowPurchRcptOrder(PurchRcptHeaderNo: code[20])
    var
        PurchRcptHeader: record "Purch. Rcpt. Header";
        PostedPurchReceipt: page "Posted Purchase Receipt";
        lblConfirm: Label '¿Desea abrir el %1 %2?', comment = 'ESP="¿Desea abrir el %1 %2?"';
    begin

        PurchRcptHeader.SetRange("No.", PurchRcptHeaderNo);
        PostedPurchReceipt.SetTableView(PurchRcptHeader);
        PostedPurchReceipt.Run();
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

    // 

    // ======================================================================================================
    // =============     Get Lista Viajeros          ====================
    // ==  
    // ==  Detalle de los empleados de su organización registrados en nuestros sistemas. 
    // ==  
    // ======================================================================================================
    // procedure GetListaViajeros()
    // var
    //     JsonBody: JsonObject;
    //     JsonResponse: JsonObject;
    //     JsonTokResponse: JsonToken;
    //     ErrorText: Text;
    //     StatusCode: Integer;
    // begin
    //     REST_CONSULTIA(lblListaViajero, 'GET', '', true, StatusCode, JsonResponse, false);
    //     Message(format(JsonResponse));

    // end;

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
    // procedure GetInvoicebyDate(Startdate: Date; EndDate: date)
    // var
    //     Vendor: Record Vendor;
    //     CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header";
    //     JsonBody: JsonObject;
    //     JsonResponse: JsonObject;
    //     JsonTokResponse: JsonToken;
    //     JsonEmisor: JsonObject;
    //     JsonReceptor: JsonObject;
    //     JsonFacturas: JsonArray;
    //     JsonFactura: JsonToken;
    //     JsonFacturaDetails: JsonArray;
    //     JsonFacturaDetail: JsonToken;
    //     ErrorText: Text;
    //     Metodo: text;
    //     Valuetext: text;
    //     VendorName: text;
    //     StatusCode: Integer;
    //     Window: Dialog;
    //     lblDlg: Label 'Invoice No. #1################', comment = 'ESP="Nº Factura #1################"';
    // begin
    //     Window.Open(lblDlg);
    //     Metodo := lblInvoice + StrSubstNo(lblDate, format(Startdate, 0, '<day,2>/<Month,2>/<Year4>'), format(EndDate, 0, '<day,2>/<Month,2>/<Year4>'));

    //     REST_CONSULTIA(Metodo, 'GET', '', true, StatusCode, JsonResponse, false);


    //     JsonEmisor := GetJSONItemFieldObject(JsonResponse.AsToken(), 'Emisor');
    //     JsonReceptor := GetJSONItemFieldObject(JsonResponse.AsToken(), 'Receptor');
    //     JsonFacturas := GetJSONItemFieldArray(JsonResponse.AsToken(), 'Facturas');

    //     Valuetext := GetJSONItemFieldText(JsonEmisor.AsToken(), 'CIF');
    //     VendorName := GetJSONItemFieldText(JsonEmisor.AsToken(), 'Razon_social');
    //     Vendor.Reset();
    //     Vendor.SetRange("VAT Registration No.", Valuetext);
    //     if vendor.FindFirst() then;
    //     // ValueText := GetJSONItemFieldText(JsonReceptor.AsToken(), 'Razon_social');

    //     foreach JsonFactura in JsonFacturas do begin
    //         AddInvoiceHeader(CONSULTIAInvoiceHeader, JsonFactura, Vendor."No.", VendorName, Valuetext);
    //         Window.Update(1, CONSULTIAInvoiceHeader.N_Factura);

    //         JsonFacturaDetails := GetJSONItemFieldArray(JsonFactura, 'Detalles');

    //         foreach JsonFacturaDetail in JsonFacturaDetails do begin
    //             AddInvoiceDetails(CONSULTIAInvoiceHeader, JsonFacturaDetail);
    //         end;

    //         CreateRecordLinkPDF(CONSULTIAInvoiceHeader);

    //         Commit();
    //     end;
    //     Window.Close();
    // end;

    // local procedure CreateRecordLinkPDF(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header")
    // var
    //     DocumentAttachment: Record "Document Attachment";
    //     TempBlob: Record TempBlob;
    //     FileManagement: Codeunit "File Management";
    //     Instr: InStream;
    //     FileName: text;
    // begin
    //     if CallGetInvoicePdf(CONSULTIAInvoiceHeader.Id, InStr) then begin
    //         FileName := CONSULTIAInvoiceHeader.N_Factura + '.pdf';
    //         DocumentAttachment.Reset();
    //         DocumentAttachment.SetRange("Table ID", Database::"ZM CONSULTIA Invoice Header");
    //         DocumentAttachment.SetRange("No.", CONSULTIAInvoiceHeader.N_Factura);
    //         if DocumentAttachment.FindFirst() then
    //             exit;
    //         DocumentAttachment.Init();
    //         DocumentAttachment."Table ID" := Database::"ZM CONSULTIA Invoice Header";
    //         DocumentAttachment."No." := CONSULTIAInvoiceHeader.N_Factura;
    //         DocumentAttachment."Attached Date" := CreateDateTime(Today, time);
    //         DocumentAttachment."Attached By" := UserSecurityId();
    //         DocumentAttachment.Validate("File Extension", FileManagement.GetExtension(FileName));
    //         DocumentAttachment.Validate("File Name", CONSULTIAInvoiceHeader.N_Factura);
    //         DocumentAttachment."Document Reference ID".ImportStream(Instr, FileName);
    //         DocumentAttachment.Insert(true)
    //     end
    // end;

    // local procedure AddInvoiceHeader(var CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; JsonFactura: JsonToken; VendorNo: text;
    //     VendorName: Text; VatRegistrationNo: text[20])
    // var
    //     FieldValue: text;
    //     FieldValueInt: Integer;
    // begin
    //     FieldValue := GetJSONItemFieldText(JsonFactura, 'ID_Factura');
    //     Evaluate(FieldValueInt, FieldValue);
    //     if CONSULTIAInvoiceHeader.Get(FieldValueInt) then
    //         exit;
    //     CONSULTIAInvoiceHeader.Init();
    //     CONSULTIAInvoiceHeader.Id := FieldValueInt;
    //     CONSULTIAInvoiceHeader.N_Factura := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(N_Factura));
    //     CONSULTIAInvoiceHeader."N_Pedido" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(N_Pedido));
    //     CONSULTIAInvoiceHeader."F_Factura" := DT2Date(GetJSONItemFieldDateTime(JsonFactura, CONSULTIAInvoiceHeader.FieldName(F_Factura)));
    //     CONSULTIAInvoiceHeader."Descripcion" := GetJSONItemFieldText(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Descripcion));
    //     CONSULTIAInvoiceHeader."IdCorp_Sol" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(IdCorp_Sol));
    //     CONSULTIAInvoiceHeader."Nombre_Sol" := GetJSONItemFieldText(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Nombre_Sol));
    //     CONSULTIAInvoiceHeader."Proyecto" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Proyecto));
    //     CONSULTIAInvoiceHeader."Ref_Ped_Cl" := GetJSONItemFieldText(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Ref_Ped_Cl));
    //     CONSULTIAInvoiceHeader."Responsable_compra" := GetJSONItemFieldText(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Responsable_compra));
    //     CONSULTIAInvoiceHeader."Tipo" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Tipo));
    //     CONSULTIAInvoiceHeader."FacturaRectificada" := GetJSONItemFieldCode(JsonFactura, CONSULTIAInvoiceHeader.FieldName(FacturaRectificada));
    //     CONSULTIAInvoiceHeader."Total_Base" := GetJSONItemFieldDecimal(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Total_Base));
    //     CONSULTIAInvoiceHeader."Total_Impuesto" := GetJSONItemFieldDecimal(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Total_Impuesto));
    //     CONSULTIAInvoiceHeader."Total_Tasas_Exentas" := GetJSONItemFieldDecimal(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Total_Tasas_Exentas));
    //     CONSULTIAInvoiceHeader."Total" := GetJSONItemFieldDecimal(JsonFactura, CONSULTIAInvoiceHeader.FieldName(Total));
    //     CONSULTIAInvoiceHeader."Vendor No." := CopyStr(VendorNo, 1, MaxStrLen(CONSULTIAInvoiceHeader."Vendor No."));
    //     CONSULTIAInvoiceHeader."Vendor Name" := CopyStr(VendorName, 1, MaxStrLen(CONSULTIAInvoiceHeader."Vendor Name"));
    //     CONSULTIAInvoiceHeader."Vat Registration No." := VatRegistrationNo;
    //     CONSULTIAInvoiceHeader.Status := CONSULTIAInvoiceHeader.Status::Abierto;
    //     CONSULTIAInvoiceHeader.Insert();
    // end;

    // local procedure AddInvoiceDetails(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; JsonFacturaDetail: JsonToken)
    // var
    //     CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
    //     FieldValue: text;
    //     FieldValueInt: Integer;
    // begin
    //     FieldValue := GetJSONItemFieldText(JsonFacturaDetail, 'Numero');
    //     Evaluate(FieldValueInt, FieldValue);
    //     if CONSULTIAInvoiceLine.Get(CONSULTIAInvoiceHeader.id, FieldValueInt) then
    //         exit;
    //     CONSULTIAInvoiceLine.Init();
    //     CONSULTIAInvoiceLine.Id := CONSULTIAInvoiceHeader.Id;
    //     CONSULTIAInvoiceLine.N_Factura := CONSULTIAInvoiceHeader.N_Factura;
    //     CONSULTIAInvoiceLine.Numero := GetJSONItemFieldInteger(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Numero));
    //     CONSULTIAInvoiceLine."Desc_servicio" := GetJSONItemFieldtext(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Desc_servicio));
    //     CONSULTIAInvoiceLine."Proveedor" := GetJSONItemFieldtext(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Proveedor));
    //     CONSULTIAInvoiceLine."F_Ini" := DT2Date(GetJSONItemFieldDateTime(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(F_Ini)));
    //     CONSULTIAInvoiceLine."F_Fin" := DT2Date(GetJSONItemFieldDateTime(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(F_Fin)));
    //     CONSULTIAInvoiceLine."IdCorp_Usuario" := GetJSONItemFieldcode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(IdCorp_Usuario));
    //     CONSULTIAInvoiceLine."Usuario" := GetJSONItemFieldtext(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Usuario));
    //     CONSULTIAInvoiceLine."Ref_Usuario" := GetJSONItemFieldtext(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Ref_Usuario));
    //     CONSULTIAInvoiceLine."Ref_DPTO" := GetJSONItemFieldText(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Ref_DPTO));
    //     CONSULTIAInvoiceLine."Producto" := GetJSONItemFieldCode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Producto));
    //     CONSULTIAInvoiceLine."Base" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Base));
    //     CONSULTIAInvoiceLine."Porc_IVA" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Porc_IVA));
    //     CONSULTIAInvoiceLine."Porc_IVA" := CONSULTIAInvoiceLine."Porc_IVA" * 100;
    //     CONSULTIAInvoiceLine."Imp_IVA" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Imp_IVA));
    //     CONSULTIAInvoiceLine."Tasas" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(Tasas));
    //     CONSULTIAInvoiceLine."PVP" := GetJSONItemFielddecimal(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(PVP));
    //     CONSULTIAInvoiceLine."IdCorp_Sol" := GetJSONItemFieldCode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(IdCorp_Sol));
    //     GetEmployeeDimensionsValue(CONSULTIAInvoiceLine);
    //     CONSULTIAInvoiceLine."IdServicio" := GetJSONItemFieldCode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(IdServicio));
    //     CONSULTIAInvoiceLine."NumeroLineaServicio" := GetJSONItemFieldInteger(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(NumeroLineaServicio));
    //     CONSULTIAInvoiceLine."CodigoProducto" := GetJSONItemFieldCode(JsonFacturaDetail, CONSULTIAInvoiceLine.FieldName(CodigoProducto));
    //     CONSULTIAInvoiceLine.Insert();
    // end;



    // procedure GetGLAccountDimensionsValue(var CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line")
    // var
    //     GLSetup: record "General Ledger Setup";
    //     CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header";
    //     DefaultDimension: Record "Default Dimension";
    //     DimSetEntry: Record "Dimension Set Entry" temporary;
    //     DimensionMgt: Codeunit DimensionManagement;
    //     GLAccount: code[20];
    //     DimensionSetIDArr: ARRAY[10] OF Integer;
    //     TableID: ARRAY[10] OF Integer;
    //     No: ARRAY[10] OF Code[20];
    //     GlobalDim1Code: code[20];
    //     GlobalDim2Code: code[20];
    //     DimSetID: Integer;
    // begin
    //     GLSetup.Get();
    //     if CONSULTIAInvoiceHeader."G/L Account Fair" = '' then
    //         GLAccount := CONSULTIAInvoiceLine.Ref_DPTO
    //     else
    //         GLAccount := CONSULTIAInvoiceHeader."G/L Account Fair";
    //     TableID[1] := Database::"G/L Account";
    //     No[1] := GLAccount;
    //     DimSetID := DimensionMgt.GetDefaultDimID(TableID, No, '', GlobalDim1Code, GlobalDim2Code, DimSetID, 0);
    //     DimensionMgt.GetDimensionSet(DimSetEntry, DimSetID);
    //     DimSetEntry.Reset();
    //     DimSetEntry.SetRange("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
    //     if DimSetEntry.FindFirst() then
    //         CONSULTIAInvoiceLine.Partida := DimSetEntry."Dimension Value Code";
    // end;

    // procedure GetInvoicePdf(CONSULTIAInvoiceHeader: Record "ZM BCD Travel Invoice Header")
    // var
    //     Instr: InStream;
    //     FileName: text;
    //     lblConfirm: Label '¿Would you like to download the PDF of invoice %1?', comment = 'ESP="¿Desea descargar el PDF de la factura %1?"';
    // begin
    //     if Confirm(lblConfirm, false, CONSULTIAInvoiceHeader.N_Factura) then
    //         if CallGetInvoicePdf(CONSULTIAInvoiceHeader.Id, Instr) then begin
    //             FileName := CONSULTIAInvoiceHeader.N_Factura + '.pdf';
    //             DownloadFromStream(Instr, lblDownload, '', '', FileName);
    //         end;
    // end;

    // local procedure CallGetInvoicePdf(Id: integer; var Instr: InStream): Boolean
    // var
    //     JsonResponse: JsonObject;
    //     Metodo: text;
    //     FileName: Text;
    //     StatusCode: Integer;

    // begin
    //     Metodo := StrSubstNo(lblGetInvoicePDF, format(Id));

    //     if GetResponsePDF(Metodo, Instr) then
    //         exit(true);

    // end;

    // local procedure GetResponsePDF(metodo: text; var Stream: InStream): Boolean
    // var
    //     TempBlob: Record TempBlob;
    //     Client: HttpClient;
    //     Headers: HttpHeaders;
    //     RequestMessage: HttpRequestMessage;
    //     ResponseMessage: HttpResponseMessage;
    //     RequestContent: HttpContent;
    //     Url: text;
    //     StringAuthorization: text;
    //     User: text;
    //     PassWebServKey: text;
    //     StringAuth: text;
    //     IsSucces: Boolean;
    // begin
    //     PurchasesPayablesSetup.Get();
    //     PurchasesPayablesSetup.TestField("CONSULTIA Url");
    //     PurchasesPayablesSetup.TestField("CONSULTIA User");
    //     PurchasesPayablesSetup.TestField("CONSULTIA Password");
    //     //Creamos una url
    //     Url := PurchasesPayablesSetup."CONSULTIA Url" + metodo;


    //     RequestMessage.SetRequestUri(Url);
    //     RequestMessage.Method := 'GET';

    //     User := PurchasesPayablesSetup."CONSULTIA User";
    //     PassWebServKey := PurchasesPayablesSetup."CONSULTIA Password";
    //     TempBlob.WriteTextLine(User + ':' + PassWebServKey);
    //     StringAuth := TempBlob.ToBase64String();
    //     StringAuthorization := 'Basic ' + StringAuth;

    //     //Creamos la cabecera de athorization
    //     Headers := Client.DefaultRequestHeaders();
    //     Headers.Add('Authorization', StringAuthorization);

    //     if Client.Send(RequestMessage, ResponseMessage) then
    //         if ResponseMessage.IsSuccessStatusCode() then begin
    //             if ResponseMessage.Content.ReadAs(Stream) then
    //                 IsSucces := true;
    //         end else
    //             ResponseMessage.Content.ReadAs(Stream);

    //     exit(IsSucces);
    // end;

    // procedure CreatePurchaseInvoice(var CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header")
    // var
    //     PurchaseHeader: Record "Purchase Header";
    //     lblInvoice: Label 'Create la %1 %2.', comment = 'ESP="Creada la %1 %2."';
    // begin
    //     CONSULTIAInvoiceHeader.TestField("Pre Invoice No.", '');
    //     CONSULTIAInvoiceHeader.TestField("Invoice Header No.", '');
    //     case true of
    //         CONSULTIAInvoiceHeader.Total >= 0:
    //             CONSULTIAInvoiceHeader."Document Type" := CONSULTIAInvoiceHeader."Document Type"::Invoice;
    //         else
    //             CONSULTIAInvoiceHeader."Document Type" := CONSULTIAInvoiceHeader."Document Type"::"Credit Memo";
    //     end;

    //     AddPurchaseHeaderfromCONSULTIA(CONSULTIAInvoiceHeader, PurchaseHeader);

    //     AddPurchaseLinefromCONSULTIA(CONSULTIAInvoiceHeader, PurchaseHeader);

    //     CopyDocumentAttachment(CONSULTIAInvoiceHeader, PurchaseHeader);

    //     CONSULTIAInvoiceHeader."Pre Invoice No." := PurchaseHeader."No.";
    //     CONSULTIAInvoiceHeader.Modify();

    //     Message(lblInvoice, PurchaseHeader."Document Type", PurchaseHeader."No.");
    // end;

    // local procedure AddPurchaseHeaderfromCONSULTIA(var CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; var PurchaseHeader: Record "Purchase Header")
    // var
    //     Vendor: Record Vendor;
    // begin
    //     if CONSULTIAInvoiceHeader."Vendor No." = '' then begin
    //         Vendor.Get(GetVendorNoByVatRegistrationNo(CONSULTIAInvoiceHeader."Vat Registration No."));
    //         CONSULTIAInvoiceHeader."Vendor No." := Vendor."No.";
    //     end;

    //     PurchaseHeader.Init();
    //     PurchaseHeader.InitInsert();
    //     case CONSULTIAInvoiceHeader."Document Type" of
    //         CONSULTIAInvoiceHeader."Document Type"::Invoice:
    //             PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
    //         CONSULTIAInvoiceHeader."Document Type"::"Credit Memo":
    //             PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
    //     end;
    //     PurchaseHeader.Validate("Buy-from Vendor No.", CONSULTIAInvoiceHeader."Vendor No.");
    //     PurchaseHeader.Validate("Posting Date", WorkDate());
    //     PurchaseHeader.Validate("Document Date", CONSULTIAInvoiceHeader.F_Factura);
    //     case CONSULTIAInvoiceHeader."Document Type" of
    //         CONSULTIAInvoiceHeader."Document Type"::Invoice:
    //             PurchaseHeader."Vendor Invoice No." := CONSULTIAInvoiceHeader.N_Factura;
    //         CONSULTIAInvoiceHeader."Document Type"::"Credit Memo":
    //             PurchaseHeader."Vendor Cr. Memo No." := CONSULTIAInvoiceHeader.N_Factura;
    //     end;
    //     PurchaseHeader."Vendor Shipment No." := CopyStr(CONSULTIAInvoiceHeader.N_Pedido, 1, MaxStrLen(PurchaseHeader."Vendor Shipment No."));
    //     PurchaseHeader."Your Reference" := CopyStr(CONSULTIAInvoiceHeader.N_Pedido, 1, MaxStrLen(PurchaseHeader."Your Reference"));
    //     PurchaseHeader."CONSULTIA ID Factura" := CONSULTIAInvoiceHeader.Id;
    //     PurchaseHeader.Insert();
    // end;

    // local procedure GetVendorNoByVatRegistrationNo(VatRegistrationNo: Text): code[20]
    // var
    //     Vendor: Record Vendor;
    // begin
    //     Vendor.Reset();
    //     Vendor.SetRange("VAT Registration No.", copystr(VatRegistrationNo, 1, MaxStrLen(Vendor."VAT Registration No.")));
    //     Vendor.FindFirst();
    //     exit(Vendor."No.");
    // end;

    // local procedure AddPurchaseLinefromCONSULTIA(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; PurchaseHeader: Record "Purchase Header")
    // var
    //     CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
    //     LineNo: Integer;
    // begin
    //     CONSULTIAInvoiceLine.Reset();
    //     CONSULTIAInvoiceLine.SetRange(Id, CONSULTIAInvoiceHeader.Id);
    //     if CONSULTIAInvoiceLine.FindFirst() then
    //         repeat
    //             LineNo += 10000;
    //             AddPurchaseLine(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine, PurchaseHeader, LineNo);
    //         Until CONSULTIAInvoiceLine.next() = 0;
    // end;

    // local procedure AddPurchaseLine(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"; PurchaseHeader: Record "Purchase Header"; LineNo: Integer)
    // var
    //     PurchaseLine: Record "Purchase Line";
    // begin
    //     PurchaseLine.Init();
    //     PurchaseLine."Document Type" := PurchaseHeader."Document Type";
    //     PurchaseLine."Document No." := PurchaseHeader."No.";
    //     PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
    //     PurchaseLine."Line No." := LineNo;
    //     PurchaseLine.Insert();
    //     PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
    //     if CONSULTIAInvoiceHeader."G/L Account Fair" = '' then
    //         PurchaseLine.Validate("No.", CONSULTIAInvoiceLine.Ref_DPTO)
    //     else
    //         PurchaseLine.Validate("No.", CONSULTIAInvoiceHeader."G/L Account Fair");

    //     PurchaseLine.Description := copystr(CONSULTIAInvoiceLine.Desc_servicio, 1, 100);
    //     PurchaseLine."Description 2" := copystr(CONSULTIAInvoiceLine.Desc_servicio, 101, MaxStrLen(PurchaseLine."Description 2"));
    //     PurchaseLine.Validate(Quantity, 1);
    //     PurchaseLine.Validate("VAT Bus. Posting Group", PurchaseHeader."VAT Bus. Posting Group");
    //     PurchaseLine.Validate("VAT Prod. Posting Group", GetVATProdPostingGroup(CONSULTIAInvoiceLine, PurchaseHeader));
    //     PurchaseLine.Validate("Direct Unit Cost", CONSULTIAInvoiceLine.Base);
    //     PurchaseLine.Validate("Shortcut Dimension 1 Code", CONSULTIAInvoiceLine.Ref_Usuario);
    //     PurchaseLine.IdCorp_Sol := CONSULTIAInvoiceLine.IdCorp_Sol;
    //     PurchaseLine.Modify();
    //     SetPurchaseLineDimensiones(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine, PurchaseLine);
    //     // controlar que si hay tasas, hay que poner dos lineas y una exenta
    //     if CONSULTIAInvoiceLine.Tasas <> 0 then begin
    //         PurchaseLine.Init();
    //         PurchaseLine."Document Type" := PurchaseHeader."Document Type";
    //         PurchaseLine."Document No." := PurchaseHeader."No.";
    //         PurchaseLine."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
    //         PurchaseLine."Line No." := LineNo + 5000;
    //         PurchaseLine.Insert();
    //         PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
    //         if CONSULTIAInvoiceHeader."G/L Account Fair" = '' then
    //             PurchaseLine.Validate("No.", CONSULTIAInvoiceLine.Ref_DPTO)
    //         else
    //             PurchaseLine.Validate("No.", CONSULTIAInvoiceHeader."G/L Account Fair");

    //         PurchaseLine.Description := copystr(CONSULTIAInvoiceLine.Desc_servicio, 1, 100);
    //         PurchaseLine."Description 2" := copystr(CONSULTIAInvoiceLine.Desc_servicio, 101, 100);
    //         PurchaseLine.Validate(Quantity, 1);
    //         PurchaseLine.Validate("VAT Bus. Posting Group", PurchaseHeader."VAT Bus. Posting Group");
    //         PurchaseLine.Validate("VAT Prod. Posting Group", 'EXENTOSERV');
    //         PurchaseLine.Validate("Direct Unit Cost", CONSULTIAInvoiceLine.Tasas);
    //         PurchaseLine.Validate("Shortcut Dimension 1 Code", CONSULTIAInvoiceLine.Ref_Usuario);
    //         PurchaseLine.IdCorp_Sol := CONSULTIAInvoiceLine.IdCorp_Sol;
    //         PurchaseLine.Modify();
    //         SetPurchaseLineDimensiones(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine, PurchaseLine);
    //     end;
    // end;

    // local procedure GetVATProdPostingGroup(CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"; PurchaseHeader: Record "Purchase Header"): code[20]
    // var
    //     VATPostingSetup: Record "VAT Posting Setup";
    // begin
    //     // TODO, cambiar por configuracion de porcentaje iva
    //     VATPostingSetup.Reset();
    //     VATPostingSetup.SetFilter("VAT Prod. Posting Group", '%1', '*SERV');
    //     VATPostingSetup.SetRange("VAT Bus. Posting Group", PurchaseHeader."VAT Bus. Posting Group");
    //     VATPostingSetup.SetRange("VAT %", CONSULTIAInvoiceLine.Porc_IVA);
    //     if VATPostingSetup.FindFirst() then
    //         exit(VATPostingSetup."VAT Prod. Posting Group");
    // end;

    // local procedure SetPurchaseLineDimensiones(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
    //                         var PurchaseLine: Record "Purchase Line")
    // var
    //     GLSetup: Record "General Ledger Setup";
    //     recNewDimSetEntry: record "Dimension Set Entry" temporary;
    //     cduDimMgt: Codeunit DimensionManagement;
    //     cduCambioDim: Codeunit CambioDimensiones;
    //     GlobalDim1: code[20];
    //     GlobalDim2: code[20];
    //     intDimSetId: Integer;
    // begin
    //     GLSetup.Get();
    //     // CECO
    //     // Empleado y Unico por feria MK (campo proyecto de cabecera)
    //     GlobalDim1 := GetCONSULTIAInvoiceLineCECO(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
    //     recNewDimSetEntry.Init();
    //     recNewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 1 Code";
    //     recNewDimSetEntry.Validate("Dimension Value Code", GlobalDim1);
    //     recNewDimSetEntry.Insert();

    //     // PROYECTO
    //     CONSULTIAInvoiceLine.CalcFields(Proyecto);
    //     if CONSULTIAInvoiceLine."Proyecto Manual" = '' then
    //         CONSULTIAInvoiceLine.TestField(Proyecto);
    //     recNewDimSetEntry.Init();
    //     recNewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 2 Code";
    //     recNewDimSetEntry.Validate("Dimension Value Code", GetCONSULTIAInvoiceLineProyecto(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));
    //     recNewDimSetEntry.Insert();
    //     // PARTIDA
    //     CONSULTIAInvoiceLine.TestField(Partida);
    //     recNewDimSetEntry.Init();
    //     recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 8 Code";
    //     recNewDimSetEntry.Validate("Dimension Value Code", GetCONSULTIAInvoiceLinePARTIDA(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));
    //     recNewDimSetEntry.Insert();
    //     // DETALLE
    //     recNewDimSetEntry.Init();
    //     recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 3 Code";
    //     recNewDimSetEntry.Validate("Dimension Value Code", GetCONSULTIAInvoiceLineDETALLE(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));
    //     recNewDimSetEntry.Insert();
    //     // DEPART CODIGO (APROBACIONES)
    //     if CONSULTIAInvoiceLine.DEPART <> '' then begin
    //         recNewDimSetEntry.Init();
    //         recNewDimSetEntry."Dimension Code" := GLSetup."Shortcut Dimension 4 Code";
    //         recNewDimSetEntry.Validate("Dimension Value Code", CONSULTIAInvoiceLine.DEPART);
    //         recNewDimSetEntry.Insert();
    //     end;
    //     Clear(cduDimMgt);
    //     intDimSetId := cduDimMgt.GetDimensionSetID(recNewDimSetEntry);
    //     clear(cduCambioDim);

    //     GlobalDim1 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 1 Code", intDimSetId);
    //     GlobalDim2 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 2 Code", intDimSetId);

    //     PurchaseLine."Dimension Set ID" := intDimSetId;
    //     PurchaseLine."Shortcut Dimension 1 Code" := GlobalDim1;
    //     PurchaseLine."Shortcut Dimension 2 Code" := GlobalDim2;
    //     PurchaseLine.Modify();
    // end;

    // local procedure GetCONSULTIAInvoiceLineCECO(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"): code[50]
    // begin
    //     if CONSULTIAInvoiceHeader."Global Dimension 1 code Fair" = '' then begin
    //         CONSULTIAInvoiceLine.TestField(Ref_Usuario);
    //         exit(CONSULTIAInvoiceLine.Ref_Usuario);
    //     end else begin
    //         exit(CONSULTIAInvoiceHeader."Global Dimension 1 code Fair");
    //     end;
    // end;

    // local procedure GetCONSULTIAInvoiceLineProyecto(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"): code[50]
    // begin
    //     if CONSULTIAInvoiceHeader.Proyecto = '' then begin
    //         if CONSULTIAInvoiceLine."Proyecto Manual" <> '' then
    //             exit(CONSULTIAInvoiceLine."Proyecto Manual");
    //         CONSULTIAInvoiceLine.TestField(Proyecto);
    //         exit(CONSULTIAInvoiceLine.Proyecto);
    //     end else begin
    //         exit(CONSULTIAInvoiceHeader.Proyecto);
    //     end;
    // end;

    // local procedure GetCONSULTIAInvoiceLineDETALLE(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"): code[50]
    // begin
    //     if CONSULTIAInvoiceHeader."Dimension Detalle Fair" = '' then begin
    //         CONSULTIAInvoiceLine.TestField(Detalle);
    //         exit(CONSULTIAInvoiceLine.Detalle)
    //     end else begin
    //         exit(CONSULTIAInvoiceHeader."Dimension Detalle Fair");
    //     end;
    // end;

    // local procedure GetCONSULTIAInvoiceLinePARTIDA(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"): code[50]
    // begin
    //     if CONSULTIAInvoiceHeader."Dimension Partida Fair" = '' then begin
    //         CONSULTIAInvoiceLine.TestField(Partida);
    //         exit(CONSULTIAInvoiceLine.Partida)
    //     end else begin
    //         exit(CONSULTIAInvoiceHeader."Dimension Partida Fair");
    //     end;
    // end;

    // local procedure CopyDocumentAttachment(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; PurchaseHeader: Record "Purchase Header")
    // var
    //     DocumentAttachment: Record "Document Attachment";
    //     TargetDocumentAttachment: Record "Document Attachment";
    // begin
    //     DocumentAttachment.Reset();
    //     DocumentAttachment.SetRange("Table ID", Database::"ZM CONSULTIA Invoice Header");
    //     DocumentAttachment.SetRange("No.", CONSULTIAInvoiceHeader.N_Factura);
    //     if DocumentAttachment.FindFirst() then
    //         repeat
    //             TargetDocumentAttachment.Init();
    //             TargetDocumentAttachment := DocumentAttachment;
    //             TargetDocumentAttachment.id := 0;
    //             TargetDocumentAttachment."Table ID" := Database::"Purchase Header";
    //             TargetDocumentAttachment."Document Type" := PurchaseHeader."Document Type";
    //             TargetDocumentAttachment."No." := PurchaseHeader."No.";
    //             TargetDocumentAttachment.Insert(true);
    //         until DocumentAttachment.Next() = 0;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterDeleteEvent', '', true, true)]
    // local procedure PurchaseHeader_OnAfterDeleteEvent(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    // var
    //     CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header";
    // begin
    //     case Rec."Document Type" of
    //         Rec."Document Type"::Invoice, Rec."Document Type"::"Credit Memo":
    //             begin
    //                 CONSULTIAInvoiceHeader.Reset();
    //                 CONSULTIAInvoiceHeader.SetRange("Pre Invoice No.", Rec."No.");
    //                 if CONSULTIAInvoiceHeader.FindFirst() then begin
    //                     CONSULTIAInvoiceHeader."Pre Invoice No." := '';
    //                     CONSULTIAInvoiceHeader.Modify();
    //                 end;

    //             end;
    //     end;
    // end;

    // procedure AssingEmployeeIdCorp(var Rec: Record "ZM CONSULTIA Invoice Line")
    // var
    //     Employee: Record Employee;
    //     EmployeeList: Page "Employee List";
    // begin
    //     Rec.TestField(IdCorp_Usuario, '');
    //     EmployeeList.LookupMode := true;
    //     if EmployeeList.RunModal() = Action::LookupOK then begin
    //         EmployeeList.GetRecord(Employee);
    //         Rec.IdCorp_Usuario := Employee."No.";
    //         GetEmployeeDimensionsValue(Rec);
    //         Rec.Modify();
    //     end;
    // end;

    // procedure UpdateDimensions(var Rec: Record "ZM CONSULTIA Invoice Line")
    // begin
    //     GetProjectDimension(Rec);
    //     GetEmployeeDimensionsValue(Rec);
    //     GetGLAccountDimensionsValue(Rec);
    //     Rec.Modify();
    // end;

    // procedure AssingProject(var Rec: Record "ZM CONSULTIA Invoice Line")
    // var
    //     ProductProject: Record "ZM CONSULTIA Producto-Proyecto";
    //     DimensionValue: Record "Dimension Value";
    //     DimensionValues: Page "Dimension Values";
    //     lblConfirm: Label '¿Desea Cambiar el proyecto %1 del producto %2 a %3?', comment = 'ESP="¿Desea Cambiar el proyecto %1 del producto %2 a %3?"';
    // begin
    //     ProductProject.Reset();
    //     CreateProductoProject(Rec.CodigoProducto, Rec.Producto);
    //     ProductProject.Get(Rec.CodigoProducto);
    //     DimensionValue.Reset();
    //     DimensionValue.SetRange("Global Dimension No.", 2);
    //     DimensionValues.LookupMode := true;
    //     DimensionValues.SetTableView(DimensionValue);
    //     if DimensionValues.RunModal() = Action::LookupOK then begin
    //         DimensionValues.GetRecord(DimensionValue);
    //         if ProductProject.Proyecto <> '' then
    //             if not Confirm(lblConfirm, true, ProductProject.Proyecto, ProductProject.Proyecto, DimensionValue.Code) then
    //                 exit;
    //         ProductProject.Proyecto := DimensionValue.Code;
    //         ProductProject.Modify();
    //     end;
    // end;

    // local procedure GetProjectDimension(var Rec: Record "ZM CONSULTIA Invoice Line"): Boolean
    // var
    //     ProductProject: Record "ZM CONSULTIA Producto-Proyecto";
    // begin
    //     if Rec.Proyecto <> '' then
    //         exit;
    //     ProductProject.Reset();
    //     ProductProject.SetRange(CodigoProducto, Rec.CodigoProducto);
    //     if ProductProject.FindFirst() then
    //         if ProductProject.Proyecto <> '' then
    //             Rec.Proyecto := ProductProject.Proyecto;
    // end;

    // local procedure CreateProductoProject(CodigoProducto: code[50]; Producto: text[100])
    // var
    //     ProductProject: Record "ZM CONSULTIA Producto-Proyecto";
    // begin
    //     if ProductProject.Get(CodigoProducto) then
    //         exit;
    //     ProductProject.Init();
    //     ProductProject.CodigoProducto := CodigoProducto;
    //     ProductProject.Description := CopyStr(Producto, 1, MaxStrLen(ProductProject.Description));
    //     ProductProject.Insert();
    //     Commit();
    // end;

    // // =============     CREAR DIARIO DE APROVISIONAMIENTO          ====================
    // // ==  
    // // ==  funciones para crear diario de aprovisionamiento de facturas de CONSULTIA
    // // ==  
    // // ======================================================================================================

    // procedure CreateJNLAprovisionamiento(var CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; DesProvisioning: Boolean)
    // var
    //     GenJournalBatch: Record "Gen. Journal Batch";
    //     CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line";
    //     BudgetBuffer: record "Budget Buffer" temporary;
    //     GenJnlManagement: Codeunit GenJnlManagement;

    // begin
    //     PurchasesPayablesSetup.Get();
    //     GenJournalBatch.Get(PurchasesPayablesSetup."CONSULTIA Gen. Jnl. Template", PurchasesPayablesSetup."CONSULTIA Gen. Journal Batch");
    //     PurchasesPayablesSetup.TestField("CONSULTIA G/L Provide");
    //     PurchasesPayablesSetup.TestField("CONSULTIA Gen. Jnl. Template");
    //     PurchasesPayablesSetup.TestField("CONSULTIA Gen. Journal Batch");
    //     BudgetBuffer.DeleteAll();
    //     if not DesProvisioning then
    //         CONSULTIAInvoiceHeader.TestField("Invoice Header No.", '');
    //     if DesProvisioning then begin
    //         CONSULTIAInvoiceHeader.TestField(Provisioning, true);
    //         CONSULTIAInvoiceHeader.TestField("Des Provisioning", false);
    //     end else begin
    //         CONSULTIAInvoiceHeader.TestField(Provisioning, false);
    //     end;
    //     CONSULTIAInvoiceLine.Reset();
    //     CONSULTIAInvoiceLine.SetRange(id, CONSULTIAInvoiceHeader.Id);
    //     if CONSULTIAInvoiceLine.FindFirst() then
    //         repeat

    //             AddAprovisionamientoBuffer(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine, BudgetBuffer, DesProvisioning);

    //         Until CONSULTIAInvoiceLine.next() = 0;

    //     CreateJNLLineAprovisionamiento(CONSULTIAInvoiceHeader, BudgetBuffer);
    //     case DesProvisioning of
    //         true:
    //             begin
    //                 CONSULTIAInvoiceHeader."Des Provisioning" := true;
    //                 CONSULTIAInvoiceHeader."Des Provisioning Date" := WorkDate();

    //             end;
    //         else begin
    //             CONSULTIAInvoiceHeader.Provisioning := true;
    //             CONSULTIAInvoiceHeader."Provisioning Date" := WorkDate();
    //         end;
    //     end;
    //     CONSULTIAInvoiceHeader.Modify();

    //     Commit();
    //     GenJnlManagement.TemplateSelectionFromBatch(GenJournalBatch)

    // end;


    // local procedure AddAprovisionamientoBuffer(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header";
    //             CONSULTIAInvoiceLine: Record "ZM CONSULTIA Invoice Line"; var BudgetBuffer: record "Budget Buffer"; DesProvisioning: Boolean)
    // var
    //     myInt: Integer;
    // begin
    //     BudgetBuffer.Reset();
    //     BudgetBuffer.SetRange("G/L Account No.");
    //     BudgetBuffer.SetRange("Dimension Value Code 1", GetCONSULTIAInvoiceLineCECO(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));  // CECO
    //     BudgetBuffer.SetRange("Dimension Value Code 2", GetCONSULTIAInvoiceLineProyecto(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));  // PROYECTO
    //     BudgetBuffer.SetRange("Dimension Value Code 3", GetCONSULTIAInvoiceLinePARTIDA(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));  // Partida
    //     BudgetBuffer.SetRange("Dimension Value Code 4", GetCONSULTIAInvoiceLineDETALLE(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine));  // DETALLE
    //     if not BudgetBuffer.FindFirst() then begin
    //         BudgetBuffer.Init();
    //         BudgetBuffer."G/L Account No." := CONSULTIAInvoiceLine.Ref_DPTO;
    //         BudgetBuffer."Dimension Value Code 1" := GetCONSULTIAInvoiceLineCECO(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
    //         BudgetBuffer."Dimension Value Code 2" := GetCONSULTIAInvoiceLineProyecto(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
    //         BudgetBuffer."Dimension Value Code 3" := GetCONSULTIAInvoiceLinePARTIDA(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
    //         BudgetBuffer."Dimension Value Code 4" := GetCONSULTIAInvoiceLineDETALLE(CONSULTIAInvoiceHeader, CONSULTIAInvoiceLine);
    //         BudgetBuffer.Insert();
    //     end;
    //     case DesProvisioning of
    //         true:
    //             BudgetBuffer.Amount -= CONSULTIAInvoiceLine.Base;
    //         else
    //             BudgetBuffer.Amount += CONSULTIAInvoiceLine.Base;
    //     end;
    //     BudgetBuffer.Modify();
    // end;

    // local procedure CreateJNLLineAprovisionamiento(CONSULTIAInvoiceHeader: Record "ZM CONSULTIA Invoice Header"; var BudgetBuffer: record "Budget Buffer")
    // var
    //     GenJnlLine: Record "Gen. Journal Line";
    //     GenJournalBatch: Record "Gen. Journal Batch";
    //     LastLine: Integer;
    // begin
    //     PurchasesPayablesSetup.Get();
    //     GenJournalBatch.Get(PurchasesPayablesSetup."CONSULTIA Gen. Jnl. Template", PurchasesPayablesSetup."CONSULTIA Gen. Journal Batch");
    //     // primero miramos si existen líneas y obtenemos la ultima línea
    //     GenJnlLine.Reset();
    //     GenJnlLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
    //     GenJnlLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
    //     if GenJnlLine.FindLast() then
    //         LastLine := GenJnlLine."Line No." + 10000
    //     else
    //         LastLine := 10000;
    //     BudgetBuffer.Reset();
    //     if BudgetBuffer.FindFirst() then
    //         repeat
    //             GenJnlLine.Init();
    //             GenJnlLine."Journal Template Name" := GenJournalBatch."Journal Template Name";
    //             GenJnlLine."Journal Batch Name" := GenJournalBatch.Name;
    //             GenJnlLine."Line No." := LastLine;
    //             GenJnlLine."Posting Date" := Workdate;
    //             GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
    //             GenJnlLine."Document Date" := CONSULTIAInvoiceHeader.F_Factura;
    //             GenJnlLine.Insert();
    //             GenJnlLine."Document No." := CopyStr(CONSULTIAInvoiceHeader.N_Factura, 1, MaxStrLen(GenJnlLine."Document No."));
    //             GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
    //             GenJnlLine.validate("Account No.", BudgetBuffer."G/L Account No.");
    //             GenJnlLine.Description := CopyStr(StrSubstNo('%1 %2', CONSULTIAInvoiceHeader.N_Factura, CONSULTIAInvoiceHeader.Descripcion), 1, MaxStrLen(GenJnlLine.Description));
    //             GenJnlLine."External Document No." := CopyStr(CONSULTIAInvoiceHeader.N_Factura, 1, MaxStrLen(GenJnlLine."External Document No."));
    //             GenJnlLine.Validate(Amount, BudgetBuffer.Amount);
    //             GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
    //             GenJnlLine.Validate("Bal. Account No.", PurchasesPayablesSetup."CONSULTIA G/L Provide");
    //             GenJnlLine.Modify();
    //             LastLine += 10000;
    //         Until BudgetBuffer.next() = 0;
    // end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        JobsSetup: Record "Jobs Setup";
    // lblurlConsultia: Label 'https://api-destinux.consultiatravel.es/B2B.Test';
    // lblListaViajero: Label '/api/ListaViajeros';
    // lblInvoice: Label '/api/facturas';
    // lblDate: Label '?FechaIni=%1&FechaFin=%2';
    // lblGetInvoicePDF: Label '/api/Facturas/ObtenerPDF?IdFactura=%1';
    // lblDownload: Label 'Descarga de fichero', comment = 'ESP="Descarga de fichero"';

    // =============     ABERTI BI UPDATE FUNCTIONS ADO SQL SERVER          ====================
    // ==  
    // ==  todas las funciones para actualizar SQL Server con ADO
    // ==  
    // ======================================================================================================
    var
        BISQLConnection: DotNet SqlConnection;

    procedure SQLUpdateALL(DeleteAll: Boolean)
    var
        GLAccountNo: Integer;
        GLEntryNo: Integer;
    begin
        GLAccountNo := SQLGLAccountsUpdate();
        GLEntryNo := SQLGLGLEntrysUpdate(DeleteAll);
        SendMailBIUpdate(GLAccountNo, GLEntryNo);
    end;

    procedure SQLBIGetRecordsNo(var GLRecordsNo: Integer; var GLEntryRecordsNo: Integer; var GLBudgetRecordsNo: Integer; var ItemsRecordsNo: Integer;
            var CustomerRecordsNo: Integer; var FacturasRecordsNo: Integer; var PedidosRecordsNo: Integer)
    var
        Windows: Dialog;
    begin
        Windows.Open('Actualizando contador registros.....');
        GetRecordsNoGLAccount(GLRecordsNo);
        GetRecordsNoGLEntry(GLEntryRecordsNo);
        GetRecordsNoBudgetGLEntry(GLBudgetRecordsNo);
        GetRecordsNoItemCompleto(ItemsRecordsNo);
        GetRecordsNoSalesCustomer(CustomerRecordsNo);
        GetRecordsNoSalesFacturas(FacturasRecordsNo);
        GetRecordsNoSalesPedidos(PedidosRecordsNo);
        Windows.Close();
    end;

    procedure GetRecordsNoGLAccount(var RecordsNo: Integer)
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtCommand: text;
        lblSQLCount: Label 'SELECT count(*) FROM tBIFinan_Cuentas WHERE [00 - Origen] =''%1''';
    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        case CompanyName of
            'ZUMMO':
                txtCommand := StrSubstNo(lblSQLCount, 'ZIM');
            'INVESTMENTS':
                txtCommand := StrSubstNo(lblSQLCount, 'ZINV');
            else
                txtCommand := StrSubstNo(lblSQLCount, '');
        end;
        SQLCommand.CommandText := txtCommand;
        // ** EXEC READER **
        //SQLReader := SQLCommand.ExecuteReader;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            if SQLReader.Read() then
                RecordsNo := SQLReader.GetInt32(0);

    end;

    procedure GetRecordsNoGLEntry(var RecordsNo: Integer)
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtCommand: Text;
        lblSQLCount: Label 'SELECT count(*) FROM tBIFinan3Nav WHERE [00 - Origen] =''%1''';
    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        case CompanyName of
            'ZUMMO':
                txtCommand := StrSubstNo(lblSQLCount, 'ZIM');
            'INVESTMENTS':
                txtCommand := StrSubstNo(lblSQLCount, 'ZINV');
            else
                txtCommand := StrSubstNo(lblSQLCount, '');
        end;
        SQLCommand.CommandText := txtCommand;
        // ** EXEC READER **
        //SQLReader := SQLCommand.ExecuteReader;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            if SQLReader.Read() then
                RecordsNo := SQLReader.GetInt32(0);
    end;

    procedure GetRecordsNoBudgetGLEntry(var RecordsNo: Integer)
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtCommand: Text;
        lblSQLCount: Label 'SELECT count(*) FROM tBIFinan_PresupuestoFinanzas WHERE [00 - Origen] =''%1''';
    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        case CompanyName of
            'ZUMMO':
                txtCommand := StrSubstNo(lblSQLCount, 'ZIM');
            'INVESTMENTS':
                txtCommand := StrSubstNo(lblSQLCount, 'ZINV');
            else
                txtCommand := StrSubstNo(lblSQLCount, '');
        end;
        SQLCommand.CommandText := txtCommand;
        // ** EXEC READER **
        //SQLReader := SQLCommand.ExecuteReader;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            if SQLReader.Read() then
                RecordsNo := SQLReader.GetInt32(0);

    end;

    procedure GetRecordsNoItemCompleto(var RecordsNo: Integer)
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtCommand: Text;
        lblSQLCount: Label 'SELECT count(*) FROM ItemCompleto';
    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        SQLCommand.CommandText := lblSQLCount;
        // ** EXEC READER **
        //SQLReader := SQLCommand.ExecuteReader;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            if SQLReader.Read() then
                RecordsNo := SQLReader.GetInt32(0);

    end;

    procedure GetRecordsNoSalesCustomer(var RecordsNo: Integer)
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtCommand: Text;
        lblSQLCount: Label 'SELECT count(*) FROM SalesCustomer';
    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        SQLCommand.CommandText := lblSQLCount;
        // ** EXEC READER **
        //SQLReader := SQLCommand.ExecuteReader;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            if SQLReader.Read() then
                RecordsNo := SQLReader.GetInt32(0);

    end;

    procedure GetRecordsNoSalesFacturas(var RecordsNo: Integer)
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtCommand: Text;
        lblSQLCount: Label 'SELECT count(*) FROM SalesFacturas';
    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        SQLCommand.CommandText := lblSQLCount;
        // ** EXEC READER **
        //SQLReader := SQLCommand.ExecuteReader;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            if SQLReader.Read() then
                RecordsNo := SQLReader.GetInt32(0);

    end;

    procedure GetRecordsNoSalesPedidos(var RecordsNo: Integer)
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtCommand: Text;
        lblSQLCount: Label 'SELECT count(*) FROM SalesPedidos';
    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        SQLCommand.CommandText := lblSQLCount;
        // ** EXEC READER **
        //SQLReader := SQLCommand.ExecuteReader;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            if SQLReader.Read() then
                RecordsNo := SQLReader.GetInt32(0);

    end;

    procedure SQLGLAccountsUpdate() RecordNo: Integer
    var
        GLAccount: Record "G/L Account";
        Level: Integer;
        Account1: Integer;
        Account2: Integer;
        Account3: Integer;
        Account4: Integer;
        Desc1: Text;
        Desc2: text;
        Desc3: text;
        Desc4: text;
        AccountNo: Integer;

        windows: Dialog;
    begin
        windows.Open('#1###################################\#2##############################');
        windows.Update(1, 'Updating G L Account.....');
        if not SQLDeleteRecordsNoGLAccount() then
            exit;
        GLAccount.Reset();
        // GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if GLAccount.FindFirst() then
            repeat
                windows.Update(2, GLAccount."No.");
                if Evaluate(AccountNo, GLAccount."No.") then begin
                    // case GLAccount."Account Type" of
                    //     GLAccount."Account Type"::"Begin-Total", GLAccount."Account Type"::Heading:
                    //         Level += 1;
                    //     GLAccount."Account Type"::"End-Total", GLAccount."Account Type"::Total:
                    //         Level -= 1;
                    // end;
                    case Level of
                        1:
                            begin
                                if Evaluate(Account1, GLAccount."No.") then
                                    Desc1 := GLAccount.Name;
                                Account2 := 0;
                                Desc2 := '';
                                Account3 := 0;
                                Desc3 := '';
                                Account4 := 0;
                                Desc4 := '';
                            end;
                        2:
                            begin
                                if Evaluate(Account2, GLAccount."No.") then
                                    Desc2 := GLAccount.Name;
                                Account3 := 0;
                                Desc3 := '';
                                Account4 := 0;
                                Desc4 := '';

                            end;
                        3:
                            begin
                                if Evaluate(Account3, GLAccount."No.") then
                                    Desc3 := GLAccount.Name;
                                Account4 := 0;
                                Desc4 := '';
                            end;
                        4:
                            begin
                                if Evaluate(Account4, GLAccount."No.") then
                                    Desc4 := GLAccount.Name;
                            end;
                    end;
                    // añadimos cada una de las opcioens de subcunentas mayor
                    // 4 digitos y 5 digitos
                    UpdateGLAccount(GLAccount, AccountNo, Account1, Account2, Account3, Account4, Desc1, Desc2, Desc3, Desc4);
                    RecordNo += 1;
                end;
            until GLAccount.Next() = 0;
        windows.Close();
    end;

    local procedure UpdateGLAccount(GLAccount: Record "G/L Account"; AccountNo: Integer; Account1: Integer; Account2: Integer; Account3: Integer; Account4: Integer;
                Desc1: Text; Desc2: text; Desc3: text; Desc4: text): Boolean
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtSQLCommandText: Text;
        txtSQLCommandValues: Text;
        GLAccountNo: Integer;
        lblSQLinsertTable: Label 'INSERT INTO tBIFinan_Cuentas';
        lblSQLInsertFields: Label '([C7 - Cuenta1] ,[C7 - Cuenta2],[C7 - Cuenta3] ,[C7 - Cuenta4],[C8 - Cuenta Cod7],[00 - Origen],[DescCuenta1],[DescCuenta2],[DescCuenta3],[DescCuenta4],[DescCuenta7])';
        lblSQLInsertValues: Label 'values( %1,%2,%3,%4,%5,''%6'',''%7'',''%8'',''%9'',''%10'',''%11'')';

    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        txtSQLCommandValues := StrSubstNo(lblSQLInsertValues, Account1, Account2, Account3, Account4, AccountNo, 'ZINC', Desc1, Desc2, Desc3, Desc4, GLAccount.Name);
        txtSQLCommandText := StrSubstNo('%1 %2 %3', lblSQLinsertTable, lblSQLInsertFields, txtSQLCommandValues);
        SQLCommand.CommandText := txtSQLCommandText;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            exit(true);

    end;

    Local procedure SQLDeleteRecordsNoGLAccount(): Boolean
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        Windows: Dialog;
        lblSQLDelete: Label 'DELETE FROM tBIFinan_Cuentas WHERE [00 - Origen] =''%1''';
    begin
        windows.Open('#1###################################\#2##############################');
        windows.Update(1, 'Updating.....');
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        SQLCommand.CommandText := StrSubstNo(lblSQLDelete, 'ZINC');
        // ** EXEC READER **
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            exit(false);
        windows.close;
        exit(true);
    end;



    local procedure SQLGLGLEntrysUpdate(DeleteAll: Boolean) RecordNo: Integer
    var
        GLSetup: Record "General Ledger Setup";
        GLEntry: Record "G/L Entry";
        Level: Integer;
        Account1: Integer;
        Account2: Integer;
        Account3: Integer;
        Account4: Integer;
        Desc1: Text;
        Desc2: text;
        Desc3: text;
        Desc4: text;
        AccountNo: Integer;
        windows: Dialog;
    begin
        windows.Open('#1###################################\#2##############################\#3##############################');
        windows.Update(1, 'Updating G L Entry.....');
        if not SQLDeleteRecordsNoGLEntry(DeleteAll) then
            exit;
        GLSetup.Get();
        GLEntry.Reset();
        if not DeleteAll then
            GLEntry.SetRange("Posting Date", GLSetup."Allow Posting From", GLSetup."Allow Posting To");
        if GLEntry.FindFirst() then
            repeat
                windows.Update(2, GLEntry."Entry No.");
                windows.Update(3, GLEntry."Posting Date");
                UpdateGLEntry(GLEntry);
                RecordNo += 1;
            until GLEntry.Next() = 0;
        windows.Close();
    end;

    local procedure UpdateGLEntry(GLEntry: Record "G/L Entry"): Boolean
    var
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        txtSQLCommandText: Text;
        txtSQLCommandValues: Text;
        txtSQLInsertFields: text;
        GLAccountNo: Integer;

        lblSQLinsertTable: Label 'INSERT INTO tBIFinan3Nav';
        lblSQLInsertValues: Label 'values(';

    begin
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        txtSQLInsertFields := '([Entry No_],[G_L Account No_],[Posting Date],[Document Type],[Document No_],[Description],[Bal_ Account No_],[Amount],[Global Dimension 1 Code],[Global Dimension 2 Code]' +
                    ',[User ID],[Source Code],[System-Created Entry],[Quantity],[VAT Amount],[Business Unit Code]' +
                    ',[Reason Code],[Gen_ Bus_ Posting Group],[Gen_ Prod_ Posting Group],[Transaction No_],[Debit Amount]' +
                    ',[Credit Amount],[Document Date],[External Document No_],[Source No_],[Tax Area Code],[Tax Group Code]' +
                    ',[VAT Bus_ Posting Group],[VAT Prod_ Posting Group],[Additional-Currency Amount],[Add_-Currency Debit Amount],[Add_-Currency Credit Amount]' +
                    ',[FA Entry No_],[Last Modified DateTime],[00 - Origen])';

        txtSQLCommandValues := lblSQLInsertValues + format(GLEntry."Entry No.");
        txtSQLCommandValues += ',''' + GLEntry."G/L Account No." + '''';
        txtSQLCommandValues += ',''' + StrSubstNo('%1-%2-%3', Date2DMY(GLEntry."Posting Date", 3), Date2DMY(GLEntry."Posting Date", 1), Date2DMY(GLEntry."Posting Date", 2)) + '''';
        case GLEntry."Document Type" of
            GLEntry."Document Type"::" ":
                txtSQLCommandValues += ',' + format(0);
            GLEntry."Document Type"::"Credit Memo":
                txtSQLCommandValues += ',' + format(3);
            GLEntry."Document Type"::"Finance Charge Memo":
                txtSQLCommandValues += ',' + format(4);
            GLEntry."Document Type"::Invoice:
                txtSQLCommandValues += ',' + format(2);
            GLEntry."Document Type"::Payment:
                txtSQLCommandValues += ',' + format(1);
            GLEntry."Document Type"::Refund:
                txtSQLCommandValues += ',' + format(6);
            GLEntry."Document Type"::Reminder:
                txtSQLCommandValues += ',' + format(5);
            else
                txtSQLCommandValues += ',' + format(0);
        end;
        txtSQLCommandValues += ',''' + FormatText(GLEntry."Document No.") + '''';
        txtSQLCommandValues += ',''' + FormatText(GLEntry.Description) + '''';
        txtSQLCommandValues += ',''' + GLEntry."Bal. Account No." + '''';
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry.Amount);
        txtSQLCommandValues += ',''' + GLEntry."Global Dimension 1 Code" + '''';
        txtSQLCommandValues += ',''' + GLEntry."Global Dimension 2 Code" + '''';
        txtSQLCommandValues += ',''' + GLEntry."User ID" + '''';
        txtSQLCommandValues += ',''' + GLEntry."Source Code" + '''';
        case GLEntry."System-Created Entry" of
            true:
                txtSQLCommandValues += ',0';
            else
                txtSQLCommandValues += ',1';
        end;
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry.Quantity);
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry."VAT Amount");
        txtSQLCommandValues += ',''' + GLEntry."Business Unit Code" + '''';
        txtSQLCommandValues += ',''' + FormatText(GLEntry."Reason Code") + '''';
        txtSQLCommandValues += ',''' + GLEntry."Gen. Bus. Posting Group" + '''';
        txtSQLCommandValues += ',''' + GLEntry."Gen. Prod. Posting Group" + '''';
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry."Transaction No.");
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry."Debit Amount");
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry."Credit Amount");
        txtSQLCommandValues += ',''' + StrSubstNo('%1-%2-%3', Date2DMY(GLEntry."Document Date", 3), Date2DMY(GLEntry."Document Date", 1), Date2DMY(GLEntry."Document Date", 2)) + '''';
        txtSQLCommandValues += ',''' + FormatText(GLEntry."External Document No.") + '''';
        txtSQLCommandValues += ',''' + GLEntry."Source No." + '''';
        txtSQLCommandValues += ',''' + GLEntry."Tax Area Code" + '''';
        txtSQLCommandValues += ',''' + GLEntry."Tax Group Code" + '''';
        txtSQLCommandValues += ',''' + GLEntry."VAT Bus. Posting Group" + '''';
        txtSQLCommandValues += ',''' + GLEntry."VAT Prod. Posting Group" + '''';
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry."Additional-Currency Amount");
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry."Add.-Currency Debit Amount");
        txtSQLCommandValues += ',' + FormatDecimaNumber(GLEntry."Add.-Currency Credit Amount");
        txtSQLCommandValues += ',' + format(GLEntry."FA Entry No.");
        txtSQLCommandValues += ',''' + StrSubstNo('%1-%2-%3', Date2DMY(DT2Date(GLEntry."Last Modified DateTime"), 3), Date2DMY(DT2Date(GLEntry."Last Modified DateTime"), 1)
                                                , Date2DMY(DT2Date(GLEntry."Last Modified DateTime"), 2)) + '''';
        txtSQLCommandValues += ',''ZINC''';
        txtSQLCommandValues += ')';
        txtSQLCommandText := StrSubstNo('%1 %2 %3', lblSQLinsertTable, txtSQLInsertFields, txtSQLCommandValues);
        SQLCommand.CommandText := txtSQLCommandText;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            exit(true);

    end;

    local procedure FormatDecimaNumber(Value: Decimal) Result: text
    begin
        // convertimos el decimal en texto, sustituyendo la COMMA por un punto por el Idioma ENG
        Result := format(Value, 0, 1);
        Result := ConvertStr(Result, ',', '.');
    end;

    local procedure FormatText(Value: text) Result: text
    var
        myInt: Integer;
    begin
        Result := ConvertStr(Result, '''', '´');
    end;

    Local procedure SQLDeleteRecordsNoGLEntry(DeleteAll: Boolean): Boolean
    var
        GLSetup: Record "General Ledger Setup";
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        FechaIni: text;
        Windows: Dialog;
        lblSQLDelete: Label 'DELETE FROM tBIFinan3Nav WHERE [00 - Origen] =''%1'' and [Posting Date]>=%2';
        lblSQLDeleteAll: Label 'DELETE FROM tBIFinan3Nav WHERE [00 - Origen] =''%1''';
    begin
        GLSetup.Get();

        windows.Open('#1###################################\#2##############################');
        windows.Update(1, 'Updating.....');
        if IsNull(BISQLConnection) then
            SQLConnect(BISQLConnection);
        Clear(SQLCommand);
        SQLCommand := BISQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        case DeleteAll of
            true:
                begin
                    SQLCommand.CommandText := StrSubstNo(lblSQLDeleteAll, 'ZINC');
                end;
            else begin
                FechaIni := StrSubstNo('%1-%2-%3 0:00', Date2DMY(GLSetup."Allow Posting From", 3), Date2DMY(GLSetup."Allow Posting From", 2), Date2DMY(GLSetup."Allow Posting From", 1));
                SQLCommand.CommandText := StrSubstNo(lblSQLDelete, 'ZINC', FechaIni);
            end;
        end;
        // ** EXEC READER **
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then
            exit(false);
        windows.close;
        exit(true);
    end;

    procedure SendMailBIUpdate(GLAccountNo: Integer; GLEntryNo: Integer)
    var
        CuCron: Codeunit CU_Cron;
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Recipients: Text;
        Subject: Text;
        Body: Text;
        GLSetupOnly: Option GLSetup,ABETIA;
        InStrReport: InStream;
        OutStrReport: OutStream;
        lblSubject: Label 'Update BI %1';
        lblBody: Label '';
    begin
        Recipients := CuCron.GetRecipientsGLSetup(GLSetupOnly::ABETIA);
        if Recipients <> '' then begin
            Clear(SMTPMail);
            SMTPMailSetup.Get();
            Subject := StrSubstNo(lblSubject, CompanyName);
            body := StrSubstNo(lblBody, GLAccountNo, GLEntryNo);
            SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", Recipients, Subject, Body, false);
            SMTPMail.Send();
        end;
    end;

    local procedure SQLConnect(var SQLConnection: dotnet SQLConnection)
    var
        GLSetup: Record "General Ledger Setup";
        ConnStr: text;
        DataSourceTok: label 'Data Source=%1;Initial Catalog=%2;User Id=%3;Password=%4;';
    begin
        GLSetup.Get();
        GLSetup.TestField("Data Source");
        GLSetup.TestField("Initial Catalog");
        GLSetup.TestField("User Id");
        GLSetup.TestField("Password");
        // ConnStr := StrSubstNo(DataSourceTok, 'zummo.ddns.net', 'ReportingZummo', 'zummo', '@b3rti@');
        ConnStr := StrSubstNo(DataSourceTok, GLSetup."Data Source", GLSetup."Initial Catalog", GLSetup."User Id", GLSetup."Password");
        SQLConnection := SQLConnection.SQLConnection(ConnStr);
        SQLConnection.Open();
    end;

    procedure SQLDataReaderDemo()
    var
        SQLConnection: dotnet SQLConnection;
        SQLCommand: DotNet SqlCommand;
        SQLReader: DotNet SqlDataReader;
        ItemNo: code[20];
        IdItem: Integer;
        windows: Dialog;
    begin
        windows.Open('#1###################################\#2##############################');
        windows.Update(1, 'Empezamos');
        if IsNull(SQLConnection) then
            SQLConnect(SQLConnection);
        Clear(SQLCommand);
        SQLCommand := SQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'select * From ItemCompleto';
        SQLCommand.CommandText := 'INSERT into ItemCompleto (No_,ClasVtas_btc) values (''Prueba'',2)';
        // ** EXEC READER **
        //SQLReader := SQLCommand.ExecuteReader;
        SQLReader := SQLCommand.ExecuteReader;
        IF SQLReader.HasRows then BEGIN
            WHILE SQLReader.Read() DO BEGIN
                ItemNo := SQLReader.GetString(1);
                IdItem := SQLReader.GetInt32(2);
            END;
            windows.Update(1, ItemNo);
            windows.Update(2, IdItem);
        END;
        windows.close;
    end;


}