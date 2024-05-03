page 17212 "Purchase Request less 200"
{
    ApplicationArea = All;
    Caption = 'Purchase Request less 200', Comment = 'ESP="Solicitudes de Compra menos 200"';
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    PageType = List;
    SourceTable = "Purchase Requests less 200";
    UsageCategory = Lists;
    CardPageId = "Purchase Request less 200 Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
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
                field(Description; Rec.Description)
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
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field("Purchase Invoice"; "Purchase Invoice")
                {
                    ApplicationArea = all;
                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = all;
                    Visible = false;
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
        area(Navigation)
        {
            action(PostedPurchaseRequest)
            {
                Caption = 'Posted Purch. Order Request', comment = 'ESP="Hist. Solicitud Ped. Compra"';
                Image = OrderPromising;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    OnAction_PostedPurchaseRequest();
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        FilterUser();
        ShowApprovalButton := Rec.IsUserApproval();
    end;

    var
        UserSetup: Record "User Setup";
        ShowApprovalButton: Boolean;

    local procedure FilterUser()
    begin
        UserSetup.Reset();
        if UserSetup.Get(UserId) then
            if UserSetup."Approvals Purch. Request" then
                exit;
        Rec.SetRange("User Id", UserId);
    end;

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

    local procedure OnAction_PostedPurchaseRequest()
    var
        PurchaseRequest: Record "Purchase Requests less 200";
        PurchaseRequests: page "Purchase Request less 200";
    begin
        if not PurchaseRequest.IsUserApproval() then
            PurchaseRequest.SetRange("User Id", UserId);
        PurchaseRequest.SetRange(Status, PurchaseRequest.Status::Approved);
        PurchaseRequest.SetRange(Invoiced, true);
        PurchaseRequests.SetTableView(PurchaseRequest);
        PurchaseRequests.RunModal();
    end;
}
