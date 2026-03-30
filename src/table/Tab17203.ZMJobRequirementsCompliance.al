table 17203 "ZM Job Requirements Compliance"
{
    DataClassification = CustomerContent;
    Caption = 'JOB Requirements Compliance', comment = 'ESP="Cumplimiento Requisitos Proyectos"';
    DrillDownPageId = "ZM Job Requirement Compliances";
    LookupPageId = "ZM Job Requirement Compliances";

    fields
    {
        field(1; "Job No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.', comment = 'ESP="Nº proyecto"';
            TableRelation = Job;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', comment = 'ESP="Nº Línea"';
            AutoIncrement = true;
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(20; Category; Option)
        {
            Caption = 'Category', comment = 'ESP="Categoría"';
            OptionMembers = " ","Won't",Could,Should,Must;
        }
        field(30; RP0; Boolean)
        {
            Caption = 'RP0', comment = 'ESP="RP0"';
        }
        field(40; RP1; Boolean)
        {
            Caption = 'RP1', comment = 'ESP="RP1"';
        }
        field(50; RP2; Boolean)
        {
            Caption = 'RP2', comment = 'ESP="RP2"';
        }
        field(60; RP4; Boolean)
        {
            Caption = 'RP4', comment = 'ESP="RP4"';
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
        key(key1; "Job No.")
        { }
        key(key2; Description)
        { }
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