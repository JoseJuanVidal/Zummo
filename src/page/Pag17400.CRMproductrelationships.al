page 17400 "CRM productrelationships"
{
    PageType = List;
    SourceTable = "CRM productrelationships"; // "CRM FormasPago_btc";
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
                field(productsubstituteid; productsubstituteid) { ApplicationArea = All; }
                field(productid; productid) { ApplicationArea = All; }
                field(name; name) { ApplicationArea = All; }
                field(Direction; Direction) { ApplicationArea = All; }
                field(salesrelationshiptype; salesrelationshiptype) { ApplicationArea = All; }
                field(CreatedOn; CreatedOn) { ApplicationArea = All; }

                field(CreatedBy; CreatedBy) { ApplicationArea = All; }
                field(ModifiedOn; ModifiedOn) { ApplicationArea = All; }
                field(ModifiedBy; ModifiedBy) { ApplicationArea = All; }
                field(CreatedOnBehalfBy; CreatedOnBehalfBy) { ApplicationArea = All; }
                field(ModifiedOnBehalfBy; ModifiedOnBehalfBy) { ApplicationArea = All; }

                // field(statecode; statecode) { ApplicationArea = All; }
                field(VersionNumber; VersionNumber) { ApplicationArea = All; }
                field(ImportSequenceNumber; ImportSequenceNumber) { ApplicationArea = All; }

                field(TimeZoneRuleVersionNumber; TimeZoneRuleVersionNumber) { ApplicationArea = All; }
                field(UTCConversionTimeZoneCode; UTCConversionTimeZoneCode) { ApplicationArea = All; }

            }
        }
    }

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

}