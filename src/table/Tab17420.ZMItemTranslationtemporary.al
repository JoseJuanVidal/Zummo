table 17420 "ZM Item Translation temporary"
{
    DataClassification = CustomerContent;
    Caption = 'Item Tranlation', comment = 'ESP="Traducciona productos"';
    LookupPageId = "ZM Item Translation temporary";
    DrillDownPageId = "ZM Item Translation temporary";

    fields
    {
        field(1; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP="Nº producto"';
            TableRelation = "ZM PL Items temporary";
        }
        field(2; "Language Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP="Cód. idioma"';
            TableRelation = Language;
        }
        field(3; "Description"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(4; "Description 2"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description 2', comment = 'ESP="Descripción 2"';
        }
        field(5400; "Variant Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Variant Code', comment = 'ESP="Cód. variante"';
        }
    }

    keys
    {
        key(PK; "Item No.", "Variant Code", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
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