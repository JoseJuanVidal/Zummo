pageextension 50088 "ZM EXT Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addafter("Payment Export Format")
        {
            field("Contrac Confirming Caixabanc"; "Contrac Confirming Caixabanc")
            {
                ApplicationArea = all;
            }
        }
    }
}
