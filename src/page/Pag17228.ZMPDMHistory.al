page 17228 "ZM PDM History"
{
    Caption = 'PDM History', comment = 'ESP="Histórico PDM"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM PDM History";
    SourceTableView = sorting("Date") order(descending);
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Date"; "Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("PDM Code"; "PDM Code")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field(Revision; Revision)
                {
                    ApplicationArea = All;
                }
                field(Version; Version)
                {
                    ApplicationArea = All;
                }
                field(Transition; Transition)
                {
                    ApplicationArea = All;
                    StyleExpr = StyleTxt;
                }
                field("To Status"; "To Status")
                {
                    ApplicationArea = All;
                }
                field("User Name"; "User Name")
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                }
                field(Approval; Approval)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                }
                field("Document ID"; "Document ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenFile)
            {
                ApplicationArea = All;
                Caption = 'Open approved version', comment = 'ESP="Abrir versión aprobada"';
                ToolTip = 'Opens the file of this version (only for approvals).', comment = 'ESP="Abre el fichero de esta versión (solo en las aprobaciones)."';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = Approval;

                trigger OnAction()
                begin
                    PDMSync.OpenHistoryFile(Rec);
                end;
            }
            action(OnlyApprovals)
            {
                ApplicationArea = All;
                Caption = 'Only approvals', comment = 'ESP="Solo aprobaciones"';
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if GetFilter(Approval) = '' then
                        SetRange(Approval, true)
                    else
                        SetRange(Approval);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := '';
        if Approval then
            StyleTxt := 'Favorable';
    end;

    var
        PDMSync: Codeunit "ZM PDM Sync";
        StyleTxt: Text;
}
