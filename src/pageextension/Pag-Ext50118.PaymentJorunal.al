pageextension 50118 "PaymentJorunal" extends "Payment Journal"
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
    }

}