pageextension 50232 "ZM Item Lookup" extends "Item Lookup"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; "No. 2")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}