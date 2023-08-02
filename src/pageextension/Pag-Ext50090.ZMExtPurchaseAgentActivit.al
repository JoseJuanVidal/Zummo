pageextension 50090 "ZM  Ext Purchase Agent Activit" extends "Purchase Agent Activities"
{
    layout
    {
        addafter("Upcoming Orders")
        {
            field("Contract/Suppliers"; "Contract/Suppliers")
            {
            }
        }
    }
}
