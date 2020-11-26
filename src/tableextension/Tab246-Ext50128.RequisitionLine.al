tableextension 50128 "RequisitionLine" extends "Requisition Line" //246
{
    fields
    {
        field(50100; Stock_btc; Decimal)
        {
            Caption = 'Inventario', comment = 'ESP="Inventario"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity" WHERE(
                "Item No." = FIELD("No."),
                  "Location Code" = FIELD("Location Code"),
                "Variant Code" = FIELD("Variant Code"),
                Open = const(true)
            ));
        }


        field(50103; StockSeguridad_btc; Decimal)
        {
            ObsoleteState = Removed;
            Editable = false;
            Caption = 'Safety Stock', comment = 'ESP="Stock Seguridad"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Safety Stock Quantity" where("No." = field("No.")));
        }

        field(50104; PlazoDias_btc; DateFormula)
        {
            ObsoleteState = Removed;
            Editable = false;
            Caption = 'Lead Time Calculation', comment = 'ESP="Plazo entrega días"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Lead Time Calculation" where("No." = field("No.")));
        }

        field(50108; MultiplosPedido_btc; Decimal)
        {
            ObsoleteState = Removed;
            Editable = false;
            Caption = 'Order Multiple', comment = 'ESP="Múltiplos de pedido"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Order Multiple" where("No." = field("No.")));
        }

        field(50109; CantidadMinimaPedido_btc; Decimal)
        {
            ObsoleteState = Removed;
            Editable = false;
            Caption = 'Minumun Order Quantity', comment = 'ESP="Cantidad mínima pedido"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Minimum Order Quantity" where("No." = field("No.")));
        }

        field(50110; Urgente; Boolean)
        {
            Caption = 'Urgente';
        }
        field(50111; "Estado"; Option)
        {
            Editable = true;
            Caption = 'Estado', comment = 'ESP="Estado"';
            OptionMembers = Pedido,Oferta,StockSeguridad;
            OptionCaption = 'Pedido,Oferta,StockSeguridad', comment = 'ESP="Pedido,Oferta,StockSeguridad"';
        }
    }
}