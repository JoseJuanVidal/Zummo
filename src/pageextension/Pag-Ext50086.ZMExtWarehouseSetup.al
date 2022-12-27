pageextension 50086 "ZM Ext Warehouse Setup" extends "Warehouse Setup"
{
    layout
    {
        addafter("Shipment Posting Policy")
        {
            field("Recep. alm. cantidad a cero"; "Recep. alm. cantidad a cero")
            {
                ApplicationArea = all;
            }
        }
    }
}
