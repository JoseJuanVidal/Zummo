table 17409 "ZM CONSULTIA Producto-Proyecto"
{
    DataClassification = CustomerContent;
    Caption = 'Producto - Proyecto', comment = 'ESP="Producto - Proyecto"';
    LookupPageId = "ZM CONSULTIA Producto-Proyecto";
    DrillDownPageId = "ZM CONSULTIA Producto-Proyecto";

    fields
    {
        field(1; "CodigoProducto"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Cód. producto', comment = 'ESP="Cód. producto"';
        }
        field(2; Description; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(3; "Proyecto"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Proyecto', comment = 'ESP="Proyecto"';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
    }

    keys
    {
        key(PK; CodigoProducto)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}