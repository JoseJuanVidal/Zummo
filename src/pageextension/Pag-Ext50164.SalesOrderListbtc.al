pageextension 50164 "SalesOrderList_btc" extends "Sales Order List"
{//9305
    layout
    {

        addafter("Location Code")
        {
            // lo quitamos de la lista, porque BITEC lo paso a la extension SGA y ha duplicado el campo
            /*field(ImpresoAlmacen_btc; ImpresoAlmacen_btc)
            {
                ApplicationArea = All;
            }*/
            field(AmountcostLines; AmountcostLines)
            {
                Caption = 'Importe Coste', comment = 'ESP="Importe Coste"';
                ApplicationArea = all;
                ToolTip = 'Especifica la suma de los importes del campo Coste unitario por unidades de las líneas de pedido de venta.';
            }
            field("Payment Method Code"; "Payment Method Code")
            {
                ApplicationArea = All;
            }
            field("Quote No.2"; "Quote No.")
            {
                ApplicationArea = All;
            }
            field(Abono; Abono)
            {
                ApplicationArea = all;
            }
            field(ComentarioInterno_btc; ComentarioInterno_btc)
            {
                ApplicationArea = all;
            }
            field("ABC Cliente"; "ABC Cliente")
            {
                ApplicationArea = all;
                Visible = false;
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
        modify(Post)
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
                PromotedCategory = Category7;
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
                    if (Rec."Document Date" < workdate()) or (rec."Posting Date" < workdate()) then begin
                        rec.Validate("Document Date", workdate());
                        rec.Validate("Posting Date", workdate());
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
        addfirst("F&unctions")
        {
            action(Movimientos)
            {
                ApplicationArea = all;
                Caption = 'Trazabilidad Serie', comment = 'ESP="Trazabilidad Serie"';
                ToolTip = 'Trazabilidad Serie',
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
                    Customer: Record Customer;
                    Selection: Integer;
                    rep: Report PedidoCliente;
                begin
                    Commit();
                    Selection := STRMENU('1.-Pedido Nac,2.-Pedido Exp', 1);
                    // Message(Format(Selection));
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
                                        // buscamos el campo de customer, de si el cliente se obliga a NETO
                                        if Customer.Get(Rec."Sell-to Customer No.") then
                                            rep.Pneto(Customer."Mostrar Documentos Netos")
                                        else
                                            rep.Pneto(false);
                                        rep.PTipoDocumento(1);//1 pedido 2 proforma
                                        rep.SetTableView(rSalesHead);
                                        rep.run();
                                        // Report.Run(Report::PedidoCliente, true, false, SalesHeader); //50102
                                    end;
                                2:
                                    begin
                                        rep.Pvalorado(true);
                                        rep.Pneto(true);
                                        rep.PTipoDocumento(1);//1 pedido 2 proforma
                                        rep.SetTableView(rSalesHead);
                                        rep.run();
                                        // Report.Run(Report::PedidoCliente, true, false, SalesHeader); //50102
                                    end;

                            end;
                    end;
                end;
            }
            action("Listado NºSerie")
            {
                ApplicationArea = all;
                Caption = 'Listado NºSerie', comment = 'ESP="Listado NºSerie"';
                ToolTip = 'Listado NºSerie',
                    comment = 'ESP="Listado NºSerie"';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Report;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                    tempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                begin

                    Funciones.ObtenerMtosVentaSerie(tempItemLedgerEntry, true)

                end;
            }
        }
        addafter("Delete Invoiced")
        {
            action(PackginListShipment)
            {
                Caption = 'Packing List', comment = 'ESP="Lista de bultos"';
                ApplicationArea = all;
                Image = NewShipment;

                trigger OnAction()
                begin
                    ActionPackginListOrder();
                end;

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AmountcostLines := CalcAmountcostLines();
    end;

    Var
        Saleslines: record "Sales Line";
        AmountcostLines: Decimal;

    procedure GetResult(VAR SalesHeader: Record "Sales Header")
    begin
        CurrPage.SETSELECTIONFILTER(SalesHeader);
    end;

    local procedure ActionPackginListOrder()
    var
        Funtions: Codeunit Funciones;
    begin
        Funtions.SalesOrderShowPackginListShipment(Rec);
    end;
}