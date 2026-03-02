pageextension 50167 "PostedTransferReceipt" extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Transfer Order No."; "Transfer Order No.")
            {
                ApplicationArea = All;
            }

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
            action("Imprimir Etiqueta Expedicion")
            {
                ApplicationArea = all;
                Caption = 'Etiquetas Expedicion', comment = 'ESP="Etiqueta Expedicion"';
                ToolTip = 'Imprimir etiquetas',
                    comment = 'ESP="Imprimir etiquetas"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = PrintReport;

                trigger OnAction()
                var
                    TransferRcpHeader: Record "Transfer Receipt Header";
                    EtiquetExp: report "EtiquetaDeExpedicion PedTransf";
                begin
                    TransferRcpHeader.SetRange("No.", Rec."No.");
                    EtiquetExp.SetTableView(TransferRcpHeader);
                    EtiquetExp.Run();
                end;
            }
        }
    }
}