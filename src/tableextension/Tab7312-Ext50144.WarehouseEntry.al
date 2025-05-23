tableextension 50144 "WarehouseEntry" extends "Warehouse Entry"  //7312
{
    fields
    {
        field(50100; ItemDesc1_btc; Text[100])
        {
            Editable = false;
            Caption = 'Description 1', comment = 'ESP="Descripción 1"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }

        field(50101; ItemDesc2_btc; Text[50])
        {
            Editable = false;
            Caption = 'Description 2', comment = 'ESP="Descripción 2"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Description 2" where("No." = field("Item No.")));
        }
        field(50105; "Fecha Fin Contrato"; date)
        {
            Caption = 'Fecha Fin Contrato', comment = 'ESP="Fecha Fin Contrato"';
        }
        field(50106; "Comentario"; text[100])
        {
            Caption = 'Comentario', comment = 'ESP="Comentario"';
        }
        field(50110; "Customer No."; Code[20])
        {
            Caption = 'Customer No.', comment = 'ESP=Cód. Cliente"';
        }
        field(50112; Blocked; Boolean)
        {
            Caption = 'Blocked', comment = 'ESP=Bloqueado"';
        }
        field(50120; "Language Code"; code[10])
        {
            Caption = 'Language Code', comment = 'ESP=Cód. Idioma"';
            TableRelation = Language;
        }
        field(50122; "Description Language"; text[100])
        {
            Caption = 'Description Language', comment = 'ESP="Descripción Idioma"';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Translation".Description where("Item No." = field("Item No."), "Language Code" = field("Language Code")));
        }
    }
}