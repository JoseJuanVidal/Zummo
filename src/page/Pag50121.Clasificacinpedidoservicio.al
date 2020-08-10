page 50121 "Clasificación pedido servicio"
{
    //Clasificación pedido servicio

    PageType = List;
    SourceTable = ClassPedServicio;
    Caption = 'Clasificación pedido servicio';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TipoPedidoNivel2_btc; TipoPedidoNivel2_btc)
                {
                    ApplicationArea = All;
                }
                field(DescTipoPedidoNivel2_btc; DescTipoPedidoNivel2_btc)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
