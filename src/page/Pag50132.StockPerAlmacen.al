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
                    Caption = 'Balance con Ofertas', comment = 'ESP="Balance con Ofertas"';
                    Editable = false;
                }
                field(BalanceSinOfertas; BalanceSinOfertas)
                {
                    Caption = 'Balance sin Ofertas', comment = 'ESP="Balance sin Ofertas"';
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

}
