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

                    trigger OnValidate()
                    begin
                        UpdateSubform();
                    end;

                    trigger OnAssistEdit()
                    begin
                        OnAssistEdit_No();
                    end;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        UpdateSubform();
                    end;
                }
                field("Codigo Empleado"; "Codigo Empleado")
                {
                    ApplicationArea = all;
                }
                field("Nombre Empleado"; "Nombre Empleado")
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

                        trigger OnValidate()
                        begin
                            UpdateSubForm();
                        end;
                    }
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Descripción Factura', comment = 'ESP="Descripción Factura"';
                }
                group(PartidaPresupuestaria)
                {
                    Caption = 'Seleccionar Partida presupuestaría', comment = 'ESP="Seleccionar Partida presupuestaría"';
                    field(Type; Type)
                    {
                        ApplicationArea = all;
                    }
                    field("G/L Account No."; "G/L Account No.")
                    {
                        ApplicationArea = all;
                    }
                    field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Global Dimension 8 Code"; "Global Dimension 8 Code")
                    {
                        ApplicationArea = all;
                    }
                    field("Global Dimension 3 Code"; "Global Dimension 3 Code")
                    {
                        ApplicationArea = all;
                    }
                }
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
                field("G/L Entry"; "G/L Entry")
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
            action(Close)
            {
                ApplicationArea = all;
                Caption = 'Close Request', comment = 'ESP="Cerrar Solicitud"';
                Image = CloseDocument;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ShowApprovalButton;

                trigger OnAction()
                var
                    lblConfirm: Label '¿You want to change the Status of %1 to $2', comment = 'ESP="¿Desea cambiar el Estado de %1 como $2?"';
                begin
                    // comprobamos que el usuario puede realizar el cambio
                    CheckIsUserApproval();
                    if not Confirm(lblConfirm, true, Rec.TableCaption, Rec.Status::Posted) then
                        exit;
                    Rec.Status := Rec.Status::Posted;
                    Rec.Modify();
                end;
            }
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdateSubForm();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        UpdateSubForm();
    end;

    trigger OnOpenPage()
    begin
        ShowApprovalButton := Rec.IsUserApproval();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Comments := Rec.GetComment().ToText();
        UpdateSubForm();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // al salir de la pantalla si no ha enviado la aprobación, se lo recordamos 
        // y enviamos
        if (Rec.Amount = 0) or (Rec."G/L Account No." = '') or
            (Rec.Description = '') or (Rec."Vendor Name" = '') then
            exit;
        if (Rec.Status in [Rec.Status::" "]) and (Rec."No." <> '') then
            if Confirm(lblConfirmSend) then
                Rec.SendEmailApproval();

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

    local procedure UpdateSubForm()
    var
        RefRecord: recordRef;
    begin
        if RefRecord.Get(Rec.RecordId) then;
        CurrPage."Attachment Document".Page.SetTableNo(17200, Rec."No.", 0, RefRecord);
    end;

    local procedure CheckIsUserApproval()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        if UserSetup.Get(UserId) then
            UserSetup.TestField("Approvals Purch. Request", true);
    end;
}
