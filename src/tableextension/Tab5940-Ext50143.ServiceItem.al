tableextension 50143 "Service Item" extends "Service Item"
//5940
{
    fields
    {
        field(50100; CodAnterior_btc; Code[20])
        {
            Caption = 'Cod.Anterior', comment = 'ESP="Cod.Anterior"';
        }
        field(50110; CodSerieHistorico_btc; Code[20])
        {
            Caption = 'Nº.Serie.Historico', comment = 'ESP="Nº.Serie.Histórico"';
        }
    }
}