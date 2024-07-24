pageextension 50215 "ZM Apply Bank Acc. Ledger" extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            action(CloseLedgerEntries)
            {
                ApplicationArea = all;
                Caption = 'Close Ledger Entry', comment = 'ESP="Cerrar Mov. Banco"';
                Image = Close;

                trigger OnAction()
                begin
                    OnAction_CloseLedgerEntries();
                end;
            }
        }
    }

    var
        lblConfirm: Label 'Do you want to close the entry %1 %2 %3?', comment = 'ESP="¿Desea cerrar el movimiento %1 %2 %3.?"';

    local procedure OnAction_CloseLedgerEntries()
    var
        Funciones: Codeunit Funciones;
    begin
        if not Confirm(lblConfirm, false, Rec."Entry No.", Rec."Document No.", Rec.Description) then
            exit;
        Funciones.CloseLedgerEntries(Rec."Entry No.");
        CurrPage.Update();

    end;
}