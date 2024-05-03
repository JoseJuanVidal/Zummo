pageextension 50007 "PostedPurchaseInvoice" extends "Posted Purchase Invoice"
{
    //Guardar Nº asiento y Nº documento

    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Purch. Request less 200"; "Purch. Request less 200")
            {
                ApplicationArea = all;
            }
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
            field(NumAsiento_btc; NumAsiento_btc)
            {
                ApplicationArea = All;
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
                    Editable = false;
                }
                field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Plastic Date Declaration"; "Plastic Date Declaration")
                {
                    ApplicationArea = all;
                }
            }
        }

    }
}