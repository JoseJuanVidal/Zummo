pageextension 50233 "ZM Customer Lookup" extends "Customer Lookup"
{
    layout
    {
        addafter("No.")
        {
            field("Codigo Anterior"; "Codigo Anterior")
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