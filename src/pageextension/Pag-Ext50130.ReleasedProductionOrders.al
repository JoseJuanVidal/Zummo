pageextension 50130 "ReleasedProductionOrders" extends "Released Production Orders"
{
    actions
    {
        addbefore("Change &Status")
        {
            action(DeleteRange)
            {
                ApplicationArea = All;
                Image = DeleteAllBreakpoints;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Delete several', comment = 'ESP="Borrar varias"';
                ToolTip = 'It allows you to delete several production orders at once by selecting the ones you wish to delete',
                    comment = 'ESP="Permite borrar varias ordenes de producción a la vez seleccionando las que se deseen borrar"';

                trigger OnAction()
                var
                    labelConfirm: Label 'Do you want to delete the selected orders?', comment = 'ESP="¿Desea borrar las ordenes seleccionadas?"';
                    recProdOrders: Record "Production Order";
                begin
                    if not Confirm(labelConfirm) then
                        exit;

                    CurrPage.SetSelectionFilter(recProdOrders);
                    recProdOrders.DeleteAll(true);
                end;
            }

            action(StatusRange)
            {
                ApplicationArea = All;
                Image = NewStatusChange;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Caption = 'Change multiple OP status', comment = 'ESP="Cambiar estado múltiples OP"';
                ToolTip = 'Change the status to several OPs at once',
                    comment = 'ESP="Permite cambiar el estado a varias OP a la vez"';

                trigger OnAction()
                var
                    recProdOrders: Record "Production Order";
                    cduFunFabricacion: Codeunit FuncionesFabricacion;
                begin
                    CurrPage.SetSelectionFilter(recProdOrders);

                    Clear(cduFunFabricacion);
                    cduFunFabricacion.CambiaEstadoVariasOrdenesProduccion(recProdOrders);
                end;
            }
        }
    }
}