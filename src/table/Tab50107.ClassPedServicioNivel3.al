table 50107 "ClassPedServicioNivel3"
{
    //Clasificación pedido servicio 

    DataClassification = ToBeClassified;
    Caption = 'Order service classification', comment = 'ESP="Clasificación pedidos servicio"';
    DrillDownPageId = ClassPedServicio3;
    LookupPageId = ClassPedServicio3;

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
            TableRelation = ClassPedServicio.TipoPedidoNivel2_btc where(
                TipoPedidoNivel1_btc = field(TipoPedidoNivel1_btc)
            );
        }

        field(3; TipoPedidoNivel3_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Type order service level 3', comment = 'ESP="Tipo pedido servicio nivel 3"';
        }

        field(4; DescTipoPedidoNivel3_btc; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description order service level 3', comment = 'ESP="Descripción pedido servicio nivel 3"';
        }
    }

    keys
    {
        key(PK; TipoPedidoNivel1_btc, TipoPedidoNivel2_btc, TipoPedidoNivel3_btc)
        {
            Clustered = true;
        }
    }
}