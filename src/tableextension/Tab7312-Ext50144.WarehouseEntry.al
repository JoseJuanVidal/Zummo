tableextension 50144 "WarehouseEntry" extends "Warehouse Entry"  //7312
{
    fields
    {
        field(50100; ItemDesc1_btc; Text[100])
        {
            Editable = false;
            Caption = 'Description 1', comment = 'ESP="Descripción 1"';
            FieldClass = FlowField;
            CalcFormula = lookup (Item.Description where("No." = field("Item No.")));
        }

        field(50101; ItemDesc2_btc; Text[50])
        {
            Editable = false;
            Caption = 'Description 2', comment = 'ESP="Descripción 2"';
            FieldClass = FlowField;
            CalcFormula = lookup (Item."Description 2" where("No." = field("Item No.")));
        }
    }
}