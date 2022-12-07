tableextension 50005 "STH BOM BufferExt" extends "BOM Buffer"
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
        Field(50200; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Qty. (kg)', comment = 'ESP="Cdad. plástico (kg)"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Plastic Qty. (kg)" where("No." = field("No.")));
            editable = false;
            DecimalPlaces = 5 : 5;
        }
        Field(50201; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Qty (kg)', comment = 'ESP="Cdad. plástico reciclado (kg)"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Recycled Plastic Qty. (kg)" where("No." = field("No.")));
            editable = false;
            DecimalPlaces = 5 : 5;
        }
        Field(50202; "Recycled plastic %"; decimal)
        {
            Caption = 'Plastic %', comment = 'ESP="% Plástico reciclado"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Recycled plastic %" where("No." = field("No.")));
            editable = false;
            DecimalPlaces = 2 : 2;
        }
        Field(50203; "Packing Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Packing Plastic Qty. (kg)', comment = 'ESP="Cdad. plástico embalaje (kg)"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Packing Plastic Qty. (kg)" where("No." = field("No.")));
            editable = false;
            DecimalPlaces = 5 : 5;
        }
        Field(50204; "Packing Recycled plastic (kg)"; decimal)
        {
            Caption = 'Packing Recycled Plastic Qty (kg)', comment = 'ESP="Cdad. plástico reciclado embalaje (kg)"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Packing Recycled plastic (kg)" where("No." = field("No.")));
            editable = false;
            DecimalPlaces = 5 : 5;
        }
        Field(50205; "Packing Recycled plastic %"; decimal)
        {
            Caption = 'Packing Plastic %', comment = 'ESP="% Plástico reciclado embalaje"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Packing Recycled plastic %" where("No." = field("No.")));
            editable = false;
            DecimalPlaces = 2 : 2;
        }
        field(50206; Steel; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Steel where("No." = field("No.")));
            editable = false;
            Caption = 'Steel', comment = 'ESP="Acero"';
        }
        field(50207; Carton; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Carton where("No." = field("No.")));
            editable = false;
            Caption = 'Carton', comment = 'ESP="Cartón"';
        }
        field(50208; Wood; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Wood where("No." = field("No.")));
            editable = false;
            Caption = 'Wood', comment = 'ESP="Madera"';
        }
    }
}
