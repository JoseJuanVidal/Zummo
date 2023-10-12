pageextension 50035 "ReceivablesCarteraDocs" extends "Receivables Cartera Docs"
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
            field("Cred_ Max_ Aseg. Autorizado Por_btc"; "Cred_ Max_ Aseg. Autorizado Por_btc")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Suplemento_aseguradora; Suplemento_aseguradora)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = all;
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(clasificacion_aseguradora; clasificacion_aseguradora)
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        modify("Payment Method Code")
        {
            Editable = true;

            trigger OnAfterValidate()
            begin
                if Modify() then;
            end;
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