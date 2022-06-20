report 50116 "FacturaNacionalUK"
{
    RDLCLayout = './src/report/Rep50116.FacturaNacionalUK.rdl';
    Caption = 'Factura Nacional UK', comment = 'ESP="Factura Nacional UK"';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Invoice';
            column(CompanyInfoName; CompanyInfo.Name) { }
            column(CompanyInfoVatRegGB; lblVat + CompanyInfo."Vat Reg. GB") { }
            column(CompanyInfoEORI; lblEORI + CompanyInfo.EORI) { }
            column(BancoBicSwift_Lbl; BancoBicSwift_Lbl) { }
            column(txtcomentaires; txtcomentaires)
            {

            }
            column(mostrarNetos; mostrarNetos)
            {

            }
            column(codigoDivisa; codigoDivisa) { }
            column(FechaOperacion; FechaOperacion) { }
            column(MostrarFechaOperacion; MostrarFechaOperacion) { }
            column(Text0010Txt; Text0010Txt) { }
            column(VATAmount2; importeiva) { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Importecab; TotalAmount2) { }
            column(CuadroBultos_BultosLbl; CuadroBultos_BultosLbl) { }
            column(CuadroBultos_IncotermLbl; CuadroBultos_IncotermLbl) { }
            column(CuadroBultos_PesoNetoLbl; CuadroBultos_PesoNetoLbl) { }
            column(CuadroBultos_VolumenLbl; CuadroBultos_VolumenLbl) { }
            column(totalBultos; totalBultos)
            {

            }
            column(totalPeso; totalPeso)
            {

            }
            column(totalPalets; totalPalets)
            {

            }
            column(CuadroBultos_PaletsLbl; CuadroBultos_PaletsLbl)
            {

            }
            column(volumen; volumen) { }
            column(Shipment_Method_Code; "Shipment Method Code")
            {

            }
            //column(Importesb; ) { }
            column(Work_Description; workDescription)
            {

            }
            column(ivafactura; ivafactura) { }
            column(ImportePP; PmtDiscAmount) { }
            column(desPp; "Payment Discount %") { }
            column(desFacturaValor; porcentdescuento) { }
            column(ImporteSubTotal; TotalSalesInvoiceHeader.Amount) { }
            column(Importeiva2; importeiva) { }
            column(bas; CustAmount) { }
            column(Portes; Portes) { }
            column(Importetotal; AmountInclVAT) { }
            column(Desfactura; TotalSalesInvoiceHeader."Invoice Discount Amount") { }
            column(BancoCuenta_Lbl; BancoCuenta_Lbl) { }
            column(BancoIBAN_Lbl; BancoIBAN_Lbl) { }
            column(BancoPais_Lbl; BancoPais_Lbl) { }
            column(BancoSucursal_Lbl; BancoSucursal_Lbl) { }
            column(BancoNombre_Lbl; BancoNombre_Lbl) { }
            column(PortesNacionalLbl; PortesNacionalLbl)
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
            column(BankAccountRecordCountry; BankAccountRecord."Country/Region Code") { }
            column(NoAlbaran_Lbl; NoAlbaran_Lbl)
            {
            }
            column(NoPedido_Lbl; NoPedido_Lbl)
            {
            }
            column(facturaLidl; facturaLidl)
            {

            }
            column(facturaExportacion; facturaExportacion) { }
            column(NoAlbaranLidl_Lbl; NoAlbaranLidl_Lbl)
            {

            }
            column(NoPedidoLidl_Lbl; NoPedidoLidl_Lbl)
            {

            }
            column(NoPedidoInternoProveedorLidl_Lbl; NoPedidoInternoProveedorLidl_Lbl)
            {

            }
            column(Importe_Caption; Importe_Lbl)
            {
            }
            column(Tel_Lbl; Tel_Lbl)
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
            column(RE_Caption; RE_Lbl)
            {
            }
            column(ImporteBruto_Caption; ImporteBruto_Lbl)
            {
            }
            column(DtoGeneral_Caption; DtoGeneral_Lbl)
            {
            }
            column(DtoPP_Lbl; DtoPP_Lbl)
            {
            }
            column(Portes_Caption; Portes_Lbl)
            {
            }
            column(SubTotal_Caption; SubTotal_Lbl)
            {
            }
            column(Articulo_Lbl; Articulo_Lbl)
            {
            }
            column(Discount2CaptionLbl; Discount2CaptionLbl)
            {
            }
            column(PRGestionPedidosCliente_Lbl; PRGestionPedidosCliente_Lbl)
            {
            }
            column(FO01_Lbl; FO01_Lbl)
            {
            }
            column(Comentarios_Lbl; Comentarios_Lbl)
            {
            }
            column(DireccionDeEnvio_Lbl; DireccionDeEnvio_Lbl)
            {
            }
            column(ElSubtotalIncluye_Lbl; ElSubtotalIncluye_Lbl)
            {
            }
            column(ZummoInnovaciones_Lbl; ZummoInnovaciones_Lbl)
            {
            }
            column(SegunLoDispuesto_Lbl; SegunLoDispuesto_Lbl)
            {
            }
            column(TFZummo_Lbl; TFZummo_Lbl)
            {
            }
            column(NSerie_Lbl; NSerie_Lbl)
            {

            }
            column(CompanyInfoBankCountNo; BankAccountRecord.IBAN)
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
            column(AlbaranCaption; AlbaranCaptionLbl)
            {
            }
            column(FacturaCaptionLbl; FacturaCaptionLbl)
            {
            }
            column(FechaCaptionLbl; FechaCaptionLbl)
            {
            }
            column(NumeroCaptionLbl; NumeroCaptionLbl)
            {
            }
            column(PaginaCaptionLbl; PaginaCaptionLbl)
            {
            }
            column(ClienteCaptionLbl; ClienteCaptionLbl)
            {
            }
            column(FormadepagoCaptionLbl; FormadepagoCaptionLbl)
            {
            }
            column(VencimientosCaptionLbl; VencimientosCaptionLbl)
            {
            }
            column(TelefonoCaptionLbl; TelefonoCaptionLbl)
            {
            }
            column(FaxCaptionLbl; FaxCaptionLbl)
            {
            }
            column(OperacionaseguradaCaptionLbl; OperacionaseguradaCaptionLbl)
            {
            }
            column(CreditoycaucionCaptionLbl; CreditoycaucionCaptionLbl)
            {
            }
            column(ProteccionDatosCaptionLbl; ProteccionDatosCaptionLbl)
            {
            }
            column(PelemixSLUCaptionLbl; PelemixSLUCaptionLbl)
            {
            }
            column(RegistroMercantilCaptionLbl; RegistroMercantilCaptionLbl)
            {
            }
            column(TextoFacturaCaptionLbl; TextoFacturaCaptionLbl)
            {
            }
            column(TextoRetiraClienteCaptionLbl; TextoRetiraClienteCaptionLbl)
            {
            }
            column(TransportistaCaptionLbl; TransportistaCaptionLbl)
            {
            }
            column(DNICaptionLbl; DNICaptionLbl)
            {
            }
            column(MatriculasCaptionLbl; MatriculasCaptionLbl)
            {
            }
            column(TransportistaText; TransportistaText)
            {
            }
            column(DNItext; DNItext)
            {
            }
            column(MatriculasText; MatriculasText)
            {
            }
            column(LocalidadCaptionLbl; LocalidadCaptionLbl)
            {
            }
            column(DireccioncaptionLbl; DireccioncaptionLbl)
            {
            }
            column(ProvinciaCaptionLbl; ProvinciaCaptionLbl)
            {
            }
            column(EmpresaTransporteText; EmpresaTransporteText)
            {
            }
            column(CIFDNICaptionLbl; CIFDNICaptionLbl)
            {
            }
            column(PrecioenAlhamadeMurciaCaptionLbl; PrecioenAlhamadeMurciaCaptionLbl)
            {
            }
            column(BancoCaptionLbl; BancoCaptionLbl)
            {
            }
            column(ImporteVencimientosCaptionLbl; ImporteVencimientosCaptionLbl)
            {
            }
            column(DtoPPCaptionLbl; DtoPPCaptionLbl)
            {
            }
            column(ImporteIVACaptionLbl; ImporteIVACaptionLbl)
            {
            }
            column(ImporteRecargoCaptionLbl; ImporteRecargoCaptionLbl)
            {
            }
            column(ImportePPCaptionLbl; ImportePPCaptionLbl)
            {
            }
            column(TipoCaptionLbl; TipoCaptionLbl)
            {
            }
            column(BaseImponibleCaptionLbl; BaseImponibleCaptionLbl)
            {
            }
            column(RecCaptionLbl; RecCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(ImporteDescuentoFacturaCaptionLbl; ImporteDescuentoFacturaCaptionLbl)
            {
            }
            column(CPCaptionLbl; CPCaptionLbl)
            {
            }
            column(CopiaCaptionLbl; CopiaCaptionLbl)
            {
            }
            column(OriginalCaption; OriginalCaptionLbl)
            {
            }
            column(AgenteCaptionLbl; AgenteCaptionLbl)
            {
            }
            //Captions

            column(Reimpresion; Reimpresion)
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(CurrencyChange; CurrencyChange) { }

            //SOTHIS EBR 010920 id 159231
            column(logo; CompanyInfo1.LogoCertificacion)
            { }
            //fin SOTHIS EBR 010920 id 159231
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
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
                    column(CustAddr1; "Sales Invoice Header"."Sell-to Customer Name")
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; "Sales Invoice Header"."Bill-to Address" + ' ' + "Sales Invoice Header"."Bill-to Address 2")
                    {
                    }
                    column(SelltoCustNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer No.")
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; "Sales Invoice Header"."Sell-to Post Code")
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; "Sales Invoice Header"."Sell-to City")
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; "Sales Invoice Header"."Sell-to County")
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CustAddr6; UpperCase(nombrePais))
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
                    column(txtEORI; txtEORI) { }
                    column(txtVatEORI; txtVatEORI) { }
                    column(TransportistaRecordNombre; TransportistaRecord.Name)
                    {
                    }
                    //Datos banco

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
                    column(FechaVencimiento4; FechaVencimiento[4])
                    {
                    }
                    column(FechaVencimiento5; FechaVencimiento[5])
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
                    column(ImporteVencimiento4; ImporteVencimiento[4])
                    {
                    }
                    column(ImporteVencimiento5; ImporteVencimiento[5])
                    {
                    }
                    //SOTHIS EBR id 163375 160920
                    column(Delegado; Customer.Delegado_btc)
                    {
                    }
                    //fin SOTHIS EBR id 163375 160920
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
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
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Invoice Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(NumAlbaran; codAlb)
                        {

                        }
                        column(LineaComentarioSerie; LineaComentarioSerie) { }
                        column(numPedido; numPedido)
                        {

                        }

                        column(numPedidoProveedor; numPedidoProveedor)
                        {

                        }
                        column(fechaPedido; format(fechaPedido))
                        {

                        }
                        column(fechaAlbaran; format(fechaAlbaran))
                        {

                        }
                        //Datos lineas cargo
                        column(EsCargo; EsCargo) { }
                        column(NoSerie_Value; NoSerie_Value)
                        {
                        }
                        column(EsEmbalaje; EsEmbalaje) { }
                        column(CargosBase; CargosBase) { }
                        column(CargosIVA; CargosIVA) { }
                        column(CargosRE; CargosRE) { }
                        column(CargosREPer; CargosREPer) { }
                        column(CargosTipoIVA; CargosTipoIVA) { }
                        column(GetCarteraInvoice; GetCarteraInvoice())
                        {
                        }
                        column(LineAmt_SalesInvoiceLine; "Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(Description_SalesInvLine; txtDescLinea)
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
                        column(DecLine_Discount1___btc; "DecLine Discount1 %_btc") { }
                        column(DecLine_Discount2___btc; "DecLine Discount2 %_btc") { }
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
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(DiscountCaption; DiscountCaptionLbl)
                        {
                        }
                        column(AmtCaption; AmtCaptionLbl)
                        {
                        }
                        column(PostedShpDateCaption; PostedShpDateCaptionLbl)
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
                        column(PmtDiscVATCaption; PmtDiscVATCaptionLbl)
                        {
                        }
                        column(Description_SalesInvLineCaption; Decripcion_Lbl)
                        {
                        }
                        column(No_SalesInvoiceLineCaption; FieldCaption("No."))
                        {
                        }
                        column(Quantity_SalesInvoiceLineCaption; Cantidad_lbl)
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
                            DataItemTableView = SORTING(Number);
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
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
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
                            DataItemTableView = SORTING(Number);
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

                        /*###############################################################################################
                                                                INICIO ENSAMBLADO
                            ###############################################################################################*/
                        dataitem("Assemble-to-Order Link"; "Posted Assemble-to-Order Link")
                        {
                            DataItemTableView = sorting("Assembly Document Type");
                            column(AssLink_Document_No_; "Document No.")
                            {
                            }
                            column(AssLink_Document_Type; "Document Type")
                            {
                            }
                            column(AssLink_Document_Line_No_; "Document Line No.")
                            {
                            }
                            dataitem("Assembly Header"; "Posted Assembly Header")
                            {
                                DataItemLink = "No." = field("Assembly Document No.");
                                DataItemTableView = sorting("No.");
                                column(AssHeader_No_;
                                "No.")
                                {
                                }

                                dataitem("Assembly Line"; "Posted Assembly Line")
                                {
                                    DataItemLink = "Document No." = field("No.");
                                    DataItemTableView = sorting("Document No.");
                                    column(Assembly_No; "Document No.")
                                    {
                                    }
                                    column(Assembly_Item_No; "No.")
                                    {
                                    }
                                    column(Assembly_Description; Description)
                                    {
                                    }
                                    column(NoSerieEnsamblado; NoSerieEnsamblado)
                                    {
                                    }

                                    dataitem(SerieEnsamblado; "Item Ledger Entry")
                                    {
                                        DataItemLink = "Document No." = field("Document No."), "Document Line No." = field("Line No.");

                                        column(Item_No_; "Item No.")
                                        {

                                        }

                                        column(Serial_No_; "Serial No.")
                                        {

                                        }
                                    }
                                }
                            }
                            trigger OnPreDataItem()
                            var
                                recPostAssLink: Record "Posted Assemble-to-Order Link";
                            begin
                                recPostAssLink.Reset();
                                recPostAssLink.SetRange("Document Type", recPostAssLink."Document Type"::"Sales Shipment");
                                recPostAssLink.SetRange("Document No.", "Sales Invoice Line"."Shipment No.");
                                recPostAssLink.SETRANGE("Document Line No.", "Sales Invoice Line"."Shipment Line No.");
                                if recPostAssLink.FindFirst() then begin
                                    "Assemble-to-Order Link".SetRange("Document Type", "Assemble-to-Order Link"."Document Type"::"Sales Shipment");
                                    "Assemble-to-Order Link".SetRange("Document No.", "Sales Invoice Line"."Shipment No.");
                                    "Assemble-to-Order Link".SETRANGE("Document Line No.", "Sales Invoice Line"."Shipment Line No.");
                                end else begin
                                    "Assemble-to-Order Link".SetRange("Document Type", "Assemble-to-Order Link"."Document Type"::"Sales Shipment");
                                    "Assemble-to-Order Link".SetRange("Order No.", "Sales Invoice Line"."Order No.");
                                    "Assemble-to-Order Link".SetRange("Order Line No.", "Sales Invoice Line"."Order Line No.");
                                end;

                            end;
                        }
                        /*###############################################################################################
                                                            FIN ENSAMBLADO
                        ###############################################################################################*/

                        dataitem(Lotes; Integer)
                        {
                            DataItemTableView = sorting(number);
                            column(NoLote_RecMemLotes; RecMemLotes.NoLote) { }
                            column(NoSerie_RecMemLotes; RecMemLotes.NoSerie) { }
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
                            recCabAlbaran: Record "Sales Shipment Header";
                            recIt: Record item;
                            TraduccionProducto: Record "Item Translation";
                            recCabPedido: Record "Sales Header";
                            recArchPedido: Record "Sales Header Archive";
                            recSInvLinAux: Record "Sales Invoice Line";
                            recSInvLinAlbaran: record "Sales Invoice Line";
                            codFacturaOrigen: code[20];
                            cduFunciones: Codeunit Funciones;
                            txtAux: Text[100];
                        begin

                            if TraduccionProducto.Get("No.",
                                "Variant Code",
                                 "Sales Invoice Header"."Language Code")
                            then
                                Description := TraduccionProducto.Description;

                            if (Type = Type::"G/L Account") and ("No." = '7591000') then
                                CurrReport.Skip();

                            if (Type = Type::Item) and (recit.Get("No.")) and (recIt."Item Category Code" = 'EMBALAJE') then
                                CurrReport.Skip();

                            if (Type = Type::Item) and (quantity = 0) then
                                CurrReport.Skip();

                            if (Type = Type::Resource) and (quantity = 0) then
                                CurrReport.Skip();

                            txtDescLinea := Description;

                            if (idiomaReport <> '') and (Type = Type::"G/L Account") then begin
                                if idiomaReport <> 'ESP' then begin
                                    clear(cduFunciones);
                                    txtAux := cduFunciones.GetTradDescCuenta("No.", idiomaReport);

                                    if txtAux <> '' then
                                        txtDescLinea := txtaux;
                                end;
                            end;

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
                                /*clear(RecTempLineaAlbaran);
                                RecTempLineaAlbaran.DeleteAll();
                                "Sales Invoice Line".GetSalesShptLines(RecTempLineaAlbaran);*/
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
                                If type = type::"G/L Account" then
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

                            if Type = type::" " then
                                if (StrPos(Description, 'Shipment No.') <> 0) or (StrPos(Description, 'Nº albarán') <> 0) then
                                    CurrReport.Skip();

                            if Type = type::" " then
                                type := Type::Item;

                            numPedido := '';
                            numPedidoProveedor := '';
                            codAlb := '';

                            if "Sales Invoice Line"."Shipment No." <> '' then
                                codAlb := "Sales Invoice Line"."Shipment No."
                            else
                                if "Sales Invoice Line"."Order No." <> '' then begin
                                    recCabPedido.Reset();
                                    recCabPedido.SetRange("Document Type", recCabPedido."Document Type"::Order);
                                    recCabPedido.SetRange("No.", "Sales Invoice Line"."Order No.");
                                    if recCabPedido.FindFirst() then
                                        codAlb := recCabPedido."Last Shipping No."
                                    else begin
                                        recArchPedido.Reset();
                                        recArchPedido.SetRange("Document Type", recArchPedido."Document Type"::Order);
                                        recArchPedido.SetRange("No.", "Sales Invoice Line"."Order No.");
                                        if recArchPedido.FindLast() then
                                            codAlb := recArchPedido."Last Shipping No.";
                                    end;
                                end;

                            IF codAlb <> '' THEN begin
                                if recCabAlbaran.Get(codAlb) then begin
                                    numPedido := recCabAlbaran."Order No.";
                                    numPedidoProveedor := recCabAlbaran."External Document No.";
                                    fechaPedido := recCabAlbaran."Order Date";
                                    fechaAlbaran := recCabAlbaran."Document Date";

                                    recSalesShptLineTmp.Reset();
                                    recSalesShptLineTmp.SetRange("Document No.", recCabAlbaran."No.");
                                    if not recSalesShptLineTmp.FindFirst() then begin
                                        recSalesShptLineTmp.Init();
                                        recSalesShptLineTmp."Document No." := recCabAlbaran."No.";
                                        recSalesShptLineTmp.Insert();

                                        //totalBultos += recCabAlbaran.NumBultos_btc;
                                        //totalPeso += recCabAlbaran.Peso_btc;
                                    end;
                                end;
                            end else begin
                                // Facturas que se crean copiando líneas de abono. Obtenemos nº pedido y nº albarán como se puede, porque tampoco viajan al abono
                                recSInvLinAux.Reset();
                                recSInvLinAux.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                                recSInvLinAux.SetRange(Type, recSInvLinAux.Type::" ");
                                recSInvLinAux.SETFILTER(Description, '%1', 'Nº factura ' + '*');
                                if recSInvLinAux.FindFirst() then begin
                                    codFacturaOrigen := CopyStr(recSInvLinAux.Description, StrPos(recSInvLinAux.Description, 'Nº factura ') + 11);
                                    codFacturaOrigen := DelChr(codFacturaOrigen, '=', ':');

                                    recSInvLinAlbaran.Reset();
                                    recSInvLinAlbaran.setrange("Document No.", codFacturaOrigen);
                                    recSInvLinAlbaran.SetFilter("Order No.", '<>%1', '');
                                    if recSInvLinAlbaran.FindFirst() then begin
                                        recCabPedido.Reset();
                                        recCabPedido.SetRange("Document Type", recCabPedido."Document Type"::Order);
                                        recCabPedido.SetRange("No.", recSInvLinAlbaran."Order No.");
                                        if recCabPedido.FindFirst() then
                                            codAlb := recCabPedido."Last Shipping No."
                                        else begin
                                            recArchPedido.Reset();
                                            recArchPedido.SetRange("Document Type", recArchPedido."Document Type"::Order);
                                            recArchPedido.SetRange("No.", recSInvLinAlbaran."Order No.");
                                            if recArchPedido.FindLast() then
                                                codAlb := recArchPedido."Last Shipping No.";
                                        end;
                                    end;

                                    IF codAlb <> '' THEN
                                        if recCabAlbaran.Get(codAlb) then begin
                                            numPedido := recCabAlbaran."Order No.";
                                            numPedidoProveedor := recCabAlbaran."External Document No.";
                                            fechaPedido := recCabAlbaran."Order Date";
                                            fechaAlbaran := recCabAlbaran."Document Date";

                                            recSalesShptLineTmp.Reset();
                                            recSalesShptLineTmp.SetRange("Document No.", recCabAlbaran."No.");
                                            if not recSalesShptLineTmp.FindFirst() then begin
                                                recSalesShptLineTmp.Init();
                                                recSalesShptLineTmp."Document No." := recCabAlbaran."No.";
                                                recSalesShptLineTmp.Insert();
                                            end;
                                        end;
                                end;
                            end;
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
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
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

                            IF (nLineaIVAActual <= ARRAYLEN(nBaseActual)) THEN BEGIN

                                nBaseActual[nLineaIVAActual] := VATAmountLine."VAT Base";
                                nImporteIVA[nLineaIVAActual] := VATAmountLine."VAT Amount";
                                nDescuento[nLineaIVAActual] := VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount";
                                IF VATAmountLine."EC Amount" = 0 THEN BEGIN
                                    nPorcentajeRE[nLineaIVAActual] := 0;
                                    nRE[nLineaIVAActual] := 0;
                                END
                                ELSE BEGIN
                                    nPorcentajeRE[nLineaIVAActual] := VATAmountLine."EC %";
                                    nRE[nLineaIVAActual] := VATAmountLine."EC Amount";
                                END;

                                IF VATAmountLine."VAT Amount" = 0 THEN
                                    nPorcentajeIVA[nLineaIVAActual] := 0
                                ELSE
                                    nPorcentajeIVA[nLineaIVAActual] := VATAmountLine."VAT %";
                            END;
                            nLineaIVAActual += 1;
                            //FIN BITEC1
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, VATAmountLine.Count());
                            nLineaIVAActual := 1;
                            CLEAR(nImporteIVA);
                            CLEAR(nPorcentajeIVA);
                            CLEAR(nBaseActual);
                            CLEAR(nDescuento);
                        end;
                    }
                    dataitem(VATClauseEntryCounter; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
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
                        DataItemTableView = SORTING(Number);
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
                        DataItemTableView = SORTING(Key);
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
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
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
                        DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = FILTER(1 ..));
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
                        DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number = const(1));
                        column(nBaseActual1; nBaseActual[1]) { }
                        column(nBaseActual2; nBaseActual[2]) { }
                        column(nBaseActual3; nBaseActual[3]) { }
                        column(nImporteIVA1; nImporteIVA[1]) { }
                        column(nImporteIVA2; nImporteIVA[2]) { }
                        column(nImporteIVA3; nImporteIVA[3]) { }
                        column(nPorcentajeIVA1; nPorcentajeIVA[1]) { }
                        column(nPorcentajeIVA2; nPorcentajeIVA[2]) { }
                        column(nPorcentajeIVA3; nPorcentajeIVA[3]) { }
                        column(nRE1; nRE[1]) { }
                        column(nRE2; nRE[2]) { }
                        column(nRE3; nRE[3]) { }
                        column(nPorcentajeRE1; nPorcentajeRE[1]) { }
                        column(nPorcentajeRE2; nPorcentajeRE[2]) { }
                        column(nPorcentajeRE3; nPorcentajeRE[3]) { }
                        column(nDescuento1; nDescuento[1]) { }
                        column(nDescuento2; nDescuento[2]) { }
                        column(nDescuento3; nDescuento[3]) { }
                        column(CargosIVAPorcent; CargosIVAPorcent) { }
                        column(CargosRePorcent; CargosRePorcent) { }
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
                        CODEUNIT.Run(CODEUNIT::"Sales Inv.-Printed", "Sales Invoice Header");
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
                // TotalSalesInvoiceHeader: Record "Sales Invoice Header";
                // TotalSalesInvoiceline: Record "Sales Invoice Line";
                // VATAmount: Decimal;
                // DocumentTotals: Codeunit "Document Totals";
                NomPais: Record "Country/Region";
                InitSalesLine: Record "Sales Invoice Line";
                LineaVentaPortes: Record "Sales Invoice Line";


                SalesInvLine: Record "Sales Invoice Line";
                CostCalcMgt: Codeunit "Cost Calculation Management";
                currency: Record Currency;
                recConfConta: record "General Ledger Setup";
                recSalesInvLinePeso: Record "Sales Invoice Line";
                cdaFunciones: Codeunit Funciones;
            begin
                totalBultos := 0;
                totalPeso := 0;
                totalPalets := 0;

                totalBultos := NumBultos_btc;
                totalPeso := Peso_btc;
                totalPalets := NumPalets_btc;

                if totalPeso = 0 then begin
                    recSalesInvLinePeso.Reset();
                    recSalesInvLinePeso.SetRange("Document No.", "No.");
                    recSalesInvLinePeso.SetFilter("Gross Weight", '<>%1', 0);
                    if recSalesInvLinePeso.FindSet() then
                        repeat
                            totalPeso += recSalesInvLinePeso."Gross Weight" * recSalesInvLinePeso.Quantity;
                        until recSalesInvLinePeso.Next() = 0;
                end;

                recSalesShptLineTmp.Reset();
                recSalesShptLineTmp.DeleteAll();

                TotalSalesInvoiceHeader.Reset();
                TotalSalesInvoiceHeader.SetRange("No.", "No.");
                TotalSalesInvoiceHeader.FindFirst();
                if NomPais.get("Sell-to Country/Region Code") then
                    nombrePais := NomPais.Name;

                TotalSalesInvoiceline.Reset();
                TotalSalesInvoiceline.SetRange("Document No.", "No.");
                TotalSalesInvoiceline.FindFirst();

                CurrReport.Language := Language.GetLanguageID("Language Code");
                FormatAddressFields("Sales Invoice Header");
                FormatDocumentFields("Sales Invoice Header");
                DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoiceHeader, VATAmount2, TotalSalesInvoiceline);

                workdescription := GetWorkDescription();
                Portes := 0;
                LineaVentaPortes.Reset();
                LineaVentaPortes.SetRange("Document No.", "No.");
                // LineaVentaPortes.SetRange(Type, LineaVentaPortes.Type::"G/L Account");
                LineaVentaPortes.SetRange("No.", '7591000');
                if LineaVentaPortes.FindSet then
                    repeat
                        Portes := Portes + LineaVentaPortes."Line Amount";
                    until LineaVentaPortes.Next = 0;
                //calculo descuento pronto pago
                ImportePP := (TotalSalesInvoiceHeader."Amount Including VAT" - VATAmount2) - TotalSalesInvoiceHeader.Amount - TotalSalesInvoiceHeader."Invoice Discount Amount";
                ivafactura := 0;
                InitSalesLine.Reset;
                InitSalesLine.SetRange("Document No.", "No.");
                InitSalesLine.Setfilter("VAT %", '<>0');
                if InitSalesLine.FindFirst then
                    ivafactura := InitSalesLine."VAT %";

                // Descuento porcentaje factura
                porcentDescuento := 0;

                if (TotalSalesInvoiceHeader."Invoice Discount Value" + TotalSalesInvoiceHeader.Amount - Portes) > 0 then
                    porcentDescuento := (TotalSalesInvoiceHeader."Invoice Discount Amount" * 100) / (TotalSalesInvoiceHeader."Invoice Discount Amount" - Portes + TotalSalesInvoiceHeader.Amount);
                // 165646 JJV antes Value -> Amount porcentDescuento := (TotalSalesInvoiceHeader."Invoice Discount Value" * 100) / (TotalSalesInvoiceHeader."Invoice Discount Value" - Portes + TotalSalesInvoiceHeader.Amount);

                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust)
                else begin
                    CurrReport.Language := Language.GetLanguageID(Cust."Language Code");
                    idiomaReport := Cust."Language Code";
                end;

                if optIdioma <> optIdioma::" " then begin
                    CurrReport.LANGUAGE := Language.GetLanguageID(format(optIdioma));
                    idiomaReport := format(optIdioma);
                end;

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                Customer.Get("Sell-to Customer No.");
                if (BankAccountRecord.Get("Sell-to Customer No.", Customer."Preferred Bank Account Code")) and (
                    "Payment Method Code" = 'GIRO') then
                    ;
                GetLineFeeNoteOnReportHist("No.");

                OnAfterGetRecordSalesInvoiceHeader("Sales Invoice Header");
                OnGetReferenceText("Sales Invoice Header", ReferenceText, Handled);

                MovsCliente.SETRANGE("Document No.", "No.");
                MovsCliente.SETFILTER("Document Type", '%1', MovsCliente."Document Type"::Bill);
                MovsCliente.SETRANGE("Customer No.", "Bill-to Customer No.");

                MovsCliente.SETRANGE("Posting Date", "Posting Date");
                IF NOT MovsCliente.FINDSET() THEN BEGIN
                    MovsCliente.SETFILTER("Document Type", '%1', MovsCliente."Document Type"::Invoice);
                    IF NOT MovsCliente.FINDSET() THEN
                        EXIT;
                END;
                intContador := 1;
                REPEAT
                    FechaVencimiento[intContador] := MovsCliente."Due Date";
                    MovsCliente.CALCFIELDS("Amount (LCY)");
                    ImporteVencimiento[intContador] := MovsCliente."Amount (LCY)";
                    intContador := intContador + 1;
                UNTIL MovsCliente.NEXT() = 0;

                /*#########################################################################################################################
                                                                INICIO TOTALES
                #########################################################################################################################*/
                clear(importeiva);
                CLEAR(SalesInvLine);
                clear(CustAmount);
                clear(AmountInclVAT);
                clear(InvDiscAmount);
                clear(PmtDiscAmount);
                clear(CostLCY);
                clear(LineQty);
                clear(TotalNetWeight);
                clear(TotalGrossWeight);
                clear(TotalVolume);
                clear(TotalParcels);
                clear(VATPercentage);
                clear(VATAmount);
                clear(CostCalcMgt);

                IF "Currency Code" = '' THEN
                    currency.InitRoundingPrecision
                ELSE
                    currency.GET("Currency Code");

                SalesInvLine.SETRANGE("Document No.", "No.");
                IF SalesInvLine.FIND('-') THEN
                    REPEAT
                        CustAmount := CustAmount + SalesInvLine.Amount;
                        AmountInclVAT := AmountInclVAT + SalesInvLine."Amount Including VAT";

                        IF "Prices Including VAT" THEN BEGIN
                            InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount" /
                                (1 + (SalesInvLine."VAT %" + SalesInvLine."EC %") / 100);
                            PmtDiscAmount := PmtDiscAmount + SalesInvLine."Pmt. Discount Amount" /
                                (1 + (SalesInvLine."VAT %" + SalesInvLine."EC %") / 100)
                        END ELSE BEGIN
                            InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount";
                            PmtDiscAmount := PmtDiscAmount + SalesInvLine."Pmt. Discount Amount";
                        END;

                        CostLCY := CostLCY + (SalesInvLine.Quantity * SalesInvLine."Unit Cost (LCY)");
                        LineQty := LineQty + SalesInvLine.Quantity;
                        TotalNetWeight := TotalNetWeight + (SalesInvLine.Quantity * SalesInvLine."Net Weight");
                        TotalGrossWeight := TotalGrossWeight + (SalesInvLine.Quantity * SalesInvLine."Gross Weight");
                        TotalVolume := TotalVolume + (SalesInvLine.Quantity * SalesInvLine."Unit Volume");

                        IF SalesInvLine."Units per Parcel" > 0 THEN
                            TotalParcels := TotalParcels + ROUND(SalesInvLine.Quantity / SalesInvLine."Units per Parcel", 1, '>');

                        IF SalesInvLine."VAT %" <> VATPercentage THEN
                            IF VATPercentage = 0 THEN
                                VATPercentage := SalesInvLine."VAT %" + SalesInvLine."EC %"
                            ELSE
                                VATPercentage := -1;

                        TotalAdjCostLCY :=
                        TotalAdjCostLCY + CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine) +
                        CostCalcMgt.CalcSalesInvLineNonInvtblCostAmt(SalesInvLine);
                    UNTIL SalesInvLine.NEXT = 0;

                VATAmount := AmountInclVAT - CustAmount;
                InvDiscAmount := ROUND(InvDiscAmount, currency."Amount Rounding Precision");


                importeiva := VATAmount;
                /*#########################################################################################################################
                                                                FIN TOTALES
                #########################################################################################################################*/

                codigoDivisa := '';

                if "Sales Invoice Header"."Currency Code" <> '' then
                    codigoDivisa := "Sales Invoice Header"."Currency Code"
                else begin
                    recConfConta.get();
                    if recConfConta."LCY Code" <> '' then
                        codigoDivisa := recConfConta."LCY Code"
                    else
                        codigoDivisa := 'EUR';
                end;

                // buscamos la fecha de operacion del SII en otra extension
                FechaOperacion := cdaFunciones.GetExtensionFieldValueDate("Sales Invoice Header".RecordId, 66600, false);

                // ZUMMO UK  si tiene codigo EORI, es que es para venta en UK, ponemos el pais a ES  GETDATA(60
                if cust.EORI <> '' then
                    if NomPais.get(CompanyInfo."Country/Region Code") then
                        nombrePais := NomPais.Name;
                // ponemos con el IVA el EORI
                if Cust.EORI = '' then begin
                    txtVatEORI := '';
                    txtEORI := '';
                end else begin
                    txtVatEORI := Cust.EORI;
                    txtEORI := lblEORI;
                end;
            end;

            trigger OnPostDataItem()
            begin
                OnAfterPostDataItem("Sales Invoice Header");
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
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies', Comment = 'ESP="Núm. Copias"';
                        ToolTip = 'Specifies how many copies of the document to print.', Comment = 'ESP="Especifica cuántas copias del documento se imprimirán"';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information', Comment = 'ESP="Ver información interna"';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.',
                            Comment = 'ESP="Especifica si se desea ver información interna del informe"';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction', Comment = 'ESP="Log Interacción"';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.', Comment = 'ESP="Especifica si se guardará interacción con el contacto"';
                    }
                    field(DisplayAsmInformation; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components', Comment = 'ESP="Ver componentes de ensamblado"';
                        ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.',
                            Comment = 'ESP="Especifica si el informe incluirá información sobre los componentes de ensamblado"';
                    }
                    field(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Additional Fee Note', Comment = 'ESP="Mostrar nota de tarifa adicional"';
                        ToolTip = 'Specifies that any notes about additional fees are included on the document.',
                            Comment = 'ESP="Especifica que cualquier nota sobre tarifas adicionales se incluye en el documento"';
                    }

                    field(Reimpresion; Reimpresion)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Print again', Comment = 'ESP="Volver a Imprimir"';
                        ToolTip = 'Check the option to reprint a copy', Comment = 'ESP="Marca la opción de volver a imprimir una copia"';
                    }

                    field(facturaLidl; facturaLidl)
                    {
                        ApplicationArea = All;
                        Caption = 'Lidl Invoice', comment = 'ESP="Factura Lidl"';
                        ToolTip = 'Indicate that is a Lidl invoice', comment = 'ESP="Indica que es una factura Lidl"';
                    }

                    field(facturaExportacion; facturaExportacion)
                    {
                        ApplicationArea = All;
                        Caption = 'Export Invoice', comment = 'ESP="Factura Exportación"';
                        ToolTip = 'Indicate that is a exportation invoice', comment = 'ESP="Indica que es una factura de exportación"';
                    }

                    field(optIdioma; optIdioma)
                    {
                        ApplicationArea = All;
                        Caption = 'Language', comment = 'ESP="Idioma"';
                    }
                    field(volumen; volumen)
                    {
                        ApplicationArea = All;
                        Caption = 'Volume(m3)', comment = 'ESP="Volumen(m3)"';
                        ToolTip = 'Indicates the volume of products in m3', comment = 'ESP="Indica el volumen de los productos en m3"';
                    }

                    field(mostrarNetos; mostrarNetos)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Net', comment = 'ESP="Mostrar Netos"';
                        ToolTip = 'If the invoice is national, it is possible to show the net amounts', comment = 'ESP="Si la factura es nacional, se da la posibilidad de mostrar los importes netos"';

                        trigger OnValidate()
                        var
                            lbErrorErr: label 'Option only available on national invoice', Comment = 'ESP="Opción solo disponible en factura nacional"';
                        begin
                            if facturaLidl or facturaExportacion then begin
                                message(lbErrorErr);

                                Error('');

                                //RequestOptionsPage.Update(false);
                            end;
                        end;
                    }
                    field(MostrarFechaOperacion; MostrarFechaOperacion)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Operation Date', comment = 'ESP="Mostrar Fecha Operacion"';
                        ToolTip = 'If the invoice is national, it is possible to show the net amounts', comment = 'ESP="Si la factura es nacional, se da la posibilidad de mostrar los importes netos"';
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
            NoOfCopies := 0;

            if facturaLidl or facturaExportacion then
                mostrarNetos := true
            else
                mostrarNetos := false;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        SalesSetup.Get();
        CompanyInfo.Get();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        CompanyInfo1.Get();
        CompanyInfo1.CalcFields(Picture);

        //SOTHIS EBR 010920 id 15923
        CompanyInfo1.CalcFields(LogoCertificacion);
        //fin SOTHIS EBR 010920 id 15923

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
    //Variables
    var
        CustAmount: decimal;
        porcentDescuento: Decimal;
        mostrarNetos: Boolean;
        codigoDivisa: code[20];
        AmountInclVAT: decimal;
        InvDiscAmount: decimal;
        PmtDiscAmount: decimal;
        CostLCY: decimal;
        LineQty: decimal;
        TotalNetWeight: decimal;
        TotalGrossWeight: decimal;
        TotalVolume: decimal;
        TotalParcels: decimal;
        VATPercentage: decimal;
        VATAmount: decimal;
        TotalAmount2: Decimal;
        TotalAmount1: Decimal;
        importeiva: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        TotalAdjCostLCY: Decimal;
        AdjProfitLCY: decimal;
        AdjProfitPct: Decimal;
        TotalSalesInvoiceHeader: Record "Sales Invoice Header";
        TotalSalesLineF: Record "Sales Invoice Line";
        TotalSalesLineLCYF: Record "Sales Invoice Line";
        Portes: Decimal;
        nombrePais: Text[50];
        workdescription: Text;
        ImportePP: Decimal;
        ivafactura: Decimal;
        TotalSalesInvoiceline: Record "Sales Invoice Line";
        VATAmount2: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        RecCuenta: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        BankAccountRecord: Record "Customer Bank Account";
        idiomaReport: code[10];
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
        volumen: Decimal;
        //RecSalesLines: Record "Sales Invoice Line";
        SalesShipmentBuffer: Record "Sales Shipment Buffer" temporary;
        recSalesShptLineTmp: Record "Sales Shipment Line" temporary;
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
        totalBultos: Decimal;
        totalPeso: decimal;
        totalPalets: Decimal;
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        VATPostingSetup: Record "VAT Posting Setup";
        PaymentMethod: Record "Payment Method";
        RecBankPrevisto: Record "Bank Account";
        RecMemLotes: Record MemEstadistica_btc temporary;
        //RecGeneralLedgerSetup: Record "General Ledger Setup";
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
        MatriculasText: Text[50];
        TransportistaText: Text[50];
        EmpresaTransporteText: Text[50];
        DNItext: Code[9];
        CodDivisa: Code[20];
        NoSerie_Value: Code[50];
        numPedido: Code[20];
        numPedidoProveedor: code[35];
        NoSerieEnsamblado: code[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        intContador: Integer;
        FechaVencimiento: array[5] of Date;
        ImporteVencimiento: array[5] of Decimal;
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
        Text007Txt: Label 'VAT Amount Specification in ', Comment = 'ESP="Especificación del importe del IVA en"';
        Text008Txt: Label 'Local Currency', Comment = 'ESP="Divisa Local"';
        VALExchRate: Text[50];
        Text009Txt: Label 'Exchange rate: %1/%2', Comment = 'ESP="Tipo de cambio: %1/%2"';
        CalculatedExchRate: Decimal;
        Text010Txt: Label 'Sales - Prepayment Invoice %1', Comment = 'ESP="Ventas - Factura Prepago %1"';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        //Variables IVA
        //TotalImporte: Decimal;
        nImporteIVA: array[3] of Decimal;
        nPorcentajeIVA: array[3] of Decimal;
        nBaseActual: array[3] of Decimal;
        nRE: array[3] of Decimal;
        nPorcentajeRE: array[3] of Decimal;
        nDescuento: array[3] of Decimal;
        //nLineaActual: Integer;
        nLineaIVAActual: Integer;
        TotalGivenAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        Reimpresion: Boolean;
        facturaLidl: boolean;
        facturaExportacion: Boolean;
        txtDescLinea: text[100];

        PhoneNoCaptionLbl: Label 'Phone No.', Comment = 'ESP="Teléfono."';
        VATRegNoCaptionLbl: Label 'VAT Registration No.', Comment = 'ESP="CIF"';
        GiroNoCaptionLbl: Label 'Giro No.', Comment = 'ESP="Núm. Giro"';
        BankNameCaptionLbl: Label 'Bank', Comment = 'ESP="Banco"';
        BankAccNoCaptionLbl: Label 'Account No.', Comment = 'ESP="Núm. Cuenta"';
        DueDateCaptionLbl: Label 'Due Date', Comment = 'ESP="Fecha Vencimiento"';
        InvoiceNoCaptionLbl: Label 'Invoice No.', Comment = 'ESP="Núm. Factura"';
        PostingDateCaptionLbl: Label 'Posting Date', Comment = 'ESP="Fecha registro"';
        HdrDimsCaptionLbl: Label 'Header Dimensions', Comment = 'ESP="Dimensión cabecera"';
        LocalidadCaptionLbl: Label 'City', Comment = 'ESP="Localidad"';
        PmtinvfromdebtpaidtoFactCompCaptionLbl: Label 'The payment of this invoice, in order to be released from the debt, has to be paid to the Factoring Company.',
            Comment = 'ESP="El pago de esta factura, para ser liberado de la deuda, debe ser pagado a la Compañía de Factoring."';
        UnitPriceCaptionLbl: Label 'Price/unit', Comment = 'ESP="Precio U.",FRA="Prix/un"';
        DiscountCaptionLbl: Label 'Dto.1', Comment = 'ESP="Dto.1"';
        Discount2CaptionLbl: Label 'Dto.2', Comment = 'ESP="Dto.2"';
        AmtCaptionLbl: Label 'Amount', Comment = 'ESP="Importe",FRA="Montant"';
        BancoCaptionLbl: Label 'Bank data', Comment = 'ESP="Datos bancarios"';
        VATClausesCapLbl: Label 'VAT Clause', Comment = 'ESP="Cláusula IVA"';
        ProvinciaCaptionLbl: Label 'State', Comment = 'ESP="Provincia"';
        PrecioenAlhamadeMurciaCaptionLbl: Label 'Precio en Alhama de Murcia', Comment = 'ESP="Precio en Alhama de Murcia"';
        PostedShpDateCaptionLbl: Label 'Posted Shipment Date', Comment = 'ESP="Fecha de envío publicada"';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount', Comment = 'ESP="Importe descuento factura"';
        SubtotalCaptionLbl: Label 'Taxable Base', Comment = 'ESP="Base Imponible"';
        PmtDiscGivenAmtCaptionLbl: Label 'Payment Disc Given Amount', Comment = 'ESP="Descuento de pago Cantidad dada"';
        PmtDiscVATCaptionLbl: Label 'Payment Discount on VAT', Comment = 'ESP="Descuento de pago en IVA"';
        ShpCaptionLbl: Label 'Shipment', Comment = 'ESP="Envío"';
        LineDimsCaptionLbl: Label 'Line Dimensions', Comment = 'ESP="Dimensiones Línea"';
        VATAmtLineVATCaptionLbl: Label 'VAT %', Comment = 'ESP="% IVA"';
        VATECBaseCaptionLbl: Label 'VAT+EC Base', Comment = 'ESP="IVA+EC Base"';
        VATAmountCaptionLbl: Label 'VAT Amount', Comment = 'ESP="Importe IVA"';
        VATAmtSpecCaptionLbl: Label 'VAT Amount Specification', Comment = 'ESP="Especificación importe IVA"';
        VATIdentCaptionLbl: Label 'VAT Identifier', Comment = 'ESP="Identificador IVA"';
        InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount', Comment = 'ESP="Base descuento factura"';
        LineAmtCaption1Lbl: Label 'Line Amount', Comment = 'ESP="Importe línea"';
        InvPmtDiscCaptionLbl: Label 'Invoice and Payment Discounts', Comment = 'ESP="Descuentos en facturas y pagos"';
        ECAmtCaptionLbl: Label 'EC Amount', Comment = 'ESP="Importe EC"';
        ECCaptionLbl: Label 'EC %', Comment = 'ESP="EC %"';
        VALVATBaseLCYCaption1Lbl: Label 'VAT Base', Comment = 'ESP="Base IVA"';
        DireccioncaptionLbl: Label 'Address:', Comment = 'ESP="Dirección:"';
        VATAmtCaptionLbl: Label 'VAT Amount', Comment = 'ESP="Importe IVA"';
        VATIdentifierCaptionLbl: Label 'VAT Identifier', Comment = 'ESP="Identificador IVA"';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address', Comment = 'ESP="Envío a dirección"';
        PmtTermsDescCaptionLbl: Label 'Payment Terms', Comment = 'ESP="Términos Pago",FRA="Conditions de Paiement"';
        ShpMethodDescCaptionLbl: Label 'Shipment Method', Comment = 'ESP="Método Envío"';
        PmtMethodDescCaptionLbl: Label 'Payment Terms', Comment = 'ESP="Método Pago",FRA="Conditions de Paiement"';
        DocDateCaptionLbl: Label 'Document Date', Comment = 'ESP="Fecha emisión"';
        HomePageCaptionLbl: Label 'Home Page', Comment = 'ESP="Página Web"';
        EmailCaptionLbl: Label 'Email', Comment = 'ESP="Email"';
        FacturaCaptionLbl: Label 'INVOICE', Comment = 'ESP="FACTURA",FRA="FACTURE"';
        FormadepagoCaptionLbl: Label 'Payment Terms', Comment = 'ESP="Forma de Pago",FRA="Conditions de Paiement"';
        ClienteCaptionLbl: Label 'Customer', Comment = 'ESP="Cliente",FRA="Client"';
        FechaCaptionLbl: Label 'Date', Comment = 'ESP="Fecha"';
        NumeroCaptionLbl: Label 'Num.', Comment = 'ESP="Núm."';
        PaginaCaptionLbl: Label 'Page', Comment = 'ESP="Página"';
        ImporteDescuentoFacturaCaptionLbl: Label 'Amount Dto. bill', Comment = 'ESP="Importe Dto. Factura"';
        VencimientosCaptionLbl: Label 'Payment Date Expiration (s)', Comment = 'ESP="Fecha Pago Vencimiento(s)",FRA="Expiration de la date de paiement(s)"';
        ImporteVencimientosCaptionLbl: Label 'Expiration Amount (s)', Comment = 'ESP="Importe Vencimiento(s)",FRA="Montant (s) d´expiration"';
        CIFDNICaptionLbl: Label 'VAT:', Comment = 'ESP="NIF:",FRA="Nº de Siret"';
        CPCaptionLbl: Label 'PC:', Comment = 'ESP="CP:"';
        OperacionaseguradaCaptionLbl: Label 'Operation secured in', Comment = 'ESP="Operación asegurada en"';
        CreditoycaucionCaptionLbl: Label 'Credit and caution', Comment = 'ESP="Crédito y Caución"';
        TelefonoCaptionLbl: Label 'Phone/Fax:', Comment = 'ESP="Tel/Fax:",FRA="Tél/Fax:"';
        FaxCaptionLbl: Label 'Fax', Comment = 'ESP="Fax"';
        OriginalCaptionLbl: Label 'ORIGINAL', Comment = 'ESP="ORIGINAL"';
        CopiaCaptionLbl: Label 'COPY', Comment = 'ESP="COPIA"';
        //DivisaCaptionLbl: Label '€';
        ProteccionDatosCaptionLbl: Label 'PERSONAL DATA PROTECTION', Comment = 'ESP="PROTECCION DE DATOS DE CARÁCTER PERSONAL"';
        PelemixSLUCaptionLbl: Label 'PELEMIX, S.L.U.-N.I.F.: B-73255622', Comment = 'ESP="PELEMIX, S.L.U.-N.I.F.: B-73255622"';
        TextoRetiraClienteCaptionLbl: Label 'Retira el cliente por sus propios medios a traves de ',
            Comment = 'ESP="Retira el cliente por sus propios medios a traves de "';
        TransportistaCaptionLbl: Label 'Shipping Agent:', Comment = 'ESP="Transportista:"';
        DNICaptionLbl: Label 'DNI:', Comment = 'ESP="DNI:"';
        MatriculasCaptionLbl: Label 'License plates', Comment = 'ESP="Matriculas"';
        AgenteCaptionLbl: Label 'Agent:', Comment = 'ESP="Agente:",FRA="Agent:"';
        RegistroMercantilCaptionLbl: Label 'Inscrita en el registro mercantil de Murcia, tomo 2028,folio 11, hoja MU-43705 inscripcion 1ª',
            Comment = 'ESP="Inscrita en el registro mercantil de Murcia, tomo 2028,folio 11, hoja MU-43705 inscripcion 1ª"';
        TextoFacturaCaptionLbl: Label 'Esta factura sólo debe pagarse utilizando los datos bancarios reflejados arriba. Cualquier cambio indicado por otros medios debe considerarse válido',
            Comment = 'ESP="Esta factura sólo debe pagarse utilizando los datos bancarios reflejados arriba. Cualquier cambio indicado por otros medios debe considerarse válido"';
        CACCaptionLbl: Text;
        CACTxt: Label 'Special scheme of the cash criteria', Comment = 'ESP="Régimen especial del criterio de caja"';
        CuadroBultos_BultosLbl: Label 'Bulks:', comment = 'ESP="Bultos:",FRA="Bulks:"';
        CuadroBultos_IncotermLbl: Label 'INCOTERM:', comment = 'ESP="INCOTERM:"';
        CuadroBultos_VolumenLbl: Label 'Volume(m3):', comment = 'ESP="Volumen(m3):",FRA="Volume(m3):"';
        CuadroBultos_PesoNetoLbl: Label 'Gross Weight(kg):', comment = 'ESP="Peso Neto(kg):",FRA="Gross Weight(kg):"';
        CuadroBultos_PaletsLbl: Label 'Pallets:', comment = 'ESP="Palets:",FRA="Palettes"';
        Text004Txt: Label 'Sales - Invoice %1', Comment = 'Ventas - Factura %1';
        PageCaptionCapLbl: Label 'Page %1 of %2', Comment = 'ESP="Página %1 de %2"';
        TotalCaptionLbl: Label 'Total', Comment = 'ESP="Total"';
        ImporteRecargoCaptionLbl: Label 'Surcharge Amount', Comment = 'ESP="Importe Recargo"';
        //PorIvaCaptionLbl: Label '%IVA';
        DtoPPCaptionLbl: Label 'Dt. P.P.', Comment = 'ESP="Dto. P.P."';
        ImportePPCaptionLbl: Label 'Amount P.P.', Comment = 'ESP="Importe P.P."';
        BaseImponibleCaptionLbl: Label 'Taxable Base', Comment = 'ESP="Base Imponible"';
        RecCaptionLbl: Label 'Rec.', Comment = 'ESP="Rec."';
        ImporteIVACaptionLbl: Label 'VAT Amount.', Comment = 'ESP="ImporteIVA."';
        TipoCaptionLbl: Label 'Type', Comment = 'ESP="Tipo"';
        AlbaranCaptionLbl: Label 'Shipping No.:', Comment = 'ESP="Albarán:"';
        //Labels
        BancoPais_Lbl: Label 'Country:', Comment = 'ESP="País:"';
        BancoNombre_Lbl: Label ', Bank:', Comment = 'ESP=", Banco:"';
        BancoCuenta_Lbl: Label 'Account:', Comment = 'ESP="Cuenta"';
        BancoBicSwift_Lbl: Label 'BIC/Swift:', Comment = 'ESP="BIC/Swift:"';
        BancoIBAN_Lbl: Label 'IBAN:', Comment = 'ESP="IBAN"';
        BancoSucursal_Lbl: Label 'Branch office:', Comment = 'ESP="Sucursal:"';
        PortesNacionalLbl: Label 'NATIONAL PORTES', Comment = 'ESP="PORTES NACIONAL"';
        NoAlbaran_Lbl: Label 'Delivery Note:', Comment = 'ESP="Nº Albarán:",FRA="Bordereau d´expédition:"';
        NoPedido_Lbl: Label 'Order number:', Comment = 'ESP="Nº Pedido:",FRA="Nº commande:"';
        NoAlbaranLidl_Lbl: Label 'Delivery Note:', Comment = 'ESP="Nº Albarán:",FRA="Bordereau d´expédition:"';
        NoPedidoLidl_Lbl: Label 'ProShop Order No.:', Comment = 'ESP="Nº Pedido ProShop:"';
        NoPedidoInternoProveedorLidl_Lbl: label 'Internal vendor order No.', comment = 'ESP="Nº Pedido interno del proveedor"';
        Tel_Lbl: Label 'Phone:', Comment = 'ESP="Tel:",FRA="Tél:"';
        BaseImponible_Lbl: Label 'Tax base', Comment = 'ESP="Base imponible"';
        txtcomentaires: label 'Comments', comment = 'ESP="Comentarios",FRA="Commentaires"';
        Base_Lbl: Label 'Tax Base', Comment = 'ESP="Base",FRA="Base"';
        IVA_Lbl: Label 'VAT', Comment = 'ESP="IVA",FRA="TVA"';
        Porcentaje_Lbl: Label '%', Comment = 'ESP="%"';
        RE_Lbl: Label 'R.E.', Comment = 'ESP="R.E."';
        Importe_Lbl: Label 'Amount', Comment = 'ESP="Importe",FRA="Quantité"';
        ImporteBruto_Lbl: Label 'Amount', Comment = 'ESP="Importe Bruto",FRA="Suos_Total"';
        DtoGeneral_Lbl: Label 'Disc.Com', Comment = 'ESP="Dto.Com",FRA="Rem."';
        DtoPP_Lbl: Label 'P.P.Disc', Comment = 'ESP="Dto.PP",FRA="Esc.P.C."';
        Portes_Lbl: Label 'Freight', Comment = 'ESP="Portes",FRA="Fret"';
        SubTotal_Lbl: Label 'Tax Base', Comment = 'ESP="SubTotal",FRA="Bases H.T."';
        Articulo_Lbl: Label 'Item', Comment = 'ESP="Artículo",FRA="Article"';
        Cantidad_Lbl: Label 'Quantity', comment = 'ESP="Cantidad",FRA="Quantité"';
        Decripcion_Lbl: Label 'Description', comment = 'ESP="Descripción",FRA="Description"';
        PRGestionPedidosCliente_Lbl: Label 'PR-MANAGEMENT OF CUSTOMER ORDERS', Comment = 'ESP="PR-GESTION DE LOS PEDIDOS DEL CLIENTE"';
        FO01_Lbl: Label 'FO.01_C8.01_V12', Comment = 'ESP="FO.01_C8.01_V12"';
        Comentarios_Lbl: Label 'Remark', Comment = 'ESP="Comentarios",FRA="Commentaires"';
        DireccionDeEnvio_Lbl: Label 'Delivery Address', Comment = 'ESP="Dirección de envío",FRA="Adresse d´expédition"';
        ElSubtotalIncluye_Lbl: Label 'El subtotal incluye el coste de gestión de los RAEES según Real Decreto 110/2015, de 20 de febrero, sobre residuos de aparatos eléctricos y electrónicos (BOE de 21/02/2015)',
            Comment = 'ESP="El subtotal incluye el coste de gestión de los RAEES según Real Decreto 110/2015, de 20 de febrero, sobre residuos de aparatos eléctricos y electrónicos (BOE de 21/02/2015)"';
        SegunLoDispuesto_Lbl: Label 'As provided by Regulation (EU) 2016/769 of the European Parliament and of the Council of April 27, 2016 regarding the protection of natural persons, we inform you that your data will be incorporated into the treatment system owned by ZUMMO MECHANICAL INNOVATIONS, SA - in order to be able to send you the corresponding invoice. You may exercise the rights of access, rectification, limitation of treatment, deletion, portability and opposition / revocation, in the terms established by current regulations on data protection, by sending your request to the postal address indicated above, you can also address to the competent Control Authority to submit the claim it deems appropriate.',
            Comment = 'ESP="Según lo Dispuesto por el Reglamento (UE) 2016/769 del Parlamento Europeo y del Consejo de 27 de abril de 2016 relativo a la protección de las personas físicas, le informamos que sus datos serán incorporados al sistema de tratamiento titularidad de ZUMMO INNOVACIONES MECÁNICAS, S.A. - con la finalidad de poder remitirle la correspondiente factura. Podrá ejercer los derechos de acceso, rectificación, limitación de tratamiento, supresión, portabilidad y oposición/revocación, en los términos que establece la normativa vigente en materia de protección de datos, dirigiendo su petición a la dirección postal arriba indicada, asimismo, podrá dirigirse a la Autoridad de Control competente para presentar la reclamación que considere oportuna."';
        ZummoInnovaciones_Lbl: Label 'Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia el 26 de enero de 1999, Tomo 4336, Libro 1648, Sección Gral., Folio 212, hoja Y-22381, Inscripción 1ª CIF A-9Nº R.I. Productor AEE 288',
            Comment = 'ESP="Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia on January 26, 1999, Volume 4336, Book 1648, General Section, Folio 212, page Y-22381, Registration 1st CIF A-9Nº R.I. AEE producer 288"';
        TFZummo_Lbl: Label 'T +34 961 301 246| F +34 961 301 250| zummo@zummo.es| Cádiz, 4.46113 Moncada.Valencia.Spain|www.zummo.es',
            Comment = 'ESP="T +34 961 301 246| F +34 961 301 250| zummo@zummo.es| Cádiz, 4.46113 Moncada.Valencia.Spain|www.zummo.es"';
        NSerie_Lbl: Label 'Serial No.:', Comment = 'ESP="Nº de Serie:"';
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
        fechaPedido: date;
        fechaAlbaran: date;
        optIdioma: Option " ","ENU","ESP","FRA";
        codAlb: code[20];
        FechaOperacion: date;
        Text0010Txt: Label 'Operation Date', Comment = 'ESP="Fecha Operación"';
        MostrarFechaOperacion: Boolean;
        lblEORI: Label 'EORI: ', comment = 'ESP="EORI: "';
        lblVat: Label 'VAT: ', comment = 'ESP="VAT: "';

        txtVatEORI: Text;
        txtEORI: text;

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
        IF CargosTipoIVA <> 0 THEN
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
        IF ValueEntryRelation.FINDFIRST() THEN
            REPEAT
                ValueEntry.GET(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
                ItemLedgEntry.CALCFIELDS("Sales Amount (Actual)");
                RecMemEstadisticas.RESET();
                RecMemEstadisticas.SETRANGE(NoLote, ItemLedgEntry."Serial No.");
                IF NOT RecMemEstadisticas.FINDFIRST() THEN BEGIN
                    RecMemEstadisticas.INIT();
                    RecMemEstadisticas.NoMov := NumMov;
                    NumMov += 1;
                    RecMemEstadisticas.NoLote := ItemLedgEntry."Lot No.";
                    RecMemEstadisticas.NoSerie := ItemLedgEntry."Serial No.";
                    RecMemEstadisticas.Noproducto := ItemLedgEntry."Item No.";
                    RecMemEstadisticas.INSERT();
                END;

            UNTIL ValueEntryRelation.NEXT() = 0;
    end;

    procedure EsExportacion()
    begin
        facturaExportacion := true;
        facturaLidl := false;
    end;

    procedure EsLidl()
    begin
        facturaLidl := true;
        facturaExportacion := false;
    end;

    procedure EsNacional()
    begin
        facturaLidl := false;
        facturaExportacion := false;
    end;
}

