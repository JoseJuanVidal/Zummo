pageextension 50136 "SalesQuote" extends "Sales Quote"
{
    layout
    {
        addafter("Due Date")
        {
            field(FechaRecepcionMail_btc; FechaRecepcionMail_btc)
            {
                ApplicationArea = All;
            }
            field(NumDias_btc; NumDias_btc)
            {
                ApplicationArea = All;
            }
            field(ofertaprobabilidad; ofertaprobabilidad)
            {
                ApplicationArea = all;
            }
            field(OfertaSales; OfertaSales)
            {
                ApplicationArea = all;
            }
            field("No contemplar planificacion"; "No contemplar planificacion")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(AreaManager_btc; AreaManager_btc)
            {
                ApplicationArea = all;
            }
            field(InsideSales_btc; InsideSales_btc)
            {
                ApplicationArea = all;
            }
            field(ClienteReporting_btc; ClienteReporting_btc)
            {
                ApplicationArea = all;
            }
        }
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
    }


    actions
    {
        addafter(DocAttach)
        {
            //131219 S19/01406 Incluir comentarios predefinidos
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
                    Commit();
                    clear(pageComentarios);
                    pageComentarios.LookupMode(true);

                    if pageComentarios.RunModal() = Action::LookupOK then begin
                        pageComentarios.GetRecord(recComentario);
                        SetWorkDescription(recComentario.GetComentario());
                    end;
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
                                        // buscamos el campo de customer, de si el cliente se obliga a NETO
                                        if Customer.Get(Rec."Sell-to Customer No.") then
                                            rep.Pneto(Customer."Mostrar Documentos Netos")
                                        else
                                            rep.Pneto(false);
                                        //if (SalesHeader."Document Type" = SalesHeader."Document Type"::Quote) then
                                        rep.PTipoDocumento(2);//1 pedido 2 proforma
                                        rep.SetTableView(rSalesHead);
                                        rep.run();
                                    end;
                                2:
                                    begin
                                        rep.Pvalorado(true);
                                        rep.Pneto(true);
                                        rep.PTipoDocumento(2);
                                        rep.SetTableView(rSalesHead);
                                        rep.run();
                                    end;



                            end;
                    end;
                end;
            }
            action(Descuentos)
            {
                ApplicationArea = All;
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
            action(NoPlanificacion)
            {
                ApplicationArea = All;
                Caption = 'Marcar/Desmarcar no planificar';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Planning;

                trigger OnAction()
                begin
                    UpdateNoComplarPlanificacion;
                    CurrPage.Update();
                end;


            }
        }
    }

    trigger OnClosePage()
    begin
        if Rec.Find() then
            if not Rec."Aviso Oferta bajo pedido" then begin
                Rec."Aviso Oferta bajo pedido" := true;
                Rec.Modify();
                Funciones.CheckEsBajoPedido(Rec);
            end;
    end;

    var
        Funciones: Codeunit Funciones;

    local procedure UpdateNoComplarPlanificacion()
    var
        funciones: Codeunit Funciones;
    begin
        Rec."No contemplar planificacion" := not rec."No contemplar planificacion";
        Rec.Modify();
        funciones.UpdateNoContemplarPlanificacion(Rec);
    end;
}