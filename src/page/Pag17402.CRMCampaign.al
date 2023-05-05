page 17402 "CRM Campaign"
{
    Caption = 'CRM Campaign';
    PageType = List;
    SourceTable = "CRM Campaign";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(campaignid; Rec.campaignid)
                {
                    ApplicationArea = All;
                }
                field(codename; Rec.codename)
                {
                    ApplicationArea = All;
                }
                field(name; Rec.name)
                {
                    ApplicationArea = All;
                }
                field(description; Rec.description)
                {
                    ApplicationArea = All;
                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    ApplicationArea = All;
                }
                field(CreatedOn; Rec.CreatedOn)
                {
                    ApplicationArea = All;
                }
                field(CreatedOnBehalfBy; Rec.CreatedOnBehalfBy)
                {
                    ApplicationArea = All;
                }
                field(ModifiedBy; Rec.ModifiedBy)
                {
                    ApplicationArea = All;
                }
                field(ModifiedOn; Rec.ModifiedOn)
                {
                    ApplicationArea = All;
                }
                field(OwnerId; Rec.OwnerId)
                {
                    ApplicationArea = All;
                }
                field(ModifiedOnBehalfBy; Rec.ModifiedOnBehalfBy)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
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
    var
        CurrentlyCoupledCDS: Record "CRM Delegado_crm_btc"; // "CRM Delegado_btc";

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    procedure SetCurrentlyCoupledCDSWorker(CDS: Record "CRM Delegado_crm_btc") // "CRM Delegado_btc")
    begin
        CurrentlyCoupledCDS := CDS;
    end;
}
