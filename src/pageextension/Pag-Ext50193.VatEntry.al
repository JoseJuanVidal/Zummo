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
    end;


    var
        NombreClienteProv: code[100];

}