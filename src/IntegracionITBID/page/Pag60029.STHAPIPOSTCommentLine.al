page 60029 "STH API POST Comment Line"
{
    APIGroup = 'sothisGroup';
    APIPublisher = 'sothis';
    APIVersion = 'v1.0';
    Caption = 'STH API Comment Line';
    // EntityCaption = 'STH API Comment Line';
    // EntitySetCaption = 'STH API Comment Line';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'sthPostCommentLine';
    EntitySetName = 'sthPostCommentLine';
    ODataKeyFields = "Table Name", "No.", "Line No.";
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
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                }
                field(comment; Rec.Comment)
                {
                    Caption = 'Comment';
                }
                field(actionHTTP; actionHTTP) { }
                field(result; result) { }
            }
        }
    }

    var
        commentLine: Record "Comment Line";
        actionHTTP: Text;
        result: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        result := 'Failed';
        case actionHTTP of
            'DELETE':
                begin
                    if commentLine.Get(Rec."Table Name"::Vendor, Rec."No.", Rec."Line No.") then begin
                        commentLine.Delete();
                    end;

                    result := 'Success';
                end;
            'POST':
                begin
                    if commentLine.Get(Rec."Table Name"::Vendor, Rec."No.", Rec."Line No.") then
                        Error('El registro ya existe %1', Rec."No.");

                    commentLine.Init();
                    commentLine.TransferFields(Rec);
                    commentLine.Insert();
                end;
            'PATCH':
                begin
                    if commentLine.Get(Rec."Table Name"::Vendor, Rec."No.", Rec."Line No.") then begin
                        commentLine.TransferFields(Rec);
                        commentLine.Modify();
                    end;
                end;
        end;
        result := 'Success';
        exit(false);
    end;
}