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
        // partes JotForm (AddonSGA los lee por RecordRef con estos nº de campo): valor del qid 13
        // y grupos de la ficha del parte que se ven (ninguno marcado = se ven todos)
        field(4; "JotForm Service Type"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'JotForm Service Type', comment = 'ESP="Tipo Servicio JotForm"';
        }
        field(5; "Show Installation Group"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show Installation/Training Group', comment = 'ESP="Ver grupo Instalación/Formación"';
        }
        field(6; "Show Corrective Group"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show Corrective Group', comment = 'ESP="Ver grupo Correctivo"';
        }
        field(7; "Show Counters Group"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show Counters Group', comment = 'ESP="Ver grupo Contadores"';
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