pageextension 50002 "SalesCreditMemo" extends "Sales Credit Memo"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("Sell-to Search Name"; "Sell-to Search Name")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addafter("Work Description")
        {
            field(CurrencyChange; CurrencyChange)
            {
                ApplicationArea = all;
                ToolTip = 'Indicar el cambio para la impresión de los documentos.', comment = 'ESP="Indicar el cambio para la impresión de los documentos."';
            }
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
            field(InsideSales_btc; InsideSales_btc)
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
            field("Return Receipt No."; "Return Receipt No.")
            {
                ApplicationArea = all;
            }
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = all;
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
                    clear(pageComentarios);
                    pageComentarios.LookupMode(true);

                    if pageComentarios.RunModal() = Action::LookupOK then begin
                        pageComentarios.GetRecord(recComentario);
                        SetWorkDescription(recComentario.GetComentario());
                    end;
                end;
            }
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
    }
}