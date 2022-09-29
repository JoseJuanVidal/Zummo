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
                field("Cta. Contable IVA Recupeacion"; "Cta. Contable IVA Recuperacion")
                {
                    ApplicationArea = all;
                }
                field("Proveedor IVA Recuperacion"; "Proveedor IVA Recuperacion")
                {
                    ApplicationArea = all;
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