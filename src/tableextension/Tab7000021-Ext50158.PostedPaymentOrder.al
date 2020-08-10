tableextension 50158 "PostedPaymentOrder" extends "Posted Payment Order"  //7000021
{
    fields
    {
        field(50100; DueDate_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date', comment = 'ESP="Fecha Pago"';
        }
    }
}