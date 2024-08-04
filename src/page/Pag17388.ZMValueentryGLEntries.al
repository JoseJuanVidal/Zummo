page 17388 "ZM Value entry - G/L Entries"
{
    ApplicationArea = All;
    Caption = 'Value entry - G/L Entries', Comment = 'ESP="Costes Mov. valor - Mov. conta "';
    PageType = List;
    SourceTable = "ZM Value entry - G/L Entry";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Value Entry No."; "Value Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Item Ledger Entry Type"; "Item Ledger Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Item Ledger Entry No."; "Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Valued Quantity"; "Valued Quantity")
                {
                    ApplicationArea = all;
                }
                field("Item Ledger Entry Quantity"; "Item Ledger Entry Quantity")
                {
                    ApplicationArea = all;
                }
                field("Invoiced Quantity"; "Invoiced Quantity")
                {
                    ApplicationArea = all;
                }
                field("Cost per Unit"; "Cost per Unit")
                {
                    ApplicationArea = all;
                }
                field("Sales Amount (Actual)"; "Sales Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Discount Amount"; "Discount Amount")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Applies-to Entry"; "Applies-to Entry")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Amount (Actual)"; "Cost Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field("Cost Posted to G/L"; "Cost Posted to G/L")
                {
                    ApplicationArea = all;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Drop Shipment"; "Drop Shipment")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Amount (Actual) (ACY)"; "Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Posted to G/L (ACY)"; "Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost per Unit (ACY)"; "Cost per Unit (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Document Line No."; "Document Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Order Type"; "Order Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Order No."; "Order No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Order Line No."; "Order Line No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Expected Cost"; "Expected Cost")
                {
                    ApplicationArea = all;
                }
                field("Item Charge No."; "Item Charge No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Valued By Average Cost"; "Valued By Average Cost")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Partial Revaluation"; "Partial Revaluation")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Inventoriable; Inventoriable)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Valuation Date"; "Valuation Date")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = all;
                }
                field("Variance Type"; "Variance Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Purchase Amount (Actual)"; "Purchase Amount (Actual)")
                {
                    ApplicationArea = all;
                }
                field("Purchase Amount (Expected)"; "Purchase Amount (Expected)")
                {
                    ApplicationArea = all;
                }
                field("Sales Amount (Expected)"; "Sales Amount (Expected)")
                {
                    ApplicationArea = all;
                }
                field("Cost Amount (Expected)"; "Cost Amount (Expected)")
                {
                    ApplicationArea = all;
                }
                field("Cost Amount (Non-Invtbl.)"; "Cost Amount (Non-Invtbl.)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Amount (Expected) (ACY)"; "Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Cost Amount (Non-Invtbl.)(ACY)"; "Cost Amount (Non-Invtbl.)(ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Expected Cost Posted to G/L"; "Expected Cost Posted to G/L")
                {
                    ApplicationArea = all;
                }
                field("Exp. Cost Posted to G/L (ACY)"; "Exp. Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Capacity Ledger Entry No."; "Capacity Ledger Entry No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("No."; "No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("G/L Entry No."; "G/L Entry No.")
                {
                    ApplicationArea = all;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = all;
                }
                field("G/L Posting Date"; "G/L Posting Date")
                {
                    ApplicationArea = all;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = all;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = all;
                }
                field("Credit Amount"; "Credit Amount")
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
            action(Update)
            {
                Caption = 'Update', comment = 'ESP="Actualizar"';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lblConfirm: Label '¿Desea actualizar los movimientos de Costes?', comment = 'ESP="¿Desea actualizar los movimientos de Costes?"';
                begin
                    if Confirm(lblConfirm) then
                        Rec.UpdateEntries();
                end;
            }
        }
    }

}
