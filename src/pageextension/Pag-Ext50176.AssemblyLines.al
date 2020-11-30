pageextension 50176 "AssemblyLines" extends "Assembly Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("Document Type_btc"; "Document Type_btc") { }
            field("Document No_btc"; "Document No_btc") { }
            field("Document Line No_btc"; "Document Line No_btc") { }
            field("Fecha Fin Oferta_btc"; "Fecha Fin Oferta_btc") { }
            field(NombreCliente; NombreCliente)
            {
                ApplicationArea = all;
                Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
            }
            field(SalesHeaderPromised; SalesHeader."Promised Delivery Date")
            {
                Caption = 'Fecha entrega prometida', comment = 'ESP="Fecha entrega prometida"';
            }
            field(SalesHeaderRequested; SalesHeader."Requested Delivery Date")
            {
                Caption = 'Fecha entrega requerida', comment = 'ESP="Fecha entrega requerida"';
            }
            field(QuoteNoSalesOrder; QuoteNoSalesOrder)
            {
                ApplicationArea = all;
            }
        }
    }

    var
        SalesHeader: Record "Sales Header";
        NombreCliente: Code[100];

    trigger OnAfterGetRecord()
    begin
        NombreCliente := '';
        SalesHeader.reset;
        SalesHeader.SetRange("Document Type", "Document Type_btc");
        SalesHeader.SetRange("No.", "Document No_btc");
        if SalesHeader.FindFirst() then begin
            NombreCliente := SalesHeader."Sell-to Customer Name";
        end;

    end;


}

