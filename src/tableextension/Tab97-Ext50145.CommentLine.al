tableextension 50145 "CommentLine" extends "Comment Line" //97
{

    fields
    {
        field(50100; ComentarioCliente_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Comment', comment = 'ESP="Comentario Cliente"';
        }

        field(50101; Usuario_btc; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User', comment = 'ESP="Usuario"';
        }

        field(50102; Fecha_btc; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date', comment = 'ESP="Fecha"';
        }
        field(50105; AvisoVentas; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales warning', comment = 'ESP="Aviso Ventas"';
        }
    }

    trigger OnInsert()
    begin
        Usuario_btc := UserId();
        Fecha_btc := CreateDateTime(Today, Time);
    end;
}