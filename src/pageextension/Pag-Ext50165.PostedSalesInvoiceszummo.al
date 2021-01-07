pageextension 50165 "PostedSalesInvoices_zummo" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Location Code")
        {
            field("VAT Registration No."; "VAT Registration No.") { }
            /*            field(credMaxAsegAut; credMaxAsegAut)
                        {
                            Editable = false;
                            ApplicationArea = All;
                            Caption = 'Crédito Maximo Aseguradora Autorizado Por', Comment = 'ESP="Crédito Maximo Aseguradora Autorizado Por"';
                        }*/
            field("Quote No."; "Quote No.") { }
            field(CorreoEnviado_btc; CorreoEnviado_btc) { }
            field(FacturacionElec_btc; FacturacionElec_btc) { }
            field(AreaManager_btc; AreaManager_btc) { }

            field(NumAbono; NumAbono)
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("Cred_ Max_ Aseg. AutorizadoPor"; "Cred_ Max_ Aseg. AutorizadoPor")
            {
                ApplicationArea = all;
            }
            field(Suplemento_aseguradora; Suplemento_aseguradora)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field(Aseguradora_comunicacion; Aseguradora_comunicacion)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field(Fecha_Aseguradora_comunicacion; Fecha_Aseguradora_comunicacion)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
            }
            field(fecha; CalcDate('+2M', rec."Posting Date"))
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        addfirst(Reporting)
        {
            action("Impimir Fact.Export")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                Caption = 'Impimir Fact.Export', comment = 'ESP="Impimir Fact.Export"';
                ToolTip = 'Impimir Fact.Export',
                    comment = 'ESP="Impimir Fact.Export"';

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    recReqLine: Report FacturaExportacion;
                    reportFactura: Report FacturaNacionalMaquinas;
                    Selection: Integer;
                begin
                    Selection := STRMENU('1.-Exportacion,2.-Nacional,3.-Lidl,4.-Brasil', 1);
                    // Message(Format(Selection));
                    SalesInvoiceHeader.Reset();
                    IF Selection > 0 THEN begin

                        SalesInvoiceHeader.SetRange("No.", Rec."No.");
                        if SalesInvoiceHeader.FindFirst() then
                            case Selection of
                                1:
                                    begin
                                        clear(reportFactura);
                                        reportFactura.EsExportacion();
                                        reportFactura.SetTableView(SalesInvoiceHeader);
                                        reportFactura.Run();
                                    end;
                                2:
                                    begin
                                        clear(reportFactura);
                                        reportFactura.EsNacional();
                                        reportFactura.SetTableView(SalesInvoiceHeader);
                                        reportFactura.Run();
                                    end;
                                3:
                                    begin
                                        clear(reportFactura);
                                        reportFactura.EsLidl();
                                        reportFactura.SetTableView(SalesInvoiceHeader);
                                        reportFactura.Run();
                                    end;
                                4:
                                    Report.Run(Report::FacturaRegBrasil, true, false, SalesInvoiceHeader);//50123
                            end;
                    end;
                end;
            }


        }
        // S20/00375
        addafter(Email)
        {
            action(Email_btc)
            {
                ApplicationArea = All;
                Image = Email;
                Promoted = true;
                PromotedCategory = Category6;
                Caption = '&Email', comment = 'ESP="&Correo electrónico"';
                trigger onAction()
                var
                    cduCron: Codeunit CU_Cron;
                begin
                    cduCron.EnvioPersonalizado(Rec);
                end;
            }

        }
        modify(Email)
        {
            Visible = false;
        }

        modify(SendCustom)
        {
            Visible = false;
        }
        //FIN S20/00375
        addlast(Processing)
        {
            action(MarkAseguradora)
            {
                ApplicationArea = all;
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Category6;
                Caption = 'Marcar comunicado Aaseguradora', comment = 'ESP="Marcar comunicado Aaseguradora"';

                trigger OnAction()
                begin
                    MarkComunicate;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recCustomer: Record Customer;
    begin
        credMaxAsegAut := '';

        /*     if recCustomer.Get("Bill-to Customer No.") then
                 credMaxAsegAut := recCustomer."Cred_ Max_ Aseg. Autorizado Por_btc";*/

        ShowVtoAseguradora := false;
        StyleExp := '';
        if rec.Suplemento_aseguradora <> '' then
            if not rec.Aseguradora_comunicacion then
                if CalcDate('+2M', rec."Posting Date") <= WorkDate() then begin
                    StyleExp := 'UnFavorable'
                end else
                    if CalcDate('+1M', rec."Posting Date") < WorkDate() then begin
                        StyleExp := 'Ambiguous'
                    end;

    end;

    var
        credMaxAsegAut: code[20];
        StyleExp: text;
        ShowVtoAseguradora: Boolean;
        Text000: Label '¿Desea marcar %1 facturas como enviadas a Aseguradora?', comment = 'ESP="¿Desea marcar %1 facturas como enviadas a Aseguradora?"';

    local procedure MarkComunicate()
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        CurrPage.SetSelectionFilter(SalesInvHeader);
        if not Confirm(Text000, false, SalesInvHeader.Count) then
            exit;
        if SalesInvHeader.findset() then
            repeat
                SalesInvHeader.Aseguradora_comunicacion := true;
                if SalesInvHeader.Fecha_Aseguradora_comunicacion = 0D then
                    SalesInvHeader.Fecha_Aseguradora_comunicacion := WorkDate();
                SalesInvHeader.Modify();
            Until SalesInvHeader.next() = 0;

    end;
}