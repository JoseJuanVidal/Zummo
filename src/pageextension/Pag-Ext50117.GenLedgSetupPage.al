pageextension 50117 "GenLedgSetupPage" extends "General Ledger Setup"
{
    layout
    {
        addafter(Application)
        {
            group(Bitec)
            {
                Caption = 'Bitec', comment = 'ESP="Bitec"';

                field(TipoCambioPorFechaEmision_btc; TipoCambioPorFechaEmision_btc)
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter("Allow Posting To")
        {
            field(BloqueoCompras; BloqueoCompras)
            {

            }
            field(BloqueoVentas; BloqueoVentas) { }
        }
    }
}