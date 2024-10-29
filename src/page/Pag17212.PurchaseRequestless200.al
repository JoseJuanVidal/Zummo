page 17212 "Purchase Request less 200"
{
    ApplicationArea = All;
    Caption = 'Purchase Request less 200', Comment = 'ESP="Compra menor 200"';
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
    PageType = List;
    SourceTable = "Purchase Requests less 200";
    SourceTableView = where(Status = filter(" " | Pending | Approved | Reject));
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
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                // field(Quantity; Rec.Quantity)
                // {
                //     ApplicationArea = All;
                // }
                // field("Unit Price"; "Unit Price")
                // {
                //     ApplicationArea = all;
                // }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = all;
                    Visible = false;
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
                    Visible = false;
                }
                field("G/L Entry"; "G/L Entry")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = all;
                }
                field("Codigo Empleado"; "Codigo Empleado")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Nombre Empleado"; "Nombre Empleado")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
        // area(factboxes)
        // {
        //     part("Attachment Document"; "ZM Document Attachment Factbox")
        //     {
        //         ApplicationArea = all;
        //         Caption = 'Attachment Document', comment = 'ESP="Documentos adjuntos"';
        //         SubPageLink = "Table ID" = const(17200), "No." = field("No.");

        //     }
        // }
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
            group(Relations)
            {
                Caption = 'Relations', comment = 'ESP="Relaciones"';
                action(UpdateStatus)
                {
                    ApplicationArea = all;
                    Caption = 'Updagte Status', comment = 'ESP="Act. estados"';
                    Image = Status;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    Begin
                        OnAction_UpdateStatus();
                    End;
                }
                action(GLEntries)
                {
                    ApplicationArea = all;
                    Caption = 'Assign movs. contabiliddad', comment = 'ESP="Asignar movs. contabiliddad"';
                    Image = GeneralLedger;

                    trigger OnAction()
                    Begin
                        OnAction_RelateGLEntries();
                    End;
                }

                action(RelatePurchInvoices)
                {
                    ApplicationArea = all;
                    Caption = 'Assign Posted Purch. Invoices', comment = 'ESP="Asignar Hist. Facturas compras"';
                    Image = PurchaseInvoice;

                    trigger OnAction()
                    Begin
                        OnAction_RelatePurchInvoices();
                    End;
                }

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
                    Navigate_PostedPurchaseRequest();
                end;
            }
            action(Navigate)
            {
                Caption = '&Navigate', comment = 'ESP="&Navegar"';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Navigate();
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        // FilterUser();
        ShowApprovalButton := Rec.IsUserApproval();
    end;

    // trigger OnAfterGetCurrRecord()
    // var
    //     RefRecord: recordRef;
    // begin
    //     if RefRecord.Get(Rec.RecordId) then;
    //     CurrPage."Attachment Document".Page.SetTableNo(17200, Rec."No.", 0, RefRecord)
    // end;

    var
        UserSetup: Record "User Setup";
        ShowApprovalButton: Boolean;

    local procedure FilterUser()
    begin
        Rec.SetFilter(Status, '<>%1', Rec.Status::Posted);
        UserSetup.Reset();
        if UserSetup.Get(UserId) then
            if UserSetup."Approvals Purch. Request" then
                exit;
        // Rec.SetRange("User Id", UserId);

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

    local procedure OnAction_UpdateStatus()
    var
        PurReqLess200: Record "Purchase Requests less 200";
        lblConfirm: Label '¿Do you want to update the status of Request under 200 €?', comment = 'ESP="¿Desea actualizar los estados de las Solicitudes menor 200 €?"';
    begin
        if not Confirm(lblConfirm) then
            exit;
        PurReqLess200.SetRange(Status, PurReqLess200.Status::Approved);
        if PurReqLess200.FindFirst() then
            repeat
                PurReqLess200.UpdateStatus();
            Until PurReqLess200.next() = 0;
    end;

    local procedure OnAction_RelateGLEntries()
    var
        GLEntry: Record "G/L Entry";
        GLEntries: page "General Ledger Entries";
    begin
        GLEntry.SetRange("Posting Date", CalcDate('<-CY>', Rec."Posting Date"), CalcDate('<CY>', Rec."Posting Date"));
        GLEntry.SetRange(Amount, Rec.Amount);
        GLEntries.SetTableView(GLEntry);
        GLEntries.LookupMode := true;
        if GLEntries.RunModal() = action::LookupOK then begin
            GLEntries.GetRecord(GLEntry);
            GLEntry.TestField("Purch. Request less 200", '');
            Rec.AssingGLEntry(GLEntry);
        end;
    end;

    local procedure OnAction_RelatePurchInvoices()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PostedPurchaseInvoices: page "Posted Purchase Invoices";
    begin
        PurchInvHeader.SetRange("Posting Date", CalcDate('<-CY>', Rec."Posting Date"), CalcDate('<CY>', Rec."Posting Date"));
        PurchInvHeader.SetRange(Amount, Rec.Amount);
        PostedPurchaseInvoices.SetTableView(PurchInvHeader);
        PostedPurchaseInvoices.LookupMode := true;
        if PostedPurchaseInvoices.RunModal() = action::LookupOK then begin
            PostedPurchaseInvoices.GetRecord(PurchInvHeader);
            Rec.AssingPurchInvoice(PurchInvHeader);
        end;
    end;
}
