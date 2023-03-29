pageextension 50014 "PostedSalesShipment" extends "Posted Sales Shipment"
{
    //Nº bultos

    layout
    {
        addafter("Salesperson Code")
        {
            field(Peso_btc; Peso_btc)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(NumPalets_btc; NumPalets_btc)
            {
                ApplicationArea = All;
                Editable = false;
            }

            field(NumBultos_btc; NumBultos_btc)
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(MotivoBloqueo_btc; MotivoBloqueo_btc)
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
        addafter("Posting Date")
        {
            field("Fecha Entrega en destino"; "Fecha Entrega en destino")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addfirst(Processing)
        {

            group(Expedicion)
            {
                Caption = 'Expedition Labels', comment = 'ESP="Etiquetas de expedición"';

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
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        ItemledgerEntry2: Record "Item Ledger Entry";
                        SalesShipmentLine: Record "Sales Shipment Line";
                    begin
                        SalesShipmentLine.reset;
                        SalesShipmentLine.SetRange("Document No.", Rec."No.");
                        SalesShipmentLine.SetFilter(Quantity, '>0');
                        if SalesShipmentLine.FindFirst() then begin

                            ItemLedgerEntry.Reset();
                            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                            ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                            ItemLedgerEntry.SetRange("Document No.", Rec."No.");
                            ItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
                            // 220188 no imprime si no son productos
                            if ItemLedgerEntry.FindFirst() then begin
                                itemledgerEntry2.reset;
                                itemledgerEntry2.SetRange("Entry No.", ItemLedgerEntry."Entry No.");
                                itemledgerEntry2.FindFirst();
                                Report.Run(Report::EtiquetaDeExpedicion, false, false, ItemLedgerEntry2);
                            end else begin
                                // si no tiene movimientos, imprimir una en blanco por producto                               
                                Report.Run(Report::"EtiquetaDeExpedicionShipment", false, false, SalesShipmentLine);

                            end;

                        end;
                    end;
                }
                action("Imprimir Selec Etiquetas")
                {
                    ApplicationArea = all;
                    Caption = 'Selección Etiquetas Exp.', comment = 'ESP="Selección Etiquetas Exp."';
                    ToolTip = 'Imprimir etiquetas',
                    comment = 'ESP="Imprimir etiquetas"';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Report;
                    Image = PrintReport;

                    trigger OnAction()
                    begin
                        ImprimeSelecionEtiquetas(true);
                    end;
                }
            }

            group(EtEmbalaje)
            {
                Caption = 'Etiquetas embalaje', comment = 'ESP="Etiquetas embalaje"';

                action("Imprimir Etiquetas Embalaje")
                {
                    ApplicationArea = all;
                    Caption = 'Etiqueta Embalaje', comment = 'ESP="Etiquetas Embalaje"';
                    ToolTip = 'Imprimir etiquetas',
                    comment = 'ESP="Imprimir etiquetas"';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Report;
                    Image = PrintReport;

                    trigger OnAction()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                        itemledgerEntry2: Record "Item Ledger Entry";
                    begin
                        ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                        ItemLedgerEntry.SetRange("Document No.", Rec."No.");
                        if ItemLedgerEntry.FindFirst() then begin
                            repeat
                                itemledgerEntry2.reset;
                                itemledgerEntry2.SetRange("Entry No.", ItemLedgerEntry."Entry No.");
                                itemledgerEntry2.FindFirst();
                                Report.Run(Report::EtiquetaEmbalaje, false, false, ItemLedgerEntry2);
                            until ItemLedgerEntry.Next() = 0;
                        end;
                    end;
                }

                action("Imprimir Selec Etiquetas Emb")
                {
                    ApplicationArea = all;
                    Caption = 'Selección Etiquetas Emb.', comment = 'ESP="Selección Etiquetas Emb."';
                    ToolTip = 'Imprimir etiquetas',
                    comment = 'ESP="Imprimir etiquetas"';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Report;
                    Image = PrintReport;

                    trigger OnAction()
                    begin
                        ImprimeSelecionEtiquetas(false);
                    end;
                }
            }
            action("Imprimir PackingList")
            {
                ApplicationArea = all;
                Caption = 'Packing List', comment = 'ESP="Packing List"';
                ToolTip = 'PackingList ',
                    comment = 'ESP="Imprimir PackingList"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;
                Image = PrintReport;

                trigger OnAction()
                var
                    recSalesShptHeader: Record "Sales Shipment Header";
                begin
                    recSalesShptHeader.Reset();
                    recSalesShptHeader.SetRange("No.", "No.");
                    Report.Run(Report::PackingList, true, false, recSalesShptHeader);
                end;
            }
            action("Pesos y Bultos")
            {
                ApplicationArea = all;
                Caption = 'Pesos y Bultos', comment = 'ESP="Pesos y Bultos"';
                ToolTip = 'Pesos y Bultos',
                    comment = 'ESP="Pesos y Bultos"';
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
                    pageAbrir.SetEnvioOrigen('', Rec."No.", '');
                    pageAbrir.SetEnviosDatos(Rec);

                    if pageAbrir.RunModal() = Action::LookupOK then begin
                        pageAbrir.GetDatos(peso, numPalets, numBultos);

                        NumBultos_btc := numBultos;
                        NumPalets_btc := numPalets;
                        Peso_btc := peso;
                        pageAbrir.SetDatos(Peso_btc, NumPalets_btc, NumBultos_btc);
                    end;
                end;
            }

        }
    }

    local procedure ImprimeSelecionEtiquetas(pExpedicion: Boolean)
    var
        ItemLedgerEntry2: Record "Item Ledger Entry";
        recAlbTemp: Record LinAlbCompraBuffer temporary;
        recLinAlbaran: Record "Sales Shipment Line";
        movsImprimir: List of [Integer];
        pageEtiquetas: Page "Selección Etiquetas";
        i: Integer;
    begin
        recAlbTemp.Reset();
        recAlbTemp.DeleteAll();

        recLinAlbaran.Reset();
        recLinAlbaran.SetRange("Document No.", rec."No.");
        recLinAlbaran.SetRange(Type, recLinAlbaran.Type::Item);
        recLinAlbaran.SetFilter(Quantity, '<>%1', 0);
        recLinAlbaran.SetFilter("Item Shpt. Entry No.", '<>%1', 0);
        if recLinAlbaran.FindSet() then
            repeat
                recAlbTemp.Init();
                recAlbTemp.NumAlbaran := recLinAlbaran."Document No.";
                recAlbTemp.NumLinea := recLinAlbaran."Line No.";
                recAlbTemp.NumProducto := recLinAlbaran."No.";
                recAlbTemp.DescProducto := recLinAlbaran.Description;
                //recAlbTemp.Cantidad := recLinAlbaran.Quantity;
                recAlbTemp.Cantidad := 0;
                recAlbTemp.NumMovimiento := recLinAlbaran."Item Shpt. Entry No.";
                recAlbTemp.Insert();
            until recLinAlbaran.Next() = 0;

        Clear(pageEtiquetas);
        pageetiquetas.LookupMode(true);
        pageEtiquetas.Editable(true);
        pageEtiquetas.SetData(recAlbTemp);
        if pageEtiquetas.RunModal() = Action::LookupOK then begin
            Clear(movsImprimir);
            pageEtiquetas.GetDatos(movsImprimir);

            for i := 1 to movsImprimir.Count do begin
                itemledgerEntry2.reset;
                itemledgerEntry2.SetRange("Entry No.", movsImprimir.get(i));
                itemledgerEntry2.FindFirst();

                if pExpedicion then
                    Report.Run(Report::EtiquetaDeExpedicion, false, false, ItemLedgerEntry2)
                else
                    Report.Run(Report::EtiquetaEmbalaje, false, false, ItemLedgerEntry2);
            end;
        end;
    end;
}