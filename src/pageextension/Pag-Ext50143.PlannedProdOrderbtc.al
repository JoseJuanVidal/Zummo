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
                lblConfirm: Label 'Las ordenes de fabricación se realizan con el modulo AddonCDP.¿Desea continuar?', comment = 'ESP="Las ordenes de fabricación se realizan con el modulo AddonCDP.¿Desea continuar?"';
                LimitaAccionErr: Label 'No se puede realizar esta acción.', Comment = 'Can''t do this action.';
            begin
                if not Confirm(lblConfirm) then
                    Error(LimitaAccionErr);
            end;
        }
    }
}