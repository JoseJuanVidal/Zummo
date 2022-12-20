pageextension 50083 "Purchase CRMemos" extends "Purchase Credit Memos"
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
