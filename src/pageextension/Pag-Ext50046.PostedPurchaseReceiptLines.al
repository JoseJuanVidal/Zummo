pageextension 50046 "PostedPurchaseReceiptLines" extends "Posted Purchase Receipt Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Posting Date"; "Posting Date")
            {
                ApplicationArea = All;
            }
            field("Direct Unit Cost"; "Direct Unit Cost")
            {
                ApplicationArea = all;
            }
            field("Nombre Proveedor"; "Nombre Proveedor")
            {
                ApplicationArea = all;
            }
            field("Fecha Vencimiento"; "Fecha Vencimiento")
            {
                ApplicationArea = all;
            }
        }
    }

}