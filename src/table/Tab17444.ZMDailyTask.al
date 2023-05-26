table 17444 "ZM Daily Task"
{
    DataClassification = CustomerContent;
    LookupPageId = "ZM Daily Task";
    DrillDownPageId = "ZM Daily Task";


    fields
    {
        field(1; "User Id"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Code"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(3; "Description"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
    }

    keys
    {
        key(PK; "User Id", Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; code, Description) { }
        fieldgroup(DropDown; Code, Description) { }
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