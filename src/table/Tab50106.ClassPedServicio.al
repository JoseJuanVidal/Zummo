table 50106 "ClassPedServicio"
{
    //Clasificación pedido servicio

    DataClassification = CustomerContent;
    Caption = 'Order service classification', comment = 'ESP="Clasificación pedidos servicio"';
    DrillDownPageId = "Clasificación pedido servicio";
    LookupPageId = "Clasificación pedido servicio";

    fields
    {
        field(1; TipoPedidoNivel1_btc; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type order service level 1', comment = 'ESP="Tipo pedido servicio nivel 1"';
            TableRelation = "Service Order Type".Code;
        }

        field(2; TipoPedidoNivel2_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Type order service level 2', comment = 'ESP="Tipo pedido servicio nivel 2"';
        }

        field(3; DescTipoPedidoNivel2_btc; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description order service level 2', comment = 'ESP="Descripción pedido servicio nivel 2"';
        }
    }

    keys
    {
        key(PK; TipoPedidoNivel1_btc, TipoPedidoNivel2_btc)
        {
            Clustered = true;
        }
    }
}