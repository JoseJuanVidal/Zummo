pageextension 50024 "PurchCrMemoSubform" extends "Purch. Cr. Memo Subform"
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