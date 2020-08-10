report 50117 "FacturaBrasilMaquinas"
{
    RDLCLayout = './src/report/Rep50117.FacturaBrasilMaquinas.rdlc';
    Caption = 'Factura Brasil Máquinas', Comment = 'Brazil Machines Invoice';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Hist. factura venta', Comment = 'Posted Sales Invoice';

            column(CompanyInfoBankCountNo; RecBankPrevisto.IBAN)
            {
            }
            column(No_SalesInvHdr; "No.")
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(CodDivisa; CodDivisa)
            {
            }
            column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
            {
            }
            column(ShpMethodDescCaption; ShpMethodDescCaptionLbl)
            {
            }
            column(PmtMethodDescCaption; PmtMethodDescCaptionLbl)
            {
            }
            column(DocDateCaption; DocDateCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
            {
            }

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(SalesInvoiceHeaderPaymentMethodCode; "Sales Invoice Header"."Payment Method Code")
                    {
                    }
                    column(SalesInvoiceHeaderBillToCustomerNo; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(DocumentCaptionCopyText; StrSubstNo(DocumentCaption(), CopyText))
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(SelltoCustNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer No.")
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_SalesInvHdr; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(PostingDate_SalesInvHdr; Format("Sales Invoice Header"."Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesInvHeader; "Sales Invoice Header"."VAT Registration No.")
                    {
                    }
                    column(DueDate_SalesInvHeader; Format("Sales Invoice Header"."Due Date", 0, 4))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No_SalesInvoiceHeader1; "Sales Invoice Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_SalesInvHdr; "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(OrderNoText; OrderNoText)
                    {
                    }
                    column(OrderNo_SalesInvHeader; "Sales Invoice Header"."Order No.")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(DocDate_SalesInvoiceHdr; Format("Sales Invoice Header"."Document Date", 0, 4))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdr; "Sales Invoice Header"."Prices Including VAT")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo; Format("Sales Invoice Header"."Prices Including VAT"))
                    {
                    }
                    column(PageCaption; PageCaptionCapLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption; BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption; BankAccNoCaptionLbl)
                    {
                    }
                    column(DueDateCaption; DueDateCaptionLbl)
                    {
                    }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl)
                    {
                    }
                    column(PostingDateCaption; PostingDateCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    column(CACCaption; CACCaptionLbl)
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr3; ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; ShipToAddr[8])
                    {
                    }
                    column(CustomerTelefono; Customer."Phone No.")
                    {
                    }
                    column(CustomerFax; Customer."Fax No.")
                    {
                    }
                    column(CustomerCIFDNI; Customer."VAT Registration No.")
                    {
                    }
                    column(TransportistaRecordNombre; TransportistaRecord.Name)
                    {
                    }
                    column(Bank_IBAN; BankAccountRecord.IBAN)
                    {
                    }
                    column(Bank_Swift; BankAccountRecord."SWIFT Code")
                    {
                    }
                    column(Bank_Pais; BankAccountRecord."Country/Region Code")
                    {
                    }
                    column(Bank_NombreBanco; BankAccountRecord.Name)
                    {
                    }
                    column(Bank_Cuenta; BankAccountRecord."CCC Bank No.")
                    {
                    }
                    column(Bank_Sucursal; BankAccountRecord."CCC Bank Branch No.")
                    {
                    }
                    column(BankAccountRecordDireccion; BankAccountRecord.Address)
                    {
                    }
                    column(BankAccountRecordPostCode; BankAccountRecord."Post Code")
                    {
                    }
                    column(BankAccountRecordCity; BankAccountRecord.City)
                    {
                    }
                    column(BankAccountRecordCountry; BankAccountRecord."Country/Region Code")
                    {
                    }
                    column(CustomerCountry; Customer."Country/Region Code")
                    {
                    }
                    column(FechaVencimiento1; FechaVencimiento[1])
                    {
                    }
                    column(FechaVencimiento2; FechaVencimiento[2])
                    {
                    }
                    column(FechaVencimiento3; FechaVencimiento[3])
                    {
                    }
                    column(ImporteVencimiento1; ImporteVencimiento[1])
                    {
                    }
                    column(ImporteVencimiento2; ImporteVencimiento[2])
                    {
                    }
                    column(ImporteVencimiento3; ImporteVencimiento[3])
                    {
                    }
                    column(NumBultos; CabeceraAlbaranRecord.NumBultos_btc)
                    {
                    }
                    column(PesoBruto; CabeceraAlbaranRecord.Peso_btc)
                    {
                    }

                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                        column(DimText; DimText)
                        {
                        }
                        column(Number_DimensionLoop1; Number)
                        {
                        }
                        column(HdrDimsCaption; HdrDimsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet() then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break();
                        end;
                    }

                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = sorting("Document No.", "Line No.");

                        column(EsCargo; EsCargo)
                        {
                        }
                        column(EsEmbalaje; EsEmbalaje)
                        {
                        }
                        column(CargosBase; CargosBase)
                        {
                        }
                        column(CargosIVA; CargosIVA)
                        {
                        }
                        column(CargosRE; CargosRE)
                        {
                        }
                        column(CargosREPer; CargosREPer)
                        {
                        }
                        column(CargosTipoIVA; CargosTipoIVA)
                        {
                        }
                        column(GetCarteraInvoice; GetCarteraInvoice())
                        {
                        }
                        column(LineAmt_SalesInvoiceLine; "Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Description_SalesInvLine; Description)
                        {
                        }
                        column(No_SalesInvoiceLine; "No.")
                        {
                        }
                        column(Quantity_SalesInvoiceLine; Quantity)
                        {
                        }
                        column(UOM_SalesInvoiceLine; "Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesInvLine; "Unit Price")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesInvoiceLine; "Line Discount %")
                        {
                        }
                        column(VATIdent_SalesInvLine; "VAT Identifier")
                        {
                        }
                        column(PostedShipmentDate; Format("Shipment Date"))
                        {
                        }
                        column(Type_SalesInvoiceLine; Type)
                        {
                        }
                        column(InvDiscountAmount; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmount; TotalAmount)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalGivenAmount; TotalGivenAmount)
                        {
                        }
                        column(Shipment_No_; "Shipment No.")
                        {
                        }
                        column(SalesInvoiceLineAmount; Amount)
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(AmountIncludingVATAmount; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Amount_SalesInvoiceLineIncludingVAT; "Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountVAT; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseDisc_SalesInvHdr; "Sales Invoice Header"."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscountOnVAT; TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATCalcType; VATAmountLine."VAT Calculation Type")
                        {
                        }
                        column(LineNo_SalesInvoiceLine; "Line No.")
                        {
                        }
                        column(PmtinvfromdebtpaidtoFactCompCaption; PmtinvfromdebtpaidtoFactCompCaptionLbl)
                        {
                        }
                        column(PostedShpDateCaption; PostedShpDateCaptionLbl)
                        {
                        }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        {
                        }
                        column(PmtDiscGivenAmtCaption; PmtDiscGivenAmtCaptionLbl)
                        {
                        }
                        column(PmtDiscVATCaption; PmtDiscVATCaptionLbl)
                        {
                        }
                        column(Description_SalesInvLineCaption; FieldCaption(Description))
                        {
                        }
                        column(No_SalesInvoiceLineCaption; FieldCaption("No."))
                        {
                        }
                        column(Quantity_SalesInvoiceLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesInvoiceLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdent_SalesInvLineCaption; FieldCaption("VAT Identifier"))
                        {
                        }
                        column(IsLineWithTotals; LineNoWithTotal = "Line No.")
                        {
                        }
                        column(CabeceraAlbaranRecordFecha; Format(CabeceraAlbaranRecord."Document Date"))
                        {
                        }
                        column(TipoLinea; FORMAT("Sales Invoice Line".Type, 0, 2))
                        {
                        }

                        dataitem("Sales Shipment Buffer"; "Integer")
                        {
                            DataItemTableView = sorting(Number);

                            column(PostingDate_SalesShipmentBuffer; Format(SalesShipmentBuffer."Posting Date"))
                            {
                            }
                            column(Quantity_SalesShipmentBuffer; SalesShipmentBuffer.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(ShpCaption; ShpCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then
                                    SalesShipmentBuffer.Find('-')
                                else
                                    SalesShipmentBuffer.Next();
                            end;

                            trigger OnPreDataItem()
                            begin
                                SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                                SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");

                                SetRange(Number, 1, SalesShipmentBuffer.Count());
                            end;
                        }

                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimsCaption; LineDimsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break();

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                            end;
                        }

                        dataitem(AsmLoop; "Integer")
                        {
                            DataItemTableView = sorting(Number);

                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                            }
                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(TempPostedAsmLineVariantCode; BlanksForIndent() + TempPostedAsmLine."Variant Code")
                            {
                            }
                            column(TempPostedAsmLineDescrip; BlanksForIndent() + TempPostedAsmLine.Description)
                            {
                            }
                            column(TempPostedAsmLineNo; BlanksForIndent() + TempPostedAsmLine."No.")
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if Number = 1 then
                                    TempPostedAsmLine.FindSet()
                                else
                                    TempPostedAsmLine.Next();

                                if ItemTranslation.Get(TempPostedAsmLine."No.",
                                     TempPostedAsmLine."Variant Code",
                                     "Sales Invoice Header"."Language Code")
                                then
                                    TempPostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                Clear(TempPostedAsmLine);
                                if not DisplayAssemblyInformation then
                                    CurrReport.Break();
                                CollectAsmInformation();
                                Clear(TempPostedAsmLine);
                                SetRange(Number, 1, TempPostedAsmLine.Count());
                            end;
                        }

                        dataitem(Lotes; Integer)
                        {
                            DataItemTableView = sorting(number);

                            column(NoLote_RecMemLotes; RecMemLotes.NoLote)
                            {
                            }
                            column(NoSerie_RecMemLotes; RecMemLotes.NoSerie)
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                RecMemLotes.Reset();
                                SetRange(Number, 1, RecMemLotes.Count());
                            end;

                            trigger OnAfterGetRecord()
                            begin
                                if (Number = 1) then begin
                                    if RecMemLotes.FindSet() = false then
                                        CurrReport.Break();
                                end else
                                    if RecMemLotes.Next() = 0 then
                                        CurrReport.Break();
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            InitializeShipmentBuffer();
                            if (Type = Type::"G/L Account") and (not ShowInternalInfo) then
                                "No." := '';
                            if VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then begin
                                VATAmountLine.Init();
                                VATAmountLine."VAT Identifier" := "VAT Identifier";
                                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                VATAmountLine."Tax Group Code" := "Tax Group Code";
                                VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                                VATAmountLine."EC %" := VATPostingSetup."EC %";
                                VATAmountLine."VAT Base" := Amount;
                                VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                                VATAmountLine."Line Amount" := "Line Amount";
                                VATAmountLine."Pmt. Discount Amount" := "Pmt. Discount Amount";
                                if "Allow Invoice Disc." then
                                    VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                VATAmountLine.SetCurrencyCode("Sales Invoice Header"."Currency Code");
                                VATAmountLine."VAT Difference" := "VAT Difference";
                                VATAmountLine."EC Difference" := "EC Difference";
                                if "Sales Invoice Header"."Prices Including VAT" then
                                    VATAmountLine."Prices Including VAT" := true;
                                VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                                VATAmountLine.InsertLine();
                                CalcVATAmountLineLCY(
                                  "Sales Invoice Header", VATAmountLine, TempVATAmountLineLCY,
                                  VATBaseRemainderAfterRoundingLCY, AmtInclVATRemainderAfterRoundingLCY);

                                TotalSubTotal += "Line Amount";
                                TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                                TotalAmount += Amount;
                                TotalAmountVAT += "Amount Including VAT" - Amount;
                                TotalAmountInclVAT += "Amount Including VAT";
                                TotalGivenAmount -= "Pmt. Discount Amount";
                                TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Pmt. Discount Amount" - "Amount Including VAT");

                                If CabeceraAlbaranRecord.get("Shipment No.") then;

                                //Albaranes por línea
                                Clear(RecTempLineaAlbaran);
                                RecTempLineaAlbaran.DeleteAll();
                                "Sales Invoice Line".GetSalesShptLines(RecTempLineaAlbaran);
                                EsCargo := false;
                                EsEmbalaje := false;
                                Clear(CargosBase);
                                Clear(CargosIVA);
                                Clear(CargosTipoIVA);
                                Clear(CargosRE);
                                Clear(CargosREPer);

                                if "Sales Invoice Line"."Item Category Code" = 'EMBALAJES' then
                                    EsEmbalaje := true;
                                //Sacar datos para lineas tipo cargo.
                                If Type = Type::"G/L Account" then
                                    if not RecCuenta.Get("Sales Invoice Line"."No.") then
                                        Clear(RecCuenta);
                                if RecCuenta."Ignore Discounts" = true then
                                    EsCargo := true;
                                if EsCargo then begin
                                    CargosBase := Amount;
                                    CargosTipoIVA := "VAT %";
                                    CargosREPer := "EC %";
                                    If CargosIvaPorcent = 0 then
                                        CargosIVAPorcent := "VAT %";
                                    If CargosREPer = 0 then
                                        CargosREPer := "EC %";
                                    CalculoIVAREPortes();
                                end;
                            end;

                            //Calculo lotes
                            RecMemLotes.Reset();
                            RecMemLotes.DeleteAll();
                            RetrieveLotAndExpFromPostedInv("Sales Invoice Line".RowID1(), RecMemLotes);
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATAmountLine.DeleteAll();
                            TempVATAmountLineLCY.DeleteAll();
                            VATBaseRemainderAfterRoundingLCY := 0;
                            AmtInclVATRemainderAfterRoundingLCY := 0;
                            SalesShipmentBuffer.Reset();
                            SalesShipmentBuffer.DeleteAll();
                            FirstValueEntryNo := 0;
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) and (Amount = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            LineNoWithTotal := "Line No.";
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }

                    dataitem(LineasAlbaran; Integer)
                    {
                        DataItemTableView = sorting(number);

                        column(NoAlbaran_RecTempLineaAlbaran; RecTempLineaAlbaran."No.")
                        {
                        }
                        column(FechaAlbaran_RecTempLineaAlbaran; format(RecTempLineaAlbaran."Posting Date"))
                        {
                        }
                        column(NoLinea_RecTempLineaAlbaran; RecTempLineaAlbaran."Line No.")
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            RecTempLineaAlbaran.Reset();
                            SetRange(Number, 1, RecTempLineaAlbaran.Count());
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            if number = 1 then
                                RecTempLineaAlbaran.FindSet()
                            else
                                RecTempLineaAlbaran.Next();
                        end;
                    }

                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(VATAmountLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Invoice Line".GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscountAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineECAmount; VATAmountLine."EC Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLineEC; VATAmountLine."EC %")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATCaption; VATAmtLineVATCaptionLbl)
                        {
                        }
                        column(VATECBaseCaption; VATECBaseCaptionLbl)
                        {
                        }
                        column(VATAmountCaption; VATAmountCaptionLbl)
                        {
                        }
                        column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
                        {
                        }
                        column(VATIdentCaption; VATIdentCaptionLbl)
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmtCaption1; LineAmtCaption1Lbl)
                        {
                        }
                        column(InvPmtDiscCaption; InvPmtDiscCaptionLbl)
                        {
                        }
                        column(ECAmtCaption; ECAmtCaptionLbl)
                        {
                        }
                        column(ECCaption; ECCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            if VATAmountLine."VAT Amount" = 0 then
                                VATAmountLine."VAT %" := 0;
                            if VATAmountLine."EC Amount" = 0 then
                                VATAmountLine."EC %" := 0;

                            //Campos Importes Pie
                            if (nLineaIVAActual <= ARRAYLEN(nBaseActual)) then begin
                                nBaseActual[nLineaIVAActual] := VATAmountLine."VAT Base";
                                nImporteIVA[nLineaIVAActual] := VATAmountLine."VAT Amount";
                                nDescuento[nLineaIVAActual] := VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount";
                                if VATAmountLine."EC Amount" = 0 then begin
                                    nPorcentajeRE[nLineaIVAActual] := 0;
                                    nRE[nLineaIVAActual] := 0;
                                end
                                else begin
                                    nPorcentajeRE[nLineaIVAActual] := VATAmountLine."EC %";
                                    nRE[nLineaIVAActual] := VATAmountLine."EC Amount";
                                end;

                                if VATAmountLine."VAT Amount" = 0 then
                                    nPorcentajeIVA[nLineaIVAActual] := 0
                                else
                                    nPorcentajeIVA[nLineaIVAActual] := VATAmountLine."VAT %";
                            end;
                            nLineaIVAActual += 1;
                            //FIN BITEC1                     
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, VATAmountLine.Count());
                            nLineaIVAActual := 1;
                            Clear(nImporteIVA);
                            Clear(nPorcentajeIVA);
                            Clear(nBaseActual);
                            Clear(nDescuento);
                        end;
                    }

                    dataitem(VATClauseEntryCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(VATClauseVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATClauseCode; VATAmountLine."VAT Clause Code")
                        {
                        }
                        column(VATClauseDescription; VATClause.Description)
                        {
                        }
                        column(VATClauseDescription2; VATClause."Description 2")
                        {
                        }
                        column(VATClauseAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Invoice Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATClausesCaption; VATClausesCapLbl)
                        {
                        }
                        column(VATClauseVATIdentifierCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        column(VATClauseVATAmtCaption; VATAmtCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            if not VATClause.Get(VATAmountLine."VAT Clause Code") then
                                CurrReport.Skip();
                            VATClause.TranslateDescription("Sales Invoice Header"."Language Code");
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(VATClause);
                            SetRange(Number, 1, VATAmountLine.Count());
                        end;
                    }

                    dataitem(VatCounterLCY; "Integer")
                    {
                        DataItemTableView = sorting(Number);

                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT1; TempVATAmountLineLCY."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier1; TempVATAmountLineLCY."VAT Identifier")
                        {
                        }
                        column(VALVATBaseLCYCaption1; VALVATBaseLCYCaption1Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            TempVATAmountLineLCY.GetLine(Number);
                            VALVATBaseLCY := TempVATAmountLineLCY."VAT Base";
                            VALVATAmountLCY := TempVATAmountLineLCY."Amount Including VAT" - TempVATAmountLineLCY."VAT Base";
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Invoice Header"."Currency Code" = '')
                            then
                                CurrReport.Break();

                            SetRange(Number, 1, VATAmountLine.Count());

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007Txt + Text008Txt
                            else
                                VALSpecLCYHeader := Text007Txt + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Invoice Header"."Posting Date", "Sales Invoice Header"."Currency Code", 1);
                            CalculatedExchRate := Round(1 / "Sales Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.00001);
                            VALExchRate := StrSubstNo(Text009Txt, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }

                    dataitem(PaymentReportingArgument; "Payment Reporting Argument")
                    {
                        DataItemTableView = sorting(Key);
                        UseTemporary = true;

                        column(PaymentServiceLogo; Logo)
                        {
                        }
                        column(PaymentServiceURLText; "URL Caption")
                        {
                        }
                        column(PaymentServiceURL; GetTargetURL())
                        {
                        }

                        trigger OnPreDataItem()
                        var
                            PaymentServiceSetup: Record "Payment Service Setup";
                        begin
                            PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument, "Sales Invoice Header");
                            if IsEmpty() then
                                CurrReport.Break();
                        end;
                    }

                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                    }

                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));

                        column(SelltoCustNo_SalesInvHdr; "Sales Invoice Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_SalesInvHdrCaption; "Sales Invoice Header".FieldCaption("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                                CurrReport.Break();
                        end;
                    }

                    dataitem(LineFee; "Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1 ..));

                        column(LineFeeCaptionLbl; TempLineFeeNoteOnReportHist.ReportText)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if not DisplayAdditionalFeeNote then
                                CurrReport.Break();

                            if Number = 1 then begin
                                if not TempLineFeeNoteOnReportHist.FindSet() then
                                    CurrReport.Break()
                            end else
                                if TempLineFeeNoteOnReportHist.Next() = 0 then
                                    CurrReport.Break();
                        end;
                    }

                    dataitem(DesglosesIVA; "Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));

                        column(nBaseActual1; nBaseActual[1])
                        {
                        }
                        column(nBaseActual2; nBaseActual[2])
                        {
                        }
                        column(nBaseActual3; nBaseActual[3])
                        {
                        }
                        column(nImporteIVA1; nImporteIVA[1])
                        {
                        }
                        column(nImporteIVA2; nImporteIVA[2])
                        {
                        }
                        column(nImporteIVA3; nImporteIVA[3])
                        {
                        }
                        column(nPorcentajeIVA1; nPorcentajeIVA[1])
                        {
                        }
                        column(nPorcentajeIVA2; nPorcentajeIVA[2])
                        {
                        }
                        column(nPorcentajeIVA3; nPorcentajeIVA[3])
                        {
                        }
                        column(nRE1; nRE[1])
                        {
                        }
                        column(nRE2; nRE[2])
                        {
                        }
                        column(nRE3; nRE[3])
                        {
                        }
                        column(nPorcentajeRE1; nPorcentajeRE[1])
                        {
                        }
                        column(nPorcentajeRE2; nPorcentajeRE[2])
                        {
                        }
                        column(nPorcentajeRE3; nPorcentajeRE[3])
                        {
                        }
                        column(nDescuento1; nDescuento[1])
                        {
                        }
                        column(nDescuento2; nDescuento[2])
                        {
                        }
                        column(nDescuento3; nDescuento[3])
                        {
                        }
                        column(CargosIVAPorcent; CargosIVAPorcent)
                        {
                        }
                        column(CargosRePorcent; CargosRePorcent)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalGivenAmount := 0;
                    TotalPaymentDiscountOnVAT := 0;
                end;

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode() then
                        Codeunit.Run(Codeunit::"Sales Inv.-Printed", "Sales Invoice Header");
                end;

                trigger OnPreDataItem()
                begin
                    If (Reimpresion = true) then
                        NoOfCopies := 0;
                    NoOfLoops := Abs(NoOfCopies) + Cust."Invoice Copies" + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                Handled: Boolean;
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Sales Invoice Header");
                FormatDocumentFields("Sales Invoice Header");

                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                Customer.Get("Sell-to Customer No.");
                if BankAccountRecord.Get('CUENTA BANC. EMPRESA') then;
                GetLineFeeNoteOnReportHist("No.");

                OnAfterGetRecordSalesInvoiceHeader("Sales Invoice Header");
                OnGetReferenceText("Sales Invoice Header", ReferenceText, Handled);

                MovsCliente.SETRANGE("Document No.", "No.");
                MovsCliente.SETFILTER("Document Type", '%1', MovsCliente."Document Type"::Bill);
                MovsCliente.SETRANGE("Customer No.", "Bill-to Customer No.");

                MovsCliente.SETRANGE("Posting Date", "Posting Date");
                if not MovsCliente.FINDSET() then begin
                    MovsCliente.SETFILTER("Document Type", '%1', MovsCliente."Document Type"::Invoice);
                    if not MovsCliente.FINDSET() then
                        exit;
                end;
                intContador := 1;
                repeat
                    FechaVencimiento[intContador] := MovsCliente."Due Date";
                    MovsCliente.CALCFIELDS("Amount (LCY)");
                    ImporteVencimiento[intContador] := MovsCliente."Amount (LCY)";
                    intContador := intContador + 1;
                until MovsCliente.next() = 0;

            end;

            trigger OnPostDataItem()
            begin
                OnAfterPostDataItem("Sales Invoice Header");
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
                group(Options)
                {
                    Caption = 'Opciones', Comment = 'Options';

                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Nº de copias', Comment = 'No. of Copies';
                        ToolTip = 'Especifica cuantas copias de documento a imprimir.', Comment = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mostrar información interna', Comment = 'Show Internal Information';
                        Tooltip = 'Especifica si se quiere que el informe impreso muestre información solo de uso interno', Comment = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Interacción con el Registro', Comment = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        Tooltip = 'Especifica que las interacciones con el contacto son registradas.', Comment = 'Specifies that interactions with the contact are logged.';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Mostrar componentes de ensamblado', Comment = 'Show Assembly Components';
                        Tooltip = 'Especifica si se quiere que el informe incluya información sobre componentes que fueron usados pedidos de ensamblado vinculados que suministraron el/los productos vendidos.', Comment = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mostrar nota de tarifa adicional', Comment = 'Show Additional Fee Note';
                        Tooltip = 'Especifica que cualquier nota sobre tarifas adicionales son incluidas en el documento.', Comment = 'Specifies that any notes about additional fees are included on the document.';
                    }
                    field(Reimpresion; Reimpresion)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Volver a Imprimir', Comment = 'Reprint';
                        ToolTip = 'Marca la opción de volver a imprimir una copia.', Comment = 'Marks the option to reprint a copy.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
            NoOfCopies := 1;
        end;
    }

    labels
    {
        FacturaTitulo = 'FACTURA', Comment = 'INVOICE';
        FacturaSubtituloIzq = 'PR-GESTION DE LOS PEDIDOS DEL CLIENTE', Comment = 'PR-CUSTOMER ORDER MANAGEMENT';
        FacturaSubtituloDch = 'FO.01.OFN/A9.11', Comment = 'FO.01.OFN/A9.11';
        FechaEncabezado = 'Fecha', Comment = 'Date';
        CondicionEntregaEncabezado = 'Condición de entrega', Comment = 'Terms of delivery';
        FormaPagoEncabezado = 'Forma de pago', Comment = 'Method of payment';
        DestinoFinalEncabezado = 'Destino final', Comment = 'Final destination';
        PaisFabricacionEncabezado = 'País de fabricación', Comment = 'Country of manufacture';
        NumEncabezado = 'Núm.', Comment = 'No.';
        MedioTransporteEncabezado = 'Medio de transporte', Comment = 'Conveyance';
        DivisaEncabezado = 'Divisa', Comment = 'Currency';
        NumPaginaEnvabezado = 'Nº Hoja', Comment = 'Page No.';
        CODEtiqueta = 'COD:', Comment = 'COD:';
        TelFaxEtiqueta = 'Telf./Fax:', Comment = 'Phone/Fax:';
        BultosEncabezado = 'Bultos', Comment = 'Packages';
        PesoBrutoEncabezado = 'Peso Bruto (kg.)', Comment = 'GrossWeight(kg.)';
        VolumenEncabezado = 'Volumen (m3)', Comment = 'Volume (m3)';
        ArticuloEncabezadoColumna = 'Artículo', Comment = 'Item';
        DescripcionEncabezadoColumna = 'Descripción', Comment = 'Description';
        CantidadEncabezadoColumna = 'Cantidad', Comment = 'Quantity';
        PrecioUnitarioEncabezadoColumna = 'Precio U.', Comment = 'Unit Price';
        ImporteEncabezadoColumna = 'Importe', Comment = 'Amount';
        EmpresasFirmantesEncabezado = 'Las empresas abajo firmantes están relacionadas en este negocio, directamente, sin agentes o representantes:', Comment = 'The undersigned companies are directly related to this business, without agents or representatives:';
        EmbarqueMaquinasTexto = 'Embarque de las máquinas em até 20 días', Comment = 'Shipment of the machines in 20 days';
        ExportadorFabricanteEtiqueta = 'Exportador y fabricante:', Comment = 'Exporter and manufacturer:';
        PaisOrigenEtiqueta = 'PAIS ORIGEN:', Comment = 'SOURCE COUNTRY:';
        PaisProcedenciaEtiqueta = 'PAIS PROCEDENCIA:', Comment = 'ORIGIN COUNTRY:';
        ImportadorRepresentanteDistribuidorEtiqueta = 'Importador, Representante y Distribuidor:', Comment = 'Importer, Representative and Distributor:';
        BancoEtiqueta = 'BANCO:', Comment = 'BANK:';
        DireccionBancoEtiqueta = 'DIRECCIÓN:', Comment = 'ADDRESS:';
        IBANEtiqueta = 'IBAN', Comment = 'IBAN';
        BICCodeEtiqueta = 'BIC CODE:', Comment = 'BIC CODE:';
        NCMEtiqueta = 'NCM:', Comment = 'NCM:';
        PaisDestinoEtiqueta = 'PAIS DE DESTINO:', Comment = 'DESTINATION COUNTRY:';
        PuertoEmbarqueEtiqueta = 'PUERTO DE EMBARQUE', Comment = 'SHIPMENT PORT:';
        InfoExportadorTexto = 'El exportador de los productos incluidos en el presente documento (autorización aduanera nº ES/46/0128/11) declara que, salvo indicación en contrario, estos productos gozan de origen preferencial Union Europea.', Comment = 'The exporter of the products included in this document (customs authorization nº ES / 46/0128/11) declares that, unless otherwise indicated, these products enjoy preferential origin European Union.';
        ContenedorEtiqueta = 'Contenedor:', Comment = 'Container:';
        PrecintoEtiqueta = 'Precinto:', Comment = 'Seal:';
        ImporteBrutoEncabezadoColumna = 'Importe Bruto', Comment = 'Gross Amount';
        PortesEncabezadoColumna = 'Portes', Comment = 'Postage';
        ImporteSubTotalEncabezadoColumna = 'SubTotal', Comment = 'SubTotal';
        ImporteTotalEncabezadoColumna = 'TOTAL', Comment = 'TOTAL';
        FacturaPie = 'Según lo Dispuesto por el Reglamento (UE) 2016/769 del Parlamento Europeo y del Consejo de 27 de abril de 2016 relativo a la protección de las personas físicas, le informamos que sus datos serán incorporados al sistema de tratamiento titularidad de ZUMMO INNOVACIONES MECÁNICAS, S.A. - con la finalidad de poder remitirle la correspondiente factura. Podrá ejercer los derechos de acceso, rectificación, limitación de tratamiento, supresión, portabilidad y oposición/revocación, en los términos que establece la normativa vigente en materia de protección de datos, dirigiendo su petición a la dirección postal arriba indicada, asimismo, podrá dirigirse a la Autoridad de Control competente para presentar la reclamación que considere oportuna.', Comment = 'As provided by Regulation (EU) 2016/769 of the European Parliament and of the Council of April 27, 2016 regarding the protection of natural persons, we inform you that your data will be incorporated into the treatment system owned by ZUMMO MECHANICAL INNOVATIONS, SA - in order to be able to send you the corresponding invoice. You may exercise the rights of access, rectification, limitation of treatment, deletion, portability and opposition / revocation, in the terms established by current regulations on data protection, by sending your request to the postal address indicated above, you can also address to the competent Control Authority to submit the claim it deems appropriate.';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        SalesSetup.Get();
        CompanyInfo.Get();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        CompanyInfo1.Get();
        CompanyInfo1.CalcFields(Picture);
        OnAfterInitReport();
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
            if "Sales Invoice Header".FindSet() then
                repeat
                    if "Sales Invoice Header"."Bill-to Contact No." <> '' then
                        SegManagement.LogDocument(
                          SegManagement.SalesInvoiceInterDocType(), "Sales Invoice Header"."No.", 0, 0, DATABASE::Contact,
                          "Sales Invoice Header"."Bill-to Contact No.", "Sales Invoice Header"."Salesperson Code",
                          "Sales Invoice Header"."Campaign No.", "Sales Invoice Header"."Posting Description", '')
                    else
                        SegManagement.LogDocument(
                          SegManagement.SalesInvoiceInterDocType(), "Sales Invoice Header"."No.", 0, 0, DATABASE::Customer,
                          "Sales Invoice Header"."Bill-to Customer No.", "Sales Invoice Header"."Salesperson Code",
                          "Sales Invoice Header"."Campaign No.", "Sales Invoice Header"."Posting Description", '');
                until "Sales Invoice Header".Next() = 0;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage() then
            InitLogInteraction();
    end;

    var
        GLSetup: Record "General Ledger Setup";
        BankAccountRecord: Record "Bank Account";
        CabeceraAlbaranRecord: Record "Sales Shipment Header";
        MovsCliente: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        TransportistaRecord: Record "Shipping Agent";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        Cust: Record Customer;
        VATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineLCY: Record "VAT Amount Line" temporary;
        RecTempLineaAlbaran: Record "Sales Shipment Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        TempPostedAsmLine: Record "Posted Assembly Line" temporary;
        VATClause: Record "VAT Clause";
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        VATPostingSetup: Record "VAT Posting Setup";
        PaymentMethod: Record "Payment Method";
        RecBankPrevisto: Record "Bank Account";
        RecMemLotes: Record MemEstadistica_btc temporary;
        RecCuenta: Record "G/L Account";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[50];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        CodDivisa: Code[20];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        Reimpresion: Boolean;
        intContador: Integer;
        FechaVencimiento: array[3] of Date;
        ImporteVencimiento: array[3] of Decimal;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[75];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007Txt: Label 'VAT Amount Specification in ';
        Text008Txt: Label 'Local Currency';
        VALExchRate: Text[50];
        Text009Txt: Label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010Txt: Label 'Sales - Prepayment Invoice %1';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        nImporteIVA: array[3] of Decimal;
        nPorcentajeIVA: array[3] of Decimal;
        nBaseActual: array[3] of Decimal;
        nRE: array[3] of Decimal;
        nPorcentajeRE: array[3] of Decimal;
        nDescuento: array[3] of Decimal;
        nLineaIVAActual: Integer;
        TotalGivenAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        DueDateCaptionLbl: Label 'Due Date';
        InvoiceNoCaptionLbl: Label 'Invoice No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        HdrDimsCaptionLbl: Label 'Header Dimensions';
        PmtinvfromdebtpaidtoFactCompCaptionLbl: Label 'The payment of this invoice, in order to be released from the debt, has to be paid to the Factoring Company.';
        VATClausesCapLbl: Label 'VAT Clause';
        PostedShpDateCaptionLbl: Label 'Posted Shipment Date';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        PmtDiscGivenAmtCaptionLbl: Label 'Payment Disc Given Amount';
        PmtDiscVATCaptionLbl: Label 'Payment Discount on VAT';
        ShpCaptionLbl: Label 'Shipment';
        LineDimsCaptionLbl: Label 'Line Dimensions';
        VATAmtLineVATCaptionLbl: Label 'VAT %';
        VATECBaseCaptionLbl: Label 'VAT+EC Base';
        VATAmountCaptionLbl: Label 'VAT Amount';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
        VATIdentCaptionLbl: Label 'VAT Identifier';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        LineAmtCaption1Lbl: Label 'Line Amount';
        InvPmtDiscCaptionLbl: Label 'Invoice and Payment Discounts';
        ECAmtCaptionLbl: Label 'EC Amount';
        ECCaptionLbl: Label 'EC %';
        VALVATBaseLCYCaption1Lbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        ShpMethodDescCaptionLbl: Label 'Shipment Method';
        PmtMethodDescCaptionLbl: Label 'Payment Method';
        DocDateCaptionLbl: Label 'Document Date';
        HomePageCaptionLbl: Label 'Home Page';
        EmailCaptionLbl: Label 'Email';
        CACCaptionLbl: Text;
        CACTxt: Label 'Régimen especial del criterio de caja';
        Text004Txt: Label 'Sales - Invoice %1', Comment = '%1 = Document No.';
        PageCaptionCapLbl: Label 'Page %1 of %2';
        DisplayAdditionalFeeNote: Boolean;
        LineNoWithTotal: Integer;
        VATBaseRemainderAfterRoundingLCY: Decimal;
        AmtInclVATRemainderAfterRoundingLCY: Decimal;
        CargosBase: Decimal;
        CargosIVA: Decimal;
        CargosTipoIVA: Decimal;
        CargosRE: Decimal;
        CargosREPer: Decimal;
        CargosRePorcent: Decimal;
        CargosIVAPorcent: Decimal;
        EsCargo: Boolean;
        EsEmbalaje: Boolean;

    [Scope('Personalization')]
    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure InitializeShipmentBuffer()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        TempSalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
    begin
        NextEntryNo := 1;
        if "Sales Invoice Line"."Shipment No." <> '' then
            if SalesShipmentHeader.Get("Sales Invoice Line"."Shipment No.") then
                exit;

        if "Sales Invoice Header"."Order No." = '' then
            exit;

        case "Sales Invoice Line".Type of
            "Sales Invoice Line".Type::Item:
                GenerateBufferFromValueEntry("Sales Invoice Line");
            "Sales Invoice Line".Type::"G/L Account", "Sales Invoice Line".Type::Resource,
          "Sales Invoice Line".Type::"Charge (Item)", "Sales Invoice Line".Type::"Fixed Asset":
                GenerateBufferFromShipment("Sales Invoice Line");
        end;

        SalesShipmentBuffer.Reset();
        SalesShipmentBuffer.SetRange("Document No.", "Sales Invoice Line"."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", "Sales Invoice Line"."Line No.");
        if SalesShipmentBuffer.Find('-') then begin
            TempSalesShipmentBuffer := SalesShipmentBuffer;
            if SalesShipmentBuffer.Next() = 0 then begin
                SalesShipmentBuffer.Get(
                  TempSalesShipmentBuffer."Document No.", TempSalesShipmentBuffer."Line No.", TempSalesShipmentBuffer."Entry No.");
                SalesShipmentBuffer.Delete();
                exit;
            end;
            SalesShipmentBuffer.CalcSums(Quantity);
            if SalesShipmentBuffer.Quantity <> "Sales Invoice Line".Quantity then begin
                SalesShipmentBuffer.DeleteAll();
                exit;
            end;
        end;
    end;

    local procedure GenerateBufferFromValueEntry(SalesInvoiceLine2: Record "Sales Invoice Line")
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SetRange("Posting Date", "Sales Invoice Header"."Posting Date");
        ValueEntry.SetRange("Item Charge No.", '');
        ValueEntry.SetFilter("Entry No.", '%1..', FirstValueEntryNo);
        if ValueEntry.Find('-') then
            repeat
                if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    if SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 then
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    else
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesInvoiceLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                end;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            until (ValueEntry.Next() = 0) or (TotalQuantity = 0);
    end;

    local procedure GenerateBufferFromShipment(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine2: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        TotalQuantity: Decimal;
        Quantity: Decimal;
    begin
        TotalQuantity := 0;
        SalesInvoiceHeader.SetCurrentKey("Order No.");
        SalesInvoiceHeader.SetFilter("No.", '..%1', "Sales Invoice Header"."No.");
        SalesInvoiceHeader.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        if SalesInvoiceHeader.Find('-') then
            repeat
                SalesInvoiceLine2.SetRange("Document No.", SalesInvoiceHeader."No.");
                SalesInvoiceLine2.SetRange("Line No.", SalesInvoiceLine."Line No.");
                SalesInvoiceLine2.SetRange(Type, SalesInvoiceLine.Type);
                SalesInvoiceLine2.SetRange("No.", SalesInvoiceLine."No.");
                SalesInvoiceLine2.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
                if SalesInvoiceLine2.Find('-') then
                    repeat
                        TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
                    until SalesInvoiceLine2.Next() = 0;
            until SalesInvoiceHeader.Next() = 0;

        SalesShipmentLine.SetCurrentKey("Order No.", "Order Line No.");
        SalesShipmentLine.SetRange("Order No.", "Sales Invoice Header"."Order No.");
        SalesShipmentLine.SetRange("Order Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentLine.SetRange(Type, SalesInvoiceLine.Type);
        SalesShipmentLine.SetRange("No.", SalesInvoiceLine."No.");
        SalesShipmentLine.SetRange("Unit of Measure Code", SalesInvoiceLine."Unit of Measure Code");
        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);

        if SalesShipmentLine.Find('-') then
            repeat
                if "Sales Invoice Header"."Get Shipment Used" then
                    CorrectShipment(SalesShipmentLine);
                if Abs(SalesShipmentLine.Quantity) <= Abs(TotalQuantity - SalesInvoiceLine.Quantity) then
                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
                else begin
                    if Abs(SalesShipmentLine.Quantity) > Abs(TotalQuantity) then
                        SalesShipmentLine.Quantity := TotalQuantity;
                    Quantity :=
                      SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

                    TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
                    SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

                    if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then
                        AddBufferEntry(
                          SalesInvoiceLine,
                          Quantity,
                          SalesShipmentHeader."Posting Date");
                end;
            until (SalesShipmentLine.Next() = 0) or (TotalQuantity = 0);
    end;

    local procedure CorrectShipment(var SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        SalesInvoiceLine.SetCurrentKey("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SetRange("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SetRange("Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesInvoiceLine.Find('-') then
            repeat
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            until SalesInvoiceLine.Next() = 0;
    end;

    local procedure AddBufferEntry(SalesInvoiceLine: Record "Sales Invoice Line"; QtyOnShipment: Decimal; PostingDate: Date)
    begin
        SalesShipmentBuffer.SetRange("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SetRange("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SetRange("Posting Date", PostingDate);
        if SalesShipmentBuffer.Find('-') then begin
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.Modify();
            exit;
        end;

        with SalesShipmentBuffer do begin
            "Document No." := SalesInvoiceLine."Document No.";
            "Line No." := SalesInvoiceLine."Line No.";
            "Entry No." := NextEntryNo;
            Type := SalesInvoiceLine.Type;
            "No." := SalesInvoiceLine."No.";
            Quantity := QtyOnShipment;
            "Posting Date" := PostingDate;
            Insert();
            NextEntryNo := NextEntryNo + 1
        end;
    end;

    local procedure DocumentCaption(): Text
    var
        DocCaption: Text;
    begin
        OnBeforeGetDocumentCaption("Sales Invoice Header", DocCaption);
        if DocCaption <> '' then
            exit(DocCaption);
        if "Sales Invoice Header"."Prepayment Invoice" then
            exit(Text010Txt);
        exit(Text004Txt);
    end;

    procedure GetCarteraInvoice(): Boolean
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        with CustLedgEntry do begin
            SetCurrentKey("Document No.", "Document Type", "Customer No.");
            SetRange("Document Type", "Document Type"::Invoice);
            SetRange("Document No.", "Sales Invoice Header"."No.");
            SetRange("Customer No.", "Sales Invoice Header"."Bill-to Customer No.");
            SetRange("Posting Date", "Sales Invoice Header"."Posting Date");
            if FindFirst() then
                if "Document Situation" = "Document Situation"::" " then
                    exit(false)
                else
                    exit(true)
            else
                exit(false);
        end;
    end;

    procedure ShowCashAccountingCriteria(SalesInvoiceHeader: Record "Sales Invoice Header"): Text
    var
        VATEntry: Record "VAT Entry";
    begin
        GLSetup.Get();
        if not GLSetup."Unrealized VAT" then
            exit;
        CACCaptionLbl := '';
        VATEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
        VATEntry.SetRange("Document Type", VATEntry."Document Type"::Invoice);
        if VATEntry.FindSet() then
            repeat
                if VATEntry."VAT Cash Regime" then
                    CACCaptionLbl := CACTxt;
            until (VATEntry.Next() = 0) or (CACCaptionLbl <> '');
        exit(CACCaptionLbl);
    end;

    [Scope('Personalization')]
    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure FormatDocumentFields(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        with SalesInvoiceHeader do begin
            FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
            FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");
            if "Payment Method Code" = '' then
                PaymentMethod.Init()
            else
                PaymentMethod.Get("Payment Method Code");

            OrderNoText := FormatDocument.SetText("Order No." <> '', FieldCaption("Order No."));
            ReferenceText := FormatDocument.SetText("Your Reference" <> '', FieldCaption("Your Reference"));
            VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FieldCaption("VAT Registration No."));
        end;
    end;

    local procedure FormatAddressFields(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        FormatAddr.GetCompanyAddr(SalesInvoiceHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesInvBillTo(CustAddr, SalesInvoiceHeader);
        ShowShippingAddr := FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, SalesInvoiceHeader);
    end;

    local procedure CollectAsmInformation()
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        TempPostedAsmLine.DeleteAll();
        if "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item then
            exit;
        with ValueEntry do begin
            SetCurrentKey("Document No.");
            SetRange("Document No.", "Sales Invoice Line"."Document No.");
            SetRange("Document Type", "Document Type"::"Sales Invoice");
            SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
            SetRange(Adjustment, false);
            if not FindSet() then
                exit;
        end;
        repeat
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
                if ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" then begin
                    SalesShipmentLine.Get(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    if SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then begin
                        PostedAsmLine.SetRange("Document No.", PostedAsmHeader."No.");
                        if PostedAsmLine.FindSet() then
                            repeat
                                TreatAsmLineBuffer(PostedAsmLine);
                            until PostedAsmLine.Next() = 0;
                    end;
                end;
        until ValueEntry.Next() = 0;
    end;

    local procedure TreatAsmLineBuffer(PostedAsmLine: Record "Posted Assembly Line")
    begin
        Clear(TempPostedAsmLine);
        TempPostedAsmLine.SetRange(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SetRange("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SetRange("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SetRange(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SetRange("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        if TempPostedAsmLine.FindFirst() then begin
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.Modify();
        end else begin
            Clear(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.Insert();
        end;
    end;

    local procedure GetUOMText(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    [Scope('Personalization')]
    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;

    local procedure GetLineFeeNoteOnReportHist(SalesInvoiceHeaderNo: Code[20])
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll();
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", SalesInvoiceHeaderNo);
        if not CustLedgerEntry.FindFirst() then
            exit;

        if not Customer.Get(CustLedgerEntry."Customer No.") then
            exit;

        LineFeeNoteOnReportHist.SetRange("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SetRange("Language Code", Customer."Language Code");
        if LineFeeNoteOnReportHist.FindSet() then
            repeat
                InsertTempLineFeeNoteOnReportHist(LineFeeNoteOnReportHist, TempLineFeeNoteOnReportHist);
            until LineFeeNoteOnReportHist.Next() = 0
        else begin
            LineFeeNoteOnReportHist.SetRange("Language Code", Language.GetUserLanguage());
            if LineFeeNoteOnReportHist.FindSet() then
                repeat
                    InsertTempLineFeeNoteOnReportHist(LineFeeNoteOnReportHist, TempLineFeeNoteOnReportHist);
                until LineFeeNoteOnReportHist.Next() = 0;
        end;
    end;

    local procedure CalcVATAmountLineLCY(SalesInvoiceHeader: Record "Sales Invoice Header"; TempVATAmountLine2: Record "VAT Amount Line" temporary; var TempVATAmountLineLCY2: Record "VAT Amount Line" temporary; var VATBaseRemainderAfterRoundingLCY2: Decimal; var AmtInclVATRemainderAfterRoundingLCY2: Decimal)
    var
        VATBaseLCY: Decimal;
        AmtInclVATLCY: Decimal;
    begin
        if (not GLSetup."Print VAT specification in LCY") or
           (SalesInvoiceHeader."Currency Code" = '')
        then
            exit;

        TempVATAmountLineLCY2.Init();
        TempVATAmountLineLCY2 := TempVATAmountLine2;
        with SalesInvoiceHeader do begin
            VATBaseLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date", "Currency Code", TempVATAmountLine2."VAT Base", "Currency Factor") +
              VATBaseRemainderAfterRoundingLCY2;
            AmtInclVATLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date", "Currency Code", TempVATAmountLine2."Amount Including VAT", "Currency Factor") +
              AmtInclVATRemainderAfterRoundingLCY2;
        end;
        TempVATAmountLineLCY2."VAT Base" := Round(VATBaseLCY);
        TempVATAmountLineLCY2."Amount Including VAT" := Round(AmtInclVATLCY);
        TempVATAmountLineLCY2.InsertLine();

        VATBaseRemainderAfterRoundingLCY2 := VATBaseLCY - TempVATAmountLineLCY2."VAT Base";
        AmtInclVATRemainderAfterRoundingLCY2 := AmtInclVATLCY - TempVATAmountLineLCY2."Amount Including VAT";
    end;

    local procedure InsertTempLineFeeNoteOnReportHist(var LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist."; var TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary)
    begin
        repeat
            TempLineFeeNoteOnReportHist.Init();
            TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
            TempLineFeeNoteOnReportHist.Insert();
        until TempLineFeeNoteOnReportHist.Next() = 0;
    end;

    [IntegrationEvent(false, TRUE)]
    [Scope('Personalization')]
    procedure OnAfterGetRecordSalesInvoiceHeader(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDocumentCaption(SalesInvoiceHeader: Record "Sales Invoice Header"; var DocCaption: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetReferenceText(SalesInvoiceHeader: Record "Sales Invoice Header"; var ReferenceText: Text[80]; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterInitReport()
    begin
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterPostDataItem(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
    end;

    local procedure CalculoIVAREPortes()
    begin
        if CargosTipoIVA <> 0 then
            CargosIVA := Round(("Sales Invoice Line"."Amount Including VAT" - "Sales Invoice Line".Amount - "Sales Invoice Line"."VAT Difference"
                - "Sales Invoice Line"."EC Difference") / (CargosREPer + CargosTipoIVA) * CargosTipoIVA, GLSetup."Inv. Rounding Precision (LCY)") +
                "Sales Invoice Line"."VAT Difference";
        If CargosREPer <> 0 then
            CargosRE := ROUND(("Sales Invoice Line"."Amount Including VAT" - "Sales Invoice Line".Amount - "Sales Invoice Line"."VAT Difference"
                - "Sales Invoice Line"."EC Difference") / (CargosREPer + CargosTipoIVA) * CargosREPer, GLSetup."Inv. Rounding Precision (LCY)") +
                "Sales Invoice Line"."EC Difference";
    end;

    local procedure RetrieveLotAndExpFromPostedInv(InvoiceRowID: Text[250]; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary)
    var
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        NumMov: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Invoices)
        RecMemEstadisticas.RESET();
        RecMemEstadisticas.DELETEALL();
        NumMov := 1;

        ValueEntryRelation.SETCURRENTKEY("Source RowId");
        ValueEntryRelation.SETRANGE("Source RowId", InvoiceRowID);
        if ValueEntryRelation.FINDFIRST() then
            repeat
                ValueEntry.GET(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
                ItemLedgEntry.CALCFIELDS("Sales Amount (Actual)");
                RecMemEstadisticas.RESET();
                RecMemEstadisticas.SETRANGE(NoLote, ItemLedgEntry."Lot No.");
                if not RecMemEstadisticas.FINDFIRST() then begin
                    RecMemEstadisticas.INIT();
                    RecMemEstadisticas.NoMov := NumMov;
                    NumMov += 1;
                    RecMemEstadisticas.NoLote := ItemLedgEntry."Lot No.";
                    RecMemEstadisticas.NoSerie := ItemLedgEntry."Serial No.";
                    RecMemEstadisticas.Noproducto := ItemLedgEntry."Item No.";
                    RecMemEstadisticas.INSERT();
                end;

            until ValueEntryRelation.next() = 0;
    end;
}
