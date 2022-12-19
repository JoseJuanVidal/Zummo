pageextension 50123 "ReleasedProdOrderLines" extends "Released Prod. Order Lines"
{
    layout
    {
        addafter("Ending Date")
        {
            field(FechaInicial_btc; FechaInicial_btc)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    Validate("Starting Date", FechaInicial_btc);
                end;
            }
        }
        modify("Starting Date-Time")
        {
            Editable = false;
        }
    }

    actions
    {
        addafter("Order &Tracking")
        {
            action(ShowPurchaseLine)
            {
                ApplicationArea = all;
                Caption = 'Seguimiento pedido compra', comment = 'ESP="Seguimiento pedido compra"';
                Image = Purchase;

                trigger OnAction()
                begin
                    PurchaseLineRelated;
                end;

            }
        }
    }


    local procedure PurchaseLineRelated()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        PurchaseLine.SetRange("Prod. Order Line No.", Rec."Line No.");
        Page.RunModal(page::"Purchase Lines", PurchaseLine);
    end;
}