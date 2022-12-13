pageextension 50001 "ServiceOrder" extends "Service Order"
{
    layout
    {
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
            field("Cerrado en plataforma"; "Cerrado en plataforma") { }


            field(NumEstanteria_btc; NumEstanteria_btc)
            {
                ApplicationArea = all;
            }
            field(CodResolucion_btc; CodResolucion_btc)
            {
                ApplicationArea = All;
            }


            field(ComentarioAlmacen_btc; ComentarioAlmacen_btc)
            {
                ApplicationArea = all;
            }

        }

        addafter(Description)
        {
            field("Operation Description"; "Operation Description")
            {
                ApplicationArea = all;
            }

            field("Operation Description 2"; "Operation Description 2")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(Duplicate)
            {
                Caption = 'Duplicar', comment = 'ESP="Duplicar"';
                ApplicationArea = all;
                Image = CopyDocument;

                trigger OnAction()
                begin
                    DuplicateServiceOrder;
                end;
            }
        }


    }

    local procedure DuplicateServiceOrder()
    var
        Funciones: Codeunit Funciones;
    begin
        Funciones.DuplicateServiceOrder(Rec);
    end;

}