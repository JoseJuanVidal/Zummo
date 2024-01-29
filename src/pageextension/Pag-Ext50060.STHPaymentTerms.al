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
            field("Es NO Asegurable (Otros)"; "Es NO Asegurable (Otros)")
            {
                ApplicationArea = all;
            }
            field("PayDays Average"; "PayDays Average")
            {
                ApplicationArea = all;
            }
        }
    }
}