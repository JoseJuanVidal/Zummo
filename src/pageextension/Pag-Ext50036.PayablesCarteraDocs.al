pageextension 50036 "PayablesCarteraDocs" extends "Payables Cartera Docs"
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
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        txtNombre := '';
        NFacturaProveedor := '';

        if Type = Type::Payable then begin
            if recVendor.Get("Account No.") then
                txtNombre := recVendor.Name;
        end else
            if recCustomer.Get("Account No.") then
                txtNombre := recCustomer.Name;

        PurchInvHeader.reset;
        PurchInvHeader.SetRange("No.", "Document No.");
        if PurchInvHeader.FindFirst() then begin
            NFacturaProveedor := PurchInvHeader."Vendor Invoice No.";
        end;

    end;

    var
        txtNombre: Text[100];
        NFacturaProveedor: code[35];
}