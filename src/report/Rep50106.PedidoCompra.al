report 50106 "Pedido Compra"
{
    RDLCLayout = './src/report/Rep50106.PedidoCompra.rdl';
    DefaultLayout = RDLC;
    Caption = 'Pedido Compra', Comment = 'Purchase Order';
    PreviewMode = PrintLayout;
    EnableHyperlinks = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Standard Purchase - Order';
            column(PortesLbl; PortesLbl)
            {
            }
            column(Work_Description; workDescription)
            {

            }
            column(portes; '')
            {
            }
            column(AgenciaTransporte; '')
            {
            }
            column(PhoneFax; Vendor."Phone No." + '/' + Vendor."Fax No.")
            {
            }
            column(Comment; '')
            {
            }
            column(MetodoEnvio; "Purchase Header"."Shipment Method Code")
            {
            }
            column(Buy_fromVendorName; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            COLUMN(Currency_Code; Currency_Code) { }
            column(DirectUniCostCaptionLbl; DirectUniCostCaptionLbl)
            {
            }
            column(CompanyAddress1; CompanyAddr[1])
            {
            }
            column(CompanyAddress2; CompanyAddr[2])
            {
            }
            column(CompanyAddress3; CompanyAddr[3])
            {
            }
            column(CompanyAddress4; CompanyAddr[4])
            {
            }
            column(CompanyAddress5; CompanyAddr[5])
            {
            }
            column(CompanyAddress6; CompanyAddr[6])
            {
            }
            column(CompanyHomePage_Lbl; HomePageCaptionLbl)
            {
            }
            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyEmail_Lbl; EmailIDCaptionLbl)
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyPhoneNo_Lbl; CompanyInfoPhoneNoCaptionLbl)
            {
            }
            column(CompanyGiroNo; CompanyInfo."Giro No.")
            {
            }
            column(CompanyGiroNo_Lbl; CompanyInfoGiroNoCaptionLbl)
            {
            }
            column(CompanyBankName; CompanyInfo."Bank Name")
            {
            }
            column(CompanyBankName_Lbl; CompanyInfoBankNameCaptionLbl)
            {
            }
            column(CompanyBankBranchNo; CompanyInfo."Bank Branch No.")
            {
            }
            column(CompanyBankBranchNo_Lbl; CompanyInfo.FieldCaption("Bank Branch No."))
            {
            }
            column(CompanyBankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(CompanyBankAccountNo_Lbl; CompanyInfoBankAccNoCaptionLbl)
            {
            }
            column(CompanyIBAN; CompanyInfo.IBAN)
            {
            }
            column(CompanyIBAN_Lbl; CompanyInfo.FieldCaption(IBAN))
            {
            }
            column(CompanySWIFT; CompanyInfo."SWIFT Code")
            {
            }
            column(CompanySWIFT_Lbl; CompanyInfo.FieldCaption("SWIFT Code"))
            {
            }
            column(CompanyLogoPosition; CompanyLogoPosition)
            {
            }
            column(CompanyRegistrationNumber; CompanyInfo.GetRegistrationNumber)
            {
            }
            column(CompanyRegistrationNumber_Lbl; CompanyInfo.GetRegistrationNumberLbl)
            {
            }
            column(CompanyVATRegNo; CompanyInfo.GetVATRegistrationNumber)
            {
            }
            column(CompanyVATRegNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl)
            {
            }
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber)
            {
            }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl)
            {
            }
            column(CompanyLegalOffice; CompanyInfo.GetLegalOffice)
            {
            }
            column(CompanyLegalOffice_Lbl; CompanyInfo.GetLegalOfficeLbl)
            {
            }
            column(CompanyCustomGiro; CompanyInfo.GetCustomGiro)
            {
            }
            column(CompanyCustomGiro_Lbl; CompanyInfo.GetCustomGiroLbl)
            {
            }
            column(DocType_PurchHeader; "Document Type")
            {
            }
            column(No_PurchHeader; "No.")
            {
            }
            column(DocumentTitle_Lbl; DocumentTitleLbl)
            {
            }
            column(Amount_Lbl; AmountCaptionLbl)
            {
            }
            column(PurchLineInvDiscAmt_Lbl; PurchLineInvDiscAmtCaptionLbl)
            {
            }
            column(Subtotal_Lbl; SubtotalCaptionLbl)
            {
            }
            column(VATAmtLineVAT_Lbl; VATAmtLineVATCaptionLbl)
            {
            }
            column(VATAmtLineVATAmt_Lbl; VATAmtLineVATAmtCaptionLbl)
            {
            }
            column(VATAmtSpec_Lbl; VATAmtSpecCaptionLbl)
            {
            }
            column(VATIdentifier_Lbl; VATIdentifierCaptionLbl)
            {
            }
            column(VATAmtLineInvDiscBaseAmt_Lbl; VATAmtLineInvDiscBaseAmtCaptionLbl)
            {
            }
            column(VATAmtLineLineAmt_Lbl; VATAmtLineLineAmtCaptionLbl)
            {
            }
            column(VALVATBaseLCY_Lbl; VALVATBaseLCYCaptionLbl)
            {
            }
            column(Total_Lbl; TotalCaptionLbl)
            {
            }
            column(PaymentTermsDesc_Lbl; PaymentTermsDescCaptionLbl)
            {
            }
            column(ShipmentMethodDesc_Lbl; ShipmentMethodDescCaptionLbl)
            {
            }
            column(PrepymtTermsDesc_Lbl; PrepymtTermsDescCaptionLbl)
            {
            }
            column(HomePage_Lbl; HomePageCaptionLbl)
            {
            }
            column(EmailID_Lbl; EmailIDCaptionLbl)
            {
            }
            column(AllowInvoiceDisc_Lbl; AllowInvoiceDiscCaptionLbl)
            {
            }
            column(CurrRepPageNo; StrSubstNo(PageLbl, Format(CurrReport.PageNo)))
            {
            }
            column(DocumentDate; Format("Document Date", 0, 4))
            {
            }
            column(DueDate; Format("Due Date", 0, 4))
            {
            }
            column(ExptRecptDt_PurchaseHeader; Format("Expected Receipt Date", 0, 4))
            {
            }
            column(OrderDate_PurchaseHeader; Format("Order Date", 0, 4))
            {
            }
            column(VATNoText; VATNoText)
            {
            }
            column(VATRegNo_PurchHeader; "VAT Registration No.")
            {
            }
            column(PurchaserText; PurchaserText)
            {
            }
            column(SalesPurchPersonName; SalespersonPurchaser.Name)
            {
            }
            column(ReferenceText; ReferenceText)
            {
            }
            column(YourRef_PurchHeader; "Your Reference")
            {
            }
            column(BuyFrmVendNo_PurchHeader; "Buy-from Vendor No.")
            {
            }
            column(BuyFromAddr1; BuyFromAddr[1])
            {
            }
            column(BuyFromAddr2; BuyFromAddr[2])
            {
            }
            column(BuyFromAddr3; BuyFromAddr[3])
            {
            }
            column(BuyFromAddr4; BuyFromAddr[4])
            {
            }
            column(BuyFromAddr5; BuyFromAddr[5])
            {
            }
            column(BuyFromAddr6; BuyFromAddr[6])
            {
            }
            column(BuyFromAddr7; BuyFromAddr[7])
            {
            }
            column(BuyFromAddr8; BuyFromAddr[8])
            {
            }
            column(PricesIncludingVAT_Lbl; PricesIncludingVATCaptionLbl)
            {
            }
            column(PricesInclVAT_PurchHeader; "Prices Including VAT")
            {
            }
            column(OutputNo; OutputNo)
            {
            }
            column(VATBaseDisc_PurchHeader; "VAT Base Discount %")
            {
            }
            column(PricesInclVATtxt; PricesInclVATtxtLbl)
            {
            }
            column(PaymentTermsDesc; PaymentTerms.Description)
            {
            }
            column(PaymentMethodDesc; PaymentMethod.Description) { }
            column(ShipmentMethodDesc; ShipmentMethod.Description)
            {
            }
            column(PrepmtPaymentTermsDesc; PrepmtPaymentTerms.Description)
            {
            }
            column(Shipment_Method_Code_lbl; Shipment_Method_Code_lbl) { }
            column(Shipment_Method_Code; "Shipment Method Code") { }
            column(DimText; DimText)
            {
            }
            column(OrderNo_Lbl; OrderNoCaptionLbl)
            {
            }
            column(Page_Lbl; PageCaptionLbl)
            {
            }
            column(DocumentDate_Lbl; DocumentDateCaptionLbl)
            {
            }
            column(BuyFrmVendNo_PurchHeader_Lbl; FieldCaption("Buy-from Vendor No."))
            {
            }
            column(PricesInclVAT_PurchHeader_Lbl; FieldCaption("Prices Including VAT"))
            {
            }
            column(Receiveby_Lbl; ReceivebyCaptionLbl)
            {
            }
            column(Buyer_Lbl; BuyerCaptionLbl)
            {
            }
            column(PayToVendNo_PurchHeader; "Pay-to Vendor No.")
            {
            }
            column(VendAddr8; VendAddr[8])
            {
            }
            column(VendAddr7; VendAddr[7])
            {
            }
            column(VendAddr6; VendAddr[6])
            {
            }
            column(VendAddr5; VendAddr[5])
            {
            }
            column(VendAddr4; VendAddr[4])
            {
            }
            column(VendAddr3; VendAddr[3])
            {
            }
            column(VendAddr2; VendAddr[2])
            {
            }
            column(VendAddr1; VendAddr[1])
            {
            }
            column(PaymentDetails_Lbl; PaymentDetailsCaptionLbl)
            {
            }
            column(VendNo_Lbl; VendNoCaptionLbl)
            {
            }
            column(VendorCaptionLbl; VendorCaptionLbl) { }
            column(SellToCustNo_PurchHeader; "Sell-to Customer No.")
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
            column(ShiptoAddress_Lbl; ShiptoAddressCaptionLbl)
            {
            }
            column(SellToCustNo_PurchHeader_Lbl; FieldCaption("Sell-to Customer No."))
            {
            }
            column(ItemNumber_Lbl; ItemNumberCaptionLbl)
            {
            }
            column(ItemDescription_Lbl; ItemDescriptionCaptionLbl)
            {
            }
            column(ItemQuantity_Lbl; ItemQuantityCaptionLbl)
            {
            }
            column(ItemUnit_Lbl; ItemUnitCaptionLbl)
            {
            }
            column(ItemUnitPrice_Lbl; ItemUnitPriceCaptionLbl)
            {
            }
            column(ItemLineAmount_Lbl; ItemLineAmountCaptionLbl)
            {
            }
            column(ToCaption_Lbl; ToCaptionLbl)
            {
            }
            column(VendorIDCaption_Lbl; VendorIDCaptionLbl)
            {
            }
            column(ConfirmToCaption_Lbl; ConfirmToCaptionLbl)
            {
            }
            column(PurchOrderCaption_Lbl; PurchOrderCaptionLbl)
            {
            }
            column(PurchOrderNumCaption_Lbl; PurchOrderNumCaptionLbl)
            {
            }
            column(PurchOrderDateCaption_Lbl; PurchOrderDateCaptionLbl)
            {
            }
            column(TaxIdentTypeCaption_Lbl; TaxIdentTypeCaptionLbl)
            {
            }
            column(OrderDate_Lbl; OrderDateLbl)
            {
            }
            column(VendorInvoiceNo_Lbl; VendorInvoiceNoLbl)
            {
            }
            column(VendorInvoiceNo; "Vendor Invoice No.")
            {
            }
            column(VendorOrderNo_Lbl; VendorOrderNoLbl)
            {
            }
            column(VendorOrderNo; "Vendor Order No.")
            {
            }
            column(PediProveeedorLbl; PediProveeedorLbl)
            {
            }
            column(PRCOMPRASLbl; PRCOMPRASLbl)
            {
            }
            column(ISOLbl; ISOLbl)
            {
            }
            column(DateLbl; DateLbl)
            {
            }
            column(PhoneFaxLbl; PhoneFaxLbl)
            {
            }
            column(AgenciaTransporteLbl; AgenciaTransporteLbl)
            {
            }
            column(VatLbl; VatLbl)
            {
            }
            column(BaseImponibleLbl; BaseImponibleLbl)
            {
            }
            column(TotalDTOLbl; TotalDTOLbl)
            {
            }
            column(VATAmtLineVATAmtCaptionLbl; VATAmtLineVATAmtCaptionLbl)
            {
            }
            column(ImporteBrutoLbl; ImporteBrutoLbl)
            {
            }
            column(VATAmountText; TempVATAmountLine.VATAmountText)
            {
            }
            column(TotalVATAmount; VATAmount)
            {
                AutoFormatExpression = "Purchase Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalVATDiscountAmount; -VATDiscountAmount)
            {
                AutoFormatExpression = "Purchase Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalVATBaseAmount; VATBaseAmount)
            {
                AutoFormatExpression = "Purchase Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalAmountInclVAT; TotalAmountInclVAT)
            {
                AutoFormatExpression = "Purchase Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalInclVATText; TotalInclVATText)
            {
            }
            column(TotalExclVATText; TotalExclVATText)
            {
            }
            column(TotalSubTotal; TotalSubTotal)
            {
                AutoFormatExpression = "Purchase Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalInvoiceDiscountAmount; TotalInvoiceDiscountAmount)
            {
                AutoFormatExpression = "Purchase Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalAmount; TotalAmount)
            {
                AutoFormatExpression = "Purchase Header"."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalText; TotalText)
            {
            }
            column(DescuentoCabPurch; "Purchase Header"."Payment Discount %")
            {
            }
            //SOTHIS EBR 040920 id 159231
            column(logo; CompanyInfo.LogoCertificacion)
            { }
            //fin SOTHIS EBR 040920 id 159231
            //JAA -  Ticket 261019 Añadir horario inicio y fin en el report
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(WorkHours; WorkHours)
            {
            }
            column(DireccionEntregaLbl; DireccionEntregaLbl) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(AmountCaptionLbl; AmountCaptionLbl)
                {
                }
                column(PurchLineLineDiscCaptionLbl; PurchLineLineDiscCaptionLbl)
                {
                }
                column(LineNo_PurchLine; "Line No.")
                {
                }
                column(Vendor_Item_No_; "Vendor Item No.") { }
                column(AllowInvDisctxt; AllowInvDisctxt)
                {
                }
                column(Type_PurchLine; Format(Type, 0, 2))
                {
                }
                column(No_PurchLine; "No.")
                {
                }
                column(Desc_PurchLine; Description)
                {
                }
                column(Desc_PurchLine2; Description)
                {
                }
                column(Qty_PurchLine; FormattedQuanitity)
                {
                }
                column(UOM_PurchLine; "Unit of Measure")
                {
                }
                column(DirUnitCost_PurchLine; FormattedDirectUnitCost)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 2;
                }
                column(LineDisc_PurchLine; "Line Discount %")
                {
                }
                column(LineAmt_PurchLine; "Line Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(AllowInvDisc_PurchLine; "Allow Invoice Disc.")
                {
                }
                column(VATIdentifier_PurchLine; "VAT Identifier")
                {
                }
                column(InvDiscAmt_PurchLine; -"Inv. Discount Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(TotalInclVAT; "Line Amount" - "Inv. Discount Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(DirectUniCost_Lbl; DirectUniCostCaptionLbl)
                {
                }
                column(PurchLineLineDisc_Lbl; PurchLineLineDiscCaptionLbl)
                {
                }
                column(VATDiscountAmount_Lbl; VATDiscountAmountCaptionLbl)
                {
                }
                column(No_PurchLine_Lbl; FieldCaption("No."))
                {
                }
                column(Desc_PurchLine_Lbl; FieldCaption(Description))
                {
                }
                column(Qty_PurchLine_Lbl; FieldCaption(Quantity))
                {
                }
                column(UOM_PurchLine_Lbl; ItemUnitOfMeasureCaptionLbl)
                {
                }
                column(VATIdentifier_PurchLine_Lbl; FieldCaption("VAT Identifier"))
                {
                }
                column(DuedateLbl; DuedateLbl)
                {
                }
                column(AmountIncludingVAT; "Amount Including VAT")
                {
                }
                column(TotalPriceCaption_Lbl; TotalPriceCaptionLbl)
                {
                }
                column(InvDiscCaption_Lbl; InvDiscCaptionLbl)
                {
                }
                column(UnitPrice_PurchLine; "Unit Price (LCY)")
                {
                }
                column(UnitPrice_PurchLine_Lbl; UnitPriceLbl)
                {
                }
                column(JobNo_PurchLine; "Job No.")
                {
                }
                column(JobNo_PurchLine_Lbl; JobNoLbl)
                {
                }
                column(ExpectedReceiptDate; Format("Purchase Line"."Expected Receipt Date", 8, '<Day,2>/<Month,2>/<Year,2>'))
                {
                }
                column(JobTaskNo_PurchLine; "Job Task No.")
                {
                }
                column(JobTaskNo_PurchLine_Lbl; JobTaskNoLbl)
                {
                }
                column(UnitCost; "Purchase Line"."Direct Unit Cost")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    AllowInvDisctxt := Format("Allow Invoice Disc.");
                    TotalSubTotal += "Line Amount";
                    TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                    TotalAmount += Amount;
                    if "Cross-Reference No." <> '' then
                        "No." := "Cross-Reference No.";

                    FormatDocument.SetPurchaseLine("Purchase Line", FormattedQuanitity, FormattedDirectUnitCost);
                    //CurrReport.NEWPAGE;
                end;
            }
            dataitem(Totals; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                trigger OnAfterGetRecord()
                var
                    TempPrepmtPurchLine: Record "Purchase Line" temporary;
                begin


                end;
            }
            dataitem(VATCounter; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(VATAmtLineVATBase; TempVATAmountLine."VAT Base")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineVATAmt; TempVATAmountLine."VAT Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineLineAmt; TempVATAmountLine."Line Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineInvDiscBaseAmt; TempVATAmountLine."Inv. Disc. Base Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineInvDiscAmt; TempVATAmountLine."Invoice Discount Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmtLineVAT; TempVATAmountLine."VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(VATAmtLineVATIdentifier; TempVATAmountLine."VAT Identifier")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TempVATAmountLine.GetLine(Number);
                end;

                trigger OnPreDataItem()
                begin
                    if VATAmount = 0 then
                        CurrReport.Break;
                    SetRange(Number, 1, TempVATAmountLine.Count);
                end;
            }
            dataitem(VATCounterLCY; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(VALExchRate; VALExchRate)
                {
                }
                column(VALSpecLCYHeader; VALSpecLCYHeader)
                {
                }
                column(VALVATAmountLCY; VALVATAmountLCY)
                {
                    AutoFormatType = 1;
                }
                column(VALVATBaseLCY; VALVATBaseLCY)
                {
                    AutoFormatType = 1;
                }

                trigger OnAfterGetRecord()
                begin
                    TempVATAmountLine.GetLine(Number);
                    VALVATBaseLCY :=
                      TempVATAmountLine.GetBaseLCY(
                        "Purchase Header"."Posting Date", "Purchase Header"."Currency Code", "Purchase Header"."Currency Factor");
                    VALVATAmountLCY :=
                      TempVATAmountLine.GetAmountLCY(
                        "Purchase Header"."Posting Date", "Purchase Header"."Currency Code", "Purchase Header"."Currency Factor");
                end;

                trigger OnPreDataItem()
                begin
                    if (not GLSetup."Print VAT specification in LCY") or
                       ("Purchase Header"."Currency Code" = '') or
                       (TempVATAmountLine.GetTotalVATAmount = 0)
                    then
                        CurrReport.Break;

                    SetRange(Number, 1, TempVATAmountLine.Count);

                    if GLSetup."LCY Code" = '' then
                        VALSpecLCYHeader := VATAmountSpecificationLbl + LocalCurrentyLbl
                    else
                        VALSpecLCYHeader := VATAmountSpecificationLbl + Format(GLSetup."LCY Code");

                    CurrExchRate.FindCurrency("Purchase Header"."Posting Date", "Purchase Header"."Currency Code", 1);
                    VALExchRate := StrSubstNo(ExchangeRateLbl, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                end;
            }
            dataitem(PrepmtLoop; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(PrepmtLineAmount; PrepmtLineAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtInvBufGLAccNo; TempPrepaymentInvLineBuffer."G/L Account No.")
                {
                }
                column(PrepmtInvBufDesc; TempPrepaymentInvLineBuffer.Description)
                {
                }
                column(TotalInclVATText2; TotalInclVATText)
                {
                }
                column(TotalExclVATText2; TotalExclVATText)
                {
                }
                column(PrepmtInvBufAmt; TempPrepaymentInvLineBuffer.Amount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATAmountText; TempPrepmtVATAmountLine.VATAmountText)
                {
                }
                column(PrepmtVATAmount; PrepmtVATAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtInvBuDescCaption; PrepmtInvBuDescCaptionLbl)
                {
                }
                column(PrepmtInvBufGLAccNoCaption; PrepmtInvBufGLAccNoCaptionLbl)
                {
                }
                column(PrepaymentSpecCaption; PrepaymentSpecCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        if not TempPrepaymentInvLineBuffer.Find('-') then
                            CurrReport.Break;
                    end else
                        if TempPrepaymentInvLineBuffer.Next = 0 then
                            CurrReport.Break;

                    if "Purchase Header"."Prices Including VAT" then
                        PrepmtLineAmount := TempPrepaymentInvLineBuffer."Amount Incl. VAT"
                    else
                        PrepmtLineAmount := TempPrepaymentInvLineBuffer.Amount;
                end;
            }
            dataitem(PrepmtVATCounter; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(PrepmtVATAmtLineVATAmt; TempPrepmtVATAmountLine."VAT Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATAmtLineVATBase; TempPrepmtVATAmountLine."VAT Base")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATAmtLineLineAmt; TempPrepmtVATAmountLine."Line Amount")
                {
                    AutoFormatExpression = "Purchase Header"."Currency Code";
                    AutoFormatType = 1;
                }
                column(PrepmtVATAmtLineVAT; TempPrepmtVATAmountLine."VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(PrepmtVATAmtLineVATId; TempPrepmtVATAmountLine."VAT Identifier")
                {
                }
                column(PrepymtVATAmtSpecCaption; PrepymtVATAmtSpecCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TempPrepmtVATAmountLine.GetLine(Number);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, TempPrepmtVATAmountLine.Count);
                end;
            }
            dataitem(LetterText; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(GreetingText; GreetingLbl)
                {
                }
                column(BodyText; BodyLbl)
                {
                }
                column(ClosingText; ClosingLbl)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                TempPrepmtPurchLine: Record "Purchase Line" temporary;
                recVendor: Record Vendor;
            begin
                TotalAmount := 0;
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if recVendor.Get("Purchase Header"."Buy-from Vendor No.") then
                    CurrReport.Language := Language.GetLanguageID(recVendor."Language Code");

                if optIdioma <> optIdioma::" " then
                    CurrReport.LANGUAGE := Language.GetLanguageID(format(optIdioma));

                // si no tiene codigo divisa ponemos divisa principal
                Currency_Code := "Purchase Header"."Currency Code";
                if Currency_Code = '' then
                    Currency_Code := 'EUR';


                FormatAddressFields("Purchase Header");
                FormatDocumentFields("Purchase Header");
                if Vendor.Get("Purchase Header"."Buy-from Vendor No.") then;
                if not IsReportInPreviewMode then begin
                    CODEUNIT.Run(CODEUNIT::"Purch.Header-Printed", "Purchase Header");
                    if ArchiveDocument then
                        ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);
                end;

                Clear(TempPurchLine);
                Clear(PurchPost);
                TempPurchLine.DeleteAll;
                TempVATAmountLine.DeleteAll;
                PurchPost.GetPurchLines("Purchase Header", TempPurchLine, 0);
                TempPurchLine.CalcVATAmountLines(0, "Purchase Header", TempPurchLine, TempVATAmountLine);
                TempPurchLine.UpdateVATOnLines(0, "Purchase Header", TempPurchLine, TempVATAmountLine);
                VATAmount := TempVATAmountLine.GetTotalVATAmount;
                VATBaseAmount := TempVATAmountLine.GetTotalVATBase;
                VATDiscountAmount :=
                  TempVATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code", "Purchase Header"."Prices Including VAT");
                TotalAmountInclVAT := TempVATAmountLine.GetTotalAmountInclVAT;

                TempPrepaymentInvLineBuffer.DeleteAll;
                PurchasePostPrepayments.GetPurchLines("Purchase Header", 0, TempPrepmtPurchLine);
                if not TempPrepmtPurchLine.IsEmpty then begin
                    PurchasePostPrepayments.GetPurchLinesToDeduct("Purchase Header", TempPurchLine);
                    if not TempPurchLine.IsEmpty then
                        PurchasePostPrepayments.CalcVATAmountLines("Purchase Header", TempPurchLine, TempPrePmtVATAmountLineDeduct, 1);
                end;
                PurchasePostPrepayments.CalcVATAmountLines("Purchase Header", TempPrepmtPurchLine, TempPrepmtVATAmountLine, 0);
                TempPrepmtVATAmountLine.DeductVATAmountLine(TempPrePmtVATAmountLineDeduct);
                PurchasePostPrepayments.UpdateVATOnLines("Purchase Header", TempPrepmtPurchLine, TempPrepmtVATAmountLine, 0);
                PurchasePostPrepayments.BuildInvLineBuffer2("Purchase Header", TempPrepmtPurchLine, 0, TempPrepaymentInvLineBuffer);
                PrepmtVATAmount := TempPrepmtVATAmountLine.GetTotalVATAmount;
                PrepmtVATBaseAmount := TempPrepmtVATAmountLine.GetTotalVATBase;
                PrepmtTotalAmountInclVAT := TempPrepmtVATAmountLine.GetTotalAmountInclVAT;

                //JAA- ticket #261019 Concatenamos los horarios para mostrarlos en el report
                WorkHours := 'Horario: ' + Format(CompanyInfo."Initial Work Hour") + ' - ' + Format(CompanyInfo."Final Work Hour");
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
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Archive Document', Comment = 'ESP="Archivar documento"';
                        ToolTip = 'Specifies whether to archive the order.', Comment = 'ESP="Especifica si se debe archivar el pedido."';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Log Interaction', Comment = 'ESP="Log Interacción"';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to log this interaction.', Comment = 'ESP="Especifica si desea registrar esta interacción."';
                    }

                    field(optIdioma; optIdioma)
                    {
                        ApplicationArea = All;
                        Caption = 'Language', comment = 'ESP="Idioma"';
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
            ArchiveDocument := PurchSetup."Archive Orders";
        end;

        trigger OnOpenPage()
        begin
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        PurchSetup.Get;
        CompanyInfo.CalcFields(Picture);

        //SOTHIS EBR 010920 id 15923
        CompanyInfo.CalcFields(LogoCertificacion);
        //fin SOTHIS EBR 010920 id 15923
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode then
            if "Purchase Header".FindSet then
                repeat
                    SegManagement.LogDocument(
                      13, "Purchase Header"."No.", 0, 0, DATABASE::Vendor, "Purchase Header"."Buy-from Vendor No.",
                      "Purchase Header"."Purchaser Code", '', "Purchase Header"."Posting Description", '');
                until "Purchase Header".Next = 0;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction;
    end;

    var
        optIdioma: Option " ","ENU","ESP","FRA";
        PageLbl: Label 'Page %1', Comment = '%1 = Page No.';
        VATAmountSpecificationLbl: Label 'VAT Amount Specification in ', Comment = 'ESP="Especificación importe IVA en "';
        LocalCurrentyLbl: Label 'Local Currency', Comment = 'ESP="Divisa Local"';
        ExchangeRateLbl: Label 'Exchange rate: %1/%2', Comment = '%1 = CurrExchRate."Relational Exch. Rate Amount", %2 = CurrExchRate."Exchange Rate Amount"';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.', Comment = 'ESP="Nº teléfono"';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.', Comment = 'ESP="Nº Giro"';
        CompanyInfoBankNameCaptionLbl: Label 'Bank', Comment = 'ESP="Banco"';
        CompanyInfoBankAccNoCaptionLbl: Label 'Account No.', Comment = 'ESP="Nº cuenta"';
        OrderNoCaptionLbl: Label 'Order No.', Comment = 'ESP="Nº Pedido"';
        PageCaptionLbl: Label 'Page', Comment = 'ESP="Página"';
        DocumentDateCaptionLbl: Label 'Document Date', Comment = 'ESP="Fecha emisión"';
        DirectUniCostCaptionLbl: Label 'Unit Price', Comment = 'ESP="Precio"';
        PurchLineLineDiscCaptionLbl: Label 'Disc %', Comment = 'ESP="% Desc"';
        VATDiscountAmountCaptionLbl: Label 'Payment Discount on VAT', Comment = 'ESP="Descuento de pago en IVA"';
        PaymentDetailsCaptionLbl: Label 'Payment Details', Comment = 'ESP="Detalle pago"';
        VendNoCaptionLbl: Label 'Vendor No.', Comment = 'ESP="Nº proveedor"';
        VendorCaptionLbl: Label 'VENDOR', Comment = 'ESP="PROVEEDOR"';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address', Comment = 'ESP="Envío-a dirección"';
        PrepmtInvBuDescCaptionLbl: Label 'Description', Comment = 'ESP="Descripción"';
        PrepmtInvBufGLAccNoCaptionLbl: Label 'G/L Account No.', Comment = 'ESP="Nº cuenta"';
        PrepaymentSpecCaptionLbl: Label 'Prepayment Specification', Comment = 'ESP="Especificación prepago"';
        PrepymtVATAmtSpecCaptionLbl: Label 'Prepayment VAT Amount Specification', Comment = 'ESP="Especificación de importe de IVA prepago"';
        AmountCaptionLbl: Label 'Amount', Comment = 'ESP="Importe"';
        PurchLineInvDiscAmtCaptionLbl: Label 'Invoice Discount Amount', Comment = 'ESP="Importe descuento factura"';
        SubtotalCaptionLbl: Label 'Subtotal', Comment = 'ESP="Sub total"';
        VATAmtLineVATCaptionLbl: Label 'VAT %', Comment = 'ESP="% IVA"';
        VATAmtLineVATAmtCaptionLbl: Label 'VAT Amount', Comment = 'ESP="Importe IVA"';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification', Comment = 'ESP="Especificación importe IVA"';
        VATIdentifierCaptionLbl: Label 'VAT Identifier', Comment = 'ESP="Identificador IVA"';
        VATAmtLineInvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount', Comment = 'ESP="Importe base de descuento de factura"';
        VATAmtLineLineAmtCaptionLbl: Label 'Line Amount', Comment = 'ESP="Importe línea"';
        VALVATBaseLCYCaptionLbl: Label 'VAT Base', Comment = 'ESP="Base IVA"';
        PricesInclVATtxtLbl: Label 'Prices Including VAT', Comment = 'ESP="Precios IVA incluido"';
        Shipment_Method_Code_lbl: Label 'Shipment Method', Comment = 'ESP="Condiciones envío"';
        TotalCaptionLbl: Label 'Total', Comment = 'ESP="Total"';
        PaymentTermsDescCaptionLbl: Label 'Payment Terms', Comment = 'ESP="Términos pago"';
        ShipmentMethodDescCaptionLbl: Label 'Shipment Method', Comment = 'ESP="Método envío"';
        PrepymtTermsDescCaptionLbl: Label 'Prepmt. Payment Terms', Comment = 'ESP="Términos pago prepago"';
        HomePageCaptionLbl: Label 'Home Page', Comment = 'ESP="Página web"';
        EmailIDCaptionLbl: Label 'Email', Comment = 'ESP="Email"';
        AllowInvoiceDiscCaptionLbl: Label 'Allow Invoice Discount', Comment = 'ESP="Permite descuento factura"';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempPrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        TempPurchLine: Record "Purchase Line" temporary;
        TempPrepaymentInvLineBuffer: Record "Prepayment Inv. Line Buffer" temporary;
        TempPrePmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        PurchPost: Codeunit "Purch.-Post";
        SegManagement: Codeunit SegManagement;
        PurchasePostPrepayments: Codeunit "Purchase-Post Prepayments";
        ArchiveManagement: Codeunit ArchiveManagement;
        VendAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        BuyFromAddr: array[8] of Text[100];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        FormattedQuanitity: Text;
        FormattedDirectUnitCost: Text;
        workDescription: Text;
        Currency_Code: text;
        OutputNo: Integer;
        DimText: Text[120];
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        AllowInvDisctxt: Text[30];
        [InDataSet]
        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        DocumentTitleLbl: Label 'Purchase Order', Comment = 'ESP="Pedido compra"';
        CompanyLogoPosition: Integer;
        ReceivebyCaptionLbl: Label 'Receive By', Comment = 'ESP="Recibido por"';
        BuyerCaptionLbl: Label 'Buyer', Comment = 'ESP="Comprador"';
        ItemNumberCaptionLbl: Label 'Item No.', Comment = 'ESP="Nº producto"';
        ItemDescriptionCaptionLbl: Label 'Description', Comment = 'ESP="Descripción"';
        ItemQuantityCaptionLbl: Label 'Quantity', Comment = 'ESP="Cantidad"';
        ItemUnitCaptionLbl: Label 'Unit', Comment = 'ESP="Unidad"';
        ItemUnitPriceCaptionLbl: Label 'Unit Price', Comment = 'ESP="Precio"';
        ItemLineAmountCaptionLbl: Label 'Line Amount', Comment = 'ESP="Importe línea"';
        PricesIncludingVATCaptionLbl: Label 'Prices Including VAT', Comment = 'ESP="Precios IVA incluido"';
        ItemUnitOfMeasureCaptionLbl: Label 'Unit', Comment = 'ESP="Unidad"';
        ToCaptionLbl: Label 'To:', Comment = 'ESP="A:"';
        VendorIDCaptionLbl: Label 'Vendor ID', Comment = 'ESP="Id Proveedor"';
        ConfirmToCaptionLbl: Label 'Confirm To', Comment = 'ESP="Confirmar a"';
        PurchOrderCaptionLbl: Label 'PURCHASE ORDER', Comment = 'ESP="PEDIDO COMPRA"';
        PurchOrderNumCaptionLbl: Label 'Purchase Order Number:', Comment = 'ESP="Nº pedido compra:"';
        PurchOrderDateCaptionLbl: Label 'Purchase Order Date:', Comment = 'ESP="Fecha pedido compra:"';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type', Comment = 'ESP="Tipo ident. fiscal"';
        TotalPriceCaptionLbl: Label 'Total Price', Comment = 'ESP="Precio total"';
        InvDiscCaptionLbl: Label 'Invoice Discount:', Comment = 'ESP="Descuento factura:"';
        GreetingLbl: Label 'Hello', Comment = 'ESP="Hola"';
        ClosingLbl: Label 'Sincerely', Comment = 'ESP="Sinceramente"';
        BodyLbl: Label 'The purchase order is attached to this message.', Comment = 'ESP="El pedido de compra está adjunto a este mensaje."';
        OrderDateLbl: Label 'Order Date', Comment = 'ESP="Fecha pedido"';
        ArchiveDocument: Boolean;
        VendorOrderNoLbl: Label 'Vendor Order No.', Comment = 'ESP="Nº pedido proveedor"';
        VendorInvoiceNoLbl: Label 'Vendor Invoice No.', Comment = 'ESP="Nº factura proveedor"';
        UnitPriceLbl: Label 'Unit Price (LCY)', Comment = 'ESP="Precio unitario (DL)"';
        JobNoLbl: Label 'Job No.', Comment = 'ESP="Nº proyecto"';
        JobTaskNoLbl: Label 'Job Task No.', Comment = 'ESP="Nº tarea proyecto"';
        DuedateLbl: Label 'Due Date', Comment = 'ESP="Fecha entrega"';
        PediProveeedorLbl: Label 'VENDOR ORDER', Comment = 'ESP="PEDIDO COMPRA"';
        PRCOMPRASLbl: Label 'OR-PURCHASE', Comment = 'ESP="PR-COMPRAS"';
        //ISOLbl: Label 'PO.01.DCP/A1.11', Comment = 'ESP="PO.01.DCP/A1.11"';
        ISOLbl: Label 'FO.04_C4.01_V14', Comment = 'ESP="FO.04_C4.01_V14"';
        DateLbl: Label 'Date', Comment = 'ESP="Fecha de inicio"';
        PhoneFaxLbl: Label 'Phone/Fax:', Comment = 'ESP="Telf/Fax:"';
        AgenciaTransporteLbl: Label 'Transport Agency', Comment = 'ESP="Agencia transporte"';
        VatLbl: Label 'VAT', Comment = 'ESP="IVA"';
        BaseImponibleLbl: Label 'Amount Ex.Vat', Comment = 'ESP="Importe excl. IVA"';
        TotalDTOLbl: Label 'Disc. Total', Comment = 'ESP="Desc. Total"';
        ImporteBrutoLbl: Label 'Amount ', Comment = 'ESP="Importe"';
        Vendor: Record Vendor;
        PortesLbl: Label 'Freight', Comment = 'ESP="Portes"';
        DireccionEntregaLbl: Label 'ADDRESS DELIVERY IN: ', Comment = 'ESP="DIRECCIÓN DE ENTREGA: "';
        WorkHours: Text;

    [Scope('Personalization')]
    procedure InitializeRequest(LogInteractionParam: Boolean)
    begin
        LogInteraction := LogInteractionParam;
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody);
    end;

    local procedure FormatAddressFields(var PurchaseHeader: Record "Purchase Header")
    begin
        FormatAddr.GetCompanyAddr(PurchaseHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.PurchHeaderBuyFrom(BuyFromAddr, PurchaseHeader);
        if PurchaseHeader."Buy-from Vendor No." <> PurchaseHeader."Pay-to Vendor No." then
            FormatAddr.PurchHeaderPayTo(VendAddr, PurchaseHeader);
        FormatAddr.PurchHeaderShipTo(ShipToAddr, PurchaseHeader);
    end;

    local procedure FormatDocumentFields(PurchaseHeader: Record "Purchase Header")
    begin
        with PurchaseHeader do begin
            FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
            FormatDocument.SetPurchaser(SalespersonPurchaser, "Purchaser Code", PurchaserText);
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            FormatDocument.SetPaymentTerms(PrepmtPaymentTerms, "Prepmt. Payment Terms Code", "Language Code");
            FormatDocument.SetPaymentMethod(PaymentMethod, "Payment Method Code", "Language Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");

            ReferenceText := FormatDocument.SetText("Your Reference" <> '', FieldCaption("Your Reference"));
            VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FieldCaption("VAT Registration No."));
        end;
    end;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
    end;

    local procedure TempPurchaseLine(var TMPPurchaseLine: Record "Purchase Line"; veces: Integer)
    begin


        if not TMPPurchaseLine.IsTemporary then
            exit;

        if TMPPurchaseLine.Count < veces then;
    end;
}

