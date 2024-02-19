page 17421 "ZM PL Item Purchases Prices"
{
    Caption = 'Item purchases prices', comment = 'ESP="Precios compra productos"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM PL Item Purchase Prices";


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                    ApplicationArea = all;
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}