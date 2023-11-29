pageextension 50048 "Accounting Manager Role Ext" extends "Accounting Manager Role Center"
{
    layout
    {

    }

    actions
    {
        addafter("Cartera Setup")
        {
            action(AnalisisMovContable)
            {
                Caption = 'Análisis Movs Contabilidad', comment = 'ESP="Análisis Movs Contabilidad"';
                RunObject = page "ZM Analisis Movs Contabilidad";
                Image = GLRegisters;
            }
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
        }
    }
}