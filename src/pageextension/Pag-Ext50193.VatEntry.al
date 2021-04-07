pageextension 50193 "VatEntry" extends "VAT Entries"
{
    layout
    {
        addafter("Bill-to/Pay-to No.")
        {
            field(NombreClienteProv; NombreClienteProv)
            {
                ApplicationArea = all;
                Caption = 'Nombre Cliente Proverdor';
            }
            field(Paisenvio; Paisenvio)
            {
                ApplicationArea = all;
                Caption = 'Pais Envío', comment = 'ESP="Pais Envío"';
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        NombreClienteProv := '';
        if Vendor.get("Bill-to/Pay-to No.") then
            NombreClienteProv := Vendor.Name;

        if Customer.get("Bill-to/Pay-to No.") then
            NombreClienteProv := Customer.Name;
        case rec.Type of
            Rec.Type::Sale:
                begin
                    if HistFacVenta.get("Document No.") then
                        Paisenvio := HistFacVenta."Ship-to Country/Region Code";
                end;
            else
                Paisenvio := '';

        end

    end;


    var
        HistFacVenta: Record "Sales Invoice Header";
        NombreClienteProv: code[100];
        Paisenvio: text;

}