pageextension 50022 "PurchaseQuoteSubform" extends "Purchase Quote Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            // Mostar iva en compras y ventas
            field("VAT %"; "VAT %")
            {
                ApplicationArea = All;
            }

            //Mostar iva en compras y ventas
            field("VAT Identifier"; "VAT Identifier")
            {
                ApplicationArea = All;
            }
        }
    }
}