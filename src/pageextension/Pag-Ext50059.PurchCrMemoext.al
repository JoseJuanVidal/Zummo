pageextension 50059 "PurchCrMemoext" extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field("CONSULTIA ID Factura"; "CONSULTIA ID Factura")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("CONSULTIA N Factura"; "CONSULTIA N Factura")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = All;
            }
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }

        }
        addlast(Content)
        {
            group(Plastic)
            {
                Caption = 'Normativa Plástico', comment = 'ESP="Normativa Plástico"';

                field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Plastic Date Declaration"; "Plastic Date Declaration")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}