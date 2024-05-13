report 50103 "AlbaranVenta"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50103.AlbaranVenta.rdl';
    Caption = 'Albaran Venta', Comment = 'ESP="Sales Shipment"';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions = tabledata "Item Ledger Entry" = rmid;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Histórico albaranes venta', Comment = 'ESP="Posted Sales Shipment"';
            column(No_SalesShptHeader; "No.")
            {

            }
            column(Peso_btc; Peso_btc) { }
            column(Shipment_Method_Code; "Shipment Method Code") { }
            column(CuadroBultos_IncotermLbl; CuadroBultos_IncotermLbl) { }
            column(CuadroBultos_VolumenLbl; CuadroBultos_VolumenLbl) { }
            column(CuadroBultos_PesoNetoLbl; CuadroBultos_PesoNetoLbl) { }
            column(esPackingList; esPackingList) { }
            column(pesoHeader; pesoHeader) { }
            column(volumen; volumen) { }
            column(NoSerie_Caption; NoSerie_Lbl)
            {
            }
            column(Palets_Lbl; Palets_Lbl)
            {

            }
            column(NumBultos_btc; NumBultos_btc)
            {

            }

            column(NumPalets_btc; NumPalets_btc)
            {

            }
            column(PageCaption; PageCaptionCap_Lbl)
            {
            }
            //Variables
            column(TransportistaNombre_btc; TransportistaNombre_btc)
            {
            }
            //Captions
            column(Albaran_Lbl; Albaran_Lbl)
            {
            }
            column(Packing_Lbl; Packing_Lbl) { }
            column(PRGestion_Lbl; PRGestion_Lbl)
            {
            }
            column(FO01_Lbl; FO01_Txt)
            {
            }
            column(Fecha_Lbl; Fecha_Lbl)
            {
            }
            column(Numero_Lbl; Numero_Lbl)
            {
            }
            column(Cliente_Lbl; Cliente_Lbl)
            {
            }
            column(NuestraReferencia_Lbl; NuestraReferencia_Lbl)
            {
            }
            column(EmitidoPor_Lbl; EmitidoPor_Lbl)
            {
            }
            column(NIF_Lbl; NIF_Lbl)
            {
            }
            column(TelFax_Lbl; TelFax_Lbl)
            {
            }
            column(Agente_Lbl; Agente_Lbl)
            {
            }
            column(FacturarA_Lbl; FacturarA_Lbl)
            {
            }
            column(Articulo_Lbl; Articulo_Lbl)
            {
            }
            column(NPedido_Lbl; NPedido_Lbl)
            {
            }
            column(DescriptionCaptionLbl; DescriptionCaptionLbl)
            {
            }
            column(Cantidad_Lbl; Cantidad_Lbl)
            {
            }
            column(CantidadPedida_Lbl; CantidadPedida_Lbl)
            {
            }
            column(Comentarios_Lbl; Comentarios_Lbl)
            {
            }
            column(Bultos_Lbl; Bultos_Lbl)
            {
            }
            column(Transportista_Lbl; Transportista_Lbl)
            {
            }
            column(Portes_Lbl; Portes_Lbl)
            {
            }
            column(RecibiConforme_Lbl; RecibiConforme_Lbl)
            {
            }
            column(SegunLoDispuesto_Lbl; SegunLoDispuesto_Lbl)
            {
            }
            column(TFZummo_Lbl; TFZummo_Lbl)
            {
            }
            column(ZummoInnovaciones_Lbl; ZummoInnovaciones_Lbl)
            {
            }
            column(WorkDescprion; WorkDescprion)
            { }
            column(EsFrancia; EsFrancia) { }
            column(lblRAEES; lblRAEES) { }
            column(lblPILAS; lblPILAS) { }
            //SOTHIS EBR 010920 id 159231
            column(logo; CompanyInfo1.LogoCertificacion)
            { }
            //fin SOTHIS EBR 010920 id 159231
            column(Productordeproducto; CompanyInfo."Productor de producto") { }
            column(ProductordeproductoCaption; CompanyInfo.FieldCaption("Productor de producto")) { }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(TransportistaNombre; TransportistaNombre_btc)
                    {
                    }
                    column(CompanyInfoName; CompanyInfo.Name)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(SalesShptCopyText; STRSUBSTNO(Text002_Lbl, CopyText))
                    {
                    }
                    column(ShipToAddr1; ShipToAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(ShipToAddr2; ShipToAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(ShipToAddr3; direnvio)
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(ShipToAddr4; ShipToAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(ShipToAddr5; ShipToAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo; RecShipToAddr."Phone No.")
                    {
                    }
                    column(ShipToAddr6; ShipToAddr[6])
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoFaxNo; customer."Fax No.")
                    {
                    }
                    column(CompanyInfoVATRegtnNo; CompanyInfo."VAT Registration No.")
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
                    column(SelltoCustNo_SalesShptHeader; "Sales Shipment Header"."Sell-to Customer No.")
                    {
                    }
                    column(facturaA; "Sales Shipment Header"."Bill-to Name") { }
                    column(VATRegistrationNo; "Sales Shipment header"."VAT Registration No.") { }

                    column(DocDate_SalesShptHeader; FORMAT("Sales Shipment Header"."Document Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourRef_SalesShptHeader; "Sales Shipment Header"."Your Reference")
                    {
                    }
                    column(ShipToAddr7; ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8; ShipToAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(ShptDate_SalesShptHeader; FORMAT("Sales Shipment Header"."Shipment Date"))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ItemTrackingAppendixCaption; ItemTrackingAppendixCaptionLbl)
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
                    column(ShipmentNoCaption; ShipmentNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
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
                    column(SelltoCustNo_SalesShptHeaderCaption; "Sales Shipment Header".FIELDCAPTION("Sell-to Customer No."))
                    {
                    }
                    column(OrderNoCaption_SalesShptHeader; 'Our Document No.')
                    {
                    }
                    column(OrderNo_SalesShptHeader; "Sales Shipment Header"."Order No.")
                    {
                    }
                    column(ExternalDocumentNoCaption_SalesShptHeader; 'Purchase Order No.')
                    {
                    }
                    column(ExternalDocumentNo_SalesShptHeader; "Sales Shipment Header"."External Document No.")
                    {
                    }

                    dataitem("Sales Shipment Line"; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(Description_SalesShptLine; Description)
                        {
                        }
                        column(pesoLinea; recProductoPeso."Net Weight" * Quantity)
                        {

                        }
                        column(NoSerie_Value; NoSerie_Value)
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(ShowCorrectionLines; ShowCorrectionLines)
                        {
                        }
                        column(Type_SalesShptLine; FORMAT(Type, 0, 2))
                        {
                        }
                        column(AsmHeaderExists; AsmHeaderExists)
                        {
                        }
                        column(DocumentNo_SalesShptLine; "Document No.")
                        {
                        }
                        column(LinNo; LinNo)
                        {
                        }
                        column(Qty_SalesShptLine; Quantity)
                        {
                        }
                        column(UOM_SalesShptLine; "Unit of Measure")
                        {
                        }
                        column(No_SalesShptLine; "No.")
                        {
                        }
                        column(LineNo_SalesShptLine; "Line No.")
                        {
                        }
                        column(Description_SalesShptLineCaption; FIELDCAPTION(Description))
                        {
                        }
                        column(Qty_SalesShptLineCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(UOM_SalesShptLineCaption; FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(No_SalesShptLineCaption; FIELDCAPTION("No."))
                        {
                        }

                        dataitem(DisplayAsmInfo; Integer)
                        {
                            DataItemTableView = SORTING(Number);
                            column(PostedAsmLineItemNo; BlanksForIndent() + PostedAsmLine."No.")
                            {
                            }
                            column(PostedAsmLineDescription; BlanksForIndent() + PostedAsmLine.Description)
                            {
                            }
                            column(PostedAsmLineQuantity; PostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0 : 5;
                            }
                            column(PostedAsmLineUOMCode; GetUnitOfMeasureDescr(PostedAsmLine."Unit of Measure Code"))
                            {
                            }

                            trigger OnAfterGetRecord();
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                IF Number = 1 THEN
                                    PostedAsmLine.FINDSET()
                                ELSE
                                    PostedAsmLine.NEXT();

                                IF ItemTranslation.GET(PostedAsmLine."No.",
                                     PostedAsmLine."Variant Code",
                                     "Sales Shipment Header"."Language Code")
                                THEN
                                    PostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem();
                            begin
                                IF NOT DisplayAssemblyInformation THEN
                                    CurrReport.BREAK();
                                IF NOT AsmHeaderExists THEN
                                    CurrReport.BREAK();

                                PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                                SETRANGE(Number, 1, PostedAsmLine.COUNT());
                            end;
                        }
                        //sacar lineas de ensamblado
                        dataitem("Posted Assemble-to-Order Link"; "Posted Assemble-to-Order Link")
                        {
                            DataItemTableView = SORTING("Assembly Document Type", "Assembly Document No.");
                            column(AssLink_Document_No_; "Document No.")
                            {
                            }
                            column(AssLink_Document_Type; "Document Type")
                            {
                            }
                            dataitem("Posted Assembly Header"; "Posted Assembly Header")
                            {
                                DataItemLink = "No." = field("Assembly Document No.");
                                DataItemTableView = sorting("No.");

                                column(AssHeader_No_;
                                "No.")
                                {
                                }
                                dataitem("Posted Assembly Line"; "Posted Assembly Line")
                                {
                                    DataItemTableView = SORTING("Document No.");
                                    DataItemLink = "Document No." = field("No.");
                                    //"Line No." = field ();

                                    column(Assembly_No; "Document No.")
                                    {
                                    }
                                    column(Assembly_Line_No_; "Line No.")
                                    { }
                                    column(Assembly_Item_No; "No.")
                                    {
                                    }
                                    column(Assembly_Description; Description)
                                    {
                                    }

                                    dataitem(SerieEnsamblado; "Item Ledger Entry")
                                    {
                                        DataItemTableView = SORTING("Document No.");
                                        DataItemLink = "Document No." = field("Document No."), "Document Line No." = field("Line No.");

                                        column(Item_No_; "Item No.")
                                        {

                                        }

                                        column(NoSerie_Value_2; "Serial No.")
                                        {

                                        }

                                        trigger OnPreDataItem()
                                        begin
                                            SetFilter("Document Line No.", '<>%1', 0);
                                        end;
                                    }
                                }
                            }
                            trigger OnPreDataItem()
                            begin
                                "Posted Assemble-to-Order Link".SetRange("Document Type", "Posted Assemble-to-Order Link"."Document Type"::"Sales Shipment");
                                "Posted Assemble-to-Order Link".SETRANGE("Document No.", "Sales Shipment Line"."Document No.");
                                "Posted Assemble-to-Order Link".SetRange("Document Line No.", "Sales Shipment Line"."Line No.");
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
                            recItemLedgEntry: Record "Item Ledger Entry";
                            recit: record item;
                        begin
                            LinNo := "Line No.";

                            // control de componentes para desglose
                            if "Sales Shipment Line".ParentLineNo <> 0 then
                                CurrReport.Skip();
                            if "Sales Shipment Line".ParentLine then
                                UpdateSalesLineComponentes();
                            //-

                            if (Type = Type::"G/L Account") and ("No." = '7591000') then
                                CurrReport.Skip();

                            if (Type = Type::Item) and (recit.Get("No.")) and (recIt."Item Category Code" = 'EMBALAJES') then
                                CurrReport.Skip();

                            if (Type = Type::Item) and (Quantity = 0) then
                                CurrReport.Skip();

                            if NoSerie_Value = '' then begin
                                recItemLedgEntry.Reset();
                                recItemLedgEntry.SetRange("Document No.", "Sales Shipment Header"."No.");
                                recItemLedgEntry.SetRange("Document Line No.", "Sales Shipment Line"."Line No.");
                                if recItemLedgEntry.FindFirst() then
                                    NoSerie_Value := recItemLedgEntry."Serial No.";
                            end;

                            RecMemLotes.Reset();
                            RecMemLotes.DeleteAll();
                            RetrieveLotAndExpFromPostedInv("Sales Shipment Line"."Document No.", "Sales Shipment Line"."Line No.", RecMemLotes, recit."Obtener Serie Consumo");

                            if not recProductoPeso.Get("No.") then
                                clear(recProductoPeso);
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(BilltoCustNo_SalesShptHeader; "Sales Shipment Header"."Bill-to Customer No.")
                        {
                        }
                        column(CustAddr1; CustAddr[1])
                        {
                        }
                        column(CustAddr2; CustAddr[2])
                        {
                        }
                        column(CustAddr3; CustAddr[3])
                        {
                        }
                        column(CustAddr4; CustAddr[4])
                        {
                        }
                        column(CustAddr5; CustAddr[5])
                        {
                        }
                        column(CustAddr6; CustAddr[6])
                        {
                        }
                        column(CustAddr7; CustAddr[7])
                        {
                        }
                        column(CustAddr8; CustAddr[8])
                        {
                        }
                        column(BilltoAddressCaption; BilltoAddressCaptionLbl)
                        {
                        }
                        column(BilltoCustNo_SalesShptHeaderCaption; "Sales Shipment Header".FIELDCAPTION("Bill-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem();
                        begin
                            IF NOT ShowCustAddr THEN
                                CurrReport.BREAK();
                        end;
                    }
                    dataitem(ItemTrackingLine; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(TrackingSpecBufferNo; TrackingSpecBuffer."Item No.")
                        {
                        }
                        column(TrackingSpecBufferDesc; TrackingSpecBuffer.Description)
                        {
                        }
                        column(TrackingSpecBufferLotNo; TrackingSpecBuffer."Lot No.")
                        {
                        }
                        column(TrackingSpecBufferSerNo; TrackingSpecBuffer."Serial No.")
                        {
                        }
                        column(TrackingSpecBufferQty; TrackingSpecBuffer."Quantity (Base)")
                        {
                        }
                        column(ShowTotal; ShowTotal)
                        {
                        }
                        column(ShowGroup; ShowGroup)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(SerialNoCaption; SerialNoCaptionLbl)
                        {
                        }
                        column(LotNoCaption; LotNoCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(NoCaption; NoCaptionLbl)
                        {
                        }
                        dataitem(TotalItemTracking; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = CONST(1));
                            column(Quantity1; TotalQty)
                            {
                            }
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF Number = 1 THEN
                                TrackingSpecBuffer.FINDSET()
                            ELSE
                                TrackingSpecBuffer.NEXT();

                            IF NOT ShowCorrectionLines AND TrackingSpecBuffer.Correction THEN
                                CurrReport.SKIP();
                            IF TrackingSpecBuffer.Correction THEN
                                TrackingSpecBuffer."Quantity (Base)" := -TrackingSpecBuffer."Quantity (Base)";

                            ShowTotal := FALSE;
                            IF ItemTrackingAppendix.IsStartNewGroup(TrackingSpecBuffer) THEN
                                ShowTotal := TRUE;

                            ShowGroup := FALSE;
                            IF (TrackingSpecBuffer."Source Ref. No." <> OldRefNo) OR
                               (TrackingSpecBuffer."Item No." <> OldNo)
                            THEN BEGIN
                                OldRefNo := TrackingSpecBuffer."Source Ref. No.";
                                OldNo := TrackingSpecBuffer."Item No.";
                                TotalQty := 0;
                            END ELSE
                                ShowGroup := TRUE;
                            TotalQty += TrackingSpecBuffer."Quantity (Base)";
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF TrackingSpecCount = 0 THEN
                                CurrReport.BREAK();
                            SETRANGE(Number, 1, TrackingSpecCount);
                            TrackingSpecBuffer.SETCURRENTKEY("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
                              "Source Prod. Order Line", "Source Ref. No.");
                        end;
                    }

                    trigger OnPreDataItem();
                    begin
                        // Item Tracking:
                        IF ShowLotSN THEN BEGIN
                            TrackingSpecCount := 0;
                            OldRefNo := 0;
                            ShowGroup := FALSE;
                        END;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if StrPos(ShipToAddr[3], "Sales Shipment Header"."Ship-to Address") = 0 then
                            dirEnvio := "Sales Shipment Header"."Ship-to Address" + ' ' + ShipToAddr[3]
                        else
                            dirEnvio := ShipToAddr[3];
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    END;
                    TotalQty := 0;           // Item Tracking
                end;

                trigger OnPostDataItem();
                begin
                    IF NOT IsReportInPreviewMode() THEN
                        CODEUNIT.RUN(CODEUNIT::"Sales Shpt.-Printed", "Sales Shipment Header");
                end;

                trigger OnPreDataItem();
                begin
                    NoOfLoops := 1 + ABS(NoOfCopies);
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord();
            var
                RecShippingAgent: Record "Shipping Agent";
                recCustomer: Record Customer;
                SalesHeader: Record "Sales Header";
            begin
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                SalesHeader.reset;
                SalesHeader.SetRange("No.", "Sales Shipment Header"."Order No.");
                SalesHeader.FindFirst();
                commit;
                WorkDescprion := SalesHeader.GetWorkDescription();


                // miramos si la direccion de envio el pais es FRANCIA
                EsFrancia := GetCountryShipFR();

                if esPackingList then
                    FO01_Txt := FO02_Lbl
                else
                    FO01_Txt := FO01_Lbl;

                if recCustomer.Get("Bill-to Customer No.") then
                    CurrReport.LANGUAGE := Language.GetLanguageID(recCustomer."Language Code");

                if optIdioma <> optIdioma::" " then
                    CurrReport.LANGUAGE := Language.GetLanguageID(format(optIdioma));

                FormatAddressFields("Sales Shipment Header");
                FormatDocumentFields("Sales Shipment Header");
                if Customer.get("Sell-to Customer No.") then;

                //Sacamos telefono de dirección de envio
                if RecShipToAddr.get("Sell-to Customer No.", "Ship-to Code") then;

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");
                //Sacamos el nombre del transportista
                RecShippingAgent.Reset();
                IF NOT RecShippingAgent.Get("Sales Shipment Header"."Shipping Agent Code") THEN Clear(RecShippingAgent);
                TransportistaNombre_btc := RecShippingAgent.Name;
            end;

            trigger OnPostDataItem();
            begin
                OnAfterPostDataItem("Sales Shipment Header");
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
                        Caption = 'Nº copias', Comment = 'No. of Copies';
                        ToolTip = 'Especifica cuántas copias del documento se van a imprimir.',
                          Comment = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mostrar información interna',
                          Comment = 'Show Internal Information';
                        ToolTip = 'Especifica si el documento muestra información interna.',
                          Comment = 'Specifies if the document shows internal information.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log interacción',
                          Comment = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Especifica si desea registrar como interacciones los informes que imprime.',
                          Comment = 'Specifies if you want to record the reports that you print as interactions.';
                    }
                    field("Show Correction Lines"; ShowCorrectionLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Muestra líneas corrección',
                          Comment = 'Show Correction Lines';
                        ToolTip = 'Especifica si se mostrarán en el informe las líneas de corrección provocadas al deshacer un registro de cantidad.',
                          Comment = 'Specifies if the correction lines of an undoing of quantity posting will be shown on the report.';
                    }
                    field(ShowLotSN; ShowLotSN)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mostrar apéndice números serie/lote',
                          Comment = 'Show Serial/Lot Number Appendix';
                        ToolTip = 'Especifica si desea imprimir un apéndice del informe de albaranes de venta en el que se muestren los números de lote y de serie del envío.',
                          Comment = 'Specifies if you want to print an appendix to the sales shipment report showing the lot and serial numbers in the shipment.';
                    }

                    field(optIdioma; optIdioma)
                    {
                        ApplicationArea = All;
                        Caption = 'Language', comment = 'ESP="Idioma"';
                    }

                    field(esPackingList; esPackingList)
                    {
                        ApplicationArea = All;
                        Caption = 'Packing List', comment = 'ESP="Packing List"';
                    }

                    field(volumen; volumen)
                    {
                        ApplicationArea = All;
                        Caption = 'Volume', comment = 'ESP="Volumen"';
                    }

                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage();
        begin
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInfo.GET();
        SalesSetup.GET();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        //SOTHIS EBR 010920 id 15923
        CompanyInfo1.CalcFields(picture, LogoCertificacion);
        //fin SOTHIS EBR 010920 id 15923
        OnAfterInitReport();
    end;

    trigger OnPostReport();
    begin
        IF LogInteraction AND NOT IsReportInPreviewMode() THEN
            IF "Sales Shipment Header".FINDSET() THEN
                REPEAT
                    SegManagement.LogDocument(
                      5, "Sales Shipment Header"."No.", 0, 0, DATABASE::Customer, "Sales Shipment Header"."Sell-to Customer No.",
                      "Sales Shipment Header"."Salesperson Code", "Sales Shipment Header"."Campaign No.",
                      "Sales Shipment Header"."Posting Description", '');
                UNTIL "Sales Shipment Header".NEXT() = 0;
    end;

    trigger OnPreReport();
    begin
        IF NOT CurrReport.USEREQUESTPAGE() THEN
            InitLogInteraction();
        AsmHeaderExists := FALSE;
    end;

    var
        dirEnvio: Text;
        RecShipToAddr: Record "Ship-to Address";
        WorkDescprion: Text;
        esPackingList: Boolean;

        SalesPurchPerson: Record "Salesperson/Purchaser";
        Customer: Record Customer;
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        Language: Record "Language";
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        RespCenter: Record "Responsibility Center";
        RecMemLotes: Record MemEstadistica_btc temporary;
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit "SegManagement";
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        SalesPersonText: Text[50];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        optIdioma: Option " ","ENU","ESP","FRA";
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        ShowCustAddr: Boolean;
        DimText: Text[2048];
        OldDimText: Text[2048];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        recProductoPeso: Record Item;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        [InDataSet]


        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        LinNo: Integer;
        Text002_Lbl: label 'Venta - Alb. venta %1', Comment = 'Sales - Shipment %1'; //'%1 = Document No.'
        ItemTrackingAppendixCaptionLbl: Label 'Seguimiento productos - Apéndice', Comment = 'Item Tracking - Appendix';
        PhoneNoCaptionLbl: Label 'Nº teléfono', Comment = 'Phone No.';
        VATRegNoCaptionLbl: Label 'CIF/NIF', Comment = 'VAT Reg. No.';
        GiroNoCaptionLbl: Label 'Nº giro postal', Comment = 'Giro No.';
        BankNameCaptionLbl: Label 'Banco', Comment = 'Bank';
        BankAccNoCaptionLbl: Label 'Nº cuenta', Comment = 'ESP="Account No."';
        ShipmentNoCaptionLbl: Label 'Nº albarán', Comment = 'ESP="Shipment No."';
        ShipmentDateCaptionLbl: Label 'Fecha envío', Comment = 'ESP="Shipment Date"';
        HomePageCaptionLbl: Label 'Página Web', Comment = 'ESP="Home Page"';
        EmailCaptionLbl: Label 'Correo electrónico', Comment = 'ESP="Email"';
        DocumentDateCaptionLbl: Label 'Fecha emisión documento', Comment = 'ESP="Document Date"';
        HeaderDimensionsCaptionLbl: Label 'Dimensiones cabecera', Comment = 'ESP="Header Dimensions"';
        LineDimensionsCaptionLbl: Label 'Dimensiones línea', Comment = 'ESP="Line Dimensions"';
        BilltoAddressCaptionLbl: Label 'Fact. a-Dirección', Comment = 'ESP="Bill-to Address"';
        QuantityCaptionLbl: Label 'Cantidad', Comment = 'ESP="Quantity"';
        SerialNoCaptionLbl: Label 'Serial No.', Comment = 'ESP="Nº serie"';
        LotNoCaptionLbl: Label 'Nº lote', Comment = 'ESP="Lot No."';
        DescriptionCaptionLbl: Label 'Description', Comment = 'ESP="Description"';
        NoCaptionLbl: Label 'Nº', Comment = 'No.';
        PageCaptionCap_Lbl: Label 'Página %1 de %2', Comment = 'Page %1 of %2';
        //Variables
        NoSerie_Value: Code[20];
        NoSerie_Value_2: Code[20];
        TransportistaNombre_btc: Text[50];
        //Captions
        Albaran_Lbl: Label 'SHIPMENT', Comment = 'ESP="ALBARÁN"';
        Packing_Lbl: Label 'PACKING LIST', comment = 'ESP="PACKING LIST"';
        PRGestion_Lbl: Label 'PR-GESTION DE LOS PEDIDOS DE CLIENTE', Comment = '';
        FO01_Txt: text;
        FO01_Lbl: Label 'FO.03_C8.01_V14', Comment = 'ESP="FO.03_C8.01_V14"';  // ALBARAN
        FO02_Lbl: Label 'FO.04_C8.01_V03', Comment = 'ESP="FO.04_C8.01_V03"';  // PACKING LIST
        pesoHeader: Label 'Weight(kg)', comment = 'ESP="Peso(kg)"';
        Fecha_Lbl: Label 'Date', Comment = 'ESP="Fecha"';
        Numero_Lbl: Label 'Number', Comment = 'ESP="Número"';
        Cliente_Lbl: Label 'Customer', Comment = 'ESP="Cliente"';
        NuestraReferencia_Lbl: Label 'Ref.', Comment = 'ESP="Nuestra referencia"';
        EmitidoPor_Lbl: Label 'Issued by:', Comment = 'ESP="Emitido por:"';
        NIF_Lbl: Label 'VAT:', Comment = 'ESP="NIF:"';
        TelFax_Lbl: Label 'Tel/Fax:', Comment = 'Tel/Fax:';
        Agente_Lbl: Label 'Agent:', Comment = 'ESP="Agente:"';
        FacturarA_Lbl: Label 'Invoice to:', Comment = 'ESP="Facturar a:"';
        Articulo_Lbl: Label 'Article', Comment = 'ESP="Artículo"';
        NPedido_Lbl: Label 'N/Order', Comment = 'ESP="N/Pedido"';
        Cantidad_Lbl: Label 'Quantity', Comment = 'ESP="Cantidad"';
        CantidadPedida_Lbl: Label 'Cantidad Pedida', Comment = 'Amount Requested';
        Comentarios_Lbl: Label 'Remarks', Comment = 'ESP="Comentarios"';
        Bultos_Lbl: Label 'Bulks', Comment = 'ESP="Bultos"';
        Palets_Lbl: Label 'Pallets', comment = 'ESP="Palets"';
        Transportista_Lbl: Label 'Shipping agent', Comment = 'ESP="Transportista"';
        Portes_Lbl: Label 'FREIGHT', Comment = 'ESP="PORTES"';
        RecibiConforme_Lbl: Label 'RECEIVED AS,', Comment = 'ESP="RECIBI CONFORME"';
        SegunLoDispuesto_Lbl: Label 'Según lo Dispuesto por el Reglamento (UE) 2016/769 del Parlamento Europeo y del Consejo de 27 de abril de 2016 relativo a la protección de las personas físicas, le informamos que sus datos serán incorporados al sistema de tratamiento titularidad de ZUMMO INNOVACIONES MECÁNICAS, S.A. - con la finalidad de poder remitirle la correspondiente factura. Podrá ejercer los derechos de acceso, rectificación, limitación de tratamiento, supresión, portabilidad y oposición/revocación, en los términos que establece la normativa vigente en materia de protección de datos, dirigiendo su petición a la dirección postal arriba indicada, asimismo, podrá dirigirse a la Autoridad de Control competente para presentar la reclamación que considere oportuna.',
  Comment = 'As provided by Regulation (EU) 2016/769 of the European Parliament and of the Council of April 27, 2016 regarding the protection of natural persons, we inform you that your data will be incorporated into the treatment system owned by ZUMMO MECHANICAL INNOVATIONS , SA - in order to be able to send you the corresponding invoice. You may exercise the rights of access, rectification, limitation of treatment, deletion, portability and opposition / revocation, in the terms established by current regulations on data protection, by sending your request to the postal address indicated above, you can also address to the competent Control Authority to submit the claim it deems appropriate.';
        TFZummo_Lbl: Label 'T +34 961 301 246| F +34 961 301 250| zummo@zummo.es| Cádiz, 4.46113 Moncada.Valencia.Spain|www.zummo.es',
  Comment = 'T +34 961 301 246| F +34 961 301 250| zummo@zummo.es| Cádiz, 4.46113 Moncada.Valencia.Spain|www.zummo.es';
        ZummoInnovaciones_Lbl: Label 'Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia el 26 de enero de 1999, Tomo 4336, Libro 1648, Sección Gral., Folio 212, hoja Y-22381, Inscripción 1ª CIF A-96112024 Nº R.I. Productor AEE 288',
  Comment = 'Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia on January 26, 1999, Volume 4336, Book 1648, General Section, Folio 212, page Y-22381, Registration 1st CIF A-96112024 Nº R.I. AEE producer 288';
        NoSerie_Lbl: Label 'Serial No. ', Comment = 'ESP="Nº de Serie:"';
        CuadroBultos_IncotermLbl: Label 'Incoterm:', comment = 'ESP="Incoterm:"';
        CuadroBultos_VolumenLbl: Label 'Volume(m3):', comment = 'ESP="Volumen(m3):",FRA="Volume(m3):"';
        CuadroBultos_PesoNetoLbl: Label 'Gross Weight(kg):', comment = 'ESP="Peso Neto(kg):",FRA="Gross Weight(kg):"';
        volumen: Decimal;
        EsFrancia: Boolean;
        lblRAEES: Text;
        lblPILAS: text;

    [Scope('Personalization')]
    procedure InitLogInteraction();
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(5) <> '';
    end;

    [Scope('Personalization')]
    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; NewShowCorrectionLines: Boolean; NewShowLotSN: Boolean; DisplayAsmInfo: Boolean);
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
        ShowLotSN := NewShowLotSN;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure IsReportInPreviewMode(): Boolean;
    var
        MailManagement: Codeunit "Mail Management";
    begin
        EXIT(CurrReport.PREVIEW() OR MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure FormatAddressFields(SalesShipmentHeader: Record "Sales Shipment Header");
    begin
        FormatAddr.GetCompanyAddr(SalesShipmentHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesShptShipTo(ShipToAddr, SalesShipmentHeader);
        ShowCustAddr := FormatAddr.SalesShptBillTo(CustAddr, ShipToAddr, SalesShipmentHeader);
    end;

    local procedure FormatDocumentFields(SalesShipmentHeader: Record "Sales Shipment Header");
    begin
        WITH SalesShipmentHeader DO BEGIN
            FormatDocument.SetSalesPerson(SalesPurchPerson, "Salesperson Code", SalesPersonText);
            ReferenceText := FormatDocument.SetText("Your Reference" <> '', FIELDCAPTION("Your Reference"));
        END;
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10];
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    end;

    local procedure GetCountryShipFR(): Boolean
    var
        CountryRegion: Record "Country/Region";
    begin
        lblRAEES := '';
        lblPILAS := '';
        if CountryRegion.Get("Sales Shipment Header"."Ship-to Country/Region Code") then begin
            lblRAEES := CountryRegion."ID RAES";
            lblPILAS := CountryRegion."ID PILAS";
            exit(true);
        end;
    end;

    [Scope('Personalization')]
    procedure BlanksForIndent(): Text[10];
    begin
        EXIT(PADSTR('', 2, ' '));
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterInitReport();
    begin
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterPostDataItem(var SalesShipmentHeader: Record "Sales Shipment Header");
    begin
    end;

    local procedure RetrieveLotAndExpFromPostedInv(pNumDocumento: Code[20]; pNumLinea: Integer; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary; SearchSerieParent: Boolean)
    var
        IsParentItem: Record Item;
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        SerialNoParent: text;
        NumMov: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Invoices)
        RecMemEstadisticas.RESET();
        RecMemEstadisticas.DELETEALL();
        NumMov := 1;

        ItemLedgEntry.Reset();
        ItemLedgEntry.SetRange("Document No.", pNumDocumento);
        ItemLedgEntry.SetRange("Document Line No.", pNumLinea);
        if ItemLedgEntry.FindSet() then
            repeat
                RecMemEstadisticas.INIT();
                RecMemEstadisticas.NoMov := NumMov;
                NumMov += 1;
                RecMemEstadisticas.NoLote := ItemLedgEntry."Lot No.";
                RecMemEstadisticas.NoSerie := ItemLedgEntry."Serial No.";
                RecMemEstadisticas.Noproducto := ItemLedgEntry."Item No.";
                if SearchSerieParent then begin
                    SerialNoParent := GetSerialNoParent(ItemLedgEntry);
                    if SerialNoParent <> '' then
                        RecMemEstadisticas.NoSerie += StrSubstNo('    (Ref: %1)', SerialNoParent);
                end;
                RecMemEstadisticas.INSERT();
            until ItemLedgEntry.Next() = 0;
    end;

    local procedure GetSerialNoParent(ItemLedgEntry: Record "Item Ledger Entry"): Text
    var
        ParentItemLedgEntry: Record "Item Ledger Entry";
        Funciones: Codeunit Funciones;
    begin
        ParentItemLedgEntry.Reset();
        ParentItemLedgEntry.SetRange("Item No.", ItemLedgEntry."Item No.");
        ParentItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Output);
        ParentItemLedgEntry.SetRange("Serial No.", ItemLedgEntry."Serial No.");
        if ParentItemLedgEntry.FindFirst() then begin
            if ParentItemLedgEntry.SerialNoParent = '' then begin
                Funciones.ItemLdgEntryGetParentSerialNo(ParentItemLedgEntry);
                ParentItemLedgEntry.Modify();
            end;
            exit(ParentItemLedgEntry.SerialNoParent);
        end;
    end;

    local procedure UpdateSalesLineComponentes()
    var
        SalesShipmentLine: record "Sales Shipment Line";
        Quantity: Decimal;
        UnitPrice: Decimal;
        Dto: Decimal;
        Dto1: Decimal;
        Dto2: Decimal;
    begin
        SalesShipmentLine.Reset();
        SalesShipmentLine.SetRange("Document No.", "Sales Shipment Line"."Document No.");
        SalesShipmentLine.SetRange(ParentLineNo, "Sales Shipment Line"."Line No.");
        if SalesShipmentLine.FindFirst() then
            repeat
                if Quantity < SalesShipmentLine.Quantity then
                    Quantity := SalesShipmentLine.Quantity;
                UnitPrice += SalesShipmentLine."Unit Price";
                Dto := SalesShipmentLine."Line Discount %";
                Dto1 := SalesShipmentLine."DecLine Discount1 %_btc";
                Dto2 := SalesShipmentLine."DecLine Discount2 %_btc";
            Until SalesShipmentLine.next() = 0;
        "Sales Shipment Line".Type := SalesShipmentLine.Type::Item;
        "Sales Shipment Line"."No." := SalesShipmentLine.ParentItemNo;
        "Sales Shipment Line".Quantity := Quantity;
        "Sales Shipment Line"."Unit Price" := UnitPrice;
        "Sales Shipment Line"."Line Discount %" := Dto;
        "Sales Shipment Line"."DecLine Discount1 %_btc" := Dto1;
        "Sales Shipment Line"."DecLine Discount2 %_btc" := Dto2;
    end;
}

