pageextension 50118 "PaymentJournal" extends "Payment Journal"
{
    layout
    {
        addafter("Credit Amount")
        {
            field("Currency Factor"; "Currency Factor")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter(Amount)
        {
            field("Purch. Request less 200"; "Purch. Request less 200")
            {
                ApplicationArea = all;

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }

}