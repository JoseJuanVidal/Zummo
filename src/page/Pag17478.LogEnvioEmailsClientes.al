page 17478 "LogEnvioEmailsClientes"
{
    Caption = 'Log Envio Emails Facturas/Abonos', comment = 'ESP="Log Envio Emails Facturas/Abonos"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "LogEnvioEmailsClientes";
    // Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(FechaDocumento_btc; FechaDocumento_btc)
                {
                }
                field(CodCliente_btc; CodCliente_btc)
                {
                }
                field(Enviado_btc; Enviado_btc)
                { }
                field(NombreCliente_btc; NombreCliente_btc)
                { }
                field(FechaEnvio_btc; FechaEnvio_btc)
                { }
                field(TieneError_btc; TieneError_btc)
                { }
                field(DescError_btc; DescError_btc)
                { }
                field(DireccionEmail_btc; DireccionEmail_btc)
                { }
                field(Importe_btc; Importe_btc)
                { }
                field(NoDoc_btc; NoDoc_btc)
                { }
                field(Tipo; Tipo)
                { }
                field(clienteFact_btc; clienteFact_btc)
                { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(EnvioMasivoMail)
            {
                ApplicationArea = all;
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    CUCron: Codeunit CU_Cron;
                begin
                    if confirm('¿Envio de Facturacion electronica?') then
                        CUCron.EnvioMasivoMail();
                end;
            }
        }
    }
}