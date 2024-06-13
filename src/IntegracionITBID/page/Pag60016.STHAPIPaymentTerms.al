page 60016 "STH API Payment Terms"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Payment Terms';
    // EntityCaption = 'STH API Payment Terms';
    // EntitySetCaption = 'STH API Payment Terms';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPaymentTerms';
    EntitySetName = 'sthPaymentTerms';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = "Payment Terms";
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
