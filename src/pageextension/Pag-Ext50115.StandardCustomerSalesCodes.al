pageextension 50115 "StandardCustomerSalesCodes" extends "Standard Customer Sales Codes"
{
    layout
    {
        addafter("Customer No.")
        {
            field("Customer Name"; "Customer Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Valid To date")
        {
            field(Active; Active)
            {
                ApplicationArea = all;
            }
            field(Periodicidad_btc; Periodicidad_btc)
            {
                ApplicationArea = All;
            }

            field(UltimaFechaFactura_btc; UltimaFechaFactura_btc)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(ProximaFechaFactura_btc; ProximaFechaFactura_btc)
            {
                ApplicationArea = All;
            }
            field("Amount Lines"; "Amount Lines")
            {
                ApplicationArea = all;
            }
        }
    }
}