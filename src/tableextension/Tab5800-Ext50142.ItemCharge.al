tableextension 50142 "ItemCharge" extends "Item Charge"  //5800
{
    //Descuento cargos producto

    fields
    {
        field(50100; OmiteDescuentos_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Skip discounts', comment = 'ESP="Omite descuentos"';
        }
    }
}