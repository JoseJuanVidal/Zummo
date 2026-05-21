tableextension 50220 "ZM Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50120; "Codigo Anterior"; code[20])
        {
            Caption = 'Codigo Anterior', comment = 'ESP="Codigo Anterior"';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}