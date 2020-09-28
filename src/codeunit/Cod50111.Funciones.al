codeunit 50111 "Funciones"
{
    Permissions = tabledata "Item Ledger Entry" = rm, tabledata "Sales Invoice Header" = rm;
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

    procedure ChangeExtDocNoPostedSalesInvoice(InvoiceNo: code[20]; ExtDocNo: Text[35]; NewWorkDescription: text; AreaManager: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TempBlob: Record TempBlob temporary;
    begin
        if SalesInvoiceHeader.Get(InvoiceNo) then begin
            SalesInvoiceHeader."External Document No." := ExtDocNo;
            SalesInvoiceHeader.AreaManager_btc := AreaManager;
            CLEAR(SalesInvoiceHeader."Work Description");
            if not (NewWorkDescription = '') then begin
                TempBlob.Blob := SalesInvoiceHeader."Work Description";
                TempBlob.WriteAsText(NewWorkDescription, TEXTENCODING::UTF8);
                SalesInvoiceHeader."Work Description" := TempBlob.Blob;
            end;
            SalesInvoiceHeader.Modify();
        end;
    end;

}
