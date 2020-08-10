// Precio personalizado en líneas de venta estándar
pageextension 50145 "StandardSalesCodeSubform" extends "Standard Sales Code Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(Precio_btc; Precio_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}