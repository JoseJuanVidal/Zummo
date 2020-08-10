pageextension 50189 "BankAccountList" extends "Bank Account List"
{
    layout
    {
        addafter(Contact)
        {
            field(Balance; Balance)
            {
                ApplicationArea = All;
            }

            field("Balance at Date"; "Balance at Date")
            {
                ApplicationArea = All;
            }

            field("Balance (LCY)"; "Balance (LCY)")
            {
                ApplicationArea = All;
            }

            field("Balance at Date (LCY)"; "Balance at Date (LCY)")
            {
                ApplicationArea = All;
            }
        }
    }
}