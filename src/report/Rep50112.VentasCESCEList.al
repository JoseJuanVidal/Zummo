report 50112 "Ventas CESCE - List"
{
    Caption = 'Ventas CESCE', Comment = 'CESCE Sales';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50112.VentasCESCEList.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView =
                sorting("Document No.", "Posting Date")
                where("Document Type" = filter(Invoice | "Credit Memo" | Payment), "Source Type" = filter(Customer));
            RequestFilterFields = "Posting Date";

            column(CompanyName; CompanyProperty.DisplayName())
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
            column(Amount; Amount)
            {
            }
            column(Entry_No_; "Entry No.")
            {
            }
            column(PaymentMethod; PaymentMethodTxt)
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

            column(estadoDocumentoTxt; estadoDocumentoTxt) { }

            column(estadoDocCaption_Lbl; estadoDocCaption_Lbl) { }

            trigger OnAfterGetRecord()
            var
                recCarteraDoc: Record "Cartera Doc.";
                recPostedCarteraDoc: Record "Posted Cartera Doc.";
                recClosedCarteraDoc: Record "Closed Cartera Doc.";
                recMovsCliente: Record "Cust. Ledger Entry";
                recMovsClienteLiquidacion: Record "Cust. Ledger Entry";
                recCustomer: Record "Customer";
                txtNoCuenta: Code[20];
            begin
                case "Document Type" of
                    "Document Type"::Invoice:
                        if SalesInvHeader.Get("Document No.") then begin
                            if (NOT Customer.Get(SalesInvHeader."Sell-to Customer No.")) OR
                                 // comprobar si tiene CESCE en el historico
                                 // (Customer."Cred_ Max_ Aseg. Autorizado Por_btc" <> 'CESCE') OR
                                 // (Customer."Credito Maximo Aseguradora_btc" <= 0) then
                                 NOT CheckCustomerCESCE(Customer."No.", SupplementTxt) then
                                // -comprobar
                                CurrReport.Skip();
                            // Para evitar el desglose mostramos solo la primera linea que tenga importe positivo y q venga de las cuentas 43*
                            // Si encontramos una registro es q ya hemos pintado una linea con ese No Documento, por tanto la saltamos
                            txtNoCuenta := '';
                            IF Strlen("G/L Account No.") >= 2 then
                                txtNoCuenta := CopyStr("G/L Account No.", 1, 2);
                            IF (Amount <= 0) OR (txtNoCuenta <> '43') OR (TempAgingBandBuffer.Get("Document No.")) then
                                CurrReport.Skip();

                            TempAgingBandBuffer.Init();
                            TempAgingBandBuffer."Currency Code" := "Document No.";
                            TempAgingBandBuffer.Insert();

                            //SupplementTxt := Customer.Suplemento_aseguradora;
                            BusinessNameTxt := StrSubstNo('%1 - %2', Customer."No.", Customer.Name);
                            DocumentDateTxt := Format(SalesInvHeader."Document Date");

                            if PaymentMethod.Get(SalesInvHeader."Payment Method Code") then
                                PaymentMethodTxt := PaymentMethod.Description;

                            DueDateTxt := Format(SalesInvHeader."Due Date");
                            DocumentNoTxt := SalesInvHeader."No.";

                            PostingDateTxt := Format(SalesInvHeader."Posting Date");
                            TypeTxt := Format("Document Type");

                            if CountryRegion.Get(SalesInvHeader."Sell-to Country/Region Code") then
                                CountryTxt := CountryRegion.Name;
                        end else
                            CurrReport.Skip();
                    "Document Type"::"Credit Memo":
                        if SalesCrMemoHeader.Get("Document No.") then begin
                            if not ShowCreditMemo then
                                CurrReport.Skip();
                            if (NOT Customer.Get(SalesCrMemoHeader."Sell-to Customer No.")) OR
                                // comprobar si tiene CESCE en el historico
                                // (Customer."Cred_ Max_ Aseg. Autorizado Por_btc" <> 'CESCE') OR
                                // (Customer."Credito Maximo Aseguradora_btc" <= 0) then
                                NOT CheckCustomerCESCE(Customer."No.", SupplementTxt) then
                                CurrReport.Skip();
                            //Tenemos en cuenta solo los abonos negativos (evitamos el desglose de los positivos) y no repetir abono
                            If (Amount >= 0) OR (TempAgingBandBuffer.Get("Document No.")) then
                                CurrReport.Skip();

                            //SupplementTxt := Customer.Suplemento_aseguradora;
                            BusinessNameTxt := StrSubstNo('%1 - %2', Customer."No.", Customer.Name);

                            DocumentDateTxt := Format(SalesCrMemoHeader."Document Date");

                            if PaymentMethod.Get(SalesCrMemoHeader."Payment Method Code") then
                                PaymentMethodTxt := PaymentMethod.Description;

                            DueDateTxt := Format(SalesCrMemoHeader."Due Date");
                            DocumentNoTxt := SalesCrMemoHeader."No.";
                            PostingDateTxt := Format(SalesCrMemoHeader."Posting Date");
                            //Para descartar los abonos cuya fecha de registro calculada es diferente a la del filtro del usuario
                            If (Format("Posting Date") <> PostingDateTxt) then
                                CurrReport.Skip();
                            TypeTxt := Format("Document Type");

                            if CountryRegion.Get(SalesCrMemoHeader."Sell-to Country/Region Code") then
                                CountryTxt := CountryRegion.Name;

                            //Guardamos nº abono para no repetir documento
                            TempAgingBandBuffer.Init();
                            TempAgingBandBuffer."Currency Code" := "Document No.";
                            TempAgingBandBuffer.Insert();
                        end else
                            CurrReport.Skip();
                    "Document Type"::Payment:
                        begin
                            // si no marcan opciones, no mostramos los pagos
                            if not ShowPayments then
                                CurrReport.Skip();

                            CustLedgerEntry.Reset();
                            CustLedgerEntry.SetRange("Document No.", "Document No.");
                            CustLedgerEntry.SetRange("Entry No.", "Entry No.");
                            //CustLedgerEntry.SetRange("Transaction No.", "Transaction No.");
                            if (CustLedgerEntry.FindFirst()) then begin
                                if (NOT Customer.Get(CustLedgerEntry."Sell-to Customer No.")) OR
                                // comprobar si tiene CESCE en el historico
                                // (Customer."Cred_ Max_ Aseg. Autorizado Por_btc" <> 'CESCE') OR
                                // (Customer."Credito Maximo Aseguradora_btc" <= 0) then
                                NOT CheckCustomerCESCE(Customer."No.", SupplementTxt) then
                                    CurrReport.Skip();

                                //SupplementTxt := Customer.Suplemento_aseguradora;
                                BusinessNameTxt := StrSubstNo('%1 - %2', Customer."No.", Customer.Name);

                                DocumentDateTxt := Format(CustLedgerEntry."Document Date");

                                if PaymentMethod.Get(CustLedgerEntry."Payment Method Code") then
                                    PaymentMethodTxt := PaymentMethod.Description;

                                DueDateTxt := Format(CustLedgerEntry."Due Date");
                                //Se busca el no documento
                                recMovsCliente.Reset();
                                recMovsCliente.setrange("Posting Date", "Posting Date");
                                recMovsCliente.SetRange("Document No.", "Document No.");
                                IF NOT recMovsCliente.FindFirst() then
                                    CurrReport.Skip();

                                recMovsClienteLiquidacion.reset();
                                recMovsClienteLiquidacion.SetRange("Closed by Entry No.", "Entry No.");
                                If NOT recMovsClienteLiquidacion.FindFirst() then
                                    CurrReport.Skip();
                                //DocumentNoTxt := CustLedgerEntry."Document No.";
                                DocumentNoTxt := Format(recMovsClienteLiquidacion."Document No.");


                                PostingDateTxt := Format(CustLedgerEntry."Posting Date");
                                TypeTxt := Format("Document Type");

                                //Se busca el país del cliente
                                Customer.Reset();
                                Customer.get(recMovsCliente."Customer No.");

                                //if CountryRegion.Get(SalesInvHeader."Sell-to Country/Region Code") then 
                                if CountryRegion.Get(Customer."Country/Region Code") then
                                    CountryTxt := CountryRegion.Name;
                            end else
                                CurrReport.Skip();
                        end;
                end;

                // Estado documento
                //Pendiente = ''
                estadoDocumentoTxt := '';

                recCarteraDoc.Reset();
                recCarteraDoc.SetRange("Document No.", "Document No.");
                if recCarteraDoc.FindFirst() then
                    estadoDocumentoTxt := '' //estadoDocumentoTxt := 'Remesada'
                else begin
                    recPostedCarteraDoc.Reset();
                    recPostedCarteraDoc.SetRange("Document No.", "Document No.");
                    if recPostedCarteraDoc.FindFirst() then
                        estadoDocumentoTxt := '' //estadoDocumentoTxt := 'Pdte. Pago'
                    else begin
                        recClosedCarteraDoc.Reset();
                        recClosedCarteraDoc.SetRange("Document No.", "Document No.");
                        if recClosedCarteraDoc.FindFirst() then
                            estadoDocumentoTxt := 'Pagada'
                    end;
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
                    field(ShowPayments; ShowPayments)
                    {
                        ApplicationArea = all;
                        Caption = 'Mostrar Pagos', comment = 'ESP="Mostrar Pagos"';
                    }
                    field(ShowCreditMemo; ShowCreditMemo)
                    {
                        ApplicationArea = all;
                        Caption = 'Mostrar Abonos', comment = 'ESP="Mostrar Abonos"';
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
        CESCESalesCaption = 'Ventas CESCE', Comment = 'CESCE Sales';
        SupplementHeading = 'Suplemento', Comment = 'Supplement';
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
    }

    trigger OnPreReport();
    var
        FormatDocument: Codeunit "Format Document";
    begin
        GLEntryFilterTxt := FormatDocument.GetRecordFiltersWithCaptions("G/L Entry");
        TempAgingBandBuffer.DeleteAll();
    end;

    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        HistAsegurora: Record "STH Hist. Aseguradora";
        Customer: Record Customer;
        PaymentMethod: Record "Payment Method";
        CountryRegion: Record "Country/Region";
        //Para guardar los Document no q ya se han mostrado en la factura
        TempAgingBandBuffer: Record "Aging Band Buffer" temporary;
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
        estadoDocCaption_Lbl: Label 'Document Status', Comment = 'ESP="Estado Documento"';
        ShowPayments: Boolean;
        ShowCreditMemo: Boolean;

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
