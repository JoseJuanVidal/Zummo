pageextension 50201 "STH Payment MethodsExt" extends "Payment Methods"
{
    layout
    {
        addlast(Control1)
        {
            field("Ocultar fecha vto"; "Ocultar fecha vto")
            {
                ApplicationArea = all;
            }
        }
    }
}