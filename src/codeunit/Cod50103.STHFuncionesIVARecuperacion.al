codeunit 50103 "STH Funciones IVA Recuperacion"
{
    trigger OnRun()
    var
        lblConfirm: Label '¿Desea exportar la valoración de existencia a %1 en Excel?', comment = 'ESP="¿Desea exportar la valoración de existencia a %1 en Excel?"';
    begin
        // preguntamos si exportamos la valoracion inventario a fecha 
        if Confirm(lblConfirm, false, CalcDate('<CM>', workdate)) then
            ExportExcelValInventario();
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        tmpItem: Record Item temporary;

    // ================ Funciones para la importacion de excel de Recuperación de IVA  ======================
    // Tipo 
    // Nombre 
    // accion  
    //  29/09/2022
    //  
    // ==  Parametro  - 

    procedure CreateJnlIVARecuperacion(GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        ExcelBuffer: Record "Excel Buffer";
        SeriesMGt: codeunit NoSeriesManagement;
        NVInStream: InStream;
        DocNo: text;
        FileName: text;
        Sheetname: text;
        LastLine: Integer;
        i: Integer;
        Rows: Integer;
        UploadResult: Boolean;
        IDFra: text;
        txtFechaFra: text;
        FechaFra: date;
        IVA: text;
        CuentaContable: text;
        txtImporte: text;
        Importe: decimal;
        CIFProveedor: text;
        CuentaProveedor: text;
        NombreFiscal: text;
        Pais: text;
        Divisa: text;
        Direccion: text;
        Localidad: text;
        Provincia: text;
        CPProveeor: text;
        Id60dias: text;    //60 dias es el nombre de la empresa de recuperación de IVA
        LastDocumentNo: code[20];
        Text000: label 'Cargar Fichero de Excel';
        Text001: Label 'Nominas %1 %2';
    begin

        ExcelBuffer.DeleteAll();
        UploadResult := UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream);
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        Commit();
        ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 1);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";
        // primero miramos si existen líneas y obtenemos la ultima línea
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if GenJnlLine.FindLast() then
            LastLine := GenJnlLine."Line No." + 10000
        else
            LastLine := 10000;

        LastDocumentNo := GetNextSerialNo(GenJournalBatch);

        for i := 2 to Rows do begin

            InitValues(IDFra, txtFechaFra, FechaFra, IVA, CuentaContable, txtImporte, Importe, CIFProveedor, CuentaProveedor, NombreFiscal, Pais, Divisa, Direccion, Localidad, Provincia, CPProveeor, id60dias);

            ExcelBuffer.SetRange("Row No.", i);
            ExcelBuffer.SetRange("Column No.", 1);
            if ExcelBuffer.FindSet() then
                IDFra := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 2);
            if ExcelBuffer.FindSet() then
                txtFechaFra := ExcelBuffer."Cell Value as Text";
            Evaluate(FechaFra, txtFechaFra);
            ExcelBuffer.SetRange("Column No.", 3);
            if ExcelBuffer.FindSet() then
                IVA := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 4);
            if ExcelBuffer.FindSet() then
                CuentaContable := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 5);
            if ExcelBuffer.FindSet() then
                txtImporte := ExcelBuffer."Cell Value as Text";
            Evaluate(Importe, txtImporte);
            ExcelBuffer.SetRange("Column No.", 6);
            if ExcelBuffer.FindSet() then
                CIFProveedor := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 7);
            if ExcelBuffer.FindSet() then
                CuentaProveedor := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 8);
            if ExcelBuffer.FindSet() then
                NombreFiscal := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 9);
            if ExcelBuffer.FindSet() then
                Pais := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 10);
            if ExcelBuffer.FindSet() then
                Divisa := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 11);
            if ExcelBuffer.FindSet() then
                Direccion := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 12);
            if ExcelBuffer.FindSet() then
                Localidad := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 13);
            if ExcelBuffer.FindSet() then
                Provincia := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 14);
            if ExcelBuffer.FindSet() then
                CPProveeor := ExcelBuffer."Cell Value as Text";
            ExcelBuffer.SetRange("Column No.", 15);
            if ExcelBuffer.FindSet() then
                Id60dias := ExcelBuffer."Cell Value as Text";

            CrearJnlLine(GenJournalBatch, LastDocumentNo, IDFra, txtFechaFra, FechaFra, IVA, CuentaContable, txtImporte, Importe, CIFProveedor, CuentaProveedor,
                    NombreFiscal, Pais, Divisa, Direccion, Localidad, Provincia, CPProveeor, id60dias, LastLine);

            LastDocumentNo := IncStr(LastDocumentNo);

        end;

    end;


    local procedure CrearJnlLine(GenJournalBatch: Record "Gen. Journal Batch"; LastDocumentNo: Code[20]; IDFra: text; txtFechaFra: Text; FechaFra: date; IVA: text; CuentaContable: text; txtImporte: Text; Importe: decimal; CIFProveedor: text; CuentaProveedor: text;
            NombreFiscal: text; Pais: text; Divisa: text; Direccion: text; Localidad: text; Provincia: text; CPProveeor: text; id60dias: text; var LastLine: Integer)
    var
        GLSetup: Record "General Ledger Setup";
        GenJnlLine: Record "Gen. Journal Line";
        VendorName: text;
        Pos: Integer;
    begin
        GLSetup.get();
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := GenJournalBatch."Journal Template Name";
        GenJnlLine."Journal Batch Name" := GenJournalBatch.Name;
        GenJnlLine."Line No." := LastLine;
        GenJnlLine."Posting Date" := Workdate;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
        GenJnlLine."Document Date" := FechaFra;
        GenJnlLine.Insert();
        GenJnlLine."Document No." := LastDocumentNo;
        VendorName := CopyStr(NombreFiscal, 1, MaxStrLen(GenJnlLine."Succeeded Company Name"));
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine.validate("Account No.", GetVendorNo(CuentaProveedor, CIFProveedor, VendorName));
        GenJnlLine.Description := CopyStr(StrSubstNo('%1 %2', NombreFiscal, IDFra), 1, MaxStrLen(GenJnlLine.Description));
        GenJnlLine."External Document No." := GetVendorLdgExternalDocumentNo(GenJnlLine, IDFra);
        GenJnlLine."Succeeded Company Name" := NombreFiscal;
        GenJnlLine."VAT Registration No." := CIFProveedor;
        GenJnlLine.Validate(Amount, -Importe);
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        if GLSetup."Cta. Contable IVA Recuperacion" = '' then
            GenJnlLine.Validate("Bal. Account No.", CuentaContable)
        else
            GenJnlLine.Validate("Bal. Account No.", GLSetup."Cta. Contable IVA Recuperacion");
        GenJnlLine.validate("Bal. VAT Prod. Posting Group", IVA);
        GenJnlLine.Modify();
        LastLine += 10000;

        // ahora hacemos el pago para que quede todo correcto
        GenJnlLine."Line No." := LastLine;
        GenJnlLine."Pmt. Discount Date" := 0D;
        GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::" ";
        GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
        GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
        GenJnlLine."Bal. VAT Bus. Posting Group" := '';
        GenJnlLine."Bal. VAT Prod. Posting Group" := '';
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine.Validate(Amount, -GenJnlLine.Amount);
        GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
        GenJnlLine."Applies-to Doc. No." := GenJnlLine."Document No.";

        GenJnlLine.Insert();
        LastLine += 10000;

    end;

    local procedure GetNextSerialNo(GenJournalBatch: Record "Gen. Journal Batch"): code[20]
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        exit(NoSeriesMgt.GetNextNo(GenJournalBatch."No. Series", WorkDate(), false));
    end;

    local procedure GetVendorNo(CuentaProveedor: text; var CIFProveedor: Text; var VendorName: text): code[20]
    var
        GLSetup: Record "General Ledger Setup";
        Vendor: Record Vendor;
    begin
        GLSetup.Get();

        Vendor.Reset();
        Vendor.SetRange("VAT Registration No.", CIFProveedor);
        if Vendor.FindSet() then begin
            VendorName := Vendor.Name;
            //CIFProveedor := Vendor."VAT Registration No.";
            exit(Vendor."No.");
        end;
        if Vendor.Get(CuentaProveedor) then begin
            VendorName := Vendor.Name;
            //CIFProveedor := Vendor."VAT Registration No.";
            exit(Vendor."No.");
        end;

        exit(GLSetup."Proveedor IVA Recuperacion");

    end;

    local procedure InitValues(var IDFra: text; var txtFechaFra: Text; var FechaFra: date; IVA: text; var CuentaContable: text; var txtImporte: Text; var Importe: decimal; var CIFProveedor: text; var CuentaProveedor: text;
            var NombreFiscal: text; var Pais: text; var Divisa: text; var Direccion: text; var Localidad: text; var Provincia: text; var CPProveeor: text; var id60dias: text)
    var
        myInt: Integer;
    begin
        Clear(IDFra);
        clear(txtFechaFra);
        Clear(FechaFra);
        Clear(IVA);
        Clear(CuentaContable);
        Clear(txtImporte);
        Clear(Importe);
        Clear(CIFProveedor);
        Clear(CuentaProveedor);
        Clear(NombreFiscal);
        Clear(Pais);
        Clear(Divisa);
        Clear(Direccion);
        Clear(Localidad);
        clear(Provincia);
        Clear(CPProveeor);
        clear(id60dias);
    end;

    local procedure GetJnlLineExternalDocumentNo(GenJnlLine: Record "Gen. Journal Line"; ExtDocumentNo: code[35]): code[35]
    var
        GenJournalLine: Record "Gen. Journal Line";
        NoFind: Boolean;
        Pos: Integer;
    begin
        Pos := strlen(ExtDocumentNo) - MaxStrLen(GenJournalLine."External Document No.") - 1;
        if Pos < 1 then
            pos := 1;
        ExtDocumentNo := CopyStr(ExtDocumentNo, Pos, MaxStrLen(GenJournalLine."External Document No."));
        GenJournalLine.Reset();
        GenJournalLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJournalLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJournalLine.SetRange("Account No.", GenJnlLine."Account No.");
        GenJournalLine.SetRange("External Document No.", ExtDocumentNo);
        repeat
            if GenJournalLine.FindFirst() then begin
                if CopyStr(ExtDocumentNo, StrLen(ExtDocumentNo) - 1, 1) <> '/' then
                    ExtDocumentNo := CopyStr(ExtDocumentNo, 1, MaxStrLen(GenJournalLine."External Document No.") - 2) + '/0';

                ExtDocumentNo := IncStr(ExtDocumentNo);
            end else
                NoFind := true;
            GenJournalLine.SetRange("External Document No.", ExtDocumentNo);
        until NoFind;

        exit(ExtDocumentNo);
    end;

    local procedure GetVendorLdgExternalDocumentNo(GenJnlLine: Record "Gen. Journal Line"; ExtDocumentNo: text): code[35]
    var
        VendorledgerEntry: Record "Vendor Ledger Entry";
        NoFind: Boolean;
        Pos: Integer;
    begin
        Pos := strlen(ExtDocumentNo) - MaxStrLen(VendorledgerEntry."External Document No.") - 1;
        if Pos < 1 then
            pos := 1;
        ExtDocumentNo := CopyStr(ExtDocumentNo, Pos, MaxStrLen(VendorledgerEntry."External Document No."));
        VendorledgerEntry.Reset();
        VendorledgerEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
        VendorledgerEntry.SetRange("External Document No.", ExtDocumentNo);
        repeat
            if VendorledgerEntry.FindFirst() then begin

                if CopyStr(ExtDocumentNo, StrLen(ExtDocumentNo) - 1, 1) <> '/' then
                    ExtDocumentNo := CopyStr(ExtDocumentNo, 1, MaxStrLen(VendorledgerEntry."External Document No.") - 2) + '/0';

                ExtDocumentNo := IncStr(ExtDocumentNo);
            end else
                NoFind := true;
            VendorledgerEntry.SetRange("External Document No.", ExtDocumentNo);
        until NoFind;

        ExtDocumentNo := GetJnlLineExternalDocumentNo(GenJnlLine, ExtDocumentNo);

        exit(ExtDocumentNo);
    end;

    procedure CreateExcelBufferItemBom(ItemNo: code[20])
    var
        Item: Record Item;
        Window: Dialog;
        lblConfirm: Label '¿Do you want to export the BOM of material costs of %1 %2?', comment = 'ESP="¿Desea exportas la lista de costes de materiales de %1 %2?"';
    begin
        if not Item.Get(ItemNo) or (Item."Production BOM No." = '') then
            exit;
        if not Confirm(lblConfirm, false, Item."No.", Item.Description) then
            exit;

        Window.Open('Cód. producto #1###########################\Fecha #2##########');
        tmpItem.DeleteAll();
        ExcelBuffer.DeleteAll();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(CompanyName, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Listado de Costes Materiales BOM', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('BOM Producto', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Nº', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Descripción', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cantidad en BOM', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Coste', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Importe por maquina', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Método coste', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Coste estandar', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Coste unitario', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Proveedor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Nombre Proveedor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Plazo de Entrega', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Stock', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ultimo proveedor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Nombre Ult. Proveedor', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ultimo pedido', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ultima Fecha de compra', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Ultimo precio de compra', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Familia', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Categoria', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SubCategoria', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();

        AddProductionBomLine(Item."Production BOM No.");

        ExcelBuffer.CreateNewBook('BOM Costes Materiales');

        ExcelBuffer.WriteSheet('BOM producto', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('BOM Productos');
        ExcelBuffer.DownloadAndOpenExcel;
        Window.Close();



    end;

    local procedure AddProductionBomLine(ProductionBOMNo: code[20])
    var
        ItemBOM: Record Item;
        ProductionBomLine: Record "Production BOM Line";
    begin
        ProductionBomLine.Reset();
        ProductionBomLine.SetRange("Production BOM No.", ProductionBOMNo);
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        ProductionBomLine.SetRange("Version Code", '');
        if ProductionBomLine.FindFirst() then
            repeat
                if ItemBOM.Get(ProductionBomLine."No.") then begin
                    if ItemBOM."Production BOM No." = '' then
                        ItemBomtoBufferExcel(ProductionBOMNo, ItemBOM, ProductionBomLine."Quantity per", ProductionBomLine."Production BOM No.")
                    else
                        GetBOMProduction(ProductionBOMNo, ItemBOM, ProductionBomLine."Quantity per");
                end;
            Until ProductionBomLine.next() = 0;
    end;


    local procedure GetBOMProduction(BomNo: code[20]; ItemBom: Record Item; QTQPer: Decimal)
    var
        ItemBOMLine: Record Item;
        ProductionBomLine: Record "Production BOM Line";
    begin
        ItemBomtoBufferExcel(BomNo, ItemBOM, 0, ProductionBomLine."Production BOM No.");
        ProductionBomLine.Reset();
        ProductionBomLine.SetRange("Production BOM No.", ItemBom."Production BOM No.");
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        ProductionBomLine.SetRange("Version Code", '');
        if ProductionBomLine.FindFirst() then
            repeat
                if ItemBOM.Get(ProductionBomLine."No.") then begin
                    if (ItemBOM."Production BOM No." = '') or (ItemBom."Replenishment System" in [ItemBom."Replenishment System"::Purchase]) then
                        ItemBomtoBufferExcel(BomNo, ItemBOM, ProductionBomLine."Quantity per", ProductionBomLine."Production BOM No.")
                    else
                        GetBOMProduction(BomNo, ItemBOM, QTQPer * ProductionBomLine."Quantity per");
                end;
            Until ProductionBomLine.next() = 0;

    end;

    local procedure ItemBomtoBufferExcel(BomNo: code[20]; ItemBom: Record Item; QTQPer: Decimal; ParentItemNo: code[20])
    var
        ExcelBufferRow: Integer;
        OldRow: Integer;
        AddNEW: Boolean;
        OldQty: Decimal;
    begin
        tmpItem.Reset();
        if tmpItem.Get(ItemBOM."No.") then begin
            OldRow := ExcelBuffer."Row No.";
            // aqui acumulamos datos 4=> qty per  6=> importe total
            ExcelBuffer.SetRange("Column No.", 2);
            ExcelBuffer.SetRange("Cell Value as Text", ItemBom."No.");
            if ExcelBuffer.FindFirst() then begin
                ExcelBuffer.SetRange("Cell Value as Text");
                ExcelBuffer.SetRange("Row No.", ExcelBuffer."Row No.");
                ExcelBuffer.SetRange("Column No.", 4);  // QTY Per unit
                if ExcelBuffer.FindFirst() then begin
                    if Evaluate(OldQty, ExcelBuffer."Cell Value as Text") then;
                    ExcelBuffer."Cell Value as Text" := format(OldQty + QTQPer);
                    ExcelBuffer.Modify();
                    ExcelBuffer.SetRange("Column No.", 6);  // Precio x producto
                    if ExcelBuffer.FindFirst() then begin
                        case ItemBom."Costing Method" of
                            ItemBom."Costing Method"::Average, ItemBom."Costing Method"::FIFO, ItemBom."Costing Method"::LIFO:
                                ExcelBuffer."Cell Value as Text" := format((QTQPer + OldQty) * ItemBom."Unit Cost")
                            else
                                ExcelBuffer."Cell Value as Text" := format((QTQPer + OldQty) * ItemBom."Standard Cost");
                        end;
                        ExcelBuffer.Modify();
                    end;
                    ExcelBuffer.SetRange("Row No.", ExcelBuffer."Row No.");
                    ExcelBuffer.SetRange("Column No.");
                    if ExcelBuffer.FindLast() then
                        ExcelBuffer.SetCurrent(ExcelBuffer."Row No.", ExcelBuffer."Column No.")
                    else
                        ExcelBuffer.SetCurrent(ExcelBuffer."Row No.", 23);
                    ExcelBuffer.AddColumn(ParentItemNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(QTQPer, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

                    AddNEW := true;
                end;
            end;
            ExcelBuffer.SetRange("Column No.", 1);
            ExcelBuffer.SetRange("Row No.");
            ExcelBuffer.SetRange("Cell Value as Text");
            if ExcelBuffer.FindLast() then
                ExcelBuffer.SetCurrent(ExcelBuffer."Row No.", 1)
            else begin
                ExcelBuffer.SetCurrent(OldRow + 1, 1);
                ExcelBuffer."Row No." := OldRow + 1;
            end;
            ExcelBuffer."Column No." := 1;
            ExcelBuffer.SetRange("Column No.");
            ExcelBuffer.NewRow();
        end;
        if not AddNEW then begin
            ExcelBufferRow := AddItemBomtoBufferExcel(BomNo, ItemBOM, QTQPer);
            if not tmpItem.Get(ItemBom."No.") then begin
                tmpItem.Init();
                tmpItem."No." := ItemBom."No.";
                tmpItem.Description := ItemBom.Description;
                tmpItem.Carton := ExcelBufferRow;
                tmpItem.Insert();
            end;
        end;
    end;

    local procedure AddItemBomtoBufferExcel(BomNo: code[20]; ItemBom: Record Item; QTQPer: Decimal) RowNo: Integer
    var
        Vendor: Record Vendor;
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchReceiptHeader: Record "Purch. Rcpt. Header";
        Funciones: Codeunit Funciones;
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", ItemBom."No.");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        if ItemLedgerEntry.FindLast() then;
        ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
        if PurchReceiptHeader.get(ItemLedgerEntry."Document No.") then;

        ExcelBuffer.AddColumn(BomNo, false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemBom."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemBom.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(QTQPer, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        case ItemBom."Costing Method" of
            ItemBom."Costing Method"::Average, ItemBom."Costing Method"::FIFO, ItemBom."Costing Method"::LIFO:
                begin
                    ExcelBuffer.AddColumn(ItemBom."Unit Cost", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(QTQPer * ItemBom."Unit Cost", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                end;
            else begin
                ExcelBuffer.AddColumn(ItemBom."Standard Cost", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(QTQPer * ItemBom."Standard Cost", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
            end;
        end;
        ExcelBuffer.AddColumn(ItemBom."Costing Method", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemBom."Standard Cost", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ItemBom."Unit Cost", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        if Vendor.Get(ItemBom."Vendor No.") then;
        ExcelBuffer.AddColumn(ItemBom."Vendor No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Vendor.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemBom."Lead Time Calculation", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        Funciones.SetFilterLocations(ItemBom);
        ItemBom.CalcFields(Inventory);
        ExcelBuffer.AddColumn(itembom.Inventory, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ItemLedgerEntry."Source No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        if Vendor.Get(ItemLedgerEntry."Source No.") then;
        ExcelBuffer.AddColumn(Vendor.Name, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchReceiptHeader."Order No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemLedgerEntry."Posting Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        if ItemLedgerEntry.Quantity = 0 then
            ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number)
        else
            ExcelBuffer.AddColumn(Round((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") / ItemLedgerEntry.Quantity, 0.01), false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ItemBom.CalcFields("Desc. Purch. Family", "Desc. Purch. Category", "Desc. Purch. SubCategory");
        ExcelBuffer.AddColumn(ItemBom."Desc. Purch. Family", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemBom."Desc. Purch. Category", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ItemBom."Desc. Purch. SubCategory", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        RowNo := ExcelBuffer."Row No.";
        ExcelBuffer.NewRow();
    end;

    local procedure ExportExcelValInventario()
    var
        Item: Record Item;
        Location: Record Location;
        ValueEntry: Record "Value Entry";
        Window: Dialog;
    begin
        Window.Open('#1##################\#2########################');
        ExcelBuffer.DELETEALL;
        ExcelBuffer.CreateNewBook('Valoracion');

        ExcelBuffer.AddColumn('Almacen', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cod. producto', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Descripcion', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Inventario', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Cantidad Mov. valor', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Coste', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;

        Location.RESET;
        IF Location.FINDFIRST THEN
            REPEAT
                Window.UPDATE(1, Location.Code);
                Item.RESET;
                Item.SETRANGE("Location Filter", Location.Code);
                Item.SETFILTER(Inventory, '>0');
                IF Item.FINDFIRST THEN
                    REPEAT
                        Window.UPDATE(2, Item."No.");
                        Item.CALCFIELDS(Inventory);
                        ExcelBuffer.AddColumn(Location.Code, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(Item.Inventory, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ValueEntry.RESET;
                        ValueEntry.SETRANGE("Item No.", Item."No.");
                        ValueEntry.SETFILTER("Location Code", Location.Code);
                        ValueEntry.SETRANGE("Posting Date", 0D, CalcDate('<CM>', workdate));
                        ValueEntry.CALCSUMS("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                        ExcelBuffer.AddColumn(ValueEntry."Item Ledger Entry Quantity", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.AddColumn(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                        ExcelBuffer.NewRow;
                    UNTIL Item.NEXT = 0;
            UNTIL Location.NEXT = 0;

        ExcelBuffer.WriteSheet('Valoracion', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('Valoracion');
        ExcelBuffer.OpenExcel();
        Window.Close();
    end;


    // =============     SCRAP Exportar DETALLE de FACTURAS          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    procedure GetTotalSalesInvoice(SalesInvHeader: Record "Sales Invoice Header") Total: Decimal
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Item: Record Item;
        SalesInvLine: Record "Sales Invoice Line";
    begin
        SalesSetup.Get();
        SalesInvLine.RESET;
        SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
        if SalesInvLine.FINDFIRST then
            repeat
                if item.Get(SalesInvLine."No.") then
                    Total += (SalesInvLine.Quantity * Item.Carton * SalesSetup."Amount SCRAP Carton") +
                             (SalesInvLine.Quantity * Item.Steel * SalesSetup."Amount SCRAP Steel") +
                             (SalesInvLine.Quantity * Item.Wood * SalesSetup."Amount SCRAP Wood") +
                             (SalesInvLine.Quantity * Item."Plastic Qty. (kg)" * SalesSetup."Amount SCRAP Plastic");

            until SalesInvLine.Next() = 0;
    end;

    procedure ExportExcelSalesInvoices(var SalesInvHeader: Record "Sales Invoice Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Item: Record Item;
        SalesInvLine: Record "Sales Invoice Line";
        Window: Dialog;
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Amount SCRAP Carton");
        SalesSetup.TestField("Amount SCRAP Steel");
        SalesSetup.TestField("Amount SCRAP Wood");
        SalesSetup.TestField("Amount SCRAP Plastic");
        Window.Open('#1##################\#2########################');
        ExcelBuffer.DELETEALL;
        ExcelBuffer.CreateNewBook('SCRAP Facturas de VENTA');

        ExcelBuffer.AddColumn('SCRAP Facturas de VENTA', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(CompanyName, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(StrSubstNo('Fecha: %1', WorkDate()), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;

        ExcelBuffer.AddColumn(SalesInvHeader.FieldCaption("No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvHeader.FieldCaption("Posting Date"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvHeader.FieldCaption("Sell-to Customer No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvHeader.FieldCaption("Sell-to Customer Name"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(SalesInvLine.FieldCaption("No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvLine.FieldCaption(Description), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesInvLine.FieldCaption(Quantity), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption("Plastic Qty. (kg)"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption("Recycled plastic Qty. (kg)"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption("Recycled plastic %"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesSetup.FieldCaption("Amount SCRAP Carton"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesSetup.FieldCaption("Amount SCRAP Steel"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesSetup.FieldCaption("Amount SCRAP Wood"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesSetup.FieldCaption("Amount SCRAP Plastic"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Importe', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow;


        IF SalesInvHeader.FINDFIRST THEN
            REPEAT
                Window.UPDATE(1, SalesInvHeader."No.");
                SalesInvLine.RESET;
                SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
                SalesInvLine.SetRange(Type, SalesInvLine.Type::Item);
                IF SalesInvLine.FINDFIRST THEN
                    REPEAT
                        Window.UPDATE(2, Item."No.");
                        if item.Get(SalesInvLine."No.") and ((Item.Wood <> 0) or (Item.Steel <> 0) or (Item.Carton <> 0)) then begin
                            ExcelBuffer.AddColumn(SalesInvHeader."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(SalesInvHeader."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(SalesInvHeader."Sell-to Customer No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(SalesInvHeader."Sell-to Customer Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                            ExcelBuffer.AddColumn(SalesInvLine."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(SalesInvLine.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(SalesInvLine.Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Item."Plastic Qty. (kg)", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Item."Recycled plastic Qty. (kg)", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Item."Recycled plastic %", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(SalesInvLine.Quantity * Item.Carton * SalesSetup."Amount SCRAP Carton", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(SalesInvLine.Quantity * Item.Steel * SalesSetup."Amount SCRAP Steel", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(SalesInvLine.Quantity * Item.Wood * SalesSetup."Amount SCRAP Wood", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(SalesInvLine.Quantity * Item."Plastic Qty. (kg)" * SalesSetup."Amount SCRAP Plastic", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn((SalesInvLine.Quantity * Item.Carton * SalesSetup."Amount SCRAP Carton") +
                                        (SalesInvLine.Quantity * Item.Steel * SalesSetup."Amount SCRAP Steel") +
                                        (SalesInvLine.Quantity * Item.Wood * SalesSetup."Amount SCRAP Wood") +
                                        (SalesInvLine.Quantity * Item."Plastic Qty. (kg)" * SalesSetup."Amount SCRAP Plastic")
                                        , FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.NewRow;
                        end;
                    UNTIL SalesInvLine.NEXT = 0;
            UNTIL SalesInvHeader.NEXT = 0;

        ExcelBuffer.WriteSheet('SCRAP Facturas de Venta', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename('SCRAP Facturas de Ventas');
        ExcelBuffer.OpenExcel();
        Window.Close();
    end;
}
