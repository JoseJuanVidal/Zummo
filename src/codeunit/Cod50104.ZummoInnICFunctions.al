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

    procedure GetJSONItemFieldText(Token: JsonToken; keyname: Text): Text
    var
        JObject: JsonObject;
        jToken: JsonToken;
    begin
        JObject := Token.AsObject();

        if JObject.Get(keyname, jToken) then exit(jToken.AsValue().AsText());

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

    procedure JIRAGetAllTickets()
    var
        JiraTicket: Record "ZM IT JIRA Tickets";
        metodo: Label 'search?maxResults=100&jql=project = TZ ORDER by ID&fields=key,summary,status,assignee&startAt=%1';
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
    begin
        JobsSetup.Get();
        JobsSetup.TestField("url Base");
        JobsSetup.TestField(user);
        JobsSetup.TestField(token);
        JIRA_SW_REST(JobsSetup."url Base", StrSubstNo(metodo, IssuesCount), 'GET', Body, true, StatusCode, ResponseText, JobsSetup.user, JobsSetup.token);

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
                    JiraTicket.Reset();
                    if not JiraTicket.Get(FieldValue) then begin
                        JiraTicket.Init();
                        JiraTicket."key" := FieldValue;
                        JiraTicket.id := GetJSONItemFieldInteger(JsonIssue, 'id');
                    end;
                    JsonIssueFields := GetJSONItemFieldObject(JsonIssue, 'fields');
                    JiraTicket.summary := GetJSONItemFieldText(JsonIssueFields.AsToken(), 'summary');
                    JsonIssueState := GetJSONItemFieldObject(JsonIssueFields.AsToken(), 'status');
                    JiraTicket.State := GetJSONItemFieldText(JsonIssueState.AsToken(), 'name');
                    JiraTicket."Description Status" := copystr(GetJSONItemFieldText(JsonIssueState.AsToken(), 'description'), 1, MaxStrLen(JiraTicket."Description Status"));
                    JsonIssueassigned := GetJSONItemFieldObject(JsonIssueFields.AsToken(), 'assignee');
                    JiraTicket.Assignee := copystr(GetJSONItemFieldText(JsonIssueassigned.AsToken(), 'displayName'), 1, MaxStrLen(JiraTicket.Assignee));
                    if not JiraTicket.Insert() then
                        JiraTicket.Modify();
                end;
                if IssuesCount < TotalIssues then begin
                    JIRA_SW_REST(JobsSetup."url Base", StrSubstNo(metodo, IssuesCount), 'GET', Body, true, StatusCode, ResponseText, JobsSetup.user, JobsSetup.token);
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
            end;
        end;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        JobsSetup: Record "Jobs Setup";

}