table 50109 "LogEnvioEmailsClientes"
{
    DataClassification = CustomerContent;
    Caption = 'Sent Emails Customer Log', comment = 'ESP="Log envío emails clientes"';

    fields
    {
        field(1; FechaDocumento_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date', comment = 'ESP="Fecha Documento"';
        }

        field(2; CodCliente_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.', comment = 'ESP="Cód. Cliente"';
            TableRelation = Customer;
        }

        field(3; Enviado_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sent', comment = 'ESP="Enviado"';
        }

        field(4; NombreCliente_btc; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name', comment = 'ESP="Nombre cliente"';
        }

        field(5; FechaEnvio_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Mail sent date', comment = 'ESP="Fecha envío e-mail"';
        }

        field(6; TieneError_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Has Error', comment = 'ESP="Tiene Error"';
        }

        field(7; DescError_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Error description', comment = 'ESP="Descripción Error"';
        }

        field(8; DireccionEmail_btc; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-mail address', comment = 'ESP="Dirección email"';
        }

        field(9; Importe_btc; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount', comment = 'ESP="Importe"';
        }

        field(10; NoDoc_btc; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.', comment = 'ESP="No. Documento"';
        }

        field(11; Tipo; Option)
        {
            OptionMembers = " ","Factura","Abono";
            OptionCaption = ' ,Factura,Abono', Comment = 'ESP=" ,Factura,Abono"';
        }

        field(12; clienteFact_btc; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No. Invoice', comment = 'ESP="Cliente facturación"';
        }
    }

    keys
    {
        key(PK; FechaDocumento_btc, CodCliente_btc)
        {
            Clustered = true;
        }
    }
}