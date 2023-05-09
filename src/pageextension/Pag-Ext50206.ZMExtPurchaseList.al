pageextension 50206 "ZM Ext Purchase List" extends "Purchase List"
{
    layout
    {
        addlast(Control1)
        {
            field("Vendor Invoice No."; "Vendor Invoice No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Shipment No."; "Vendor Shipment No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
}
