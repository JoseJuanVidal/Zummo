pageextension 50156 "PurchaseLines" extends "Purchase Lines"
{
    layout
    {
        addafter("Outstanding Quantity")
        {
            field("Quantity Received"; "Quantity Received")
            {
                ApplicationArea = all;
            }
            field("Primera Fecha Recep."; "Primera Fecha Recep.")
            {
                ApplicationArea = all;
            }
            field(TextoRechazo; TextoRechazo)
            {
                ApplicationArea = All;
            }
            field(FechaRechazo_btc; FechaRechazo_btc)
            {
                ApplicationArea = all;
            }
        }
        addafter("Expected Receipt Date")
        {
            field("Planned Receipt Date"; "Planned Receipt Date")
            {
            }
            field("Promised Receipt Date"; "Promised Receipt Date")
            {
            }
            field("Requested Receipt Date"; "Requested Receipt Date")
            {
            }
            field("Nombre Proveedor"; "Nombre Proveedor") { }
            field(FechaAlbaran; FechaAlbaran)
            {

            }
            field(FechaEmisionPedido; FechaEmisionPedido) { }
        }
        addafter("Direct Unit Cost")
        {
            field(StandarCost; StandarCost)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
    var
        FechaAlbaran: Date;
        FechaEmisionPedido: Date;

    trigger OnAfterGetRecord()
    var
        Purchrecep: Record "Purch. Rcpt. Line";
        PurchaseHeader: Record "Purchase Header";
    begin
        FechaAlbaran := 0D;
        Purchrecep.reset;
        Purchrecep.SetRange("Order No.", Rec."Document No.");
        Purchrecep.SetRange("Order Line No.", Rec."Line No.");
        Purchrecep.SetFilter(Quantity, '<>0');
        if Purchrecep.FindFirst() then begin
            FechaAlbaran := Purchrecep."Posting Date";
        end;
        PurchaseHeader.reset;
        PurchaseHeader.SetRange("No.", Rec."Document No.");
        PurchaseHeader.FindFirst();
        FechaEmisionPedido := PurchaseHeader."Document Date";
    end;

}