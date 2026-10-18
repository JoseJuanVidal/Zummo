page 17229 "ZM PDM Item FactBox"
{
    Caption = 'PDM', comment = 'ESP="PDM"';
    PageType = CardPart;
    SourceTable = Item;
    Editable = false;

    layout
    {
        area(Content)
        {
            field("PDM Revision"; "PDM Revision")
            {
                ApplicationArea = All;
                StyleExpr = StyleTxt;

                trigger OnDrillDown()
                begin
                    PDMSync.ShowItemHistory(Rec."No.");
                end;
            }
            field("PDM Approval Date"; "PDM Approval Date")
            {
                ApplicationArea = All;
            }
            field("PDM Approved By"; "PDM Approved By")
            {
                ApplicationArea = All;
            }
            field("PDM In Modification"; "PDM In Modification")
            {
                ApplicationArea = All;
            }
            field(ReplacedBy; ReplacedBy)
            {
                ApplicationArea = All;
                Caption = 'Replaced by (PDM)', comment = 'ESP="Sustituido por (PDM)"';
                ToolTip = 'The drawing of this item has been approved with a new code.', comment = 'ESP="El plano de este producto se ha aprobado con un código nuevo."';
                Style = Unfavorable;
            }
            field("PDM Documents"; "PDM Documents")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    PDMSync.ShowItemDocuments(Rec."No.");
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenPDF)
            {
                ApplicationArea = All;
                Caption = 'View drawing (PDF)', comment = 'ESP="Ver plano (PDF)"';
                Image = Document;

                trigger OnAction()
                begin
                    PDMSync.OpenItemPDF(Rec."No.");
                end;
            }
            action(History)
            {
                ApplicationArea = All;
                Caption = 'PDM History', comment = 'ESP="Histórico PDM"';
                Image = History;

                trigger OnAction()
                begin
                    PDMSync.ShowItemHistory(Rec."No.");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PDMItemLink: Record "ZM PDM Item Link";
        PDMDocument: Record "ZM PDM Document";
    begin
        ReplacedBy := '';
        StyleTxt := '';
        PDMItemLink.SetRange("Item No.", Rec."No.");
        PDMItemLink.SetRange(Main, true);
        if PDMItemLink.FindFirst() then begin
            if PDMItemLink."In Modification" then
                StyleTxt := 'Ambiguous';
            if not PDMItemLink.Current then
                if PDMDocument.Get(PDMItemLink."Document ID") then begin
                    ReplacedBy := PDMDocument."PDM Code";
                    StyleTxt := 'Unfavorable';
                end;
        end;
    end;

    var
        PDMSync: Codeunit "ZM PDM Sync";
        ReplacedBy: Text;
        StyleTxt: Text;
}
