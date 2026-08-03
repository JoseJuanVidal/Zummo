pageextension 50044 "PostedSalesShipmentLines" extends "Posted Sales Shipment Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 7 Code"; "Global Dimension 7 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 6 Code"; "Global Dimension 6 Code")
            {
                ApplicationArea = all;
            }
        }
    }
}