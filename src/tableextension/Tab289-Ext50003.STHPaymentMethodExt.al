tableextension 50003 "STH Payment MethodExt" extends "Payment Method" //289
{
    fields
    {
        Field(50000; "Es Contado"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Es Contado', comment = 'ESP="Es Contado"';
        }
    }

    var
        myInt: Integer;
}