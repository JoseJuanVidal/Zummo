report 50101 "CrearFacturasPeriodicas"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Create period invoices (process)', comment = 'ESP="Crear facturas periódicas (proceso)"';

    dataset
    {
        dataitem("Standard Customer Sales Code"; "Standard Customer Sales Code")
        {
            RequestFilterFields = "Customer No.", Code;

            trigger OnPreDataItem()
            begin
                SetFilter("Valid From Date", '%1|<=%2', 0D, WorkDate());
                SetFilter("Valid To date", '%1|>=%2', 0D, WorkDate());
                SetRange(Blocked, false);
                SetFilter(ProximaFechaFactura_btc, '<=%1', WorkDate());
            end;

            trigger OnAfterGetRecord()
            begin
                SetLlamadaDesdeReport(true);
                validate(UltimaFechaFactura_btc, WorkDate());
                Modify();

                CreateSalesInvoice(WorkDate(), WorkDate());
            end;
        }
    }
}