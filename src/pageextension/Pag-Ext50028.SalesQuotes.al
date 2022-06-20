pageextension 50028 "SalesQuotes" extends "Sales Quotes"
{
    layout
    {
        addlast(Control1)
        {
            field(AmountcostLines; AmountcostLines)
            {
                Caption = 'Importe Coste', comment = 'ESP="Importe Coste"';
                ApplicationArea = all;
                ToolTip = 'Especifica la suma de los importes del campo Coste unitario por unidades de las líneas de pedido de venta.';
            }
            field(OfertaSales; OfertaSales)
            {
                ApplicationArea = all;
            }
            field("No contemplar planificacion"; "No contemplar planificacion")
            {
                ApplicationArea = all;
            }
            field(ofertaprobabilidad; ofertaprobabilidad)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify(Print)
        {
            Visible = false;
        }

        addafter(Print)
        {
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
                    Selection := STRMENU('1.-Proforma Nac,2.-Proforma Exp', 1);
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
                                        rep.Pneto(false);
                                        rep.PTipoDocumento(2);//1 pedido 2  proforma
                                        rep.SetTableView(rSalesHead);
                                        rep.run();
                                    end;
                                2:
                                    begin
                                        rep.Pvalorado(true);
                                        rep.Pneto(true);
                                        rep.PTipoDocumento(2);//1 pedido 2  proforma
                                        rep.SetTableView(rSalesHead);
                                        rep.run();
                                    end;


                            end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AmountcostLines := CalcAmountcostLines();
    end;

    var
        AmountcostLines: Decimal;
}