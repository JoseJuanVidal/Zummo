page 17202 "API Sales Order Shipment Line"
{
    PageType = List;
    SourceTable = "Sales Shipment Line";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field("External Document No."; ExternalDocumentNo)
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
                field("Order No."; "Order No.")
                {
                    ApplicationArea = all;
                }
                field("Order Line No."; "Order Line No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field("VAT Base Amount"; "VAT Base Amount")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        ExternalDocumentNo: text;
}