page 50025 "CRM Canal_crm_btc"
{
    PageType = List;
    SourceTable = "CRM Canal_crm_btc"; // "CRM FormasPago_btc";
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                // add fields to display on the page
                field(zum_bccanalId; zum_bccanalId) { ApplicationArea = All; }
                field(zum_Name; zum_Name) { ApplicationArea = All; }
            }
        }


    }

    actions
    {
        area(processing)
        {
            action(CreateFromCDS)
            {
                ApplicationArea = All;
                Caption = 'Create in Business Central', comment = 'ESP="Crear en Bussiness Central"';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate the entity from the coupled Common Data Service data.', comment = 'ESP="Generar la entidad desde el dato emparejado del Common Data Service"';
                trigger OnAction()
                var
                    CDS: Record "CRM FormasPago_crm_btc"; // "CRM FormasPago_btc";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CurrPage.SetSelectionFilter(CDS);
                    CRMIntegrationManagement.CreateNewRecordsFromCRM(CDS);
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