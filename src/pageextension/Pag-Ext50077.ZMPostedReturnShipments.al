pageextension 50077 "ZM Posted Return Shipments" extends "Posted Return Shipments"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Document Date")
        {
            Visible = true;
        }
        addlast(Control1)
        {
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = all;
            }

            field("Vendor Authorization No."; "Vendor Authorization No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
