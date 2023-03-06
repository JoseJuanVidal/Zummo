pageextension 50165 "PostedSalesInvoices_zummo" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Location Code")
        {
            field("Package Tracking No."; "Package Tracking No.") { }
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
            field("ABC Cliente"; "ABC Cliente") { }

            field(NumAbono; NumAbono)
            {
                ApplicationArea = All;
            }
        }
        addafter("Amount Including VAT")
        {
            field("Importe (DL)"; BaseImpDL)
            {
                ApplicationArea = all;
            }
            field("Importe IVA Incl. (DL)"; ImpTotalDL)
            {
                ApplicationArea = all;
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
            }
            field("Credito Maximo Aseguradora_btc"; "Credito Maximo Aseguradora_btc")
            {
                ApplicationArea = all;
            }
            field(clasificacion_aseguradora; clasificacion_aseguradora)
            {
                ApplicationArea = all;
            }
            field("Ship-to Name"; "Ship-to Name")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Ship-to Address"; "Ship-to Address")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Ship-to Address 2"; "Ship-to Address 2")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Ship-to City"; "Ship-to City")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Ship-to County"; "Ship-to County")
            {
                ApplicationArea = all;
                Visible = false;
            }

            field("Payment Method Code"; "Payment Method Code")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addfirst(Reporting)
        {
            action("Imprimir Fact.Export")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                Caption = 'Imprimir Fact.Export', comment = 'ESP="Imprimir Fact.Export"';
                ToolTip = 'Imprimir Fact.Export',
                    comment = 'ESP="Impimir Fact.Export"';

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    Customer: Record Customer;
                    recReqLine: Report FacturaExportacion;
                    reportFactura: Report FacturaNacionalMaquinas;
                    reportFacturaUK: Report FacturaNacionalUK;

                    Selection: Integer;
                begin
                    Selection := STRMENU('1.-Exportacion,2.-Nacional,3.-Lidl,4.-Brasil,5.-Zummo UK', 1);
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
                                        if Customer.Get(Rec."Sell-to Customer No.") then
                                            reportFactura.Pneto(Customer."Mostrar Documentos Netos");
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
                                5:
                                    begin
                                        clear(reportFactura);
                                        reportFacturaUK.EsExportacion();
                                        reportFacturaUK.SetTableView(SalesInvoiceHeader);
                                        reportFacturaUK.Run();
                                    end;
                            end;
                    end;
                end;
            }

            action("Exportar PDF Facturas")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Export;
                Caption = 'Exportar PDF Facturas', comment = 'ESP="Exportar PDF Facturas"';
                ToolTip = 'Imprimir Fact.Export',
                    comment = 'ESP="Impimir Fact.Export"';

                trigger OnAction()
                begin
                    ExportarPDF();
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
        CustLedgerEntry: Record "Cust. Ledger Entry";
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

        ImpTotalDL := 0;
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", "No.");
        CustLedgerEntry.SetRange("Customer No.", "Sell-to Customer No.");
        if CustLedgerEntry.FindSet() then begin
            CustLedgerEntry.CalcFields("Amount (LCY)");
            ImpTotalDL := CustLedgerEntry."Amount (LCY)";
        end;

        BaseImpDL := 0;
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.SetRange("Document No.", Rec."No.");
        if SalesInvoiceLine.FindSet() then begin
            SalesInvoiceLine.CalcSums(Amount);
            if rec."Currency Factor" = 0 then
                BaseImpDL := SalesInvoiceLine.Amount
            else
                BaseImpDL := SalesInvoiceLine.Amount / rec."Currency Factor";
        end;
    end;

    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        FileMgt: Codeunit "File Management";
        SalesSetup: Record "Sales & Receivables Setup";
        NameValueBuffer: Record "Name/Value Buffer";
        Funciones: Codeunit Funciones;
        Ventana: Dialog;
        credMaxAsegAut: code[20];
        StyleExp: text;
        ShowVtoAseguradora: Boolean;
        ImpTotalDL: Decimal;
        BaseImpDL: Decimal;
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

    local procedure ExportarPDF()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceHeader2: Record "Sales Invoice Header";
        recReqLine: Report FacturaExportacion;
        reportFactura: Report FacturaNacionalMaquinas;
        reportFacturaUK: Report FacturaNacionalUK;
        FacturaRegBrasil: report FacturaRegBrasil;
        CodEmpleado: text;
        Selection: Integer;
        Path: text;
        FileName: text;
        files: dotnet Myfiles;
        XmlParameters: text;
        Content: file;
        OStream: OutStream;
        IStream: InStream;
        RecRef: RecordRef;
    begin
        SalesSetup.get();
        files := files.List();
        Selection := STRMENU('1.-Exportacion,2.-Nacional,3.-Lidl,4.-Brasil,5.-Zummo UK', 1);
        // FileMgt.GetServerDirectoryFilesList(NameValueBuffer, SalesSetup."Ruta exportar pdf facturas");
        // if NameValueBuffer.FINDFIRST THEN
        //     REPEAT
        //         FileMgt.DeleteServerFile(NameValueBuffer.Name);
        //     UNTIL NameValueBuffer.NEXT = 0;
        CodEmpleado := Funciones.GetExtensionFieldValuetext(Rec.RecordId, 50500, false);  // 50500  Cód. empleado
        if not FileMgt.ServerDirectoryExists(SalesSetup."Ruta exportar pdf facturas" + CodEmpleado) then
            FileMgt.ServerCreateDirectory(SalesSetup."Ruta exportar pdf facturas" + CodEmpleado);

        Path := SalesSetup."Ruta exportar pdf facturas" + CodEmpleado + '\';
        SalesInvoiceHeader.Reset();
        CurrPage.SetSelectionFilter(SalesInvoiceHeader);
        XmlParameters := GetRequestPageReport(Selection);
        Ventana.Open('Nº Documento: #1####################');
        if SalesInvoiceHeader.FindSet() then
            repeat
                IF Selection > 0 THEN begin
                    Ventana.Update(1, SalesInvoiceHeader."No.");
                    SalesInvoiceHeader2.SetRange("No.", SalesInvoiceHeader."No.");
                    FileName := Path + SalesInvoiceHeader."No." + '.pdf';
                    case Selection of
                        1:
                            begin
                                clear(reportFactura);
                                reportFactura.EsExportacion();
                                // reportFactura.SetTableView(SalesInvoiceHeader2);
                                // reportFactura.SaveAsPdf(FileName);
                                RecRef.GetTable(SalesInvoiceHeader2);

                                Content.Create(FileName);  // only supported in Business Central on-premises
                                Content.CreateOutStream(OStream);  // only supported in Business Central on-premises
                                report.SaveAs(report::FacturaNacionalMaquinas, XmlParameters, ReportFormat::Pdf, OStream, RecRef);
                                Content.Close();
                            end;
                        2:
                            begin
                                clear(reportFactura);
                                reportFactura.EsNacional();
                                // reportFactura.SetTableView(SalesInvoiceHeader2);
                                // reportFactura.SaveAsPdf(FileName);                                
                                RecRef.GetTable(SalesInvoiceHeader2);

                                Content.Create(FileName);  // only supported in Business Central on-premises
                                Content.CreateOutStream(OStream);  // only supported in Business Central on-premises
                                reportFactura.SaveAs(XmlParameters, ReportFormat::Pdf, OStream, RecRef);
                                Content.Close();
                            end;
                        3:
                            begin
                                clear(reportFactura);
                                reportFactura.EsLidl();
                                // reportFactura.SetTableView(SalesInvoiceHeader2);
                                // reportFactura.SaveAsPdf(FileName);
                                RecRef.GetTable(SalesInvoiceHeader2);

                                Content.Create(FileName);  // only supported in Business Central on-premises
                                Content.CreateOutStream(OStream);  // only supported in Business Central on-premises
                                reportFactura.SaveAs(XmlParameters, ReportFormat::Pdf, OStream, RecRef);
                                Content.Close();
                            end;
                        4:
                            begin
                                clear(FacturaRegBrasil);
                                // FacturaRegBrasil.SetTableView(SalesInvoiceHeader2);
                                // FacturaRegBrasil.SaveAsPdf(FileName);
                                RecRef.GetTable(SalesInvoiceHeader2);

                                Content.Create(FileName);  // only supported in Business Central on-premises
                                Content.CreateOutStream(OStream);  // only supported in Business Central on-premises
                                FacturaRegBrasil.SaveAs(XmlParameters, ReportFormat::Pdf, OStream, RecRef);
                                Content.Close();
                            end;
                        5:
                            begin
                                clear(reportFactura);
                                reportFacturaUK.EsExportacion();
                                // reportFacturaUK.SetTableView(SalesInvoiceHeader2);
                                // reportFacturaUK.SaveAsPdf(FileName);
                                RecRef.GetTable(SalesInvoiceHeader2);

                                Content.Create(FileName);  // only supported in Business Central on-premises
                                Content.CreateOutStream(OStream);  // only supported in Business Central on-premises
                                reportFacturaUK.SaveAs(XmlParameters, ReportFormat::Pdf, OStream, RecRef);
                                Content.Close();
                            end;
                    end;
                    files.add(FileName);
                end;
            until SalesInvoiceHeader.Next() = 0;
        Ventana.Close();

        // MergePDF(files);

        Message(StrSubstNo('Proceso finalizado, se ha creado PDF de las facturas %1 seleccionadas', SalesInvoiceHeader.Count));
    end;

    local procedure GetRequestPageReport(Selection: Integer) XmlParameters: text;
    var

        reportFactura: Report FacturaNacionalMaquinas;
        reportFacturaUK: Report FacturaNacionalUK;
        FacturaRegBrasil: report FacturaRegBrasil;
    begin
        case Selection of
            1:
                begin
                    reportFactura.EsExportacion();
                    XmlParameters := reportFactura.RunRequestPage();
                end;
            2:
                begin
                    reportFactura.EsNacional();
                    XmlParameters := reportFactura.RunRequestPage();
                end;
            3:
                begin
                    reportFactura.EsLidl();
                    XmlParameters := reportFactura.RunRequestPage();
                end;
            4:
                begin
                    XmlParameters := FacturaRegBrasil.RunRequestPage();
                end;
            5:
                begin
                    reportFacturaUK.EsExportacion();
                    XmlParameters := reportFacturaUK.RunRequestPage();
                end;
        end;
    end;

    local procedure MergePDF(var files: dotnet Myfiles)
    var
        SothisPDF: DotNet MySothisPDF;
        FileName: Text;
    begin
        FileName := 'Facturas.pdf';

        SothisPDF.Merge(files, SalesSetup."Ruta exportar pdf facturas" + FileName, FALSE);

        Download(SalesSetup."Ruta exportar pdf facturas" + FileName, 'Fichero PDF Facturas', '', '', FileName);


    end;
}