pageextension 50208 "ZM FA Ledger Entries" extends "FA Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(ReverseTransaction)
        {
            action(ExportarPDF)
            {
                ApplicationArea = all;
                Caption = 'Exportar en PDF', comment = 'ESP="Exportar en PDF"';
                Image = SendAsPDF;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_ExportarPDF();
                end;

            }
        }
    }

    var
        Funciones: codeunit "Funciones";

    local procedure OnAction_ExportarPDF()
    var
        FALedgerEntry: Record "FA Ledger Entry";
    begin
        CurrPage.SetSelectionFilter(FALedgerEntry);
        Funciones.FixedAssetLineExportPdf(FALedgerEntry);
    end;
}