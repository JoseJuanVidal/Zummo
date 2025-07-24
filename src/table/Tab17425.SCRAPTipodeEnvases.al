table 17425 "SCRAP Tipo de Envases"
{
    DataClassification = CustomerContent;
    LookupPageId = "SCRAP Lista de Envases";
    DrillDownPageId = "SCRAP Lista de Envases";

    fields
    {
        field(1; Code; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(2; Description; text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(5; Rigidez; code[1])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Code)
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