tableextension 50109 "Contact" extends Contact //5050
{
    fields
    {
        field(50151; EnviarEmailPedCompra_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Send e-mail purchase order', comment = 'ESP="Enviar email pedido compra"';
            Description = 'Bitec';
            ObsoleteState = Removed;
        }

        field(50150; EnviarEmailPedCompra2_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Send e-mail purchase order', comment = 'ESP="Enviar email pedido compra"';
            Description = 'Bitec';
        }
    }
}