pageextension 50027 "PaymentOrders" extends "Payment Orders"
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

        addafter("Export Electronic Payment")
        {
            field("Elect. Pmts Exported"; "Elect. Pmts Exported")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(Export)
        {
            action(ExportZummo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export to File', Comment = 'ESP="Exportar por Fecha Pago"';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Export a file with the payment information on the lines.', Comment = 'ESP="Exporta un archivo con la información de pago de las líneas."';

                trigger OnAction()
                var
                    recPostPmtOrder: Record "Payment Order";
                begin
                    recPostPmtOrder.Reset();
                    recPostPmtOrder.SetRange("No.", "No.");
                    REPORT.RUN(REPORT::"PO - Export N34.1_", TRUE, FALSE, recPostPmtOrder);
                end;
            }
        }
    }
}