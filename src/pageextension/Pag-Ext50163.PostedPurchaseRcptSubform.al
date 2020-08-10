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


}