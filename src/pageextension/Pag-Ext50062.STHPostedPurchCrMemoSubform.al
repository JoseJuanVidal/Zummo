pageextension 50062 "STH Posted PurchCrMemoSubform" extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Deferral Code")
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {
                ApplicationArea = all;
            }
            field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
            {
                ApplicationArea = all;
            }
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
        }
    }
}