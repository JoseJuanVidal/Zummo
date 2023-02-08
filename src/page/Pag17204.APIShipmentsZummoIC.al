page 17204 "API Shipments Zummo IC"
{
    PageType = List;
    SourceTable = "Sales Shipment Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.") { ApplicationArea = all; }
                field("Sell-to Customer No."; "Sell-to Customer No.") { ApplicationArea = all; }
                field("Sell-to Customer Name"; "Sell-to Customer Name") { ApplicationArea = all; }
                field("Order No."; "Order No.") { ApplicationArea = all; }
                field("External Document No."; "External Document No.") { ApplicationArea = all; }
                field("Posting Date"; "Posting Date") { ApplicationArea = all; }
            }
        }
    }
}