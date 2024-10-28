table 17201 "ZM Misc. Article Device Type"
{
    DataClassification = CustomerContent;
    Caption = 'Device Type', comment = 'ESP="Tipo Dispositivo"';
    LookupPageId = "ZM Misc. Article Device Type";
    DrillDownPageId = "ZM Misc. Article Device Type";


    fields
    {
        field(1; "Misc. Article Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Misc. Article Code', comment = 'ESP="Cód. recurso diverso"';
            TableRelation = "Misc. Article";
        }
        field(2; Code; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(3; Description; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
    }

    keys
    {
        key(PK; "Misc. Article Code", Code)
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