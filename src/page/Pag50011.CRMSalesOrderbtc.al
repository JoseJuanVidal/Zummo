page 50011 "CRM Sales Order btc"
{

    Caption = 'CRM Sales Order';
    PageType = List;
    SourceTable = "CRM Salesorder";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(AccountId; Rec.AccountId)
                {
                    ApplicationArea = All;
                }
                field(AccountIdName; Rec.AccountIdName)
                {
                    ApplicationArea = All;
                }
                field(BillTo_AddressId; Rec.BillTo_AddressId)
                {
                    ApplicationArea = All;
                }
                field(BillTo_City; Rec.BillTo_City)
                {
                    ApplicationArea = All;
                }
                field(BillTo_Composite; Rec.BillTo_Composite)
                {
                    ApplicationArea = All;
                }
                field(BillTo_ContactName; Rec.BillTo_ContactName)
                {
                    ApplicationArea = All;
                }
                field(BillTo_Country; Rec.BillTo_Country)
                {
                    ApplicationArea = All;
                }
                field(BillTo_Fax; Rec.BillTo_Fax)
                {
                    ApplicationArea = All;
                }
                field(BillTo_Line1; Rec.BillTo_Line1)
                {
                    ApplicationArea = All;
                }
                field(BillTo_Line2; Rec.BillTo_Line2)
                {
                    ApplicationArea = All;
                }
                field(BillTo_Line3; Rec.BillTo_Line3)
                {
                    ApplicationArea = All;
                }
                field(BillTo_Name; Rec.BillTo_Name)
                {
                    ApplicationArea = All;
                }
                field(BillTo_PostalCode; Rec.BillTo_PostalCode)
                {
                    ApplicationArea = All;
                }
                field(BillTo_StateOrProvince; Rec.BillTo_StateOrProvince)
                {
                    ApplicationArea = All;
                }
                field(BillTo_Telephone; Rec.BillTo_Telephone)
                {
                    ApplicationArea = All;
                }
                field(ContactId; Rec.ContactId)
                {
                    ApplicationArea = All;
                }
                field(ContactIdName; Rec.ContactIdName)
                {
                    ApplicationArea = All;
                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    ApplicationArea = All;
                }
                field(CreatedByName; Rec.CreatedByName)
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
                field(CreatedOnBehalfByName; Rec.CreatedOnBehalfByName)
                {
                    ApplicationArea = All;
                }
                field(CustomerId; Rec.CustomerId)
                {
                    ApplicationArea = All;
                }
                field(CustomerIdType; Rec.CustomerIdType)
                {
                    ApplicationArea = All;
                }
                field(DateFulfilled; Rec.DateFulfilled)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(DiscountAmount; Rec.DiscountAmount)
                {
                    ApplicationArea = All;
                }
                field(DiscountAmount_Base; Rec.DiscountAmount_Base)
                {
                    ApplicationArea = All;
                }
                field(DiscountPercentage; Rec.DiscountPercentage)
                {
                    ApplicationArea = All;
                }
                field(EntityImageId; Rec.EntityImageId)
                {
                    ApplicationArea = All;
                }
                field(ExchangeRate; Rec.ExchangeRate)
                {
                    ApplicationArea = All;
                }
                field(FreightAmount; Rec.FreightAmount)
                {
                    ApplicationArea = All;
                }
                field(FreightAmount_Base; Rec.FreightAmount_Base)
                {
                    ApplicationArea = All;
                }
                field(FreightTermsCode; Rec.FreightTermsCode)
                {
                    ApplicationArea = All;
                }
                field(ImportSequenceNumber; Rec.ImportSequenceNumber)
                {
                    ApplicationArea = All;
                }
                field(IsPriceLocked; Rec.IsPriceLocked)
                {
                    ApplicationArea = All;
                }
                field(LastBackofficeSubmit; Rec.LastBackofficeSubmit)
                {
                    ApplicationArea = All;
                }
                field(ModifiedBy; Rec.ModifiedBy)
                {
                    ApplicationArea = All;
                }
                field(ModifiedByName; Rec.ModifiedByName)
                {
                    ApplicationArea = All;
                }
                field(ModifiedOn; Rec.ModifiedOn)
                {
                    ApplicationArea = All;
                }
                field(ModifiedOnBehalfBy; Rec.ModifiedOnBehalfBy)
                {
                    ApplicationArea = All;
                }
                field(ModifiedOnBehalfByName; Rec.ModifiedOnBehalfByName)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(OpportunityId; Rec.OpportunityId)
                {
                    ApplicationArea = All;
                }
                field(OpportunityIdName; Rec.OpportunityIdName)
                {
                    ApplicationArea = All;
                }
                field(OrderNumber; Rec.OrderNumber)
                {
                    ApplicationArea = All;
                }
                field(OverriddenCreatedOn; Rec.OverriddenCreatedOn)
                {
                    ApplicationArea = All;
                }
                field(OwnerId; Rec.OwnerId)
                {
                    ApplicationArea = All;
                }
                field(OwnerIdType; Rec.OwnerIdType)
                {
                    ApplicationArea = All;
                }
                field(OwningBusinessUnit; Rec.OwningBusinessUnit)
                {
                    ApplicationArea = All;
                }
                field(OwningTeam; Rec.OwningTeam)
                {
                    ApplicationArea = All;
                }
                field(OwningUser; Rec.OwningUser)
                {
                    ApplicationArea = All;
                }
                field(PaymentTermsCode; Rec.PaymentTermsCode)
                {
                    ApplicationArea = All;
                }
                field(PriceLevelId; Rec.PriceLevelId)
                {
                    ApplicationArea = All;
                }
                field(PriceLevelIdName; Rec.PriceLevelIdName)
                {
                    ApplicationArea = All;
                }
                field(PricingErrorCode; Rec.PricingErrorCode)
                {
                    ApplicationArea = All;
                }
                field(PriorityCode; Rec.PriorityCode)
                {
                    ApplicationArea = All;
                }
                field(ProcessId; Rec.ProcessId)
                {
                    ApplicationArea = All;
                }
                field(QuoteId; Rec.QuoteId)
                {
                    ApplicationArea = All;
                }
                field(QuoteIdName; Rec.QuoteIdName)
                {
                    ApplicationArea = All;
                }
                field(RequestDeliveryBy; Rec.RequestDeliveryBy)
                {
                    ApplicationArea = All;
                }
                field(SalesOrderId; Rec.SalesOrderId)
                {
                    ApplicationArea = All;
                }
                field(ShippingMethodCode; Rec.ShippingMethodCode)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_AddressId; Rec.ShipTo_AddressId)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_City; Rec.ShipTo_City)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_Composite; Rec.ShipTo_Composite)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_ContactName; Rec.ShipTo_ContactName)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_Country; Rec.ShipTo_Country)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_Fax; Rec.ShipTo_Fax)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_FreightTermsCode; Rec.ShipTo_FreightTermsCode)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_Line1; Rec.ShipTo_Line1)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_Line2; Rec.ShipTo_Line2)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_Line3; Rec.ShipTo_Line3)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_Name; Rec.ShipTo_Name)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_PostalCode; Rec.ShipTo_PostalCode)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_StateOrProvince; Rec.ShipTo_StateOrProvince)
                {
                    ApplicationArea = All;
                }
                field(ShipTo_Telephone; Rec.ShipTo_Telephone)
                {
                    ApplicationArea = All;
                }
                field(StageId; Rec.StageId)
                {
                    ApplicationArea = All;
                }
                field(StateCode; Rec.StateCode)
                {
                    ApplicationArea = All;
                }
                field(StatusCode; Rec.StatusCode)
                {
                    ApplicationArea = All;
                }
                field(SubmitDate; Rec.SubmitDate)
                {
                    ApplicationArea = All;
                }
                field(SubmitStatus; Rec.SubmitStatus)
                {
                    ApplicationArea = All;
                }
                field(SubmitStatusDescription; Rec.SubmitStatusDescription)
                {
                    ApplicationArea = All;
                }
                field(TimeZoneRuleVersionNumber; Rec.TimeZoneRuleVersionNumber)
                {
                    ApplicationArea = All;
                }
                field(TotalAmount; Rec.TotalAmount)
                {
                    ApplicationArea = All;
                }
                field(TotalAmount_Base; Rec.TotalAmount_Base)
                {
                    ApplicationArea = All;
                }
                field(TotalAmountLessFreight; Rec.TotalAmountLessFreight)
                {
                    ApplicationArea = All;
                }
                field(TotalAmountLessFreight_Base; Rec.TotalAmountLessFreight_Base)
                {
                    ApplicationArea = All;
                }
                field(TotalDiscountAmount; Rec.TotalDiscountAmount)
                {
                    ApplicationArea = All;
                }
                field(TotalDiscountAmount_Base; Rec.TotalDiscountAmount_Base)
                {
                    ApplicationArea = All;
                }
                field(TotalLineItemAmount; Rec.TotalLineItemAmount)
                {
                    ApplicationArea = All;
                }
                field(TotalLineItemAmount_Base; Rec.TotalLineItemAmount_Base)
                {
                    ApplicationArea = All;
                }
                field(TotalLineItemDiscountAmount; Rec.TotalLineItemDiscountAmount)
                {
                    ApplicationArea = All;
                }
                field(TotalLineItemDiscountAmount_Ba; Rec.TotalLineItemDiscountAmount_Ba)
                {
                    ApplicationArea = All;
                }
                field(TotalTax; Rec.TotalTax)
                {
                    ApplicationArea = All;
                }
                field(TotalTax_Base; Rec.TotalTax_Base)
                {
                    ApplicationArea = All;
                }
                field(TransactionCurrencyId; Rec.TransactionCurrencyId)
                {
                    ApplicationArea = All;
                }
                field(TransactionCurrencyIdName; Rec.TransactionCurrencyIdName)
                {
                    ApplicationArea = All;
                }
                field(TraversedPath; Rec.TraversedPath)
                {
                    ApplicationArea = All;
                }
                field(UTCConversionTimeZoneCode; Rec.UTCConversionTimeZoneCode)
                {
                    ApplicationArea = All;
                }
                field(VersionNumber; Rec.VersionNumber)
                {
                    ApplicationArea = All;
                }
                field(WillCall; Rec.WillCall)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
