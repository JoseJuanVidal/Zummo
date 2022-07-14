pageextension 50073 "Vendor Posting Groups" extends "Vendor Posting Groups"
{
    layout
    {
        addafter(ShowAllAccounts)
        {
            field("Gen. Business Posting Group"; "Gen. Business Posting Group")
            {
                ApplicationArea = all;
            }
        }
    }
}
