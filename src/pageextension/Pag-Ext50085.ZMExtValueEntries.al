pageextension 50085 "ZM Ext Value Entries" extends "Value Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Prod. Order State"; "Prod. Order State")
            {
                ApplicationArea = all;
            }
        }
    }
}
