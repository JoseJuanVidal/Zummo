pageextension 50175 "PostedSalesCreditMemos_zummo" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Location Code")
        {
            field(CorreoEnviado_btc; CorreoEnviado_btc) { }
            field(FacturacionElec_btc; FacturacionElec_btc) { }
            field("Corrected Invoice No."; "Corrected Invoice No.")
            {
                ApplicationArea = All;
            }
            field("ABC Cliente"; "ABC Cliente") { }
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
            field("Payment Method Code"; "Payment Method Code")
            {
                ApplicationArea = all;
            }
            field("Payment Terms Code"; "Payment Terms Code")
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
        }
    }
    actions
    {

        addafter(SendCustom)
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
        modify("Send by &Email")
        {
            Visible = false;
        }

        modify(SendCustom)
        {
            Visible = false;
        }

        addfirst(Reporting)
        {
            action("Imprimir Fact UK")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Print;
                Caption = 'Imprimir Abono UK', Comment = 'ESP="Imprimir Abono UK"';
                ToolTip = 'Imprimir Abono UK', Comment = 'ESP="Imprimir Abono UK"';

                trigger OnAction()
                var
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    reportFacturaUK: Report AbonoVentaUKRegistrado;

                    Selection: Integer;
                begin
                    // Message(Format(Selection));
                    SalesCrMemoHeader.Reset();

                    SalesCrMemoHeader.SetRange("No.", Rec."No.");
                    if SalesCrMemoHeader.FindFirst() then begin
                        clear(reportFacturaUK);
                        reportFacturaUK.EsExportacion();
                        reportFacturaUK.SetTableView(SalesCrMemoHeader);
                        reportFacturaUK.Run();
                    end;
                end;
            }
            action("Exportar PDF Abonos")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Image = Export;
                Caption = 'Exportar PDF Abonos', comment = 'ESP="Exportar PDF Abonos"';
                ToolTip = 'Imprimir Abonos Export',
                    comment = 'ESP="Impimir Abonos Export"';

                trigger OnAction()
                begin
                    ExportarPDF();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ImpTotalDL := 0;
        BaseImpDL := 0;
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Document No.", "No.");
        CustLedgerEntry.SetRange("Customer No.", "Bill-to Customer No.");
        if CustLedgerEntry.FindSet() then begin
            CustLedgerEntry.CalcFields("Amount (LCY)");
            ImpTotalDL := CustLedgerEntry."Amount (LCY)";
            if not (rec."Currency Factor" in [0, 1]) then
                BaseImpDL := CustLedgerEntry."Amount (LCY)";
        end;

        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetRange("Document No.", Rec."No.");
        if SalesCrMemoLine.FindSet() then begin
            SalesCrMemoLine.CalcSums(Amount);
            if rec."Currency Factor" in [0, 1] then begin
                BaseImpDL := SalesCrMemoLine.Amount;
            end;
        end;

        BaseImpDL := -abs(BaseImpDL);
        ImpTotalDL := -abs(ImpTotalDL);

    end;

    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        FileMgt: Codeunit "File Management";
        SalesSetup: Record "Sales & Receivables Setup";
        NameValueBuffer: Record "Name/Value Buffer";
        Funciones: Codeunit Funciones;
        Ventana: Dialog;
        ImpTotalDL: Decimal;
        BaseImpDL: Decimal;

    local procedure ExportarPDF()
    var
        SalesCRMemoHeader: Record "Sales Cr.Memo Header";
        SalesCRMemoHeader2: Record "Sales Cr.Memo Header";
        reportFactura: Report AbonoVentaRegistrado;
        Path: text;
        FileName: text;
        files: dotnet Myfiles;
        CodEmpleado: text;
    begin
        SalesSetup.get();

        files := files.List();
        // FileMgt.GetServerDirectoryFilesList(NameValueBuffer, SalesSetup."Ruta exportar pdf facturas");
        // if NameValueBuffer.FINDFIRST THEN
        //     REPEAT
        //         FileMgt.DeleteServerFile(NameValueBuffer.Name);
        //     UNTIL NameValueBuffer.NEXT = 0;
        CodEmpleado := Funciones.GetExtensionFieldValuetext(Rec.RecordId, 50500, false);  // 50500  Cód. empleado
        if not FileMgt.ServerDirectoryExists(SalesSetup."Ruta exportar pdf facturas" + CodEmpleado) then
            FileMgt.ServerCreateDirectory(SalesSetup."Ruta exportar pdf facturas" + CodEmpleado);

        Path := SalesSetup."Ruta exportar pdf facturas" + CodEmpleado + '\';

        SalesCRMemoHeader.Reset();
        CurrPage.SetSelectionFilter(SalesCRMemoHeader);
        if not Confirm('¿Desea exportar %1 Abonos de venta?', false, SalesCRMemoHeader.count) then
            exit;
        Ventana.Open('Nº Documento: #1####################');
        if SalesCRMemoHeader.FindSet() then
            repeat
                Ventana.Update(1, SalesCRMemoHeader."No.");
                SalesCRMemoHeader2.SetRange("No.", SalesCRMemoHeader."No.");
                FileName := Path + SalesCRMemoHeader."No." + '.pdf';
                clear(reportFactura);
                reportFactura.EsExportacion();
                reportFactura.SetTableView(SalesCRMemoHeader2);
                reportFactura.SaveAsPdf(FileName);

                files.add(FileName);

            until SalesCRMemoHeader.Next() = 0;

        Ventana.Close();

        //MergePDF(files);

        Message(StrSubstNo('Proceso finalizado, se ha creado PDF de las Abonos %1 seleccionadas', SalesCRMemoHeader.Count));
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