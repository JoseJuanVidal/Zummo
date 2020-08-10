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
            field(NombreCliente; NombreCliente) { }
        }
    }

    var
        NombreCliente: Code[100];

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
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

