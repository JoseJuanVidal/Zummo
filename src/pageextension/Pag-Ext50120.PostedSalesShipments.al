pageextension 50120 "PostedSalesShipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("No. Printed")
        {
            field("Order No."; "Order No.")
            {
                ApplicationArea = All;
            }
            field(NumFactura__btc; NumFactura_btc)
            {
                ApplicationArea = All;
            }
            field(MotivoBloqueo_btc; MotivoBloqueo_btc)
            {
                ApplicationArea = All;
                Editable = true;
            }
            field(Peso_btc; Peso_btc)
            {
                ApplicationArea = All;
            }
            field(NumPalets_btc; NumPalets_btc)
            {
                ApplicationArea = All;
            }
            field(NumBultos_btc; NumBultos_btc)
            {
                ApplicationArea = All;
            }
            field(PdtFacturar; PdtFacturar)
            {
                ApplicationArea = all;
            }
            field(BaseImponibleLinea; BaseImponibleLinea)
            {
                ApplicationArea = all;
            }
            field(TotalImponibleLinea; TotalImponibleLinea)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {

            action("Imprimir Etiquetas")
            {
                ApplicationArea = all;
                Caption = 'Etiquetas', comment = 'ESP="Etiquetas"';
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
                            Report.Run(Report::EtiquetaDeExpedicion, false, false, ItemLedgerEntry2);
                        until ItemLedgerEntry.Next() = 0;
                    end;
                end;
            }

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

                    if pageAbrir.RunModal() = Action::LookupOK then begin
                        pageAbrir.GetDatos(peso, numPalets, numBultos);

                        NumBultos_btc := numBultos;
                        NumPalets_btc := numPalets;
                        Peso_btc := peso;

                        if Modify() then;

                    end;
                end;
            }
            action("Rellenar NºFactura")
            {
                ApplicationArea = all;
                Caption = 'Rellenar NºFactura', comment = 'ESP="Rellenar NºFactura"';
                ToolTip = 'Rellenar NºFactura',
                    comment = 'ESP="Rellenar NºFactura"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Balance;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                    Albaran: record "Sales Shipment Header";
                    NumFactura: Code[20];
                begin
                    Albaran.SetRange(NumFactura_btc, '');
                    if Albaran.FindSet() then
                        repeat
                            if Albaran.NumFactura_btc = '' then begin
                                NumFactura := Funciones.ObtenerNumFacturaAlbaran(Albaran);
                                if (NumFactura <> '') then begin
                                    Albaran.NumFactura_btc := NumFactura;
                                    Albaran.Modify();
                                end;
                            end;
                        until Albaran.Next() = 0;
                end;
            }
            action(calcularImportes)
            {
                ApplicationArea = all;
                Caption = 'Calcular Importes', comment = 'ESP="Calcular importes"';
                Image = Calculate;

                trigger OnAction()
                var
                    SalesShipmentLine: Record "Sales Shipment Line";
                    SalesLine: Record "Sales Line";
                    Funciones: Codeunit SalesEvents;
                    Ventana: Dialog;
                begin
                    if Not confirm('¿Desea recalcular los importe de los albaranes') then
                        exit;
                    ventana.Open('Albaran #1###############');
                    if SalesShipmentLine.findset() then
                        repeat
                            Ventana.Update(1, SalesShipmentLine."Document No.");
                            if SalesLine.Get(salesline."Document Type"::Order, SalesShipmentLine."Order No.", SalesShipmentLine."Order Line No.") then begin
                                Funciones.SalesShptLineInsertUpdateModifyField(SalesShipmentLine, SalesLine);
                            end;
                        Until SalesShipmentLine.next() = 0;
                    Ventana.Close;
                end;
            }

        }
    }

    local procedure ImprimeSelecionEtiquetas()
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
                Report.Run(Report::EtiquetaDeExpedicion, false, false, ItemLedgerEntry2);
            end;
        end;
    end;
}