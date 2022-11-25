pageextension 50187 "PurchaseInvoice" extends "Purchase Invoice"
{
    layout
    {

        movebefore("Document Date"; "Posting Date")
        addafter("Vendor Invoice No.")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = all;
            }
            field("Posting No."; "Posting No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
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
                    recPurchaseHeader: Record "Purchase Header";
                    recNomSeriesLin: Record "No. Series Line";
                    ErrorMessageMgt: Codeunit "Error Message Management";
                    ErrorMessageHandler: Codeunit "Error Message Handler";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    IsSuccess: Boolean;
                    InstructionMgt: Codeunit "Instruction Mgt.";
                    codUltimoNumUsado: Code[20];
                    PurchInvHeader: Record "Purch. Inv. Header";
                    OpenPostedPurchaseInvQst: Label 'La factura se registró con el número %1 y se movió a la ventana de facturas de compra registradas.\\¿Quiere abrir la factura registrada?';
                begin
                    COMMIT();
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
                    IsSuccess := CODEUNIT.RUN(CODEUNIT::"Purch.-Post (Yes/No)", Rec);

                    IF NOT IsSuccess THEN begin
                        if (codUltimoNumUsado <> '') then begin
                            recPurchaseHeader.Reset();
                            recPurchaseHeader.SetRange("Document Type", rec."Document Type");
                            recPurchaseHeader.SetRange("No.", rec."No.");
                            if recPurchaseHeader.FindFirst() then begin
                                if recPurchaseHeader."Posting No." <> '' then begin
                                    recNomSeriesLin.FindLast();
                                    recNomSeriesLin."Last No. Used" := codUltimoNumUsado;
                                    recNomSeriesLin.Modify(false);

                                    Commit();

                                    recPurchaseHeader."Posting No." := '';
                                    recPurchaseHeader.Modify(false);
                                    Commit();
                                end;
                            end;
                        end;

                        ErrorMessageHandler.ShowErrors();
                    end else begin
                        Commit();
                        PurchInvHeader.SETRANGE("Pre-Assigned No.", "No.");
                        PurchInvHeader.SETRANGE("Order No.", '');
                        IF PurchInvHeader.FINDFIRST THEN
                            IF InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedPurchaseInvQst, PurchInvHeader."No."),
                                 InstructionMgt.ShowPostedConfirmationMessageCode)
                            THEN
                                PAGE.RUN(PAGE::"Posted Purchase Invoice", PurchInvHeader);
                        //DocumentIsPosted := true;
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }
}