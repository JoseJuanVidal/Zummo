pageextension 50144 "ReleasedProdOrder_btc" extends "Released Production Order"
{
    //Limitar funcionalidad en las OP
    layout
    {

    }

    actions
    {
        modify(RefreshProductionOrder)
        {
            trigger OnBeforeAction()
            var
                LimitaAccionErr: Label 'No se puede realizar esta acción.', Comment = 'Can''t do this action.';
            begin
                Error(LimitaAccionErr);
            end;
        }
    }
}