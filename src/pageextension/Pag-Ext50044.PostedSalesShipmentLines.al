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
        }
    }
}