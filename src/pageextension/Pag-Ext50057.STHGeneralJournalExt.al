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
        addafter(PostAndPrint)
        {
            action(PostLot)
            {
                ApplicationArea = all;
                Caption = 'Registrar por lotes', comment = 'ESP="Registrar por lotes"';
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PostLotItemJnl;
                end;
            }
        }
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

    local procedure PostLotItemJnl()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        lblConfirm: Label '¿Desea registrar por lotes el diario?', comment = 'ESP="¿Desea registrar por lotes el diario?"';
        lblMsg: Label 'Registro de líneas realizado.', comment = 'ESP="Registro de líneas realizado."';
    begin
        if not Confirm(lblConfirm, false) then
            exit;
        GenJournalLine.Reset();
        GenJournalLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        GenJournalLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        IF GenJournalLine.FINDFIRST THEN
            REPEAT
                GenJournalLine2.RESET;
                GenJournalLine2.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
                GenJournalLine2.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
                GenJournalLine2.SETRANGE("Document No.", GenJournalLine."Document No.");
                IF GenJournalLine2.FINDFIRST THEN
                    // CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJournalLine2);
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine2);


            UNTIL GenJournalLine.NEXT = 0;

        Message(lblMsg);
    end;
}