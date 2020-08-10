report 50135 "LanzaEnvioMailsVencimientos"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Launch sending due emails (process)', comment = 'ESP="Lanza envío emails vencimientos (proceso)"';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            var
                cduCron: Codeunit CU_Cron;
                recLogEnvio: Record LogMailManagement;
            begin
                recLogEnvio.Reset();
                if recLogEnvio.FindFirst() and (UserId = 'BC') then
                    recLogEnvio.DeleteAll();

                cduCron.AvisosFacturasVencidas();
            end;
        }
    }
}