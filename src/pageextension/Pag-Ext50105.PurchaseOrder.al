pageextension 50105 "PurchaseOrder" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field(Pendiente_btc; Pendiente_btc)
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