page 50029 "CRM Quote"
{

    ApplicationArea = All;
    Caption = 'CRM Quote';
    PageType = List;
    SourceTable = "STH CRM Quote";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(AccountId; Rec.AccountId)
                {
                    ToolTip = 'Specifies the value of the Account field';
                    ApplicationArea = All;
                }
                field(AccountIdName; Rec.AccountIdName)
                {
                    ToolTip = 'Specifies the value of the AccountIdName field';
                    ApplicationArea = All;
                }
                field(BillTo_AddressId; Rec.BillTo_AddressId)
                {
                    ToolTip = 'Specifies the value of the Bill To Address ID field';
                    ApplicationArea = All;
                }
                field(BillTo_City; Rec.BillTo_City)
                {
                    ToolTip = 'Specifies the value of the Bill To City field';
                    ApplicationArea = All;
                }
                field(BillTo_Composite; Rec.BillTo_Composite)
                {
                    ToolTip = 'Specifies the value of the Bill To Address field';
                    ApplicationArea = All;
                }
                field(BillTo_ContactName; Rec.BillTo_ContactName)
                {
                    ToolTip = 'Specifies the value of the Bill To Contact Name field';
                    ApplicationArea = All;
                }
                field(BillTo_Country; Rec.BillTo_Country)
                {
                    ToolTip = 'Specifies the value of the Bill To Country/Region field';
                    ApplicationArea = All;
                }
                field(BillTo_Fax; Rec.BillTo_Fax)
                {
                    ToolTip = 'Specifies the value of the Bill To Fax field';
                    ApplicationArea = All;
                }
                field(BillTo_Line1; Rec.BillTo_Line1)
                {
                    ToolTip = 'Specifies the value of the Bill To Street 1 field';
                    ApplicationArea = All;
                }
                field(BillTo_Line2; Rec.BillTo_Line2)
                {
                    ToolTip = 'Specifies the value of the Bill To Street 2 field';
                    ApplicationArea = All;
                }
                field(BillTo_Line3; Rec.BillTo_Line3)
                {
                    ToolTip = 'Specifies the value of the Bill To Street 3 field';
                    ApplicationArea = All;
                }
                field(BillTo_Name; Rec.BillTo_Name)
                {
                    ToolTip = 'Specifies the value of the Bill To Name field';
                    ApplicationArea = All;
                }
                field(BillTo_PostalCode; Rec.BillTo_PostalCode)
                {
                    ToolTip = 'Specifies the value of the Bill To ZIP/Postal Code field';
                    ApplicationArea = All;
                }
                field(BillTo_StateOrProvince; Rec.BillTo_StateOrProvince)
                {
                    ToolTip = 'Specifies the value of the Bill To State/Province field';
                    ApplicationArea = All;
                }
                field(BillTo_Telephone; Rec.BillTo_Telephone)
                {
                    ToolTip = 'Specifies the value of the Bill To Phone field';
                    ApplicationArea = All;
                }
                field(ClosedOn; Rec.ClosedOn)
                {
                    ToolTip = 'Specifies the value of the Closed On field';
                    ApplicationArea = All;
                }
                field(ContactId; Rec.ContactId)
                {
                    ToolTip = 'Specifies the value of the Contact field';
                    ApplicationArea = All;
                }
                field(ContactIdName; Rec.ContactIdName)
                {
                    ToolTip = 'Specifies the value of the ContactIdName field';
                    ApplicationArea = All;
                }
                field(CustomerId; Rec.CustomerId)
                {
                    ToolTip = 'Specifies the value of the Potential Customer field';
                    ApplicationArea = All;
                }
                field(CustomerIdType; Rec.CustomerIdType)
                {
                    ToolTip = 'Specifies the value of the Potential Customer Type field';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    ApplicationArea = All;
                }
                field(DiscountAmount; Rec.DiscountAmount)
                {
                    ToolTip = 'Specifies the value of the Quote Discount Amount field';
                    ApplicationArea = All;
                }
                field(DiscountAmount_Base; Rec.DiscountAmount_Base)
                {
                    ToolTip = 'Specifies the value of the Quote Discount Amount (Base) field';
                    ApplicationArea = All;
                }
                field(DiscountPercentage; Rec.DiscountPercentage)
                {
                    ToolTip = 'Specifies the value of the Quote Discount (%) field';
                    ApplicationArea = All;
                }
                field(EffectiveFrom; Rec.EffectiveFrom)
                {
                    ToolTip = 'Specifies the value of the Effective From field';
                    ApplicationArea = All;
                }
                field(EffectiveTo; Rec.EffectiveTo)
                {
                    ToolTip = 'Specifies the value of the Effective To field';
                    ApplicationArea = All;
                }
                field(ExchangeRate; Rec.ExchangeRate)
                {
                    ToolTip = 'Specifies the value of the Exchange Rate field';
                    ApplicationArea = All;
                }
                field(ExpiresOn; Rec.ExpiresOn)
                {
                    ToolTip = 'Specifies the value of the Due By field';
                    ApplicationArea = All;
                }
                field(FreightAmount; Rec.FreightAmount)
                {
                    ToolTip = 'Specifies the value of the Freight Amount field';
                    ApplicationArea = All;
                }
                field(FreightAmount_Base; Rec.FreightAmount_Base)
                {
                    ToolTip = 'Specifies the value of the Freight Amount (Base) field';
                    ApplicationArea = All;
                }
                field(FreightTermsCode; Rec.FreightTermsCode)
                {
                    ToolTip = 'Specifies the value of the Freight Terms field';
                    ApplicationArea = All;
                }
                field(ImportSequenceNumber; Rec.ImportSequenceNumber)
                {
                    ToolTip = 'Specifies the value of the Import Sequence Number field';
                    ApplicationArea = All;
                }
                field(ModifiedBy; Rec.ModifiedBy)
                {
                    ToolTip = 'Specifies the value of the Modified By field';
                    ApplicationArea = All;
                }
                field(ModifiedByName; Rec.ModifiedByName)
                {
                    ToolTip = 'Specifies the value of the ModifiedByName field';
                    ApplicationArea = All;
                }
                field(ModifiedOn; Rec.ModifiedOn)
                {
                    ToolTip = 'Specifies the value of the Modified On field';
                    ApplicationArea = All;
                }
                field(ModifiedOnBehalfBy; Rec.ModifiedOnBehalfBy)
                {
                    ToolTip = 'Specifies the value of the Modified By (Delegate) field';
                    ApplicationArea = All;
                }
                field(ModifiedOnBehalfByName; Rec.ModifiedOnBehalfByName)
                {
                    ToolTip = 'Specifies the value of the ModifiedOnBehalfByName field';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field(OpportunityId; Rec.OpportunityId)
                {
                    ToolTip = 'Specifies the value of the Opportunity field';
                    ApplicationArea = All;
                }
                field(OpportunityIdName; Rec.OpportunityIdName)
                {
                    ToolTip = 'Specifies the value of the OpportunityIdName field';
                    ApplicationArea = All;
                }
                field(OverriddenCreatedOn; Rec.OverriddenCreatedOn)
                {
                    ToolTip = 'Specifies the value of the Record Created On field';
                    ApplicationArea = All;
                }
                field(OwnerId; Rec.OwnerId)
                {
                    ToolTip = 'Specifies the value of the Owner field';
                    ApplicationArea = All;
                }
                field(OwnerIdType; Rec.OwnerIdType)
                {
                    ToolTip = 'Specifies the value of the OwnerIdType field';
                    ApplicationArea = All;
                }
                field(OwningBusinessUnit; Rec.OwningBusinessUnit)
                {
                    ToolTip = 'Specifies the value of the Owning Business Unit field';
                    ApplicationArea = All;
                }
                field(OwningTeam; Rec.OwningTeam)
                {
                    ToolTip = 'Specifies the value of the Owning Team field';
                    ApplicationArea = All;
                }
                field(OwningUser; Rec.OwningUser)
                {
                    ToolTip = 'Specifies the value of the Owning User field';
                    ApplicationArea = All;
                }
                field(PaymentTermsCode; Rec.PaymentTermsCode)
                {
                    ToolTip = 'Specifies the value of the Payment Terms field';
                    ApplicationArea = All;
                }
                field(PriceLevelId; Rec.PriceLevelId)
                {
                    ToolTip = 'Specifies the value of the Price List field';
                    ApplicationArea = All;
                }
                field(PriceLevelIdName; Rec.PriceLevelIdName)
                {
                    ToolTip = 'Specifies the value of the PriceLevelIdName field';
                    ApplicationArea = All;
                }
                field(PricingErrorCode; Rec.PricingErrorCode)
                {
                    ToolTip = 'Specifies the value of the Pricing Error  field';
                    ApplicationArea = All;
                }
                field(Probabilidad; Rec.Probabilidad)
                {
                    ToolTip = 'Specifies the value of the Probabilidad field';
                    ApplicationArea = All;
                }
                field(ProcessId; Rec.ProcessId)
                {
                    ToolTip = 'Specifies the value of the Process field';
                    ApplicationArea = All;
                }
                field(QuoteId; Rec.QuoteId)
                {
                    ToolTip = 'Specifies the value of the Quote field';
                    ApplicationArea = All;
                }
                field(QuoteNumber; Rec.QuoteNumber)
                {
                    ToolTip = 'Specifies the value of the Quote ID field';
                    ApplicationArea = All;
                }
                field(RequestDeliveryBy; Rec.RequestDeliveryBy)
                {
                    ToolTip = 'Specifies the value of the Requested Delivery Date field';
                    ApplicationArea = All;
                }
                field(RevisionNumber; Rec.RevisionNumber)
                {
                    ToolTip = 'Specifies the value of the Revision ID field';
                    ApplicationArea = All;
                }
                field(ShipTo_AddressId; Rec.ShipTo_AddressId)
                {
                    ToolTip = 'Specifies the value of the Ship To Address ID field';
                    ApplicationArea = All;
                }
                field(ShipTo_City; Rec.ShipTo_City)
                {
                    ToolTip = 'Specifies the value of the Ship To City field';
                    ApplicationArea = All;
                }
                field(ShipTo_Composite; Rec.ShipTo_Composite)
                {
                    ToolTip = 'Specifies the value of the Ship To Address field';
                    ApplicationArea = All;
                }
                field(ShipTo_ContactName; Rec.ShipTo_ContactName)
                {
                    ToolTip = 'Specifies the value of the Ship To Contact Name field';
                    ApplicationArea = All;
                }
                field(ShipTo_Country; Rec.ShipTo_Country)
                {
                    ToolTip = 'Specifies the value of the Ship To Country/Region field';
                    ApplicationArea = All;
                }
                field(ShipTo_Fax; Rec.ShipTo_Fax)
                {
                    ToolTip = 'Specifies the value of the Ship To Fax field';
                    ApplicationArea = All;
                }
                field(ShipTo_FreightTermsCode; Rec.ShipTo_FreightTermsCode)
                {
                    ToolTip = 'Specifies the value of the Ship To Freight Terms field';
                    ApplicationArea = All;
                }
                field(ShipTo_Line1; Rec.ShipTo_Line1)
                {
                    ToolTip = 'Specifies the value of the Ship To Street 1 field';
                    ApplicationArea = All;
                }
                field(ShipTo_Line2; Rec.ShipTo_Line2)
                {
                    ToolTip = 'Specifies the value of the Ship To Street 2 field';
                    ApplicationArea = All;
                }
                field(ShipTo_Line3; Rec.ShipTo_Line3)
                {
                    ToolTip = 'Specifies the value of the Ship To Street 3 field';
                    ApplicationArea = All;
                }
                field(ShipTo_Name; Rec.ShipTo_Name)
                {
                    ToolTip = 'Specifies the value of the Ship To Name field';
                    ApplicationArea = All;
                }
                field(ShipTo_PostalCode; Rec.ShipTo_PostalCode)
                {
                    ToolTip = 'Specifies the value of the Ship To ZIP/Postal Code field';
                    ApplicationArea = All;
                }
                field(ShipTo_StateOrProvince; Rec.ShipTo_StateOrProvince)
                {
                    ToolTip = 'Specifies the value of the Ship To State/Province field';
                    ApplicationArea = All;
                }
                field(ShipTo_Telephone; Rec.ShipTo_Telephone)
                {
                    ToolTip = 'Specifies the value of the Ship To Phone field';
                    ApplicationArea = All;
                }
                field(ShippingMethodCode; Rec.ShippingMethodCode)
                {
                    ToolTip = 'Specifies the value of the Shipping Method field';
                    ApplicationArea = All;
                }
                field(StageId; Rec.StageId)
                {
                    ToolTip = 'Specifies the value of the Process Stage field';
                    ApplicationArea = All;
                }
                field(StateCode; Rec.StateCode)
                {
                    ToolTip = 'Specifies the value of the Status field';
                    ApplicationArea = All;
                }
                field(StatusCode; Rec.StatusCode)
                {
                    ToolTip = 'Specifies the value of the Status Reason field';
                    ApplicationArea = All;
                }

                field(TimeZoneRuleVersionNumber; Rec.TimeZoneRuleVersionNumber)
                {
                    ToolTip = 'Specifies the value of the Time Zone Rule Version Number field';
                    ApplicationArea = All;
                }
                field(TotalAmount; Rec.TotalAmount)
                {
                    ToolTip = 'Specifies the value of the Total Amount field';
                    ApplicationArea = All;
                }
                field(TotalAmountLessFreight; Rec.TotalAmountLessFreight)
                {
                    ToolTip = 'Specifies the value of the Total Pre-Freight Amount field';
                    ApplicationArea = All;
                }
                field(TotalAmountLessFreight_Base; Rec.TotalAmountLessFreight_Base)
                {
                    ToolTip = 'Specifies the value of the Total Pre-Freight Amount (Base) field';
                    ApplicationArea = All;
                }
                field(TotalAmount_Base; Rec.TotalAmount_Base)
                {
                    ToolTip = 'Specifies the value of the Total Amount (Base) field';
                    ApplicationArea = All;
                }
                field(TotalDiscountAmount; Rec.TotalDiscountAmount)
                {
                    ToolTip = 'Specifies the value of the Total Discount Amount field';
                    ApplicationArea = All;
                }
                field(TotalDiscountAmount_Base; Rec.TotalDiscountAmount_Base)
                {
                    ToolTip = 'Specifies the value of the Total Discount Amount (Base) field';
                    ApplicationArea = All;
                }
                field(TotalLineItemAmount; Rec.TotalLineItemAmount)
                {
                    ToolTip = 'Specifies the value of the Total Detail Amount field';
                    ApplicationArea = All;
                }
                field(TotalLineItemAmount_Base; Rec.TotalLineItemAmount_Base)
                {
                    ToolTip = 'Specifies the value of the Total Detail Amount (Base) field';
                    ApplicationArea = All;
                }
                field(TotalLineItemDiscountAmount; Rec.TotalLineItemDiscountAmount)
                {
                    ToolTip = 'Specifies the value of the Total Line Item Discount Amount field';
                    ApplicationArea = All;
                }
                field(TotalLineItemDiscountAmount_Ba; Rec.TotalLineItemDiscountAmount_Ba)
                {
                    ToolTip = 'Specifies the value of the Total Line Item Discount Amount (Base) field';
                    ApplicationArea = All;
                }
                field(TotalTax; Rec.TotalTax)
                {
                    ToolTip = 'Specifies the value of the Total Tax field';
                    ApplicationArea = All;
                }
                field(TotalTax_Base; Rec.TotalTax_Base)
                {
                    ToolTip = 'Specifies the value of the Total Tax (Base) field';
                    ApplicationArea = All;
                }
                field(TransactionCurrencyId; Rec.TransactionCurrencyId)
                {
                    ToolTip = 'Specifies the value of the Currency field';
                    ApplicationArea = All;
                }
                field(TransactionCurrencyIdName; Rec.TransactionCurrencyIdName)
                {
                    ToolTip = 'Specifies the value of the TransactionCurrencyIdName field';
                    ApplicationArea = All;
                }
                field(TraversedPath; Rec.TraversedPath)
                {
                    ToolTip = 'Specifies the value of the Traversed Path field';
                    ApplicationArea = All;
                }
                field(UTCConversionTimeZoneCode; Rec.UTCConversionTimeZoneCode)
                {
                    ToolTip = 'Specifies the value of the UTC Conversion Time Zone Code field';
                    ApplicationArea = All;
                }
                field(VersionNumber; Rec.VersionNumber)
                {
                    ToolTip = 'Specifies the value of the Version Number field';
                    ApplicationArea = All;
                }
                field(WillCall; Rec.WillCall)
                {
                    ToolTip = 'Specifies the value of the Ship To field';
                    ApplicationArea = All;
                }
            }
        }
    }

}
