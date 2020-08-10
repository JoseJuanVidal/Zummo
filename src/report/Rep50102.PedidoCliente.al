report 50102 "PedidoCliente"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50102.PedidoCliente.rdl';
    Caption = 'Pedido Cliente', Comment = 'Customer Order';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
           DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(Payment_Discount__; "Payment Discount %")
            {

            }
            column(telfCleiten; recC."Phone No.") { }

            column(codigoDivisa; codigoDivisa) { }
            column(PesoBruto_SalesLine; sumaPesoBruto)
            {
            }
            column(txtOferta; txtOferta) { }
            column(txtOfertaLbl; txtOfertaLbl) { }
            column(boolLineasPendientes; boolLineasPendientes) { }
            column(Portes; Portes)
            {

            }
            column(InvoiceDiscountAmount; InvoiceDiscountAmount) { }
            column(ImporteBruto; TotalSalesLineF."Line Amount") { }
            column(InvoiceDiscountPct; InvoiceDiscountPct) { }
            column(VATAmount2; importeiva) { }
            column(BaseImponible; TotalSalesLineF.Amount) { }
            column(Importecab; TotalAmount2) { }
            column(ivafactura; ivafactura) { }
            column(importeDescuentoPP; TotalSalesLineF."Pmt. Discount Amount") { }


            column(NNCTotalInclVAT2; NNC_TotalInclVAT2)
            {
            }
            column(ShipToAddr8; DestinoFinalPais)
            {
            }
            column(ShipToAddr7; "Ship-to Country/Region Code")
            {
            }
            column(ShipToAddr6; "Ship-to County")
            {
            }
            column(ShipToAddr5; "Ship-to City")
            {
            }
            column(ShipToAddr4; "Ship-to Post Code")
            {
            }
            column(ShipToAddr3; "Ship-to Address 2")
            {
            }
            column(ShipToAddr2; "Ship-to Address")
            {
            }
            column(ShipToAddr1; "Ship-to Name")
            {
            }
            column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(Valorado; Valorado)
            {

            }
            column(PrecioNeto; PrecioNeto)
            {

            }
            column(TipoDocumento; TipoDocumento) { }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(DocType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            column(DeliveryDate_SalesHeader; "Promised Delivery Date")
            {
            }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            {
            }
            column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            {
            }
            column(PaymentMethodCaption; PaymentMethodCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionLbl)
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(AllowInvDiscCaption; AllowInvDiscCaptionLbl)
            {
            }
            //Variables
            column(VatAmount_btc; VatAmount_btc)
            {
            }
            column(InvoiceDiscountAmount_btc; InvoiceDiscountAmount_btc)
            {
            }
            column(InvoiceDiscountPct_btc; InvoiceDiscountPct_btc)
            {
            }
            column(TransportistaNombre_btc; TransportistaNombre_btc)
            {
            }
            column(DestinoFinalPais; DestinoFinalPais)
            {
            }
            //Captions
            column(PedidoDeCliente_Caption; PedidoDeCliente_Lbl)
            {
            }
            column(OfertaCliente_Lbl; OfertaCliente_Lbl) { }
            column(ProformaCliente_Lbl; ProformaCliente_Lbl) { }
            column(PRGestionPedidosCliente_Caption; PRGestionPedidosCliente_Lbl)
            {
            }
            column(FO01_Caption; FO01_Lbl)
            {
            }
            column(FO02_Caption; FO02_Lbl)
            {
            }
            column(FO03_Caption; FO03_Lbl)
            {
            }
            column(Fecha_Caption; Fecha_Lbl)
            {
            }
            column(PedidoNo_Caption; PedidoNo_Lbl)
            {
    
            }
            column(FEntrega_Caption; FEntrega_Lbl)
            {
            }
            column(CondicionDePago_Caption; CondicionDePago_Lbl)
            {
            }
            column(DestinoFinal_Caption; DestinoFinal_Lbl)
            {
            }
            column(PaisFabricacion_Caption; PaisFabricacion_Lbl)
            {
            }
            column(Transportista_Caption; Transportista_Lbl)
            {
            }
            column(EmitidoPor_Caption; EmitidoPor_Lbl)
            {
            }
            column(NIF_Caption; NIF_Lbl)
            {
            }
            column(TelFax_Caption; TelFax_Lbl)
            {
            }
            column(Agente_Caption; Agente_Lbl)
            {
            }
            column(Cajas_Caption; Cajas_Lbl)
            {
            }
            column(PesoBruto_Caption; PesoBruto_Lbl)
            {
            }
            column(Volumen_Caption; Volumen_Lbl)
            {
            }
            column(Articulo_Caption; Articulo_Lbl)
            {

            }
            column(Descripcion_Caption; Descripcion_Lbl)
            {
            }
            column(Cantidad_Caption; Cantidad_Lbl)
            {
            }
            column(PrecioU_Caption; PrecioU_Lbl)
            {
            }
            column(Dto_Caption; Dto_Lbl)
            {
            }
            column(Dto_Caption2; Dto2_Lbl)
            {
            }
            column(Importe_Caption; Importe_Lbl)
            {
            }
            column(NoSerie_Caption; NoSerie_Lbl)
            {
            }
            column(Observaciones_Caption; Observaciones_Lbl)
            {
            }
            column(BaseImponible_Caption; BaseImponible_Lbl)
            {
            }
            column(Base_Caption; Base_Lbl)
            {
            }
            column(IVA_Caption; IVA_Lbl)
            {
            }
            column(Porcentaje_Caption; Porcentaje_Lbl)
            {
            }
            column(Ppdisc_Caption; PPdisc_Lbl)
            {
            }

            column(RE_Caption; RE_Lbl)
            {
            }
            column(Comentarios_Caption; Comentarios_Lbl)
            {
            }
            column(ImporteBruto_Caption; ImporteBruto_Lbl)
            {
            }
            column(DtoGeneral_Caption; DtoGeneral_Lbl)
            {
            }
            column(Portes_Caption; Portes_Lbl)
            {
            }
            column(SubTotal_Caption; SubTotal_Lbl)
            {
            }
            column(SegunLoDispuesto_Caption; SegunLoDispuesto_Lbl)
            {
            }
            column(ZummoInnovaciones_Caption; ZummoInnovaciones_Lbl)
            {
            }
            column(TFZummo_Caption; TFZummo_Lbl)
            {
            }
            column(Work_Description; workDescription)
            {

            }
            column(workDescription_lbl; workDescription_lbl)
            {

            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoName; agenteNombre)
                    {
                    }
                    column(SalesHeaderCopyText; STRSUBSTNO(Text004_Lbl, CopyText))
                    {
                    }
                    column(CustAddr1; "Sales Header"."Sell-to Customer Name")
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; "Sales Header"."Sell-to Address")
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; "Sales Header"."Sell-to Post Code")
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; "Sales Header"."Sell-to City")
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; "Sales Header"."Sell-to County")
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; destinofactura)
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
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
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(DocDate_SalesHeader; FORMAT("Sales Header"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    {
                    }
                    column(ShipmentDate_SalesHeader; FORMAT("Sales Header"."Document Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(SalesHeaderNo1; "Sales Header"."No.")
                    {
                    }
                    column(ReferenceText; "Sales Header".FIELDCAPTION("External Document No."))
                    {
                    }
                    column(SalesOrderReference_SalesHeader; "Sales Header"."External Document No.")
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
                    column(PricesIncludVAT_SalesHeader; "Sales Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption; PageCaptionCap_Lbl)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo_SalesHeader; FORMAT("Sales Header"."Prices Including VAT"))
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
                    column(BankAccountNoCaption; BankAccountNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                    }
                    column(PricesIncludVAT_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    column(CACCaption; CACCaptionLbl)
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText_DimLoop1; DimText)
                        {
                        }
                        column(Number_DimLoop1; Number)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FIND('-') THEN
                                    CurrReport.BREAK();
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK();

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK();
                        end;
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = FIELD("Document Type"),
                                       "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.BREAK();
                        end;
                    }
                    dataitem(RoundLoop; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(Descuento1_SalesLine; SalesLine."DecLine Discount1 %_btc")
                        {

                        }
                        column(Descuento2_SalesLine; SalesLine."DecLine Discount2 %_btc")
                        {

                        }
                        column(EsPorte; EsPorte)
                        {

                        }
                        //column(Portes; Portes) { }
                        column(LineAmt_SalesLine; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(EsEmbalaje; EsEmbalaje) { }
                        column(Desc_SalesLine; txtDescLinea)
                        {
                        }
                        column(NNCSalesLineLineAmt; NNC_SalesLineLineAmt)
                        {
                        }
                        column(NNCSalesLineInvDiscAmt; NNC_SalesLineInvDiscAmt)
                        {
                        }
                        column(NNCTotalExclVAT; NNC_TotalExclVAT)
                        {
                        }
                        column(NNCVATAmt; NNC_VATAmt)
                        {
                        }
                        column(NNCPmtDiscOnVAT; NNC_PmtDiscOnVAT)
                        {
                        }
                        column(NNCVatAmt2; NNC_VatAmt2)
                        {
                        }
                        column(NNCTotalExclVAT2; NNC_TotalExclVAT2)
                        {
                        }
                        column(VATBaseDisc_SalesHeader; "Sales Header"."VAT Base Discount %")
                        {
                        }
                        column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                        {
                        }
                        column(No2_SalesLine; "Sales Line"."No.")
                        {
                        }
                        column(Qty_SalesLine; cantidadSalesLine)
                        {
                        }
                        column(UOM_SalesLine; "Sales Line"."Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDisc_SalesLine; "Sales Line"."Line Discount %")
                        {
                        }
                        column(LineAmt1_SalesLine; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        {
                        }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesLine; FORMAT("Sales Line".Type))
                        {
                        }
                        column(No1_SalesLine; "Sales Line"."Line No.")
                        {
                        }
                        column(AllowInvDisYesNo_SalesLine; FORMAT("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(QtyAssembleOrder; "Sales Line"."Qty. to Assemble to Order")
                        {
                        }
                        column(SalesLineInvDiscAmt; SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLineLineAmtInvDiscAmt; -SalesLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(NNCPmtDiscGivenAmount; NNC_PmtDiscGivenAmount)
                        {
                        }
                        column(SalesLinePmtDiscGivenAmt; SalesLine."Pmt. Discount Amount")
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(VATAmount; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(SalesLineLAmtInvDiscAmtVATAmt; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" - SalesLine."Pmt. Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATDiscountAmount; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscountCaption; DiscountCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PmtDiscGivenAmtCaption; PmtDiscGivenAmtCaptionLbl)
                        {
                        }
                        column(PaymentDiscVATCaption; PaymentDiscVATCaptionLbl)
                        {
                        }
                        column(Desc_SalesLineCaption; "Sales Line".FIELDCAPTION(Description))
                        {
                        }
                        column(No_SalesLineCaption; "Sales Line".FIELDCAPTION("No."))
                        {
                        }
                        column(Qty_SalesLineCaption; "Sales Line".FIELDCAPTION(Quantity))
                        {
                        }
                        column(UOM_SalesLineCaption; "Sales Line".FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(AllowInvDisc_SalesLineCaption; "Sales Line".FIELDCAPTION("Allow Invoice Disc."))
                        {
                        }
                        column(VATIdentifier_SalesLineCaption; "Sales Line".FIELDCAPTION("VAT Identifier"))
                        {
                        }



                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText_DimLoop2; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET() THEN
                                        CurrReport.BREAK();
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK();

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK();

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            column(AsmLineUnitOfMeasureText; GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                            {
                            }
                            column(AsmLineQuantity; AsmLine.Quantity)
                            {
                            }
                            column(AsmLineDescription; BlanksForIndent() + AsmLine.Description)
                            {
                            }
                            column(AsmLineNo; BlanksForIndent() + AsmLine."No.")
                            {
                            }
                            column(AsmLineType; AsmLine.Type)
                            {
                            }


                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN
                                    AsmLine.FINDSET()
                                ELSE
                                    AsmLine.NEXT();
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT DisplayAssemblyInformation THEN
                                    CurrReport.BREAK();
                                IF NOT AsmInfoExistsForLine THEN
                                    CurrReport.BREAK();
                                AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
                                AsmLine.SETRANGE("Document No.", AsmHeader."No.");
                                SETRANGE(Number, 1, AsmLine.COUNT());
                            end;
                        }

                        //sacar lineas de ensamblado
                        dataitem("Assemble-to-Order Link"; "Assemble-to-Order Link")
                        {
                            column(AssLink_Document_No_; "Document No.")
                            {
                            }
                            column(AssLink_Document_Type; "Document Type")
                            {
                            }
                            column(AssLink_Document_Line_No_; "Document Line No.")
                            {
                            }
                            dataitem("Assembly Header"; "Assembly Header")
                            {
                                DataItemLink = "Document Type" = FIELD("Assembly Document Type"),
                                    "No." = field("Assembly Document No.");

                                column(AssHeader_No_; "No.")
                                {
                                }
                                column(AssHeader_Document_Type; "Document Type")
                                {
                                }
                                dataitem("Assembly Line"; "Assembly Line")
                                {
                                    DataItemLink = "Document No." = field("No."),
                                        "Document Type" = field("Document Type");

                                    column(Assembly_No; "Document No.")
                                    {
                                    }
                                    column(Assembly_Item_No; "No.")
                                    {
                                    }
                                    column(Assembly_Description; Description)
                                    {
                                    }
                                    column(NoSerie_Value; NoSerie_Value)
                                    {
                                    }

                                    dataitem("Reservation Entry"; "Reservation Entry")
                                    {
                                        DataItemLink = "Source ID" = field("Document No."),
                                       "Source Ref. No." = field("Line No.")
                                       ;

                                        //"Source Type"=const(901);
                                        column(Serial_No_; "Serial No.")
                                        {

                                        }
                                    }

                                    trigger OnAfterGetRecord()

                                    var
                                        RecTempItemTracking: Record "Tracking Specification" temporary;
                                        CUItemTracking: Codeunit "Item Tracking Doc. Management";
                                        ReservationEntry: Record "Reservation Entry";
                                    begin
                                        //Sacar No. Serie
                                        Clear(CUItemTracking);
                                        NoSerie_Value := '';
                                        ReservationEntry.Reset();
                                        ReservationEntry.SetRange(ReservationEntry."Reservation Status", ReservationEntry."Reservation Status"::Reservation);
                                        ReservationEntry.SetRange("Source ID", "Assembly Line"."Document No.");
                                        ReservationEntry.SetRange("Source Ref. No.", "Assembly Line"."Line No.");
                                        ReservationEntry.SetRange("Source Type", 901);
                                        ReservationEntry.SetRange("Source Subtype", 1);
                                        if ReservationEntry.FindFirst() then
                                            NoSerie_Value := ReservationEntry."Serial No.";
                                    end;
                                }
                            }
                            trigger OnPreDataItem()
                            begin
                                "Assemble-to-Order Link".SetRange("Document Type", SalesLine."Document Type");
                                "Assemble-to-Order Link".SetRange("Document No.", SalesLine."Document No.");
                                "Assemble-to-Order Link".SETRANGE("Document Line No.", SalesLine."Line No.");
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
                        var
                            cduFunciones: Codeunit Funciones;
                            txtAux: Text[100];
                            boolOferta: Boolean;
                            Item: Record Item;
                        begin
                            IF Number = 1 THEN
                                SalesLine.FIND('-')
                            ELSE
                                SalesLine.NEXT();

                            sumaPesoBruto += SalesLine."Gross Weight" * SalesLine.Quantity;

                            txtDescLinea := SalesLine.Description;

                            if boolLineasPendientes then
                                cantidadSalesLine := SalesLine."Outstanding Quantity"
                            else
                                cantidadSalesLine := SalesLine.Quantity;

                            if ConfPersonalizationMgt.GetCurrentProfileID() = 'ALMACEN' then begin
                                if ((SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '')) then begin
                                    Item.get(SalesLine."No.");
                                    txtDescLinea := Item.Description;
                                end;
                            end else begin
                                if (idiomaReport <> '') and (SalesLine.Type = SalesLine.Type::Item) then begin
                                    if idiomaReport <> 'ESP' THEN begin
                                        Clear(cduFunciones);
                                        txtAux := cduFunciones.GetTradDescProducto(SalesLine."No.", SalesLine."Variant Code", idiomaReport);

                                        if txtAux <> '' then
                                            txtDescLinea := txtAux;
                                    END;
                                end else
                                    if (idiomaReport <> '') and (SalesLine.Type = SalesLine.Type::"G/L Account") then begin
                                        if idiomaReport <> 'ESP' then begin
                                            clear(cduFunciones);
                                            txtAux := cduFunciones.GetTradDescCuenta(SalesLine."No.", idiomaReport);

                                            if txtAux <> '' then
                                                txtDescLinea := txtaux;
                                        end;
                                    end;
                            end;

                            "Sales Line" := SalesLine;
                            EsEmbalaje := false;
                            EsPorte := false;
                            Clear(Portes);
                            if (SalesLine."Item Category Code" = 'EMBALAJES') or (SalesLine."Item Category Code" = 'EMBALAJE') then
                                EsEmbalaje := true;
                            if SalesLine.Type = SalesLine.Type::"G/L Account" then
                                if not RecCuenta.Get(SalesLine."No.") then
                                    Clear(RecCuenta);


                            if "Sales Line"."No." = '7591000' then begin
                                EsPorte := true;
                                CurrReport.Skip();
                            end;



                            IF DisplayAssemblyInformation THEN
                                AsmInfoExistsForLine := SalesLine.AsmToOrderExists(AsmHeader);

                            IF NOT "Sales Header"."Prices Including VAT" AND
                               (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
                            THEN
                                SalesLine."Line Amount" := 0;

                            IF (SalesLine.Type = SalesLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "Sales Line"."No." := '';

                            NNC_SalesLineLineAmt += SalesLine."Line Amount";
                            NNC_SalesLineInvDiscAmt += SalesLine."Inv. Discount Amount";

                            NNC_TotalLCY := NNC_SalesLineLineAmt - NNC_SalesLineInvDiscAmt;

                            NNC_TotalExclVAT := NNC_TotalLCY;
                            NNC_VATAmt := VATAmount;
                            NNC_TotalInclVAT := NNC_TotalLCY - NNC_VATAmt;

                            NNC_PmtDiscOnVAT := -VATDiscountAmount;

                            NNC_TotalInclVAT2 := TotalAmountInclVAT;

                            NNC_VatAmt2 := VATAmount;
                            NNC_TotalExclVAT2 := VATBaseAmount;
                            NNC_PmtDiscGivenAmount := NNC_PmtDiscGivenAmount - SalesLine."Pmt. Discount Amount";

                            RecMemLotes.Reset();
                            RecMemLotes.DeleteAll();

                            if SalesLine."Document Type" = SalesLine."Document Type"::Quote then
                                boolOferta := true
                            else
                                boolOferta := false;

                            RetrieveLotAndExpFromPostedInv(SalesLine."Document No.", SalesLine."Line No.", RecMemLotes, boolOferta);
                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DELETEALL();
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := SalesLine.FIND('+');
                            WHILE MoreLines AND (SalesLine.Description = '') AND (SalesLine."Description 2" = '') AND
                                  (SalesLine."No." = '') AND (SalesLine.Quantity = 0) AND
                                  (SalesLine.Amount = 0)
                            DO
                                MoreLines := SalesLine.NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK();
                            SalesLine.SETRANGE("Line No.", 0, SalesLine."Line No.");

                            if boolLineasPendientes then
                                SalesLine.SetFilter("Outstanding Quantity", '<>%1', 0);

                            SETRANGE(Number, 1, SalesLine.COUNT());
                        end;
                    }



                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmountLineVATECBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVATAmount; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineLineAmount; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmtPmtDiscAmt; VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineECAmt; VATAmountLine."EC Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmountLineVAT_VATCounter; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier_VATCounter; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLineEC; VATAmountLine."EC %")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATPecrentCaption; VATPecrentCaptionLbl)
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
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(LineAmountCaption; LineAmountCaptionLbl)
                        {
                        }
                        column(InvPmtDiscountsCaption; InvPmtDiscountsCaptionLbl)
                        {
                        }
                        column(VATIdentifierCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        column(ECAmtCaption; ECAmtCaptionLbl)
                        {
                        }
                        column(ECPercentCaption; ECPercentCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        //Variables
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
                        column(nTotalImporte; nTotalImporte)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            IF VATAmountLine."VAT Amount" = 0 THEN
                                VATAmountLine."VAT %" := 0;
                            IF VATAmountLine."EC Amount" = 0 THEN
                                VATAmountLine."EC %" := 0;

                            IF nLineaActual <= ARRAYLEN(nBaseActual) THEN BEGIN
                                nBaseActual[nLineaActual] := VATAmountLine."VAT Base";
                                nImporteIVA[nLineaActual] := VATAmountLine."VAT Amount";
                                IF VATAmountLine."EC Amount" = 0 THEN BEGIN
                                    nPorcentajeRE[nLineaActual] := 0;
                                    nRE[nLineaActual] := 0;
                                END
                                ELSE BEGIN
                                    nPorcentajeRE[nLineaActual] := VATAmountLine."EC %";
                                    nRE[nLineaActual] := VATAmountLine."EC Amount";
                                END;
                                IF VATAmountLine."VAT Amount" = 0 THEN
                                    nPorcentajeIVA[nLineaActual] := 0
                                ELSE
                                    nPorcentajeIVA[nLineaActual] := VATAmountLine."VAT %";

                                nTotalImporte := nBaseActual[nLineaActual] + nImporteIVA[nLineaActual] + nRE[nLineaActual];
                            END;
                            nLineaActual += 1;

                        end;

                        trigger OnPreDataItem()
                        begin
                            IF (VATAmount = 0) AND (VATAmountLine."VAT %" + VATAmountLine."EC %" = 0) THEN
                                CurrReport.BREAK();
                            SETRANGE(Number, 1, VATAmountLine.COUNT());

                            nLineaActual := 1;
                            Clear(nBaseActual);
                            Clear(nImporteIVA);
                            Clear(nPorcentajeIVA);
                            Clear(nRE);
                            Clear(nPorcentajeRE);
                            Clear(nTotalImporte);

                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
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
                        column(VATAmountLineVAT_VATCounterLCY; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier_VATCounterLCY; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Sales Header"."Currency Code" = '') OR
                               (VATAmountLine.GetTotalVATAmount() = 0)
                            THEN
                                CurrReport.BREAK();

                            SETRANGE(Number, 1, VATAmountLine.COUNT());
                            CLEAR(VALVATBaseLCY);
                            CLEAR(VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text007_Lbl + Text008_Lbl
                            ELSE
                                VALSpecLCYHeader := Text007_Lbl + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
                            VALExchRate := STRSUBSTNO(Text009_Lbl, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                        {
                        }

                        column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                            IF NOT ShowShippingAddr THEN
                                CurrReport.BREAK();
                        end;
                    }
                    dataitem(PrepmtLoop; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(PrepmtLineAmount; PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufDesc; PrepmtInvBuf.Description)
                        {
                        }
                        column(GLAccountNo_PrepmtInvBuf; PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(TotalExclVATText1; TotalExclVATText)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmtTxt; PrepmtVATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalInclVATTxt; TotalInclVATText)
                        {
                        }
                        column(PrepmtInvBufAmount; PrepmtInvBuf.Amount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmount; PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufAmtPrepmtVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLVATAmtText1; VATAmountLine.VATAmountText())
                        {
                        }
                        column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(GLAccountNoCaption; GLAccountNoCaptionLbl)
                        {
                        }
                        column(PrepaymentSpecCaption; PrepaymentSpecCaptionLbl)
                        {
                        }
                        dataitem(PrepmtDimLoop; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText2; DimText)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT TempPrepmtDimSetEntry.FIND('-') THEN
                                        CurrReport.BREAK();
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK();

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText :=
                                          STRSUBSTNO('%1 %2', TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL TempPrepmtDimSetEntry.NEXT() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                CurrReport.Break();
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT PrepmtInvBuf.FIND('-') THEN
                                    CurrReport.BREAK();
                            END ELSE
                                IF PrepmtInvBuf.NEXT() = 0 THEN
                                    CurrReport.BREAK();

                            IF ShowInternalInfo THEN
                                DimMgt.GetDimensionSet(TempPrepmtDimSetEntry, PrepmtInvBuf."Dimension Set ID");

                            IF "Sales Header"."Prices Including VAT" THEN
                                PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            ELSE
                                PrepmtLineAmount := PrepmtInvBuf.Amount;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                        end;
                    }
                    dataitem(PrepmtVATCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmt_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBase_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmt_PrepmtVATAmtLine; PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VAT_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_PrepmtVATAmtLine; PrepmtVATAmountLine."VAT Identifier")
                        {
                        }
                        column(PrepaymentVATAmtSpecCaption; PrepaymentVATAmtSpecCaptionLbl)
                        {
                        }
                        column(PrepmtVATPercentCaption; VATPecrentCaptionLbl)
                        {
                        }
                        column(PrepmtVATBaseCaption; VATECBaseCaptionLbl)
                        {
                        }
                        column(PrepmtVATAmtCaption; VATAmountCaptionLbl)
                        {
                        }
                        column(PrepmtVATIdentCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        column(PrepmtLineAmtCaption; LineAmountCaptionLbl)
                        {
                        }
                        column(PrepmtTotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                            SETRANGE(Number, 1, PrepmtVATAmountLine.COUNT());
                        end;
                    }
                    dataitem(PrepmtTotal; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(PrepmtPaymentTermsDesc; PrepmtPaymentTerms.Description)
                        {
                        }
                        column(PrepmtPaymentTermsCaption; PrepmtPaymentTermsCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break();
                            IF NOT PrepmtInvBuf.FIND('-') THEN
                                CurrReport.BREAK();
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtSalesLine: Record 37 temporary;
                    TempSalesLine: Record 37 temporary;
                    SalesPost: Codeunit 80;
                begin
                    CLEAR(SalesLine);
                    CLEAR(SalesPost);
                    VATAmountLine.DELETEALL();
                    SalesLine.DELETEALL();
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount();
                    VATBaseAmount := VATAmountLine.GetTotalVATBase();
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT();

                    PrepmtInvBuf.DELETEALL();
                    SalesPostPrepmt.GetSalesLines("Sales Header", 0, PrepmtSalesLine);

                    IF NOT PrepmtSalesLine.ISEMPTY() THEN BEGIN
                        SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header", TempSalesLine);
                        IF NOT TempSalesLine.ISEMPTY() THEN
                            SalesPostPrepmt.CalcVATAmountLines("Sales Header", TempSalesLine, PrepmtVATAmountLineDeduct, 1);
                    END;
                    SalesPostPrepmt.CalcVATAmountLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrepmtVATAmountLineDeduct);
                    SalesPostPrepmt.UpdateVATOnLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    SalesPostPrepmt.BuildInvLineBuffer2("Sales Header", PrepmtSalesLine, 0, PrepmtInvBuf);
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount();
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase();
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT();

                    IF (VATAmountLine."VAT Calculation Type" = VATAmountLine."VAT Calculation Type"::"Reverse Charge VAT") AND
                       "Sales Header"."Prices Including VAT"
                    THEN BEGIN
                        VATBaseAmount := VATAmountLine.GetTotalLineAmount(FALSE, "Sales Header"."Currency Code");
                        TotalAmountInclVAT := VATAmountLine.GetTotalLineAmount(FALSE, "Sales Header"."Currency Code");
                    END;

                    IF Number > 1 THEN BEGIN
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    END;

                    NNC_TotalLCY := 0;
                    NNC_TotalExclVAT := 0;
                    NNC_VATAmt := 0;
                    NNC_TotalInclVAT := 0;
                    NNC_PmtDiscGivenAmount := 0;
                    NNC_PmtDiscOnVAT := 0;
                    NNC_TotalInclVAT2 := 0;
                    NNC_VatAmt2 := 0;
                    NNC_TotalExclVAT2 := 0;
                    NNC_SalesLineLineAmt := 0;
                    NNC_SalesLineInvDiscAmt := 0;
                end;

                trigger OnPostDataItem()
                begin
                    IF Print THEN
                        CODEUNIT.RUN(CODEUNIT::"Sales-Printed", "Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                RecShippingAgent: Record "Shipping Agent";
                RecCountry: Record "Country/Region";
                DocumentsTotals: Codeunit "Document Totals";
                customer: Record Customer;
                PortesSalesLine: Record "Sales Line";
                DocumentTotals: Codeunit "Document Totals";
                Currency: Record Currency;
                InitSalesLine: Record "Sales Line";

                SalesLine: Record "Sales Line";
                TempSalesLine: Record "Sales Line" temporary;
                SalesPost: Codeunit "Sales-Post";
                recSPerson: Record "Salesperson/Purchaser";
                rep: Report PedidoCliente;
                recSalesStp: Record "Sales & Receivables Setup";
                TempBlob_lRec: record TempBlob;
                recSHead: record "Sales Header";
                BlobOutStream: OutStream;
                RecRef: RecordRef;
                FileMgt: Codeunit "File Management";
                txtRutaLocalTemp: Text;
                txtRutaServidor: Text;
                recConfConta: Record "General Ledger Setup";
            begin
                if not recC.get("Sell-to Customer No.") then
                    clear(recC);

                if recSalesStp.Get() and (recSalesStp.RutaPdfPedidos_btc <> '') then
                    if (TipoDocumento = 1) and (not GuardadoPdf_btc) then begin // Pedido
                        "Sales Header".GuardadoPdf_btc := true;
                        if "Sales Header".Modify() then;

                        recSHead.reset();
                        recSHead.SetRange("Document Type", "Sales Header"."Document Type");
                        recSHead.SetRange("No.", "Sales Header"."No.");

                        txtRutaServidor := FileMgt.ServerTempFileName('pdf');

                        Clear(rep);
                        rep.Pvalorado(Valorado);
                        rep.Pneto(false);
                        rep.PTipoDocumento(TipoDocumento);//1 pedido 2 proforma
                        rep.SetTableView(recSHead);
                        rep.UseRequestPage(false);
                        rep.SaveAsPdf(txtRutaServidor);

                        txtRutaLocalTemp := FileMgt.DownloadTempFile(txtRutaServidor);

                        FileMgt.MoveAndRenameClientFile(txtRutaLocalTemp, 'Pedido_' + "Sales Header"."No." + '.pdf', recSalesStp.RutaPdfPedidos_btc);
                    end;

                //if customer.get("Sales Header"."Sell-to Contact No.") then begin
                // CurrReport.LANGUAGE := 1034;

                //end
                //else
                // CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                // "Sales Header".CalcFields("Work Description");
                sumaPesoBruto := 0;

                txtOferta := '';
                txtOfertaLbl := '';

                if "Document Type" = "Document Type"::Quote then begin
                    txtOfertaLbl := lbNumDias;

                    if optIdioma = optIdioma::ENU then
                        txtOfertaLbl := 'Lead Time: '
                    else
                        if optIdioma = optIdioma::ESP then
                            txtOfertaLbl := 'Nº días: ';

                    txtOferta := Format(NumDias_btc);
                end;

                ivafactura := 0;

                InitSalesLine.Reset;
                InitSalesLine.SetRange("Document No.", "No.");
                if InitSalesLine.FindFirst then;

                Currency.InitRoundingPrecision;
                DocumentTotals.GetTotalSalesHeaderAndCurrency(InitSalesLine, TotalSalesHeader, Currency);
                DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount2, InvoiceDiscountAmount, InvoiceDiscountPct);

                ivafactura := 0;

                InitSalesLine.Reset;
                InitSalesLine.SetRange("Document No.", "No.");
                InitSalesLine.Setfilter("VAT %", '<>0');
                if InitSalesLine.FindFirst then
                    ivafactura := InitSalesLine."VAT %";
                //ivafactura := 21;

                Portes := 0;
                PortesSalesLine.Reset;
                PortesSalesLine.SetRange("No.", '7591000');
                PortesSalesLine.SetRange("Document No.", "No.");
                if PortesSalesLine.FindSet then
                    repeat
                        Portes += PortesSalesLine.Amount;
                    until PortesSalesLine.Next = 0;


                if customer.Get("Sell-to Customer No.") then begin
                    CurrReport.LANGUAGE := Language.GetLanguageID(customer."Language Code");
                    idiomaReport := customer."Language Code";
                end;

                if optIdioma <> optIdioma::" " then begin
                    CurrReport.LANGUAGE := Language.GetLanguageID(format(optIdioma));
                    idiomaReport := format(optIdioma);
                end;

                if ConfPersonalizationMgt.GetCurrentProfileID() = 'ALMACEN' then
                    CurrReport.Language := Language.GetLanguageID('ESP');

                FormatAddressFields("Sales Header");
                FormatDocumentFields("Sales Header");

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                ShowCashAccountingCriteria("Sales Header");

                IF Print THEN
                    IF CurrReport.USEREQUESTPAGE() AND ArchiveDocument OR
                       NOT CurrReport.USEREQUESTPAGE() AND SalesSetup."Archive Orders"
                    THEN
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);

                //Sacar el nombre del transportista
                TransportistaNombre_btc := '';

                IF NOT RecShippingAgent.Get("Sales Header"."Shipping Agent Code") THEN
                    Clear(RecShippingAgent)
                else
                    TransportistaNombre_btc := RecShippingAgent.Name;

                // Comercial
                agenteNombre := CompanyInfo.Name;

                if "Salesperson Code" <> '' then
                    if recSPerson.Get("Salesperson Code") then
                        agenteNombre := recSPerson.Name;

                //Para calcular la cantidad total del descuento
                DocumentsTotals.CalculateSalesSubPageTotals("Sales Header", "Sales Line", VatAmount_btc, InvoiceDiscountAmount_btc, InvoiceDiscountPct_btc);
                //Sacar Pais Destino Final
                RecCountry.Reset();
                IF NOT RecCountry.Get("Sales Header"."Ship-to Country/Region Code") THEN Clear(RecCountry);
                DestinoFinalPais := RecCountry.Name;

                RecCountry.Reset();
                IF NOT RecCountry.Get("Sales Header"."Sell-to Country/Region Code") THEN Clear(RecCountry);
                destinofactura := RecCountry.Name;



                //workdescription
                workdescription := GetWorkDescription();

                /*#########################################################################################################################
                                                                INICIO TOTALES
                #########################################################################################################################*/
                CLEAR(SalesLine);
                CLEAR(TotalSalesLineF);
                CLEAR(TotalSalesLineLCYF);
                CLEAR(SalesPost);
                clear(importeiva);

                SalesPost.GetSalesLines("Sales Header", TempSalesLine, 0);
                CLEAR(SalesPost);
                SalesPost.SumSalesLinesTemp(
                    "Sales Header", TempSalesLine, 0, TotalSalesLineF, TotalSalesLineLCYF,
                    VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

                AdjProfitLCY := TotalSalesLineLCYF.Amount - TotalAdjCostLCY;
                IF TotalSalesLineLCYF.Amount <> 0 THEN
                    AdjProfitPct := ROUND(AdjProfitLCY / TotalSalesLineLCYF.Amount * 100, 0.1);

                IF "Prices Including VAT" THEN BEGIN
                    TotalAmount2 := TotalSalesLineF.Amount;
                    TotalAmount1 := TotalAmount2 + VATAmount;
                    TotalSalesLineF."Line Amount" :=
                        TotalAmount1 + TotalSalesLineF."Inv. Discount Amount" + TotalSalesLineF."Pmt. Discount Amount";
                END ELSE BEGIN
                    TotalAmount1 := TotalSalesLineF.Amount;
                    TotalAmount2 := TotalSalesLineF."Amount Including VAT";
                END;

                /*if TotalAmount2 > TotalSalesLineF."Line Amount" then
                    importeiva := TotalAmount2 - TotalSalesLineF."Line Amount";*/

                importeiva := VATAmount;
                /*#########################################################################################################################
                                                                FIN TOTALES
                #########################################################################################################################*/

                codigoDivisa := '';

                if "Sales Header"."Currency Code" <> '' then
                    codigoDivisa := "Sales Header"."Currency Code"
                else begin
                    recConfConta.get();
                    if recConfConta."LCY Code" <> '' then
                        codigoDivisa := recConfConta."LCY Code"
                    else
                        codigoDivisa := 'EUR';
                end;
            end;

            trigger OnPostDataItem()
            begin
                OnAfterPostDataItem("Sales Header");
            end;

            trigger OnPreDataItem()
            begin
                Print := Print OR NOT IsReportInPreviewMode();
                AsmInfoExistsForLine := FALSE;
            end;


        }
    }


    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }

                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Document';
                        ToolTip = 'Specifies if the document is archived after you print it.';

                        trigger OnValidate()
                        begin
                            IF NOT ArchiveDocument THEN
                                LogInteraction := FALSE;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';

                        trigger OnValidate()
                        begin
                            IF LogInteraction THEN
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                    field(valorado; valorado)
                    {
                        ApplicationArea = All;
                    }
                    field(PrecioNeto; PrecioNeto) { }
                    field(TipoDocumento; TipoDocumento)
                    {

                    }

                    field(optIdioma; optIdioma)
                    {
                        ApplicationArea = All;
                        Caption = 'Language', comment = 'ESP="Idioma"';
                    }

                    field(boolLineasPendientes; boolLineasPendientes)
                    {
                        ApplicationArea = All;
                        Caption = 'Only pending lines', comment = 'ESP="Solo líneas pendientes"';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
            ArchiveDocument := SalesSetup."Archive Orders";
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction();

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET();
        CompanyInfo.GET();
        CompanyInfo1.CalcFields(Picture);
        SalesSetup.GET();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);

        OnAfterInitReport();
    end;

    trigger OnPostReport()
    begin
        IF LogInteraction AND Print THEN
            IF "Sales Header".FINDSET() THEN
                REPEAT
                    "Sales Header".CALCFIELDS("No. of Archived Versions");
                    IF "Sales Header"."Bill-to Contact No." <> '' THEN
                        SegManagement.LogDocument(
                          SegManagement.SalesOrderConfirmInterDocType(), "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence",
                          "Sales Header"."No. of Archived Versions", DATABASE::Contact, "Sales Header"."Bill-to Contact No."
                          , "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description",
                          "Sales Header"."Opportunity No.")
                    ELSE
                        SegManagement.LogDocument(
                          SegManagement.SalesOrderConfirmInterDocType(), "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence",
                          "Sales Header"."No. of Archived Versions", DATABASE::Customer, "Sales Header"."Bill-to Customer No.",
                          "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description",
                          "Sales Header"."Opportunity No.");
                UNTIL "Sales Header".NEXT() = 0;
    end;

    trigger OnPreReport()
    begin
        IF NOT CurrReport.USEREQUESTPAGE() THEN
            InitLogInteraction();
    end;

    var
        txtOferta: Text;
        cantidadSalesLine: Decimal;
        txtOfertaLbl: Text;
        lbNumDias: Label 'Lead Time: ', comment = 'ESP="Nº días: "';
        TotalAmount2: Decimal;
        agenteNombre: Text;
        TotalAmount1: Decimal;
        importeiva: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        AdjProfitLCY: decimal;
        AdjProfitPct: Decimal;
        VATAmountText: text[30];
        codigoDivisa: code[20];
        TotalSalesLineF: Record "Sales Line";
        TotalSalesLineLCYF: Record "Sales Line";

        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        recC: Record Customer;
        VATAmount2: Decimal;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        RecCuenta: Record "G/L Account";
        PaymentMethod: Record "Payment Method";
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        RecMemLotes: Record MemEstadistica_btc temporary;
        PrepmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        TempPrepmtDimSetEntry: Record "Dimension Set Entry" temporary;
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record "Language";
        CurrExchRate: Record "Currency Exchange Rate";
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit "SegManagement";
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatDocument: Codeunit "Format Document";
        SalesPostPrepmt: Codeunit "Sales-Post Prepayments";
        DimMgt: Codeunit "DimensionManagement";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        SalesPersonText: Text[50];
        VATNoText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        DimText: Text[75];
        OldDimText: Text[75];
        idiomaReport: code[10];
        ShowInternalInfo: Boolean;
        Valorado: Boolean;
        TipoDocumento: Integer;//tipo documento 1 Pedido,2 oferta,3 proforma hacer un option
        PrecioNeto: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        EsEmbalaje: Boolean;

        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        OutputNo: Integer;
        NNC_TotalLCY: Decimal;
        NNC_TotalExclVAT: Decimal;
        NNC_VATAmt: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_PmtDiscOnVAT: Decimal;
        NNC_TotalInclVAT2: Decimal;
        NNC_VatAmt2: Decimal;
        NNC_TotalExclVAT2: Decimal;
        NNC_SalesLineLineAmt: Decimal;
        NNC_SalesLineInvDiscAmt: Decimal;
        Print: Boolean;
        EsPorte: Boolean;
        Portes: Decimal;
        NNC_PmtDiscGivenAmount: Decimal;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        ivafactura: Decimal;
        //Variables
        NoSerie_Value: Code[20];
        VatAmount_btc: Decimal;
        InvoiceDiscountAmount_btc: Decimal;
        InvoiceDiscountPct_btc: Decimal;
        TransportistaNombre_btc: Text[50];
        nBaseActual: Array[3] of Decimal;
        nImporteIVA: Array[3] of Decimal;
        nPorcentajeIVA: Array[3] of Decimal;
        nRE: Array[3] of Decimal;
        nPorcentajeRE: Array[3] of Decimal;
        nLineaActual: Integer;
        nTotalImporte: Decimal;
        DestinoFinalPais: Text[50];
        destinofactura: Text[50];
        workDescription: Text;
        optIdioma: Option " ","ENU","ESP","FRA";
        //************************* LABELS *************************************************************

        Text007_Lbl: Label 'VAT Amount Specification in ', comment = 'ESP=""';
        Text008_Lbl: Label 'Local Currency', comment = 'ESP=""';
        Text009_Lbl: Label 'Exchange rate: %1/%2', comment = 'ESP=""';
        Text004_Lbl: Label 'Order Confirmation %1', comment = 'ESP=""';
        PageCaptionCap_Lbl: Label 'Page %1 of %2', comment = 'ESP=""';
        PaymentTermsCaptionLbl: Label 'Payment Terms', comment = 'ESP=""';
        ShipmentMethodCaptionLbl: Label 'Shipment Method', comment = 'ESP=""';
        PaymentMethodCaptionLbl: Label 'Payment Method', comment = 'ESP=""';
        PhoneNoCaptionLbl: Label 'Phone No.', comment = 'ESP=""';
        VATRegNoCaptionLbl: Label 'VAT Registration No.', comment = 'ESP=""';
        GiroNoCaptionLbl: Label 'Giro No.', comment = 'ESP=""';
        BankNameCaptionLbl: Label 'Bank', comment = 'ESP=""';
        BankAccountNoCaptionLbl: Label 'Account No.', comment = 'ESP=""';
        ShipmentDateCaptionLbl: Label 'Shipment Date', comment = 'ESP=""';
        OrderNoCaptionLbl: Label 'Order No.', comment = 'ESP=""';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions', comment = 'ESP=""';
        UnitPriceCaptionLbl: Label 'Unit Price', comment = 'ESP=""';
        DiscountCaptionLbl: Label 'Discount %', comment = 'ESP=""';
        AmountCaptionLbl: Label 'Amount', comment = 'ESP=""';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount', comment = 'ESP=""';
        SubtotalCaptionLbl: Label 'Base Imponible', comment = 'ESP=""';
        PmtDiscGivenAmtCaptionLbl: Label 'Pmt. Discount Given Amount', comment = 'ESP=""';
        PaymentDiscVATCaptionLbl: Label 'Payment Discount on VAT', comment = 'ESP=""';
        LineDimensionsCaptionLbl: Label 'Line Dimensions', comment = 'ESP=""';
        VATPecrentCaptionLbl: Label 'VAT %', comment = 'ESP=""';
        VATECBaseCaptionLbl: Label 'VAT+EC Base', comment = 'ESP=""';
        VATAmountCaptionLbl: Label 'VAT Amount', comment = 'ESP=""';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification', comment = 'ESP=""';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount', comment = 'ESP=""';
        LineAmountCaptionLbl: Label 'Line Amount', comment = 'ESP=""';
        InvPmtDiscountsCaptionLbl: Label 'Invoice and Pmt. Discounts', comment = 'ESP=""';
        VATIdentifierCaptionLbl: Label 'VAT Identifier', comment = 'ESP=""';
        ECAmtCaptionLbl: Label 'EC Amount', comment = 'ESP=""';
        ECPercentCaptionLbl: Label 'EC %', comment = 'ESP=""';
        TotalCaptionLbl: Label 'Total', comment = 'ESP=""';
        VATBaseCaptionLbl: Label 'VAT Base', comment = 'ESP=""';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address', comment = 'ESP=""';
        DescriptionCaptionLbl: Label 'Description', comment = 'ESP=""';
        GLAccountNoCaptionLbl: Label 'G/L Account No.', comment = 'ESP=""';
        PrepaymentSpecCaptionLbl: Label 'Prepayment Specification', comment = 'ESP=""';
        PrepaymentVATAmtSpecCaptionLbl: Label 'Prepayment VAT Amount Specification', comment = 'ESP=""';
        PrepmtPaymentTermsCaptionLbl: Label 'Prepmt. Payment Terms', comment = 'ESP=""';
        HomePageCaptionLbl: Label 'Home Page', comment = 'ESP=""';
        EmailCaptionLbl: Label 'E-Mail', comment = 'ESP=""';
        DocumentDateCaptionLbl: Label 'Document Date', comment = 'ESP=""';
        AllowInvDiscCaptionLbl: Label 'Allow Invoice Discount', comment = 'ESP=""';
        CACCaptionLbl: Text;
        CACTxt: Label 'Régimen especial del criterio de caja', comment = 'ESP=""';
        //ZUMMO

        PedidoDeCliente_Lbl: Label 'SALES ORDER', comment = 'ESP="PEDIDO DE CLIENTE"';
        OfertaCliente_Lbl: Label 'PROFORMA INVOICE', comment = 'ESP="FACTURA PROFORMA"';
        ProformaCliente_Lbl: Label 'PROFORMA INVOICE', comment = 'ESP="FACTURA PROFORMA"';

        PRGestionPedidosCliente_Lbl: Label 'PR-MANAGEMENT OF CUSTOMER ORDERS', comment = 'ESP="PR-GESTION DE LOS PEDIDOS DEL CLIENTE"';

        FO01_Lbl: Label 'FO.01.DVN/A14.07', comment = 'ESP="FO.01.DVN/A14.07"';//PEDIDO
        FO02_Lbl: Label '"FO.01.DVN/A3.14', comment = 'ESP=""FO.01.DVN/A3.14';//OFERTA
        FO03_Lbl: Label 'FO.01.DVN/A3.14', comment = 'ESP="FO.01.DVN/A3.14"'; //PROFORMA

        Fecha_Lbl: Label 'Date', comment = 'ESP="Fecha"';
        PedidoNo_Lbl: Label 'ORDER Nº', Comment = 'ESP="PEDIDO Nº"';
        FEntrega_Lbl: Label 'Deliver Date', Comment = 'ESP="F.Entrega"';
        CondicionDePago_Lbl: Label 'Payment Terms/Payment Method', Comment = 'ESP="Condición de Pago/Método de Pago"';
        DestinoFinal_Lbl: Label 'Final Destination', Comment = 'ESP="Destino Final"';
        PaisFabricacion_Lbl: Label 'Country Manufacturing', Comment = 'ESP="País Fabricación"';
        Transportista_Lbl: Label 'Carrier', Comment = 'ESP="Transportista"';
        EmitidoPor_Lbl: Label 'Issued by:', Comment = 'ESP="Emitido por:"';
        NIF_Lbl: Label 'VAT:', Comment = 'ESP="NIF:"';
        TelFax_Lbl: Label 'Tel/Fax:', Comment = 'ESP="Tel/Fax:"';
        Agente_Lbl: Label 'Agent:', Comment = 'ESP="Agente:"';
        Cajas_Lbl: Label 'Boxes', Comment = 'ESP="Cajas"';
        PesoBruto_Lbl: Label 'Gross Weight(Kg)', Comment = 'ESP="Peso Bruto(Kg)"';
        Volumen_Lbl: Label 'Volume(m3)', Comment = 'ESP="Volumen(m3)"';
        Articulo_Lbl: Label 'Items', Comment = 'ESP="Artículos"';
        Descripcion_Lbl: Label 'Description', Comment = 'ESP="Descripción"';
        Cantidad_Lbl: Label 'Quantity', Comment = 'ESP="Cantidad"';
        PrecioU_Lbl: Label 'Price/unit', Comment = 'ESP="Precio U."';
        Dto_Lbl: Label 'Dto. 1', Comment = 'ESP="Dto. 1"';
        Dto2_Lbl: Label 'Dto. 2', comment = 'ESP="Dto. 2"';
        Importe_Lbl: Label 'Amount', Comment = 'ESP="Importe"';
        NoSerie_Lbl: Label 'Serial No. ', Comment = 'ESP="Nº de Serie:"';
        Observaciones_Lbl: Label 'Remarks:', Comment = 'ESP="Observaciones:"';
        BaseImponible_Lbl: Label 'Tax base', Comment = 'ESP="Base Imponible"';
        Base_Lbl: Label 'Tax Base', Comment = 'ESP="Base"';
        IVA_Lbl: Label 'VAT', Comment = 'ESP="IVA"';
        Porcentaje_Lbl: Label '%', Comment = 'ESP="%"';
        PPdisc_Lbl: Label 'Pp.Disc', Comment = 'ESP="Dto.PP"';
        RE_Lbl: Label 'R.E.', Comment = 'ESP="R.E."';
        Comentarios_Lbl: Label 'Comments', Comment = 'ESP="Comentarios"';
        ImporteBruto_Lbl: Label 'Gross Amount', Comment = 'ESP="Importe Bruto"';
        DtoGeneral_Lbl: Label 'Disc.Com', Comment = 'ESP="Dpt.Gen."';
        Portes_Lbl: Label 'Freight', Comment = 'ESP="Portes"';
        SubTotal_Lbl: Label 'Tax Base', Comment = 'ESP="Base Imponible"';
        SegunLoDispuesto_Lbl: Label 'As provided by Regulation (EU) 2016/769 of the European Parliament and of the Council of April 27, 2016 regarding the protection of natural persons, we inform you that your data will be incorporated into the treatment system owned by ZUMMO MECHANICAL INNOVATIONS, SA - in order to be able to send you the corresponding invoice. You may exercise the rights of access, rectification, limitation of treatment, deletion, portability and opposition / revocation, in the terms established by current regulations on data protection, by sending your request to the postal address indicated above, you can also address to the competent Control Authority to submit the claim it deems appropriate.'
        , comment = 'ESP="Según lo Dispuesto por el Reglamento (UE) 2016/769 del Parlamento Europeo y del Consejo de 27 de abril de 2016 relativo a la protección de las personas físicas, le informamos que sus datos serán incorporados al sistema de tratamiento titularidad de ZUMMO INNOVACIONES MECÁNICAS, S.A. - con la finalidad de poder remitirle la correspondiente factura. Podrá ejercer los derechos de acceso, rectificación, limitación de tratamiento, supresión, portabilidad y oposición/revocación, en los términos que establece la normativa vigente en materia de protección de datos, dirigiendo su petición a la dirección postal arriba indicada, asimismo, podrá dirigirse a la Autoridad de Control competente para presentar la reclamación que considere oportuna."';

        ZummoInnovaciones_Lbl: Label 'Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia on January 26, 1999, Volume 4336, Book 1648, General Section, Folio 212, page Y-22381, Registration 1st CIF A-9Nº R.I. AEE producer 288'
        , comment = 'ESP="Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia el 26 de enero de 1999, Tomo 4336, Libro 1648, Sección Gral., Folio 212, hoja Y-22381, Inscripción 1ª CIF A-9Nº R.I. Productor AEE 288"';
        TFZummo_Lbl: Label 'T +34 961 301 246| F +34 961 301 250| zummo@zummo.es| Cádiz, 4.46113 Moncada.Valencia.Spain|www.zummo.es'
        , comment = 'ESP="T +34 961 301 246| F +34 961 301 250| zummo@zummo.es| Cádiz, 4.46113 Moncada.Valencia.Spain|www.zummo.es"';
        workDescription_lbl: Label 'Description', comment = 'ESP="Descripción"';
        txtDescLinea: text[100];
        boolLineasPendientes: Boolean;
        sumaPesoBruto: Decimal;
        ConfPersonalizationMgt: codeunit "Conf./Personalization Mgt.";

    [Scope('Personalization')]
    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit 9520;
    begin
        EXIT(CurrReport.PREVIEW() OR MailManagement.IsHandlingGetEmailBody());
    end;

    procedure Pvalorado(P_valorado: Boolean)
    begin
        Valorado := P_valorado;
    end;

    procedure Pneto(P_precioNeto: Boolean)
    begin
        PrecioNeto := P_precioNeto;
    end;

    procedure PTipoDocumento(P_Documento: Integer)//pedido oferta proforma
    begin
        TipoDocumento := P_Documento;
    end;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';
    end;

    local procedure FormatAddressFields(var SalesHeader: Record 36)
    begin
        FormatAddr.GetCompanyAddr(SalesHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesHeaderBillTo(CustAddr, SalesHeader);
        ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, SalesHeader);
    end;

    local procedure FormatDocumentFields(SalesHeader: Record 36)
    begin
        WITH SalesHeader DO BEGIN
            FormatDocument.SetTotalLabels("Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
            FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);
            FormatDocument.SetPaymentTerms(PaymentTerms, "Payment Terms Code", "Language Code");
            FormatDocument.SetPaymentTerms(PrepmtPaymentTerms, "Prepmt. Payment Terms Code", "Language Code");
            FormatDocument.SetShipmentMethod(ShipmentMethod, "Shipment Method Code", "Language Code");
            FormatDocument.SetPaymentMethod(PaymentMethod, "Payment Method Code", "Language Code");

            VATNoText := FormatDocument.SetText("VAT Registration No." <> '', FIELDCAPTION("VAT Registration No."));
        END;
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record 204;
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    procedure ShowCashAccountingCriteria(SalesHeader: Record 36): Text
    var
        VATPostingSetup: Record 325;
        SalesLine: Record 37;
    begin
        GLSetup.GET();
        IF NOT GLSetup."VAT Cash Regime" THEN
            EXIT;
        CACCaptionLbl := '';
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDSET() THEN
            REPEAT
                IF VATPostingSetup.GET(SalesHeader."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") THEN
                    IF VATPostingSetup."Unrealized VAT Type" <> VATPostingSetup."Unrealized VAT Type"::" " THEN
                        CACCaptionLbl := CACTxt;
            UNTIL (SalesLine.NEXT() = 0) OR (CACCaptionLbl <> '');
        EXIT(CACCaptionLbl);
    end;

    [Scope('Personalization')]
    procedure BlanksForIndent(): Text[10]
    begin
        EXIT(PADSTR('', 2, ' '));
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterInitReport()
    begin
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterPostDataItem(var SalesHeader: Record 36)
    begin
    end;

    local procedure RetrieveLotAndExpFromPostedInv(pNumDocumento: Code[20]; pNumLinea: Integer; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary; pEsOferta: Boolean)
    var
        recReservationEntry: Record "Reservation Entry";
        recReservationEntryAux: Record "Reservation Entry";
        NumMov: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Invoices)
        RecMemEstadisticas.RESET();
        RecMemEstadisticas.DELETEALL();
        NumMov := 1;

        recReservationEntry.Reset();
        recReservationEntry.SetRange("Source ID", pNumDocumento);
        recReservationEntry.SetRange("Source Ref. No.", pNumLinea);
        recReservationEntry.SetRange("Reservation Status", recReservationEntry."Reservation Status"::Reservation);
        if recReservationEntry.FindSet() then
            repeat
                if recReservationEntry."Serial No." <> '' then begin
                    RecMemEstadisticas.INIT();
                    RecMemEstadisticas.NoMov := NumMov;
                    NumMov += 1;
                    RecMemEstadisticas.NoLote := recReservationEntry."Lot No.";
                    RecMemEstadisticas.NoSerie := recReservationEntry."Serial No.";
                    RecMemEstadisticas.Noproducto := recReservationEntry."Item No.";
                    RecMemEstadisticas.INSERT();
                end else begin
                    recReservationEntryAux.Reset();
                    recReservationEntryAux.SetRange("Entry No.", recReservationEntry."Entry No.");
                    recReservationEntryAux.SetFilter("Serial No.", '<>%1', '');
                    if recReservationEntryAux.FindFirst() then begin
                        RecMemEstadisticas.INIT();
                        RecMemEstadisticas.NoMov := NumMov;
                        NumMov += 1;
                        RecMemEstadisticas.NoLote := recReservationEntryAux."Lot No.";
                        RecMemEstadisticas.NoSerie := recReservationEntryAux."Serial No.";
                        RecMemEstadisticas.Noproducto := recReservationEntryAux."Item No.";
                        RecMemEstadisticas.INSERT();
                    end;
                end;
            until recReservationEntry.Next() = 0;
    end;
}

