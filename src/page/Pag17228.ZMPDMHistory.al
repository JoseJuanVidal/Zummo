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
                    Visible = ShowAll;
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
            action(ShowAllLines)
            {
                ApplicationArea = All;
                Caption = 'Show all', comment = 'ESP="Mostrar todo"';
                ToolTip = 'Shows all the history lines: versions, transitions and approvals.', comment = 'ESP="Muestra todas las líneas del histórico: versiones, transiciones y aprobaciones."';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                Visible = not ShowAll;

                trigger OnAction()
                begin
                    SetApprovalFilter(true);
                    CurrPage.Update(false);
                end;
            }
            action(OnlyApprovals)
            {
                ApplicationArea = All;
                Caption = 'Only approvals', comment = 'ESP="Solo aprobaciones"';
                ToolTip = 'Shows only the approvals.', comment = 'ESP="Muestra solo las aprobaciones."';
                Image = FilterLines;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowAll;

                trigger OnAction()
                begin
                    SetApprovalFilter(false);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetApprovalFilter(false);
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := '';
        if Approval then
            StyleTxt := 'Favorable';
    end;

    // Filtro de aprobaciones en el grupo 2 para que no se quite desde el panel de filtros
    local procedure SetApprovalFilter(NewShowAll: Boolean)
    begin
        ShowAll := NewShowAll;
        FilterGroup(2);
        if ShowAll then
            SetRange(Approval)
        else
            SetRange(Approval, true);
        FilterGroup(0);
    end;

    var
        PDMSync: Codeunit "ZM PDM Sync";
        StyleTxt: Text;
        ShowAll: Boolean;
}
