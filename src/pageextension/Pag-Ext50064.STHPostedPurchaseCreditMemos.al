pageextension 50064 "STH PostedPurchaseCreditMemos" extends "Posted Purchase Credit Memos"
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
    begin


        ImpTotalDL := 0;
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::"Credit Memo");
        VendorLedgerEntry.SetRange("Document No.", "No.");
        VendorLedgerEntry.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
        if VendorLedgerEntry.FindSet() then begin
            VendorLedgerEntry.CalcFields("Amount (LCY)");
            ImpTotalDL := VendorLedgerEntry."Amount (LCY)";
        end;

        BaseImpDL := 0;
        PurchCRMemoLine.Reset();
        PurchCRMemoLine.SetRange("Document No.", Rec."No.");
        if PurchCRMemoLine.FindSet() then begin
            PurchCRMemoLine.CalcSums(Amount);
            if rec."Currency Factor" = 0 then
                BaseImpDL := PurchCRMemoLine.Amount
            else
                BaseImpDL := PurchCRMemoLine.Amount / rec."Currency Factor";
        end;
    end;


    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchCRMemoLine: Record "Purch. Cr. Memo Line";
        BaseImpDL: Decimal;
        ImpTotalDL: Decimal;
}