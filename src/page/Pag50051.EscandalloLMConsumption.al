page 50051 "Escandallo LM Consumption"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Item Ledger Entry";
    SourceTableView = where("Entry Type" = const(Consumption));

    layout
    {
        area(Content)
        {
            repeater(Lineas)
            {
                field("Entry Type"; "Entry Type")
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
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Cost Amount (Expected)"; "Cost Amount (Expected)")
                {
                    ApplicationArea = all;
                }
                field("Cost Amount (Actual)"; "Cost Amount (Actual)")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}