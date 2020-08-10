tableextension 50131 "TabExtProdOrder_btc" extends "Production Order"   //5406
{
    // Generado para poder enlazar RefOrderNo
    fields
    {
        field(50000; RefOrderNo_btc; Code[20])
        {
            Caption = 'Nº orden ref.', Comment = 'Ref. Order No.';
            DataClassification = EndUserIdentifiableInformation;
        }

    }
}