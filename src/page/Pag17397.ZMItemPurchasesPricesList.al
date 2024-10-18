page 17397 "ZM Item Purchases Prices List"
{
    Caption = 'Item purchases prices List', comment = 'ESP="Lista Precios compra productos"';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTable = "ZM PL Item Purchase Prices";
    Editable = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Date/Time Creation"; "Date/Time Creation")
                {
                    ApplicationArea = all;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field("Item Name"; "Item Name")
                {
                    ApplicationArea = all;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = all;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = all;
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                    ApplicationArea = all;
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Action Approval"; "Action Approval")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Status Approval"; "Status Approval")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Date Send Approval"; "Date Send Approval")
                {
                    ApplicationArea = all;
                    Editable = false;
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
                ApplicationArea = All;
                Caption = 'Send Approval', comment = 'ESP="Envío aprobación"';
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = ItemApproval;


                trigger OnAction()
                begin
                    OnAction_SendApproval();
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve', comment = 'ESP="Aprobar"';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = UserApproval;

                trigger OnAction()
                begin
                    OnAction_Approve();
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject', comment = 'ESP="Rechazar"';
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = UserApproval;

                trigger OnAction()
                begin
                    OnAction_Reject();
                end;
            }
            action(RequestDelete)
            {
                ApplicationArea = All;
                Caption = 'Select to delete', comment = 'ESP="Seleccionar para eliminar"';
                Image = DeleteRow;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_RequestDelete();
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        UserApproval := ItemsRegistaprovals.CheckUserItemPurchasePriceApproval;
        CurrPage.Editable := EditableFields;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."Item No." = '' then
            Rec."Item No." := ItemNo;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec."Item No." = '' then
            Rec."Item No." := ItemNo;
    end;

    var
        Item: Record Item;
        ItemsRegistaprovals: Codeunit "ZM PL Items Regist. aprovals";
        ItemNo: code[20];
        ItemApproval: boolean;
        UserApproval: boolean;
        EditableFields: Boolean;
        lblConfirm: Label '¿Do you want to send the pending price approval requests for product %1 %2?', comment = 'ESP="¿Desea enviar las solicitudes pendientes de aprobacion de los precios del producto %1 %2?"';
        lblSending: Label 'Request for approval sent.', comment = 'ESP="Solicitud aprobación enviada."';
        lblConfirmApprove: Label 'The selected records (%2) go to %1. Do you want to continue?', comment = 'ESP="Se va a %1 los registros seleccionados (%2).\¿Desea continuar?"';
        lblApprove: Label 'Approve', comment = 'ESP="Aprobar"';
        lblRejecte: Label 'Rejects', comment = 'ESP="Rechazar"';

    procedure SetItemNo(Value: code[20])
    var
        myInt: Integer;
    begin
        ItemNo := Value;
        EditableFields := true;
    end;

    local procedure OnAction_SendApproval()
    var
        myInt: Integer;
    begin
        Item.Reset();
        if Item.Get(Rec."Item No.") then
            if Confirm(lblConfirm, false, Item."No.", Item.Description) then begin
                ItemsRegistaprovals.SendApprovalItemPurchasePrices(Item);
                Message(lblSending);
            end;
    end;

    local procedure OnAction_Approve()
    begin
        PurchasePricesApproval(true);
    end;

    local procedure OnAction_Reject()
    begin
        PurchasePricesApproval(false);
    end;

    local procedure PurchasePricesApproval(Approve: Boolean)
    var
        Item: Record Item;
        ItemPurchasePrices: Record "ZM PL Item Purchase Prices";
        Action: text;
    begin
        case Approve of
            true:
                Action := lblApprove
            else
                Action := lblRejecte
        end;
        CurrPage.SetSelectionFilter(ItemPurchasePrices);
        if not Confirm(lblConfirmApprove, false, Action, ItemPurchasePrices.Count) then
            exit;
        ItemPurchasePrices.ItemPurchasePricesApproval(ItemPurchasePrices, Approve);

    end;

    procedure SetItemApproval(Value: Boolean)
    begin
        ItemApproval := Value;
    end;

    local procedure OnAction_RequestDelete()
    begin
        if Rec.GetFilter("Item No.") <> '' then
            ItemsRegistaprovals.GetRequestDeleteSelection(Rec.GetFilter("Item No."));
    end;
}