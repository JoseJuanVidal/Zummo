page 17421 "ZM PL Item Purchases Prices"
{
    Caption = 'Item purchases prices', comment = 'ESP="Precios compra productos"';
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM PL Item Purchase Prices";


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
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


                trigger OnAction()
                begin
                    OnAction_SendApproval();
                end;
            }
        }
    }

    var
        Item: Record Item;
        ItemsRegistaprovals: Codeunit "ZM PL Items Regist. aprovals";
        lblConfirm: Label '¿Do you want to send the pending price approval requests for product %1 %2?', comment = 'ESP="¿Desea enviar las solicitudes pendientes de aprobacion de los precios del producto %1 %2?"';
        lblSending: Label 'Request for approval sent.', comment = 'ESP="Solicitud aprobación enviada."';

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
}