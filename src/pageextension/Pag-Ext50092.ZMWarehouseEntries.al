pageextension 50092 "ZM Warehouse Entries" extends "Warehouse Entries"
{
    layout
    {
        addafter("Item No.")
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

}