pageextension 50131 "PlanningWorksheet" extends "Planning Worksheet"
{
    layout
    {
        addafter("Replenishment System")
        {
            field(GlobStock_btc; GlobStock_btc)
            {
                Caption = 'Inventario', comment = 'ESP="Inventario"';
                ApplicationArea = All;
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowglobalStock;
                end;
            }

            field(CantDis; globDecCantDisponible)
            {
                Caption = 'Qty Available', comment = 'ESP="Cantidad disponible"';
                ApplicationArea = All;
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowglobalDecLotSize(4);
                end;
            }

            field(StockSeguridad_btc; globalDecStockSeguridad)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Safety Stock', comment = 'ESP="Stock Seguridad"';
            }
            field(globalCantidadEncurso; globalCantidadEncurso)
            {
                Caption = 'Recepciones programadas';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowglobalDecLotSize(2);
                end;
            }
            field(globalDecLotSize; globalDecLotSize)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Necesidades', comment = 'ESP="Cantidad Comprometida"';

                trigger OnDrillDown()
                begin
                    ShowglobalDecLotSize(0);
                end;
            }

            field(PlazoDias_btc; globalPlazoDias)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Lead Time Calculation', comment = 'ESP="Plazo entrega días"';
            }

            field(MultiplosPedido_btc; globalDecMultiplosPedido)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Order Multiple', comment = 'ESP="Múltiplos de pedido"';
            }

            field(CantidadMinimaPedido_btc; globalDecCantMinPedido)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Minumun Order Quantity', comment = 'ESP="Cantidad mínima pedido"';
            }



            field(globalOfertas; globalOfertas)
            {
                Caption = 'Cantidad Ofertas';
                Editable = false;
            }


            field(globalContraStock; globalContraStock)
            {
                Caption = 'ContraStock/ BajoPedido';
                Editable = false;
            }
            field(globalPedidoMaximo; globalPedidoMaximo)
            {
                Caption = 'Pedido Maximo';
                Editable = false;
            }
            field(Estado; Estado)
            {
                ApplicationArea = all;
                Editable = false;
            }

        }

        addlast(FactBoxes)
        {
            part(ComentProd; FactboxComments)
            {
                ApplicationArea = All;
                SubPageLink = "Table Name" = const(Item), "No." = field("No.");
            }
        }
    }

    actions
    {
        addafter(OrderTracking)
        {
            action(DesmarcarAceptarMensaje)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ReopenCancelled;
                Caption = 'Remove Accept Message', comment = 'ESP="Quitar Aceptar mensaje"';
                ToolTip = 'Remove the Accept Action message to the selected lines',
                    comment = 'ESP="Quita la marca de Aceptar Mensaje de acción a las líneas seleccionadas"';

                trigger OnAction()
                var
                    recReqLine: Record "Requisition Line";
                begin
                    CurrPage.SetSelectionFilter(recReqLine);

                    recReqLine.ModifyAll("Accept Action Message", false);
                end;
            }
            action(CalcularPedido)
            {
                Description = 'Calcular Pedidos';
                trigger OnAction()
                VAR
                    RutinasFab: codeunit FuncionesFabricacion;
                begin
                    RutinasFab.LanzarPlanificacionDesdePedidos();
                end;
            }
            action(CalcularTransferencias)
            {
                Description = 'Calcular Transferencias';
                trigger OnAction()
                VAR
                    RutinasFab: codeunit FuncionesFabricacion;
                begin
                    RutinasFab.LanzarPlanificacionDesdeTrans();
                end;
            }
            action(CalcularFabricaciones)
            {
                Description = 'Calcular Fabricaciones';
                trigger OnAction()
                VAR
                    RutinasFab: codeunit FuncionesFabricacion;
                begin
                    RutinasFab.LanzarPlanificacionDesdeFabs();
                end;
            }
        }
        addafter("Ro&uting")
        {
            action(Action78)
            {
                AccessByPermission = TableData "Production BOM Header" = R;
                ApplicationArea = Manufacturing;
                Caption = 'Puntos de uso', Comment = 'ESP="Puntos de uso"';
                Image = "Where-Used";
                ToolTip = 'View a list of BOMs in which the item is used.';
                Promoted = true;
                PromotedCategory = Category6;

                trigger OnAction()
                var
                    Item: Record Item;
                    ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                begin
                    Item.Get("No.");
                    ProdBOMWhereUsed.SetItem(Item, WorkDate);
                    ProdBOMWhereUsed.RunModal;
                end;
            }
            action("Production BOM")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Lista Materiales', Comment = 'ESP="Lista Materiales';
                Image = BOM;
                Promoted = true;
                PromotedCategory = Category6;
                RunObject = Page "Production BOM";
                RunPageLink = "No." = FIELD("Production BOM No.");
                ToolTip = 'Open the item''s production bill of material to view or edit its components.';
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        GlobStock_btc := GetCantidadStock();
        globDecCantDisponible := GetCantidadDisponible();
        globalDecLotSize := GetCantidadRestar();
        globalCantidadEncurso := GetCantidadSumar();

        Clear(globalPlazoDias);
        globalDirectivaFabricacion := '';
        globalDecStockSeguridad := 0;
        globalDecCantMaxPedido := 0;
        globalDecCantMinPedido := 0;
        globalDecMultiplosPedido := 0;

        if EsUnidadAlmacenamiento() then
            GetDatosUdAlmacenamiento()
        else
            GetDatosProducto();
    end;

    local procedure GetDatosUdAlmacenamiento()
    var
        recUdAlmacenamiento: Record "Stockkeeping Unit";
        recItem: Record Item;
    begin
        recUdAlmacenamiento.Reset();
        recUdAlmacenamiento.SetRange("Location Code", "Location Code");
        recUdAlmacenamiento.SetRange("Item No.", "No.");
        recUdAlmacenamiento.SetRange("Variant Code", "Variant Code");
        recUdAlmacenamiento.FindFirst();
        recUdAlmacenamiento.CalcFields(QtyonQuotesOrder);

        globalDirectivaFabricacion := format(recUdAlmacenamiento."Manufacturing Policy");
        globalPlazoDias := recUdAlmacenamiento."Lead Time Calculation";
        globalDecStockSeguridad := recUdAlmacenamiento."Safety Stock Quantity";
        globalDecCantMaxPedido := recUdAlmacenamiento."Maximum Order Quantity";
        globalDecCantMinPedido := recUdAlmacenamiento."Minimum Order Quantity";
        globalDecMultiplosPedido := recUdAlmacenamiento."Order Multiple";
        globalOfertas := recUdAlmacenamiento.QtyonQuotesOrder;
        if recItem.Get("No.") then begin
            globalContraStock := recItem."ContraStock/BajoPedido";
            globalPedidoMaximo := recItem.PedidoMaximo;
        end;
    end;

    local procedure GetDatosProducto()
    var
        recItem: Record Item;
    begin
        if recItem.Get("No.") then begin
            recItem.CalcFields(QtyonQuotesOrder);
            globalDirectivaFabricacion := Format(recItem."Manufacturing Policy");
            globalPlazoDias := recItem."Lead Time Calculation";
            globalDecStockSeguridad := recItem."Safety Stock Quantity";
            globalDecCantMaxPedido := recItem."Maximum Order Quantity";
            globalDecCantMinPedido := recItem."Minimum Order Quantity";
            globalDecMultiplosPedido := recItem."Order Multiple";
            globalOfertas := recItem.QtyonQuotesOrder;
            globalContraStock := recItem."ContraStock/BajoPedido";
            globalPedidoMaximo := recItem.PedidoMaximo;
        end;
    end;

    local procedure EsUnidadAlmacenamiento(): Boolean
    var
        recUdAlmacenamiento: Record "Stockkeeping Unit";
    begin
        if recUdAlmacenamiento.Get("Location Code", "No.", "Variant Code") then
            exit(true)
        else
            exit(false);
    end;

    local procedure GetCantidadStock(): Decimal
    var
        recItem: Record Item;
        RequisitionWkshName: Record "Requisition Wksh. Name";
        Funciones: Codeunit Funciones;
        decCant: Decimal;
    begin
        decCant := 0;

        if not recItem.Get("No.") then
            exit(0);

        /*
        "Location Code" = FIELD("Location Code"),
        "Variant Code" = FIELD("Variant Code"),
        "Shipment Date" = FIELD("Order Date")
        */

        recItem.Reset();
        recItem.SetRange("No.", "No.");
        recItem.SetRange("Location Filter", "Location Code");
        recItem.SetRange("Variant Filter", "Variant Code");
        //recItem.SetRange("Date Filter", "Starting Date", "Ending Date");

        // si es seccion de agrupar almacenes
        if RequisitionWkshName.Get("Worksheet Template Name", "Journal Batch Name") then begin
            if RequisitionWkshName.STHUseLocationGroup then begin
                Funciones.SetFilterLocations(recItem);
            end;
        end;

        if not recItem.FindFirst() then
            exit(0);

        recItem.CalcFields(Inventory);

        decCant := recItem.Inventory;

        exit(decCant);
    end;

    local procedure GetCantidadDisponible(): Decimal
    var
        recItem: Record Item;
        RequisitionWkshName: Record "Requisition Wksh. Name";
        Funciones: Codeunit Funciones;
        decCant: Decimal;
    begin
        decCant := 0;

        if not recItem.Get("No.") then
            exit(0);

        /*
        "Location Code" = FIELD("Location Code"),
        "Variant Code" = FIELD("Variant Code"),
        "Shipment Date" = FIELD("Order Date")
        */

        recItem.Reset();
        recItem.SetRange("No.", "No.");
        recItem.SetRange("Location Filter", "Location Code");
        recItem.SetRange("Variant Filter", "Variant Code");
        //recItem.SetRange("Date Filter", "Starting Date", "Ending Date");

        // si es seccion de agrupar almacenes
        if RequisitionWkshName.Get("Worksheet Template Name", "Journal Batch Name") then begin
            if RequisitionWkshName.STHUseLocationGroup then begin
                Funciones.SetFilterLocations(recItem);
            end;
        end;

        if not recItem.FindFirst() then
            exit(0);

        recItem.CalcFields(Inventory);
        recItem.CalcFields("Qty. on Purch. Order");
        recItem.CalcFields("Qty. on Prod. Order");
        recItem.CalcFields("Res. Qty. on Inbound Transfer");
        recItem.CalcFields("Qty. on Sales Return");

        recItem.CalcFields("Qty. on Sales Order");
        recItem.CalcFields("Qty. on Component Lines");
        recItem.CalcFields("Res. Qty. on Outbound Transfer");
        recItem.CalcFields("Qty. on Purch. Return");
        recItem.CalcFields("Qty. on Asm. Component");
        recItem.CalcFields(QtyonQuotesOrder);

        decCant := (recItem.Inventory +
                        recItem."Qty. on Purch. Order" +
                        recItem."Qty. on Prod. Order" +
                        recItem."Res. Qty. on Inbound Transfer" +
                        recItem."Qty. on Sales Return") -
                    (recItem."Qty. on Sales Order" +
                    recItem."Qty. on Asm. Component" +
                    recItem."Qty. on Component Lines" +
                    recItem."Res. Qty. on Outbound Transfer" +
                    recItem."Qty. on Purch. Return");

        exit(decCant);
    end;

    local procedure GetCantidadRestar(): Decimal
    var
        recItem: Record Item;
        RequisitionWkshName: Record "Requisition Wksh. Name";
        Funciones: Codeunit Funciones;
        decCant: Decimal;
    begin
        decCant := 0;

        if not recItem.Get("No.") then
            exit(0);

        /*
        "Location Code" = FIELD("Location Code"),
        "Variant Code" = FIELD("Variant Code"),
        "Shipment Date" = FIELD("Order Date")
        */

        recItem.Reset();
        recItem.SetRange("No.", "No.");
        recItem.SetRange("Location Filter", "Location Code");
        recItem.SetRange("Variant Filter", "Variant Code");
        //recItem.SetRange("Date Filter", "Starting Date", "Ending Date");

        // si es seccion de agrupar almacenes
        if RequisitionWkshName.Get("Worksheet Template Name") then begin
            if RequisitionWkshName.STHUseLocationGroup then begin
                Funciones.SetFilterLocations(recItem);
            end;
        end;

        if not recItem.FindFirst() then
            exit(0);

        recItem.CalcFields("Qty. on Sales Order");
        recItem.CalcFields("Qty. on Component Lines");
        recItem.CalcFields("Res. Qty. on Outbound Transfer");
        recItem.CalcFields("Qty. on Purch. Return");
        recItem.CalcFields("Qty. on Asm. Component");
        recItem.CalcFields(QtyonQuotesOrder);

        decCant := (recItem."Qty. on Sales Order" +
                    recItem."Qty. on Asm. Component" +
                    recItem."Qty. on Component Lines" +
                    recItem."Res. Qty. on Outbound Transfer" +
                    recItem."Qty. on Purch. Return");

        exit(decCant);
    end;

    local procedure GetCantidadSumar(): Decimal
    var
        recItem: Record Item;
        RequisitionWkshName: Record "Requisition Wksh. Name";
        Funciones: Codeunit Funciones;
        decCant: Decimal;
    begin
        decCant := 0;

        if not recItem.Get("No.") then
            exit(0);

        /*
        "Location Code" = FIELD("Location Code"),
        "Variant Code" = FIELD("Variant Code"),
        "Shipment Date" = FIELD("Order Date")
        */


        recItem.Reset();
        recItem.SetRange("No.", "No.");
        recItem.SetRange("Location Filter", "Location Code");
        recItem.SetRange("Variant Filter", "Variant Code");

        // si es seccion de agrupar almacenes
        if RequisitionWkshName.Get("Worksheet Template Name") then begin
            if RequisitionWkshName.STHUseLocationGroup then begin
                Funciones.SetFilterLocations(recItem);
            end;
        end;
        //recItem.SetRange("Date Filter", "Starting Date", "Ending Date");
        if not recItem.FindFirst() then
            exit(0);

        recItem.CalcFields(Inventory);
        recItem.CalcFields("Qty. on Purch. Order");
        recItem.CalcFields("Qty. on Prod. Order");
        recItem.CalcFields("Res. Qty. on Inbound Transfer");
        recItem.CalcFields("Qty. on Sales Return");

        decCant := (recItem."Qty. on Purch. Order" +
                     recItem."Qty. on Prod. Order" +
                     recItem."Res. Qty. on Inbound Transfer" +
                     recItem."Qty. on Sales Return");

        exit(decCant);
    end;

    var
        globalPlazoDias: DateFormula;
        GlobStock_btc: Decimal;
        globDecCantDisponible: Decimal;
        globalOfertas: Decimal;
        globalDecStockSeguridad: Decimal;

        globalCantidadEncurso: Decimal;
        globalDecCantMaxPedido: Decimal;
        globalDecCantMinPedido: Decimal;
        globalDecMultiplosPedido: Decimal;
        globalDecLotSize: Decimal;
        globalDirectivaFabricacion: Text[50];

        globalContraStock: Option " ",ContraStock,BajoPedido;
        globalPedidoMaximo: Decimal;

    local procedure ShowglobalDecLotSize(Wath: Integer)
    var
        recItem: Record Item;
        RequisitionWkshName: Record "Requisition Wksh. Name";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        Funciones: Codeunit Funciones;
    begin
        recItem.Reset();
        recItem.SetRange("No.", "No.");
        recItem.SetRange("Location Filter", "Location Code");
        recItem.SetRange("Variant Filter", "Variant Code");

        // si es seccion de agrupar almacenes
        if RequisitionWkshName.Get("Worksheet Template Name", "Journal Batch Name") then begin
            if RequisitionWkshName.STHUseLocationGroup then begin
                Funciones.SetFilterLocations(recItem);
            end;
        end;
        recItem.SetRange("Date Filter", 0D, 20991231D);
        if not recItem.FindFirst() then
            exit;

        ItemAvailFormsMgt.ShowItemAvailLineList(RecItem, wath);
    end;

    local procedure ShowglobalStock()
    var
        recItem: Record Item;
        RequisitionWkshName: Record "Requisition Wksh. Name";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        Funciones: Codeunit Funciones;
    begin
        recItem.Reset();
        recItem.SetRange("No.", "No.");
        recItem.SetRange("Location Filter", "Location Code");
        recItem.SetRange("Variant Filter", "Variant Code");

        // si es seccion de agrupar almacenes
        if RequisitionWkshName.Get("Worksheet Template Name", "Journal Batch Name") then begin
            if RequisitionWkshName.STHUseLocationGroup then begin
                Funciones.SetFilterLocations(recItem);
            end;
        end;
        //recItem.SetRange("Date Filter", "Starting Date", "Ending Date");
        if not recItem.FindFirst() then
            exit;

        ItemAvailFormsMgt.ShowItemLedgerEntries(RecItem, false);
    end;
}