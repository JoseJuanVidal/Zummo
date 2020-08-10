page 50139 "Conc. Mov. Contabilidad"
{
    Permissions = tabledata "G/L Entry" = m;

    PageType = List;
    SourceTable = "G/L Entry";
    Caption = 'G/L Entry Reconciliation', Comment = 'ESP="Conciliación Mov. Contabilidad"';
    ApplicationArea = All;
    UsageCategory = Lists;
    DeleteAllowed = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Liquidado_btc; Liquidado_btc)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Bill No."; "Bill No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Gen. Posting Type"; "Gen. Posting Type")
                {
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    ApplicationArea = All;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Period Trans. No."; "Period Trans. No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Liquidar)
            {
                ApplicationArea = All;
                Caption = 'Apply', comment = 'ESP="Liquidar"';
                ToolTip = 'Mark the selected movements as liquidated', comment = 'ESP="Marca como liquidados los movimientos seleccionados"';
                Image = Apply;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    recGlEntry: Record "G/L Entry";
                    conf_Qst: Label 'Do you want to mark the selected movements as liquidated?', comment = 'ESP="¿Desea marcar como liquidados los movimientos seleccionados?"';
                begin
                    if not Confirm(conf_Qst) then
                        exit;

                    recGlEntry.Reset();
                    CurrPage.SetSelectionFilter(recGlEntry);

                    if recGlEntry.FindSet() then
                        recGlEntry.modifyall(Liquidado_btc, true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange(Liquidado_btc, false);
    end;
}
