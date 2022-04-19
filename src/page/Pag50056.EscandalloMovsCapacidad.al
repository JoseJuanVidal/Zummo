page 50056 "Escandallo MovsCapacidad"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = "Capacity Ledger Entry";
    SourceTableView = where("Order Type" = const(Production));

    layout
    {
        area(Content)
        {
            repeater(Lineas)
            {
                field("OrderNo"; "Order No.")
                {
                    ApplicationArea = All;
                }
                field("OrderLineNo"; "Order Line No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Operation No."; "Operation No.")
                {
                    ApplicationArea = all;
                }
                field("Work Center No."; "Work Center No.")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                }
                field("Setup Time"; "Setup Time")
                {
                    ApplicationArea = all;
                }
                field("Run Time"; "Run Time")
                {
                    ApplicationArea = all;
                }
                field("Ending Time"; "Ending Time")
                {
                    ApplicationArea = all;
                }
                field("Stop Time"; "Stop Time")
                {
                    ApplicationArea = all;
                }
                field("Output Quantity"; "Output Quantity")
                {
                    ApplicationArea = all;
                }
                field("Invoiced Quantity"; "Invoiced Quantity")
                {
                    ApplicationArea = all;
                }
                field("Scrap Quantity"; "Scrap Quantity")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Direct Cost"; "Direct Cost")
                {
                    ApplicationArea = all;
                }
                field("Overhead Cost"; "Overhead Cost")
                {
                    ApplicationArea = all;
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