codeunit 50108 "FuncionesFabricacion"
{

    var
        aReqExcelBuffer: Record "Excel Buffer";

        lblConfirmExcel: Label '¿Desea exportar los resultado en Excel?', comment = 'ESP="¿Desea exportar los resultado en Excel?"';

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

    // ZM JJV 21/10/22 para poder exportar excel enla planficacion desde pedido
    // es el final de la ultima carga de demand/supply antes de calcular, 
    // [EventSubscriber(ObjectType::Codeunit, codeunit::"Inventory Profile Offsetting", 'OnAfterSupplyToInvProfile', '', true, true)]
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Inventory Profile Offsetting", 'OnBeforeCommonBalancing', '', true, true)]
    local procedure codeunitInventoryProfileOffsetting_OnBeforeCommonBalancing(var TempSKU: Record "Stockkeeping Unit"; var SupplyInvtProfile: Record "Inventory Profile"; var DemandInvtProfile: Record "Inventory Profile"; ToDate: Date)
    var
        RequisitionBuffer: record "ZM Requesition Buffer Calc.";
    begin
        // el evento esta MAL, los nombres los han cambiado
        RequisitionBuffer.Reset();
        RequisitionBuffer.SetRange("Session ID", RequisitionBuffer.GetActiveSession());
        if not RequisitionBuffer.FindFirst() then
            exit;

        AddLastReqExcelBuffer(TempSKU, DemandInvtProfile, SupplyInvtProfile, RequisitionBuffer."Worksheet Template Name", RequisitionBuffer."Journal Batch Name");  // CUIDADO, estan cambiado
    end;

    local procedure AddLastReqExcelBuffer(var TempSKU: Record "Stockkeeping Unit"; var SupplyInventoryProfile: Record "Inventory Profile";
        var DemandInventoryProfile: Record "Inventory Profile"; WorksheetTemplateName: code[10]; JournalBatchName: code[10])
    var
        Item: Record Item;
        Vendor: Record Vendor;
        RequisitionBuffer: record "ZM Requesition Buffer Calc.";
        i: Integer;
    begin
        DemandInventoryProfile.SetRange("Due Date");
        Item.Get(TempSKU."Item No.");
        RequisitionBuffer.SetRange("Worksheet Template Name", WorksheetTemplateName);
        RequisitionBuffer.SetRange("Journal Batch Name", JournalBatchName);
        RequisitionBuffer.SetRange("Item No.", TempSKU."Item No.");
        if not RequisitionBuffer.FindFirst() then begin
            RequisitionBuffer.Init();
            RequisitionBuffer."Session ID" := RequisitionBuffer.GetActiveSession();
            RequisitionBuffer."Worksheet Template Name" := WorksheetTemplateName;
            RequisitionBuffer."Journal Batch Name" := JournalBatchName;
            RequisitionBuffer."Item No." := Item."No.";
            RequisitionBuffer.Description := Item.Description;
            RequisitionBuffer."Cantidad Pedir" := 0;
            if TempSKU.FindFirst() then begin
                RequisitionBuffer."Stock de seguridad" := TempSKU."Safety Stock Quantity";
                RequisitionBuffer."Cantidad mínima pedido" := TempSKU."Minimum Order Quantity";
            end else begin
                RequisitionBuffer."Stock de seguridad" := Item."Safety Stock Quantity";
                RequisitionBuffer."Cantidad mínima pedido" := Item."Order Multiple";
            end;
            for i := 1 to 8 do begin
                if DemandInventoryProfile.findset() then
                    repeat
                        case i of
                            // DEMAND
                            1:  // Sales Line (37)
                                if DemandInventoryProfile."Source Type" = Database::"Sales Line" then
                                    RequisitionBuffer."Lín. venta" += DemandInventoryProfile."Remaining Quantity";
                            2:  // Service Line (5902)
                                if DemandInventoryProfile."Source Type" = Database::"Service Line" then
                                    RequisitionBuffer."Línea servicio" += SupplyInventoryProfile."Remaining Quantity";
                            3:  // Job Planning line (1003)
                                if DemandInventoryProfile."Source Type" = Database::"Job Planning Line" then
                                    RequisitionBuffer."Línea planificación proyecto" += DemandInventoryProfile."Remaining Quantity";
                            4:  // Prod Order Component (5407)
                                if DemandInventoryProfile."Source Type" = Database::"Prod. Order Component" then
                                    RequisitionBuffer."Componente orden producción" += DemandInventoryProfile."Remaining Quantity";
                            5:  // Asembly  Line (901)                            
                                if DemandInventoryProfile."Source Type" = Database::"Assembly Line" then
                                    RequisitionBuffer."Demanda Línea de ensamblado" += DemandInventoryProfile."Remaining Quantity";
                            6:  // Planning Component Line (99000829)                            
                                if DemandInventoryProfile."Source Type" = Database::"Planning Component" then
                                    RequisitionBuffer."Planif. componente" += DemandInventoryProfile."Remaining Quantity";
                            7:  // Trans Requisition Line (246)                            
                                if DemandInventoryProfile."Source Type" = Database::"Requisition Line" then
                                    RequisitionBuffer."Demanda Lín. hoja demanda" += DemandInventoryProfile."Remaining Quantity";
                            8:  // shipment Transfer Line (5741)                            
                                if DemandInventoryProfile."Source Type" = Database::"Transfer Line" then
                                    RequisitionBuffer."Demanda Lín. transferencia" += DemandInventoryProfile."Remaining Quantity";
                        end;
                    Until DemandInventoryProfile.next() = 0;
            end;
            for i := 1 to 7 do begin
                if SupplyInventoryProfile.findset() then
                    repeat
                        // SUPPLY
                        case i of
                            1:  // Item Ledger Entry (32)
                                if SupplyInventoryProfile."Source Type" = Database::"Item Ledger Entry" then
                                    RequisitionBuffer.Inventario += SupplyInventoryProfile."Remaining Quantity";
                            2:  // Requisition line (246)
                                if SupplyInventoryProfile."Source Type" = Database::"Requisition Line" then
                                    RequisitionBuffer."Aprov. Lín. hoja demanda" += SupplyInventoryProfile."Remaining Quantity";
                            3:  // Purchase line (39)
                                if SupplyInventoryProfile."Source Type" = Database::"Purchase Line" then
                                    RequisitionBuffer."Lín. compra" += SupplyInventoryProfile."Remaining Quantity";
                            4:  // Prod Order line (39)
                                if SupplyInventoryProfile."Source Type" = Database::"Prod. Order Line" then
                                    RequisitionBuffer."Lín. orden prod." += SupplyInventoryProfile."Remaining Quantity";
                            5:  // Assembly line (901)
                                if SupplyInventoryProfile."Source Type" = Database::"Assembly Line" then
                                    RequisitionBuffer."Aprov. Línea de ensamblado" += SupplyInventoryProfile."Remaining Quantity";
                            6:  // receipt Transfer line (5741)
                                if SupplyInventoryProfile."Source Type" = Database::"Transfer Line" then
                                    RequisitionBuffer."Aprov. Lín. transferencia" += SupplyInventoryProfile."Remaining Quantity";
                            7:  //safety Stock                            
                                if SupplyInventoryProfile."Source Type" = 0 then
                                    RequisitionBuffer."Cantidad para stock" += SupplyInventoryProfile."Remaining Quantity";
                        end;
                    Until SupplyInventoryProfile.next() = 0;
            end;
            RequisitionBuffer."Cód. proveedor" := Item."Vendor No.";
            if vendor.get(Item."Vendor No.") then;
            RequisitionBuffer."Nombre proveedor" := Vendor.Name;
            RequisitionBuffer."Plazo de entrega" := Item."Lead Time Calculation";
            RequisitionBuffer.Insert();


        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure RequisitionLine_OnAfterInsertEvent(var Rec: Record "Requisition Line"; RunTrigger: Boolean)
    begin
        RequisitionLine_UpdateQuantity(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Requisition Line", 'OnAfterModifyEvent', '', true, true)]
    local procedure RequisitionLine_OnAfterModifyEvent(var Rec: Record "Requisition Line"; RunTrigger: Boolean)
    begin
        RequisitionLine_UpdateQuantity(Rec);
    end;

    local procedure RequisitionLine_UpdateQuantity(var Rec: Record "Requisition Line")
    var
        RequisitionBuffer: record "ZM Requesition Buffer Calc.";
    begin
        if GetRequisitionBufferExist(Rec."Worksheet Template Name", Rec."Journal Batch Name") then begin
            RequisitionBuffer.Reset();
            RequisitionBuffer.SetRange("Session ID", RequisitionBuffer.GetActiveSession());
            RequisitionBuffer.SetRange("Worksheet Template Name", Rec."Worksheet Template Name");
            RequisitionBuffer.SetRange("Journal Batch Name", Rec."Journal Batch Name");
            RequisitionBuffer.SetRange("Item No.", Rec."No.");
            if not RequisitionBuffer.FindFirst() then begin
                RequisitionBuffer."Cantidad Pedir" += Rec.Quantity;

            end;
        end;
    end;


    [EventSubscriber(ObjectType::Report, Report::"Calculate Plan - Req. Wksh.", 'OnAfterSkipPlanningForItemOnReqWksh', '', true, true)]
    local procedure CalculatePlanReqWksh_OnAfterSkipPlanningForItemOnReqWksh(Item: Record Item; var SkipPlanning: Boolean)
    var
        RequisitionBuffer: record "ZM Requesition Buffer Calc.";
        RequisitionBuffer2: record "ZM Requesition Buffer Calc.";
        nLinea: Integer;
    begin
        if SkipPlanning then begin
            RequisitionBuffer.Reset();
            RequisitionBuffer.SetRange("Session ID", RequisitionBuffer.GetActiveSession());
            if not RequisitionBuffer.FindFirst() then
                exit;
            RequisitionBuffer2.SetRange("Session ID", RequisitionBuffer.GetActiveSession());
            RequisitionBuffer2.SetRange("Worksheet Template Name", RequisitionBuffer."Worksheet Template Name");
            RequisitionBuffer2.SetRange("Journal Batch Name", RequisitionBuffer."Journal Batch Name");
            RequisitionBuffer2.SetRange("Item No.", Item."No.");
            if not RequisitionBuffer2.FindFirst() then begin
                RequisitionBuffer2.Init();
                RequisitionBuffer2."Session ID" := RequisitionBuffer."Session ID";
                RequisitionBuffer2."Worksheet Template Name" := RequisitionBuffer."Worksheet Template Name";
                RequisitionBuffer2."Journal Batch Name" := RequisitionBuffer."Journal Batch Name";
                RequisitionBuffer2."Item No." := Item."No.";
                RequisitionBuffer2.Description := item.Description;
                RequisitionBuffer2."Cantidad Pedir" := -1;
                RequisitionBuffer2.Insert();
            end;
        end;
    end;

    // =============     ReqWorksheet OnBeforeActionEvent_CalculatePlan MRP  HOJa demanda       ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    [EventSubscriber(ObjectType::Page, Page::"Req. Worksheet", 'OnBeforeActionEvent', 'CalculatePlan', true, true)]
    local procedure ReqWorksheet_OnBeforeActionEvent_CalculatePlan(var Rec: Record "Requisition Line")
    var
        InventorySetup: Record "Inventory Setup";
    begin
        if Confirm(lblConfirmExcel) then begin
            InitReqExcelBuffer(Rec."Worksheet Template Name", Rec."Journal Batch Name");
        end;

        commit;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Req. Worksheet", 'OnAfterActionEvent', 'CalculatePlan', true, true)]
    local procedure ReqWorksheet_OnAfterActionEvent_CalculatePlan(var Rec: Record "Requisition Line")
    var
        InventorySetup: Record "Inventory Setup";
    begin
        if GetRequisitionBufferExist(Rec."Worksheet Template Name", Rec."Journal Batch Name") then begin
            ReqWorksheet_CalculatePlanFinish(Rec);
        end;

    end;

    // =============     ReqWorksheet OnBeforeActionEvent_CalculatePlan MPS Hoja planificacion         ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    [EventSubscriber(ObjectType::Page, Page::"Planning Worksheet", 'OnBeforeActionEvent', 'CalculateRegenerativePlan', true, true)]
    local procedure ReqWorksheet_OnBeforeActionEvent_CalculateRegenerativePlan(var Rec: Record "Requisition Line")
    var
        InventorySetup: Record "Inventory Setup";
    begin
        if GetRequisitionBufferExist(Rec."Worksheet Template Name", Rec."Journal Batch Name") then begin
            if Confirm(lblConfirmExcel) then begin
                InitReqExcelBuffer(Rec."Worksheet Template Name", rec."Journal Batch Name");
            end;
        end;

        commit;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Planning Worksheet", 'OnAfterActionEvent', 'CalculateRegenerativePlan', true, true)]
    local procedure ReqWorksheet_OnAfterActionEvent_CalculateRegenerativePlan(var Rec: Record "Requisition Line")
    var
        InventorySetup: Record "Inventory Setup";
    begin
        if GetRequisitionBufferExist(Rec."Worksheet Template Name", Rec."Journal Batch Name") then begin
            ReqWorksheet_CalculatePlanFinish(Rec);
        end;

    end;

    local procedure ReqWorksheet_CalculatePlanFinish(Rec: Record "Requisition Line")
    begin
        ExportRequisitionBuffer(Rec."Worksheet Template Name", Rec."Journal Batch Name", Rec."Worksheet Template Name");

        DeleteRequisitionBuffer(Rec."Worksheet Template Name", rec."Journal Batch Name");
    end;

    // =============     LanzarPlanificacionDesdePedidos          ====================
    // ==  
    // ==  lanza los procesos de MRP sobre las lineas de un pedido de venta y sus subconjuntos 
    // ==  
    // ======================================================================================================
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
        InventorySetup: Record "Inventory Setup";
        SalesHeaderDocNo: text;
        LastLine: Integer;
    begin
        Item.reset;
        if Item.FindSet() then begin
            repeat
                if (Item.Ordenacion_btc <> 0) OR (item.STHUseLocationGroup) then begin
                    Item.Ordenacion_btc := 0;
                    item.STHUseLocationGroup := false;
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
        if PSalesHeader.RunModal() <> Action::LookupOK then
            exit;

        SalesHeader.reset;
        PSalesHeader.GetResult(SalesHeader);
        if SalesHeader.FindSet() then begin
            repeat
                if SalesHeaderDocNo <> '' then
                    SalesHeaderDocNo += '|';
                SalesHeaderDocNo += SalesHeader."No.";
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
                        AddItemtempPlanifpedido(Item);

                    until SalesLine.Next() = 0;
                end;
            until SalesHeader.Next() = 0;

        end;

        if Confirm(lblConfirmExcel) then begin
            InitReqExcelBuffer(RequisitionWkshName.Name, 'PLANIF.');
        end;


        commit;

        ItemPedido.SetRange("No.");
        ItemPedido.SetRange("Location Filter", 'MMPP');
        ItemPedido.SetRange("Replenishment System", ItemCompra."Replenishment System"::"Prod. Order");
        ItemPedido.SetRange(Ordenacion_btc, 1);
        ItemPedido.SetRange(Blocked, false);
        clear(CalcPlan);
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
        //ItemCompra.SetRange("No.", 'SM40CN');
        clear(CalcPlan);
        CalculatePlan.SetTableView(ItemCompra);
        CalculatePlan.SetTemplAndWorksheet('APROV.', RequisitionWkshName."Name");
        CalculatePlan.UseRequestPage(false);
        CalculatePlan.InitializeRequest(today - 60, TODAY + 60);
        CalculatePlan.RUNMODAL;
        CLEAR(CalculatePlan);

        RefrescarHoja('PLANIF.', RequisitionWkshName."Name");
        RefrescarHoja('APROV.', RequisitionWkshName."Name");

        if GetRequisitionBufferExist(RequisitionWkshName.Name, 'PLANIF.') then begin
            ExportRequisitionBuffer(RequisitionWkshName.Name, 'PLANIF.', SalesHeader."No.");

            DeleteRequisitionBuffer(RequisitionWkshName.Name, 'PLANIF.');
        end;
    end;

    local procedure ExportRequisitionBuffer(WorksheetTemplateName: code[10]; JournalBatchName: code[10]; SalesHeaderDocNo: code[20])
    var
        RequisitionBuffer: record "ZM Requesition Buffer Calc.";
        reqExcelBuffer: Record "Excel Buffer" temporary;
    begin
        RequisitionBuffer.Reset();
        RequisitionBuffer.SetRange("Session ID", RequisitionBuffer.GetActiveSession());
        RequisitionBuffer.SetRange("Worksheet Template Name", WorksheetTemplateName);
        RequisitionBuffer.SetRange("Journal Batch Name", JournalBatchName);
        if RequisitionBuffer.FindFirst() then
            repeat

                CreateRequisitionBufferExcel(RequisitionBuffer, reqExcelBuffer, SalesHeaderDocNo);


                reqExcelBuffer.CreateNewBook('Planificacion');

                reqExcelBuffer.WriteSheet('Planif. ', COMPANYNAME, USERID);
                reqExcelBuffer.CloseBook();
                ReqExcelBuffer.SetFriendlyFilename('Planificación ' + WorksheetTemplateName);
                ReqExcelBuffer.DownloadAndOpenExcel;
            Until RequisitionBuffer.next() = 0;

    end;

    local procedure CreateRequisitionBufferExcel(var RequisitionBuffer: record "ZM Requesition Buffer Calc."; var reqExcelBuffer: Record "Excel Buffer"; SalesHeaderDocNo: code[20])
    begin
        CreateHeaderRequisitionBufferExcel(reqExcelBuffer, SalesHeaderDocNo);

        CreateBodyRequisitionBufferExcel(RequisitionBuffer, reqExcelBuffer, SalesHeaderDocNo);
    end;

    local procedure CreateHeaderRequisitionBufferExcel(var reqExcelBuffer: Record "Excel Buffer"; SalesHeaderDocNo: code[20])
    var
        Item: Record Item;
        RecRef: RecordRef;
    begin
        ReqExcelBuffer.AddColumn(CompanyName, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.NewRow();
        ReqExcelBuffer.AddColumn('Pedidos:', false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.AddColumn(SalesHeaderDocNo, false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.NewRow();
        ReqExcelBuffer.NewRow();
        ReqExcelBuffer.EnterCell(ReqExcelBuffer, 4, 6, 'Demandas', true, true, false);
        ReqExcelBuffer.EnterCell(ReqExcelBuffer, 4, 14, 'Aprovisionamientos', true, true, false);
        ReqExcelBuffer.NewRow();

        ReqExcelBuffer.AddColumn(Item.FieldCaption("No."), false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.AddColumn(Item.FieldCaption(Description), false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.AddColumn('Cantidad Pedir', false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.AddColumn(Item.FieldCaption("Safety Stock Quantity"), false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.AddColumn(Item.FieldCaption("Minimum Order Quantity"), false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        // DEMAND
        RecRef.Open(Database::"Sales Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Service Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Job Planning Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Prod. Order Component");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Assembly Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Planning Component");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Requisition Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Transfer Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        // SUPPLY
        RecRef.Open(Database::"Item ledger Entry");
        ReqExcelBuffer.AddColumn('Inventario', false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Requisition Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Purchase Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Prod. Order Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Assembly Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        RecRef.Open(Database::"Transfer Line");
        ReqExcelBuffer.AddColumn(RecRef.Caption, false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        RecRef.Close();
        ReqExcelBuffer.AddColumn('Cantidad para stock', false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);

        ReqExcelBuffer.AddColumn('Cód. proveedor', false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.AddColumn('Nombre proveedor', false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);
        ReqExcelBuffer.AddColumn('Plazo de entrega', false, '', true, false, false, '', ReqExcelBuffer."Cell Type"::Text);

        ReqExcelBuffer.NewRow();
    end;

    local procedure CreateBodyRequisitionBufferExcel(var RequisitionBuffer: record "ZM Requesition Buffer Calc."; var reqExcelBuffer: Record "Excel Buffer"; SalesHeaderDocNo: code[20])
    var
        Item: Record Item;
        Vendor: Record Vendor;
        TempSKU: Record "Stockkeeping Unit";
        i: Integer;
    begin
        if RequisitionBuffer.FindFirst() then
            repeat
                Item.Get(RequisitionBuffer."Item No.");
                ReqExcelBuffer.AddColumn(Item."No.", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Text);
                ReqExcelBuffer.AddColumn(Item.Description, false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Text);
                ReqExcelBuffer.AddColumn(0, false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                TempSKU.SetRange("Location Code", RequisitionBuffer."location Code");
                TempSKU.SetRange("Item No.", RequisitionBuffer."Item No.");
                if TempSKU.FindFirst() then begin
                    ReqExcelBuffer.AddColumn(TempSKU."Safety Stock Quantity", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                    ReqExcelBuffer.AddColumn(TempSKU."Minimum Order Quantity", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                end else begin
                    ReqExcelBuffer.AddColumn(Item."Safety Stock Quantity", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                    ReqExcelBuffer.AddColumn(Item."Order Multiple", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                end;
                // DEMANDS
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Lín. venta", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Línea servicio", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Línea planificación proyecto", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Componente orden producción", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Demanda Línea de ensamblado", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Planif. componente", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Demanda Lín. hoja demanda", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Demanda Lín. transferencia", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                // SUPPLIES
                ReqExcelBuffer.AddColumn(RequisitionBuffer.Inventario, false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Aprov. Lín. hoja demanda", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Lín. compra", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Lín. orden prod.", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Aprov. Línea de ensamblado", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Aprov. Lín. transferencia", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);
                ReqExcelBuffer.AddColumn(RequisitionBuffer."Cantidad para stock", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Number);

                ReqExcelBuffer.AddColumn(Item."Vendor No.", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Text);
                if Vendor.get(Item."Vendor No.") then;
                ReqExcelBuffer.AddColumn(Vendor.Name, false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Text);
                ReqExcelBuffer.AddColumn(Item."Lead Time Calculation", false, '', false, false, false, '', ReqExcelBuffer."Cell Type"::Text);

                ReqExcelBuffer.NewRow();

            Until RequisitionBuffer.next() = 0;
    end;

    local procedure InitReqExcelBuffer(WorksheetTemplateName: code[10]; JournalBatchName: code[10])
    var
        RequisitionBuffer: record "ZM Requesition Buffer Calc.";
    begin

        RequisitionBuffer.Reset();
        RequisitionBuffer.SetRange("Session ID", RequisitionBuffer.GetActiveSession());
        RequisitionBuffer.SetRange("Worksheet Template Name", WorksheetTemplateName);
        RequisitionBuffer.SetRange("Journal Batch Name", JournalBatchName);
        RequisitionBuffer.DeleteAll();

        RequisitionBuffer.Init();
        UpdateRequisitionBufferHeader(RequisitionBuffer, WorksheetTemplateName, JournalBatchName);
        RequisitionBuffer."Item No." := '';
        RequisitionBuffer.Insert();
    end;

    local procedure UpdateRequisitionBufferHeader(var RequisitionBuffer: record "ZM Requesition Buffer Calc."; WorksheetTemplateName: code[10]; JournalBatchName: code[10])
    var
        myInt: Integer;
    begin
        RequisitionBuffer."Session ID" := RequisitionBuffer.GetActiveSession();
        RequisitionBuffer."Worksheet Template Name" := WorksheetTemplateName;
        RequisitionBuffer."Journal Batch Name" := JournalBatchName;
    end;

    local procedure GetRequisitionBufferExist(WorksheetTemplateName: code[10]; JournalBatchName: code[10]): Boolean
    var
        RequisitionBuffer: record "ZM Requesition Buffer Calc.";
    begin
        RequisitionBuffer.Reset();
        RequisitionBuffer.SetRange("Session ID", RequisitionBuffer.GetActiveSession());
        RequisitionBuffer.SetRange("Worksheet Template Name", WorksheetTemplateName);
        RequisitionBuffer.SetRange("Journal Batch Name", JournalBatchName);
        if RequisitionBuffer.FindFirst() then
            exit(true);
    end;

    local procedure DeleteRequisitionBuffer(WorksheetTemplateName: code[10]; JournalBatchName: code[10]): Boolean
    var
        RequisitionBuffer: record "ZM Requesition Buffer Calc.";
    begin
        RequisitionBuffer.Reset();
        RequisitionBuffer.SetRange("Session ID", RequisitionBuffer.GetActiveSession());
        RequisitionBuffer.SetRange("Worksheet Template Name", WorksheetTemplateName);
        RequisitionBuffer.SetRange("Journal Batch Name", JournalBatchName);
        RequisitionBuffer.DeleteAll();

    end;

    local procedure AddItemtempPlanifpedido(Item: record Item)
    var
        ItemCompra: Record item;
        ItemPedido: Record item;
        BomComponent: Record "BOM Component";
        ProductionBomLine: Record "Production BOM Line";
        ProductionBomLine2: record "Production BOM Line";
    begin
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
                        AddItemtempPlanifpedido(ItemPedido);  // recursivo
                        ProductionBomLine.reset;
                        ProductionBomLine.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                        if ProductionBomLine.FindSet() then begin
                            repeat
                                ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                ItemPedido.FindFirst();
                                if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                    ItemPedido.Ordenacion_btc := 1;
                                    ItemPedido.modify();
                                    //Quitado Recursivo  AddItemtempPlanifpedido(ItemPedido);  // recursivo
                                    ProductionBomLine2.reset;
                                    ProductionBomLine2.SetRange("Production BOM No.", ItemPedido."Production BOM No.");
                                    if ProductionBomLine2.FindSet() then begin
                                        repeat
                                            ItemPedido.SetRange("No.", ProductionBomLine."No.");
                                            ItemPedido.FindFirst();
                                            if ItemPedido."Replenishment System" = ItemPedido."Replenishment System"::"Prod. Order" then begin
                                                ItemPedido.Ordenacion_btc := 1;
                                                ItemPedido.modify();
                                                //Quitado Recursivo AddItemtempPlanifpedido(ItemPedido);  // recursivo
                                            end else begin
                                                ItemCompra.SetRange("No.", ProductionBomLine."No.");
                                                ItemCompra.FindFirst();
                                                ItemCompra.Ordenacion_btc := 1;
                                                ItemCompra.Modify();
                                                //Quitado Recursivo AddItemtempPlanifpedido(ItemCompra);  // recursivo
                                            end;
                                        until ProductionBomLine2.Next() = 0;
                                    end;
                                end else begin

                                    ItemCompra.SetRange("No.", ProductionBomLine."No.");
                                    ItemCompra.FindFirst();
                                    ItemCompra.Ordenacion_btc := 1;
                                    ItemCompra.Modify();
                                    //Quitado Recursivo AddItemtempPlanifpedido(ItemCompra);  // recursivo
                                end;
                            until ProductionBomLine.Next() = 0;

                        end;

                    end else begin
                        ItemCompra.SetRange("No.", BomComponent."No.");
                        ItemCompra.FindFirst();
                        ItemCompra.Ordenacion_btc := 1;
                        ItemCompra.Modify();
                        //Quitado Recursivo AddItemtempPlanifpedido(ItemCompra);  // recursivo
                    end;
                until BomComponent.Next() = 0;
            end;
        end else begin
            //ItemPedido.reset;
            ItemPedido.SetRange("No.", Item."No.");
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
                            //Quitado Recursivo AddItemtempPlanifpedido(ItemPedido);  // recursivo
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
                                        //Quitado Recursivo AddItemtempPlanifpedido(ItemPedido);  // recursivo
                                    end else begin
                                        ItemCompra.SetRange("No.", ProductionBomLine2."No.");
                                        ItemCompra.FindFirst();
                                        ItemCompra.Ordenacion_btc := 1;
                                        ItemCompra.modify();
                                        //Quitado Recursivo AddItemtempPlanifpedido(ItemPedido);  // recursivo
                                    end;
                                until ProductionBomLine2.Next() = 0;
                            end;
                        end else begin
                            ItemCompra.SetRange("No.", ProductionBomLine."No.");
                            ItemCompra.FindFirst();
                            ItemCompra.Ordenacion_btc := 1;
                            ItemCompra.modify();
                            //Quitado Recursivo AddItemtempPlanifpedido(ItemCompra);  // recursivo
                        end;
                    until ProductionBomLine.Next() = 0;

                end;

            end else begin
                ItemCompra.SetRange("No.", Item."No.");
                ItemCompra.FindFirst();
                ItemCompra.Ordenacion_btc := 1;
                ItemCompra.modify();
                //Quitado Recursivo AddItemtempPlanifpedido(ItemCompra);  // recursivo
            end;
        end;

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
            ProductionBOMHeader.SETRANGE("Version Nos.", '');
            IF ProductionBOMHeader.FINDFIRST() THEN BEGIN
                ProductionBOMHeader2.INIT();
                ProductionBOMHeader2 := ProductionBOMHeader;
                ProductionBOMHeader2."No." := recItem2."No.";
                ProductionBOMHeader2.Description := recItem2.Description;
                IF ProductionBOMHeader2.INSERT() THEN;

                recItem2.Validate("Production BOM No.", recItem2."No.");

                ProductionBOMLine.RESET();
                ProductionBOMLine.SETRANGE("Production BOM No.", recItem."Production BOM No.");
                ProductionBOMLine.SETRANGE("Version Code", '');
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

    // =============     Crear lista Materiales Producción de filtro de productos (BI)          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    procedure BuildWhereUsedFromItem(var Item: record Item; var WhereUsedList: record "Where-Used Line"; Init: Boolean)
    var
        BOMComponentHeader: Record "Production BOM Header";
        Window: Dialog;
        Level: Integer;
        NextEntryNo: Integer;
        lblWindows: Label 'Item: #1################', comment = 'ESP="Producto: #1################"';
    begin
        if Init then
            WhereUsedList.DeleteAll();

        WhereUsedList.Reset();
        if WhereUsedList.FindLast() then
            NextEntryNo := WhereUsedList."Entry No."
        else
            NextEntryNo := 1;
        Window.Open(lblWindows);

        if Item.findset() then
            repeat
                if Item."Replenishment System" in [Item."Replenishment System"::"Prod. Order"] then begin
                    Window.Update(1, item."No.");
                    if BOMComponentHeader.Get(Item."Production BOM No.") and (BOMComponentHeader.Status in [BOMComponentHeader.Status::Certified]) then begin
                        BuildWhereUsedListBom(WhereUsedList, Item, BOMComponentHeader, Level, NextEntryNo);

                    end;
                end;
            until Item.next() = 0;


        Window.Close();
        WhereUsedList.Reset();
        if WhereUsedList.FindSet() then;
    end;

    local procedure BuildWhereUsedListBom(var WhereUsedList: record "Where-Used Line"; ParentItem: record Item; BOMComponentHeader: Record "Production BOM Header"; Level: Integer; var NextEntryNo: Integer)
    var
        Item: Record Item;
        BomItem: Record Item;
        BOMComponentHeader2: Record "Production BOM Header";
        BOMComponentLine: Record "Production BOM Line";
        NotAddItem: Boolean;
    begin
        Level += 1;
        BOMComponentLine.Reset();
        BOMComponentLine.SetRange("Production BOM No.", BOMComponentHeader."No.");
        BOMComponentLine.SetRange("Version Code", '');
        BOMComponentLine.SetRange(Type, BOMComponentLine.Type::Item);
        if BOMComponentLine.findset() then
            repeat
                NotAddItem := false;
                if BomItem.Get(BOMComponentLine."No.") then begin
                    if BomItem."Replenishment System" in [BomItem."Replenishment System"::"Prod. Order"] then begin
                        if BOMComponentHeader2.Get(BomItem."Production BOM No.") and (BOMComponentHeader.Status in [BOMComponentHeader.Status::Certified]) then begin
                            BuildWhereUsedListBom(WhereUsedList, ParentItem, BOMComponentHeader2, Level, NextEntryNo);
                            NotAddItem := true;
                        end;
                    end;
                    if not NotAddItem then begin
                        WhereUsedList.Init();
                        NextEntryNo += 1;
                        WhereUsedList."Entry No." := NextEntryNo;
                        WhereUsedList."Production BOM No." := BOMComponentLine."Production BOM No.";
                        WhereUsedList."Item No." := BOMComponentLine."No.";
                        WhereUsedList.Description := BOMComponentLine.Description;
                        WhereUsedList."Level Code" := Level;
                        WhereUsedList."Quantity Needed" := BOMComponentLine."Quantity per";
                        // Parent 
                        WhereUsedList."Parent Item No." := ParentItem."No.";
                        WhereUsedList."Description Parent" := ParentItem.Description;
                        WhereUsedList."Parent Blocked" := ParentItem.Blocked;
                        WhereUsedList.Insert()
                    end;

                end;

            until BOMComponentLine.next() = 0;
    end;

}