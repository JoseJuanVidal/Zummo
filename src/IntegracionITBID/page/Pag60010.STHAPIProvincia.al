page 60010 "STH API Provincia"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Provincia';
    // EntityCaption = 'STH API Provincia';
    // EntitySetCaption = 'STH API Provincia';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthProvincia';
    EntitySetName = 'sthProvincia';
    ODataKeyFields = "Code";
    PageType = API;
    SourceTable = "Area";
    //Editable = false;

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
                field("text"; Rec."Text")
                {
                    Caption = 'Text';
                }
            }
        }
    }
}
