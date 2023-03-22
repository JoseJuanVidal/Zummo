page 17377 "ZM OAuth20Application Folders"
{
    PageType = List;
    Caption = 'OAuth20 Application Folders', comment = 'ESP="OAuth20 Application Folders"';
    UsageCategory = None;
    SourceTable = "ZM OAuth20Application Folders";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application Code"; "Application Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        Rec.OpenDriveItems(Rec.FolderID)
                    end;
                }
                field(FolderID; FolderID)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Folders)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Folders', Comment = 'ES==Carpetas';
                Image = SelectField;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Refresh the access and refresh tokens.';

                trigger OnAction()
                begin
                    Rec.OpenDriveItems(REc.FolderID);
                end;
            }
        }
    }
}