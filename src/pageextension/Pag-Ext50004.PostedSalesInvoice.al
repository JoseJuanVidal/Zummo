pageextension 50004 "PostedSalesInvoice" extends "Posted Sales Invoice"
{
    //Guardar Nº asiento y Nº documento


    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Search Name"; "Sell-to Search Name")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addafter("Salesperson Code")
        {
            field(CurrencyChange; CurrencyChange)
            {
                ApplicationArea = all;
                ToolTip = 'Indicar el cambio para la impresión de los documentos.', comment = 'ESP="Indicar el cambio para la impresión de los documentos."';
            }
            field(Peso_btc; Peso_btc) { }
            field(NumPalets_btc; NumPalets_btc) { }
            field(NumBultos_btc; NumBultos_btc) { }
            field(EnvioFactura_zm; EnvioFactura_zm) { }
            field(CorreoEnviado_btc; CorreoEnviado_btc) { }
            field(FacturacionElec_btc; FacturacionElec_btc) { }
            field(AreaManager_btc; AreaManager_btc) { }
            field(InsideSales_btc; InsideSales_btc) { }
            field(ClienteReporting_btc; ClienteReporting_btc) { }
            field(Canal_btc; Canal_btc) { }
            field("ABC Cliente"; "ABC Cliente") { }
            field(Delegado_btc; Delegado_btc) { }
            field("Campaign No."; "Campaign No.") { }

        }
        addafter("Pre-Assigned No.")
        {
            field(NumAsiento_btc; NumAsiento_btc)
            {
                ApplicationArea = All;
            }
        }
        addafter("Succeeded VAT Registration No.")
        {
            field(FechaOperacion; FechaOperacion)
            {
                ApplicationArea = all;
                Caption = 'Fecha operación', comment = 'ESP="Fecha operación"';

                trigger OnValidate()
                begin
                    SetFechaOperacion();
                end;
            }
        }
        modify("External Document No.")
        {
            Editable = true;
        }
        modify("Work Description")
        {
            Editable = true;
        }
        addafter(Closed)
        {
            field("Cred_ Max_ Aseg. AutorizadoPor"; "Cred_ Max_ Aseg. AutorizadoPor")
            {
                Visible = false;
                Editable = true;
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                Visible = false;
                Editable = true;
            }
            field(clasificacion_aseguradora; clasificacion_aseguradora)
            {
                Visible = false;
                Editable = true;
            }
        }
    }
    actions
    {
        addfirst(Processing)
        {
            action("Cambiar Doc. Externo")
            {
                ApplicationArea = all;
                Caption = 'Cambiar Doc. Externo', comment = 'ESP="Cambiar Doc. Externo"';
                ToolTip = 'Cambiar Doc. Externo',
                    comment = 'ESP="Cambiar Doc. Externo"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Balance;

                trigger OnAction()
                var
                    PediDatos: Page "Posted Sales Invoice Change";
                    Funciones: Codeunit Funciones;
                    ExtDocNo: Text[35];
                    WorkDescription: text;
                    AreaManager: Code[20];
                    InsideSales: Code[20];
                    ClienteReporting: Code[20];
                    CurrChange: Decimal;
                    PackageTrackingNo: text[30];
                    Delegado: code[20];
                    CampaignNo: code[20];
                begin
                    PediDatos.LookupMode := true;
                    PediDatos.SetDatos(rec);
                    if PediDatos.RunModal() = Action::LookupOK then begin
                        PediDatos.GetDatos(ExtDocNo, WorkDescription, AreaManager, ClienteReporting, CurrChange, PackageTrackingNo, InsideSales, Delegado, CampaignNo);
                        Funciones.ChangeExtDocNoPostedSalesInvoice("No.", false, ExtDocNo, WorkDescription, AreaManager, ClienteReporting, CurrChange,
                            PackageTrackingNo, InsideSales, Delegado, CampaignNo);
                    end;
                end;

            }


            action("Pesos y Bultos")
            {
                ApplicationArea = all;
                Caption = 'Pesos y Bultos', comment = 'ESP="Pesos y Bultos"';
                ToolTip = 'Pesos y Bultos',
                    comment = 'ESP="Pesos y Bultos"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Balance;

                trigger OnAction()
                var
                    pageAbrir: Page RegistrarEnvio;
                    peso: Decimal;
                    numPalets: Integer;
                    numBultos: Integer;
                begin
                    Clear(pageAbrir);
                    pageAbrir.LookupMode(true);
                    pageAbrir.SetEnvioOrigen('', Rec."No.", '');

                    if pageAbrir.RunModal() = Action::LookupOK then begin
                        pageAbrir.GetDatos(peso, numPalets, numBultos);

                        NumBultos_btc := numBultos;
                        NumPalets_btc := numPalets;
                        Peso_btc := peso;
                        pageAbrir.SetDatos(Peso_btc, NumPalets_btc, NumBultos_btc);

                    end;
                end;
            }

        }

        addafter(DocAttach)
        {
            action(InsertarComentariosPredefinidos)
            {
                ApplicationArea = All;
                Image = NewProperties;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Insert predefined comments', comment = 'ESP="Insertar comentarios predefinidos"';
                ToolTip = 'Insert the comments in the table of predefined comments as order comments',
                    comment = 'ESP="Inserta como comentarios de pedido los comentarios que haya en la tabla de comentarios predefinidos"';

                trigger OnAction()
                var
                    recComentario: Record ComentariosPredefinidos;
                    pageComentarios: page "Lista comentarios predefinidos";
                begin
                    clear(pageComentarios);
                    pageComentarios.LookupMode(true);

                    if pageComentarios.RunModal() = Action::LookupOK then begin
                        pageComentarios.GetRecord(recComentario);
                        SetWorkDescription(recComentario.GetComentario());
                    end;
                end;
            }
        }

        addafter(Email)
        {
            action(Email_btc)
            {
                ApplicationArea = All;
                Image = Email;
                Promoted = true;
                PromotedCategory = Category6;
                Caption = '&Email', comment = 'ESP="&Correo electrónico"';
                trigger onAction()
                var
                    cduCron: Codeunit CU_Cron;
                begin
                    cduCron.EnvioPersonalizado(Rec);
                end;
            }

        }
        modify(Email)
        {
            Visible = false;
        }

        modify(SendCustom)
        {
            Visible = false;
        }

        addfirst(Reporting)
        {
            action("Impimir Fact.Export")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                Caption = 'Impimir Fact.Export', comment = 'ESP="Impimir Fact.Export"';
                ToolTip = 'Impimir Fact.Export',
                    comment = 'ESP="Impimir Fact.Export"';

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    Customer: Record Customer;
                    recReqLine: Report FacturaExportacion;
                    reportFactura: Report FacturaNacionalMaquinas;
                    reportFacturaUK: Report FacturaNacionalUK;

                    Selection: Integer;
                begin
                    Selection := STRMENU('1.-Exportacion,2.-Nacional,3.-Lidl,4.-Brasil,5.-Zummo UK', 1);
                    // Message(Format(Selection));
                    SalesInvoiceHeader.Reset();
                    IF Selection > 0 THEN begin

                        SalesInvoiceHeader.SetRange("No.", Rec."No.");
                        if SalesInvoiceHeader.FindFirst() then
                            case Selection of
                                1:
                                    begin
                                        clear(reportFactura);
                                        reportFactura.EsExportacion();
                                        reportFactura.SetTableView(SalesInvoiceHeader);
                                        reportFactura.Run();
                                    end;
                                2:
                                    begin
                                        clear(reportFactura);
                                        reportFactura.EsNacional();
                                        if Customer.Get(Rec."Sell-to Customer No.") then
                                            reportFactura.Pneto(Customer."Mostrar Documentos Netos");
                                        reportFactura.SetTableView(SalesInvoiceHeader);
                                        reportFactura.Run();
                                    end;
                                3:
                                    begin
                                        clear(reportFactura);
                                        reportFactura.EsLidl();
                                        reportFactura.SetTableView(SalesInvoiceHeader);
                                        reportFactura.Run();
                                    end;
                                4:
                                    Report.Run(Report::FacturaRegBrasil, true, false, SalesInvoiceHeader);//50123
                                5:
                                    begin
                                        clear(reportFactura);
                                        reportFacturaUK.EsExportacion();
                                        reportFacturaUK.SetTableView(SalesInvoiceHeader);
                                        reportFacturaUK.Run();
                                    end;
                            end;
                    end;
                end;
            }

        }

    }

    trigger OnAfterGetRecord()
    begin
        FechaOperacion := Funciones.GetExtensionFieldValueDate(Rec.RecordId, 66600, false)  // Fecha operación SII
    end;

    var
        FechaOperacion: date;
        Funciones: Codeunit Funciones;
        Text000: Label 'Se va a realizar el cambio de Fecha de operacion de la factura %1, en la Bandeja de SII.\ ¿Desea continuar?'
            , comment = 'ESP="Se va a realizar el cambio de Fecha de operacion de la factura %1, en la Bandeja de SII.\¿Desea continuar?"';

    local procedure SetWorkDescription(NewWorkDescription: Text)
    var
        TempBlob: Record TempBlob temporary;
    begin
        CLEAR("Work Description");

        IF NewWorkDescription = '' THEN
            EXIT;

        TempBlob.Blob := "Work Description";
        TempBlob.WriteAsText(NewWorkDescription, TEXTENCODING::UTF8);
        "Work Description" := TempBlob.Blob;

        MODIFY;
    end;

    local procedure SetFechaOperacion()
    var

    begin
        if not Confirm(Text000, false, rec."No.") then
            exit;
        // actualizamos el campo de fecha operacion en la tabla de historico ventas, extension SII
        Funciones.SetExtensionFieldValueDate(rec.RecordId, 66600, FechaOperacion);

        // actualizamos el campo de fecha operacion en la tabla de Bandeja de salida (66600), extension SII, campo 30 Fecha operacion
        Funciones.SetExtensionRecRefFieldValueDate(rec."No.", FechaOperacion);
        // actualizamos el campo de fecha operacion en la tabla de SII GBS
        Funciones.SIIGBS_SetExtensionRecRefFieldValueDate(rec."No.", FechaOperacion);

    end;
}