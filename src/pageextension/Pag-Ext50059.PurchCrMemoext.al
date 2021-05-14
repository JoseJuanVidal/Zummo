pageextension 50059 "PurchCrMemoext" extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = All;
            }
        }
    }
}