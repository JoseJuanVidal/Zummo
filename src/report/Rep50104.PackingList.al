report 50104 "PackingList"
{
     DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50104.PackingList.rdl';
    Caption = 'Packing List', Comment = 'Packing List';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Histórico albaranes venta', Comment = 'Posted Sales Shipment';
            column(No_SalesShptHeader; "No.")
            {
            }
            column(NoSerie_Caption; NoSerie_Lbl)
            {
            }
            column(decVolumen; decVolumen) { }
            column(decPesoBruto; decPesoBruto) { }
            column(numPalets; numPalets) { }
            column(numBultos; numBultos) { }
            column(NumHoja_Lbl; NumHoja_Lbl) { }
            column(PageCaption; PageCaptionCap_Lbl)
            {
            }
            //Variables
            column(TransportistaNombre_btc; TransportistaNombre_btc)
            {
            }
            //Captions
            column(PackingList_Lbl; PackingList_Lbl)
            {
            }
            column(Fecha_Lbl; Fecha_Lbl)
            {
            }
            column(Num_Lbl; Num_Lbl)
            {
            }
            column(Cliente_Lbl; Cliente_Lbl)
            {
            }
            column(NoHoja_Lbl; NoHoja_Lbl)
            {
            }
            column(DireccionDeEnvio_Lbl; DireccionDeEnvio_Lbl)
            {
            }
            column(MedioDeTransporte_Lbl; MedioDeTransporte_Lbl)
            {
            }
            column(TelFax_Lbl; TelFax_Lbl)
            {
            }
            column(Articulo_Lbl; Articulo_Lbl)
            {
            }
            column(DescriptionCaptionLbl; DescriptionCaptionLbl)
            {
            }
            column(Cantidad_Lbl; Cantidad_Lbl)
            {
            }
            column(M3_Lbl; M3_Lbl)
            {
            }
            column(PesoBruto_Lbl; PesoBruto_Lbl)
            {
            }
            column(PesoNeto_Lbl; PesoNeto_Lbl)
            {
            }
            column(VolumenM3_Lbl; VolumenM3_Lbl)
            {
            }
            column(PesoBrutoKG_Lbl; PesoBrutoKG_Lbl)
            {
            }
            column(NoPalet_Lbl; NoPalet_Lbl)
            {
            }
            column(Bultos_Lbl; Bultos_Lbl)
            {
            }
            column(PaisDeDestino_Lbl; PaisDeDestino_Lbl)
            {
            }
            column(Incoterm_Lbl; Incoterm_Lbl)
            {
            }
            column(Moncada_Lbl; Moncada_Lbl)
            {
            }
            column(Icm_Lbl; Icm_Lbl)
            {
            }
            column(PuertoDeEmbarque_Lbl; PuertoDeEmbarque_Lbl)
            {
            }
            column(PuertoDesembarque_Lbl; PuertoDesembarque_Lbl)
            {
            }
            column(TransAdelantada_Lbl; TransAdelantada_Lbl)
            {
            }
            column(PaisOrigen_Lbl; PaisOrigen_Lbl)
            {
            }
            column(PaisProcedencia_Lbl; PaisProcedencia_Lbl)
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
                    column(ShipToAddr3; ShipToAddr[3])
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
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
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
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
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
                    column(DocDate_SalesShptHeader; FORMAT("Sales Shipment Header"."Document Date"))//, 0, 4))
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
                    column(MetodoDeTransporte; "Sales Shipment Header"."Transport Method" + ' ' + TransportistaNombre_btc)
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
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET() THEN
                                    CurrReport.BREAK();
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK();

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT() = 0;
                        end;

                        trigger OnPreDataItem();
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK();
                        end;
                    }
                    dataitem("Sales Shipment Line"; "Sales Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(Description_SalesShptLine; Description)
                        {
                        }
                        column(recItem_NetWeight; recItem."Net Weight")
                        {

                        }
                        column(recItem_GrossWeight; recItem."Gross Weight")
                        {

                        }

                        column(recItem_UnitVolume; recItem."Unit Volume")
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
                        column(Esembalaje; EsEmbalaje) { }
                        column(EsPorte; Esporte) { }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText1; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord();
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
                                        DimText := STRSUBSTNO('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT() = 0;
                            end;

                            trigger OnPreDataItem();
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK();
                            end;
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
                        //Sacar lineas de ensamblado
                        dataitem("Assemble-to-Order Link"; "Assemble-to-Order Link")
                        {
                            dataitem("Assembly Header"; "Assembly Header")
                            {
                                DataItemLink = "Document Type" = FIELD("Assembly Document Type"),
                                    "No." = field("Assembly Document No.");
                                dataitem("Assembly Line"; "Assembly Line")
                                {
                                    column(Assembly_No; "No.")
                                    {
                                    }
                                    column(Assembly_Description; Description)
                                    {
                                    }

                                    trigger OnPreDataItem()
                                    begin
                                        "Assembly Line".SetRange("Document No.", "Assembly Header"."No.");
                                        "Assembly Line".SetRange("Document Type", "Assembly Header"."Document Type");
                                    end;
                                }
                            }

                            trigger OnPreDataItem()
                            begin
                                "Assemble-to-Order Link".SetRange("Document No.", "Sales Shipment Line"."Order No.");
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


                        trigger OnAfterGetRecord();
                        var
                            recit: Record Item;
                        begin
                            LinNo := "Line No.";
                            IF NOT ShowCorrectionLines AND Correction THEN
                                CurrReport.SKIP();

                            DimSetEntry2.SETRANGE("Dimension Set ID", "Dimension Set ID");
                            IF DisplayAssemblyInformation THEN
                                AsmHeaderExists := AsmToShipmentExists(PostedAsmHeader);

                            EsEmbalaje := false;
                            EsPorte := false;

                            if "Sales Shipment Line".Type = "Sales Shipment Line".Type::"G/L Account" then begin
                                if not RecCuenta.Get("Sales Shipment Line"."No.") then
                                    clear(RecCuenta);
                                if RecCuenta."Ignore Discounts" then
                                    EsPorte := true;
                            end;
                            if "Sales Shipment Line"."Item Category Code" = 'EMBALAJES' then
                                EsEmbalaje := true;

                            if (Type = Type::Item) and (recit.Get("No.")) and (recIt."Item Category Code" = 'EMBALAJES') then
                                CurrReport.Skip();

                            clear(recItem);
                            if type = type::Item then
                                if recItem.Get("No.") then;

                            decVolumen += recItem."Unit Volume" * Quantity;

                            if decPesoBruto = 0 then
                                decPesoBruto += "Gross Weight" * Quantity;

                            RecMemLotes.Reset();
                            RecMemLotes.DeleteAll();
                            RetrieveLotAndExpFromPostedInv("Sales Shipment Line"."Document No.", "Sales Shipment Line"."Line No.", RecMemLotes);
                        end;

                        trigger OnPostDataItem();
                        begin
                            IF ShowLotSN THEN BEGIN
                                ItemTrackingDocMgt.SetRetrieveAsmItemTracking(TRUE);
                                TrackingSpecCount :=
                                  ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,
                                    "Sales Shipment Header"."No.", DATABASE::"Sales Shipment Header", 0);
                                ItemTrackingDocMgt.SetRetrieveAsmItemTracking(FALSE);
                            END;
                        end;

                        trigger OnPreDataItem();
                        begin
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK();
                            SETRANGE("Line No.", 0, "Line No.");
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
                Cust: Record Customer;
            begin
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                if not Cust.Get("Bill-to Customer No.") then
                    Clear(Cust)
                else
                    CurrReport.Language := Language.GetLanguageID(Cust."Language Code");

                if optIdioma <> optIdioma::" " then
                    CurrReport.LANGUAGE := Language.GetLanguageID(format(optIdioma));

                FormatAddressFields("Sales Shipment Header");
                FormatDocumentFields("Sales Shipment Header");

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");
                //Sacamos el nombre del transportista
                RecShippingAgent.Reset();
                IF NOT RecShippingAgent.Get("Sales Shipment Header"."Shipping Agent Code") THEN Clear(RecShippingAgent);
                TransportistaNombre_btc := RecShippingAgent.Name;

                decVolumen := 0;
                decPesoBruto := Peso_btc;
                numPalets := NumPalets_btc;
                numBultos := NumBultos_btc;
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
                    Caption = 'Options', Comment = 'ESP="Opciones",FRA="Les options"';
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
        CompanyInfo1.get();
        CompanyInfo1.CalcFields(Picture);
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
        RecMemLotes: Record MemEstadistica_btc temporary;
        SalesPurchPerson: Record "Salesperson/Purchaser";
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
        NoOfCopies: Integer;
        optIdioma: Option " ","ENU","ESP","FRA";
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        ShowCustAddr: Boolean;
        DimText: Text[75];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        EsEmbalaje: Boolean;
        EsPorte: Boolean;
        LinNo: Integer;
        RecCuenta: Record "G/L Account";
        Text002_Lbl: label 'Venta - Alb. venta %1', Comment = 'Sales - Shipment %1'; //'%1 = Document No.'
        ItemTrackingAppendixCaptionLbl: Label 'Item Tracking - Appendix', Comment = 'ESP="Seguimiento productos - Apéndice",FRA="Suivi des produits - Annexe"';
        PhoneNoCaptionLbl: Label 'Phone No.', Comment = 'ESP="Nº teléfono",FRA="Numéro de téléphone"';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.', Comment = 'ESP="CIF/NIF",FRA="TVA Reg. Non."';
        GiroNoCaptionLbl: Label 'Giro No.', Comment = 'ESP="Nº giro postal",FRA="Giro No."';
        BankNameCaptionLbl: Label 'Bank', Comment = 'ESP="Banco",FRA="Banque"';
        BankAccNoCaptionLbl: Label 'Account No.', Comment = 'ESP="Nº cuenta",FRA="N ° de compte."';
        ShipmentNoCaptionLbl: Label 'Shipment No.', Comment = 'ESP="Nº albarán",FRA="Numéro d´expédition"';
        ShipmentDateCaptionLbl: Label 'Shipment Date', Comment = 'ESP="Fecha envío",FRA="Date d´expédition"';
        HomePageCaptionLbl: Label 'Home Page', Comment = 'ESP="Página Web",FRA="Page d´accueil"';
        EmailCaptionLbl: Label 'Email', Comment = 'ESP="Correo electrónico",FRA="Courrier électronique"';
        DocumentDateCaptionLbl: Label 'Document Date', Comment = 'ESP="Fecha emisión documento",FRA="Date du document"';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions', Comment = 'ESP="Dimensiones cabecera",FRA="Dimensions de l´en-tête"';
        LineDimensionsCaptionLbl: Label 'Dimensiones línea', Comment = 'Line Dimensions';
        BilltoAddressCaptionLbl: Label 'Bill-to Address', Comment = 'ESP="Fact. a-Dirección",FRA="Facturer à l´adresse"';
        QuantityCaptionLbl: Label 'Quantity', Comment = 'ESP="Cantidad",FRA="Quantité"';
        SerialNoCaptionLbl: Label 'Serial No.', Comment = 'ESP="Nº serie",FRA="Numéro de série."';
        LotNoCaptionLbl: Label 'Lot No.', Comment = 'ESP="Nº lote",FRA="N ° de lot"';
        DescriptionCaptionLbl: Label 'Description', Comment = 'ESP="Descripción",FRA="La description"';
        NoCaptionLbl: Label 'No.', Comment = 'ESP="Nº",FRA="Nº"';
        PageCaptionCap_Lbl: Label 'Page %1 of %2', Comment = 'ESP="Página %1 de %2",FRA="Page %1 sur %2"';
        //Variables
        TransportistaNombre_btc: Text[50];
        //Captions
        PackingList_Lbl: Label 'ROMEANEIO DE EMBARQUE/PACKING LIST', Comment = 'ROMEANEIO DE EMBARQUE/PACKING LIST';
        Fecha_Lbl: Label 'Date', Comment = 'ESP="Fecha",FRA="Date"';
        Num_Lbl: Label 'Num', Comment = 'ESP="Núm",FRA="Nom"';
        Cliente_Lbl: Label 'Customer', Comment = 'ESP="Cliente",FRA="Client"';
        NoHoja_Lbl: Label 'Nº Page', Comment = 'ESP="Nº Hoja",FRA="Nº page"';
        DireccionDeEnvio_Lbl: Label 'Shipping Address', Comment = 'ESP="Dirección de Envío",FRA="Adresse de livraison"';
        MedioDeTransporte_Lbl: Label 'Transport Method', Comment = 'ESP="Medio de Transporte",FRA="Méthode de transport"';
        TelFax_Lbl: Label 'Phone./Fax:', Comment = 'ESP="Telf./Fax:",FRA="Téléphone / Fax:"';
        Articulo_Lbl: Label 'Article', Comment = 'ESP="Artículo",FRA="Article"';
        Cantidad_Lbl: Label 'Quantity', Comment = 'ESP="Cantidad",FRA="Quantité"';
        M3_Lbl: Label 'm3', Comment = 'm3';
        PesoBruto_Lbl: Label 'Gross weight', Comment = 'ESP="Peso Bruto",FRA="Poids brut"';
        PesoNeto_Lbl: Label 'Net weight', Comment = 'ESP="Peso Neto",FRA="Poids net"';
        VolumenM3_Lbl: Label 'VOLUME M3(PALLETS)', Comment = 'ESP="VOLUMEN M3(PALETS)",FRA="VOLUME M3 (PALETTES)"';
        PesoBrutoKG_Lbl: Label 'GROSS WEIGHT KG', Comment = 'ESP="PESO BRUTO KG",FRA="POIDS BRUT KG"';
        NoPalet_Lbl: Label 'Nº PALLET', Comment = 'ESP="Nº PALET",FRA="Nº PALETTES"';
        BULTOS_Lbl: Label 'BULKS', Comment = 'ESP="BULTOS",FRA="VRAC"';
        PaisDeDestino_Lbl: Label 'COUNTRY OF DESTINATION: BRAZIL', Comment = 'ESP="PAIS DE DESTINO: BRASIL",FRA="PAYS DE DESTINATION: BRÉSIL"';
        Incoterm_Lbl: Label 'INCOTERM: EXW', Comment = 'INCOTERM: EXW';
        Moncada_Lbl: Label 'MONCADA', Comment = 'MONCADA';
        Icm_Lbl: Label 'PORT OF SHIPMENT: VALENCIA', Comment = 'ESP="PUERTO DE EMBARQUE: VALENCIA",FRA="PORT D´EXPÉDITION: VALENCE"';
        PuertoDeEmbarque_Lbl: Label 'PORT UNEMARK: SANTOS-SSZ-BRAS', Comment = 'ESP="PUERTO DESEMBARQUE: SANTOS-SSZ-BRAS",FRA="PORT UNEMARK: SANTOS-SSZ-BRAS"';
        PuertoDesembarque_Lbl: Label 'TRANS. ADVANCED', Comment = 'ESP="TRANS. ADELANTADA",FRA="TRANS. AVANCÉE"';
        TransAdelantada_Lbl: Label 'COUNTRY ORIGIN: SPAIN', Comment = 'ESP="PAIS ORIGEN: ESPAÑA",FRA="ORIGINE DU PAYS: ESPAGNE"';
        PaisOrigen_Lbl: Label 'COUNTRY PROVENANCE: SPAIN', Comment = 'ESP="PAIS PROCEDENCIA: ESPAÑA",FRA="PROVENANCE PAYS: ESPAGNE"';
        PaisProcedencia_Lbl: Label 'COUNTRY PROVENANCE: SPAIN', Comment = 'ESP="PAIS PROCEDENCIA: ESPAÑA",FRA="PROVENANCE PAYS: ESPAGNE"';
        SegunLoDispuesto_Lbl: Label 'As provided by Regulation (EU) 2016/769 of the European Parliament and of the Council of April 27, 2016 regarding the protection of natural persons, we inform you that your data will be incorporated into the treatment system owned by ZUMMO MECHANICAL INNOVATIONS, SA - in order to be able to send you the corresponding invoice. You may exercise the rights of access, rectification, limitation of treatment, deletion, portability and opposition / revocation, in the terms established by current regulations on data protection, by sending your request to the postal address indicated above, you can also address to the competent Control Authority to submit the claim it deems appropriate.',
          Comment = 'ESP="Según lo Dispuesto por el Reglamento (UE) 2016/769 del Parlamento Europeo y del Consejo de 27 de abril de 2016 relativo a la protección de las personas físicas, le informamos que sus datos serán incorporados al sistema de tratamiento titularidad de ZUMMO INNOVACIONES MECÁNICAS, S.A. - con la finalidad de poder remitirle la correspondiente factura. Podrá ejercer los derechos de acceso, rectificación, limitación de tratamiento, supresión, portabilidad y oposición/revocación, en los términos que establece la normativa vigente en materia de protección de datos, dirigiendo su petición a la dirección postal arriba indicada, asimismo, podrá dirigirse a la Autoridad de Control competente para presentar la reclamación que considere oportuna.",FRA="Conformément au règlement (UE) 2016/769 du Parlement européen et du Conseil du 27 avril 2016 relatif à la protection des personnes physiques, nous vous informons que vos données seront intégrées dans le système de traitement appartenant à ZUMMO MECHANICAL INNOVATIONS, SA - afin de pouvoir vous envoyer la facture correspondante. Vous pouvez exercer les droits d´accès, de rectification, de limitation de traitement, de suppression, de portabilité et d´opposition / révocation, dans les termes établis par la réglementation en vigueur sur la protection des données, en adressant votre demande à l´adresse postale indiquée ci-dessus, vous pouvez également vous adresser au l´autorité de contrôle compétente pour soumettre la réclamation qu´elle juge appropriée."';
        TFZummo_Lbl: Label 'T +34 961 301 246| F +34 961 301 250| zummo@zummo.es| Cádiz, 4.46113 Moncada.Valencia.Spain|www.zummo.es',
          Comment = 'T +34 961 301 246| F +34 961 301 250| zummo@zummo.es| Cádiz, 4.46113 Moncada.Valencia.Spain|www.zummo.es';
        ZummoInnovaciones_Lbl: Label 'Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia on January 26, 1999, Volume 4336, Book 1648, General Section, Folio 212, page Y-22381, Registration 1st CIF A-96112024 Nº R.I. AEE producer 288',
          Comment = 'ESP="Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia el 26 de enero de 1999, Tomo 4336, Libro 1648, Sección Gral., Folio 212, hoja Y-22381, Inscripción 1ª CIF A-96112024 Nº R.I. Productor AEE 288",FRA="Zummo Innovaciones Mecánicas, S.A. Ins.Reg.Merc.Valencia on 26 janvier 1999, Volume 4336, Book 1648, General Section, Folio 212, page Y-22381, Registration 1st CIF A-96112024 Nº R.I. AEE producteur 288"';
        NumHoja_Lbl: Label 'Sheet No.', comment = 'ESP="Nº Hoja",FRA="Fiche n°"';
        recItem: record item;
        decVolumen: Decimal;
        decPesoBruto: Decimal;
        numPalets: Decimal;
        numBultos: Decimal;
        NoSerie_Lbl: Label 'Serial No.', Comment = 'ESP="Nº de Serie:",FRA="Numéro de série."';

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

    local procedure RetrieveLotAndExpFromPostedInv(pNumDocumento: Code[20]; pNumLinea: Integer; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary)
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
                RecMemEstadisticas.INSERT();
            until ItemLedgEntry.Next() = 0;
    end;
}

