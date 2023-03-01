codeunit 50118 "SMTP_Trampa"
{
    Permissions = tabledata "Service Password" = RIMD;

    trigger OnRun()
    begin

    end;

    var
        SmtpClient: DotNet MySmtpClient;
        MailMessage: DotNet MyMailMessage;
        ExcelBuffer: Record "Excel Buffer" temporary;

    procedure CreateMessage(SenderName: Text; SenderAddress: Text; Recipients: Text; Subject: Text; Body: Text; ReplyToName: Text; ReplyToAddress: Text)
    var
        FromAddress: DotNet MyMailAddress;
        ReplyAddress: DotNet MyMailAddress;
    begin
        // create from address
        FromAddress := FromAddress.MailAddress(ReplyToAddress, ReplyToName);

        // create mail message
        IF NOT ISNULL(MailMessage) THEN
            CLEAR(MailMessage);

        MailMessage := MailMessage.MailMessage;
        MailMessage.From := FromAddress;
        MailMessage.Body := Body;
        MailMessage.Subject := Subject;
        MailMessage."To".Clear;
        MailMessage."To".Add(Recipients);
        MailMessage.IsBodyHtml := true;
        MailMessage.Sender := FromAddress.MailAddress(ReplyToAddress, ReplyToName);

        // create and add reply-to-address
        ReplyAddress := ReplyAddress.MailAddress(ReplyToAddress, ReplyToName);
        MailMessage.ReplyTo := ReplyAddress;
    end;

    procedure SendSmtpMail()
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        NetworkCredential: DotNet MyNetworkCredential;
        userAux: text[250];
        passAux: text;
    begin
        SMTPMailSetup.FindFirst();

        userAux := SMTPMailSetup."User ID";
        passAux := SMTPMailSetup.GetPassword();

        SMTPMailSetup."User ID" := SMTPMailSetup.UsuarioVencimientos;
        SMTPMailSetup.SetPassword(getPassw2());

        SMTPMailSetup.Modify();
        Commit();

        WITH SMTPMailSetup DO BEGIN
            SmtpClient := SmtpClient.SmtpClient("SMTP Server", "SMTP Server Port");
            SmtpClient.EnableSsl := "Secure Connection";
            IF Authentication <> Authentication::Anonymous THEN
                IF "User ID" <> '' THEN BEGIN
                    SmtpClient.UseDefaultCredentials := FALSE;
                    NetworkCredential := NetworkCredential.NetworkCredential("User ID", SMTPMailSetup.GetPassword());
                    SmtpClient.Credentials := NetworkCredential;
                END ELSE BEGIN
                    CLEAR(NetworkCredential);
                    SmtpClient.Credentials := NetworkCredential;
                    SmtpClient.UseDefaultCredentials := TRUE;
                END
            ELSE BEGIN
                CLEAR(NetworkCredential);
                SmtpClient.Credentials := NetworkCredential;
                SmtpClient.UseDefaultCredentials := FALSE;
            END;

            IF ISNULL(MailMessage) THEN
                ERROR('Mail msg was not created');

            SmtpClient.Send(MailMessage);
            MailMessage.Dispose;
            SmtpClient.Dispose;

            CLEAR(MailMessage);
            CLEAR(SmtpClient);
        END;

        SMTPMailSetup."User ID" := userAux;
        SMTPMailSetup.SetPassword(passAux);

        SMTPMailSetup.Modify();
        Commit();
    end;

    local procedure getPassw2(): Text
    var
        ServicePassword: Record "Service Password";
        recSmtp: Record "SMTP Mail Setup";
    begin
        recSmtp.Get();
        recSmtp.TestField(PassVencimientos);

        IF NOT ISNULLGUID(recSmtp.PassVencimientos) THEN
            IF ServicePassword.GET(recSmtp.PassVencimientos) THEN
                EXIT(ServicePassword.GetPassword);

        EXIT('');
    end;

    procedure CreateSalesInvoicePaymentTerms(var PurchInvoiceHeader: Record "Purch. Inv. Header")
    var
        Window: Dialog;
    begin
        Window.Open('Nº Factura #1###########################\Fecha #2##########');
        ExcelBuffer.DeleteAll();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(CompanyName, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(PurchInvoiceHeader.GetFilters, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(PurchInvoiceHeader.FieldCaption("Posting Date"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchInvoiceHeader.FieldCaption("Document Date"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchInvoiceHeader.FieldCaption("Buy-from Vendor No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchInvoiceHeader.FieldCaption("Buy-from Vendor Name"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchInvoiceHeader.FieldCaption("No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchInvoiceHeader.FieldCaption("Due Date"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Importe Factura', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Efecto', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Importe ', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Importe pdte.', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Fecha pago', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Importe Pago', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchInvoiceHeader.FieldCaption("Payment Method Code"), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Estado', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();

        if PurchInvoiceHeader.FindFirst() then
            repeat
                Window.Update(1, PurchInvoiceHeader."No.");
                Window.Update(2, PurchInvoiceHeader."Posting Date");

                GetVendorLedgerEntry(PurchInvoiceHeader);

            Until PurchInvoiceHeader.next() = 0;
        ExcelBuffer.CreateNewBook('Facuras compras pagos');

        ExcelBuffer.WriteSheet('Pagos', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Pago');
        ExcelBuffer.DownloadAndOpenExcel;
        Window.Close();
    end;

    local procedure GetVendorLedgerEntry(PurchInvoiceHeader: Record "Purch. Inv. Header")
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorBillLedgerEntry: Record "Vendor Ledger Entry";
        CreateVendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendorLedgerEntry.SetRange("Document No.", PurchInvoiceHeader."No.");
        if VendorLedgerEntry.FindFirst() then begin

            // buscamos si tiene efectos la factura
            VendorBillLedgerEntry.Reset();
            VendorBillLedgerEntry.SetRange("Document Type", VendorBillLedgerEntry."Document Type"::Bill);
            VendorBillLedgerEntry.SetRange("Document No.", VendorLedgerEntry."Document No.");
            if not VendorBillLedgerEntry.FindSet() then begin
                VendorBillLedgerEntry.Reset();
                VendorBillLedgerEntry.SetRange("Entry No.", VendorLedgerEntry."Entry No.");
            end;

            if VendorBillLedgerEntry.FindSet() then begin
                repeat


                    DtldVendLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.");
                    DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendorBillLedgerEntry."Entry No.");
                    DtldVendLedgEntry.SETRANGE(Unapplied, FALSE);
                    if DtldVendLedgEntry.FIND('-') then
                        repeat
                            if DtldVendLedgEntry."Vendor Ledger Entry No." = DtldVendLedgEntry."Applied Vend. Ledger Entry No." then begin
                                DtldVendLedgEntry2.INIT;
                                DtldVendLedgEntry2.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");
                                DtldVendLedgEntry2.SETRANGE(
                                  "Applied Vend. Ledger Entry No.", DtldVendLedgEntry."Applied Vend. Ledger Entry No.");
                                DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                                DtldVendLedgEntry2.SETRANGE(Unapplied, FALSE);
                                IF DtldVendLedgEntry2.FIND('-') THEN
                                    REPEAT
                                        IF DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                                           DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                                        THEN BEGIN
                                            CreateVendLedgEntry.SETCURRENTKEY("Entry No.");
                                            CreateVendLedgEntry.SETRANGE("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                            IF CreateVendLedgEntry.FIND('-') THEN
                                                CreateVendLedgEntry.MARK(TRUE);
                                        END;
                                    UNTIL DtldVendLedgEntry2.NEXT = 0;
                            end else begin
                                CreateVendLedgEntry.SETCURRENTKEY("Entry No.");
                                CreateVendLedgEntry.SETRANGE("Entry No.", DtldVendLedgEntry."Applied Vend. Ledger Entry No.");
                                IF CreateVendLedgEntry.FIND('-') THEN
                                    CreateVendLedgEntry.MARK(TRUE);
                            end;
                            AddSalesInvoiceLine(PurchInvoiceHeader, VendorBillLedgerEntry, CreateVendLedgEntry);
                        until DtldVendLedgEntry.NEXT = 0;
                until VendorBillLedgerEntry.Next() = 0;
            end;
        end;

    end;

    local procedure AddSalesInvoiceLine(PurchInvoiceHeader: Record "Purch. Inv. Header"; VendorLedgerEntry: Record "Vendor Ledger Entry"; var CreateVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        if CreateVendLedgEntry.FindFirst() then
            repeat
                ExcelBuffer.AddColumn(PurchInvoiceHeader."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(PurchInvoiceHeader."Document Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
                ExcelBuffer.AddColumn(PurchInvoiceHeader."Buy-from Vendor No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PurchInvoiceHeader."Buy-from Vendor Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PurchInvoiceHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(PurchInvoiceHeader."Due Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
                PurchInvoiceHeader.CalcFields("Amount Including VAT");
                ExcelBuffer.AddColumn(PurchInvoiceHeader."Amount Including VAT", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(VendorLedgerEntry."Bill No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                VendorLedgerEntry.CalcFields("Original Amount", "Remaining Amount");
                ExcelBuffer.AddColumn(VendorLedgerEntry."Original Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(VendorLedgerEntry."Remaining Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CreateVendLedgEntry."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::date);
                CreateVendLedgEntry.CalcFields("Original Amount");
                ExcelBuffer.AddColumn(CreateVendLedgEntry."Original Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(PurchInvoiceHeader."Payment Method Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(VendorLedgerEntry."Document Status", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.NewRow();
            Until CreateVendLedgEntry.next() = 0;
    end;


    // =============     Normativa Plastico - Exporta excel con datos          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    procedure CreatePurchaseReceiptPlastic()
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        Window: Dialog;
    begin
        PurchRcptHeader.SetFilter("Posting Date", '%1..', 20230101D);
        Window.Open('Nº Recepción #1###########################\Fecha #2##########');
        ExcelBuffer.DeleteAll();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(CompanyName, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(PurchRcptHeader.GetFilters, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(PurchRcptHeader.FieldCaption("No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchRcptLine.FieldCaption("Line No."), false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Nª Factura Compra', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Línea Factura compra', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Nº Pedido de compra', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Fecha pedido de compra', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Fecha Albarán', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cód. proveedor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Nombre proveedor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Tipo', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Referencia producto', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Descripción producto', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Categoría producto', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cantidad', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Importe Factura', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('País', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Región', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Peso Neto unitario producto', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PLASTICO EMBALAJE (KG)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PLASTICO RECICLADO EMBALAJE (KG)', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PLASTICO EMBALAJE PROVEEDOR (KG/UD) UNITARIO', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();


        if PurchRcptHeader.FindFirst() then
            repeat
                Window.Update(1, PurchRcptHeader."No.");
                Window.Update(2, PurchRcptHeader."Posting Date");

                PurchRcptLine.Reset();
                PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
                PurchRcptLine.SetFilter(Quantity, '>0');
                if PurchRcptLine.FindFirst() then
                    repeat
                        if PurchRcptLine.Type in [PurchRcptLine.Type::"Fixed Asset", PurchRcptLine.Type::"G/L Account", PurchRcptLine.Type::Item] then
                            SetReceipLine(PurchRcptHeader, PurchRcptLine);

                    Until PurchRcptLine.next() = 0;

            Until PurchRcptHeader.next() = 0;

        ExcelBuffer.CreateNewBook('Declaración Plástico');

        ExcelBuffer.WriteSheet('Recepciones', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Recepciones');
        ExcelBuffer.DownloadAndOpenExcel;
        Window.Close();
    end;

    local procedure SetReceipLine(PurchRcptHeader: Record "Purch. Rcpt. Header"; PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        Item: Record Item;
        Vendor: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
        PurchInvoiceLine: Record "Purch. Inv. Line";
    begin
        if Item.Get(PurchRcptLine."No.") then;
        Vendor.Get(PurchRcptHeader."Buy-from Vendor No.");
        if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchRcptHeader."Order No.") then;
        PurchInvoiceLine.Reset();
        PurchInvoiceLine.SetRange("Receipt No.", PurchRcptLine."Document No.");
        PurchInvoiceLine.SetRange("Receipt Line No.", PurchRcptLine."Line No.");
        if PurchInvoiceLine.FindFirst() then;
        ExcelBuffer.AddColumn(PurchRcptHeader."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchRcptLine."Line No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(PurchInvoiceLine."Document No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchInvoiceLine."Line No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(PurchRcptLine."Order No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchaseHeader."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(PurchRcptHeader."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(PurchRcptHeader."Buy-from Vendor No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchRcptHeader."Buy-from Vendor Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchRcptLine.Type, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchRcptLine."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchRcptLine.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchRcptLine."Item Category Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchRcptLine.Quantity, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(PurchInvoiceLine."Line Amount", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(PurchRcptHeader."Buy-from Country/Region Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Vendor."Gen. Bus. Posting Group", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item."Net Weight", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(item."Packing Plastic Qty. (kg)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(item."Packing Recycled plastic (kg)", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(item."Vendor Packaging product KG", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

}