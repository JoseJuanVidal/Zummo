pageextension 50041 "PostedSalesInvoiceSubform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group") { }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group") { }
        }
        addafter("Invoice Discount Amount")
        {
            field("Inv. Discount Amount"; "Inv. Discount Amount")
            {
                ApplicationArea = all;
            }
        }
    }

}