table 17381 "ZM JOB Clasification"
{
    DataClassification = CustomerContent;
    Caption = 'JOB Clasification', comment = 'ESP="Clasificación"';
    LookupPageId = "ZM Job Clafication";
    DrillDownPageId = "ZM Job Clafication";


    fields
    {
        field(1; "Field No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Field No.', comment = 'ESP="Nº Campo"';
        }
        field(2; Code; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }
    }

    keys
    {
        key(PK; "Field No.", Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; Code)
        { }
        fieldGroup(DropDown; Code)
        { }
    }

    local procedure GetCaption(): text;
    var
        myInt: Integer;
    begin

    end;
}