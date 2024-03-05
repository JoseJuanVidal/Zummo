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
        addafter("Document No.")
        {
            field(VendorShipmentNo; VendorShipmentNo)
            {
                ApplicationArea = all;
                Caption = 'Nº Albarán proveedor', comment = 'ESP="Nº Albarán proveedor"';
            }
            field("Order No."; "Order No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Global Dimension 3 Code"; "Global Dimension 3 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 8 Code"; "Global Dimension 8 Code")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not PurchRcptHeader.Get(rec."Document No.") then
            Clear(PurchRcptHeader);
        VendorShipmentNo := PurchRcptHeader."Vendor Shipment No.";
    end;

    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";

        VendorShipmentNo: text;

}