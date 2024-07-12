pageextension 50214 "ZM Bank Account Ledger Entr." extends "Bank Account Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Reverse Transaction")
        {
            action(OpenLedgerEntries)
            {
                ApplicationArea = all;
                Caption = 'Open Ledger Entry', comment = 'ESP="Abrir Mov. Banco"';
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    OnAction_OpenLedgerEntries();
                end;
            }
        }
        addafter(SetDimensionFilter)
        {
            action(NavigateApplyBankAccLedgerEntries)
            {
                ApplicationArea = all;
                Caption = 'Applies Bank Account Statement', comment = 'ESP="Liq. Extractos Bancarios"';
                Image = BankAccountStatement;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    OnAction_NavigateApplyBankAccLedgerEntries();
                end;
            }
        }
    }
    var
        lblConfirm: Label 'Do you want to open the entry %1 %2 %3?', comment = 'ESP="¿Desea abrir el movimiento %1 %2 %3.?"';

    local procedure OnAction_OpenLedgerEntries()
    var
        myInt: Integer;
    begin
        if not Confirm(lblConfirm, false, Rec."Entry No.", Rec."Document No.", Rec.Description) then
            exit;
        Rec.Open := false;
        Rec.Modify();
    end;

    local procedure OnAction_NavigateApplyBankAccLedgerEntries()
    var
        BankAccountStatementLine: Record "Bank Account Statement Line";
        BankAccountStatementLines: page "Bank Account Statement Lines";
    begin
        BankAccountStatementLine.FilterGroup := 2;
        BankAccountStatementLine.SetRange("Bank Account No.", Rec."Bal. Account No.");
        BankAccountStatementLine.SetRange("Statement No.", Rec."Statement No.");
        BankAccountStatementLine.SetRange("Statement Line No.", Rec."Statement Line No.");
        BankAccountStatementLine.FilterGroup := 0;
        BankAccountStatementLines.SetTableView(BankAccountStatementLine);
        BankAccountStatementLines.Run();

    end;
}