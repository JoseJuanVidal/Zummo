page 60014 "STH API Payment Method"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Payment Method';
    // EntityCaption = 'STH API Payment Method';
    // EntitySetCaption = 'STH API Payment Method';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPaymentMethod';
    EntitySetName = 'sthPaymentMethod';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = "Payment Method";
    Editable = false;

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
            }
        }
    }
}
