page 60005 "STH API Payment Day"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Payment Day';
    // EntityCaption = 'STH Payment Day';
    // EntitySetCaption = 'STH Payment Day';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPaymentDay';
    EntitySetName = 'sthPaymentDay';
    ODataKeyFields = Code;
    PageType = API;
    SourceTable = "Payment Day";
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
                field(dayOfTheMonth; Rec."Day of the month")
                {
                    Caption = 'Day of the month';
                }
            }
        }
    }
}
