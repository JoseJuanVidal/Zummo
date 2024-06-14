pageextension 50105 "ZM PurchaseOrder" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field(Pendiente_btc; Pendiente_btc)
            {
                ApplicationArea = All;
            }
        }
        addlast(Content)
        {
            group(Plastic)
            {
                Caption = 'Normativa Plástico', comment = 'ESP="Normativa Plástico"';

                field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Plastic Date Declaration"; "Plastic Date Declaration")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action(ExportPDF)
            {
                ApplicationArea = all;
                Image = SendAsPDF;
                Promoted = true;
                PromotedCategory = Category10;

                trigger OnAction()
                begin
                    ExportMergePDF();
                end;
            }
        }
    }
    var
        Funciones: Codeunit Funciones;

    local procedure ExportMergePDF()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        PurchaseHeader.SetRange("No.", Rec."No.");
        PurchaseHeader.FindFirst();
        Funciones.ExportarPDFPurchaseOrder(PurchaseHeader);
    end;
}