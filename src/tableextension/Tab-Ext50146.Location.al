tableextension 50146 "Location" extends Location
{//14

 //Ordenación almacenes

    fields
    {
        field(50100; Ordenacion_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Ordination', comment = 'ESP="Ordenación"';
            BlankZero = true;
        }
    }
}