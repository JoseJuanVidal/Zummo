tableextension 50121 "GenLedgerSetup" extends "General Ledger Setup"  //98
{
    fields
    {
        field(50100; TipoCambioPorFechaEmision_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Calculate the exchange rate by document date', comment = 'ESP="Calcular el tipo de cambio por fecha de emisión"';
        }
        field(50101; BloqueoCompras; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'BloqueoCompras', comment = 'ESP="Bloqueo Compras"';
        }
        field(50102; BloqueoVentas; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'BloqueoVentas', comment = 'ESP="Bloqueo Ventas"';
        }
    }
}