pageextension 50042 "PostedPurchInvoiceSubform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group") { }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group") { }
        }
    }

}