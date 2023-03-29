codeunit 50119 "ZM Visual code utilities"
{
    trigger OnRun()
    begin

    end;

    var
        tmpItem: Record Item temporary;
        ExcelBuffer: Record "Excel Buffer" temporary;

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

    procedure CheckLanguageTranslation()
    // var
    //     LanguageFile: File;
    //     FileMngt: Codeunit "File Management";
    //     FileName: Text;
    // begin
    //     FileName := FileMngt.OpenFileDialog('Fichero translation', '', 'Translation (*.XLF)|*.XLF|All Files (*.*)|*.*');
    //     if FileName = '' then
    //         exit;
    //     LanguageFile.TextMode(True);
    //     LanguageFile.WriteMode(False);
    //     LanguageFile.Open(FileName);

    var
        InStr: InStream;
        FileName: Text;
        NumberOfBytesRead: Integer;
        Position: Integer;
        Contar: Integer;
        TextRead: Text;
        Completo: Text;
        Valor1: text;
        Valor2: text;
        Valor3: text;
        Ventana: Dialog;
    begin
        // https://community.dynamics.com/business/b/tabrezblog/posts/how-to-read-file-content-in-dynamics-365-business-central-al-programming
        // You can read from or write to streams by using the InStream and OutStream methods.The Temp Blob codeunit can be used to convert between the two stream types.
        // The InStream data type can be used to read bytes from a stream object.The data is read in binary format, and you can use the Read and ReadText functions to read that format.
        if (File.UploadIntoStream('Open File', '', 'Translation (*.XLF)|*.XLF|All Files (*.*)|*.*',
                                 FileName, InStr)) then begin
            // If you use read then while written after read will not read anything because already everything in InStream variable is read -- vice versa
            // InStr.Read(TextRead);
            // Message(TextRead);
            Ventana.Open('#1#########\#2##########################################################');

            InitExcel();

            // Start: Read Each Line one by one
            while not InStr.EOS() do begin
                Contar += 1;
                Ventana.Update(1, Contar);
                NumberOfBytesRead := InStr.ReadText(TextRead, 500);
                Ventana.Update(2, TextRead);
                Position := text.StrPos(TextRead, 'priority="2">');
                if Position > 0 then begin
                    Completo := CopyStr(TextRead, Position, NumberOfBytesRead - Position);


                    Valor3 := copystr(GetTranslate3(Completo), 1, 250);
                    if Valor3 <> '' then begin
                        Valor2 := copystr(GetTranslate2(Valor3), 1, 250);
                        Valor1 := copystr(GetTranslate1(Valor3), 1, 250);

                        AddExcelLine(format(Contar), Valor1, Valor2, Valor3);
                    end;

                end;
                // Message('%1\Size: %2', TextRead, NumberOfBytesRead);
            end;
            // Stop: Read Each Line one by one
            Ventana.Close();
            FinExcel();
        end;
    end;

    local procedure GetTranslate3(Valor: text) respuesta: text;
    var
        Posicion: Integer;
        Posicion2: Integer;
    begin
        Posicion := StrPos(Valor, '>') + 1;
        Posicion2 := StrPos(Valor, '<');
        if Posicion2 > Posicion then
            respuesta := CopyStr(Valor, Posicion, Posicion2 - Posicion);
    end;

    local procedure GetTranslate2(Valor: text) respuesta: text;
    var
        Posicion: Integer;
    begin
        Posicion := StrPos(Valor, '",') + 1;
        respuesta := CopyStr(Valor, Posicion + 1, 5);
    end;

    local procedure GetTranslate1(Valor: text) respuesta: text;
    var
        Posicion: Integer;
    begin
        respuesta := CopyStr(Valor, 1, 5);
    end;


    local procedure AddExcelLine(Valor: text; Valor2: text; Valor3: text; Valor4: text)
    begin
        ExcelBuffer.AddColumn(Valor, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Valor2, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Valor3, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Valor4, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

    local procedure InitExcel()
    begin
        ExcelBuffer.DeleteAll();
        ExcelBuffer.AddColumn('Idioma', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Idioma2', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Idioma3', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
    end;

    local procedure FinExcel()
    begin
        ExcelBuffer.CreateNewBook('Planificacion');

        ExcelBuffer.WriteSheet('Traducción', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Traduccion');
        ExcelBuffer.DownloadAndOpenExcel;
    end;


}
