pageextension 50217 "ZM Serial No. Information Card" extends "Serial No. Information Card"
{
    layout
    {
        addafter("Expired Inventory")
        {
            field("Serial No. Cost"; "Serial No. Cost")
            {
                ApplicationArea = all;
            }
            field("Last Date Update Cost"; "Last Date Update Cost")
            {
                ApplicationArea = all;
            }
        }
    }
}