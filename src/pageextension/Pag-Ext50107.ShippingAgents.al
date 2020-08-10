pageextension 50107 "ShippingAgents" extends "Shipping Agents"
{
    layout
    {
        addafter("Internet Address")
        {
            field(ProveedorAsociado_btc; ProveedorAsociado_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}