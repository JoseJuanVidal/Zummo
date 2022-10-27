pageextension 50057 "STH General JournalExt" extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(ImportNominas)
            {
                ApplicationArea = all;
                Caption = 'Importar Nominas', comment = 'ESP="Importar Nominas"';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                begin
                    Funciones.CargaFicheroNominas(rec."Journal Batch Name", rec."Journal Template Name");
                end;
            }
            action(ImportIvaRecuperacion)
            {
                ApplicationArea = all;
                Caption = 'Importar Recuperación IVA', comment = 'ESP="Importar Recuperación IVA"';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJournalBatch: Record "Gen. Journal Batch";
                    Funciones: Codeunit "STH Funciones IVA Recuperacion";
                begin
                    GenJournalBatch.Reset();
                    GenJournalBatch.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJournalBatch.SetRange(Name, Rec."Journal Batch Name");
                    GenJournalBatch.FindSet();
                    Funciones.CreateJnlIVARecuperacion(GenJournalBatch);
                    CurrPage.Update();
                end;
            }
        }
    }

    var
        myInt: Integer;
}