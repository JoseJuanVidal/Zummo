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
            column(CaptionAsegurado; CaptionAsegurado) { }

            dataitem(Clasif2; Integer)
            {
                DataItemTableView = sorting(number) where(number = filter(1 .. 6));

                column(Clasificacion2; Clasificacion2) { }

                dataitem("Sales Invoice Header"; "Sales Invoice Header")
                {
                    DataItemTableView = sorting("No.", "Posting Date");
                    RequestFilterFields = "Posting Date";

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
                    column(Amount_Including_VAT; "Amount Including VAT")
                    {

                    }
                    column(Amount_Including_VATDL; AmountIncludingVATDL) { }
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
                    column(Clasif2Nivel; Clasif2Nivel)
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
                                    SetRange("Cred_ Max_ Aseg. AutorizadoPor", Aseguradora);
                                    SetFilter(clasificacion_aseguradora, '<>%1', 'REHUSADO');
                                end;
                            2:
                                begin
                                    SetRange("Cred_ Max_ Aseg. AutorizadoPor");
                                    SetRange(clasificacion_aseguradora);
                                end;
                        end;
                    end;

                    trigger OnAfterGetRecord()
                    var
                        recCarteraDoc: Record "Cartera Doc.";
                        recPostedCarteraDoc: Record "Posted Cartera Doc.";
                        recClosedCarteraDoc: Record "Closed Cartera Doc.";
                        recMovsCliente: Record "Cust. Ledger Entry";
                        recMovsClienteLiquidacion: Record "Cust. Ledger Entry";
                        recCustomer: Record "Customer";
                    begin


                        if (NOT Customer.Get("Sell-to Customer No.")) then
                            CurrReport.Skip();

                        if PaymentMethod.Get("Payment Method Code") then
                            PaymentMethodTxt := PaymentMethod.Description;

                        case Clasif1.Number of
                            1:
                                begin
                                    CaptionAsegurado := lblAsegurado;
                                    if PaymentMethod."Es Contado" then
                                        CurrReport.Skip();
                                end;
                            2:
                                begin
                                    CaptionAsegurado := lblNoAsegurado;
                                    if (Customer."Cred_ Max_ Aseg. Autorizado Por_btc" = Aseguradora) and (Customer.clasificacion_aseguradora <> 'REHUSADO')
                                        and (not PaymentMethod."Es Contado") then
                                        CurrReport.Skip();
                                    case Clasif2.Number of
                                        1: // Clasificacion2 := 'XXXXXX';
                                            if not PaymentMethod."Es Contado" then
                                                CurrReport.Skip();
                                        2:
                                            if not (Customer.clasificacion_aseguradora in ['INTERCOMPANY', 'AUTOFACTURA']) then
                                                CurrReport.Skip();
                                        3:
                                            if not (Customer.clasificacion_aseguradora in ['REHUSADO']) then
                                                CurrReport.Skip();
                                        4:
                                            if not (Customer.clasificacion_aseguradora in ['ORGANISMO PUBLICO']) then
                                                CurrReport.Skip();
                                        5:
                                            if not (Customer.clasificacion_aseguradora in ['CLIENTE PARTICULAR']) then
                                                CurrReport.Skip();

                                        6: // Clasificacion2 := 'OTROS' - 'CONTADO O PREPAGO','EMPRESAS VINCULADAS','CLIENTES REHUSADOS','ORGANISMOS PUBLICOS','PARTICULARES'
                                            begin
                                                if PaymentMethod."Es Contado" then
                                                    CurrReport.Skip();
                                                if Customer.clasificacion_aseguradora in ['INTERCOMPANY', 'AUTOFACTURA', 'ORGANISMOS PUBLICO', 'REHUSADO', 'CLIENTE PARTICULAR'] then
                                                    CurrReport.Skip();
                                            end;
                                    end;
                                end;
                        end;

                        if PaymentTerms.get("Payment Terms Code") then;



                        if Customer."Cred_ Max_ Aseg. Autorizado Por_btc" <> Aseguradora then
                            Customer."Cred_ Max_ Aseg. Autorizado Por_btc" := '';

                        if Customer.clasificacion_aseguradora = 'REHUSADO' then
                            Customer."Cred_ Max_ Aseg. Autorizado Por_btc" := '';

                        SupplementTxt := Customer.Suplemento_aseguradora;
                        BusinessNameTxt := StrSubstNo('%1 - %2', Customer."No.", Customer.Name);
                        DocumentDateTxt := Format("Document Date");


                        DueDateTxt := Format("Due Date");
                        DocumentNoTxt := "No.";

                        PostingDateTxt := Format("Posting Date");
                        TypeTxt := 'Factura';  // Format("Document Type");

                        if CountryRegion.Get("Sell-to Country/Region Code") then
                            CountryTxt := CountryRegion.Name;


                        if Customer."Cred_ Max_ Aseg. Autorizado Por_btc" <> '' then begin
                            Clasif2Nivel := CountryRegion.Name;
                            Clasificacion2 := CountryRegion.Name;
                        end else begin
                            if PaymentMethod."Es Contado" then
                                Clasif2Nivel := PaymentMethod.Code
                            else
                                if Customer.clasificacion_aseguradora <> '' then
                                    Clasif2Nivel := Customer.clasificacion_aseguradora
                                else
                                    Clasif2Nivel := 'OTROS';
                        end;

                        // Estado documento
                        //Pendiente = ''
                        estadoDocumentoTxt := '';

                        recCarteraDoc.Reset();
                        recCarteraDoc.SetRange("Document No.", "No.");
                        if recCarteraDoc.FindFirst() then
                            estadoDocumentoTxt := '' //estadoDocumentoTxt := 'Remesada'
                        else begin
                            recPostedCarteraDoc.Reset();
                            recPostedCarteraDoc.SetRange("Document No.", "No.");
                            if recPostedCarteraDoc.FindFirst() then
                                estadoDocumentoTxt := '' //estadoDocumentoTxt := 'Pdte. Pago'
                            else begin
                                recClosedCarteraDoc.Reset();
                                recClosedCarteraDoc.SetRange("Document No.", "No.");
                                if recClosedCarteraDoc.FindFirst() then
                                    estadoDocumentoTxt := 'Pagada'
                            end;
                        end;

                        // buscamos el importe DL del movimiento de cliente
                        if "Currency Factor" <> 0 then
                            AmountDL := Amount / "Currency Factor"
                        else
                            AmountDL := Amount;
                        AmountIncludingVATDL := 0;
                        if recMovsCliente.Get("Cust. Ledger Entry No.") then begin
                            recMovsCliente.CalcFields("Amount (LCY)");
                            AmountIncludingVATDL := recMovsCliente."Amount (LCY)";
                        end;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if Clasif1.Number = 1 then
                        SetRange(Number, 1)
                    else
                        SetRange(Number, 1, 6);
                end;

                trigger OnAfterGetRecord()
                begin
                    case Clasif2.Number of
                        1:
                            Clasificacion2 := 'CONTADO O PREPAGO';
                        2:
                            Clasificacion2 := 'EMPRESAS VINCULADAS';
                        3:
                            Clasificacion2 := 'CLIENTES REHUSADOS';
                        4:
                            Clasificacion2 := 'ORGANISMOS PUBLICOS';
                        5:
                            Clasificacion2 := 'PARTICULARES';
                        6:
                            Clasificacion2 := 'OTROS';
                    end;
                end;
            }

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
        GLEntryFilterTxt := FormatDocument.GetRecordFiltersWithCaptions("Sales Invoice Header");

    end;

    var
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
}
