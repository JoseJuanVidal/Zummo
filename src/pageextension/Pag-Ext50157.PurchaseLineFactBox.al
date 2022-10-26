pageextension 50157 "PurchaseLineFactBox" extends "Purchase Line FactBox"
{
    layout
    {
        addafter(Availability)
        {
            field(PedidoMinimo; PedidoMinimo) { }
            field(MultiplosDePedido; MultiplosDePedido) { }
            field(StockSeguridad; StockSeguridad) { }
        }

    }
    var
        PedidoMinimo: Decimal;
        MultiplosDePedido: Decimal;
        StockSeguridad: Decimal;

    trigger OnAfterGetRecord()
    var
        item: Record Item;
    begin
        PedidoMinimo := 0;
        MultiplosDePedido := 0;
        if Rec.Type = Rec.Type::Item then begin
            if Item.Get(Rec."No.") then begin
                PedidoMinimo := item."Minimum Order Quantity";
                MultiplosDePedido := item."Order Multiple";
                StockSeguridad := item."Safety Stock Quantity";
            end;
        end;
    end;
}