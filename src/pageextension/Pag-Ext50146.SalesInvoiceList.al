//101219 S19/01164 Precio personalizado en líneas de venta estándar
pageextension 50146 "SalesInvoiceList" extends "Sales Invoice List"
{
    layout
    {
        addafter("Bill-to Name")
        {
            field(AreaManager_btc; AreaManager_btc)
            {
                ApplicationArea = all;
            }
            field(InsideSales_btc; InsideSales_btc)
            {
                ApplicationArea = all;
            }
            field(Canal_btc; Canal_btc)
            {
                ApplicationArea = all;
            }
            field(Rappel; Rappel)
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
    actions
    {
        addafter(Approvals)
        {
            action(GenerarFactPeriod)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category6;
                Image = Report2;
                Caption = 'Create Period Invoices', comment = 'ESP="Crear facturas periódicas"';
                ToolTip = 'Allows you to manually execute the periodic sales invoice creation report',
                    comment = 'ESP="Permite ejecutar manualmente el report de creación de facturas de venta periódicas"';
                RunObject = Report CrearFacturasPeriodicas;
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
                PromotedCategory = Category5;
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