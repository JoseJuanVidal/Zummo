codeunit 50101 "Eventos_btc"
{
    Permissions = tabledata "Item Ledger Entry" = m;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterCopyFromItem', '', false, false)]
    local procedure OnAfterCopyFromItem_FillTariffNo_(VAR SalesLine: Record "Sales Line"; Item: Record Item)
    begin
        SalesLine."Tariff No_btc" := Item."Tariff No.";

    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnAfterActionEvent', 'Release', true, true)]
    local procedure P_SalesQuote_OnAfterActionEvent(VAR Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        AssemblyLine: Record "Assembly Line";
        Item: Record Item;
        Mensaje: text;
        recAssToOrdLink: Record "Assemble-to-Order Link";
    begin
        SalesLine.reset;
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
                                        Mensaje += 'El articulo ' + Item."No." + ' Es bajo pedido; '
                                    else
                                        if SalesLine.Quantity > Item.PedidoMaximo then
                                            Mensaje += 'El articulo ' + Item."No." + ' Es bajo pedido; '
                                until AssemblyLine.Next() = 0;
                        until recAssToOrdLink.Next() = 0;
                end;
                Item.Get(SalesLine."No.");
                if Item."ContraStock/BajoPedido" = Item."ContraStock/BajoPedido"::BajoPedido then
                    Mensaje += 'El articulo ' + Item."No." + ' Es bajo pedido; '
                else
                    if SalesLine.Quantity > Item.PedidoMaximo then
                        Mensaje += 'El articulo ' + Item."No." + ' Es bajo pedido; ';

            until SalesLine.Next() = 0;
        if Mensaje <> '' then
            if Confirm(Mensaje, true, true) then;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeActionEvent', 'Post', true, true)]
    local procedure P_SalesOrder_OnBeforeActionEvent(VAR Rec: Record "Sales Header")
    var

    begin
        if (Rec."Document Date" < Today) or (rec."Posting Date" < Today) then begin
            rec.Validate("Document Date", Today);
            rec.Validate("Posting Date", today);
            rec.Modify();
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", 'OnBeforeActionEvent', 'Post', true, true)]
    local procedure P_SalesInvoice_OnBeforeActionEvent(VAR Rec: Record "Sales Header")
    var

    begin
        if UserId = 'ADMIN' THEN
            EXIT;
        if (Rec."Document Date" < Today) or (rec."Posting Date" < Today) then begin
            rec.Validate("Document Date", Today);
            rec.Validate("Posting Date", today);
            rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Credit Memo", 'OnBeforeActionEvent', 'Post', true, true)]
    local procedure P_SalesCreditMemo_OnBeforeActionEvent(VAR Rec: Record "Sales Header")
    var

    begin
        if UserId = 'ADMIN' THEN
            EXIT;
        if (Rec."Document Date" < Today) or (rec."Posting Date" < Today) then begin
            rec.Validate("Document Date", Today);
            rec.Validate("Posting Date", today);
            rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterActionEvent', 'Release', true, true)]
    local procedure P_SalesOrder_OnAfterActionEvent(VAR Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        AssemblyLine: Record "Assembly Line";
        Item: Record Item;
        Mensaje: text;
        recAssToOrdLink: Record "Assemble-to-Order Link";
    begin
        SalesLine.reset;
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
            if Confirm(Mensaje + ' Son bajo pedido', true, true) then;
    end;






    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Get Shipment", 'OnAfterInsertLine', '', true, true)]
    local procedure CDU_64_OnAfterInsertLine(VAR SalesShptLine: Record "Sales Shipment Line"; VAR SalesLine: Record "Sales Line")
    begin
        TraspasaWorkDescriptionToFactura(SalesLine, SalesShptLine."Document No.");
    end;

    local procedure TraspasaWorkDescriptionToFactura(var pSalesLine: Record "Sales Line"; pShipNo: Code[20])
    var
        recSalesShptHeader: Record "Sales Shipment Header";
        recSalesHeader: Record "Sales Header";
    begin
        if pSalesLine."Document Type" <> pSalesLine."Document Type"::Invoice then
            exit;

        if pShipNo = '' then
            exit;

        if not recSalesShptHeader.Get(pShipNo) then
            exit;

        recSalesHeader.Reset();
        recSalesHeader.SetRange("Document Type", pSalesLine."Document Type");
        recSalesHeader.SetRange("No.", pSalesLine."Document No.");
        recSalesHeader.FindFirst();

        recSalesHeader.CalcFields("Work Description");
        if recSalesHeader."Work Description".HasValue() then
            exit;

        recSalesShptHeader.CalcFields("Work Description");
        if not recSalesShptHeader."Work Description".HasValue() then
            exit;

        recSalesHeader."Work Description" := recSalesShptHeader."Work Description";
        recSalesHeader.Modify();
    end;



    [EventSubscriber(ObjectType::Table, 114, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventSalesCrMemoHeader(VAR Rec: Record "Sales Cr.Memo Header"; RunTrigger: Boolean)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesHeader: Record "Sales Header";
    begin

        IF Rec."Corrected Invoice No." <> '' THEN begin

            SalesInvoiceHeader.RESET;
            SalesInvoiceHeader.SETRANGE("No.", rec."Corrected Invoice No.");
            IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document Type", ValueEntry."Document Type"::"Sales Invoice");
                ValueEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                ValueEntry.SETFILTER("Item Ledger Entry No.", '<>0');
                IF ValueEntry.FINDFIRST THEN BEGIN
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETRANGE("Entry No.", ValueEntry."Item Ledger Entry No.");
                    IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                        SalesShipmentLine.RESET;
                        SalesShipmentLine.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                        SalesShipmentLine.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                        IF SalesShipmentLine.FINDFIRST THEN BEGIN
                            SalesHeader.RESET;
                            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                            SalesHeader.SETRANGE("No.", SalesShipmentLine."Order No.");
                            IF SalesHeader.FINDFIRST THEN BEGIN
                                SalesHeader.Abono := rec."No.";
                                SalesHeader.MODIFY;

                            END;
                        END;
                    END;
                END;
            END;
        end;
    end;




    [EventSubscriber(ObjectType::Table, 27, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventItem(VAR Rec: Record Item; RunTrigger: Boolean)
    var
        CreatestockkepingUnit: report "Create Stockkeeping Unit";
        Item: Record Item;
    begin
        if Item.IsTemporary then
            exit;
        commit;
        SelectLatestVersion();
        Item.reset;
        Item.SetRange("No.", Rec."No.");
        Item.FindFirst();
        Clear(CreatestockkepingUnit);
        CreatestockkepingUnit.SetTableView(Item);
        CreatestockkepingUnit.InitializeRequest(0, false, true);
        CreatestockkepingUnit.UseRequestPage(false);
        CreatestockkepingUnit.Run();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeSendEmail', '', true, true)]
    local procedure CDU_260_OnBeforeSendemail(VAR TempEmailItem: Record "Email Item" temporary; VAR IsFromPostedDoc: Boolean; VAR PostedDocNo: Code[20]; VAR HideDialog: Boolean; VAR ReportUsage: Integer)
    var
        recPurchSetup: Record "Purchases & Payables Setup";
        recPurchHeader: Record "Purchase Header";
        recContBusRelation: Record "Contact Business Relation";
        recContact: Record Contact;
        txtDirecciones: Text;
    begin
        if not IsFromPostedDoc or not recPurchHeader.Get(recPurchHeader."Document Type"::Order, PostedDocNo) then
            exit;

        recPurchSetup.Get();

        txtDirecciones := '';

        recContBusRelation.Reset();
        recContBusRelation.SetRange("Link to Table", recContBusRelation."Link to Table"::Vendor);
        recContBusRelation.SetRange("No.", recPurchHeader."Buy-from Vendor No.");
        if recContBusRelation.FindFirst() then begin
            recContact.Reset();
            recContact.SetRange("Company No.", recContBusRelation."Contact No.");
            recContact.SetRange(EnviarEmailPedCompra2_btc, true);
            if recContact.FindSet() then
                repeat
                    txtDirecciones += recContact."E-Mail" + ';';
                until recContact.Next() = 0;

            if StrLen(txtDirecciones) > 0 then
                if txtDirecciones[StrLen(txtDirecciones)] = ';' then
                    txtDirecciones := copystr(txtDirecciones, 1, StrLen(txtDirecciones) - 1);
        end;

        if (txtDirecciones <> '') and (StrLen(txtDirecciones) <= MaxStrLen(TempEmailItem."Send to")) then
            TempEmailItem."Send to" := copystr(txtDirecciones, 1, MaxStrlen(tempemailitem."Send To"));

        recPurchSetup.CALCFIELDS(TextoEmailPedCompra_btc);

        IF recPurchSetup.TextoEmailPedCompra_btc.HASVALUE() THEN begin
            TempEmailItem."Plaintext Formatted" := true;
            TempEmailItem."Message Type" := TempEmailItem."Message Type"::"Custom Message";
            TempEmailItem.Body := recPurchSetup.TextoEmailPedCompra_btc;
        end;

        if TempEmailItem.Modify() then;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnInsertProdOrderWithReqLine', '', false, false)]
    local procedure OnInsertProdOrderWithReqLine_ManageOP(var ProductionOrder: Record "Production Order"; var RequisitionLine: Record "Requisition Line")
    var
        FuncionesFabricacion: Codeunit FuncionesFabricacion;
    begin
        Clear(FuncionesFabricacion);
        if not FuncionesFabricacion.PreChecksPartitionOP(RequisitionLine) then
            exit;

        FuncionesFabricacion.ManagePartitionOP(ProductionOrder, RequisitionLine);
    end;



    [EventSubscriber(ObjectType::Codeunit, 7000, 'OnAfterSalesLineLineDiscExists', '', false, false)]
    local procedure OnAfterSalesLineLineDiscExists(VAR SalesLine: Record "Sales Line"; VAR SalesHeader: Record "Sales Header";
    VAR TempSalesLineDisc: Record "Sales Line Discount"; ShowAll: Boolean);
    var
        Customer: Record Customer;
        Item: Record Item;
        AplicarDto1: Boolean;
        AplicarDto2: Boolean;
        Dto1: Decimal;
        Dto2: Decimal;
        decDtoFinal: Decimal;
    begin
        if SalesHeader.Status = SalesHeader.Status::Released then
            exit;

        if not Customer.get(SalesHeader."Bill-to Customer No.") then
            exit;

        if SalesLine.Type <> SalesLine.Type::Item then
            exit;

        if not Item.Get(SalesLine."No.") then
            exit;

        AplicarDto1 := false;
        AplicarDto2 := false;
        Dto1 := 0;
        Dto2 := 0;
        decDtoFinal := 0;

        if (item.OptClasVtas_btc = item.OptClasVtas_btc::"Bloque Máquina") or (item.OptClasVtas_btc = item.OptClasVtas_btc::"Conjunto Máquina") then begin
            AplicarDto1 := true;
            AplicarDto2 := true;
        end else
            if (item.OptClasVtas_btc = item.OptClasVtas_btc::Repuestos) then begin
                AplicarDto1 := true;
                AplicarDto2 := false;
            end;


        Dto1 := TempSalesLineDisc."Line Discount %";
        Dto2 := 0;
        if (AplicarDto1 and (Customer.Descuento1_btc > 0)) then
            Dto1 := customer.Descuento1_btc;
        if (AplicarDto2 and (Customer.Descuento2_btc > 0)) then
            Dto2 := customer.Descuento2_btc;

        decDtoFinal := (1 - ((1 - Dto1 / 100) * (1 - Dto2 / 100))) * 100;

        SalesLine."DECLine Discount1 %_btc" := Dto1;
        SalesLine."DECLine Discount2 %_btc" := Dto2;
        SalesLine.Validate("DecLine Discount2 %_btc");
        TempSalesLineDisc.DeleteAll();
        TempSalesLineDisc.init();
        TempSalesLineDisc.Type := TempSalesLineDisc.Type::Item;
        TempSalesLineDisc.Code := SalesLine."No.";
        TempSalesLineDisc."Starting Date" := Today() - 1;
        TempSalesLineDisc."Line Discount %" := decDtoFinal;
        TempSalesLineDisc."Sales Type" := TempSalesLineDisc."Sales Type"::Customer;
        TempSalesLineDisc."Sales Code" := SalesHeader."Bill-to Customer No.";
        TempSalesLineDisc."Unit of Measure Code" := SalesLine."Unit of Measure Code";
        TempSalesLineDisc."Variant Code" := SalesLine."Variant Code";
        TempSalesLineDisc.Insert();



    end;


    [EventSubscriber(ObjectType::Table, 337, 'OnAfterInsertEvent', '', false, false)]

    local procedure OnAfterInsertEvent(VAR Rec: Record "Reservation Entry"; RunTrigger: Boolean)
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        if ReservationEntry."Reservation Status" = ReservationEntry."Reservation Status"::Reservation then begin
            if ReservationEntry.Get(Rec."Entry No.", not (Rec.Positive)) then
                if ReservationEntry."Serial No." <> '' then begin
                    Rec."Serial No." := ReservationEntry."Serial No.";
                    Rec."Item Tracking" := Rec."Item Tracking"::"Serial No.";
                    rec.Modify();
                end else
                    if Rec."Serial No." <> '' then begin
                        ReservationEntry."Serial No." := Rec."Serial No.";
                        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Serial No.";
                        ReservationEntry.Modify();
                    end;
        end;

    end;

    // Permitimos cambiar cantidad en una línea de pedido de compra si venimos del proceso de matar restos
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Validate Source Line", 'OnBeforeVerifyFieldNotChanged', '', true, true)]
    local procedure CDU_5777_OnBeforeVerifyFieldNotChanged(NewRecRef: RecordRef; OldRecRef: RecordRef; FieldNumber: Integer; VAR IsHandled: Boolean)
    var
        recPurchLine: Record "Purchase Line";
    begin
        if NewRecRef.Number() <> 39 then
            exit;

        if (FieldNumber <> recPurchLine.FieldNo(Quantity)) and (FieldNumber <> recPurchLine.FieldNo("Qty. to Receive")) then
            exit;

        NewRecRef.SetTable(recPurchLine);

        if recPurchLine.PermitirMatarResto then
            IsHandled := true;
    end;

    // Permitimos en la recepción de almacén recibir más cantidad de la pendiente
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Receipt Line", 'OnBeforeValidateQtyToReceive', '', true, true)]
    local procedure T_7317_OnBeforeValidateQtyToReceive(VAR WarehouseReceiptLine: Record "Warehouse Receipt Line"; VAR IsHandled: Boolean)
    var
        recPurchHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
        if WarehouseReceiptLine."Qty. to Receive" > WarehouseReceiptLine."Qty. Outstanding" then begin
            IsHandled := true;

            recPurchHeader.Reset();
            recPurchHeader.SetRange("Document Type", WarehouseReceiptLine."Source Subtype");
            recPurchHeader.SetRange("No.", WarehouseReceiptLine."Source No.");
            if recPurchHeader.FindFirst() then begin
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", recPurchHeader."Document Type");
                PurchaseLine.SetRange("Document No.", recPurchHeader."No.");
                PurchaseLine.SetRange("Line No.", WarehouseReceiptLine."Source Line No.");
                if PurchaseLine.FindFirst() then begin
                    ReleasePurchDoc.Reopen(recPurchHeader);

                    PurchaseLine.PermitirMatarResto := true;
                    PurchaseLine.Validate(Quantity, PurchaseLine."Quantity Received" + WarehouseReceiptLine."Qty. to Receive");
                    PurchaseLine.Validate("Outstanding Quantity", PurchaseLine.Quantity - PurchaseLine."Quantity Received");
                    PurchaseLine.Modify();

                    ReleasePurchDoc.PerformManualRelease(recPurchHeader);
                end;
            end;
        end;
    end;

    // Quitar la marca interna para saltar bloqueos cuando se registra
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', true, true)]
    local procedure CU_90_OnAfterPostPurchaseDoc(VAR PurchaseHeader: Record "Purchase Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        recPurchLine: Record "Purchase Line";
    begin
        recPurchLine.Reset();
        recPurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        recPurchLine.SetRange("Document No.", PurchaseHeader."No.");
        recPurchLine.SetRange(PermitirMatarResto, true);
        if recPurchLine.FindFirst() then begin
            recPurchLine.ModifyAll(PermitirMatarResto, false);

            if not CommitIsSupressed then
                Commit();
        end;
    end;

    // Borramos la línea de recepción cuando registramos más cantidad de la original
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforePostUpdateWhseRcptLine', '', true, true)]
    local procedure CU_5760_OnBeforePostUpdateWhseRcptLine(VAR WarehouseReceiptLine: Record "Warehouse Receipt Line"; VAR WarehouseReceiptLineBuf: Record "Warehouse Receipt Line"; VAR DeleteWhseRcptLine: Boolean)
    begin
        if WarehouseReceiptLineBuf."Qty. Outstanding" - WarehouseReceiptLineBuf."Qty. to Receive" < 0 then
            DeleteWhseRcptLine := true;
    end;

    // Al registrar un documento de compra comprobamos que exista tipo de cambio
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    local procedure CU_90_OnBeforePostPurchaseDoc(VAR Sender: Codeunit "Purch.-Post"; VAR PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        TestTipoCambioDocumentoCompra(PurchaseHeader);
        //IF (PurchaseHeader.Invoice) or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) THEN begin
        GeneralLedgerSetup.FindFirst();
        if GeneralLedgerSetup.BloqueoCompras <> 0D THEN begin
            IF PurchaseHeader."Posting Date" < GeneralLedgerSetup.BloqueoCompras THEN
                Error('Período de facturación de compras cerrada');
        END;
        //end;
    end;


    // Al lanzar un documento de compra comprobamos que exista tipo de cambio
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeManualReleasePurchaseDoc', '', true, true)]
    local procedure CU_415_OnBeforeManualReleasePurchaseDoc(VAR PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        TestTipoCambioDocumentoCompra(PurchaseHeader);
        TestCamposPedidos(PurchaseHeader); //Control campos obligatorios pedidos
    end;

    local procedure TestTipoCambioDocumentoCompra(var PurchaseHeader: Record "Purchase Header")
    var
        cduDivisas: Codeunit Funciones;
        fechaDivisa: Date;
        lbErrorDivisaErr: Label 'No exchange rate is found for currency: %1 and date: %2 %3: %4',
            comment = 'ESP="No se encuentra tipo de cambio para divisa: %1 y fecha: %2 %3: %4"';
    begin
        Clear(cduDivisas);

        if cduDivisas.GetActivaDivisasFechaEmision() then
            fechaDivisa := PurchaseHeader."Document Date"
        else
            fechaDivisa := PurchaseHeader."Posting Date";

        if not cduDivisas.ExisteTipoCambio(PurchaseHeader."Currency Code", fechaDivisa) then
            Error(StrSubstNo(lbErrorDivisaErr, PurchaseHeader."Currency Code", fechaDivisa, Format(PurchaseHeader."Document Type"), PurchaseHeader."No."));
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterValidateEvent', 'Blocked', true, true)]
    local procedure T_23_OnAfterValidateBlocked(var Rec: Record Vendor; var xRec: Record Vendor; CurrFieldNo: Integer)
    begin
        if (Rec.Blocked <> xRec.Blocked) and (Rec.Blocked = Rec.Blocked::" ") then
            rec.CodMotivoBloqueo_btc := '';
    end;

    local procedure TestCamposPedidos(var pPurchaseHeader: Record "Purchase Header")
    begin
        pPurchaseHeader.TESTFIELD("Payment Method Code");
        pPurchaseHeader.TESTFIELD("Payment Terms Code");
        pPurchaseHeader.TestField("Due Date");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterActionEvent', 'Create &Whse. Receipt', true, true)]
    local procedure Pag_50_OnAfterActionEvent_CreateWhseReceipt(var Rec: Record "Purchase Header")
    begin
        TestCamposPedidos(Rec);
    end;


    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure T_39_OnAfterInsertEvent(VAR Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
    begin

        rec."Planning Flexibility" := rec."Planning Flexibility"::None;

    end;




    //Descripción 2 mov producto
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    local procedure CDU_22_OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        if ItemJournalLine.Desc2_btc <> '' then
            NewItemLedgEntry.Desc2_btc := ItemJournalLine.Desc2_btc;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeApplyItemLedgEntry', '', true, true)]
    local procedure CDU_22_OnBeforeApplyItemLedgEntry(var ItemLedgEntry: Record "Item Ledger Entry"; var OldItemLedgEntry: Record "Item Ledger Entry"; var ValueEntry: Record "Value Entry"; CausedByTransfer: Boolean; var Handled: Boolean)
    begin
        if OldItemLedgEntry.Desc2_btc <> '' then
            ItemLedgEntry.Desc2_btc := OldItemLedgEntry.Desc2_btc;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterApplyItemLedgEntry', '', true, true)]
    local procedure CDU_22_OnAfterApplyItemLedgEntry(var GlobalItemLedgerEntry: Record "Item Ledger Entry"; var OldItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        if OldItemLedgerEntry.Desc2_btc <> '' then begin
            if GlobalItemLedgerEntry.Desc2_btc = '' then
                GlobalItemLedgerEntry.Desc2_btc := OldItemLedgerEntry.Desc2_btc;

            if ItemJournalLine.Desc2_btc = '' then
                ItemJournalLine.Desc2_btc := OldItemLedgerEntry.Desc2_btc;
        end;
    end;

    //OnAfterPostItemJnlLine
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterPostItemJnlLine', '', true, true)]
    local procedure CDU_22_OnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; ItemLedgerEntry: Record "Item Ledger Entry")
    var
        recMovProdOrigen: Record "Item Ledger Entry";
        recItemLedFinal: Record "Item Ledger Entry";
        recItemAppEntry: Record "Item Application Entry";
        numMovProductoOrign: Integer;
    begin
        numMovProductoOrign := 0;

        recItemAppEntry.Reset();
        recItemAppEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
        if recItemAppEntry.FindFirst() then begin
            if recItemAppEntry."Inbound Item Entry No." <> ItemLedgerEntry."Entry No." then
                numMovProductoOrign := recItemAppEntry."Inbound Item Entry No."
            else
                if recItemAppEntry."Outbound Item Entry No." <> ItemLedgerEntry."Entry No." then
                    numMovProductoOrign := recItemAppEntry."Outbound Item Entry No.";

            if numMovProductoOrign <> 0 then begin
                if recMovProdOrigen.get(numMovProductoOrign) and (recMovProdOrigen.Desc2_btc <> '') then begin
                    recItemLedFinal.Reset();
                    recItemLedFinal.SetRange("Entry No.", ItemLedgerEntry."Entry No.");
                    if recItemLedFinal.FindFirst() then begin
                        recItemLedFinal.Desc2_btc := recMovProdOrigen.Desc2_btc;
                        recItemLedFinal.Modify();
                    end;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnAfterTransferOrderPostReceipt', '', true, true)]
    local procedure CDU_TransPostRcpt_OnAfterTransferOrderPostReceipt(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        TransferReceiptHeader.NumBultos_btc := TransferHeader.NumBultos_btc;
        TransferReceiptHeader.NumPalets_btc := TransferHeader.NumPalets_btc;
        TransferReceiptHeader.Peso_btc := TransferHeader.Peso_btc;
        TransferReceiptHeader.PedidoImpreso := TransferHeader.PedidoImpreso;
        if TransferReceiptHeader.Modify() then;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', true, true)]
    local procedure CDU_TansPostShip_OnAfterTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferShipmentHeader: Record "Transfer Shipment Header")
    begin
        TransferShipmentHeader.NumBultos_btc := TransferHeader.NumBultos_btc;
        TransferShipmentHeader.NumPalets_btc := TransferHeader.NumPalets_btc;
        TransferShipmentHeader.Peso_btc := TransferHeader.Peso_btc;
        TransferShipmentHeader.PedidoImpreso := TransferHeader.PedidoImpreso;
        if TransferShipmentHeader.Modify() then;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure T_32_OnAfterInserEvent(var Rec: Record "Item Ledger Entry"; RunTrigger: Boolean)
    var
        recSalesShptHeader: Record "Sales Shipment Header";
        recTransferHeader: Record "Transfer Header";
        Funciones: Codeunit Funciones;
        codCliente: Code[50];
    begin
        if (Rec."Entry Type" = rec."Entry Type"::Sale) and (rec."Document Type" = rec."Document Type"::"Sales Shipment") then begin
            if recSalesShptHeader.get(rec."Document No.") then begin
                rec.CodCliente_btc := recSalesShptHeader."Bill-to Customer No.";
                rec.Modify();
            end;
        end else
            if (rec."Entry Type" = rec."Entry Type"::Transfer) and (rec."Document Type" = rec."Document Type"::"Transfer Shipment") then begin
                if recTransferHeader.get(rec."Document No.") then begin
                    codCliente := Funciones.ObtenerValorCampoExtension(DATABASE::"Transfer Header", 50600, 1, recTransferHeader."No.");

                    if codCliente <> '' then begin
                        rec.CodCliente_btc := codCliente;
                        rec.Modify();
                    end;
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventcUSTOMER(rec: Record Customer)
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.reset;
        DimensionValue.Init();
        DimensionValue."Dimension Code" := 'PROYECTO';
        // JJV 14/08/20 ponemos la dimension global al numero indicado
        DimensionValue."Global Dimension No." := 2;
        // fin 
        DimensionValue.Code := REC."No.";
        DimensionValue.Name := rec.Name;
        DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
        IF DimensionValue.Insert() THEN;
    end;

    [EventSubscriber(ObjectType::Table, database::Customer, 'OnAfterValidateEvent', 'Name', false, false)]
    local procedure OnAfterModifyEventcUSTOMER(rec: Record Customer)
    var
        DimensionValue: Record "Dimension Value";
    begin
        DimensionValue.reset;
        DimensionValue.SetRange("Dimension Code", 'PROYECTO');
        // JJV 14/08/20 ponemos la dimension global al numero indicado
        DimensionValue."Global Dimension No." := 2;
        // fin 

        DimensionValue.SetRange(code, Rec."No.");
        if DimensionValue.FindFirst() then begin
            DimensionValue.Name := rec.Name;
            DimensionValue.Modify();
        end;
    end;

}