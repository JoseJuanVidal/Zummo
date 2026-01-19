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
        field(5; Type; Option)
        {
            Caption = 'Type', comment = 'ESP="Tipo"';
            OptionMembers = " ",Intern;
        }
        field(10; Tasks; Integer)
        {
            Caption = 'Task', comment = 'ESP="Tareas"';
            FieldClass = FlowField;
            CalcFormula = count("ZM IT JIRA Tickets" where(Project = field("key")));
            Editable = false;
        }
        field(20; Status; Enum "ZM Contracts Status")
        {
            Caption = 'Status', comment = 'ESP="Estado"';
        }
        field(30; Progression; Enum "ZM Project Progression")
        {
            Caption = 'Progression', comment = 'ESP="Progresión"';
        }
        field(40; User; code[50])
        {
            Caption = 'User', comment = 'ESP="Usuario"';
            TableRelation = "User Personalization"."User ID";
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