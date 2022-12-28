page 50153 "ZM Sales Order Packing"
{
    Caption = 'Sales Order Packing', comment = 'ESP="Packing Pedido Venta"';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order));
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
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
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
                Enabled = "No." <> '';
                Editable = "No." <> '';
                SubPageLink = "Document No." = FIELD("No."), "Document type" = const(Order);
            }
        }
    }
    var
        myInt: Integer;
}