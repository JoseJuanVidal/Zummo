page 60009 "STH API Post Code"
{
    APIGroup = 'sothiGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Post Code';
    // EntityCaption = 'STH API Post Code';
    // EntitySetCaption = 'STH API Post Code';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostCode';
    EntitySetName = 'sthPostCode';
    ODataKeyFields = "Code", City;
    PageType = API;
    SourceTable = "Post Code";

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
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                }
                field(County; Rec.County)
                {
                }
            }
        }
    }
}
