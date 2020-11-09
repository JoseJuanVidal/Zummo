pageextension 50132 "SalesOrder" extends "Sales Order"
{
    layout
    {
        addbefore("Posting Date")
        {
            field(FechaRecepcionMail_btc; FechaRecepcionMail_btc)
            {
                ApplicationArea = All;
                ToolTip = 'Fecha recepción email del cliente', comment = 'ESP="Fecha recepción email del cliente"';
                Enabled = true;
            }
            field(Abono; Abono)
            {
                ApplicationArea = all;
            }
            field(FechaAltaPedido; FechaAltaPedido)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

        addafter("Due Date")
        {
            field(FechaEnvio; "Shipment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Fecha envío', comment = 'ESP="Fecha envío"';
                Enabled = true;
            }
        }
        addbefore("Work Description")
        {

            field(CentralCompras_btc; CentralCompras_btc)
            {
                ApplicationArea = all;
            }
            field(ClienteCorporativo_btc; ClienteCorporativo_btc)
            {
                ApplicationArea = all;
            }
            field(AreaManager_btc; AreaManager_btc)
            {
                ApplicationArea = all;
            }
            field(Delegado_btc; Delegado_btc)
            {
                ApplicationArea = all;
            }

            field(GrupoCliente_btc; GrupoCliente_btc)
            {
                ApplicationArea = all;
            }
            field(Perfil_btc; Perfil_btc)
            {
                ApplicationArea = all;
            }
            field(SubCliente_btc; SubCliente_btc)
            {
                ApplicationArea = all;
            }
            field(ClienteReporting_btc; ClienteReporting_btc)
            {
                ApplicationArea = all;
            }

            field(MotivoBloqueo_btc; MotivoBloqueo_btc)
            {
                ApplicationArea = All;
            }

        }
        //Comentario interno pedidos venta
        addbefore("Work Description")
        {
            field(ComentarioInterno_btc; ComentarioInterno_btc)
            {
                ApplicationArea = All;
            }
        }
        addbefore("Work Description")
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }

        addafter("Area")
        {
            field(CodEnvio; "Shipment Method Code")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
        }

        modify("Shipment Method Code")
        {
            Visible = false;
        }

        //121219 S19/01403 Fechas pedido venta
        modify("Order Date")
        {
            Caption = 'Order Date', comment = 'ESP="Fecha Alta"';
        }

    }
    actions
    {
        modify("Create Inventor&y Put-away/Pick")
        {
            Visible = false;
        }
        modify(Action3)
        {
            Visible = false;
        }
        modify("Pick Instruction")
        {
            Visible = false;
        }
        modify("In&vt. Put-away/Pick Lines")
        {
            Visible = false;
        }
        modify("Warehouse Shipment Lines")
        {
            Visible = false;
        }
        modify(Release)
        {
            Visible = false;
        }
        modify(Reopen)
        {
            Visible = false;
        }
        modify(Post)
        {
            Visible = false;
        }
        modify(PostAndNew)
        {
            Visible = false;
        }


        addbefore(Post)
        {
            action(RegistrarFran)
            {
                ApplicationArea = All;
                Caption = 'P&ost', comment = 'ESP="R&egistrar"';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', comment = 'ESP="Finaliza el documento o el diario registrando los importes y las cantidades en las cuentas relacionadas de los libros de su empresa."';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category6;
                Image = PostOrder;
                Ellipsis = true;
                ShortcutKey = F9;

                trigger OnAction()
                var
                    recNumSerie: Record "No. Series";
                    recSalesHeader: Record "Sales Header";
                    recNomSeriesLin: Record "No. Series Line";
                    ErrorMessageMgt: Codeunit "Error Message Management";
                    ErrorMessageHandler: Codeunit "Error Message Handler";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    IsSuccess: Boolean;
                    codUltimoNumUsado: Code[20];
                begin
                    if (Rec."Document Date" < Today()) or (rec."Posting Date" < Today()) then begin
                        rec.Validate("Document Date", Today());
                        rec.Validate("Posting Date", today());
                        rec.Modify();
                    end;

                    COMMIT();

                    // Obtengo nº serie registro actual
                    codUltimoNumUsado := '';

                    recNumSerie.Reset();
                    recNumSerie.SetRange(Code, "Posting No. Series");
                    if recNumSerie.FindFirst() then begin
                        Clear(NoSeriesMgt);
                        NoSeriesMgt.SetNoSeriesLineFilter(recNomSeriesLin, recNumSerie.Code, 0D);

                        if recNomSeriesLin.FindLast() then
                            codUltimoNumUsado := recNomSeriesLin."Last No. Used";
                    end;

                    ErrorMessageMgt.Activate(ErrorMessageHandler);
                    IsSuccess := CODEUNIT.RUN(CODEUNIT::"Sales-Post (Yes/No)", Rec);

                    IF NOT IsSuccess THEN begin
                        //if Invoice and (codUltimoNumUsado <> '') then begin
                        if (codUltimoNumUsado <> '') then begin
                            recSalesHeader.Reset();
                            recSalesHeader.SetRange("Document Type", rec."Document Type");
                            recSalesHeader.SetRange("No.", rec."No.");
                            if recSalesHeader.FindFirst() then begin
                                if recSalesHeader."Posting No." <> '' then begin
                                    recNomSeriesLin.FindLast();
                                    recNomSeriesLin."Last No. Used" := codUltimoNumUsado;
                                    recNomSeriesLin.Modify(false);

                                    Commit();

                                    recSalesHeader."Posting No." := '';
                                    recSalesHeader.Modify(false);
                                    Commit();
                                end;
                            end;
                        end;

                        ErrorMessageHandler.ShowErrors();
                    end;
                end;
            }
        }
        addafter(DocAttach)
        {

            action(InsertarComentariosPredefinidos)
            {
                ApplicationArea = All;
                Image = NewProperties;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Insert predefined comments', comment = 'ESP="Insertar comentarios predefinidos"';
                ToolTip = 'Insert the comments in the table of predefined comments as order comments',
                    comment = 'ESP="Inserta como comentarios de pedido los comentarios que haya en la tabla de comentarios predefinidos"';

                trigger OnAction()
                var
                    recComentario: Record ComentariosPredefinidos;
                    pageComentarios: page "Lista comentarios predefinidos";
                begin
                    clear(pageComentarios);
                    pageComentarios.LookupMode(true);

                    if pageComentarios.RunModal() = Action::LookupOK then begin
                        pageComentarios.GetRecord(recComentario);
                        SetWorkDescription(recComentario.GetComentario());
                    end;
                end;
            }
            action(Movimientos)
            {
                ApplicationArea = all;
                Caption = 'Trazabilidad Serie', comment = 'ESP="Trazabilidad Serie"';
                ToolTip = 'Movimientos',
                    comment = 'ESP="Trazabilidad Serie"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Track;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                    tempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                begin

                    Funciones.ObtenerMtosTrazabilidadNumSerie('', tempItemLedgerEntry, true)

                end;
            }



            action("Impimir Pedido")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                Caption = 'Imprimir Pedido Zummo', comment = 'ESP="Imprimir Pedido Zummo"';
                ToolTip = 'Impimir Fact.Export',
                    comment = 'ESP="Imprimir Pedido Zummo"';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    rSalesHead: Record "Sales Header";
                    Selection: Integer;
                    rep: Report PedidoCliente;
                begin
                    Commit();
                    Selection := STRMENU('1.-Pedido Nac,2.-Pedido Exp', 1);
                    SalesHeader.Reset();
                    IF Selection > 0 THEN begin

                        SalesHeader.get(Rec."Document Type", Rec."No.");

                        rSalesHead.Reset();
                        rSalesHead.SetRange("Document Type", "Document Type");
                        rSalesHead.SetRange("No.", "No.");

                        if SalesHeader.FindFirst() then
                            case Selection of
                                1:
                                    begin
                                        rep.Pvalorado(true);
                                        rep.Pneto(false);
                                        //if (SalesHeader."Document Type" = SalesHeader."Document Type"::Quote) then
                                        rep.PTipoDocumento(1);//1 pedido 2 proforma

                                        rep.SetTableView(rSalesHead);
                                        rep.run();
                                        // Report.Run(Report::PedidoCliente, true, false, SalesHeader); //50102
                                    end;
                                2:
                                    begin
                                        rep.Pvalorado(true);
                                        rep.Pneto(true);
                                        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Quote) then
                                            rep.PTipoDocumento(1);//1 pedido 2 proforma
                                        rep.SetTableView(rSalesHead);
                                        rep.run();
                                        // Report.Run(Report::PedidoCliente, true, false, SalesHeader); //50102
                                    end;


                            end;
                    end;
                end;
            }

            action(Descuentos)
            {
                ApplicationArea = All;
                //RunObject = page Descuentos;
                //RunPageLink = "No." = field ("No."), "Document Type" = field ("Document Type");
                trigger OnAction()
                var
                    SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
                begin
                    commit;
                    page.RunModal(50001, Rec);
                    OpenSalesOrderStatistics;
                    SalesCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                end;
            }
            action(DescuentosPorc)
            {
                ApplicationArea = All;
                Caption = 'Dto. %', comment = 'ESP="Dto. %"';
                //RunObject = page Descuentos;
                //RunPageLink = "No." = field ("No."), "Document Type" = field ("Document Type");
                trigger OnAction()
                var
                    SalesLine: record "Sales Line";
                    DocumentTotals: Codeunit "Document Totals";
                    SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
                    pDescuento: page Descuentos;
                    AmountWithDiscountAllowed: Decimal;
                    InvoiceDiscountAmount: Decimal;
                    Currency: record Currency;
                begin
                    commit;
                    Currency.InitRoundingPrecision;
                    SalesLine.reset;
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.FindFirst();

                    //page.RunModal(50001, Rec);
                    /*pDescuento.SetDtoPorc();
                    pDescuento.SetTableView(Rec);
                    pDescuento.RunModal();*/
                    //OpenSalesOrderStatistics;
                    DocumentTotals.SalesDocTotalsNotUpToDate;
                    AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(SalesLine);
                    InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * rec.DescuentoFactura / 100, Currency."Amount Rounding Precision");
                    SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, rec);
                    DocumentTotals.SalesDocTotalsNotUpToDate;

                    CurrPage.UPDATE(FALSE);


                end;
            }
        }
    }

}