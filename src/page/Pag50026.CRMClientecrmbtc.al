page 50026 "CRM Cliente_crm_btc"
{
    PageType = List;
    SourceTable = "CRM Account_crm_btc"; // "CRM FormasPago_btc";
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
                field(CreatedOn; CreatedOn) { ApplicationArea = All; }

                field(CreatedBy; CreatedBy) { ApplicationArea = All; }
                field(ModifiedOn; ModifiedOn) { ApplicationArea = All; }
                field(ModifiedBy; ModifiedBy) { ApplicationArea = All; }
                field(CreatedOnBehalfBy; CreatedOnBehalfBy) { ApplicationArea = All; }
                field(ModifiedOnBehalfBy; ModifiedOnBehalfBy) { ApplicationArea = All; }
                field(OwnerId; OwnerId) { ApplicationArea = All; }
                field(OwnerIdType; OwnerIdType) { ApplicationArea = All; }
                field(OwningBusinessUnit; OwningBusinessUnit) { ApplicationArea = All; }
                field(OwningUser; OwningUser) { ApplicationArea = All; }
                field(OwningTeam; OwningTeam) { ApplicationArea = All; }
                field(statecode; statecode) { ApplicationArea = All; }
                field(statuscode; statuscode) { ApplicationArea = All; }
                field(VersionNumber; VersionNumber) { ApplicationArea = All; }
                field(ImportSequenceNumber; ImportSequenceNumber) { ApplicationArea = All; }
                field(OverriddenCreatedOn; OverriddenCreatedOn) { ApplicationArea = All; }
                field(TimeZoneRuleVersionNumber; TimeZoneRuleVersionNumber) { ApplicationArea = All; }
                field(UTCConversionTimeZoneCode; UTCConversionTimeZoneCode) { ApplicationArea = All; }
                field(AccountId; AccountId) { ApplicationArea = All; }
                field(AccountNumber; AccountNumber) { ApplicationArea = All; }
                field(Name; Name) { ApplicationArea = All; }

                field(zum_Formadepagosolicitada; zum_Formadepagosolicitada) { ApplicationArea = All; }
                field(bit_centraldecompras; bit_centraldecompras) { ApplicationArea = All; }
                field(bit_grupodedescuento; bit_grupodedescuento) { ApplicationArea = All; }
                field(bit_subcliente; bit_subcliente) { ApplicationArea = All; }
                field(bit_idioma; bit_idioma) { ApplicationArea = All; }
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