pageextension 50082 "PostedReturnShipments" extends "Posted Return Shipments"
{
    layout
    {
        addlast(Control1)
        {
            field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Plastic Date Declaration"; "Plastic Date Declaration")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
}
