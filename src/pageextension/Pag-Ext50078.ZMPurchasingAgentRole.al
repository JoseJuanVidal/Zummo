pageextension 50078 "ZM Purchasing Agent Role" extends "Purchasing Agent Role Center"
{
    layout
    {

    }

    actions
    {
        addafter("Purchase &Line Discounts")
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
            action(PostedPurchaseInvoiceLinesAction)
            {
                Caption = 'Posted Purchase Invoice Lines', comment = 'ESP="Hist. líns. fact. compra"';
                RunObject = page "Posted Purchase Invoice Lines";
                // sRunPageView = where("Qty. Rcd. Not Invoiced" = filter(<> 0));
                Image = PostedOrder;
            }
            action(PurchaseLine)
            {
                Caption = 'Purchase Order Lines', comment = 'ESP="líns. Ped. compra"';
                RunObject = page "Purchase Lines";
                RunPageView = where("Document Type" = const(Order));
                Image = OrderList;
            }
        }
        addafter("Blanket Purchase Orders")
        {
            action(ContractsSupplies)
            {
                Caption = 'Contracts and Supplies', comment = 'ESP="Contratos y Suministros"';
                RunObject = page "ZM Contracts Suplies List";
                // sRunPageView = where("Qty. Rcd. Not Invoiced" = filter(<> 0));
                Image = ContactReference;
            }
            action(PurchaseRequest)
            {
                Caption = 'Purch. Request less 200', comment = 'ESP="Solicitud Compra menos 200"';
                Image = OrderPromising;
                RunObject = page "Purchase Request less 200";
                RunPageView = where(Invoiced = const(false));
            }
        }
    }
}