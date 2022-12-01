page 50059 "WS Purchase Line"
{
    Caption = 'WS Purchase Line';
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = const(Order));
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("A. Rcd. Not Inv. Ex. VAT (LCY)"; Rec."A. Rcd. Not Inv. Ex. VAT (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = none;
                }
                field("Allow Item Charge Assignment"; Rec."Allow Item Charge Assignment")
                {
                    ApplicationArea = none;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = none;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = none;
                }
                field("Amt. Rcd. Not Invoiced"; Rec."Amt. Rcd. Not Invoiced")
                {
                    ApplicationArea = none;
                }
                field("Amt. Rcd. Not Invoiced (LCY)"; Rec."Amt. Rcd. Not Invoiced (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    ApplicationArea = none;
                }
                field("Area"; Rec."Area")
                {
                    ApplicationArea = none;
                }
                field("Attached Doc Count"; Rec."Attached Doc Count")
                {
                    ApplicationArea = none;
                }
                field("Attached to Line No."; Rec."Attached to Line No.")
                {
                    ApplicationArea = none;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = none;
                }
                field("Blanket Order Line No."; Rec."Blanket Order Line No.")
                {
                    ApplicationArea = none;
                }
                field("Blanket Order No."; Rec."Blanket Order No.")
                {
                    ApplicationArea = none;
                }
                field("Budgeted FA No."; Rec."Budgeted FA No.")
                {
                    ApplicationArea = none;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = none;
                }
                field("Completely Received"; Rec."Completely Received")
                {
                    ApplicationArea = none;
                }
                field("Copied From Posted Doc."; Rec."Copied From Posted Doc.")
                {
                    ApplicationArea = none;
                }
                field("Cross-Reference No."; Rec."Cross-Reference No.")
                {
                    ApplicationArea = none;
                }
                field("Cross-Reference Type"; Rec."Cross-Reference Type")
                {
                    ApplicationArea = none;
                }
                field("Cross-Reference Type No."; Rec."Cross-Reference Type No.")
                {
                    ApplicationArea = none;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = none;
                }
                field("Deferral Code"; Rec."Deferral Code")
                {
                    ApplicationArea = none;
                }
                field("Depr. Acquisition Cost"; Rec."Depr. Acquisition Cost")
                {
                    ApplicationArea = none;
                }
                field("Depr. until FA Posting Date"; Rec."Depr. until FA Posting Date")
                {
                    ApplicationArea = none;
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                    ApplicationArea = none;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = none;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = none;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = none;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = none;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = none;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = none;
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = none;
                }
                field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
                {
                    ApplicationArea = none;
                }
                field("EC %"; Rec."EC %")
                {
                    ApplicationArea = none;
                }
                field("EC Difference"; Rec."EC Difference")
                {
                    ApplicationArea = none;
                }
                field("Entry Point"; Rec."Entry Point")
                {
                    ApplicationArea = none;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = none;
                }
                field("FA Posting Date"; Rec."FA Posting Date")
                {
                    ApplicationArea = none;
                }
                field("FA Posting Type"; Rec."FA Posting Type")
                {
                    ApplicationArea = none;
                }
                field(FechaRechazo_btc; Rec.FechaRechazo_btc)
                {
                    ApplicationArea = none;
                }
                field(Finished; Rec.Finished)
                {
                    ApplicationArea = none;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = none;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = none;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = none;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    ApplicationArea = none;
                }
                field("IC Partner Ref. Type"; Rec."IC Partner Ref. Type")
                {
                    ApplicationArea = none;
                }
                field("IC Partner Reference"; Rec."IC Partner Reference")
                {
                    ApplicationArea = none;
                }
                field("Inbound Whse. Handling Time"; Rec."Inbound Whse. Handling Time")
                {
                    ApplicationArea = none;
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = none;
                }
                field("Insurance No."; Rec."Insurance No.")
                {
                    ApplicationArea = none;
                }
                field("Inv. Disc. Amount to Invoice"; Rec."Inv. Disc. Amount to Invoice")
                {
                    ApplicationArea = none;
                }
                field("Inv. Discount Amount"; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = none;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = none;
                }
                field("Job Currency Code"; Rec."Job Currency Code")
                {
                    ApplicationArea = none;
                }
                field("Job Currency Factor"; Rec."Job Currency Factor")
                {
                    ApplicationArea = none;
                }
                field("Job Line Amount"; Rec."Job Line Amount")
                {
                    ApplicationArea = none;
                }
                field("Job Line Amount (LCY)"; Rec."Job Line Amount (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Job Line Disc. Amount (LCY)"; Rec."Job Line Disc. Amount (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Job Line Discount %"; Rec."Job Line Discount %")
                {
                    ApplicationArea = none;
                }
                field("Job Line Discount Amount"; Rec."Job Line Discount Amount")
                {
                    ApplicationArea = none;
                }
                field("Job Line Type"; Rec."Job Line Type")
                {
                    ApplicationArea = none;
                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = none;
                }
                field("Job Planning Line No."; Rec."Job Planning Line No.")
                {
                    ApplicationArea = none;
                }
                field("Job Remaining Qty."; Rec."Job Remaining Qty.")
                {
                    ApplicationArea = none;
                }
                field("Job Remaining Qty. (Base)"; Rec."Job Remaining Qty. (Base)")
                {
                    ApplicationArea = none;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = none;
                }
                field("Job Total Price"; Rec."Job Total Price")
                {
                    ApplicationArea = none;
                }
                field("Job Total Price (LCY)"; Rec."Job Total Price (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Job Unit Price"; Rec."Job Unit Price")
                {
                    ApplicationArea = none;
                }
                field("Job Unit Price (LCY)"; Rec."Job Unit Price (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = none;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = none;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = none;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = none;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = none;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = none;
                }
                field("MPS Order"; Rec."MPS Order")
                {
                    ApplicationArea = none;
                }
                field("Maintenance Code"; Rec."Maintenance Code")
                {
                    ApplicationArea = none;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = none;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = none;
                }
                field("Nombre Proveedor"; Rec."Nombre Proveedor")
                {
                    ApplicationArea = none;
                }
                field(Nonstock; Rec.Nonstock)
                {
                    ApplicationArea = none;
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = none;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = none;
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    ApplicationArea = none;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = none;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    ApplicationArea = none;
                }
                field("Outstanding Amount (LCY)"; Rec."Outstanding Amount (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Outstanding Amt. Ex. VAT (LCY)"; Rec."Outstanding Amt. Ex. VAT (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Outstanding Qty. (Base)"; Rec."Outstanding Qty. (Base)")
                {
                    ApplicationArea = none;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = none;
                }
                field("Overhead Rate"; Rec."Overhead Rate")
                {
                    ApplicationArea = none;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = none;
                }
                field(PermitirMatarResto; Rec.PermitirMatarResto)
                {
                    ApplicationArea = none;
                }
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                    ApplicationArea = none;
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                    ApplicationArea = none;
                }
                field("Pmt. Discount Amount"; Rec."Pmt. Discount Amount")
                {
                    ApplicationArea = none;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = none;
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                    ApplicationArea = none;
                }
                field("Prepayment Amount"; Rec."Prepayment Amount")
                {
                    ApplicationArea = none;
                }
                field("Prepayment EC %"; Rec."Prepayment EC %")
                {
                    ApplicationArea = none;
                }
                field("Prepayment Line"; Rec."Prepayment Line")
                {
                    ApplicationArea = none;
                }
                field("Prepayment Tax Area Code"; Rec."Prepayment Tax Area Code")
                {
                    ApplicationArea = none;
                }
                field("Prepayment Tax Group Code"; Rec."Prepayment Tax Group Code")
                {
                    ApplicationArea = none;
                }
                field("Prepayment Tax Liable"; Rec."Prepayment Tax Liable")
                {
                    ApplicationArea = none;
                }
                field("Prepayment VAT %"; Rec."Prepayment VAT %")
                {
                    ApplicationArea = none;
                }
                field("Prepayment VAT Difference"; Rec."Prepayment VAT Difference")
                {
                    ApplicationArea = none;
                }
                field("Prepayment VAT Identifier"; Rec."Prepayment VAT Identifier")
                {
                    ApplicationArea = none;
                }
                field("Prepmt Amt Deducted"; Rec."Prepmt Amt Deducted")
                {
                    ApplicationArea = none;
                }
                field("Prepmt Amt to Deduct"; Rec."Prepmt Amt to Deduct")
                {
                    ApplicationArea = none;
                }
                field("Prepmt VAT Diff. Deducted"; Rec."Prepmt VAT Diff. Deducted")
                {
                    ApplicationArea = none;
                }
                field("Prepmt VAT Diff. to Deduct"; Rec."Prepmt VAT Diff. to Deduct")
                {
                    ApplicationArea = none;
                }
                field("Prepmt. Amount Inv. (LCY)"; Rec."Prepmt. Amount Inv. (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Prepmt. Amount Inv. Incl. VAT"; Rec."Prepmt. Amount Inv. Incl. VAT")
                {
                    ApplicationArea = none;
                }
                field("Prepmt. Amt. Incl. VAT"; Rec."Prepmt. Amt. Incl. VAT")
                {
                    ApplicationArea = none;
                }
                field("Prepmt. Amt. Inv."; Rec."Prepmt. Amt. Inv.")
                {
                    ApplicationArea = none;
                }
                field("Prepmt. Line Amount"; Rec."Prepmt. Line Amount")
                {
                    ApplicationArea = none;
                }
                field("Prepmt. VAT Amount Inv. (LCY)"; Rec."Prepmt. VAT Amount Inv. (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Prepmt. VAT Base Amt."; Rec."Prepmt. VAT Base Amt.")
                {
                    ApplicationArea = none;
                }
                field("Prepmt. VAT Calc. Type"; Rec."Prepmt. VAT Calc. Type")
                {
                    ApplicationArea = none;
                }
                field("Primera Fecha Recep."; Rec."Primera Fecha Recep.")
                {
                    ApplicationArea = none;
                }
                field("Process No."; Rec."Process No.")
                {
                    ApplicationArea = none;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ApplicationArea = none;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = none;
                }
                field("Profit %"; Rec."Profit %")
                {
                    ApplicationArea = none;
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = none;
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ApplicationArea = none;
                }
                field("Qty. Assigned"; Rec."Qty. Assigned")
                {
                    ApplicationArea = none;
                }
                field("Qty. Invoiced (Base)"; Rec."Qty. Invoiced (Base)")
                {
                    ApplicationArea = none;
                }
                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = none;
                }
                field("Qty. Rcd. Not Invoiced (Base)"; Rec."Qty. Rcd. Not Invoiced (Base)")
                {
                    ApplicationArea = none;
                }
                field("Qty. Received (Base)"; Rec."Qty. Received (Base)")
                {
                    ApplicationArea = none;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = none;
                }
                field("Qty. to Assign"; Rec."Qty. to Assign")
                {
                    ApplicationArea = none;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = none;
                }
                field("Qty. to Invoice (Base)"; Rec."Qty. to Invoice (Base)")
                {
                    ApplicationArea = none;
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = none;
                }
                field("Qty. to Receive (Base)"; Rec."Qty. to Receive (Base)")
                {
                    ApplicationArea = none;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = none;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = none;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = none;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = none;
                }
                field("Recalculate Invoice Disc."; Rec."Recalculate Invoice Disc.")
                {
                    ApplicationArea = none;
                }
                field("Receipt Line No."; Rec."Receipt Line No.")
                {
                    ApplicationArea = none;
                }
                field("Receipt No."; Rec."Receipt No.")
                {
                    ApplicationArea = none;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = none;
                }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)")
                {
                    ApplicationArea = none;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = none;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = none;
                }
                field("Ret. Qty. Shpd Not Invd.(Base)"; Rec."Ret. Qty. Shpd Not Invd.(Base)")
                {
                    ApplicationArea = none;
                }
                field("Return Qty. Shipped"; Rec."Return Qty. Shipped")
                {
                    ApplicationArea = none;
                }
                field("Return Qty. Shipped (Base)"; Rec."Return Qty. Shipped (Base)")
                {
                    ApplicationArea = none;
                }
                field("Return Qty. Shipped Not Invd."; Rec."Return Qty. Shipped Not Invd.")
                {
                    ApplicationArea = none;
                }
                field("Return Qty. to Ship"; Rec."Return Qty. to Ship")
                {
                    ApplicationArea = none;
                }
                field("Return Qty. to Ship (Base)"; Rec."Return Qty. to Ship (Base)")
                {
                    ApplicationArea = none;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    ApplicationArea = none;
                }
                field("Return Shipment Line No."; Rec."Return Shipment Line No.")
                {
                    ApplicationArea = none;
                }
                field("Return Shipment No."; Rec."Return Shipment No.")
                {
                    ApplicationArea = none;
                }
                field("Return Shpd. Not Invd."; Rec."Return Shpd. Not Invd.")
                {
                    ApplicationArea = none;
                }
                field("Return Shpd. Not Invd. (LCY)"; Rec."Return Shpd. Not Invd. (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Returns Deferral Start Date"; Rec."Returns Deferral Start Date")
                {
                    ApplicationArea = none;
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = none;
                }
                field("Routing Reference No."; Rec."Routing Reference No.")
                {
                    ApplicationArea = none;
                }
                field("Safety Lead Time"; Rec."Safety Lead Time")
                {
                    ApplicationArea = none;
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = none;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = none;
                }
                field("Salvage Value"; Rec."Salvage Value")
                {
                    ApplicationArea = none;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = none;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = none;
                }
                field("Special Order"; Rec."Special Order")
                {
                    ApplicationArea = none;
                }
                field("Special Order Sales Line No."; Rec."Special Order Sales Line No.")
                {
                    ApplicationArea = none;
                }
                field("Special Order Sales No."; Rec."Special Order Sales No.")
                {
                    ApplicationArea = none;
                }
                field(StandarCost; Rec.StandarCost)
                {
                    ApplicationArea = none;
                }
                field(Subtype; Rec.Subtype)
                {
                    ApplicationArea = none;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = none;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = none;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = none;
                }
                field(TextoRechazo; Rec.TextoRechazo)
                {
                    ApplicationArea = none;
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = none;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = none;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = none;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = none;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = none;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = none;
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = none;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = none;
                }
                field("Unit of Measure (Cross Ref.)"; Rec."Unit of Measure (Cross Ref.)")
                {
                    ApplicationArea = none;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = none;
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                    ApplicationArea = none;
                }
                field("Use Duplication List"; Rec."Use Duplication List")
                {
                    ApplicationArea = none;
                }
                field("Use Tax"; Rec."Use Tax")
                {
                    ApplicationArea = none;
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = none;
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = none;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = none;
                }
                field("VAT Calculation Type"; Rec."VAT Calculation Type")
                {
                    ApplicationArea = none;
                }
                field("VAT Difference"; Rec."VAT Difference")
                {
                    ApplicationArea = none;
                }
                field("VAT Identifier"; Rec."VAT Identifier")
                {
                    ApplicationArea = none;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = none;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = none;
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = none;
                }
                field("Whse. Outstanding Qty. (Base)"; Rec."Whse. Outstanding Qty. (Base)")
                {
                    ApplicationArea = none;
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ApplicationArea = none;
                }
            }
        }
    }
}
