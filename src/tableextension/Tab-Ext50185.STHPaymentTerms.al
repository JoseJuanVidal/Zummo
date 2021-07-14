tableextension 50185 "STH Payment Terms" extends "Payment Terms"
{
    fields
    {
        field(50000; "Es Contado"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Es contado', comment = 'ESP="Es Contado"';
        }
    }
}