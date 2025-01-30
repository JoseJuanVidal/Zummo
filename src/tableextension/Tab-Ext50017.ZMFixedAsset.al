tableextension 50017 "ZMFixedAsset" extends "Fixed Asset"
{
    fields
    {
        field(50000; "Date Ini. Amort"; Date)
        {
            Caption = 'Date Ini. Amort', comment = 'ESP="Fecha inicio amortización"';
            FieldClass = FlowField;
            CalcFormula = lookup("FA Depreciation Book"."Depreciation Starting Date" where("FA No." = field("No.")));
            Editable = false;
        }
        field(50001; "Date Fin. Amort"; Date)
        {
            Caption = 'Date Fin. Amort', comment = 'ESP="Fecha final amortización"';
            FieldClass = FlowField;
            CalcFormula = lookup("FA Depreciation Book"."Depreciation Ending Date" where("FA No." = field("No.")));
            Editable = false;
        }
        field(50010; "Status Use"; Option)
        {
            Caption = 'Status Use', comment = 'ESP="Estado Uso"';
            OptionMembers = Operativo,"No Operativo";
            OptionCaption = 'Operativo,No Operativo', Comment = 'ESP="Operativo,No Operativo"';
        }
        field(50011; "Previous AF changes"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Previous AF changes', comment = 'ESP="AF que modifica"';
            TableRelation = "Fixed Asset";
        }
        field(50012; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. Producto"';
            TableRelation = Item;
        }
    }
}
