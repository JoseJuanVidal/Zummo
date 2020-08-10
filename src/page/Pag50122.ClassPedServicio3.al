page 50122 "ClassPedServicio3"
{
    //Clasificación pedido servicio

    PageType = List;
    SourceTable = ClassPedServicioNivel3;
    Caption = 'Clasificación pedido servicio';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(TipoPedidoNivel3_btc; TipoPedidoNivel3_btc)
                {
                    ApplicationArea = All;
                }
                field(DescTipoPedidoNivel3_btc; DescTipoPedidoNivel3_btc)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}