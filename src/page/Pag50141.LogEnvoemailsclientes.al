page 50141 "Log Envío e-mails clientes"
{

    PageType = List;
    SourceTable = LogMailManagement;
    Caption = 'Log Sending client emails', Comment = 'ESP="Log Envío e-mails clientes"';
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
                field(FechaEnvio_btc; FechaEnvio_btc)
                {
                    ApplicationArea = All;
                }

                field(FechaDocumento_btc; FechaDocumento_btc)
                {
                    ApplicationArea = All;
                }
                field(CodCliente_btc; CodCliente_btc)
                {
                    ApplicationArea = All;
                }
                field(NombreCliente_btc; NombreCliente_btc)
                {
                    ApplicationArea = All;
                }
                field(Tipo; Tipo)
                {
                    ApplicationArea = all;
                }
                field(Enviado_btc; Enviado_btc)
                {
                    ApplicationArea = All;
                }
                field(DireccionEmail_btc; DireccionEmail_btc)
                {
                    ApplicationArea = All;
                }
                field(TieneError_btc; TieneError_btc)
                {
                    ApplicationArea = All;
                }
                field(DescError_btc; DescError_btc)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
