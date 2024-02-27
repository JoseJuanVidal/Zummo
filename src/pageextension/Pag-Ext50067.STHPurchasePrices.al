pageextension 50067 "STH Purchase Prices" extends "Purchase Prices"
{
    layout
    {
        modify(Control1)
        {
            Editable = IsEditable;
        }
        addlast(Control1)
        {
            field("Process No."; "Process No.")
            {
                ApplicationArea = all;
            }
            field("Process Description"; "Process Description")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter(CopyPrices)
        {
            action(SolicitudPrecios)
            {
                ApplicationArea = all;
                Caption = 'New Prices Request', comment = 'ESP="Solicitud Nuevos Precios"';
                Image = Approvals;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_RequestNewPrices();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsEditable := not SetupItemregistration.GetSetupRegActiveApproval();
    end;

    var
        SetupItemregistration: Record "ZM PL Setup Item registration";
        IsEditable: Boolean;

    local procedure OnAction_RequestNewPrices()
    var
        ItemPurchasePrice: Record "ZM PL Item Purchase Prices";
        ItemPurchasesPrices: page "ZM PL Item Purchases Prices";
    begin
        ItemPurchasePrice.FilterGroup := 2;
        ItemPurchasePrice.SetRange("Item No.", Rec.GetFilter("Item No."));
        ItemPurchasePrice.SetRange("Status Approval", ItemPurchasePrice."Status Approval"::Pending);
        ItemPurchasePrice.FilterGroup := 0;
        ItemPurchasesPrices.SetTableView(ItemPurchasePrice);
        ItemPurchasesPrices.Run();
    end;
}

