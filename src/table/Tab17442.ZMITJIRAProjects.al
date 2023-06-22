table 17442 "ZM IT JIRA Projects"
{
    DataClassification = CustomerContent;
    LookupPageId = "ZM IT JIRA Projects";
    DrillDownPageId = "ZM IT JIRA Projects";


    fields
    {
        field(1; "key"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Key', comment = 'ESP="Código"';
        }
        field(2; "name"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'name', comment = 'ESP="Nombre"';
        }
        field(3; id; Integer)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "key", name) { }
        fieldgroup(DropDown; "key", name) { }
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