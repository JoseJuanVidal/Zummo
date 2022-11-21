tableextension 50129 "WhereUsedLine" extends "Where-Used Line"  //99000790
{
    fields
    {
        field(50100; ProductoBloqueado_btc; Boolean)
        {
            Editable = false;
            Caption = 'Item Blocked', comment = 'ESP="Producto bloqueado"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Blocked where("No." = field("Item No.")));
        }
        field(50101; "Parent Item No."; code[20])
        {
            Editable = false;
            Caption = 'Parent No.', comment = 'ESP="Producto padre"';
        }
        field(50102; "Description Parent"; text[100])
        {
            Editable = false;
            Caption = 'Description Parent', comment = 'ESP="Descripción padre"';
        }
        field(50103; "Parent Blocked"; Boolean)
        {
            Editable = false;
            Caption = 'Parent Item Blocked', comment = 'ESP="Producto padre bloqueado"';
        }
    }
}