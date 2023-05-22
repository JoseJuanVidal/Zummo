pageextension 50163 "PostedPurchaseRcptSubform" extends "Posted Purchase Rcpt. Subform"
{

    actions
    {
        addfirst("F&unctions")
        {

            action("Imprimir Etiquetas")
            {
                ApplicationArea = all;
                Caption = 'Etiquetas', comment = 'ESP="Etiquetas"';
                ToolTip = 'Imprimir etiquetas',
                    comment = 'ESP="Imprimir etiquetas"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = PrintReport;

                trigger OnAction()
                begin

                    ImprimirEtiqueta();
                end;
            }
        }
        addafter(DocumentLineTracking)
        {
            action(LineasFacturas)
            {
                ApplicationArea = all;
                Caption = 'Líneas Facturas', comment = 'ESP="Líneas Facturas"';
                Image = PurchaseInvoice;

                trigger OnAction()
                begin
                    ShowPurchaseInvoiceLine;
                end;

            }
        }
    }
    procedure ImprimirEtiqueta()

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntry2: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", Rec."Document No.");
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document Line No.", Rec."Line No.");
        if ItemLedgerEntry.FindFirst() then begin
            repeat
                ItemLedgerEntry2.reset;
                ItemLedgerEntry2.SetRange("Entry No.", ItemLedgerEntry."Entry No.");
                ItemLedgerEntry2.FindFirst();
                Report.Run(Report::EtiquetaMateriaPrima, false, false, ItemLedgerEntry2);
            until ItemLedgerEntry.Next() = 0;
        end;

    end;


    local procedure ShowPurchaseInvoiceLine()
    var
        PurchaseInvoiceLine: Record "Purch. Inv. Line";
    begin
        IF Type = Type::Item THEN BEGIN
            PurchaseInvoiceLine.Reset();
            PurchaseInvoiceLine.SetRange("Receipt No.", Rec."Document No.");
            PurchaseInvoiceLine.SetRange("Receipt Line No.", rec."Line No.");
            PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice Lines", PurchaseInvoiceLine);
        END;
    end;

}