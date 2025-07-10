page 50121 "Clasificación pedido servicio"
{
    //Clasificación pedido servicio
    ApplicationArea = all;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = ClassPedServicio;
    Caption = 'Clasificación pedido servicio';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TipoPedidoNivel1_btc; TipoPedidoNivel1_btc)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
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
