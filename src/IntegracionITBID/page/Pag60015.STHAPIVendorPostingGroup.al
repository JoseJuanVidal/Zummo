page 60015 "STHAPIVendor Posting Group"
{
    Caption = 'APIVendor Posting Group ';
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    // EntityCaption = 'STH API Vendor';
    // EntitySetCaption = 'STH API Vendor';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthVendorPostingGroup';
    EntitySetName = 'sthVendorPostingGroup';
    ODataKeyFields = code;
    PageType = API;
    SourceTable = "Vendor Posting Group";
    editable = false;

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
                    ApplicationArea = none;
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = none;
                }
            }
        }
    }
}
