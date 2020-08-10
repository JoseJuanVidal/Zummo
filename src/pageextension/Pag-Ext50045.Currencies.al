pageextension 50045 "Currencies" extends Currencies
{
    actions
    {
        addafter("Adjust Exchange Rate")
        {
            action(AjustarTipoCambioBanco)
            {
                ApplicationArea = All;
                Caption = 'Bank Adjust Exchange Rate', comment = 'ESP="Ajustar tipo cambio Banco"';
                ToolTip = 'Adjust general ledger, (only bank) account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.',
                    comment = 'ESP="Ajusta los movimientos de contabilidad general, (solo bancos) para que reflejen un saldo más actualizado si el tipo de cambio ha variado desde que se registraron los movimientos."';
                Image = AdjustExchangeRates;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    report.Run(Report::"Adjust Exchange Rates Zummo", true);
                end;
            }
        }
    }
}