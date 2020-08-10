pageextension 50015 "ServiceQuote" extends "Service Quote"
{
    layout
    {
        addbefore("Service Order Type")
        {
            field(CodAnterior_btc; CodAnterior_btc)
            {
                ApplicationArea = All;
            }
        }

        addafter("Service Order Type")
        {
            field(TipoPedidoNivel2_btc; TipoPedidoNivel2_btc)
            {
                ApplicationArea = All;
            }

            field(TipoPedidoNivel3_btc; TipoPedidoNivel3_btc)
            {
                ApplicationArea = All;
            }

            field(NumEstanteria_btc; NumEstanteria_btc)
            {
                ApplicationArea = all;
            }

            field(ComentarioAlmacen_btc; ComentarioAlmacen_btc)
            {
                ApplicationArea = all;
            }
  
        }
    }


}