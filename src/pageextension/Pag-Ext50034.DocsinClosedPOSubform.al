pageextension 50034 "DocsinClosedPOSubform" extends "Docs. in Closed PO Subform"
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
        addafter("Document No.")
        {
            field("ZM Vendor Ext Doc No."; "ZM Vendor Ext Doc No.")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recCustomer: Record customer;
        recVendor: Record Vendor;
    begin
        txtNombre := '';

        if Type = Type::Payable then begin
            if recVendor.Get("Account No.") then
                txtNombre := recVendor.Name;
        end else
            if recCustomer.Get("Account No.") then
                txtNombre := recCustomer.Name;
    end;

    var
        txtNombre: Text[100];
}