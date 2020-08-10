pageextension 50170 "TransferOrder_btc" extends "Transfer Order"
{
    layout
    {
        addlast(General)
        {
            field(NumBultos_btc; NumBultos_btc)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(NumPalets_btc; NumPalets_btc)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(Peso_btc; Peso_btc)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(PedidoImpreso; PedidoImpreso)
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
    }

    actions
    {
        modify(Post) { Visible = false; }
        modify(PostAndPrint) { Visible = false; }
        addafter("F&unctions")
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

        addfirst(Reporting)
        {
            action("Imprimir Selec Etiquetas")
            {
                ApplicationArea = all;
                Caption = 'Selección Etiquetas', comment = 'ESP="Selección Etiquetas"';
                ToolTip = 'Imprimir etiquetas',
                    comment = 'ESP="Imprimir etiquetas"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = PrintReport;

                trigger OnAction()
                begin
                    ImprimeSelecionEtiquetas();
                end;
            }
        }
    }

    local procedure ImprimeSelecionEtiquetas()
    var
        recAlbTemp: Record LinAlbCompraBuffer temporary;
        rectransLine: Record "Transfer Line";
        movsImprimir: List of [Integer];
        pageEtiquetas: Page "Selección Etiquetas";
        i: Integer;
        rptPrima: Report EtiquetasGenericas;
    begin
        recAlbTemp.Reset();
        recAlbTemp.DeleteAll();

        rectransLine.Reset();
        rectransLine.SetRange("Document No.", "No.");
        rectransLine.SetFilter("Item No.", '<>%1', '');
        rectransLine.SetRange("Derived From Line No.", 0);
        if rectransLine.FindSet() then
            repeat
                recAlbTemp.Init();
                recAlbTemp.NumAlbaran := rectransLine."Document No.";
                recAlbTemp.NumLinea := rectransLine."Line No.";
                recAlbTemp.NumProducto := rectransLine."Item No.";
                recAlbTemp.DescProducto := rectransLine.Description;
                recAlbTemp.Cantidad := rectransLine.Quantity;
                recAlbTemp.NumMovimiento := rectransLine."Line No.";
                recAlbTemp.NumPedido := recAlbTemp.NumAlbaran;
                recAlbTemp.FechaRegistro := "Posting Date";
                recAlbTemp.Insert();
            until rectransLine.Next() = 0;

        Clear(pageEtiquetas);
        pageetiquetas.LookupMode(true);
        pageEtiquetas.Editable(true);
        pageEtiquetas.SetData(recAlbTemp);
        if pageEtiquetas.RunModal() = Action::LookupOK then begin
            Clear(movsImprimir);
            pageEtiquetas.GetDatos(movsImprimir);

            for i := 1 to movsImprimir.Count do begin
                recAlbTemp.reset;
                recAlbTemp.SetRange(numLinea, movsImprimir.get(i));
                recAlbTemp.FindFirst();

                clear(rptPrima);
                rptPrima.UseRequestPage(false);
                rptPrima.SetData(recAlbTemp);
                rptPrima.Run();
                //Report.Run(Report::EtiquetasGenericas, false, false, recAlbTemp);
            end;
        end;
    end;

    var
        PedidosTransferencia: codeunit Funciones;

}