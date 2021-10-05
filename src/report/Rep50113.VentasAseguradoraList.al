report 50113 "Ventas Aseguradora - List"
{
    Caption = 'Ventas Aseguradora', Comment = 'ESP="Ventas Aseguradora"';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50113.VentasAseguradoraList.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Clasif1; Integer)
        {
            DataItemTableView = sorting(number) where(number = filter(1 .. 2));
            column(Clasif1Number; Number) { }
            column(CaptionAsegurado; CaptionAsegurado) { }

            dataitem(Clasif2; Integer)
            {
                DataItemTableView = sorting(number) where(number = filter(1 .. 7));

                column(Clasificacion2; Clasificacion2) { }
                column(Clasificacion2Number; number) { }
                dataitem("Sales Inv Header"; "Sales Invoice Header")
                {
                    DataItemTableView = sorting("No.", "Posting Date");
                    RequestFilterFields = "Posting Date";

                    trigger OnPreDataItem()
                    begin


                        SetRange("No.", '');
                    end;

                }
                dataitem(Registros; integer) // "Sales Invoice Header")
                {
                    DataItemTableView = sorting(number);
                    //RequestFilterFields = "Posting Date";
                    column(Clasif2Nivel; Clasif2Nivel)
                    {
                    }
                    column(CompanyName; CompanyProperty.DisplayName())
                    {
                    }
                    column(ShowDetails; ShowDetails)
                    {
                    }
                    column(GLEntryFilter; GLEntryFilterTxt)
                    {
                    }
                    column(Supplement; SupplementTxt)
                    {
                    }
                    column(DocumentDate; DocumentDateTxt)
                    {
                    }
                    column(Amount; AmountDL)
                    {
                    }
                    column(Amount_Including_VAT; SalesInvoiceHeader.ImporteReport)
                    {

                    }
                    column(Amount_Including_VATDL; SalesInvoiceHeader.ImporteDLReport)  // AmountIncludingVATDL)
                    { }
                    column(PaymentMethod; PaymentMethodTxt)
                    {
                    }
                    column(PaymentTerms; PaymentTerms.Code)
                    {
                    }
                    column(DueDate; DuedateTxt)
                    {
                    }
                    column(DocumentNo; DocumentNoTxt)
                    {
                    }
                    column(BusinessName; BusinessNameTxt)
                    {
                    }
                    column(PostingDate; PostingDateTxt)
                    {
                    }
                    column(Type; TypeTxt)
                    {
                    }
                    column(Country; CountryTxt)
                    {
                    }
                    column(CustomerAsegurador; Customer."Cred_ Max_ Aseg. Autorizado Por_btc")
                    {
                    }

                    column(CustomerClasifAseguradora; Customer.clasificacion_aseguradora)
                    {
                    }
                    column(estadoDocumentoTxt; estadoDocumentoTxt) { }

                    column(estadoDocCaption_Lbl; estadoDocCaption_Lbl) { }



                    trigger OnPreDataItem()
                    begin


                        if Aseguradora = '' then
                            ERROR('Debe seleccionar una aseguradora para mostrar los datos');

                        case Clasif1.Number of
                            1:
                                begin
                                    SalesInvoiceHeader.SetRange("Cred_ Max_ Aseg. AutorizadoPor", Aseguradora);
                                    SalesInvoiceHeader.SetFilter(clasificacion_aseguradora, '<>%1', 'REHUSADO');
                                end;
                            2:
                                begin
                                    SalesInvoiceHeader.SetRange("Cred_ Max_ Aseg. AutorizadoPor");
                                    SalesInvoiceHeader.SetRange(clasificacion_aseguradora);
                                end;
                        end;
                        // filtramos el registro a tantos registros como facturas haya
                        Registros.SetRange(Number, 1, SalesInvoiceHeader.Count);
                    end;

                    trigger OnAfterGetRecord()
                    var
                        recCarteraDoc: Record "Cartera Doc.";
                        recPostedCarteraDoc: Record "Posted Cartera Doc.";
                        recClosedCarteraDoc: Record "Closed Cartera Doc.";
                        recMovsClienteLiquidacion: Record "Cust. Ledger Entry";
                        recCustomer: Record "Customer";
                    begin
                        // posicionamos el temporal 
                        if Number = 1 then
                            SalesInvoiceHeader.FindSet()
                        else
                            SalesInvoiceHeader.Next();

                        if (NOT Customer.Get(SalesInvoiceHeader."Sell-to Customer No.")) then
                            CurrReport.Skip();

                        if PaymentMethod.Get(SalesInvoiceHeader."Payment Method Code") then
                            PaymentMethodTxt := PaymentMethod.Description;
                        if CountryRegion.Get(SalesInvoiceHeader."Sell-to Country/Region Code") then
                            CountryTxt := CountryRegion.Name;
                        if PaymentTerms.Get(SalesInvoiceHeader."Payment Terms Code") then;

                        case Clasif1.Number of
                            1:
                                begin
                                    case Clasif2.Number of
                                        1:
                                            begin
                                                CaptionAsegurado := lblAsegurado;
                                                if Customer.clasificacion_aseguradora in ['INTERCOMPANY', 'AUTOFACTURA', 'ORGANISMOS PUBLICO', 'REHUSADO', 'CLIENTE PARTICULAR'] then
                                                    CurrReport.Skip();
                                                if PaymentMethod."Es Contado" or PaymentTerms."Es Contado" then
                                                    CurrReport.Skip();
                                                Clasif2Nivel := CountryRegion.Name;
                                                Clasificacion2 := CountryRegion.Name;
                                            end;
                                        else
                                            CurrReport.Skip();
                                    end;
                                end;
                            2:
                                begin
                                    CaptionAsegurado := lblNoAsegurado;
                                    if (Customer."Cred_ Max_ Aseg. Autorizado Por_btc" = Aseguradora) and (Customer.clasificacion_aseguradora <> 'REHUSADO')
                                        and not (PaymentMethod."Es Contado" or PaymentTerms."Es Contado") then
                                        CurrReport.Skip();
                                    case Clasif2.Number of
                                        1:
                                            begin
                                                if Customer.clasificacion_aseguradora in ['INTERCOMPANY', 'AUTOFACTURA', 'ORGANISMOS PUBLICO', 'REHUSADO', 'CLIENTE PARTICULAR'] then
                                                    CurrReport.Skip();
                                                if not (PaymentMethod."Es Contado" or PaymentTerms."Es Contado") then
                                                    CurrReport.Skip();
                                            end;
                                        2:
                                            if not (Customer.clasificacion_aseguradora in ['INTERCOMPANY']) then
                                                CurrReport.Skip();
                                        3:
                                            begin
                                                if not (Customer.clasificacion_aseguradora in ['AUTOFACTURA']) then
                                                    CurrReport.Skip();
                                            end;
                                        4:
                                            if not (Customer.clasificacion_aseguradora in ['REHUSADO']) then
                                                CurrReport.Skip();
                                        5:
                                            if not (Customer.clasificacion_aseguradora in ['ORGANISMO PUBLICO']) then
                                                CurrReport.Skip();
                                        6:
                                            if not (Customer.clasificacion_aseguradora in ['CLIENTE PARTICULAR']) then
                                                CurrReport.Skip();
                                        7: // Clasificacion2 := 'OTROS' - 'CONTADO O PREPAGO','EMPRESAS VINCULADAS','CLIENTES REHUSADOS','ORGANISMOS PUBLICOS','PARTICULARES'
                                            begin
                                                if PaymentMethod."Es Contado" or PaymentTerms."Es Contado" then
                                                    CurrReport.Skip();
                                                if Customer.clasificacion_aseguradora in ['INTERCOMPANY', 'AUTOFACTURA', 'ORGANISMOS PUBLICO', 'REHUSADO', 'CLIENTE PARTICULAR'] then
                                                    CurrReport.Skip();
                                            end;

                                    end;
                                end;
                        end;

                        if (Customer."Cred_ Max_ Aseg. Autorizado Por_btc" <> '') and (PaymentMethod."Es Contado") then begin
                            Clasif2Nivel := CountryRegion.Name;
                        end else begin
                            if Customer.clasificacion_aseguradora <> '' then
                                Clasif2Nivel := Customer.clasificacion_aseguradora
                            else
                                Clasif2Nivel := 'OTROS';
                        end;



                        if Customer."Cred_ Max_ Aseg. Autorizado Por_btc" <> Aseguradora then
                            Customer."Cred_ Max_ Aseg. Autorizado Por_btc" := '';

                        if Customer.clasificacion_aseguradora = 'REHUSADO' then
                            Customer."Cred_ Max_ Aseg. Autorizado Por_btc" := '';

                        SupplementTxt := Customer.Suplemento_aseguradora;
                        BusinessNameTxt := StrSubstNo('%1 - %2', Customer."No.", Customer.Name);
                        DocumentDateTxt := Format(SalesInvoiceHeader."Document Date");


                        DueDateTxt := Format(SalesInvoiceHeader."Due Date");
                        DocumentNoTxt := SalesInvoiceHeader."No.";

                        PostingDateTxt := Format(SalesInvoiceHeader."Posting Date");
                        TypeTxt := 'Factura';  // Format("Document Type");



                        // Estado documento
                        //Pendiente = ''
                        estadoDocumentoTxt := '';

                        recCarteraDoc.Reset();
                        recCarteraDoc.SetRange("Document No.", SalesInvoiceHeader."No.");
                        if recCarteraDoc.FindFirst() then
                            estadoDocumentoTxt := '' //estadoDocumentoTxt := 'Remesada'
                        else begin
                            recPostedCarteraDoc.Reset();
                            recPostedCarteraDoc.SetRange("Document No.", SalesInvoiceHeader."No.");
                            if recPostedCarteraDoc.FindFirst() then
                                estadoDocumentoTxt := '' //estadoDocumentoTxt := 'Pdte. Pago'
                            else begin
                                recClosedCarteraDoc.Reset();
                                recClosedCarteraDoc.SetRange("Document No.", SalesInvoiceHeader."No.");
                                if recClosedCarteraDoc.FindFirst() then
                                    estadoDocumentoTxt := 'Pagada'
                            end;
                        end;
                        /*SalesInvoiceHeader.CalcFields(Amount);
                        // buscamos el importe DL del movimiento de cliente
                        if SalesInvoiceHeader."Currency Factor" <> 0 then
                            AmountDL := SalesInvoiceHeader.Amount / SalesInvoiceHeader."Currency Factor"
                        else
                            AmountDL := SalesInvoiceHeader.Amount;
                        AmountIncludingVATDL := 0;
                        if recMovsCliente.Get(SalesInvoiceHeader."Cust. Ledger Entry No.") then begin
                            recMovsCliente.CalcFields("Amount (LCY)");
                            AmountIncludingVATDL := recMovsCliente."Amount (LCY)";
                        end;*/
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if Clasif1.Number = 1 then
                        SetRange(Number, 1)
                    else
                        SetRange(Number, 1, 7);

                end;

                trigger OnAfterGetRecord()
                begin
                    case Clasif2.Number of
                        1:
                            Clasificacion2 := 'CONTADO O PREPAGO';
                        2:
                            Clasificacion2 := 'EMPRESAS VINCULADAS';
                        3:
                            Clasificacion2 := 'AUTOFACTURA';
                        4:
                            Clasificacion2 := 'CLIENTES REHUSADOS';
                        5:
                            Clasificacion2 := 'ORGANISMOS PUBLICOS';
                        6:
                            Clasificacion2 := 'PARTICULARES';
                        7:
                            Clasificacion2 := 'OTROS';
                    end;
                end;
            }

            trigger OnPreDataItem()
            begin
                // cargamos en la variable temporal las facturas y abonos
                ChargeInvoice_return();
            end;

            trigger OnAfterGetRecord()
            begin
                case Clasif1.Number of
                    1:
                        CaptionAsegurado := lblAsegurado;
                    2:
                        CaptionAsegurado := lblNoAsegurado;
                end;
            end;
        }
    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    field(Aseguradora; Aseguradora)
                    {
                        ApplicationArea = all;
                        Caption = 'Filtro Aseguradora', comment = 'Filtro Aseguradora';

                        TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(Tabla), TipoTabla = const(Aseguradora));
                    }
                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = all;
                        Caption = 'Mostrar Detalle', comment = 'ESP="Mostrar Detalle"';
                    }
                    field(ShowPayments; ShowPayments)
                    {
                        ApplicationArea = all;
                        Caption = 'Mostrar Pagos', comment = 'ESP="Mostrar Pagos"';
                        Visible = false;
                    }
                    field(ShowCreditMemo; ShowCreditMemo)
                    {
                        ApplicationArea = all;
                        Caption = 'Mostrar Abonos', comment = 'ESP="Mostrar Abonos"';
                        Visible = false;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        CESCESalesCaption = 'Ventas Periodo', Comment = 'ESP="Ventas Periodo"';
        SupplementHeading = 'Suplemento', Comment = 'Supplemento';
        DocumentDateHeading = 'Fecha Doc.', Comment = 'Document Date';
        AmountHeading = 'Importe', Comment = 'Amount';
        PaymentMethodHeading = 'Forma de Pago', Comment = 'Payment Method';
        DueDateHeading = 'Vencimiento', Comment = 'Due Date';
        DocumentNoHeading = 'Factura/Abono', Comment = 'Document No.';
        BusinesNameHeading = 'Razón Social', Comment = 'Business Name';
        PostingDateHeading = 'Fecha Contabilización', Comment = 'Posting Date';
        TypeHeading = 'Tipo', Comment = 'Type';
        CountryHeading = 'País', Comment = 'Country';
        TotalAmountHeading = 'Importe Total', Comment = 'Total Amount';
        AmountIncVAT = 'Importe Incl. IVA', Comment = 'Importe Incl. IVA';
        AmountIncVATDL = 'Importe Incl. IVA (DL)', Comment = 'ESP="Importe Incl. IVA (DL)"';
    }

    trigger OnPreReport();
    var
        FormatDocument: Codeunit "Format Document";
    begin
        GLEntryFilterTxt := FormatDocument.GetRecordFiltersWithCaptions("Sales Inv Header");

    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header" temporary;
        recMovsCliente: Record "Cust. Ledger Entry";
        HistAsegurora: Record "STH Hist. Aseguradora";
        Customer: Record Customer;
        PaymentMethod: Record "Payment Method";
        PaymentTerms: Record "Payment Terms";
        CountryRegion: Record "Country/Region";
        //Para guardar los Document no q ya se han mostrado en la factura
        GLEntryFilterTxt: Text;
        SupplementTxt: Text;
        DocumentDateTxt: Text;
        PaymentMethodTxt: Text;
        DueDateTxt: Text;
        DocumentNoTxt: Text;
        BusinessNameTxt: Text;
        PostingDateTxt: Text;
        TypeTxt: Text;
        CountryTxt: Text;
        estadoDocumentoTxt: Text;
        Clasif2Nivel: Text;
        Clasificacion2: text;
        estadoDocCaption_Lbl: Label 'Document Status', Comment = 'ESP="Estado Documento"';
        lblAsegurado: Label 'VENTAS ASEGURABLES', comment = 'ESP="VENTAS ASEGURABLES"';
        lblNoAsegurado: Label 'VENTAS NO ASEGURABLES', comment = 'ESP="VENTAS NO ASEGURABLES"';
        ShowPayments: Boolean;
        ShowCreditMemo: Boolean;
        ShowDetails: Boolean;
        Aseguradora: Text;
        CaptionAsegurado: text;
        AmountDL: Decimal;
        AmountIncludingVATDL: Decimal;

    local procedure CheckCustomerCESCE(CustomerNo: code[20]; var Suplemento: text): Boolean;
    begin
        HistAsegurora.SetRange(CustomerNo, CustomerNo);
        HistAsegurora.SetRange(Aseguradora, 'CESCE');
        if HistAsegurora.FindLast() then begin
            Suplemento := HistAsegurora.Suplemento;
            exit(true);
        end;
    end;

    local procedure ChargeInvoice_return()
    var
        SalesInv: Record "Sales Invoice Header";
        SalesCRMemo: Record "Sales Cr.Memo Header";
    begin
        SalesInvoiceHeader.DeleteAll();
        SalesInv.CopyFilters("Sales Inv Header");
        SalesInv.SetRange("No. Series", 'V-FAC+');
        if SalesInv.findset() then
            repeat
                SalesInv.CalcFields(Amount, "Amount Including VAT");
                SalesInvoiceHeader.Init();
                SalesInvoiceHeader.TransferFields(SalesInv);
                SalesInvoiceHeader.ImporteReport := SalesInv."Amount Including VAT";
                if recMovsCliente.Get(SalesInvoiceHeader."Cust. Ledger Entry No.") then begin
                    recMovsCliente.CalcFields("Amount (LCY)");
                    AmountIncludingVATDL := recMovsCliente."Amount (LCY)";
                end else
                    AmountIncludingVATDL := SalesInv."Amount Including VAT";
                SalesInvoiceHeader.ImporteDLReport := AmountIncludingVATDL;
                SalesInvoiceHeader.Insert();


            Until SalesInv.next() = 0;
        // añadimos los abonos tambien
        SalesCRMemo.SetFilter("Posting Date", "Sales Inv Header".GetFilter("Posting Date"));
        SalesCRMemo.SetRange("No. Series", 'V-AB+');
        if SalesCRMemo.findset() then
            repeat
                SalesCRMemo.CalcFields(Amount, "Amount Including VAT");
                SalesInvoiceHeader.Init();
                SalesInvoiceHeader.TransferFields(SalesCRMemo);
                SalesInvoiceHeader.ImporteReport := -SalesCRMemo."Amount Including VAT";
                if recMovsCliente.Get(SalesInvoiceHeader."Cust. Ledger Entry No.") then begin
                    recMovsCliente.CalcFields("Amount (LCY)");
                    AmountIncludingVATDL := recMovsCliente."Amount (LCY)";
                end else
                    AmountIncludingVATDL := -SalesCRMemo."Amount Including VAT";
                SalesInvoiceHeader.ImporteDLReport := AmountIncludingVATDL;
                SalesInvoiceHeader.Insert();

            Until SalesCRMemo.next() = 0;
    end;

}
