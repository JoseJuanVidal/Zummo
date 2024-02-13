pageextension 50103 "SalesLines" extends "Sales Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field(NombreCliente_btc; NombreCliente_btc)
            {
                ApplicationArea = All;
            }
            field(ExternalDocument; ExternalDocument) { }
            field(MotivoRetraso_btc; MotivoRetraso_btc) { }
            field(TextoMotivoRetraso_btc; TextoMotivoRetraso_btc) { }
            field("Promised Delivery Date"; "Promised Delivery Date") { }
        }

        addafter("Reserved Qty. (Base)")
        {
            field(StockAlmacen_btc; StockAlmacen_btc)
            {
                ApplicationArea = All;
            }
            field(FechaFinValOferta_btc; FechaFinValOferta_btc)
            {
                Visible = visiblebool;
            }
            field(FechaAlbaran; FechaAlbaran)
            {
                ApplicationArea = all;
            }
            field(QuoteNoSalesOrder; QuoteNoSalesOrder)
            {
                ApplicationArea = all;
            }
            field(ComentarioInterno_btc; ComentarioInterno_btc)
            {
                ApplicationArea = all;
                Visible = false;
            }
        }




    }
    var
        visiblebool: Boolean;
        FechaAlbaran: Date;

    trigger OnOpenPage()
    begin
        if rec."Document Type" = "Document Type"::Quote then
            visiblebool := true
        else
            visiblebool := false;
    end;

    procedure GetResult(VAR SalesLine: Record "Sales Line")
    begin
        CurrPage.SETSELECTIONFILTER(SalesLine);
    end;

    trigger OnAfterGetRecord()
    var
        SalesShipmentLine: Record "Sales Shipment Line";
    BEGIN
        FechaAlbaran := 0D;
        SalesShipmentLine.reset;
        SalesShipmentLine.SetRange("Order No.", Rec."Document No.");
        SalesShipmentLine.SetRange("Order Line No.", rec."Line No.");
        SalesShipmentLine.SetFilter(Quantity, '>0');
        if SalesShipmentLine.FindFirst() then begin
            FechaAlbaran := SalesShipmentLine."Posting Date";
        end;

    END;
}