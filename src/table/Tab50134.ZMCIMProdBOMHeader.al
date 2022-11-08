table 50134 "ZM CIM Prod. BOM Header"
{
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                "Search Name" := Description;
            end;
        }
        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(12; "Search Name"; Code[100])
        {
            Caption = 'Search Name';
        }
        field(21; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(22; "Low-Level Code"; Integer)
        {
            Caption = 'Low-Level Code';
        }
        field(40; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(43; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
        }
        field(45; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'New,Certified,Under Development,Closed';
            OptionMembers = New,Certified,"Under Development",Closed;

        }
        field(50; "Version Nos."; Code[20])
        {
            Caption = 'Version Nos.';
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; Description)
        {
        }
        key(Key4; Status)
        {
        }
    }
}