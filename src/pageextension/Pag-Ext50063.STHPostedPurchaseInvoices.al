pageextension 50063 "STH PostedPurchaseInvoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field("Importe (DL)"; BaseImpDL)
            {
                ApplicationArea = all;
            }
            field("Importe IVA Incl. (DL)"; ImpTotalDL)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    var
    begin


        ImpTotalDL := 0;
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendorLedgerEntry.SetRange("Document No.", "No.");
        VendorLedgerEntry.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
        if VendorLedgerEntry.FindSet() then begin
            VendorLedgerEntry.CalcFields("Amount (LCY)");
            ImpTotalDL := -VendorLedgerEntry."Amount (LCY)";
        end;

        BaseImpDL := 0;
        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document No.", Rec."No.");
        if PurchInvLine.FindSet() then begin
            PurchInvLine.CalcSums(Amount);
            if rec."Currency Factor" = 0 then
                BaseImpDL := PurchInvLine.Amount
            else
                BaseImpDL := PurchInvLine.Amount / rec."Currency Factor";
        end;
    end;


    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvLine: Record "Purch. Inv. Line";
        BaseImpDL: Decimal;
        ImpTotalDL: Decimal;
}