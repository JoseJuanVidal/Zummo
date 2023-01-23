pageextension 50029 "DocsinPOSubform" extends "Docs. in PO Subform"
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
                Visible = false;
            }
            field("STH Vendor Name"; "STH Vendor Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Document No.")
        {
            field("ZM Vendor Ext Doc No."; "ZM Vendor Ext Doc No.")
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