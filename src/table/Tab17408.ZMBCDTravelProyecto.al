table 17408 "ZM BCD Travel Proyecto"
{
    DataClassification = CustomerContent;
    Caption = 'BCD Travel Proyecto', comment = 'ESP="BCD Travel Proyecto"';
    LookupPageId = "ZM BCD Travel Proyecto";
    DrillDownPageId = "ZM BCD Travel Proyecto";

    fields
    {
        field(1; "Codigo"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Código', comment = 'ESP="Código"';
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
        key(PK; Codigo)
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