page 60006 "STH API Non-Payment Period"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Non-Payment Period';
    // EntityCaption = 'STH API Non-Payment Period';
    // EntitySetCaption = 'STH API Non-Payment Period';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthNonPaymentPeriod';
    EntitySetName = 'sthNonPaymentPeriod';
    ODataKeyFields = Code;
    PageType = API;
    SourceTable = "Non-Payment Period";
    // Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(id; Rec.Id)
                // {
                //     Caption = 'Id';
                // }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(fromDate; Rec."From Date")
                {
                    Caption = 'From Date';
                }
                field(toDate; Rec."To Date")
                {
                    Caption = 'To Date';
                }
            }
        }
    }
}
