pageextension 50037 "CarteraDocuments" extends "Cartera Documents"
{
    layout
    {
        addafter("Account No.")
        {
            field(txtNomb; txtNombre)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Name', comment = 'ESP="Nombre"';
            }
            field(BancoProveedor; BancoProveedor)
            {
                ApplicationArea = all;
            }
        }
        modify("Payment Method Code")
        {
            Editable = true;
        }
    }

    trigger OnAfterGetRecord()
    var
        recCustomer: Record customer;
        recVendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        txtNombre := '';

        if Type = Type::Payable then begin
            if recVendor.Get("Account No.") then begin
                txtNombre := recVendor.Name;
                VendorBankAccount.Reset();
                VendorBankAccount.SetRange("Vendor No.", "Account No.");
                VendorBankAccount.SetRange("Use For Electronic Payments", true);
                BancoProveedor := VendorBankAccount.FindFirst();
            end;
        end else
            if recCustomer.Get("Account No.") then
                txtNombre := recCustomer.Name;


    end;

    var
        txtNombre: Text[100];
        BancoProveedor: Boolean;
}