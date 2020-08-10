pageextension 50010 "ItemCharges" extends "Item Charges"
{
    //Descuento cargos producto

    layout
    {
        addafter("Search Description")
        {
            field(OmiteDescuentos_btc; OmiteDescuentos_btc)
            {
                ApplicationArea = All;
                Visible = false;  // El estándar no aplica descuentos de factura a los cargos de producto
            }
        }
    }
}