pageextension 50026 "Posted Payment Orders" extends "Posted Payment Orders"
{
    layout
    {
        addafter("Posting Date")
        {
            field(DueDate_btc; DueDate_btc)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("&Navigate")
        {
            action(Export)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export to File', Comment = 'ESP="Exportar a archivo"';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Export a file with the payment information on the lines.', Comment = 'ESP="Exporta un archivo con la información de pago de las líneas."';

                trigger OnAction()
                var
                    recPostPmtOrder: Record "Posted Payment Order";
                begin
                    //ExportToFile();

                    recPostPmtOrder.Reset();
                    recPostPmtOrder.SetRange("No.", "No.");
                    REPORT.RUN(REPORT::"ExportN341PostedPmtOrder", TRUE, FALSE, recPostPmtOrder);
                end;
            }
        }
    }

    procedure FilterSourceForExport(var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine.SetRange("Journal Template Name", '');
        GenJnlLine.SetRange("Journal Batch Name", '');
        GenJnlLine.SetRange("Document No.", "No.");
        GenJnlLine."Bal. Account No." := "Bank Account No.";
    end;

    procedure ExportToFile()
    var
        GenJnlLine: Record "Gen. Journal Line";
        BankAccount: Record "Bank Account";
    begin
        SetRecFilter();

        BankAccount.Get("Bank Account No.");
        FilterSourceForExport(GenJnlLine);
        CODEUNIT.Run(BankAccount.GetPaymentExportCodeunitID(), GenJnlLine);
        Find();

        Modify();
    end;
}