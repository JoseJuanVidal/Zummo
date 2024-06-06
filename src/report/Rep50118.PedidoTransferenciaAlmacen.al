report 50118 "PedidoTransferenciaAlmacen"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50118.PedidoTransferenciaAlmacen.rdl';
    Caption = 'Pedido Transferencia Almacén', Comment = 'Transfer Order';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Transfer Order';

            column(CompanyInfo1Picture; CompanyInfo1.Picture) { }
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
            column(ShowBinContents; ShowBinContents)
            {
            }
            column(totalPeso; totalPeso)
            {
            }
            column(NoSerie_Caption; NumSerieLbl) { }
            column(DesdeLbl; DesdeLbl)
            {
            }
            column(totalPalets; totalPalets)
            {
            }
            column(totalBultos; totalBultos)
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
            column(TipoDocumento; TipoDocumento) { }
            column(NoDocumento; NoDocumento) { }
            column(LineaDocumento; LineaDocumento) { }
            column(ProductoProduccion; ProductoProduccion) { }
            column(FechaInicialFab; FechaInicialFab) { }
            column(comment; GetComment) { }

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
                    column(TransferFromAddr1; TransferFromAddr[1])
                    {
                    }
                    column(TransferToAddr2; TransferToAddr[2])
                    {
                    }
                    column(TransferFromAddr2; TransferFromAddr[2])
                    {
                    }
                    column(TransferToAddr3; TransferToAddr[3])
                    {
                    }
                    column(TransferFromAddr3; TransferFromAddr[3])
                    {
                    }
                    column(TransferToAddr4; TransferToAddr[4])
                    {
                    }
                    column(TransferFromAddr4; TransferFromAddr[4])
                    {
                    }
                    column(TransferToAddr5; TransferToAddr[5])
                    {
                    }
                    column(TransferToAddr6; TransferToAddr[6])
                    {
                    }
                    column(InTransitCode_TransHdr; "Transfer Header"."In-Transit Code")
                    {
                        IncludeCaption = true;
                    }
                    column(PostingDate_TransHdr; Format("Transfer Header"."Posting Date", 0, 4))
                    {
                    }
                    column(TransferToAddr7; TransferToAddr[7])
                    {
                    }
                    column(TransferToAddr8; TransferToAddr[8])
                    {
                    }
                    column(TransferFromAddr5; TransferFromAddr[5])
                    {
                    }
                    column(TransferFromAddr6; TransferFromAddr[6])
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
                        DataItemLinkReference = "Transfer Header";
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
                    dataitem("Transfer Line"; "Transfer Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Transfer Header";
                        DataItemTableView = SORTING("Document No.", "Line No.") WHERE("Derived From Line No." = CONST(0));
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
                        column(Qty_TransLineShipped; "Quantity Shipped")
                        {
                            IncludeCaption = true;
                        }
                        column(QtyReceived_TransLine; "Quantity Received")
                        {
                            IncludeCaption = true;
                        }
                        column(TransFromBinCode_TransLine; "Transfer-from Bin Code")
                        {
                            IncludeCaption = true;
                        }
                        column(TransToBinCode_TransLine; "Transfer-To Bin Code")
                        {
                            IncludeCaption = true;
                        }
                        column(LineNo_TransLine; "Line No.")
                        {
                        }
                        column(ContUbicaciones; ContUbicaciones)
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
                            column(SerialContUbicaciones; SerialContUbicaciones)
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

                                SerialContUbicaciones := '';
                                SerialContUbicaciones := GetBinContentItemNo("Transfer Line"."Transfer-from Code", "Transfer Line"."Item No.", -1, RecMemLotes.NoSerie);

                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");

                            // Añadimos las ubicaciones de los productos
                            ContUbicaciones := '';
                            ContUbicaciones := GetBinContentItemNo("Transfer Line"."Transfer-from Code", "Transfer Line"."Item No.", "Transfer Line".Quantity, '');

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
                ProdOrderLine: Record "Prod. Order Line";

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
                FormatAddr.TransferHeaderTransferFrom(TransferFromAddr, "Transfer Header");
                FormatAddr.TransferHeaderTransferTo(TransferToAddr, "Transfer Header");

                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init;

                if optIdioma <> optIdioma::" " then
                    CurrReport.LANGUAGE := Language.GetLanguageID(format(optIdioma));

                CodCliente := '';
                FechaInicialFab := '';
                ProductoProduccion := '';

                if UserId <> 'BC' then begin
                    CodCliente := PedidosTransferencia.ObtenerValorCampoExtension(DATABASE::"Transfer Header", 50600, 1, "No.");

                    TipoDocumento := '';
                    TipoDocumento := PedidosTransferencia.ObtenerValorCampoExtension(DATABASE::"Transfer Header", 50650, 1, "No.");
                    NoDocumento := '';
                    NoDocumento := PedidosTransferencia.ObtenerValorCampoExtension(DATABASE::"Transfer Header", 50610, 1, "No.");
                    LineaDocumento := 0;
                    evaluate(lineadocumento, PedidosTransferencia.ObtenerValorCampoExtension(DATABASE::"Transfer Header", 50620, 1, "No."));
                end;
                ProdOrderLine.reset;
                ProdOrderLine.SetRange("Prod. Order No.", NoDocumento);
                ProdOrderLine.SetRange("Line No.", LineaDocumento);
                if ProdOrderLine.FindFirst() then begin
                    FechaInicialFab := format(ProdOrderLine."Starting Date");
                    ProductoProduccion := ProdOrderLine."Item No." + ' - ' + ProdOrderLine.Description;
                end;

                if CodCliente <> '' then begin
                    Cliente.Get(CodCliente);
                    TransferToAddr[1] := Cliente.Name + ' (' + CodCliente + ')';
                end;
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
                        ApplicationArea = Location;
                        Caption = 'No. of Copies', Comment = 'ESP="Nº Copias"';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Location;
                        Caption = 'Show Internal Information', Comment = 'ESP="Mostrar Informacion Interna"';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(ShowComment; ShowComment)
                    {
                        ApplicationArea = Location;
                        Caption = 'Show Comments', Comment = 'ESP="Mostrar Comentarios"';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(ShowBinContents; ShowBinContents)
                    {
                        ApplicationArea = Location;
                        Caption = 'Mostrar Ubicaciones producto', comment = 'ESP="Mostrar Ubicaciones producto"';
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

        trigger OnOpenPage()
        begin
            ShowComment := true;
            if (UserId = 'ALMACEN') or UserSetup."Informes Almacen" then
                ShowBinContents := true;
        end;
    }

    labels
    {
        PostingDateCaption = 'Fecha Registro';
        ShptMethodDescCaption = 'Método Envío';
    }
    //SOTHIS EBR 070920 id 15923
    trigger OnInitReport();
    begin
        if UserSetup.Get(UserId) then;
        CompanyInfo.GET();
        SalesSetup.GET();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        CompanyInfo1.get();
        CompanyInfo1.CalcFields(Picture);

        CompanyInfo1.CalcFields(LogoCertificacion);


    end;
    //fin SOTHIS EBR 070920 id 15923
    var
        UserSetup: Record "User Setup";
        PedidosTransferencia: Codeunit Funciones;
        //SOTHIS EBR 070920 id 159231        
        FormatDocument: Codeunit "Format Document";
        //fin SOTHIS EBR 070920 id 159231
        CuadroBultos_IncotermLbl: Label 'INCOTERM:', comment = 'ESP="INCOTERM:"';
        totalBultos: Decimal;
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
        TransferFromAddr: array[8] of Text[100];
        TransferToAddr: array[8] of Text[100];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        ShowComment: Boolean;
        ShowBinContents: Boolean;
        ContUbicaciones: text;
        SerialContUbicaciones: text;
        Continue: Boolean;
        OutputNo: Integer;
        HdrDimensionsCaptionLbl: Label 'Dimensiones Cabecera';
        LineDimensionsCaptionLbl: Label 'Dimensiones Línea';
        PurchOrderCaptionLbl: Label 'PEDIDO TRANSFERENCIA';
        PRCOMPRASLbl: Label 'PR-GESTION DE PEDIDOS DE CLIENTES';
        ISOLbl: Label 'FO.05_C3.02_V02';
        PediProveeedorLbl: Label 'Nota de Entrega';
        DesdeLbl: Label 'Desde';
        HastaLbl: Label 'Hasta';
        NumSerieLbl: Label 'Serial No.', comment = 'ESP="Nº Serie"';
        FechaInicialFab: text;
        TipoDocumento: Code[30];
        NoDocumento: Code[30];
        LineaDocumento: Integer;
        ProductoProduccion: Text;
        CuadroBultos_BultosLbl: Label 'Bulks:', comment = 'ESP="Bultos:",FRA="Bulks:"';
        CuadroBultos_PaletsLbl: Label 'Pallets:', comment = 'ESP="Palets:",FRA="Palettes"';
        CuadroBultos_VolumenLbl: Label 'Volume(m3):', comment = 'ESP="Volumen(m3):",FRA="Volume(m3):"';
        CuadroBultos_PesoNetoLbl: Label 'Gross Weight(kg):', comment = 'ESP="Peso Neto(kg):",FRA="Gross Weight(kg):"';
        totalPalets: Decimal;
        volumen: Decimal;
        totalPeso: decimal;

    local procedure RetrieveLotAndExpFromPostedInv(pNumDocumento: Code[20]; pNumLinea: Integer; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary)
    var
        recReservationEntry: Record "Reservation Entry";
        NumMov: Integer;
    begin
        // retrieves a data set of Item Ledger Entries (Posted Invoices)
        RecMemEstadisticas.RESET();
        RecMemEstadisticas.DELETEALL();
        NumMov := 1;

        recReservationEntry.Reset();
        recReservationEntry.SetRange("Source ID", pNumDocumento);
        recReservationEntry.SetRange("Source Ref. No.", pNumLinea);
        if recReservationEntry.FindSet() then
            repeat
                RecMemEstadisticas.INIT();
                RecMemEstadisticas.NoMov := NumMov;
                NumMov += 1;
                RecMemEstadisticas.NoLote := recReservationEntry."Lot No.";
                RecMemEstadisticas.NoSerie := recReservationEntry."Serial No.";
                RecMemEstadisticas.Noproducto := recReservationEntry."Item No.";
                RecMemEstadisticas.INSERT();
            until recReservationEntry.Next() = 0;
    end;

    local procedure GetBinContentItemNo(LocationCode: code[10]; ItemNo: code[20]; Quantity: Decimal; SerialNo: code[50]) BinContens: text
    var
        Item: Record Item;
        Funciones: Codeunit Funciones;
        ListBinContent: List of [code[20]];
        ListQtyBinContent: List of [decimal];
        BinCode: code[20];
        BinQuantity: Decimal;
        i: Integer;
    begin
        if Item.Get(ItemNo) then
            if (Item."Item Tracking Code" <> '') and (SerialNo = '') then
                exit;
        Funciones.GetBinContentItemNo(LocationCode, ItemNo, Quantity, SerialNo, ListBinContent, ListQtyBinContent);

        foreach BinCode in ListBinContent do begin
            i += 1;
            BinQuantity := ListQtyBinContent.Get(i);
            if BinContens <> '' then
                BinContens += '-';
            BinContens += StrSubstNo('%1 (%2)', BinCode, BinQuantity)
        end;
    end;

    local procedure GetComment() Comment: text
    var
        InventoryCommentLine: Record "Inventory Comment Line";
        LF: Char;
        FF: Char;
    begin
        if not ShowComment then
            exit;
        LF := 10;
        FF := 13;
        InventoryCommentLine.Reset();
        InventoryCommentLine.SetRange("Document Type", InventoryCommentLine."Document Type"::"Transfer Order");
        InventoryCommentLine.SetRange("No.", "Transfer Header"."No.");
        if InventoryCommentLine.FindFirst() then
            repeat
                if Comment <> '' then
                    Comment += format(LF) + Format(FF);
                Comment += InventoryCommentLine.Comment;
            Until InventoryCommentLine.next() = 0;
    end;
}

