pageextension 50162 "PostedPurchaseReceipt" extends "Posted Purchase Receipt"
{
    layout
    {
        modify("Vendor Shipment No.")
        {
            Editable = true;
        }

        addlast(FactBoxes)
        {
            part(Documents; "ZM SH Record Link Sharepoints")
            {
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action(MarcaNoFacturar)
            {
                ApplicationArea = all;
                Caption = 'Marcar no facturar', comment = 'ESP="Marcar no facturar"';
                Image = Check;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;

                begin
                    Funciones.MarcarNoFacturar(Rec);
                end;

            }
        }
        addfirst(Reporting)
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
                begin
                    // CurrPage.PurchReceiptLines.Page.ImprimirEtiqueta();
                    ImprimirEtiqueta();
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

        }
    }


    trigger OnAfterGetRecord()
    begin
        CurrPage.Documents.Page.SetRecordIR(Rec.RecordId, StrSubstNo('%1 %2', rec."Buy-from Vendor No.", Rec."No."));
    end;

    local procedure ImprimeSelecionEtiquetas()
    var
        ItemLedgerEntry2: Record "Item Ledger Entry";
        recAlbTemp: Record LinAlbCompraBuffer temporary;
        recLinAlbaran: Record "Purch. Rcpt. Line";
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
        recLinAlbaran.SetFilter("Item Rcpt. Entry No.", '<>%1', 0);
        if recLinAlbaran.FindSet() then
            repeat
                recAlbTemp.Init();
                recAlbTemp.NumAlbaran := recLinAlbaran."Document No.";
                recAlbTemp.NumLinea := recLinAlbaran."Line No.";
                recAlbTemp.NumProducto := recLinAlbaran."No.";
                recAlbTemp.DescProducto := recLinAlbaran.Description;
                recAlbTemp.Cantidad := recLinAlbaran.Quantity;
                recAlbTemp.NumMovimiento := GetEntryNo(recLinAlbaran);

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
                ItemLedgerEntry2.reset;
                ItemLedgerEntry2.SetRange("Entry No.", movsImprimir.get(i));
                ItemLedgerEntry2.FindFirst();
                Report.Run(Report::EtiquetaMateriaPrima, false, false, ItemLedgerEntry2);
            end;
        end;
    end;

    local procedure GetEntryNo(recLinAlbaran: Record "Purch. Rcpt. Line"): Integer
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchaseLine: Record "Purchase Line";
    begin
        if ItemLedgerEntry.Get(recLinAlbaran."Item Rcpt. Entry No.") then
            if ItemLedgerEntry."Document No." = recLinAlbaran."Document No." then
                exit(recLinAlbaran."Item Rcpt. Entry No.");

        // si es una subcontratación, que es tipo Salida de Fabrica la buscamos
        PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", recLinAlbaran."Order No.");
        PurchaseLine.SetRange("line No.", recLinAlbaran."Line No.");
        if PurchaseLine.FindFirst() then begin
            ItemLedgerEntry.Reset();
            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
            ItemLedgerEntry.SetRange("Posting Date", Rec."Posting Date");
            ItemLedgerEntry.SetRange("Order No.", PurchaseLine."Prod. Order No.");
            ItemLedgerEntry.SetRange("Order Line No.", PurchaseLine."Prod. Order Line No.");
            if ItemLedgerEntry.FindFirst() then
                exit(ItemLedgerEntry."Entry No.");
        end;
    end;

    procedure ImprimirEtiqueta()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntry2: Record "Item Ledger Entry";
        PurchReceiptLine: Record "Purch. Rcpt. Line";
        PurchaseLine: Record "Purchase Line";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        ItemLedgerEntry.SetRange(ItemLedgerEntry."Document No.", Rec."No.");
        if ItemLedgerEntry.FindFirst() then begin
            repeat
                ItemLedgerEntry2.reset;
                ItemLedgerEntry2.SetRange("Entry No.", ItemLedgerEntry."Entry No.");
                ItemLedgerEntry2.FindFirst();
                Report.Run(Report::EtiquetaMateriaPrima, false, false, ItemLedgerEntry2);
            until ItemLedgerEntry.Next() = 0;
        end else begin
            // aqui buscamos los movimientos de producto por subcontratación
            PurchReceiptLine.Reset();
            PurchReceiptLine.SetRange("Document No.", Rec."No.");
            PurchReceiptLine.SetRange(Type, PurchReceiptLine.Type::Item);
            PurchReceiptLine.SetFilter(Quantity, '>0');
            if PurchReceiptLine.FindFirst() then
                repeat
                    PurchaseLine.SetRange(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange("Document No.", PurchReceiptLine."Order No.");
                    PurchaseLine.SetRange("line No.", PurchReceiptLine."Line No.");
                    if PurchaseLine.FindFirst() then begin
                        ItemLedgerEntry.Reset();
                        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
                        ItemLedgerEntry.SetRange("Posting Date", Rec."Posting Date");
                        ItemLedgerEntry.SetRange("Order No.", PurchaseLine."Prod. Order No.");
                        ItemLedgerEntry.SetRange("Order Line No.", PurchaseLine."Prod. Order Line No.");
                        if ItemLedgerEntry.FindFirst() then
                            repeat
                                ItemLedgerEntry2.reset;
                                ItemLedgerEntry2.SetRange("Entry No.", ItemLedgerEntry."Entry No.");
                                ItemLedgerEntry2.FindFirst();
                                ItemLedgerEntry2."Item Category Code" := PurchaseLine."Document No.";
                                Report.Run(Report::EtiquetaMateriaPrima, false, false, ItemLedgerEntry2);
                            Until ItemLedgerEntry.next() = 0;
                    end;
                Until PurchReceiptLine.next() = 0;
        end;
    end;

}