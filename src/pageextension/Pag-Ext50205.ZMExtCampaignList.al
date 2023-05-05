pageextension 50205 "ZM Ext Campaign List" extends "Campaign List"
{
    actions
    {
        addafter("Sales &Line Discounts")
        {
            action(CRMSinc)
            {
                Caption = 'Sync. CRM Campaign', comment = 'ESP="Sincronizar Campañas CRM"';
                ApplicationArea = All;
                Visible = true;
                Image = RefreshText;
                ToolTip = 'Update Campingn CRM.', comment = 'ESP="Actualiza campañas del CRM"';
                trigger OnAction()
                var
                    CRMIntegrationManagement: Codeunit Integracion_crm_btc;
                begin
                    CRMIntegrationManagement.UpdateCRMCampaign;
                end;
            }
        }
    }

}
