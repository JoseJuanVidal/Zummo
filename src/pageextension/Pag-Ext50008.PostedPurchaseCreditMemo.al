pageextension 50008 "PostedPurchaseCreditMemo" extends "Posted Purchase Credit Memo"
{
    //Guardar Nº asiento y Nº documento

    layout
    {
        addafter("Corrected Invoice No.")
        {
            field(NumAsiento_btc; NumAsiento_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}