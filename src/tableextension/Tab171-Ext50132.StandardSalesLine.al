//Precio personalizado en líneas de venta estándar
tableextension 50132 "StandardSalesLine" extends "Standard Sales Line"  //171
{
    LookupPageId = "Standard Sales Code Subform";
    fields
    {
        field(50101; Precio_btc; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Price', comment = 'ESP="Precio"';
        }
    }
}