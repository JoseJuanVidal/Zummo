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
                field(FolderName; FolderName)
                {
                    ApplicationArea = all;
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
                Caption = 'Folders', Comment = 'ESP="Carpetas"';
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
            action(URL)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'URL', Comment = 'ESP="URL"';
                Image = LinkWeb;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Open the URL', Comment = 'ESP="Abrir URL"';

                trigger OnAction()
                begin
                    Rec.OpenDriveItems(REc.FolderID);
                end;
            }
            action(crearfichero)
            {
                ApplicationArea = all;

                trigger OnAction()
                var
                    Sharepoint: Codeunit "Sharepoint OAuth App. Helper";
                    InStr: InStream;
                begin
                    Sharepoint.SaveFileStream('c:\Zummo\otros\pdf\', 'S00034 ABxxx 33434311', InStr);
                end;
            }
        }
    }
}