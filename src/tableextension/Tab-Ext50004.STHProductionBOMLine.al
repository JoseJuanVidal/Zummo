tableextension 50004 "STH Production BOM Line" extends "Production BOM Line"
{
    fields
    {
        field(50000; "Description Language"; Text[100])
        {
            Caption = 'Description Language', Comment = 'ESP="Descripción Idioma"';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Translation".Description where("Item No." = field("No."), "Language Code" = field("Language Filter")));
            editable = false;
        }
        field(50001; "Language Filter"; code[10])
        {
            Caption = 'Language Filter', comment = 'ESP="Filtro Idioma"';
            FieldClass = FlowFilter;
        }

        field(50006; Steel; Decimal)
        {
            Caption = 'Steel Packing (kg)', comment = 'ESP="Acero Embalaje (kg)"';
            Description = 'Acero que se utiliza para el envío del producto';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Steel where("No." = field("No.")));
        }
        field(50007; Carton; Decimal)
        {
            Caption = 'Carton Packing (kg)', comment = 'ESP="Cartón Embalaje (kg)"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Steel where("No." = field("No.")));
        }
        field(50008; Wood; Decimal)
        {
            Caption = 'Wood Packing (kg)', comment = 'ESP="Madera Embalaje (kg)"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Steel where("No." = field("No.")));
        }
    }
}
