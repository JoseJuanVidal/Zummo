pageextension 50111 "ContactCard" extends "Contact Card"
{
    layout
    {
        addlast(General)
        {
            field(EnviarEmailPedCompra_btc; EnviarEmailPedCompra2_btc)
            {
                ApplicationArea = All;
                Enabled = enabledEmail;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recContactBus: Record "Contact Business Relation";
    begin
        enabledEmail := false;

        recContactBus.Reset();
        recContactBus.SetRange("Link to Table", recContactBus."Link to Table"::Vendor);
        recContactBus.SetRange("Contact No.", "Company No.");
        if recContactBus.FindFirst() then
            enabledEmail := true;
    end;

    var
        enabledEmail: Boolean;
}