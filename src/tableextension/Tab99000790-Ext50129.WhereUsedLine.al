tableextension 50129 "WhereUsedLine" extends "Where-Used Line"  //99000790
{
    fields
    {
        field(50100; ProductoBloqueado_btc; Boolean)
        {
            Editable = false;
            Caption = 'Item Blocked', comment = 'ESP="Producto bloqueado"';
            FieldClass = FlowField;
            CalcFormula = lookup (Item.Blocked where("No." = field("Item No.")));
        }
    }
}