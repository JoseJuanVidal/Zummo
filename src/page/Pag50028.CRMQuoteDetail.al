page 50028 "CRM Quote Detail"
{
    PageType = List;
    SourceTable = "STH CRM Quotedetail";// "CRM Area Manager_btc";
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(QuoteDetailId; QuoteDetailId) { }
                field(QuoteId; QuoteId)
                { }
                field(zum_num_oferta; zum_num_oferta) { }
                field(SalesRepId; SalesRepId) { }
                field(LineItemNumber; LineItemNumber) { }
                field(UoMId; UoMId) { }
                field(ProductId; ProductId) { }
                field(RequestDeliveryBy; RequestDeliveryBy) { }
                field(Quantity; Quantity) { }
                field(PricingErrorCode; PricingErrorCode) { }
                field(ManualDiscountAmount; ManualDiscountAmount) { }
                field(ProductDescription; ProductDescription) { }
                field(VolumeDiscountAmount; VolumeDiscountAmount) { }
                field(PricePerUnit; PricePerUnit) { }
                field(BaseAmount; BaseAmount) { }
                field(ExtendedAmount; ExtendedAmount) { }
                field(Description; Description) { }
                field(ShipTo_Name; ShipTo_Name) { }
                field(IsPriceOverridden; IsPriceOverridden) { }
                field(Tax; Tax) { }
                field(ShipTo_Line1; ShipTo_Line1) { }

                field(ShipTo_Line2; ShipTo_Line2) { }
                field(ShipTo_Line3; ShipTo_Line3) { }
                field(ShipTo_City; ShipTo_City) { }
                field(ShipTo_StateOrProvince; ShipTo_StateOrProvince) { }
                field(ShipTo_Country; ShipTo_Country) { }
                field(ShipTo_PostalCode; ShipTo_PostalCode) { }
                field(WillCall; WillCall) { }
                field(IsProductOverridden; IsProductOverridden) { }
                field(ShipTo_Telephone; ShipTo_Telephone) { }
                field(ShipTo_Fax; ShipTo_Fax) { }
                field(ShipTo_FreightTermsCode; ShipTo_FreightTermsCode) { }
                field(ProductIdName; ProductIdName) { }
                field(UoMIdName; UoMIdName) { }
                field(SalesRepIdName; SalesRepIdName) { }
                field(QuoteStateCode; QuoteStateCode) { }
                field(ShipTo_AddressId; ShipTo_AddressId) { }
                field(ShipTo_ContactName; ShipTo_ContactName) { }
                field(TransactionCurrencyId; TransactionCurrencyId) { }
                field(ExchangeRate; ExchangeRate) { }

                field(Tax_Base; Tax_Base) { }
                field(ExtendedAmount_Base; ExtendedAmount_Base) { }
                field(PricePerUnit_Base; PricePerUnit_Base) { }
                field(TransactionCurrencyIdName; TransactionCurrencyIdName) { }
                field(BaseAmount_Base; BaseAmount_Base) { }
                field(ManualDiscountAmount_Base; ManualDiscountAmount_Base) { }
                field(VolumeDiscountAmount_Base; VolumeDiscountAmount_Base) { }
                field(CreatedOnBehalfByName; CreatedOnBehalfByName) { }
                field(ModifiedOnBehalfByName; ModifiedOnBehalfByName) { }
                field(SequenceNumber; SequenceNumber) { }
                field(PropertyConfigurationStatus; PropertyConfigurationStatus) { }
                field(ProductAssociationId; ProductAssociationId) { }
                field(ParentBundleId; ParentBundleId) { }
                field(ProductTypeCode; ProductTypeCode) { }



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
                field(VersionNumber; VersionNumber) { ApplicationArea = All; }
                field(ImportSequenceNumber; ImportSequenceNumber) { ApplicationArea = All; }
                field(OverriddenCreatedOn; OverriddenCreatedOn) { ApplicationArea = All; }
                field(TimeZoneRuleVersionNumber; TimeZoneRuleVersionNumber) { ApplicationArea = All; }
                field(UTCConversionTimeZoneCode; UTCConversionTimeZoneCode) { ApplicationArea = All; }
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
                    CDS: Record "CRM AreaManager_crm_btc";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CurrPage.SetSelectionFilter(CDS);
                    CRMIntegrationManagement.CreateNewRecordsFromCRM(CDS);
                end;
            }
        }
    }

    var
        CurrentlyCoupledCDSWorker: Record "CRM AreaManager_crm_btc";

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    procedure SetCurrentlyCoupledCDSWorker(CDS: Record "CRM AreaManager_crm_btc")
    begin
        CurrentlyCoupledCDSWorker := CDS;
    end;
}