table 50151 "STH Fallo Localizado"
{
    DataClassification = CustomerContent;
    LookupPageId = "STH Fallo Localizado";
    DrillDownPageId = "STH Fallo Localizado";

    fields
    {
        field(1; FalloLocalizado; code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fallo Localizado', comment = 'ESP="Fallo Localizado"';
        }
        field(2; InformeMejora; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Informe Mejora', comment = 'ESP="Informe Mejora"';
        }
        field(3; "Descripción"; text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripción', comment = 'ESP="Descripción"';
        }
    }

    keys
    {
        key(PK; FalloLocalizado)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; FalloLocalizado, InformeMejora, "Descripción")
        {

        }
        fieldgroup(Brick; FalloLocalizado, InformeMejora, "Descripción")
        { }
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