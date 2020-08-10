pageextension 50104 "TransferOrders" extends "Transfer Orders"
{
    layout
    {
        addafter("Direct Transfer")
        {
            field(PedidoImpreso; PedidoImpreso)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(Reporting)
        {
            action("Pesos y Bultos")
            {
                ApplicationArea = all;
                Caption = 'Pesos y Bultos', comment = 'ESP="Pesos y Bultos"';
                ToolTip = 'Pesos y Bultos', comment = 'ESP="Pesos y Bultos"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Balance;

                trigger OnAction()
                var
                    pageAbrir: Page RegistrarEnvio;
                    peso: Decimal;
                    numPalets: Integer;
                    numBultos: Integer;
                begin
                    Clear(pageAbrir);
                    pageAbrir.LookupMode(true);
                    pageAbrir.SetDatos(Peso_btc, NumPalets_btc, NumBultos_btc);

                    if pageAbrir.RunModal() = Action::LookupOK then begin
                        pageAbrir.GetDatos(peso, numPalets, numBultos);

                        NumBultos_btc := numBultos;
                        NumPalets_btc := numPalets;
                        Peso_btc := peso;

                        if Modify() then;
                    end;
                end;
            }
        }
    }

    procedure GetResult(VAR transferHeader: Record "Transfer Header")
    begin
        CurrPage.SETSELECTIONFILTER(transferHeader);
    end;
}