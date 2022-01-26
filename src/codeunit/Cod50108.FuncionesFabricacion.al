codeunit 50108 "FuncionesFabricacion"
{
    procedure CambiaEstadoVariasOrdenesProduccion(var pOrdenProd: Record "Production Order")
    var
        cduProdorderStatus: Codeunit "Prod. Order Status Management";
        ChangeStatusForm: Page "Change Status on Prod. Order";
        NewStatus: Option Quote,Planned,"Firm Planned",Released,Finished;
        NewPostingDate: Date;
        NewUpdateUnitCost: Boolean;
        labelConfirmQst: Label 'Do you want to change the status of the selected orders?', comment = 'ESP="¿Desea cambiar el estado de las ordenes seleccionadas?"';
    begin
        if not Confirm(labelConfirmQst) then
            exit;

        if pOrdenProd.FindFirst() then begin
            Clear(ChangeStatusForm);
            ChangeStatusForm.Set(pOrdenProd);

            IF ChangeStatusForm.RUNMODAL() = ACTION::Yes THEN BEGIN
                ChangeStatusForm.ReturnPostingInfo(NewStatus, NewPostingDate, NewUpdateUnitCost);

                if pOrdenProd.FindSet() then
                    repeat
                        Clear(cduProdorderStatus);
                        cduprodorderstatus.ChangeStatusOnProdOrder(pOrdenProd, NewStatus, NewPostingDate, NewUpdateUnitCost);
                        COMMIT();
                    until pOrdenProd.Next() = 0;
            END;
        end;
    end;

    // Al actualizar la cantidad de la línea de OP actualizamos también la cantidad de la cabecera
    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure T_5406_OnAfterValidateEvent(VAR Rec: Record "Prod. Order Line"; VAR xRec: Record "Prod. Order Line"; CurrFieldNo: Integer)
    var
        recLinOp: Record "Prod. Order Line";
        recCabOp: Record "Production Order";
        decCantidadCabecera: Decimal;
    begin
        if rec.Quantity = xRec.Quantity then
            exit;

        decCantidadCabecera := Rec.Quantity;

        recLinOp.Reset();
        recLinOp.SetRange(Status, Rec.Status);
        recLinOp.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        recLinOp.SetFilter("Line No.", '<>%1', rec."Line No.");
        if recLinOp.FindSet() then
            repeat
                decCantidadCabecera += recLinOp.Quantity;
            until recLinOp.Next() = 0;

        recCabOp.Reset();
        recCabOp.SetRange(Status, rec.Status);
        recCabOp.SetRange("No.", rec."Prod. Order No.");
        if recCabOp.FindFirst() then begin
            recCabOp.Validate(Quantity, decCantidadCabecera);
            recCabOp.Modify(true);
        end;
    end;

    // Al actualizar la cantidad de la línea de OP actualizamos también la cantidad de la cabecera
    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", 'OnBeforeValidateEvent', 'Starting Date', true, true)]
    local procedure T_5406_OnBeforeValidateEventStartDate(VAR Rec: Record "Prod. Order Line"; VAR xRec: Record "Prod. Order Line"; CurrFieldNo: Integer)
    var
        ProductionOrder: Record "Production Order";
    begin
        rec.FechaInicial_btc := rec."Starting Date";
        Rec."Starting Date-Time" := CreateDateTime(Rec."Starting Date", 0T);
        Rec."Starting Date" := Rec."Starting Date";
        ProductionOrder.Get(Rec.Status, Rec."Prod. Order No.");
        ProductionOrder."Starting Date-Time" := CreateDateTime(Rec."Starting Date", 0T);
        ProductionOrder."Starting Date" := rec."Starting Date";
        ProductionOrder.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", 'OnBeforeValidateEvent', 'Starting Date-Time', true, true)]
    local procedure T_5406_OnBeforeValidateEventStartDatetime(VAR Rec: Record "Prod. Order Line"; VAR xRec: Record "Prod. Order Line"; CurrFieldNo: Integer)
    var

    begin
        rec.FechaInicial_btc := DT2Date(rec."Starting Date-Time");
    end;

    // Al regenerar la hoja de planificación, marcamos a sí el campo Aceptar mensaje. No hay evento para hacerlo durante el proceso
    [EventSubscriber(ObjectType::Page, Page::"Planning Worksheet", 'OnAfterActionEvent', 'CalculateRegenerativePlan', true, true)]
    local procedure P_99000852_OnAfterActionEvent(VAR Rec: Record "Requisition Line")
    var
        recReqLine: Record "Requisition Line";
        recReqLine2: Record "Requisition Line";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        Item: Record Item;
    begin
        RefrescarHoja(rec."Worksheet Template Name", rec."Journal Batch Name");
    end;

    local procedure RefrescarHoja(Worksheettemplate: Code[20]; JournalBatchName: code[20])
    var
        recReqLine: Record "Requisition Line";
        recReqLine2: Record "Requisition Line";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        Item: Record Item;
        Transparency: Codeunit "Planning Transparency";
        Warning: Integer;
        InventorySetup: record "Inventory Setup";
    begin
        InventorySetup.Get();
        recReqLine.Reset();
        recReqLine.SetRange("Worksheet Template Name", Worksheettemplate);
        recReqLine.SetRange("Journal Batch Name", JournalBatchName);
        if recReqLine.FindSet() then begin
            repeat
                if InventorySetup."MRP Bitec Activo" then begin

                    recReqLine2.reset;
                    recReqLine2.SetRange("Worksheet Template Name", recReqLine."Worksheet Template Name");
                    recReqLine2.SetRange("Journal Batch Name", recReqLine."Journal Batch Name");
                    recReqLine2.SetRange("No.", recReqLine."No.");
                    recReqLine2.SetRange("Action Message", recReqLine."Action Message"::New);
                    recReqLine2.SetFilter("Line No.", '<>%1', recReqLine."Line No.");
                    recReqLine2.SetFilter("Location Code", recReqLine."Location Code");
                    if recReqLine2.FindSet() then begin
                        repeat
                            recReqLine.validate(Quantity, recReqLine.Quantity + recReqLine2.Quantity);
                            ReservationEntry.reset;
                            ReservationEntry.SetRange("Source ID", recReqLine2."Worksheet Template Name");
                            ReservationEntry.SetRange("Source Ref. No.", recReqLine2."Line No.");
                            if ReservationEntry.FindSet() then begin
                                repeat
                                    ReservationEntry2.Get(ReservationEntry."Entry No.", ReservationEntry.Positive);
                                    ReservationEntry2."Source Ref. No." := recReqLine."Line No.";
                                    ReservationEntry2.Modify();

                                until ReservationEntry.Next() = 0;
                            end;
                            recReqLine2.Delete(true);
                        until recReqLine2.Next() = 0;
                    end;
                    Item.reset;
                    Item.SetRange("No.", recReqLine."No.");
                    if Item.FindFirst() then begin

                        if Item."Minimum Order Quantity" > recReqLine.Quantity then
                            recReqLine.validate(Quantity, Item."Minimum Order Quantity");

                        if Item."Order Multiple" <> 0 then begin
                            if recReqLine.Quantity mod Item."Order Multiple" <> 0 then begin
                                recReqLine.validate(Quantity, (Round(recReqLine.Quantity / Item."Order Multiple", 1, '>')) * Item."Order Multiple");
                            end;
                        end;
                    end;
                end;
                recReqLine.Validate("Starting Date", CalcDate('2S', Today));
                recReqLine.Estado := HojaDemandaUrgente(recReqLine);
                Warning := Transparency.ReqLineWarningLevel(recReqLine);
                // " ",Emergency,Exception,Attention
                if Warning in [0, 1, 3] then
                    recReqLine."Accept Action Message" := true;
                recReqLine."Planning Flexibility" := recReqLine."Planning Flexibility"::None;
                recReqLine.Modify();
            until recReqLine.Next() = 0;
        end;

    end;

    local procedure HojaDemandaUrgente(RequisitionLine: Record "Requisition Line") MyOption: Option Pedido,Oferta,StockSeguridad
    var
        StockUnit: Record "Stockkeeping Unit";
    begin
        //MyOption := false;
        StockUnit.reset;
        StockUnit.SetRange("Item No.", RequisitionLine."No.");
        StockUnit.SetRange("Location Code", RequisitionLine."Location Code");
        StockUnit.SetRange("Variant Code", RequisitionLine."Variant Code");
        if StockUnit.FindSet() then begin
            StockUnit.CalcFields("Qty. on Sales Order", "Qty. on Component Lines");
            StockUnit.CalcFields("Qty. on Service Order", "Trans. Ord. Shipment (Qty.)");
            StockUnit.CalcFields(Inventory, "Qty. on Asm. Component");
            StockUnit.CalcFields(QtyonQuotesOrder, "Cant_ componentes Oferta");
            StockUnit.CalcFields("Qty. on Purch. Order", "Qty. on Prod. Order");
            StockUnit.CalcFields("Qty. on Assembly Order");
            if (StockUnit.Inventory +
                StockUnit."Qty. on Assembly Order" +
                StockUnit."Qty. on Prod. Order" +
                StockUnit."Qty. on Purch. Order" +
                StockUnit."Trans. Ord. Receipt (Qty.)")
                <
                (StockUnit."Qty. on Service Order" +
                StockUnit."Qty. on Sales Order" +
                StockUnit."Qty. on Component Lines" +
                StockUnit."Qty. on Asm. Component" +
                StockUnit."Trans. Ord. Shipment (Qty.)") then begin
                MyOption := MyOption::Pedido;
            end else
                if
                (StockUnit.Inventory +
                StockUnit."Qty. on Assembly Order" +
                StockUnit."Qty. on Prod. Order" +
                StockUnit."Qty. on Purch. Order" +
                StockUnit."Trans. Ord. Receipt (Qty.)")
                <
                    (StockUnit.QtyonQuotesOrder +
                    StockUnit."Cant_ componentes Oferta" +
                    StockUnit."Qty. on Service Order" +
                    StockUnit."Qty. on Sales Order" +
                    StockUnit."Qty. on Component Lines" +
                    StockUnit."Qty. on Asm. Component" +
                    StockUnit."Trans. Ord. Shipment (Qty.)") then begin
                    MyOption := MyOption::Oferta;
                end else begin
                    MyOption := MyOption::StockSeguridad;
                end;
        end;
    end;

    // Al regenerar la hoja de planificación, marcamos a sí el campo Aceptar mensaje. No hay evento para hacerlo durante el proceso
    [EventSubscriber(ObjectType::Page, Page::"Req. Worksheet", 'OnAfterActionEvent', 'CalculatePlan', true, true)]
    local procedure P_292_OnAfterActionEvent(VAR Rec: Record "Requisition Line")
    var
        recReqLine: Record "Requisition Line";
        recReqLine2: Record "Requisition Line";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        Item: Record Item;
    begin
        RefrescarHoja(rec."Worksheet Template Name", rec."Journal Batch Name");

    end;


    procedure LanzarPlanificacionDesdePedidos()
    var
        SalesHeader: Record "Sales Header";
        PSalesHeader: Page SalesOrderList;
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ItemCompra: Record item;
        ItemPedido: Record item;
        BomComponent: Record "BOM Component";
        CalcPlan: Report "Calculate Plan - Plan. Wksh.";
        CalculatePlan: Report "Calculate Plan - Req. Wksh.";
        ProductionBomLine: Record "Production BOM Line";
        ProductionBomLine2: Record "Production BOM Line";
        ReqWkshNames: Page "ReqWkshNames";
        RequisitionWkshName: Record "Requisition Wksh. Name";
    begin
        Item.reset;
        if Item.FindSet() then begin
            repeat
                if Item.Ordenacion_btc <> 0 then begin
                    Item.Ordenacion_btc := 0;
                    Item.Modify;
                end;
            until Item.Next() = 0;
        end;
        Commit();
        RequisitionWkshName.Reset();
        RequisitionWkshName.SetRange("Template Type", RequisitionWkshName."Template Type"::Planning);
        clear(ReqWkshNames);
        ReqWkshNames.LOOKUPMODE(TRUE);
        ReqWkshNames.SetTableView(RequisitionWkshName);
        if ReqWkshNames.RunModal() = Action::LookupOK then begin
            RequisitionWkshName.reset;
            ReqWkshNames.GetResult(RequisitionWkshName);
            RequisitionWkshName.FindFirst();
        end;

        Commit();
        SalesHeader.reset;
        SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Quote);
        PSalesHeader.LOOKUPMODE(TRUE);
        PSalesHeader.SetTableView(SalesHeader);
        if PSalesHeader.RunModal() = Action::LookupOK then begin
            SalesHeader.reset;
            PSalesHeader.GetResult(SalesHeader);
            if SalesHeader.FindSet() then begin
                repeat
                    SalesLine.reset;
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    SalesLine.SetFilter("Outstanding Quantity", '>0');
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    if SalesLine.FindSet() then begin
                        repeat
                            Item.reset;
                            Item.SetRange("No.", SalesLine."No.");
                            item.FindFirst();
                            if Item."Assembly BOM" then begin
                                BomComponent.reset;
                                BomComponent.SetRange("Parent Item No.", Item."No.");
                                if BomComponent.FindSet() then begin
                                    repeat
                                        ItemPedido.SetRange("No.", BomComponent."No.");
                                        ItemPedido.FindFirst();
                                        if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                            ItemPedido.Ordenacion_btc := 1;
                                            ItemPedido.Modify();
                                            ProductionBomLine.reset;
                                            ProductionBomLine.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                                            if ProductionBomLine.FindSet() then begin
                                                repeat
                                                    ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                                    ItemPedido.FindFirst();
                                                    if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                                        ItemPedido.Ordenacion_btc := 1;
                                                        ItemPedido.modify();
                                                        ProductionBomLine2.reset;
                                                        ProductionBomLine2.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                                                        if ProductionBomLine2.FindSet() then begin
                                                            repeat
                                                                ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                                                ItemPedido.FindFirst();
                                                                if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                                                    ItemPedido.Ordenacion_btc := 1;
                                                                    ItemPedido.modify();

                                                                end else begin
                                                                    ItemCompra.SetRange("No.", ProductionBomLine."No.");
                                                                    ItemCompra.FindFirst();
                                                                    ItemCompra.Ordenacion_btc := 1;
                                                                    ItemCompra.Modify();

                                                                end;
                                                            until ProductionBomLine2.Next() = 0;
                                                        end;
                                                    end else begin

                                                        ItemCompra.SetRange("No.", ProductionBomLine."No.");
                                                        ItemCompra.FindFirst();
                                                        ItemCompra.Ordenacion_btc := 1;
                                                        ItemCompra.Modify();
                                                    end;
                                                until ProductionBomLine.Next() = 0;

                                            end;

                                        end else begin
                                            ItemCompra.SetRange("No.", BomComponent."No.");
                                            ItemCompra.FindFirst();
                                            ItemCompra.Ordenacion_btc := 1;
                                            ItemCompra.Modify();
                                        end;
                                    until BomComponent.Next() = 0;
                                end;
                            end else begin
                                //ItemPedido.reset;
                                ItemPedido.SetRange("No.", SalesLine."No.");
                                ItemPedido.FindFirst();
                                if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                    ItemPedido.Ordenacion_btc := 1;
                                    ItemPedido.modify();
                                    ProductionBomLine.reset;
                                    ProductionBomLine.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                                    if ProductionBomLine.FindSet() then begin
                                        repeat
                                            ItemPedido.reset;
                                            ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                            ItemPedido.FindFirst();
                                            if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                                ItemPedido.Ordenacion_btc := 1;
                                                ItemPedido.modify();
                                                ProductionBomLine2.reset;
                                                ProductionBomLine2.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                                                if ProductionBomLine2.FindSet() then begin
                                                    repeat
                                                        //item4.reset;
                                                        ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                                        ItemPedido.FindFirst();
                                                        if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                                            ItemPedido.Ordenacion_btc := 1;
                                                            ItemPedido.modify();
                                                        end else begin
                                                            ItemCompra.SetRange("No.", ProductionBomLine2."No.");
                                                            ItemCompra.FindFirst();
                                                            ItemCompra.Ordenacion_btc := 1;
                                                            ItemCompra.modify();
                                                        end;
                                                    until ProductionBomLine2.Next() = 0;
                                                end;
                                            end else begin
                                                ItemCompra.SetRange("No.", ProductionBomLine."No.");
                                                ItemCompra.FindFirst();
                                                ItemCompra.Ordenacion_btc := 1;
                                                ItemCompra.modify();
                                            end;
                                        until ProductionBomLine.Next() = 0;

                                    end;

                                end else begin
                                    ItemCompra.SetRange("No.", SalesLine."No.");
                                    ItemCompra.FindFirst();
                                    ItemCompra.Ordenacion_btc := 1;
                                    ItemCompra.modify();
                                end;
                            end;
                        until SalesLine.Next() = 0;
                    end;
                until SalesHeader.Next() = 0;

            end;
        end;

        commit;

        ItemPedido.SetRange("No.");
        ItemPedido.SetRange("Location Filter", 'MMPP');
        ItemPedido.SetRange("Replenishment System", ItemCompra."Replenishment System"::"Prod. Order");
        ItemPedido.SetRange(Ordenacion_btc, 1);
        ItemPedido.SetRange(Blocked, false);
        CalcPlan.SetTableView(ItemPedido);
        CalcPlan.SetTemplAndWorksheet('PLANIF.', RequisitionWkshName."Name", TRUE);
        CalcPlan.UseRequestPage(false);
        CalcPlan.InitializeRequest(today - 60, TODAY + 60, TRUE);
        CalcPlan.RunModal();
        clear(CalcPlan);

        commit;
        ItemCompra.SetRange("No.");
        ItemCompra.SetRange("Location Filter", 'MMPP');
        ItemCompra.SetRange("Replenishment System", ItemCompra."Replenishment System"::Purchase);
        ItemCompra.SetRange(Ordenacion_btc, 1);
        ItemCompra.SetRange(Blocked, false);
        CalculatePlan.SetTableView(ItemCompra);
        CalculatePlan.SetTemplAndWorksheet('APROV.', RequisitionWkshName."Name");
        CalculatePlan.UseRequestPage(false);
        CalculatePlan.InitializeRequest(today - 60, TODAY + 60);
        CalculatePlan.RUNMODAL;
        CLEAR(CalculatePlan);

        RefrescarHoja('PLANIF.', RequisitionWkshName."Name");
        RefrescarHoja('APROV.', RequisitionWkshName."Name");
    end;

    procedure LanzarPlanificacionDesdeTrans()
    var

        Item: Record Item;
        ItemCompra: Record item;
        ItemPedido: Record item;
        CalcPlan: Report "Calculate Plan - Plan. Wksh.";
        CalculatePlan: Report "Calculate Plan - Req. Wksh.";
        ProductionBomLine: Record "Production BOM Line";
        ProductionBomLine2: Record "Production BOM Line";
        TransferHeader: Record "Transfer Header";
        TransferOrders: page "Transfer Orders";
        TransferLines: Record "Transfer Line";
        ReqWkshNames: Page "ReqWkshNames";
        RequisitionWkshName: Record "Requisition Wksh. Name";
    begin
        Item.reset;
        if Item.FindSet() then begin
            repeat
                if Item.Ordenacion_btc <> 0 then begin
                    Item.Ordenacion_btc := 0;
                    Item.Modify;
                end;
            until Item.Next() = 0;
        end;
        Commit();
        RequisitionWkshName.Reset();
        RequisitionWkshName.SetRange("Template Type", RequisitionWkshName."Template Type"::Planning);
        clear(ReqWkshNames);
        ReqWkshNames.LOOKUPMODE(TRUE);
        ReqWkshNames.SetTableView(RequisitionWkshName);
        if ReqWkshNames.RunModal() = Action::LookupOK then begin
            RequisitionWkshName.reset;
            ReqWkshNames.GetResult(RequisitionWkshName);
            RequisitionWkshName.FindFirst();
        end;

        commit;
        TransferHeader.reset;
        TransferHeader.findset;
        TransferOrders.LOOKUPMODE(TRUE);
        TransferOrders.SetTableView(TransferHeader);
        if TransferOrders.RunModal() = Action::LookupOK then begin
            TransferHeader.reset;
            TransferOrders.GetResult(TransferHeader);
            if TransferHeader.FindSet() then begin
                repeat
                    TransferLines.reset;
                    TransferLines.SetRange("Document No.", TransferHeader."No.");
                    if TransferLines.FindSet() then begin
                        repeat
                            Item.reset;
                            Item.SetRange("No.", TransferLines."Item No.");
                            item.FindFirst();

                            ItemPedido.SetRange("No.", TransferLines."Item No.");
                            ItemPedido.FindFirst();
                            if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                ItemPedido.Ordenacion_btc := 1;
                                ItemPedido.modify();
                                ProductionBomLine.reset;
                                ProductionBomLine.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                                if ProductionBomLine.FindSet() then begin
                                    repeat
                                        ItemPedido.reset;
                                        ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                        ItemPedido.FindFirst();
                                        if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                            ItemPedido.Ordenacion_btc := 1;
                                            ItemPedido.modify();
                                            ProductionBomLine2.reset;
                                            ProductionBomLine2.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                                            if ProductionBomLine2.FindSet() then begin
                                                repeat
                                                    //item4.reset;
                                                    ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                                    ItemPedido.FindFirst();
                                                    if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                                        ItemPedido.Ordenacion_btc := 1;
                                                        ItemPedido.modify();
                                                    end else begin
                                                        ItemCompra.SetRange("No.", ProductionBomLine2."No.");
                                                        ItemCompra.FindFirst();
                                                        ItemCompra.Ordenacion_btc := 1;
                                                        ItemCompra.modify();
                                                    end;
                                                until ProductionBomLine2.Next() = 0;
                                            end;
                                        end else begin
                                            ItemCompra.SetRange("No.", ProductionBomLine."No.");
                                            ItemCompra.FindFirst();
                                            ItemCompra.Ordenacion_btc := 1;
                                            ItemCompra.modify();
                                        end;
                                    until ProductionBomLine.Next() = 0;

                                end;

                            end else begin
                                ItemCompra.SetRange("No.", TransferLines."Item No.");
                                ItemCompra.FindFirst();
                                ItemCompra.Ordenacion_btc := 1;
                                ItemCompra.modify();
                            end;


                        until TransferLines.Next() = 0;
                    end;
                until TransferHeader.Next() = 0;

            end;
        end;

        commit;




        ItemPedido.SetRange("No.");
        ItemPedido.SetRange("Location Filter", 'MMPP');
        ItemPedido.SetRange("Replenishment System", ItemCompra."Replenishment System"::"Prod. Order");
        ItemPedido.SetRange(Ordenacion_btc, 1);
        ItemPedido.SetRange(Blocked, false);
        CalcPlan.SetTableView(ItemPedido);
        CalcPlan.SetTemplAndWorksheet('PLANIF.', RequisitionWkshName."Name", TRUE);
        CalcPlan.UseRequestPage(false);
        CalcPlan.InitializeRequest(today - 60, TODAY + 60, TRUE);
        CalcPlan.RunModal();
        clear(CalcPlan);

        commit;
        ItemCompra.SetRange("No.");
        ItemCompra.SetRange("Location Filter", 'MMPP');
        ItemCompra.SetRange("Replenishment System", ItemCompra."Replenishment System"::Purchase);
        ItemCompra.SetRange(Ordenacion_btc, 1);
        ItemCompra.SetRange(Blocked, false);
        CalculatePlan.SetTableView(ItemCompra);
        CalculatePlan.SetTemplAndWorksheet('APROV.', RequisitionWkshName."Name");
        CalculatePlan.UseRequestPage(false);
        CalculatePlan.InitializeRequest(today - 60, TODAY + 60);
        CalculatePlan.RUNMODAL;
        CLEAR(CalculatePlan);

        RefrescarHoja('PLANIF.', RequisitionWkshName."Name");
        RefrescarHoja('APROV.', RequisitionWkshName."Name");

    end;

    procedure LanzarPlanificacionDesdeFabs()
    var

        Item: Record Item;
        ItemCompra: Record item;
        ItemPedido: Record item;
        CalcPlan: Report "Calculate Plan - Plan. Wksh.";
        CalculatePlan: Report "Calculate Plan - Req. Wksh.";
        ProductionBomLine: Record "Production BOM Line";
        ProductionBomLine2: Record "Production BOM Line";
        ProdOrderLine: Record "Prod. Order Line";
        PProdorderlines: Page "Prod. Order Line List";
        ReqWkshNames: Page "ReqWkshNames";
        RequisitionWkshName: Record "Requisition Wksh. Name";
    begin
        Item.reset;
        if Item.FindSet() then begin
            repeat
                if Item.Ordenacion_btc <> 0 then begin
                    Item.Ordenacion_btc := 0;
                    Item.Modify;
                end;
            until Item.Next() = 0;
        end;
        Commit();
        RequisitionWkshName.Reset();
        RequisitionWkshName.SetRange("Template Type", RequisitionWkshName."Template Type"::Planning);
        clear(ReqWkshNames);
        ReqWkshNames.LOOKUPMODE(TRUE);
        ReqWkshNames.SetTableView(RequisitionWkshName);
        if ReqWkshNames.RunModal() = Action::LookupOK then begin
            RequisitionWkshName.reset;
            ReqWkshNames.GetResult(RequisitionWkshName);
            RequisitionWkshName.FindFirst();
        end;

        commit;
        ProdOrderLine.reset;
        ProdOrderLine.Setfilter(Status, '<4');
        ProdOrderLine.findset;
        PProdorderlines.LOOKUPMODE(TRUE);
        PProdorderlines.SetTableView(ProdOrderLine);
        if PProdorderlines.RunModal() = Action::LookupOK then begin
            //Message('estoy dentro');
            ProdOrderLine.reset;
            PProdorderlines.GetResult(ProdOrderLine);
            if ProdOrderLine.FindSet() then begin
                repeat
                    Item.reset;
                    Item.SetRange("No.", ProdOrderLine."Item No.");
                    item.FindFirst();

                    //ItemPedido.reset;
                    ItemPedido.SetRange("No.", ProdOrderLine."Item No.");
                    ItemPedido.FindFirst();
                    if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                        ItemPedido.Ordenacion_btc := 1;
                        ItemPedido.modify();
                        ProductionBomLine.reset;
                        ProductionBomLine.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                        if ProductionBomLine.FindSet() then begin
                            repeat
                                ItemPedido.reset;
                                ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                ItemPedido.FindFirst();
                                if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                    ItemPedido.Ordenacion_btc := 1;
                                    ItemPedido.modify();
                                    ProductionBomLine2.reset;
                                    ProductionBomLine2.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                                    if ProductionBomLine2.FindSet() then begin
                                        repeat
                                            ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                            ItemPedido.FindFirst();
                                            if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                                ItemPedido.Ordenacion_btc := 1;
                                                ItemPedido.modify();

                                            end else begin
                                                ItemCompra.SetRange("No.", ProductionBomLine2."No.");
                                                ItemCompra.FindFirst();
                                                ItemCompra.Ordenacion_btc := 1;
                                                ItemCompra.modify();
                                            end;
                                        until ProductionBomLine2.Next() = 0;
                                    end;
                                end else begin

                                    ItemCompra.SetRange("No.", ProductionBomLine."No.");
                                    ItemCompra.FindFirst();
                                    ItemCompra.Ordenacion_btc := 1;
                                    ItemCompra.modify();
                                end;
                            until ProductionBomLine.Next() = 0;

                        end;

                    end else begin
                        ItemCompra.SetRange("No.", ProdOrderLine."Item No.");
                        ItemCompra.FindFirst();
                        ItemCompra.Ordenacion_btc := 1;
                        ItemCompra.modify();
                    end;

                until ProdOrderLine.Next() = 0;

            end;
        end;

        commit;

        ItemPedido.SetRange("No.");
        ItemPedido.SetRange("Location Filter", 'MMPP');
        ItemPedido.SetRange("Replenishment System", ItemCompra."Replenishment System"::"Prod. Order");
        ItemPedido.SetRange(Ordenacion_btc, 1);
        ItemPedido.SetRange(Blocked, false);
        CalcPlan.SetTableView(ItemPedido);
        CalcPlan.SetTemplAndWorksheet('PLANIF.', RequisitionWkshName."Name", TRUE);
        CalcPlan.UseRequestPage(false);
        CalcPlan.InitializeRequest(today - 60, TODAY + 60, TRUE);
        CalcPlan.RunModal();
        clear(CalcPlan);

        commit;
        ItemCompra.SetRange("No.");
        ItemCompra.SetRange("Location Filter", 'MMPP');
        ItemCompra.SetRange("Replenishment System", ItemCompra."Replenishment System"::Purchase);
        ItemCompra.SetRange(Ordenacion_btc, 1);
        ItemCompra.SetRange(Blocked, false);
        CalculatePlan.SetTableView(ItemCompra);
        CalculatePlan.SetTemplAndWorksheet('APROV.', RequisitionWkshName."Name");
        CalculatePlan.UseRequestPage(false);
        CalculatePlan.InitializeRequest(today - 60, TODAY + 60);
        CalculatePlan.RUNMODAL;
        CLEAR(CalculatePlan);

        RefrescarHoja('PLANIF.', RequisitionWkshName."Name");
        RefrescarHoja('APROV.', RequisitionWkshName."Name");

    end;

    //Check precondiciones para poder realizar partición de la OP desde Hoja de planificación, interactua con cdu 50109
    procedure PreChecksPartitionOP(var ReqLine: Record "Requisition Line"): Boolean
    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        Clear(Item);
        Item.GET(ReqLine."No.");
        //cambiar a la info del lote y ver marca activar NS 
        If (ReqLine.Quantity <= 1) then
            exit(false)
        else begin
            CLEAR(ItemTrackingCode);
            if not ItemTrackingCode.Get(Item."Item Tracking Code") then
                exit(false)
            else
                exit(ItemTrackingCode."SN Specific Tracking");
        end;
    end;
    //Procedimiento para poder partir las OP desde Hoja de planificación en base a las cantidades, interactua con cdu 50109
    procedure ManagePartitionOP(var ProductionOrder: Record "Production Order"; var RequisitionLine: Record "Requisition Line")
    var
        CantidadReparto: Decimal;
        iteracionBucle: Decimal;
        sobranteDecimal: Decimal;
        cantidadAsignar: Decimal;
        parteDecimal: text;

    begin
        Clear(CantidadReparto);
        CantidadReparto := RequisitionLine.Quantity - 1;

        RequisitionLine.Quantity := 1;
        RequisitionLine."Cost Amount" := RequisitionLine."Unit Cost";
        RequisitionLine.Modify(true);

        //Calculo cantidad a repartir en bucle por si llega 10,8 / 10,5 se prepara para dejar al último, no debería pasar 
        parteDecimal := FORMAT(ROUND(CantidadReparto) MOD 1 * 100);
        CantidadReparto := CantidadReparto DIV 1;
        EVALUATE(sobranteDecimal, '0,' + parteDecimal);

        For iteracionBucle := 1 TO CantidadReparto do begin
            Clear(cantidadAsignar);
            if iteracionBucle <> CantidadReparto then
                cantidadAsignar := 1
            else
                cantidadAsignar := 1 + sobranteDecimal;

            GenerarOP(cantidadAsignar, ProductionOrder, RequisitionLine);
        end;
    end;

    local procedure GenerarOP(Cantidad: Decimal; var ProductionOrder: Record "Production Order"; var RequisitionLine: Record "Requisition Line")
    var
        ProdOrder: Record "Production Order";
        Item: Record Item;
        CarryOutActions: Codeunit "Carry Out Action";
    begin
        Item.GET(RequisitionLine."No.");

        ProdOrder.INIT();
        ProdOrder.Status := ProductionOrder.Status;
        ProdOrder."No. Series" := ProdOrder.GetNoSeriesCode();
        ProdOrder."No." := '';
        ProdOrder.INSERT(TRUE);
        ProdOrder."Source Type" := ProdOrder."Source Type"::Item;
        ProdOrder."Source No." := RequisitionLine."No.";
        ProdOrder.VALIDATE(Description, RequisitionLine.Description);
        ProdOrder."Description 2" := RequisitionLine."Description 2";
        ProdOrder."Creation Date" := Today();
        ProdOrder."Last Date Modified" := Today();
        ProdOrder."Inventory Posting Group" := Item."Inventory Posting Group";
        ProdOrder."Gen. Prod. Posting Group" := RequisitionLine."Gen. Prod. Posting Group";
        ProdOrder."Gen. Bus. Posting Group" := RequisitionLine."Gen. Business Posting Group";
        ProdOrder."Due Date" := RequisitionLine."Due Date";
        ProdOrder."Starting Time" := RequisitionLine."Starting Time";
        ProdOrder."Starting Date" := RequisitionLine."Starting Date";
        ProdOrder."Ending Time" := RequisitionLine."Ending Time";
        ProdOrder."Ending Date" := RequisitionLine."Ending Date";
        ProdOrder."Location Code" := RequisitionLine."Location Code";
        ProdOrder."Bin Code" := RequisitionLine."Bin Code";
        ProdOrder."Low-Level Code" := RequisitionLine."Low-Level Code";
        ProdOrder."Routing No." := RequisitionLine."Routing No.";
        ProdOrder.Quantity := Cantidad;
        ProdOrder."Unit Cost" := RequisitionLine."Unit Cost";
        ProdOrder."Cost Amount" := RequisitionLine."Unit Cost" * Cantidad;
        ProdOrder."Shortcut Dimension 1 Code" := RequisitionLine."Shortcut Dimension 1 Code";
        ProdOrder."Shortcut Dimension 2 Code" := RequisitionLine."Shortcut Dimension 2 Code";
        ProdOrder."Dimension Set ID" := RequisitionLine."Dimension Set ID";
        ProdOrder.RefOrderNo_btc := RequisitionLine."Ref. Order No.";
        ProdOrder.UpdateDatetime();
        ProdOrder.Modify();

        Clear(CarryOutActions);
        CarryOutActions.InsertProdOrderLine(RequisitionLine, ProdOrder, Item);
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnAfterSupplyToInvProfile', '', false, false)]
    local procedure OnAfterSupplyToInvProfile(VAR InventoryProfile: Record "Inventory Profile"; VAR Item: Record Item; VAR ToDate: Date; VAR ReservEntry: Record "Reservation Entry"; VAR NextLineNo: Integer)
    begin
        InventoryProfile.reset;
        InventoryProfile.SetRange(IsSupply, true);
        InventoryProfile.ModifyAll("Due Date", 20010101D);
        InventoryProfile.ModifyAll("Starting Date", 20010101D);
        InventoryProfile.reset;
    end;

    //Al crear líneas de OP desde la hoja de planificación rellenar fecha incial
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Carry Out Action", 'OnInsertProdOrderLineWithReqLine', '', true, true)]
    local procedure CU_99000813_OnInsertProdOrderLineWithReqLine(var ProdOrderLine: Record "Prod. Order Line"; var RequisitionLine: Record "Requisition Line")
    begin
        ProdOrderLine.FechaInicial_btc := ProdOrderLine."Starting Date";
    end;

    //Copiar producto
    procedure CopiarProducto(pProductoOrigen: code[20]; pProductoDestino: Code[20]; pDescripcionNueva: Text[100]; pCrearListaMateriales: Boolean)
    var
        recItem: Record Item;
        recItem2: Record Item;
        ItemVariant: Record "Item Variant";
        ItemVariant2: Record "Item Variant";
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ItemUnitofMeasure2: Record "Item Unit of Measure";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributeValueMapping2: Record "Item Attribute Value Mapping";
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMHeader2: Record "Production BOM Header";
        ProductionBOMLine: Record "Production BOM Line";
        ProductionBOMLine2: Record "Production BOM Line";
        BOMComponent: Record "BOM Component";
        BOMComponent2: Record "BOM Component";
    begin
        recItem.GET(pProductoOrigen);

        recItem2.RESET();
        recItem2 := recItem;
        recItem2."No." := pProductoDestino;
        recItem2.Validate(Description, pDescripcionNueva);
        recItem2."Unit Cost" := 0;

        if not pCrearListaMateriales then
            recItem2.Validate("Production BOM No.", recItem."Production BOM No.");

        recItem2."Last Date Modified" := TODAY();
        recItem2.INSERT();

        // Variante
        ItemVariant.RESET();
        ItemVariant.SETRANGE("Item No.", recItem."No.");
        IF ItemVariant.FINDSET() THEN
            REPEAT
                ItemVariant2 := ItemVariant;
                ItemVariant2."Item No." := recItem2."No.";
                ItemVariant2.Description := recItem2.Description;
                ItemVariant2.INSERT();
            UNTIL ItemVariant.NEXT() = 0;

        // Unidades de Medida
        ItemUnitofMeasure.RESET();
        ItemUnitofMeasure.SETRANGE("Item No.", recItem."No.");
        IF ItemUnitofMeasure.FINDSET() THEN
            REPEAT
                ItemUnitofMeasure2 := ItemUnitofMeasure;
                ItemUnitofMeasure2."Item No." := recItem2."No.";
                ItemUnitofMeasure2.INSERT();
            UNTIL ItemUnitofMeasure.NEXT() = 0;

        // Atributos
        ItemAttributeValueMapping.RESET();
        ItemAttributeValueMapping.SETRANGE("No.", recItem."No.");
        IF ItemAttributeValueMapping.FINDSET() THEN
            REPEAT
                ItemAttributeValueMapping2 := ItemAttributeValueMapping;
                ItemAttributeValueMapping2."No." := recItem2."No.";
                ItemAttributeValueMapping2.INSERT();
            UNTIL ItemAttributeValueMapping.NEXT() = 0;

        // Composiciones
        BOMComponent.RESET();
        BOMComponent.SETRANGE("Parent Item No.", recItem."No.");
        IF BOMComponent.FINDSET() THEN
            REPEAT
                BOMComponent2 := BOMComponent;
                BOMComponent2."Parent Item No." := recItem2."No.";
                IF BOMComponent2.INSERT() THEN;
            UNTIL BOMComponent.NEXT() = 0;

        // Lista Materiales
        if pCrearListaMateriales then begin
            ProductionBOMHeader.RESET();
            ProductionBOMHeader.SETRANGE("No.", recItem."Production BOM No.");
            IF ProductionBOMHeader.FINDFIRST() THEN BEGIN
                ProductionBOMHeader2.INIT();
                ProductionBOMHeader2 := ProductionBOMHeader;
                ProductionBOMHeader2."No." := recItem2."No.";
                ProductionBOMHeader2.Description := recItem2.Description;
                IF ProductionBOMHeader2.INSERT() THEN;

                recItem2.Validate("Production BOM No.", recItem2."No.");

                ProductionBOMLine.RESET();
                ProductionBOMLine.SETRANGE("Production BOM No.", recItem."Production BOM No.");
                IF ProductionBOMLine.FINDSET() THEN
                    REPEAT
                        ProductionBOMLine2.INIT();
                        ProductionBOMLine2 := ProductionBOMLine;
                        ProductionBOMLine2."Production BOM No." := recItem2."No.";
                        ProductionBOMLine2.INSERT();
                    UNTIL ProductionBOMLine.NEXT() = 0;
            END;
        end;
    end;

    procedure CalcDisponble(StockkeepingUnit: record "Stockkeeping Unit"; var BalanceConOfertas: Decimal; var BalanceSinOfertas: decimal)
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        BalanceConOfertas := 0;
        BalanceSinOfertas := 0;
        StockkeepingUnit.SetFilter(Filter_FinOferta_Btc, '%1..', WorkDate());
        StockkeepingUnit.CalcFields(Inventory, "Qty. on Assembly Order", "Qty. on Prod. Order", "Qty. on Purch. Order",
            "Trans. Ord. Receipt (Qty.)", "Qty. on Asm. Component", "Qty. on Component Lines", "Qty. on Job Order", "Qty. on Sales Order",
            "Qty. on Service Order", "Trans. Ord. Shipment (Qty.)", QtyonQuotesOrder, "Cant_ componentes Oferta");
        //BalanceConOfertas := Inventory + "Qty. on Assembly Order" + "Qty. on Prod. Order" + "Qty. on Purch. Order" + "Trans. Ord. Receipt (Qty.)"
        //    - "Qty. on Asm. Component" - "Qty. on Component Lines" - "Qty. on Job Order" - "Qty. on Sales Order" - "Qty. on Service Order"
        //    - "Trans. Ord. Shipment (Qty.)" - QtyonQuotesOrder - "Cant_ componentes Oferta";
        //BalanceSinOfertas := Inventory + "Qty. on Assembly Order" + "Qty. on Prod. Order" + "Qty. on Purch. Order" + "Trans. Ord. Receipt (Qty.)"
        //    - "Qty. on Asm. Component" - "Qty. on Component Lines" - "Qt
        if InventorySetup.Inventory then begin
            BalanceConOfertas := StockkeepingUnit.Inventory;
            BalanceSinOfertas := StockkeepingUnit.Inventory;
        end;
        if InventorySetup."Qty. on Assembly Order" then begin
            BalanceConOfertas += StockkeepingUnit."Qty. on Assembly Order";
            BalanceSinOfertas += StockkeepingUnit."Qty. on Assembly Order";
        end;
        if InventorySetup."Qty. on Prod. Order" then begin
            BalanceConOfertas += StockkeepingUnit."Qty. on Prod. Order";
            BalanceSinOfertas += StockkeepingUnit."Qty. on Prod. Order";
        end;
        if InventorySetup."Qty. on Purch. Order" then begin
            BalanceConOfertas += StockkeepingUnit."Qty. on Purch. Order";
            BalanceSinOfertas += StockkeepingUnit."Qty. on Purch. Order";
        end;
        if InventorySetup."Trans. Ord. Receipt (Qty.)" then begin
            BalanceConOfertas += StockkeepingUnit."Trans. Ord. Receipt (Qty.)";
            BalanceSinOfertas += StockkeepingUnit."Trans. Ord. Receipt (Qty.)";
        end;
        if InventorySetup."Qty. on Asm. Component" then begin
            BalanceConOfertas -= StockkeepingUnit."Qty. on Asm. Component";
            BalanceSinOfertas -= StockkeepingUnit."Qty. on Asm. Component";
        end;
        if InventorySetup."Qty. on Component Lines" then begin
            BalanceConOfertas -= StockkeepingUnit."Qty. on Component Lines";
            BalanceSinOfertas -= StockkeepingUnit."Qty. on Component Lines";
        end;
        if InventorySetup."Qty. on Job Order" then begin
            BalanceConOfertas -= StockkeepingUnit."Qty. on Job Order";
            BalanceSinOfertas -= StockkeepingUnit."Qty. on Job Order";
        end;
        if InventorySetup."Qty. on Sales Order" then begin
            BalanceConOfertas -= StockkeepingUnit."Qty. on Sales Order";
            BalanceSinOfertas -= StockkeepingUnit."Qty. on Sales Order";
        end;
        if InventorySetup."Qty. on Service Order" then begin
            BalanceConOfertas -= StockkeepingUnit."Qty. on Service Order";
            BalanceSinOfertas -= StockkeepingUnit."Qty. on Service Order";
        end;
        if InventorySetup."Trans. Ord. Shipment (Qty.)" then begin
            BalanceConOfertas -= StockkeepingUnit."Trans. Ord. Shipment (Qty.)";
            BalanceSinOfertas -= StockkeepingUnit."Trans. Ord. Shipment (Qty.)";
        end;
        if InventorySetup."Qty. on Sales Quote" then begin
            BalanceConOfertas -= StockkeepingUnit.QtyonQuotesOrder;
        end;
        if InventorySetup."Qty. on Component Quote" then begin

            BalanceConOfertas -= StockkeepingUnit."Cant_ componentes Oferta";
        end;



    end;
}