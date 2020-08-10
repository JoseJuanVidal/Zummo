tableextension 50175 "Transfer Receipt Header Z" extends "Transfer Receipt Header"  //5746
{
    fields
    {
        field(50102; Peso_btc; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Weight', comment = 'ESP="Peso"';
        }

        field(50103; NumPalets_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of pallets', comment = 'ESP="Nº Palets"';
        }

        field(50104; NumBultos_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of packages', comment = 'ESP="Nº Bultos"';
        }

        field(50105; PedidoImpreso; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Printed Order', comment = 'ESP="Pedido Impreso"';
        }
    }
}