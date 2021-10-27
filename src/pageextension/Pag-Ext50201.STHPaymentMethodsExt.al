pageextension 50201 "STH Payment MethodsExt" extends "Payment Methods"
{
    layout
    {
        addlast(Control1)
        {
            field("Es Contado"; "Es Contado")
            {
                ApplicationArea = all;
            }
            field("Ocultar fecha vto"; "Ocultar fecha vto")
            {
                ApplicationArea = all;
            }
        }
    }
}