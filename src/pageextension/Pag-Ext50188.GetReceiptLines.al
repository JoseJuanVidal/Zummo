pageextension 50188 "GetReceiptLines" extends "Get Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field(CodAlbProveedor_btc; CodAlbProveedor_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}