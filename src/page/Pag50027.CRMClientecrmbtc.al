page 50027 "CRM Cliente_crm_btc"
{
    PageType = List;
    SourceTable = "CRM Account_crm_btc"; // "CRM FormasPago_btc";
    //Editable = false;
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
                field(WebSiteURL; WebSiteURL) { ApplicationArea = All; }
                field(EMailAddress1; EMailAddress1) { ApplicationArea = All; }
                field(EMailAddress2; EMailAddress2) { ApplicationArea = All; }
                field(Telephone1; Telephone1) { ApplicationArea = All; }
                field(Fax; Fax) { ApplicationArea = All; }
                field(CreditLimit; CreditLimit) { ApplicationArea = All; }
                field(Address1_ShippingMethodCode; Address1_ShippingMethodCode) { ApplicationArea = All; }
                field(Address2_PrimaryContactName; Address2_PrimaryContactName) { ApplicationArea = All; }
                field(Address2_Line1; Address2_Line1) { ApplicationArea = All; }
                field(Address2_Line2; Address2_Line2) { ApplicationArea = All; }

                field(Address2_City; Address2_City) { ApplicationArea = All; }
                field(Address2_StateOrProvince; Address2_StateOrProvince) { ApplicationArea = All; }
                field(Address2_PostalCode; Address2_PostalCode) { ApplicationArea = All; }
                field(NAddress2_FreightTermsCodeme; Address2_FreightTermsCode) { ApplicationArea = All; }
                field(bit_BCPais; bit_BCPais) { ApplicationArea = All; }
                field(zum_Descuento1; zum_Descuento1) { ApplicationArea = All; }
                field(zum_Descuento2; zum_Descuento2) { ApplicationArea = All; }
                field(zum_Prepago; zum_Prepago) { ApplicationArea = All; }
                field(zum_Creditointerno; zum_Creditointerno) { ApplicationArea = All; }
                field(zum_Creditoautorizadopor; zum_Creditoautorizadopor) { ApplicationArea = All; }
                field(zum_Creditoaseguradora; zum_Creditoaseguradora) { ApplicationArea = All; }
                field(zum_creditoaseguradora_Base; zum_creditoaseguradora_Base) { ApplicationArea = All; }
                field(zum_Formadepagosolicitada; zum_Formadepagosolicitada) { ApplicationArea = All; }
                field(zum_bcareamanager; zum_bcareamanager) { ApplicationArea = All; }
                field(zum_bcdelegado; zum_bcdelegado) { ApplicationArea = All; }
                field(zum_bcclientecorporativo; zum_bcclientecorporativo) { ApplicationArea = All; }
                field(zum_grupodecliente; zum_grupodecliente) { ApplicationArea = All; }
                field(zum_bcactividadcliente; zum_bcactividadcliente) { ApplicationArea = All; }
                field(bit_bcformadepago; bit_bcformadepago) { ApplicationArea = All; }
                field(bit_bcterminosdepago; bit_bcterminosdepago) { ApplicationArea = All; }
                field(DefaultPriceLevelId; DefaultPriceLevelId) { ApplicationArea = All; }
                field(bit_centralcompras; bit_centralcompras) { ApplicationArea = All; }
                field(Zum_canal; Zum_canal) { ApplicationArea = All; }
                field(PrimaryContactId; PrimaryContactId) { ApplicationArea = All; }
                field(bit_subclientebc; bit_subclientebc) { ApplicationArea = All; }
                field(bit_centraldecompras; bit_centraldecompras) { ApplicationArea = All; }
                field(bit_grupodedescuento; bit_grupodedescuento) { ApplicationArea = All; }
                field(bit_idioma; bit_idioma) { ApplicationArea = All; }
                field(zum_mercado; zum_mercado) { ApplicationArea = all; }
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