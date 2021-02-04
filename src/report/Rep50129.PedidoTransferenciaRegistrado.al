report 50129 "PedidoTransferenciaRegistrado"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50129.PedidoTransferenciaRegistrado.rdl';
    Caption = 'Ped.Transferencia Registrado', Comment = 'Ped.Transferencia Registrado';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Transfer Receipt Header"; "Transfer Receipt Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Transfer Receipt';

            column(NoSerie_Caption; NumSerieLbl) { }
            column(DesdeLbl; DesdeLbl)
            {
            }
            column(CuadroBultos_BultosLbl; CuadroBultos_BultosLbl)
            {

            }
            column(CuadroBultos_VolumenLbl; CuadroBultos_VolumenLbl) { }
            column(CuadroBultos_PesoNetoLbl; CuadroBultos_PesoNetoLbl) { }
            column(volumen; volumen) { }

            column(CuadroBultos_IncotermLbl; CuadroBultos_IncotermLbl) { }
            column(CuadroBultos_PaletsLbl; CuadroBultos_PaletsLbl)
            {

            }
            column(totalPalets; totalPalets)
            {

            }
            column(totalBultos; totalBultos)
            {

            }

            column(totalPeso; totalPeso)
            {

            }

            column(HastaLbl; HastaLbl)
            {
            }
            column(PurchOrderCaptionLbl; PurchOrderCaptionLbl)
            {
            }
            column(PRCOMPRASLbl; PRCOMPRASLbl)
            {
            }
            column(ISOLbl; ISOLbl)
            {
            }
            column(PediProveeedorLbl; PediProveeedorLbl)
            {
            }
            column(No_TransferHdr; "No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CopyCaption; StrSubstNo(Text001, CopyText))
                    {
                    }
                    column(TransferToAddr1; TransferToAddr[1])
                    {
                    }
                    column(TransferFromAddr1; "Transfer Receipt Header"."Transfer-from Name")
                    {
                    }
                    column(TransferToAddr2; "Transfer Receipt Header"."Transfer-to Code")
                    {
                    }
                    column(TransferFromAddr2; "Transfer Receipt Header"."Transfer-from Code")
                    {
                    }
                    column(TransferToAddr3; "Transfer Receipt Header"."Transfer-to Address")
                    {
                    }
                    column(TransferFromAddr3; "Transfer Receipt Header"."Transfer-from Address")
                    {
                    }
                    column(TransferToAddr4; "Transfer Receipt Header"."Transfer-to City")
                    {
                    }
                    column(TransferFromAddr4; "Transfer Receipt Header"."Transfer-from City")
                    {
                    }
                    column(TransferToAddr5; "Transfer Receipt Header"."Transfer-to County")
                    {
                    }
                    column(TransferFromAddr5; "Transfer Receipt Header"."Transfer-from County")
                    {
                    }
                    column(TransferToAddr6; "Transfer Receipt Header"."Trsf.-to Country/Region Code")
                    {
                    }
                    column(TransferfromAddr6; "Transfer Receipt Header"."Trsf.-from Country/Region Code")
                    {
                    }
                    column(TransferToAddr9; "Transfer Receipt Header"."Transfer-to Post Code")
                    {
                    }
                    column(TransferfromAddr9; "Transfer Receipt Header"."Transfer-from Post Code")
                    {
                    }
                    column(InTransitCode_TransHdr; "Transfer Receipt Header"."In-Transit Code")
                    {
                        IncludeCaption = true;
                    }
                    column(PostingDate_TransHdr; Format("Transfer Receipt Header"."Posting Date", 0, 4))
                    {
                    }
                    column(TransferToAddr7; TransferToAddr[7])
                    {
                    }
                    column(TransferToAddr8; TransferToAddr[8])
                    {
                    }
                    column(PageCaption; StrSubstNo(Text002, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(ShptMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    //SOTHIS EBR 070920 id 159231
                    column(logo; CompanyInfo1.LogoCertificacion)
                    { }
                    //fin SOTHIS EBR 070920 id 159231
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Transfer Receipt Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(Number_DimensionLoop1; Number)
                        {
                        }
                        column(HdrDimensionsCaption; HdrDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break;
                        end;
                    }
                    dataitem("Transfer Receipt Line"; "Transfer Receipt Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Transfer Receipt Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(ItemNo_TransLine; "Item No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Desc_TransLine; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(Qty_TransLine; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(UOM_TransLine; "Unit of Measure")
                        {
                            IncludeCaption = true;
                        }
                        column(Qty_TransLineShipped; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(QtyReceived_TransLine; Quantity) { IncludeCaption = true; }



                        column(TransFromBinCode_TransLine; "Transfer Receipt Line"."Transfer-from Code")
                        {
                            IncludeCaption = true;
                        }
                        column(TransToBinCode_TransLine; "Transfer-to Code")
                        {
                            IncludeCaption = true;
                        }
                        column(LineNo_TransLine; "Line No.")
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText2; DimText)
                            {
                            }
                            column(Number_DimensionLoop2; Number)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break;
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
                            DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");

                            RecMemLotes.Reset();
                            RecMemLotes.DeleteAll();
                            RetrieveLotAndExpFromPostedInv("Document No.", "Line No.", RecMemLotes);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text000;
                        OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }



            trigger OnAfterGetRecord()
            var
                CodCliente: Code[20];
                Cliente: Record Customer;
                PedidosTransferencia: Codeunit Funciones;
            begin
                if not PedidoImpreso then begin
                    PedidoImpreso := true;
                    if Modify() then;
                end;

                totalBultos := 0;
                totalPeso := 0;
                totalPalets := 0;

                totalBultos := NumBultos_btc;
                totalPeso := Peso_btc;
                totalPalets := NumPalets_btc;

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init;

                if optIdioma <> optIdioma::" " then
                    CurrReport.LANGUAGE := Language.GetLanguageID(format(optIdioma));

                CodCliente := '';

                if UserId <> 'BC' then begin
                    CodCliente := PedidosTransferencia.ObtenerValorCampoExtension(DATABASE::"Transfer Receipt Header", 50600, 1, "No.");
                    TransferToAddr[1] := "Transfer Receipt Header"."Transfer-to Name";
                    if CodCliente <> '' then begin
                        Cliente.Get(CodCliente);
                        TransferToAddr[1] := Cliente.Name + ' (' + CodCliente + ')';
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
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Location;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Location;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
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
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        PostingDateCaption = 'Fecha Registro';
        ShptMethodDescCaption = 'Método Envío';
    }
    //SOTHIS EBR 070920 id 15923
    trigger OnInitReport();
    begin
        CompanyInfo.GET();
        SalesSetup.GET();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        CompanyInfo1.get();
        CompanyInfo1.CalcFields(Picture);

        CompanyInfo1.CalcFields(LogoCertificacion);


    end;
    //fin SOTHIS EBR 070920 id 15923
    var
        optIdioma: Option " ","ENU","ESP","FRA";
        Language: Record Language;
        Text000: Label 'COPIA';
        Text001: Label 'Pedido Transferencia %1';
        Text002: Label 'Página %1';
        ShipmentMethod: Record "Shipment Method";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RecMemLotes: Record MemEstadistica_btc temporary;
        //SOTHIS EBR 070920 id 159231
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        //fin  SOTHIS EBR 070920 id 159231
        FormatAddr: Codeunit "Format Address";
        //SOTHIS EBR 070920 id 159231        
        FormatDocument: Codeunit "Format Document";
        //fin SOTHIS EBR 070920 id 159231
        TransferFromAddr: array[8] of Text[100];
        TransferToAddr: array[8] of Text[100];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        OutputNo: Integer;
        HdrDimensionsCaptionLbl: Label 'Dimensiones Cabecera';
        LineDimensionsCaptionLbl: Label 'Dimensiones Línea';
        PurchOrderCaptionLbl: Label 'NOTA ENTREGA';
        PRCOMPRASLbl: Label 'PR-TRANSFER';
        ISOLbl: Label '';
        PediProveeedorLbl: Label 'Nota de Entrega';
        DesdeLbl: Label 'Desde';
        HastaLbl: Label 'Hasta';
        NumSerieLbl: Label 'Serial No.', comment = 'ESP="Nº Serie"';
        CuadroBultos_BultosLbl: Label 'Bulks:', comment = 'ESP="Bultos:",FRA="Bulks:"';
        CuadroBultos_PaletsLbl: Label 'Pallets:', comment = 'ESP="Palets:",FRA="Palettes"';
        CuadroBultos_VolumenLbl: Label 'Volume(m3):', comment = 'ESP="Volumen(m3):",FRA="Volume(m3):"';
        CuadroBultos_PesoNetoLbl: Label 'Gross Weight(kg):', comment = 'ESP="Peso Neto(kg):",FRA="Gross Weight(kg):"';
        totalPalets: Decimal;
        volumen: Decimal;
        totalPeso: decimal;
        CuadroBultos_IncotermLbl: Label 'INCOTERM:', comment = 'ESP="INCOTERM:"';
        totalBultos: Decimal;

    local procedure RetrieveLotAndExpFromPostedInv(pNumDocumento: Code[20]; pNumLinea: Integer; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary)
    var
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

