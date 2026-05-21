page 17397 "ZM Item Purchases Prices List"
{
    Caption = 'Item purchases prices List', comment = 'ESP="Lista Precios compra productos"';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = all;
    SourceTable = "ZM PL Item Purchase Prices";
    SourceTableTemporary = true;
    SourceTableView = sorting("Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
    // Editable = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Date/Time Creation"; "Date/Time Creation")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
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
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = all;
                }
                field("Vendor Item No."; "Vendor Item No.")
                {
                    ApplicationArea = all;
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    ApplicationArea = all;
                }
                field("Minimum Order Quantity"; "Minimum Order Quantity")
                {
                    ApplicationArea = all;
                }
                field("Order Multiple"; "Order Multiple")
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
            action(ImportExcel)
            {
                ApplicationArea = all;
                Caption = 'Import Precios compra', comment = 'ESP="Importar Precios compra"';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = UserApproval;

                trigger OnAction()
                begin
                    Rec.ImportExcel(Rec);
                    if Rec.FindFirst() then;
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve Purchase Price', comment = 'ESP="Aprobar precios"';
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
        }
        area(Navigation)
        {
            action(ListUsed)
            {
                ApplicationArea = All;
                Caption = 'Puntos de uso (Nivel superior)', comment = 'ESP="Puntos de uso (Nivel superior)"';
                Image = "Where-Used";

                trigger OnAction()
                var
                    Item: Record Item;
                    ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
                begin
                    if not Item.Get(Rec."Item No.") then
                        exit;
                    ProdBOMWhereUsed.SetItem(Item, WORKDATE);
                    ProdBOMWhereUsed.RUNMODAL();
                end;
            }

        }
    }


    trigger OnOpenPage()
    begin
        UserApproval := ItemsRegistaprovals.CheckUserPriceListOwner;
        CurrPage.Editable := UserApproval;
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
        // CurrPage.SetSelectionFilter(ItemPurchasePrices);
        // ItemPurchasePrices.SetRange("Status Approval", ItemPurchasePrices."Status Approval"::Pending);
        if not Confirm(lblConfirmApprove, false, Action, Rec.Count) then
            exit;
        // creamos peticion temporal
        ItemPurchasePrices.ModifyAll(Selected, false);
        if Rec.FindFirst() then
            repeat
                ItemPurchasePrices.Init();
                ItemPurchasePrices := Rec;
                ItemPurchasePrices.Selected := true;
                ItemPurchasePrices.Insert();
            Until Rec.next() = 0;
        ItemPurchasePrices.SetRange(Selected, true);
        ItemPurchasePrices.ItemPurchasePricesApproval(ItemPurchasePrices, Approve);
        Rec.DeleteAll();
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