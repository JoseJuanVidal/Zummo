page 50154 "ZM Sales Shipment Packing"
{
    Caption = 'Sales Shipment Packing', comment = 'ESP="Packing Albarán Venta"';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Shipment Header";
    DeleteAllowed = false;
    InsertAllowed = false;


    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General', comment = 'ESP="General"';
                Editable = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Sell-to City"; "Sell-to City")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    ApplicationArea = All;
                }
            }
            part(Lines; "ZM Sales Order Packing Line")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
                SubPageLink = "Document No." = FIELD("No."), "Document type" = const("Sales Shipment");

            }
        }
    }

    var
        myInt: Integer;
}