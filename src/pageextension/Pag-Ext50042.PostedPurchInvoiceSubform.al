pageextension 50042 "PostedPurchInvoiceSubform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group") { }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group") { }
            field(IdCorp_Sol; IdCorp_Sol)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Nombre Empleado"; "Nombre Empleado")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Purch. Order No."; "Purch. Order No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
}