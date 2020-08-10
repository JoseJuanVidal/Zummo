pageextension 50143 "PlannedProdOrder_btc" extends "Planned Production Order"
{
    //Limitar funcionalidad en las OP
    layout
    {

    }

    actions
    {
        modify("Re&fresh Production Order")
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