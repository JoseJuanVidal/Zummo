page 60012 "STH API Currency"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Currency';
    // EntityCaption = 'STH API Currency';
    // EntitySetCaption = 'STH API Currency';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthCurrency';
    EntitySetName = 'sthCurrency';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = Currency;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.Id)
                {
                    Caption = 'Id';
                }
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
