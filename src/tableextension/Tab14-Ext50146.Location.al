tableextension 50146 "Location" extends Location  //14
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
        field(50101; RequiredShipinvoice; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Not allow "Ship and Invoice" without send complety', comment = 'ESP="No permitir "Enviar y Facturar" sin envio completo"';
            BlankZero = true;
        }
    }
}