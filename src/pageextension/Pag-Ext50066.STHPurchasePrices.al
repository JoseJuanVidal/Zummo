pageextension 50066 "STH Purchase Prices" extends "Purchase Prices"
{
    layout
    {
        addlast(Control1)
        {
            field("Process No."; "Process No.")
            {
                ApplicationArea = all;
            }
            field("Process Description"; "Process Description")
            {
                ApplicationArea = all;
            }
        }
    }
}
