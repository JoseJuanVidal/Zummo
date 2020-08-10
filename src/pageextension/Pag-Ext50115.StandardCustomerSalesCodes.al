pageextension 50115 "StandardCustomerSalesCodes" extends "Standard Customer Sales Codes"
{
    layout
    {
        addafter("Valid To date")
        {
            field(Periodicidad_btc; Periodicidad_btc)
            {
                ApplicationArea = All;
            }

            field(UltimaFechaFactura_btc; UltimaFechaFactura_btc)
            {
                ApplicationArea = All;
            }

            field(ProximaFechaFactura_btc; ProximaFechaFactura_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}