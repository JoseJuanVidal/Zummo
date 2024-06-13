page 60007 "STH API Comment Line"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Comment Line';
    // EntityCaption = 'STH API Comment Line';
    // EntitySetCaption = 'STH API Comment Line';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthCommentLine';
    EntitySetName = 'sthCommentLine';
    ODataKeyFields = "No.", "Line No.";
    PageType = API;
    SourceTable = "Comment Line";
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
                field(tableName; Rec."Table Name")
                {
                    Caption = 'Table Name';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
            }
        }
    }
}
