codeunit 50111 "Funciones"
{
    Permissions = tabledata "Item Ledger Entry" = rm, tabledata "Sales Invoice Header" = rmid, tabledata "G/L Entry" = rmid,
        tabledata "Sales Shipment Header" = rmid, tabledata "Sales Cr.Memo Header" = rmid, tabledata "Sales Header Archive" = rmid,
        tabledata "Return Shipment Header" = rmid;
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

    procedure CheckandSetFilterOneLocation(var Item: Record Item)
    var
        Location: Record Location;
        Text000: label 'No se puede realizar planificacicón con Agrupación y multiples filtros de Almacén', Comment = 'ESP="No se puede realizar planificación con Agrupación y multiples filtros de Almacén"';
    begin
        Location.SetFilter(Code, item.GetFilter("Location Filter"));
        if Location.count > 1 then
            Error(text000);
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
        Item.STHFilterLocation := Item.GetFilter("Location Filter");
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

    procedure DeleteFilterOneLocation(var WorkSheetName: code[10]; FilterLocation: code[10])
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.SetRange("Journal Batch Name", WorkSheetName);
        ReqLine.SetRange("Worksheet Template Name", 'PLANIF.');
        ReqLine.SetFilter("Location Code", '<>%1', FilterLocation);
        ReqLine.DeleteAll();
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

    procedure ChangeDimensionCECOGLEntries(var GLEntry: Record "G/L Entry"; DimGlobal1: Code[20])
    var
        GLSetup: Record "General Ledger Setup";
        recNewDimSetEntry: record "Dimension Set Entry" temporary;
        cduDimMgt: Codeunit DimensionManagement;
        cduCambioDim: Codeunit CambioDimensiones;
        GlobalDim1: code[20];
        intDimSetId: Integer;
    begin
        GLSetup.Get;
        // recorremos los movimientos de contabilidad seleccionados
        if GLEntry.findset() then
            repeat
                recNewDimSetEntry.Reset();
                recNewDimSetEntry.DeleteAll();
                // recogemos los valores del dimension SET y cambiamos el CECO por el nuevo CECO
                GetDimSetEntry(recNewDimSetEntry, GLEntry."Dimension Set ID", DimGlobal1);

                recNewDimSetEntry.Reset();
                if not recNewDimSetEntry.IsEmpty() then begin
                    Clear(cduDimMgt);
                    intDimSetId := cduDimMgt.GetDimensionSetID(recNewDimSetEntry);

                    // Obtengo dimensiones globales y actualizamos campo de Dimension global 1
                    clear(cduCambioDim);
                    GlobalDim1 := cduCambioDim.GetDimValueFromDimSetID(GLSetup."Global Dimension 1 Code", intDimSetId);

                    GlEntry."Dimension Set ID" := intDimSetId;
                    GlEntry."Global Dimension 1 Code" := DimGlobal1;
                    GlEntry.Modify();
                end;
            Until GLEntry.next() = 0;
    end;

    local procedure GetDimSetEntry(var NewDimSetEntry: record "Dimension Set Entry"; pIntDimension: Integer; DimGlobal1: Code[20])
    var
        GLSetup: Record "General Ledger Setup";
        recDimSetEntry: Record "Dimension Set Entry";
        DimensionValue: record "Dimension Value";
        AddedCECO: Boolean;
    begin
        GLSetup.Get;
        DimensionValue.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
        DimensionValue.SetRange(Code, DimGlobal1);
        DimensionValue.FindSet();
        recDimSetEntry.Reset();
        recDimSetEntry.SetRange("Dimension Set ID", pIntDimension);
        if recDimSetEntry.FindSet() then
            repeat
                NewDimSetEntry := recDimSetEntry;
                if NewDimSetEntry."Dimension Code" = GLSetup."Global Dimension 1 Code" then begin
                    NewDimSetEntry."Dimension Value Code" := DimGlobal1;
                    NewDimSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                    AddedCECO := true;
                end;
                NewDimSetEntry.Insert();
            until recDimSetEntry.Next() = 0;
        if not AddedCECO then begin
            NewDimSetEntry."Dimension Set ID" := pIntDimension;
            NewDimSetEntry."Dimension Code" := GLSetup."Global Dimension 1 Code";
            NewDimSetEntry."Dimension Value Code" := DimGlobal1;
            NewDimSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
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
        if not HistAseguradora.FindLast() then begin
            HistAseguradora.Init();
            HistAseguradora.CustomerNo := CustomerNo;
            HistAseguradora.DateIni := FechaIni;
            HistAseguradora.Aseguradora := Aseguradora;
            HistAseguradora."Credito Maximo Aseguradora_btc" := Importe;
            HistAseguradora.Suplemento := Suplemento;
            HistAseguradora.Insert();
        end;
        HistAseguradora.Name := Name;
        HistAseguradora.Suplemento := Suplemento;
        HistAseguradora.Modify();
    end;
}
