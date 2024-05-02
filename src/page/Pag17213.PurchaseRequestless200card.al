page 17213 "Purchase Request less 200 Card"
{
    Caption = 'Purchase Request less 200', Comment = 'ESP="Solicitud de Compra menos 200"';
    PageType = Card;
    SourceTable = "Purchase Requests less 200";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            Group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                group(Vendor)
                {
                    Caption = 'Vendor', comment = 'ESP="Proveedor"';
                    field("Vendor No."; Rec."Vendor No.")
                    {
                        ApplicationArea = All;
                    }
                    field("Vendor Name"; Rec."Vendor Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Vendor Name 2"; Rec."Vendor Name 2")
                    {
                        ApplicationArea = All;
                    }
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(SendApproval)
            {
                ApplicationArea = all;
                Caption = 'Send Approval', comment = 'ESP="Envío Aprobación"';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_SendApproval();
                end;
            }
            action(Approve)
            {
                ApplicationArea = all;
                Caption = 'Approve', comment = 'ESP="Aprobar"';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowApprovalButton;

                trigger OnAction()
                begin
                    OnAction_Approve();
                end;
            }
            action(Reject)
            {
                ApplicationArea = all;
                Caption = 'Reject', comment = 'ESP="Rechazar"';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowApprovalButton;

                trigger OnAction()
                begin
                    OnAction_Reject();
                end;
            }
        }
    }

    var
        ShowApprovalButton: Boolean;

    local procedure OnAction_SendApproval()
    begin
        Rec.SendApproval();

    end;

    local procedure OnAction_Approve()
    begin
        Rec.Approve();
    end;

    local procedure OnAction_Reject()
    begin
        Rec.Reject();
    end;
}
