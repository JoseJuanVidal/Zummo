page 60013 "STH API Language"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Language';
    // EntityCaption = 'STH API Language';
    // EntitySetCaption = 'STH API Language';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthLanguage';
    EntitySetName = 'sthLanguage';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = Language;
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
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
            }
        }
    }
}
