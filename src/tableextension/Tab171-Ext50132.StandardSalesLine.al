//Precio personalizado en líneas de venta estándar
tableextension 50132 "StandardSalesLine" extends "Standard Sales Line"  //171
{
    fields
    {
        field(50101; Precio_btc; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price', comment = 'ESP="Precio"';
        }
    }
}