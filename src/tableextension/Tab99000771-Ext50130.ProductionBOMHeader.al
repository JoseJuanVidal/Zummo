
tableextension 50130 "ProductionBOMHeader" extends "Production BOM Header"  //99000771
{
    fields
    {
        field(50100; ProductoBloqueado_btc; Boolean)
        {
            Editable = false;
            Caption = 'Item Blocked', comment = 'ESP="Producto bloqueado"';
            FieldClass = FlowField;
            CalcFormula = lookup (Item.Blocked where("No." = field("No.")));
        }
    }
}