codeunit 50111 "Funciones"
{
    Permissions = tabledata "Item Ledger Entry" = rm, tabledata "Sales Invoice Header" = rmid, tabledata "G/L Entry" = rmid,
        tabledata "Sales Shipment Header" = rmid, tabledata "Sales Cr.Memo Header" = rmid, tabledata "Sales Header Archive" = rmid,
        tabledata "Return Shipment Header" = rmid, tabledata "Purch. Rcpt. Header" = rmid, tabledata "Purch. Rcpt. Line" = rmid,
        tabledata "Sales Cr.Memo Line" = rmid, tabledata "Sales Invoice Line" = rmid, tabledata "Job Ledger Entry" = rmid;
    TableNo = "Sales Header";


    trigger OnRun()
    var
        TipoDoc: integer;
        NumDoc: Code[20];
    begin
        ImprimirPedido(Rec."Document Type", Rec."No.");
    end;

    procedure ImprimirPedido(TipoDoc: integer; NumDoc: Code[20])

    var
        SalesHeader: Record "Sales Header";
        rSalesHead: Record "Sales Header";
        Selection: Integer;
        rep: Report PedidoCliente;
    begin

        SalesHeader.Reset();
        SalesHeader.get(TipoDoc, numDoc);

        rSalesHead.Reset();
        rSalesHead.SetRange("Document Type", TipoDoc);
        rSalesHead.SetRange("No.", NumDoc);


        if SalesHeader.FindFirst() then begin
            //case Selection of

            rep.Pvalorado(false);
            rep.Pneto(false);
            rep.PTipoDocumento(1);//1 pedido 2 proforma
            rep.Pvalorado(false);
            rep.SetTableView(rSalesHead);
            rep.run();

            //end;
        end;
    end;

    procedure ObtenerPesosFactura(CodFactura: Code[20]; var Peso: Decimal;
        var NumPalets: Integer;
        var Bultos: Integer)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Albaran: Record "Sales Shipment Header";
        LinAlbaran: Record "Sales Shipment Line";
        ValueEntry: record "Value Entry";
        SalesInvLine: Record "Sales Invoice Line";
        CodAlbaran: Code[20];

        SalesInvoiceHeader: record "Sales Invoice Header";
        TempSalesShptLine: Record "Sales Shipment Line" temporary;
    begin
        TempSalesShptLine.RESET;
        TempSalesShptLine.DELETEALL;
        SalesInvLine.SetRange("Document No.", CodFactura);
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        if SalesInvLine.FindSet() then
            repeat
                ValueEntry.RESET;
                ValueEntry.SETCURRENTKEY("Document No.");
                ValueEntry.SETRANGE("Document No.", SalesInvLine."Document No.");
                ValueEntry.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                ValueEntry.SETRANGE("Document Line No.", SalesInvLine."Line No.");
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.");
                        IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN
                            IF LinAlbaran.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.") THEN BEGIN
                                TempSalesShptLine.INIT;
                                TempSalesShptLine := LinAlbaran;
                                IF TempSalesShptLine.INSERT THEN;
                                if (LinAlbaran."Document No." <> CodAlbaran) then begin
                                    Albaran.Get(LinAlbaran."Document No.");
                                    Peso += Albaran.Peso_btc;
                                    NumPalets += Albaran.NumPalets_btc;
                                    Bultos += Albaran.NumBultos_btc;
                                end;
                                CodAlbaran := LinAlbaran."Document No.";

                            END;
                        ;
                    UNTIL ValueEntry.NEXT = 0;
            until SalesInvLine.Next() = 0;
    end;




    procedure ObtenerNumFacturaAlbaran(Albaran: Record "Sales Shipment Header"): Code[20]
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesInvLine: Record "Sales Invoice Line";
        ValueEntry: record "Value Entry";
        LinAlbaran: Record "Sales Shipment Line";
        NumFactura: Code[20];
    begin
        LinAlbaran.SetRange("Document No.", Albaran."No.");
        LinAlbaran.SetRange(Type, LinAlbaran.Type::Item);
        if LinAlbaran.FindFirst() then begin
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETCURRENTKEY("Document No.");
            ItemLedgerEntry.SETRANGE("Document No.", LinAlbaran."Document No.");
            ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
            ItemLedgerEntry.SETRANGE("Document Line No.", LinAlbaran."Line No.");

            ItemLedgerEntry.SETFILTER("Invoiced Quantity", '<>0');
            IF ItemLedgerEntry.FindFirst() THEN BEGIN
                ValueEntry.SETCURRENTKEY("Item Ledger Entry No.", "Entry Type");
                ValueEntry.SETRANGE("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                ValueEntry.SETFILTER("Invoiced Quantity", '<>0');
                ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                IF ValueEntry.FindFirst() THEN begin

                    IF ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Invoice" THEN
                        IF SalesInvLine.GET(ValueEntry."Document No.", ValueEntry."Document Line No.") THEN BEGIN
                            Exit(SalesInvLine."Document No.");
                        END;
                end;
            end;
        END;
        exit('');
    end;


    procedure BorrarSeguimientos(tabla: Integer; DocumentNo: Code[20]; LinDocumento: integer)
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
    begin

        //ReservationEntry.SETRANGE("Location Code", Almacen);
        ReservationEntry.SETRANGE("Source ID", DocumentNo);
        ReservationEntry.SETRANGE(ReservationEntry."Source Ref. No.", LinDocumento);
        ReservationEntry.SETRANGE(ReservationEntry."Source Type", tabla);
        ReservationEntry.SetFilter("Reservation Status", '<>%1', ReservationEntry."Reservation Status"::Reservation);
        IF ReservationEntry.FINDSET() THEN
            REPEAT
                ReservationEntry.DELETE;
                if ReservationEntry2.GET(ReservationEntry."Entry No.", NOT (ReservationEntry.Positive)) then
                    ReservationEntry2.DELETE;
            UNTIL ReservationEntry.NEXT() = 0;
    end;



    procedure GetTradDescCuenta(pCodCuenta: code[20]; pCodIdioma: code[10]): text[100]
    var
        recTextos: Record "Extended Text Header";
    begin
        recTextos.Reset();
        recTextos.SetRange("Table Name", recTextos."Table Name"::"G/L Account");
        recTextos.SetRange("Language Code", pCodIdioma);
        recTextos.SetFilter(Description, '<>%1', '');
        if recTextos.FindFirst() then
            exit(recTextos.Description)
        else
            exit('');
    end;


    procedure GetTradDescProducto(pCodProducto: code[20]; pCodVariante: code[10]; pCodIdioma: code[10]): text[100]
    var
        recItemTranslation: Record "Item Translation";
    begin
        if recItemTranslation.get(pCodProducto, pCodVariante, pCodIdioma) then
            exit(recItemTranslation.Description);

        exit('');
    end;


    procedure AmountToLCY(FCAmount: Decimal; CurrencyFactor: Decimal; CurrencyCode: Code[10]; CurrencyDate: Date): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
    begin
        Currency.GET(CurrencyCode);
        Currency.TESTFIELD("Unit-Amount Rounding Precision");
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              CurrencyDate, CurrencyCode,
              FCAmount, CurrencyFactor),
            Currency."Unit-Amount Rounding Precision"));
    end;


    procedure ObtenerMtosTrazabilidadNumSerie(NumSerie: Code[20]; var tempItemLedgerEntry: Record "Item Ledger Entry"; AbrirPage: boolean)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntry2: Record "Item Ledger Entry";
        NumMtoLiquidado: Integer;
        AssembleToOrderLink: Record "Posted Assemble-to-Order Link";
        Factura: record "Sales Invoice Header";
        Albaran: Record "Sales Shipment Header";
        p: Page PedirDatoZummo;
    begin

        p.SetDato(NumSerie);
        p.RunModal();
        NumSerie := p.GetDato();

        tempItemLedgerEntry.SetCurrentKey("Entry No.");
        if (NumSerie = '') then Error('Sólo es posible trazar Números de Serie.');

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Serial No.", NumSerie);
        if ItemLedgerEntry.FindSet() then
            repeat
                tempItemLedgerEntry.Init();
                tempItemLedgerEntry.Copy(ItemLedgerEntry);
                tempItemLedgerEntry.Insert();
                //Si es de tipo Albaran--> Inserto Factura.
                if (ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment") then begin
                    //Si se ha desecho Envio puede no existir Albran per si Mto Prod del albaran deshecho.
                    //Hago insert
                    tempItemLedgerEntry."Order No." := Albaran."Order No.";
                    tempItemLedgerEntry.Modify();
                    //Si se ha desecho Envio puede no existir Albran per si Mto Prod del albaran deshecho.
                    if Albaran.get(ItemLedgerEntry."Document No.") then begin
                        Factura.Reset();
                        Factura.SetRange("Order No.", Albaran."Order No.");
                        if Factura.FindFirst() then begin
                            tempItemLedgerEntry.Init();
                            tempItemLedgerEntry.Copy(ItemLedgerEntry);
                            tempItemLedgerEntry."Order No." := Albaran."Order No.";
                            tempItemLedgerEntry."Document Type" := tempItemLedgerEntry."Document Type"::"Service Invoice";
                            tempItemLedgerEntry."Posting Date" := Factura."Posting Date";
                            tempItemLedgerEntry."Entry No." := tempItemLedgerEntry."Entry No." + 1000000;
                            tempItemLedgerEntry."Document No." := Factura."No.";
                            tempItemLedgerEntry.Insert();
                        end;
                    end;
                end;

                // Si es Consumo de ensamblado busco salida de esnsambado de ese Consumo
                if (ItemLedgerEntry."Entry Type" = ItemLedgerEntry."Entry Type"::"Assembly Consumption") then begin
                    ItemLedgerEntry2.Reset();
                    ItemLedgerEntry2.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::"Assembly Output");
                    ItemLedgerEntry2.SetRange("Order No.", ItemLedgerEntry."Order No.");
                    if ItemLedgerEntry2.FindFirst() then begin
                        if not (tempItemLedgerEntry.Get(ItemLedgerEntry2."Entry No.")) then begin
                            tempItemLedgerEntry.Init();
                            tempItemLedgerEntry.Copy(ItemLedgerEntry2);
                            tempItemLedgerEntry.Insert();
                            NumMtoLiquidado := ItemLedgerEntry2."Applies-to Entry";
                        end;
                    end;
                    //Recorro Ensamblado
                    AssembleToOrderLink.SetRange("Document Type", AssembleToOrderLink."Document Type"::"Sales Shipment");
                    AssembleToOrderLink.SetRange(AssembleToOrderLink."Assembly Document No.", tempItemLedgerEntry."Document No.");
                    // AssembleToOrderLink.SetRange(AssembleToOrderLink."Document Line No.", tempItemLedgerEntry."Document Line No.");
                    if AssembleToOrderLink.FindSet() then
                        repeat
                            ItemLedgerEntry2.Reset();
                            ItemLedgerEntry2.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                            ItemLedgerEntry2.SetRange("Document No.", AssembleToOrderLink."Document No.");
                            ItemLedgerEntry2.SetRange(ItemLedgerEntry2."Document Line No.", AssembleToOrderLink."Document Line No.");
                            if ItemLedgerEntry2.FindFirst() then begin
                                if not (tempItemLedgerEntry.Get(ItemLedgerEntry2."Entry No.")) then begin
                                    tempItemLedgerEntry.Init();
                                    tempItemLedgerEntry.Copy(ItemLedgerEntry2);
                                    tempItemLedgerEntry."Order No." := AssembleToOrderLink."Order No.";//Pedido
                                    tempItemLedgerEntry."Order Line No." := AssembleToOrderLink."Order Line No."; //Lin.Pedido
                                    tempItemLedgerEntry.Insert();
                                    //Inserto Mto de Factura
                                    Factura.Reset();
                                    Factura.SetRange("Order No.", AssembleToOrderLink."Order No.");
                                    if Factura.FindFirst() then begin
                                        tempItemLedgerEntry.Init();
                                        tempItemLedgerEntry.Copy(ItemLedgerEntry2);
                                        tempItemLedgerEntry."Order No." := AssembleToOrderLink."Order No.";
                                        tempItemLedgerEntry."Document Type" := tempItemLedgerEntry."Document Type"::"Service Invoice";
                                        tempItemLedgerEntry."Posting Date" := Factura."Posting Date";
                                        tempItemLedgerEntry."Entry No." := tempItemLedgerEntry."Entry No." + 1000000;
                                        tempItemLedgerEntry."Document No." := Factura."No.";
                                        tempItemLedgerEntry.Insert();
                                    end;
                                end;
                            end;
                        until AssembleToOrderLink.Next() = 0;
                end;
            until ItemLedgerEntry.Next() = 0;

        //Mismo bucle pero con Cod.Anterior

        if (AbrirPage) then begin
            tempItemLedgerEntry.Reset();
            Page.Run(Page::"Item Ledger Entries", tempItemLedgerEntry);
        end;
    end;


    procedure ObtenerMtosVentaSerie(var tempItemLedgerEntry: Record "Item Ledger Entry"; AbrirPage: boolean)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntry2: Record "Item Ledger Entry";
        AssembleToOrderLink: Record "Posted Assemble-to-Order Link";
        Factura: record "Sales Invoice Header";
        Albaran: Record "Sales Shipment Header";
        Item: Record Item;
    begin
        tempItemLedgerEntry.SetCurrentKey("Entry No.");
        //BUCLE CON NUM.SERIE DIRECTO
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        ItemLedgerEntry.SetFilter("Serial No.", '<>''''');
        //ItemLedgerEntry.SetRange("Serial No.", '02180098');

        if ItemLedgerEntry.FindSet() then
            repeat
                //Verifico que lleve SN de tracking por si las moscas
                Item.Get(ItemLedgerEntry."Item No.");
                if Item."Item Tracking Code" = 'SEGNS' then begin

                    tempItemLedgerEntry.Init();
                    tempItemLedgerEntry.Copy(ItemLedgerEntry);
                    tempItemLedgerEntry."Order Type" := tempItemLedgerEntry."Order Type"::" ";
                    if Albaran.get(ItemLedgerEntry."Document No.") then begin
                        tempItemLedgerEntry."Order No." := Albaran."Order No.";
                        Factura.Reset();
                        Factura.SetRange("Order No.", Albaran."Order No.");
                        tempItemLedgerEntry."External Document No." := 'NO FACTURADO';
                        if Factura.FindFirst() then begin
                            tempItemLedgerEntry."External Document No." := Factura."No.";
                            tempItemLedgerEntry."Lot No." := Albaran."Sell-to Customer Name";
                        end;
                    end;
                    tempItemLedgerEntry.Insert();
                end;

            until ItemLedgerEntry.Next() = 0;

        //BUCLE ENSAMBLADO: Si es Consumo de ensamblado busco salida de esnsamblado de ese Consumo
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Posted Assembly");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::"Assembly Consumption");
        ItemLedgerEntry.SetFilter("Serial No.", '<>''''');

        if ItemLedgerEntry.FindSet() then
            repeat
                //Busco Mto de la Salida de Ensamblado de ese Pedido
                ItemLedgerEntry2.Reset();
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Posted Assembly");
                ItemLedgerEntry2.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::"Assembly Output");
                ItemLedgerEntry2.SetRange("Order No.", ItemLedgerEntry."Order No.");
                if ItemLedgerEntry2.FindFirst() then;

                //Recorro Ensamblado
                AssembleToOrderLink.SetRange("Document Type", AssembleToOrderLink."Document Type"::"Sales Shipment");
                AssembleToOrderLink.SetRange(AssembleToOrderLink."Assembly Document No.", ItemLedgerEntry2."Document No."); //Pedido Ensam Reg
                // AssembleToOrderLink.SetRange(AssembleToOrderLink."Document Line No.", tempItemLedgerEntry."Document Line No.");
                if AssembleToOrderLink.FindSet() then
                    repeat
                        //Busco Mto de Alb Venta
                        ItemLedgerEntry2.Reset();
                        ItemLedgerEntry2.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                        ItemLedgerEntry2.SetRange("Document No.", AssembleToOrderLink."Document No."); //Albaran
                        ItemLedgerEntry2.SetRange(ItemLedgerEntry2."Document Line No.", AssembleToOrderLink."Document Line No."); //Lin.Alb
                        if ItemLedgerEntry2.FindFirst() then begin
                            if not (tempItemLedgerEntry.Get(ItemLedgerEntry2."Entry No.")) then begin

                                tempItemLedgerEntry.Init();
                                tempItemLedgerEntry.Copy(ItemLedgerEntry2);
                                tempItemLedgerEntry."Order Type" := tempItemLedgerEntry."Order Type"::Assembly;

                                tempItemLedgerEntry."Order No." := AssembleToOrderLink."Order No."; //Pedido
                                tempItemLedgerEntry."Order Line No." := AssembleToOrderLink."Order Line No."; //Lin.Pedido
                                if Albaran.get(AssembleToOrderLink."Document No.") then begin
                                    tempItemLedgerEntry."Lot No." := Albaran."Sell-to Customer Name";

                                    Factura.Reset();
                                    //Factura.SetRange("Order No.", Albaran."Order No.");
                                    Factura.SetRange("Order No.", AssembleToOrderLink."Order No.");
                                    tempItemLedgerEntry."External Document No." := 'NO FACTURADO';
                                    if Factura.FindFirst() then begin
                                        tempItemLedgerEntry."External Document No." := Factura."No.";
                                    end;
                                    tempItemLedgerEntry.Insert();
                                end;

                            end;
                        end;

                    until AssembleToOrderLink.Next() = 0;
            until ItemLedgerEntry.Next() = 0;

        //Mismo bucle pero con Cod.Anterior

        if (AbrirPage) then begin
            tempItemLedgerEntry.Reset();
            Page.Run(Page::"Item Ledger Entries", tempItemLedgerEntry);
        end;
    end;

    procedure GetActivaDivisasFechaEmision(): Boolean
    var
        recGenLedgSetup: Record "General Ledger Setup";
    begin
        recGenLedgSetup.Get();

        if recGenLedgSetup.TipoCambioPorFechaEmision_btc then
            exit(true)
        else
            exit(false);
    end;

    procedure GetDivisaLocal(): Code[10]
    var
        recGenLedgSetup: Record "General Ledger Setup";
    begin
        recGenLedgSetup.Get();
        recGenLedgSetup.TestField("LCY Code");
        exit(recGenLedgSetup."LCY Code");
    end;

    procedure ExisteTipoCambio(pCodDivisa: Code[10]; pFechaCambio: Date): Boolean
    var
        recCurrExchange: Record "Currency Exchange Rate";
        fechaDiaAnterior: Date;
    begin
        if (pCodDivisa = '') or (pCodDivisa = GetDivisaLocal()) then
            exit(true);

        exit(true);

        recCurrExchange.Reset();
        recCurrExchange.SetRange("Currency Code", pCodDivisa);
        recCurrExchange.SetRange("Starting Date", pFechaCambio);
        if recCurrExchange.IsEmpty() then begin
            fechaDiaAnterior := CalcDate('-1D', pFechaCambio);
            recCurrExchange.SetRange("Starting Date", fechaDiaAnterior);
            if recCurrExchange.IsEmpty() then
                exit(false)
            else
                exit(true);
        end else
            exit(true);
    end;


    procedure PagPostedBillsSettleAction(var RecPostcarteraDoc: Record "Posted Cartera Doc.")
    var
        Text1100000Txt: Label 'No bills have been found that can be settled. \', comment = 'ESP="No se han encontrado facturas que puedan liquidarse"';
        Text1100001Txt: Label 'Please check that at least one open bill was selected.', Comment = 'ESP="Verifique que se haya seleccionado al menos una factura abierta"';
    begin
        if not RecPostcarteraDoc.Find('=><') then
            exit;

        RecPostcarteraDoc.SetRange(Status, RecPostcarteraDoc.Status::Open);
        if not RecPostcarteraDoc.FindFirst() then
            Error(
              Text1100000Txt +
              Text1100001Txt);
        if RecPostcarteraDoc.Type = RecPostcarteraDoc.Type::Receivable then
            REPORT.RunModal(REPORT::SettleDocsinPostBillGrTSR_BTC, true, false, RecPostcarteraDoc)
        else
            REPORT.RunModal(REPORT::"Settle Docs. in Posted PO", true, false, RecPostcarteraDoc);
    end;

    procedure PagDocsPostedBGAction(var RecPostcarteraDoc: Record "Posted Cartera Doc.")
    var
        Text1100000Txt: Label 'No documents have been found that can be settled. \', comment = 'ESP="No se han encontrado documentos que puedan ser resueltos"';
        Text1100001Txt: Label 'Please check that at least one open document was selected.', comment = 'ESP="Compruebe que se haya seleccionado al menos un documento abierto"';
    begin
        if not RecPostcarteraDoc.Find('=><') then
            exit;

        RecPostcarteraDoc.SetRange(Status, RecPostcarteraDoc.Status::Open);
        if not RecPostcarteraDoc.FindFirst() then
            Error(
              Text1100000Txt +
              Text1100001Txt);

        REPORT.RunModal(REPORT::"Settle Docs. in Posted PO_BTC", true, false, RecPostcarteraDoc);
    end;

    procedure ObtenerValorCampoExtension(tabla: integer; campo: integer; CampoClave: Integer; valorClave: Code[20]) sTxt: Text[20];
    var
        vRecordRef: RecordRef;
        vFieldRef: FieldRef;
    begin
        vRecordRef.OPEN(tabla);
        vFieldRef := vRecordRef.FIELD(CampoClave); //CP
        vFieldRef.SETFILTER(valorClave);

        IF vRecordRef.FINDFIRST THEN begin
            vFieldRef := vRecordRef.FIELD(campo);
            sTxt := FORMAT(vFieldRef.VALUE);
        end;
    end;

    procedure ChangeExtDocNoPostedSalesInvoice(InvoiceNo: code[20]; ExtDocNo: Text[35]; NewWorkDescription: text; AreaManager: Code[20]; ClienteReporting: code[20]; CurrChange: Decimal; PackageTrackingNo: text[30]; InsideSales: code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TempBlob: Record TempBlob temporary;
    begin
        if SalesInvoiceHeader.Get(InvoiceNo) then begin
            SalesInvoiceHeader."External Document No." := ExtDocNo;
            SalesInvoiceHeader.AreaManager_btc := AreaManager;
            SalesInvoiceHeader.InsideSales_btc := InsideSales;
            SalesInvoiceHeader.ClienteReporting_btc := ClienteReporting;
            SalesInvoiceHeader.CurrencyChange := CurrChange;
            CLEAR(SalesInvoiceHeader."Work Description");
            if not (NewWorkDescription = '') then begin
                TempBlob.Blob := SalesInvoiceHeader."Work Description";
                TempBlob.WriteAsText(NewWorkDescription, TEXTENCODING::UTF8);
                SalesInvoiceHeader."Work Description" := TempBlob.Blob;
            end;
            SalesInvoiceHeader."Package Tracking No." := PackageTrackingNo;
            SalesInvoiceHeader.Modify();
        end;
    end;


    procedure CheckFilterOneLocation(var Item: Record Item)
    var
        Location: Record Location;
        Text000: label 'No se puede realizar planificacicón con Agrupación y multiples filtros de Almacén', Comment = 'ESP="No se puede realizar planificación con Agrupación y multiples filtros de Almacén"';
    begin
        if Item.GetFilter("Location Filter") = '' then
            Error('Debe Seleccionar el Almacén principal');
        Location.SetFilter(Code, item.GetFilter("Location Filter"));
        if Location.count > 1 then
            Error(text000);

    end;

    procedure SetFilterOneLocation(var Item: Record Item)
    var
        Location: Record Location;
        Text000: label 'No se puede realizar planificacicón con Agrupación y multiples filtros de Almacén', Comment = 'ESP="No se puede realizar planificación con Agrupación y multiples filtros de Almacén"';
    begin
        //if Item.GetFilter("Location Filter") <> 'MMPP' then
        //    Error('Debe Seleccionar el Almacén principal MMPP');
        // Location.SetFilter(Code, item.GetFilter("Location Filter"));
        // if Location.count > 1 then
        //     Error(text000);
        SetFilterLocations(Item);

    end;

    procedure SetFilterLocations(var Item: Record Item)
    var
        Location: Record Location;
        LocFilter: Text;
    begin
        Location.Reset();
        Location.SetRange(CalculoPlanificaion, true);
        if Location.findset() then
            repeat
                if LocFilter <> '' then
                    LocFilter += '|';
                LocFilter += Location.Code;
            Until Location.next() = 0;
        if Item.STHFilterLocation = '' then
            Item.STHFilterLocation := 'MMPP'; //Item.GetFilter("Location Filter");
        if LocFilter <> '' then
            Item.SetFilter("Location Filter", LocFilter);
    end;

    procedure ChangeFilterOneLocation(var InventoryProfile: Record "Inventory Profile"; var Item: record Item)
    begin
        if item.STHUseLocationGroup then begin
            if Item.STHFilterLocation <> '' then begin
                InventoryProfile.Reset();
                InventoryProfile.ModifyAll("Location Code", Item.STHFilterLocation);
            end
        end
    end;

    procedure ResetFilterOneLocation(var Item: record Item)
    begin
        Item.SetFilter("Location Filter", item.STHFilterLocation);
    end;

    procedure DeleteFilterOneLocation(var WorkSheetName: code[10]; FilterLocation: code[100])
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.SetRange("Journal Batch Name", WorkSheetName);
        //ReqLine.SetRange("Worksheet Template Name", 'PLANIF.');
        ReqLine.SetFilter("Location Code", '<>%1', FilterLocation);
        //ReqLine.DeleteAll();
        if ReqLine.findset() then
            repeat
                if ReqLine."Location Code" <> FilterLocation then
                    ReqLine.Delete();
            Until ReqLine.next() = 0;
    end;

    procedure GetExtensionFieldValuetext(vRecordIf: RecordId; fieldNo: Integer; CalcField: boolean): text
    var
        vRecRef: RecordRef;
        vFieldRef: FieldRef;
    begin
        if vRecRef.Get(vRecordIf) then begin
            if vRecRef.FieldExist(fieldNo) then begin
                vFieldRef := vRecRef.field(fieldNo);
                if CalcField then
                    vFieldRef.CalcField();
                Exit(vFieldRef.Value);
            end;
        end;
    end;

    procedure GetExtensionFieldValueDate(vRecordIf: RecordId; fieldNo: Integer; CalcField: boolean): Date
    var
        vRecRef: RecordRef;
        vFieldRef: FieldRef;
    begin
        if vRecRef.Get(vRecordIf) then begin
            if vRecRef.FieldExist(fieldNo) then begin
                vFieldRef := vRecRef.field(fieldNo);
                if CalcField then
                    vFieldRef.CalcField();
                Exit(vFieldRef.Value);
            end;
        end;
    end;

    procedure SetExtensionFieldValueDate(vRecordIf: RecordId; fieldNo: Integer; Valor: date)
    var
        vRecRef: RecordRef;
        vFieldRef: FieldRef;
    begin
        if vRecRef.Get(vRecordIf) then begin
            if vRecRef.FieldExist(fieldNo) then begin
                vFieldRef := vRecRef.field(fieldNo);
                vFieldRef.Value := valor;
                vRecRef.modify;
            end;
        end;
    end;

    procedure SetExtensionRecRefFieldValueDate(DocNo: code[20]; Valor: date)
    var
        vRecRef: RecordRef;
        vFieldRef: FieldRef;
    begin
        vRecRef.Open(66600);
        //        vFieldRef := vRecRef.FIELD(2);   // Tipo Documento = factura
        //      vFieldRef.SetRange(DocNo);
        vFieldRef := vRecRef.FIELD(7);  // Documento No.
        vFieldRef.SetRange(DocNo);
        if vRecRef.FINDSET(FALSE, FALSE) then begin
            vFieldRef := vRecRef.field(30);
            vFieldRef.Value := valor;
            vRecRef.modify;
        end;
    end;

    procedure SIIGBS_SetExtensionRecRefFieldValueDate(DocNo: code[20]; Valor: date)
    var
        vRecRef: RecordRef;
        vFieldRef: FieldRef;
    begin
        vRecRef.Open(88208);
        //        vFieldRef := vRecRef.FIELD(2);   // Tipo Documento = factura
        //      vFieldRef.SetRange(DocNo);
        vFieldRef := vRecRef.FIELD(4);  // Documento No.
        vFieldRef.SetRange(DocNo);
        if vRecRef.FINDSET(FALSE, FALSE) then begin
            vFieldRef := vRecRef.field(47);  // 47 Fecha operacion
            vFieldRef.Value := valor;
            vRecRef.modify;
        end;
    end;

    procedure CustomerCalculateFechaVto()
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Ventana: Dialog;
        Text000: label 'Código #1###################';
    begin
        Ventana.Open(Text000);
        Customer.SetFilter("Cred_ Max_ Aseg. Autorizado Por_btc", '<>%1', '');
        if Customer.findset() then
            repeat
                Ventana.Update(1, Customer."No.");
                CustLedgerEntry.SetCurrentKey("Due Date");
                CustLedgerEntry.SetRange("Customer No.", Customer."No.");
                CustLedgerEntry.SetRange(Open, true);
                CustLedgerEntry.SetRange(Positive, true);
                if CustLedgerEntry.FindSet() then begin
                    Customer.FechaVtoAseg := CalcDate('+60D', CustLedgerEntry."Due Date");
                    Customer.Modify();
                end;
            Until Customer.next() = 0;
        CustLedgerEntry.Reset();
        CustLedgerEntry.SetRange(FechaVtoAsegurador, 0D);
        if CustLedgerEntry.findset() then
            repeat
                CustLedgerEntry.FechaVtoAsegurador := CalcDate('+60D', CustLedgerEntry."Due Date");
                CustLedgerEntry.Modify();
            Until CustLedgerEntry.next() = 0;
        Ventana.Close();
    end;

    procedure CargaFicheroNominas(JournalBatchName: code[10]; JournalTemplateName: code[10])
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        DimValue: Record "Dimension Value";
        NVInStream: InStream;
        GenJnlLine: record "Gen. Journal Line";
        GenJournalBatch: record "Gen. Journal Batch";
        SeriesNo: Record "No. Series";
        FileMngt: codeunit "File Management";
        SeriesMGt: codeunit NoSeriesManagement;
        FileName: Text;
        Fichero: File;
        txtRecord: text;
        tmpTexto: Text;
        DocNo: text;
        Cuenta: Text;
        DebeHaber: Text;
        Concepto: text;
        CECO: Text;
        Importe: Decimal;
        ImporteDebe: Decimal;
        ImporteHaber: Decimal;
        Fecha: date;
        Dia: Integer;
        Mes: Integer;
        Empleado: text;
        Apunte: text;
        NApunte: Integer;
        Linea: Integer;
        Rows: Integer;
        I: Integer;
        Sheetname: text;
        UploadResult: Boolean;
        Text000: label 'Cargar Fichero de Excel';
        Text001: Label 'Nominas %1 %2';
    begin
        ExcelBuffer.DeleteAll();
        UploadResult := UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream);
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        // miramos si hay serie y los ponemos
        GenJournalBatch.SetRange("Journal Template Name", JournalTemplateName);
        GenJournalBatch.SetRange(name, JournalBatchName);
        GenJournalBatch.FindSet();
        DocNo := SeriesMGt.GetNextNo(GenJournalBatch."No. Series", WorkDate(), false);

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 2);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        if GenJnlLine.FindLast() then
            Linea := GenJnlLine."Line No." + 10000
        else
            linea := 10000;

        for i := 1 to Rows do begin
            Concepto := '';
            CECO := '';
            DebeHaber := '';
            tmpTexto := '';
            ExcelBuffer.SetRange("Row No.", i);
            ExcelBuffer.SetRange("Column No.", 2);
            if ExcelBuffer.FindSet() then
                Apunte := ExcelBuffer."Cell Value as Text";
            if Evaluate(NApunte, apunte) then begin
                ExcelBuffer.SetRange("Column No.", 3);
                if ExcelBuffer.FindSet() then
                    Concepto := ExcelBuffer."Cell Value as Text";
                ExcelBuffer.SetRange("Column No.", 5);
                if ExcelBuffer.FindSet() then
                    CECO := ExcelBuffer."Cell Value as Text";
                ExcelBuffer.SetRange("Column No.", 7);
                if ExcelBuffer.FindSet() then
                    DebeHaber := ExcelBuffer."Cell Value as Text";
                ExcelBuffer.SetRange("Column No.", 8);
                if ExcelBuffer.FindSet() then
                    Cuenta := ExcelBuffer."Cell Value as Text";
                ExcelBuffer.SetRange("Column No.", 11);
                if ExcelBuffer.FindSet() then begin
                    tmpTexto := ExcelBuffer."Cell Value as Text";
                    Evaluate(ImporteDebe, tmpTexto)
                end;
                ExcelBuffer.SetRange("Column No.", 14);
                if ExcelBuffer.FindSet() then begin
                    tmpTexto := ExcelBuffer."Cell Value as Text";
                    Evaluate(ImporteHaber, tmpTexto)
                end;
                if ImporteDebe > 0 then
                    Importe := ImporteDebe
                else
                    Importe := -ImporteHaber;
                fecha := DMY2Date(1);  // primer dia del mes
                GenJnlLine.Init();
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Line No." := Linea;
                GenJnlLine."Posting Date" := Workdate;
                GenJnlLine.Insert();
                GenJnlLine."Document No." := DocNo;
                GenJnlLine."External Document No." := CopyStr(StrSubstNo(text001, Date2DMY(WorkDate(), 2), Date2DMY(WorkDate(), 3)), 1, MaxStrLen(GenJnlLine."Document No."));
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.Validate("Account No.", Cuenta);
                GenJnlLine.Description := Concepto;
                GenJnlLine.Validate(Amount, Importe);
                if CECO <> '' then begin
                    DimValue.Reset();
                    DimValue.SetRange("Global Dimension No.", 1);
                    DimValue.SetRange(code, CECO);
                    if not DimValue.FindSet() then begin
                        DimValue.SetRange(code);
                        DimValue.SetRange(Name, CECO);
                        DimValue.FindSet();
                    end;
                    GenJnlLine.Validate("Shortcut Dimension 1 Code", DimValue.Code);
                    //GenJnlLine.Validate("Shortcut Dimension 2 Code", 
                end;
                GenJnlLine.Modify();
                Linea += 10000;
            end;
        END;
    end;

    procedure ChangeDimensionCECOGLEntries(var GLEntry: Record "G/L Entry"; DimGlobal1: Code[20]; DimGlobal2: Code[20])
    var
        GLSetup: Record "General Ledger Setup";
        recNewDimSetEntry: record "Dimension Set Entry" temporary;
        cduDimMgt: Codeunit DimensionManagement;
        cduCambioDim: Codeunit CambioDimensiones;
        GlobalDim1: code[20];
        GlobalDim2: code[20];
        intDimSetId: Integer;
    begin
        GLSetup.Get;
        // recorremos los movimientos de contabilidad seleccionados
        if GLEntry.findset() then
            repeat
                recNewDimSetEntry.Reset();
                recNewDimSetEntry.DeleteAll();
                // recogemos los valores del dimension SET y cambiamos el CECO por el nuevo CECO
                GetDimSetEntry(recNewDimSetEntry, GLEntry."Dimension Set ID", DimGlobal1, DimGlobal2);

                recNewDimSetEntry.Reset();
                if not recNewDimSetEntry.IsEmpty() then begin
                    Clear(cduDimMgt);
                    intDimSetId := cduDimMgt.GetDimensionSetID(recNewDimSetEntry);

                    // Obtengo dimensiones globales y actualizamos campo de Dimension global 1
                    clear(cduCambioDim);
                    GlobalDim1 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 1 Code", intDimSetId);
                    GlobalDim2 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 2 Code", intDimSetId);

                    GlEntry."Dimension Set ID" := intDimSetId;
                    if DimGlobal1 <> '' then
                        GlEntry."Global Dimension 1 Code" := DimGlobal1;
                    if DimGlobal2 <> '' then
                        GlEntry."Global Dimension 2 Code" := DimGlobal2;
                    GlEntry.Modify();
                end;
            Until GLEntry.next() = 0;
    end;

    local procedure GetDimSetEntry(var NewDimSetEntry: record "Dimension Set Entry"; pIntDimension: Integer; DimGlobal1: Code[20]; DimGlobal2: code[20])
    var
        GLSetup: Record "General Ledger Setup";
        recDimSetEntry: Record "Dimension Set Entry";
        DimensionValue: record "Dimension Value";
        DimensionValue2: record "Dimension Value";
        AddedCECO: Boolean;
        AddedProyecto: Boolean;
    begin
        GLSetup.Get;
        // CECO y Proyecto

        if DimGlobal1 <> '' then begin
            DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
            DimensionValue.SetRange(Code, DimGlobal1);
            DimensionValue.FindSet();
        end;
        if DimGlobal2 <> '' then begin
            DimensionValue2.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
            DimensionValue2.SetRange(Code, DimGlobal2);
            DimensionValue2.FindSet();
        end;
        recDimSetEntry.Reset();
        recDimSetEntry.SetRange("Dimension Set ID", pIntDimension);
        if recDimSetEntry.FindSet() then
            repeat
                NewDimSetEntry := recDimSetEntry;
                if DimGlobal1 <> '' then begin
                    if NewDimSetEntry."Dimension Code" = GLSetup."Global Dimension 1 Code" then begin
                        NewDimSetEntry."Dimension Value Code" := DimGlobal1;
                        NewDimSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                        AddedCECO := true;
                    end;
                end;
                if DimGlobal2 <> '' then begin
                    if NewDimSetEntry."Dimension Code" = GLSetup."Global Dimension 2 Code" then begin
                        NewDimSetEntry."Dimension Value Code" := DimGlobal2;
                        NewDimSetEntry."Dimension Value ID" := DimensionValue2."Dimension Value ID";
                        AddedProyecto := true;
                    end;
                end;
                NewDimSetEntry.Insert();
            until recDimSetEntry.Next() = 0;
        if (DimGlobal1 <> '') and not AddedCECO then begin
            NewDimSetEntry."Dimension Set ID" := pIntDimension;
            NewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 1 Code";
            NewDimSetEntry."Dimension Value Code" := DimGlobal1;
            NewDimSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
            NewDimSetEntry.Insert();
        end;
        if (DimGlobal2 <> '') and not AddedProyecto then begin
            NewDimSetEntry."Dimension Set ID" := pIntDimension;
            NewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 2 Code";
            NewDimSetEntry."Dimension Value Code" := DimGlobal2;
            NewDimSetEntry."Dimension Value ID" := DimensionValue2."Dimension Value ID";
            NewDimSetEntry.Insert();
        end;

    end;

    procedure ChangeSalesHeader()
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        Shipment: record "Sales Shipment Header";
        Invoice: record "Sales Invoice Header";
        Abono: record "Sales Cr.Memo Header";
        Archivo: record "Sales Header Archive";
        Devo: record "Return Shipment Header";
        ventana: Dialog;
    begin
        ventana.Open('Tipo #1####################\No #2#################');
        SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order");
        if SalesHeader.findset() then
            repeat
                IF Customer.Get(SalesHeader."Sell-to Customer No.") then begin
                    if Customer.ClienteReporting_btc <> '' then begin
                        ventana.Update(1, SalesHeader."Document Type");
                        ventana.Update(2, SalesHeader."No.");
                        SalesHeader.ClienteReporting_btc := Customer.ClienteReporting_btc;
                        SalesHeader.Modify();
                        Shipment.SetRange("Order No.", SalesHeader."No.");
                        Shipment.ModifyAll(ClienteReporting_btc, Customer.ClienteReporting_btc);
                        Invoice.SetRange("Order No.", SalesHeader."No.");
                        Invoice.ModifyAll(ClienteReporting_btc, Customer.ClienteReporting_btc);
                        Abono.SetRange("Return Order No.", SalesHeader."No.");
                        Abono.ModifyAll(ClienteReporting_btc, Customer.ClienteReporting_btc);
                        Devo.SetRange("Return Order No.", SalesHeader."No.");
                        Devo.ModifyAll(ClienteReporting_btc, Customer.ClienteReporting_btc);
                        Archivo.SetRange("Document Type", SalesHeader."Document Type");
                        Archivo.SetRange("No.", SalesHeader."No.");
                        Archivo.ModifyAll(ClienteReporting_btc, Customer.ClienteReporting_btc);
                    end;
                end;
            Until SalesHeader.next() = 0;
        Message('Fin proceso');
    end;

    procedure FinAseguradora(Customer: Record Customer)
    var
        Input: page "STH Input Hist Aseguradora";
        lblConfirm: Label '¿Desea eliminar el credito a %1 de %2 por %3?', comment = 'ESP="¿Desea eliminar el credito a %1 de %2 por %3?"';
    begin
        // pedimos los datos de Fecha Fin
        Input.SetShowFin();
        Input.SetDatos(Customer);
        Input.LookupMode := true;
        if Input.RunModal() = Action::LookupOK then begin

            // Confirmamos Cerrar el credito
            if Confirm(lblConfirm, false, Customer.Name, Customer."Cred_ Max_ Aseg. Autorizado Por_btc", Customer."Credito Maximo Aseguradora_btc") then begin
                FinCustomerCredit(Customer, Input.GetDateFin());
            end;
        end
    end;

    procedure FinCustomerCredit(Customer: Record Customer; DateFin: date)
    var
        HistAseguradora: Record "STH Hist. Aseguradora";
    begin
        HistAseguradora.SetRange(CustomerNo, Customer."No.");
        HistAseguradora.SetRange(Aseguradora, Customer."Cred_ Max_ Aseg. Autorizado Por_btc");
        if not HistAseguradora.FindLast() then begin
            HistAseguradora.Init();
            HistAseguradora.CustomerNo := Customer."No.";
            HistAseguradora.Aseguradora := Customer."Cred_ Max_ Aseg. Autorizado Por_btc";
            HistAseguradora."Credito Maximo Aseguradora_btc" := Customer."Credito Maximo Aseguradora_btc";
            HistAseguradora.Suplemento := Customer.Suplemento_aseguradora;
            HistAseguradora.Insert();
        end;
        HistAseguradora.Name := Customer.Name;
        HistAseguradora.Suplemento := Customer.Suplemento_aseguradora;
        HistAseguradora.DateFin := DateFin;
        HistAseguradora.Modify();

        // Actualizar datos de clientes, poner a blanco        
        Customer."Cred_ Max_ Aseg. Autorizado Por_btc" := '';
        Customer."Credito Maximo Aseguradora_btc" := 0;
        Customer.Suplemento_aseguradora := '';
        Customer.validate("Credit Limit (LCY)", Customer."Credito Maximo Aseguradora_btc" + Customer."Credito Maximo Interno_btc");
        Customer.Modify();

    end;

    procedure RevertFinAseguradora(var HistAse: Record "STH Hist. Aseguradora")
    var
        Customer: record Customer;
    begin
        Customer.Get(HistAse.CustomerNo);
        Customer.TestField("Cred_ Max_ Aseg. Autorizado Por_btc", '');
        Customer."Cred_ Max_ Aseg. Autorizado Por_btc" := HistAse.Aseguradora;
        Customer."Credito Maximo Aseguradora_btc" := HistAse."Credito Maximo Aseguradora_btc";
        Customer.Suplemento_aseguradora := HistAse.Suplemento;
        Customer.validate("Credit Limit (LCY)", HistAse."Credito Maximo Aseguradora_btc" + Customer."Credito Maximo Interno_btc");
        Customer.Modify();
        HistAse.DateFin := 0D;
        HistAse.Modify();
    end;

    procedure AsigCreditoAeguradora(CustomerNo: Code[20]; Name: Text; Aseguradora: code[20]; Importe: Decimal; Suplemento: Code[20]; FechaIni: Date)
    var
        HistAseguradora: Record "STH Hist. Aseguradora";
    begin
        HistAseguradora.SetRange(CustomerNo, CustomerNo);
        HistAseguradora.SetRange(Aseguradora, Aseguradora);
        HistAseguradora.SetRange(DateIni, FechaIni);
        if not HistAseguradora.FindLast() then begin
            HistAseguradora.Init();
            HistAseguradora.CustomerNo := CustomerNo;
            HistAseguradora.DateIni := FechaIni;
            HistAseguradora.Aseguradora := Aseguradora;
            HistAseguradora.Insert();
        end;
        HistAseguradora.Name := Name;
        HistAseguradora."Credito Maximo Aseguradora_btc" := Importe;
        HistAseguradora.Suplemento := Suplemento;
        HistAseguradora.DateFin := 0D;
        HistAseguradora.Modify();
    end;

    procedure ChangeClienteReporting(Old: code[20]; New: code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        ReturnShipmentHeader: Record "Return Shipment Header";
    begin

        SalesHeader.SetRange(ClienteReporting_btc, old);
        SalesHeader.ModifyAll(ClienteReporting_btc, New);

        SalesShipmentHeader.SetRange(ClienteReporting_btc, old);
        SalesShipmentHeader.ModifyAll(ClienteReporting_btc, New);

        SalesCrMemoHeader.SetRange(ClienteReporting_btc, old);
        SalesCrMemoHeader.ModifyAll(ClienteReporting_btc, New);

        SalesHeaderArchive.SetRange(ClienteReporting_btc, old);
        SalesHeaderArchive.ModifyAll(ClienteReporting_btc, New);

        ReturnShipmentHeader.SetRange(ClienteReporting_btc, old);
        ReturnShipmentHeader.ModifyAll(ClienteReporting_btc, New);

        SalesInvoiceHeader.SetRange(ClienteReporting_btc, old);
        SalesInvoiceHeader.ModifyAll(ClienteReporting_btc, New);
    end;


    procedure ImportExcelEmployee()
    var
        Employee: record Employee;
        TextoAuxiliares: record TextosAuxiliares;
        MultiRRHH_zum: Record MultiRRHH_zum;
        ExcelBuffer: Record "Excel Buffer" temporary;
        FileStream: InStream;
        Fichero: text;
        Sheet: text;
        MaxRow: Integer;
        MaxCol: Integer;
        i: integer;
        New: Integer;
        change: Integer;
        Low: Integer;
        NEmpleado: Integer;
        Text000: Label '¿Desea actualizar los datos de Personal con los datos de la excel?', Comment = 'ESP="¿Desea actualizar los datos de Personal con los datos de la excel?"';
        lblResume: Label 'Altas: %1\Bajas %2\Cambios %3\', comment = 'ESP="Altas: %1\Bajas %2\Cambios %3\"';
        lblFin: Label 'Se ha procedido a la actualización de los datos', comment = 'ESP="Se ha procedido a la actualización de los datos"';
    begin
        ExcelBuffer.DeleteAll();
        Commit();
        UploadIntoStream('Abrir Excel', '', 'Excel Files (*.xlsx)|*.*', fichero, FileStream);
        ExcelBuffer.LockTable();
        Sheet := ExcelBuffer.SelectSheetsNameStream(FileStream);
        ExcelBuffer.OpenBookStream(FileStream, Sheet);
        ExcelBuffer.ReadSheet();
        ExcelBuffer.SetRange("Column No.", 1);
        if ExcelBuffer.FindLast() then;
        MaxRow := ExcelBuffer."Row No.";
        ExcelBuffer.Reset();
        ExcelBuffer.SetRange("Row No.", 14); // donde estan las columnas titulo
        if ExcelBuffer.FindLast() then;
        MaxCol := ExcelBuffer."Column No.";

        //if not Confirm(Text000, false) then
        //  exit;

        // cargamos el array de almacenes
        ExcelBuffer.Reset();
        for i := 1 to MaxRow do begin
            ExcelBuffer.Reset();
            ExcelBuffer.SetRange("Row No.", i);  // ponemos la línea
            ExcelBuffer.SetRange("Column No.", 1);  // Cod. empleado
            if ExcelBuffer.FindSet() then begin
                if Evaluate(NEmpleado, ExcelBuffer."Cell Value as Text") then begin
                    if Employee.Get(format(NEmpleado)) then begin
                        ExcelBuffer.SetRange("Column No.", 11);  // SituacionActual
                        if ExcelBuffer.FindSet() then;
                        case ExcelBuffer."Cell Value as Text" of
                            'Alta':
                                change += 1;
                            else
                                Low += 1;
                        end;
                    end else begin
                        new += 1;
                    end;
                end;

            end;
        end;
        if not Confirm(lblResume + Text000, false, new, Low, change) then
            exit;
        for i := 1 to MaxRow do begin
            ExcelBuffer.Reset();
            ExcelBuffer.SetRange("Row No.", i);  // ponemos la línea
            ExcelBuffer.SetRange("Column No.", 1);  // Cod. empleado
            if ExcelBuffer.FindSet() then begin
                if Evaluate(NEmpleado, ExcelBuffer."Cell Value as Text") then begin
                    if not Employee.Get(format(NEmpleado)) then begin
                        Employee.Init();
                        Employee."No." := format(NEmpleado);
                    end;
                    ExcelBuffer.SetRange("Column No.", 3);  // Nombre
                    if ExcelBuffer.FindSet() then
                        Employee.Name := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 4);  // 1 apellido
                    if ExcelBuffer.FindSet() then
                        Employee."First Family Name" := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 5);  // 2 apellido
                    if ExcelBuffer.FindSet() then
                        Employee."Second Family Name" := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 2);  // NIF
                    if ExcelBuffer.FindSet() then
                        Employee.NIF_zum := ExcelBuffer."Cell Value as Text";
                    ExcelBuffer.SetRange("Column No.", 6);  // Area
                    if ExcelBuffer.FindSet() then begin
                        MultiRRHH_zum.SetRange(Tabla, MultiRRHH_zum.tabla::"Area");
                        MultiRRHH_zum.SetRange(Descripcion, ExcelBuffer."Cell Value as Text");
                        MultiRRHH_zum.FindSet();
                        Employee.Area_zum := MultiRRHH_zum.Codigo;
                    end;
                    ExcelBuffer.SetRange("Column No.", 7);  // Departamento
                    if ExcelBuffer.FindSet() then begin
                        MultiRRHH_zum.SetRange(tabla, MultiRRHH_zum.tabla::Departamentos);
                        MultiRRHH_zum.SetRange(Descripcion, ExcelBuffer."Cell Value as Text");
                        MultiRRHH_zum.FindSet();
                        Employee.Departamento_zum := MultiRRHH_zum.Codigo;
                    end;
                    ExcelBuffer.SetRange("Column No.", 8);  // Cargo
                    if ExcelBuffer.FindSet() then
                        Employee."Job Title" := CopyStr(ExcelBuffer."Cell Value as Text", 1, 30);
                    ExcelBuffer.SetRange("Column No.", 8);  // Cargo
                    if ExcelBuffer.FindSet() then
                        Employee."Job Title" := CopyStr(ExcelBuffer."Cell Value as Text", 1, 30);
                    ExcelBuffer.SetRange("Column No.", 9);  // Telf
                    if ExcelBuffer.FindSet() then
                        Employee."Phone No." := CopyStr(ExcelBuffer."Cell Value as Text", 1, 30);
                    ExcelBuffer.SetRange("Column No.", 10);  // email
                    if ExcelBuffer.FindSet() then
                        Employee."E-Mail" := CopyStr(ExcelBuffer."Cell Value as Text", 1, 80);

                    ExcelBuffer.SetRange("Column No.", 11);  // SituacionActual
                    if ExcelBuffer.FindSet() then;
                    case ExcelBuffer."Cell Value as Text" of
                        'Alta':
                            begin
                                Employee.Status := Employee.Status::Active;
                            end;
                        else begin
                            Employee.Status := Employee.Status::Terminated;
                        end;
                    end;
                    if not Employee.Insert() then
                        Employee.Modify();
                end;

            end;
        end;

        Message(lblFin);
    end;

    procedure changePostinGroup(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        InvPostingGroup: record "Inventory Posting Group";
        pPostingGroup: page "Inventory Posting Groups";

        Text000: Label 'Desea Cambiar el Grupo de registro de las lineas a %1';
    begin
        SalesHeader.TestField(Status, SalesHeader.Status::Open);
        pPostingGroup.LookupMode := true;
        if pPostingGroup.RunModal() = Action::LookupOK then begin
            pPostingGroup.GetRecord(InvPostingGroup);
            if Confirm(Text000, false, InvPostingGroup.Code) then begin
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("Qty. to Invoice", '<>0');
                SalesLine.ModifyAll("Posting Group", InvPostingGroup.Code);
            end;
        end;
    end;

    procedure MarcarNoFacturar(PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        lblConfirm: Label 'Se va a marcar el Albaran cono Facturado completamente. ¿Desea continuar?', comment = 'ESP="Se va a marcar el Albaran cono Facturado completamente. ¿Desea continuar?"';
    begin
        if not Confirm(lblConfirm, false) then
            exit;
        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        if PurchRcptLine.findset() then
            repeat
                PurchRcptLine."Qty. Rcd. Not Invoiced" := 0;
                PurchRcptLine.Modify();
            Until PurchRcptLine.next() = 0;
    end;

    procedure CheckEsBajoPedido(Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        AssemblyLine: Record "Assembly Line";
        Item: Record Item;
        Mensaje: text;
        recAssToOrdLink: Record "Assemble-to-Order Link";
    begin
        SalesLine.reset;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                if SalesLine."Qty. to Assemble to Order" > 0 then begin
                    recAssToOrdLink.Reset();
                    recAssToOrdLink.SetRange("Document Type", SalesLine."Document Type");
                    recAssToOrdLink.SetRange("Document No.", SalesLine."Document No.");
                    recAssToOrdLink.SetRange("Document Line No.", SalesLine."Line No.");
                    if recAssToOrdLink.FindSet() then
                        repeat
                            AssemblyLine.Reset();
                            AssemblyLine.SetRange("Document Type", recAssToOrdLink."Assembly Document Type");
                            AssemblyLine.SetRange("Document No.", recAssToOrdLink."Assembly Document No.");
                            if AssemblyLine.FindSet() then
                                repeat
                                    Item.Get(SalesLine."No.");
                                    if Item."ContraStock/BajoPedido" = Item."ContraStock/BajoPedido"::BajoPedido then
                                        Mensaje += 'El articulo ' + Item."No." + ' ; '
                                    else
                                        if SalesLine.Quantity > Item.PedidoMaximo then
                                            Mensaje += 'El articulo ' + Item."No." + ' ; '
                                until AssemblyLine.Next() = 0;
                        until recAssToOrdLink.Next() = 0;
                end;
                Item.Get(SalesLine."No.");
                if Item."ContraStock/BajoPedido" = Item."ContraStock/BajoPedido"::BajoPedido then
                    Mensaje += 'El articulo ' + Item."No." + '; '
                else
                    if Item."ContraStock/BajoPedido" = Item."ContraStock/BajoPedido"::" " then
                        Mensaje += 'El articulo ' + Item."No." + ' no se indica si es bajopedido/contrastock ; '
                    else
                        if SalesLine.Quantity > Item.PedidoMaximo then
                            Mensaje += 'El articulo ' + Item."No." + ' ; ';

            until SalesLine.Next() = 0;
        if Mensaje <> '' then
            Message(Mensaje + ' Son bajo pedido');
    end;

    procedure CrearOferta(var SalesHeaderAux: Record "STH Sales Header Aux")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Error: Boolean;
        ErrorDtos: Boolean;
    begin
        SalesHeaderAux.status := SalesHeaderAux.status::Error;
        SalesHeaderAux.Modify();
        commit();

        //COMPROBAR SI EXISTE YA UN REGISTRO DE ESTA OFERTA
        CheckExisteOferta(SalesHeader, SalesHeaderAux);

        //INSERTAR CABECERA
        InsertarCabeceraOferta(SalesHeader, SalesHeaderAux);

        //INSERTAR LINEAS
        InsertarLineasOferta(SalesLine, SalesHeaderAux, ErrorDtos);

        UpdateNoContemplarPlanificacion(SalesHeader);

        // Calcular Dto de cabecera

        CalcularDescuentoTotal(SalesHeader, SalesHeaderAux."Invoice Discount");

        // poner estado AUX
        SalesHeader.CalcFields(Amount);
        case error of
            true:
                begin
                    SalesHeaderAux.Status := SalesHeaderAux.Status::Error;
                end;
            else begin
                if ErrorDtos then
                    SalesHeaderAux.Status := SalesHeaderAux.Status::"Dif. Dtos"
                else
                    if SalesHeaderAux.Amount = SalesHeader.Amount then
                        SalesHeaderAux.Status := SalesHeaderAux.Status::Finalizada
                    else
                        SalesHeaderAux.Status := SalesHeaderAux.Status::"Dif. Importe";
            end;
        end;
        SalesHeaderAux.Created := true;
        SalesHeaderAux.Modify();

    end;

    local procedure CheckExisteOferta(var SalesHeader: Record "Sales Header"; SalesHeaderAux: Record "STH Sales Header Aux")
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Quote, SalesHeaderAux."No.") then
            Error('El registro ya existe');
    end;

    local procedure InsertarCabeceraOferta(var SalesHeader: Record "Sales Header"; var SalesHeaderAux: Record "STH Sales Header Aux")
    var
        ErrorDtos: Boolean;
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
        SalesHeader.Validate("No.", SalesHeaderAux."No.");
        SalesHeader.Validate("Sell-to Customer No.", SalesHeaderAux."Sell-to Customer No.");
        case SalesHeaderAux.Probability of
            '':
                SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::" ";
            'Alta':
                SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::Alta;
            'Baja':
                SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::Baja;
            'Media':
                SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::Media;
            'Muy Baja':
                SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::"Muy Baja";
        end;
        SalesHeader.Validate("Currency Code", SalesHeaderAux."Currency Code");
        SalesHeader.Validate("Ship-to Name", SalesHeaderAux."Ship-to Name");
        SalesHeader.Validate("Ship-to Name 2", SalesHeaderAux."Ship-to Name 2");
        SalesHeader.Validate("Ship-to Address", SalesHeaderAux."Ship-to Address");
        SalesHeader.Validate("Ship-to Address 2", SalesHeaderAux."Ship-to Address 2");
        SalesHeader.Validate("Ship-to City", SalesHeaderAux."Ship-to City");
        SalesHeader.Validate("Ship-to County", SalesHeaderAux."Bill-to County");
        SalesHeader.Validate("Ship-to Country/Region Code", SalesHeaderAux."Ship-to Country/Region Code");
        SalesHeader.Validate("Ship-to Post Code", SalesHeaderAux."Ship-to Post Code");
        SalesHeader.Validate("Shipping Agent Code", SalesHeaderAux."Shipping Agent Code");
        SalesHeader.Validate("Payment Terms Code", SalesHeaderAux."Payment Terms Code");
        //SalesHeader.Validate(Amount, SalesHeaderAux.Amount);
        //SalesHeader.Validate("Amount Including VAT", SalesHeaderAux."Amount Including VAT");
        SalesHeader.Validate("Bill-to Name", SalesHeaderAux."Bill-to Name");
        SalesHeader.Validate("Bill-to Address", SalesHeaderAux."Bill-to Address");
        SalesHeader.Validate("Bill-to Address 2", SalesHeaderAux."Bill-to Address 2");
        SalesHeader.Validate("Bill-to City", SalesHeaderAux."Bill-to City");
        SalesHeader.Validate("Bill-to County", SalesHeaderAux."Bill-to County");
        SalesHeader.Validate("Bill-to Country/Region Code", SalesHeaderAux."Bill-to Country/Region Code");
        SalesHeader.Validate("Bill-to Post Code", SalesHeaderAux."Bill-to Post Code");
        //SalesHeader.Validate("Invoice Discount Amount", SalesHeaderAux."Invoice Discount Amount");
        SalesHeader.Validate("Requested Delivery Date", SalesHeaderAux."Requested Delivery Date");
        SalesHeader.OfertaSales := true;
        SalesHeader."No contemplar planificacion" := true;
        SalesHeader.Insert();


    end;

    local procedure InsertarLineasOferta(var SalesLine: Record "Sales Line"; var SalesHeaderAux: Record "STH Sales Header Aux"; var ErrorDtos: Boolean)
    var
        SalesLinesAux: Record "STH Sales Line Aux";
    begin
        // SalesLinesAux.SetRange("Sell-to Customer No.", SalesHeaderAux."Sell-to Customer No.");
        SalesLinesAux.SetRange("Document No.", SalesHeaderAux."No.");

        // if SalesLinesAux.Get(SalesHeaderAux."Sell-to Customer No.", SalesHeaderAux."No.") then begin
        if SalesLinesAux.FindFirst() then begin
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Quote;
                SalesLine.Type := SalesLine.Type::Item;
                SalesLine."Sell-to Customer No." := SalesHeaderAux."Sell-to Customer No.";
                SalesLine.Validate("Document No.", SalesLinesAux."Document No.");
                SalesLine.Validate("Line No.", SalesLinesAux."Line No.");
                SalesLine.Insert();
                SalesLine.Validate("No.", SalesLinesAux."No.");
                SalesLine.Validate(Description, SalesLinesAux.Description);
                SalesLine.Validate("Description 2", SalesLinesAux."Description 2");
                SalesLine.Validate(Quantity, SalesLinesAux.Quantity);
                SalesLine.Validate("Unit Price", SalesLinesAux."Unit Price");
                // controlamos el dtos segun las necesidades
                SalesLineDtos(SalesLine, SalesLinesAux);
                if SalesLine."Line Discount %" <> SalesLinesAux."Line Discount %" then
                    ErrorDtos := true;

                SalesLine."No contemplar planificacion" := true;
                SalesLine.Modify();
            until SalesLinesAux.Next() = 0;
        end;
    end;

    local procedure SalesLineDtos(var SalesLine: Record "Sales Line"; SalesLinesAux: Record "STH Sales Line Aux")
    var
        Customer: Record customer;
        CustomerDiscountGroup: Record "Customer Discount Group";
        NoAplicarDto: Boolean;
    begin
        if Customer.get(SalesLine."Sell-to Customer No.") then
            if CustomerDiscountGroup.get(Customer."Customer Disc. Group") then
                if CustomerDiscountGroup."Oferta CRM aplicar Dto" then
                    NoAplicarDto := true;


        if not NoAplicarDto then begin
            SalesLine.Validate("Line Discount %", SalesLinesAux."Line Discount %");
            if (SalesLinesAux."Line Discount Amount" <> 0) and (SalesLinesAux."Line Discount %" = 0) then
                SalesLine.Validate("Line Discount Amount", SalesLinesAux."Line Discount Amount");
            // SalesLine.Validate(Amount, SalesLinesAux.Amount);
            // SalesLine.Validate("Line Amount", SalesLinesAux."Line Amount");
            // SalesLine.Validate("Amount Including VAT", SalesLinesAux."Amount Including VAT");
        end
    end;

    procedure CalcularDescuentoTotal(var SalesHeader: Record "Sales Header"; DescuentoFactura: Decimal)
    var
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        AmountWithDiscountAllowed: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        SalesLine: record "Sales Line";
        InvoiceDiscountAmount: Decimal;
        Currency: record Currency;
    begin
        Currency.InitRoundingPrecision;
        SalesLine.reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.FindFirst();
        AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(SalesLine);
        InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * DescuentoFactura / 100, Currency."Amount Rounding Precision");
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
    end;

    procedure UpdateNoContemplarPlanificacion(SalesHeader: record "Sales Header")
    var
        Salesline: Record "Sales Line";
        AsmLine: Record "Assembly Line";
        Asmtoorderlink: Record "Assemble-to-Order Link";
    begin
        Salesline.SetRange("Document Type", SalesHeader."Document Type");
        Salesline.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.findset() then
            repeat
                Salesline."No contemplar planificacion" := SalesHeader."No contemplar planificacion";
                Salesline.Modify();
                if Asmtoorderlink.AsmExistsForSalesLine(SalesLine) then begin
                    AsmLine.FILTERGROUP := 2;
                    AsmLine.SETRANGE("Document Type", Asmtoorderlink."Assembly Document Type");
                    AsmLine.SETRANGE("Document No.", Asmtoorderlink."Assembly Document No.");
                    if AsmLine.findset() then
                        repeat
                            // marcamos las lineas del pedido de ensamblado como no contemplar
                            AsmLine."No contemplar planificacion" := SalesHeader."No contemplar planificacion";
                            AsmLine.Modify();
                        Until AsmLine.next() = 0;

                end;
            Until SalesLine.next() = 0;
    end;


    procedure SalesInvoiceLineUpdatecost(var Rec: Record "Sales Invoice Line")
    var
        Item: record Item;
        SalesInvLine: Record "Sales Invoice Line";
        SKU: Record "Stockkeeping Unit";
        UOMMgt: Codeunit "Unit of Measure Management";
        lblConfirm: Label '¿Desea actualizar el Coste unitario\%1 - %2?', comment = 'ESP="¿Desea actualizar el Coste unitario\%1 - %2?"';
    begin
        SalesInvLine.Reset();
        SalesInvLine.Get(Rec."Document No.", Rec."Line No.");
        SalesInvLine.TESTFIELD(Type, SalesInvLine.Type::Item);
        SalesInvLine.TESTFIELD("No.");
        Item.Get(SalesInvLine."No.");

        if not Confirm(lblConfirm, true, SalesInvLine."No.", SalesInvLine.Description) then
            exit;

        SalesInvLine."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, SalesInvLine."Unit of Measure Code");
        IF GetSKU(SKU, SalesInvLine."Location Code", SalesInvLine."No.", SalesInvLine."Variant Code") THEN
            SalesInvLine."Unit Cost" := SKU."Unit Cost" * SalesInvLine."Qty. per Unit of Measure"
        ELSE
            SalesInvLine.VALIDATE("Unit Cost", Item."Unit Cost" * SalesInvLine."Qty. per Unit of Measure");

        SalesInvLine."Unit Cost (LCY)" := SalesInvLine."Unit Cost";
        SalesInvLine.Modify();
    end;

    procedure SalesCRMemoLineUpdatecost(var SalesCRMemoLine: Record "Sales Cr.Memo Line")
    var
        Item: record Item;
        SKU: Record "Stockkeeping Unit";
        UOMMgt: Codeunit "Unit of Measure Management";
        lblConfirm: Label '¿Desea actualizar el Coste unitario\%1 - %2?', comment = 'ESP="¿Desea actualizar el Coste unitario\%1 - %2?"';
    begin
        SalesCRMemoLine.TESTFIELD(Type, SalesCRMemoLine.Type::Item);
        SalesCRMemoLine.TESTFIELD("No.");
        Item.Get(SalesCRMemoLine."No.");

        if not Confirm(lblConfirm, true, SalesCRMemoLine."No.", SalesCRMemoLine.Description) then
            exit;

        SalesCRMemoLine."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, SalesCRMemoLine."Unit of Measure Code");
        IF GetSKU(SKU, SalesCRMemoLine."Location Code", SalesCRMemoLine."No.", SalesCRMemoLine."Variant Code") THEN
            SalesCRMemoLine."Unit Cost" := SKU."Unit Cost" * SalesCRMemoLine."Qty. per Unit of Measure"
        ELSE
            SalesCRMemoLine.VALIDATE("Unit Cost (LCY)", Item."Unit Cost" * SalesCRMemoLine."Qty. per Unit of Measure");

        SalesCRMemoLine."Unit Cost (LCY)" := SalesCRMemoLine."Unit Cost";
        SalesCRMemoLine.Modify();
    end;

    local procedure GetSKU(var SKU: Record "Stockkeeping Unit"; LocationCode: code[10]; ItemNo: code[20]; VariantCode: code[20]): Boolean
    begin
        IF (SKU."Location Code" = LocationCode) AND
           (SKU."Item No." = ItemNo) AND
           (SKU."Variant Code" = VariantCode)
        THEN
            EXIT(TRUE);
        IF SKU.GET(LocationCode, ItemNo, VariantCode) THEN
            EXIT(TRUE);

        EXIT(FALSE);

    end;

    procedure RetrieveLotAndExpFromPostedInv(InvoiceRowID: Text[250]; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary; var NumMov: Integer)
    var
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";

    begin
        // retrieves a data set of Item Ledger Entries (Posted Invoices)
        //Calculo lotes
        RecMemEstadisticas.RESET();
        RecMemEstadisticas.DELETEALL();

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

    procedure SalesInvoiceLineAssemblyTracking(SalesInvoiceLine: Record "Sales Invoice Line"; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary; var NumMov: Integer)
    var
        recPostAssLink: Record "Posted Assemble-to-Order Link";
        PostedAssembletoOrderLink: record "Posted Assemble-to-Order Link";
        AssemblyHeader: record "Posted Assembly Header";
        AssemblyLine: record "Posted Assembly Line";
        ItemLedgerEntry: record "Item Ledger Entry";
    begin
        recPostAssLink.Reset();
        recPostAssLink.SetRange("Document Type", recPostAssLink."Document Type"::"Sales Shipment");
        recPostAssLink.SetRange("Document No.", SalesInvoiceLine."Shipment No.");
        recPostAssLink.SETRANGE("Document Line No.", SalesInvoiceLine."Shipment Line No.");
        if recPostAssLink.FindFirst() then begin
            PostedAssembletoOrderLink.SetRange("Document Type", PostedAssembletoOrderLink."Document Type"::"Sales Shipment");
            PostedAssembletoOrderLink.SetRange("Document No.", SalesInvoiceLine."Shipment No.");
            PostedAssembletoOrderLink.SETRANGE("Document Line No.", SalesInvoiceLine."Shipment Line No.");
        end else begin
            PostedAssembletoOrderLink.SetRange("Document Type", PostedAssembletoOrderLink."Document Type"::"Sales Shipment");
            PostedAssembletoOrderLink.SetRange("Order No.", SalesInvoiceLine."Order No.");
            PostedAssembletoOrderLink.SetRange("Order Line No.", SalesInvoiceLine."Order Line No.");
        end;
        if PostedAssembletoOrderLink.findset() then
            repeat
                AssemblyHeader.SetRange("No.", PostedAssembletoOrderLink."Assembly Document No.");
                if AssemblyHeader.findset() then
                    repeat
                        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                        if AssemblyLine.findset() then
                            repeat
                                ItemLedgerEntry.SetRange("Document No.", AssemblyLine."Document No.");
                                ItemLedgerEntry.SetRange("Document Line No.", AssemblyLine."Line No.");
                                if ItemLedgerEntry.findset() then
                                    repeat
                                        RecMemEstadisticas.RESET();
                                        RecMemEstadisticas.SETRANGE(NoSerie, ItemLedgerEntry."Serial No.");
                                        IF NOT RecMemEstadisticas.FINDFIRST() THEN BEGIN
                                            RecMemEstadisticas.INIT();
                                            NumMov += 1;
                                            RecMemEstadisticas.NoMov := NumMov;
                                            RecMemEstadisticas.NoLote := ItemLedgerEntry."Lot No.";
                                            RecMemEstadisticas.NoSerie := ItemLedgerEntry."Serial No.";
                                            RecMemEstadisticas.Noproducto := ItemLedgerEntry."Item No.";
                                            RecMemEstadisticas.INSERT();
                                        END;
                                    Until ItemLedgerEntry.next() = 0;
                            Until AssemblyLine.next() = 0;

                    Until AssemblyHeader.next() = 0;

            Until PostedAssembletoOrderLink.next() = 0;
    end;

    procedure ExportTrazabilidadFacturas(var SalesInvoiceLine: Record "Sales Invoice Line"; TextoFiltro: text)
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Ventana: Dialog;
    begin
        Ventana.Open('Nº Factura #1###############\Nº Linea #2###############\Producto #3#############');
        ExcelBuffer.DELETEALL;
        ExcelBuffer.CreateNewBook('Trazabilidad Facturas');
        // creamos la cabecera de la excel
        HeaderExcelBuffer(ExcelBuffer, TextoFiltro);

        // añadimos las líneas
        if SalesInvoiceLine.findset() then
            repeat
                Ventana.Update(1, SalesInvoiceLine."Document No.");
                Ventana.Update(2, SalesInvoiceLine."Line No.");
                Ventana.Update(3, SalesInvoiceLine."No.");
                LinesExcelBuffer(ExcelBuffer, SalesInvoiceLine);
            Until SalesInvoiceLine.next() = 0;

        Ventana.Close();

        ExcelBuffer.WriteSheet('Trazabilidad Facturas', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.DownloadAndOpenExcel;
    end;

    local procedure HeaderExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; TextoFiltro: text)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Trazabilidad Facturas', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Filtro:', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(TextoFiltro, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Sell-to Customer No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Nombre Cliente', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Document No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Posting Date"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption(Type), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption(Description), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Location Code"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption(Quantity), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Posting Group"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Unit Cost"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Unit Price"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.FieldCaption("Line Amount"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

    local procedure LinesExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; SalesInvoiceLine: Record "Sales Invoice Line")
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        IsBold: Boolean;
    begin
        // Buscar clientes y poner nombre        
        if SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then;
        case SalesInvoiceLine."Attached to Line No." of
            0, 1:
                IsBold := true;
        end;


        ExcelBuffer.AddColumn(SalesInvoiceLine."Sell-to Customer No.", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceHeader."Sell-to Customer Name", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine."Document No.", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine."Posting Date", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.Type, FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine."No.", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.Description, FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine."Location Code", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine.Quantity, FALSE, '', FALSE, IsBold, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine."Posting Group", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine."Unit Cost", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine."Unit Price", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvoiceLine."Line Amount", FALSE, '', IsBold, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

    // =============     Funcion para poder cambiar la descripción de los movimientos de proyectos          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================

    // TODO para Susana, hacer guardar las descripcion

    procedure SetJOBBledgerEntryDescription(var JobLdgEntry: Record "Job Ledger Entry"; Desc: text)
    var
        myInt: Integer;
    begin
        if JobLdgEntry.Description <> Copystr(Desc, 1, MaxStrLen(JobLdgEntry.Description)) then begin
            JobLdgEntry.Description := Copystr(Desc, 1, MaxStrLen(JobLdgEntry.Description));
            JobLdgEntry.Modify();
        end;
    end;

}
