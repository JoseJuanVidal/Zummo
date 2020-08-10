pageextension 50007 "PostedPurchaseInvoice" extends "Posted Purchase Invoice"
{
    //Guardar Nº asiento y Nº documento

    layout
    {
        addafter("Vendor Invoice No.")
        {
            field(NumAsiento_btc; NumAsiento_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}