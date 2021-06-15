pageextension 50060 "STH Payment Terms" extends "Payment Terms"
{
    layout
    {
        addlast(Control1)
        {
            field("Es Contado"; "Es Contado")
            {
                ApplicationArea = all;
            }
        }
    }
}