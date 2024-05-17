page 17213 "Purchase Request less 200 Card"
{
    Caption = 'Purchase Request less 200', Comment = 'ESP="Compra menor 200"';
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';
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
                    trigger OnAssistEdit()
                    begin
                        OnAssistEdit_No();
                    end;
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
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Descripción Factura', comment = 'ESP="Descripción Factura"';
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
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field("Purchase Invoice"; "Purchase Invoice")
                {
                    ApplicationArea = all;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = all;
                    Caption = 'Comments', comment = 'ESP="Comentarios"';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        OnValidate_Comment();
                    end;
                }
            }
        }
        area(factboxes)
        {
            part("Attachment Document"; "ZM Document Attachment Factbox")
            {
                ApplicationArea = all;
                Caption = 'Attachment Document', comment = 'ESP="Documentos adjuntos"';
                SubPageLink = "Table ID" = const(17200), "No." = field("No.");
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

    trigger OnOpenPage()
    begin
        ShowApprovalButton := Rec.IsUserApproval();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Comments := Rec.GetComment().ToText();
    end;

    trigger OnAfterGetRecord()
    var
        RefRecord: recordRef;
    begin
        RefRecord.Get(Rec.RecordId);
        CurrPage."Attachment Document".Page.SetTableNo(17200, Rec."No.", 0, RefRecord);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // al salir de la pantalla si no ha enviado la aprobación, se lo recordamos 
        // y enviamos
        if Rec.Status in [Rec.Status::" "] then
            if Confirm(lblConfirmSend) then
                SendEmailApproval();

    end;

    var
        Comments: text;
        ShowApprovalButton: Boolean;
        lblConfirmSend: Label 'El pedido de compra no se ha enviado para la aprobación.\¿Desea enviarlo ahora?', comment = 'ESP="El pedido de compra no se ha enviado para la aprobación.\¿Desea enviarlo ahora?"';

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

    local procedure OnValidate_Comment()
    begin
        Rec.SetComment(Comments);
    end;

    local procedure OnAssistEdit_No()
    var
        myInt: Integer;
    begin
        IF AssistEdit(xRec) THEN
            CurrPage.UPDATE;
    end;

}
