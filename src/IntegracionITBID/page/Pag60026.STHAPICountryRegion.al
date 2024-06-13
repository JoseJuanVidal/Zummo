page 60026 "STH API Country/Region"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Country Region';
    // EntityCaption = 'STH API Country Region';
    // EntitySetCaption = 'STH API Country Region';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthCountryRegion';
    EntitySetName = 'sthCountryRegion';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = "Country/Region";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(euCountryRegionCode; Rec."EU Country/Region Code")
                {
                    Caption = 'EU Country/Region Code';
                }
                field(countyName; Rec."County Name")
                {
                    Caption = 'County Name';
                }
                // field(id; Rec.Id)
                // {
                //     Caption = 'Id';
                // }
                // field(systemId; Rec.SystemId)
                // {
                //     Caption = 'SystemId';
                // }
            }
        }
    }
}
