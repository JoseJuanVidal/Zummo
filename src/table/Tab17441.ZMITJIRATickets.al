table 17441 "ZM IT JIRA Tickets"
{
    DataClassification = CustomerContent;
    LookupPageId = "ZM IT JIRA Tickets";
    DrillDownPageId = "ZM IT JIRA Tickets";


    fields
    {
        field(1; "key"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Key', comment = 'ESP="Código"';
        }
        field(2; "summary"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'summary', comment = 'ESP="Nombre"';
        }
        field(3; id; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; State; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'State', comment = 'ESP="Estado"';
        }
        field(11; "Description Status"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description Status', comment = 'ESP="Descripción Estado"';
        }
        field(12; Assignee; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Assignee', comment = 'ESP="Asignado"';
        }
        field(15; "Type"; enum "ZM Ext JIRA Ticket Type")
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
        fieldgroup(Brick; "key", summary) { }
        fieldgroup(DropDown; "key", summary) { }
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