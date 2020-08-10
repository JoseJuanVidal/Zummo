pageextension 50032 "DocsinClosedBGSubform" extends "Docs. in Closed BG Subform"
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

            field("Direct Debit Mandate ID"; "Direct Debit Mandate ID")
            {
                ApplicationArea = All;
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