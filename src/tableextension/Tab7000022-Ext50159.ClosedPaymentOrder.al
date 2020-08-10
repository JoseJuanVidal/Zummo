tableextension 50159 "ClosedPaymentOrder" extends "Closed Payment Order"  //7000022
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