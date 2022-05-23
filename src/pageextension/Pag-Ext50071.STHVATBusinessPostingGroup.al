
pageextension 50071 "STH VAT Business Posting Group" extends "VAT Business Posting Groups"
{
    layout
    {
        addlast(Control1)
        {
            field("Cód. Texto Factura"; "Cód. Texto Factura")
            {
                ApplicationArea = all;
            }
        }
    }
}
