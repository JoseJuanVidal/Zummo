enum 50108 "ZM Pakcing Document Type"
{
    Extensible = true;

    value(0; Order)
    {
        Caption = 'Order', comment = 'ESP="Pedido Venta"';
    }
    value(1; "Sales Shipment")
    {
        Caption = 'Sales Shipment', comment = 'ESP="Albarán venta"';
    }
    value(2; "Return Receipt")
    {
        Caption = 'Return Receipt', comment = 'ESP="Dev. Venta"';
    }
}