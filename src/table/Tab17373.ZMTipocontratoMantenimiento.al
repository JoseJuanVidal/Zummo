table 17373 "ZM Tipo contrato Mantenimiento"
{
    DataClassification = CustomerContent;
    Caption = 'Tipo contrato mantenimiento', comment = 'ESP=""Tipo contrato Mantenimiento""';
    LookupPageId = "ZM Tipo contrato Mantenimiento";
    DrillDownPageId = "ZM Tipo contrato Mantenimiento";

    fields
    {
        field(1; Name; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Name', comment = 'ESP="Nombre"';
        }
        field(10; duration; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Duration', comment = 'ESP="Duración"';

        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, duration) { }
        fieldgroup(Brick; Name, duration) { }
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