tableextension 50139 "PurchInvHeader" extends "Purch. Inv. Header"  //122
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