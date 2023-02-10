page 17201 "API IC Sales Order Shipment"
{
    PageType = List;
    SourceTable = "Sales Shipment Header";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = all;
                }
                field("Order No."; "Order No.")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = all;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = all;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    ApplicationArea = all;
                }
                field("Shipment Date"; "Shipment Date")
                {
                    ApplicationArea = all;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ApplicationArea = all;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}