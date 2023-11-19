table 17445 "ZM Daily Time Activo Fjjo"
{
    DataClassification = ToBeClassified;
    Caption = 'AF Partes Diario', comment = 'ESP="AF Partes Diario"';
    LookupPageId = "ZM Daily Time AF";
    DrillDownPageId = "ZM Daily Time AF";

    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Código', comment = 'ESP="Código"';
        }
        field(2; Description; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripción', comment = 'ESP="Descripción"';
        }
    }

    keys
    {
        key(Key1; Code)
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