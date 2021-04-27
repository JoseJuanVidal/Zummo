/*table 50101 "ComentariosVarios"
{
    DataClassification = CustomerContent;
    Caption = 'Various Comments', comment = 'ESP="Comentarios varios"';

    //DrillDownPageId = ComentariosVarios;
    //LookupPageId = ComentariosVarios;

    fields
    {
        field(1; TablaOrigen_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Origin', comment = 'ESP="Origen"';
        }

        field(2; No_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="No."';
        }

        field(3; TipoComentario_btc; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Lock Comment";
            OptionCaption = ' ,Lock Comment', Comment = 'ESP=" ,Comentario Bloqueo"';
        }

        field(4; NumLinea_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Comment Line No.', comment = 'ESP="Nº línea comentario"';
        }

        field(5; Comentario_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment', comment = 'ESP="Comentario"';
        }
    }

    keys
    {
        key(PK; TablaOrigen_btc, No_btc, TipoComentario_btc, NumLinea_btc)
        {
            Clustered = true;
        }
    }
}*/