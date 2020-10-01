pageextension 50048 "Accounting Manager Role Ext" extends "Accounting Manager Role Center"
{
    layout
    {

    }

    actions
    {
        addafter("Cartera Setup")
        {
            action(PostedPurchaseReceiptLinesAction)
            {
                Caption = 'Posted Purchase Receipt Lines', comment = 'ESP="Hist. líns. albs. compra"';
                RunObject = page "Posted Purchase Receipt Lines";
                RunPageView = where("Qty. Rcd. Not Invoiced" = filter(<> 0));
                Image = PostedOrder;
            }
            action(PostedSalesShipmentLinesAction)
            {
                Caption = 'Posted Sales Shipment Lines', comment = 'ESP="Hist. líns. albs. venta"';
                RunObject = page "Posted Sales Shipment Lines";
                Image = PostedOrder;
            }
        }
    }
}