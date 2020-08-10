pageextension 50183 "ClosedPaymentOrders" extends "Closed Payment Orders"
{
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
                    recPostPmtOrder: Record "Closed Payment Order";
                begin
                    recPostPmtOrder.Reset();
                    recPostPmtOrder.SetRange("No.", "No.");
                    REPORT.RUN(REPORT::"ExportN341ClosedPmtOrder", TRUE, FALSE, recPostPmtOrder);
                end;
            }
        }
    }
}