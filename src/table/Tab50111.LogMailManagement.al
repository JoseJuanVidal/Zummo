table 50111 "LogMailManagement"
{
    DataClassification = CustomerContent;
    Caption = 'Log Mail Management', comment = 'ESP="Log Mail Management"';

    fields
    {
        field(1; Entry_No; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Caption = 'Entry No.', comment = 'ESP="Nº Movimientos"';
        }

        field(2; FechaDocumento_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date', comment = 'ESP="Fecha Documento"';
        }

        field(3; CodCliente_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.', comment = 'ESP="Cód. Cliente"';
            TableRelation = Customer;
        }

        field(4; Enviado_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sent', comment = 'ESP="Enviado"';
        }

        field(5; NombreCliente_btc; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name', comment = 'ESP="Nombre cliente"';
        }

        field(6; FechaEnvio_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Mail sent date', comment = 'ESP="Fecha envío e-mail"';
        }

        field(7; TieneError_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Has Error', comment = 'ESP="Tiene Error"';
        }

        field(8; DescError_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Error description', comment = 'ESP="Descripción Error"';
        }

        field(9; DireccionEmail_btc; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-mail address', comment = 'ESP="Dirección email"';
        }

        field(10; Importe_btc; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount', comment = 'ESP="Importe"';
        }

        field(11; Tipo; Option)
        {
            OptionMembers = " ","Prox. Vencimientos","Facturas Vencidas";
            OptionCaption = ' ,Prox. Vencimientos,Facturas Vencidas', Comment = 'ESP=" ,Prox. Vencimientos,Facturas Vencidas"';
        }
    }

    keys
    {
        key(PK; Entry_No)
        {
            Clustered = true;
        }
    }
}