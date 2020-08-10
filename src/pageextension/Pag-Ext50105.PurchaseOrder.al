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
    }
}