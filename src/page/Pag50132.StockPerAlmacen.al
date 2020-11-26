page 50132 "StockPerAlmacen"
{

    PageType = ListPart;
    SourceTable = "Stockkeeping Unit";
    Caption = 'Location Stock', comment = 'ESP="Stock por Almacen"';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field(Inventory; Inventory)
                {
                    ApplicationArea = All;
                    Caption = '(+)Inventario';

                    trigger OnDrillDown()
                    begin
                        ShowInventory();
                    end;
                }
                field("Qty. on Assembly Order"; "Qty. on Assembly Order")
                {
                    ApplicationArea = All;
                    Caption = '(+)Cant. en pedido de ensamblado';
                }
                field("Qty. on Prod. Order"; "Qty. on Prod. Order")
                {
                    ApplicationArea = All;
                    Caption = '(+)Cant. en orden producc.';
                }
                field("Qty. on Purch. Order"; "Qty. on Purch. Order")
                {
                    ApplicationArea = All;
                    Caption = '(+)Cant. en pedidos compra';

                    trigger OnDrillDown()
                    begin
                        ShowPurchaseLine;
                    end;
                }
                field("Trans. Ord. Receipt (Qty.)"; "Trans. Ord. Receipt (Qty.)")
                {
                    Caption = '(+)Recep. ped. transfer. (cant.)';
                }
                field("Qty. on Asm. Component"; "Qty. on Asm. Component")
                {
                    ApplicationArea = All;
                    Caption = '(-)Cant. componentes';
                }

                field("Qty. on Component Lines"; "Qty. on Component Lines")
                {
                    ApplicationArea = All;
                    Caption = '(-)Cant. línea componentes';
                }
                field("Qty. on Job Order"; "Qty. on Job Order")
                {
                    ApplicationArea = All;
                    Caption = '(-)Cant. en pedido de proyecto';
                }

                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                    ApplicationArea = All;
                    Caption = '(-)Cant. en pedidos venta';

                    trigger OnDrillDown()
                    begin
                        ShowSalesLine();
                    end;
                }
                field("Qty. on Service Order"; "Qty. on Service Order")
                {
                    ApplicationArea = All;
                    Caption = '(-)Cant. en ped. servicio';
                }

                field("Trans. Ord. Shipment (Qty.)"; "Trans. Ord. Shipment (Qty.)")
                {
                    Caption = '(-)Envío ped. transfer. (cant.)';

                }
                field(QtyonQuotesOrder; QtyonQuotesOrder)
                {
                    Caption = '(-)Cant. en ofertas de venta';
                }
                field("Cant_ componentes Oferta"; "Cant_ componentes Oferta")
                {
                    Caption = '(-)Cant. componentes Oferta';
                }
                field(BalanceConOfertas; BalanceConOfertas)
                {
                    Caption = 'Cantidad disponible (con Ofertas)', comment = 'ESP="Cantidad disponible (con Ofertas)"';
                    Editable = false;
                }
                field(BalanceSinOfertas; BalanceSinOfertas)
                {
                    Caption = '', comment = 'ESP="Cantidad Disponible"';
                    Editable = false;
                }
                field(Ordenacion; Ordenacion)
                {

                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        SetCurrentKey(Ordenacion);
    end;

    trigger OnAfterGetRecord()
    VAR
        InventorySetup: Record "Inventory Setup";
        FuncFabricacion: Codeunit FuncionesFabricacion;
    begin
        InventorySetup.Get();
        BalanceConOfertas := 0;
        BalanceSinOfertas := 0;
        FuncFabricacion.CalcDisponble(rec, BalanceConOfertas, BalanceSinOfertas);
        //BalanceConOfertas := Inventory + "Qty. on Assembly Order" + "Qty. on Prod. Order" + "Qty. on Purch. Order" + "Trans. Ord. Receipt (Qty.)"
        //    - "Qty. on Asm. Component" - "Qty. on Component Lines" - "Qty. on Job Order" - "Qty. on Sales Order" - "Qty. on Service Order"
        //    - "Trans. Ord. Shipment (Qty.)" - QtyonQuotesOrder - "Cant_ componentes Oferta";
        //BalanceSinOfertas := Inventory + "Qty. on Assembly Order" + "Qty. on Prod. Order" + "Qty. on Purch. Order" + "Trans. Ord. Receipt (Qty.)"
        //    - "Qty. on Asm. Component" - "Qty. on Component Lines" - "Qt        
    end;

    var
        BalanceConOfertas: Decimal;
        BalanceSinOfertas: Decimal;

    local procedure ShowInventory()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", "Item No.");
        ItemLedgerEntry.SetRange("Location Code", "Location Code");
        ItemLedgerEntry.SetRange("Global Dimension 1 Code", "Global Dimension 1 Filter");
        ItemLedgerEntry.SetRange("Global Dimension 2 Code", "Global Dimension 2 Filter");
        ItemLedgerEntry.SetRange("Drop Shipment", "Drop Shipment Filter");
        ItemLedgerEntry.SetRange("Variant Code", "Variant Code");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntry.SetRange(Positive, true);
        page.RunModal(0, ItemLedgerEntry);
    end;

    local procedure ShowSalesLine()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.type::Item);
        SalesLine.SetRange("No.", "Item No.");
        SalesLine.SetRange("Location Code", "Location Code");
        SalesLine.SetRange("Shortcut Dimension 1 Code", "Global Dimension 1 Filter");
        SalesLine.SetRange("Shortcut Dimension 2 Code", "Global Dimension 2 Filter");
        SalesLine.SetRange("Drop Shipment", "Drop Shipment Filter");
        SalesLine.SetRange("Variant Code", "Variant Code");
        //if GetFilter("Date Filter") <> '' then
        //SalesLine.SetRange("Shipment Date", "Date Filter");
        SalesLine.SetFilter("Outstanding Quantity", '<>0');
        page.RunModal(0, SalesLine);
    end;

    local procedure ShowPurchaseLine()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("No.", "Item No.");
        PurchaseLine.SetRange("Location Code", "Location Code");
        PurchaseLine.SetRange("Shortcut Dimension 1 Code", "Global Dimension 1 Filter");
        PurchaseLine.SetRange("Shortcut Dimension 2 Code", "Global Dimension 2 Filter");
        PurchaseLine.SetRange("Drop Shipment", "Drop Shipment Filter");
        PurchaseLine.SetRange("Variant Code", "Variant Code");
        //if GetFilter("Date Filter") <> '' then
        //PurchaseLine.SetRange("Expected Receipt Date", "Date Filter");
        PurchaseLine.SetFilter("Outstanding Quantity", '<>0');
        page.RunModal(0, PurchaseLine);
    end;
}
