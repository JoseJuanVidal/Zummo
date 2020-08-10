tableextension 50140 "PurchCrMemoHdr" extends "Purch. Cr. Memo Hdr."  //124
{
    fields
    {
        //Guardar Nº asiento y Nº documento
        field(50100; NumAsiento_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction No.', comment = 'ESP="Nº asiento"';
        }
    }
}