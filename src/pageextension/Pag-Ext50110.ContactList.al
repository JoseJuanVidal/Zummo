pageextension 50110 "ContactList" extends "Contact List"  //
{
    layout
    {
        addafter("Territory Code")
        {
            field(EnviarEmailPedCompra_btc; EnviarEmailPedCompra2_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}