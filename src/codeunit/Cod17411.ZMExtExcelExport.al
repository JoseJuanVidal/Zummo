codeunit 17411 "ZM Ext Excel Export"
{
    trigger OnRun()
    begin

    end;

    // =============     EXPORTACION A EXCEL DE LISTA DE VENDEDORES          ====================
    // ==  
    // ==  TZ-856 Informe de referencias y precios por proveedor
    // ==  
    // ==  reporte que ingresando por Nº y/o Nombre de proveedor, nos indique las referencias que ese proveedor tiene asignadas junto con sus datos de compra.  
    // ==  
    // ==  INPUT - Cod. proveedor - 
    // ==       Nombre 
    // ==       Filtro Fecha 
    // ==  
    // ==  OUTPUT - Cod. Nº Referencia
    // ==       Descripción
    // ==       Unidad de medida
    // ==       precio unitario ficha
    // ==       tarifa X - Dias Entrega
    // ==       tarifa X - precio unitario
    // ==       tarifa X - cantidad lote

    procedure ExportVendorPrice()
    var
        Item: Record Item;
        Vendor: Record Vendor;
        PurchasePrice: Record "Purchase Price";
        ExcelBuffer: Record "Excel Buffer" temporary;
        RefRecord: RecordRef;
        RefField: FieldRef;
        Filters: text;
        VendorNo: code[20];
        RangeMin: date;
        RangeMax: date;
        Window: Dialog;
        lblConfirm: Label 'No filter has been indicated\¿Do you want to continue?', comment = 'ESP="No se ha indicado ningun filtro.\¿Desea continuar?"';
        lblDialog: Label 'Proveedor #1#############\Prodcuto #2##################################'
                , comment = 'ESP="Proveedor #1#############\Prodcuto #2##################################"';
    begin

        Filters := GetVendorRequestFilter(RefRecord);
        if Filters = '' then
            if not Confirm(lblConfirm) then
                exit;
        RefField := RefRecord.field(Vendor.FieldNo("No."));
        Vendor.SetFilter("No.", RefField.GetFilter);
        RefField := RefRecord.field(Vendor.FieldNo("Date Filter"));
        Vendor.SetFilter("Date Filter", RefField.GetFilter);

        Window.Open(lblDialog);
        ExcelBuffer.DELETEALL;
        ExcelBuffer.CreateNewBook('Proveedor - Tarifa precios');
        // creamos la cabecera de la excel
        HeaderVendorPricesExcelBuffer(ExcelBuffer, Filters);

        // añadimos las líneas
        if Vendor.FindFirst() then
            repeat
                Window.Update(1, Vendor."No.");
                Item.Reset();
                if Item.FindFirst() then
                    repeat
                        Window.Update(2, Item."No.");

                        PurchasePrice.Reset();
                        PurchasePrice.SetRange("Vendor No.", Vendor."No.");
                        PurchasePrice.SetRange("Item No.", Item."No.");
                        // if Vendor.GetFilter("Date Filter") <> '' then begin
                        //     if strpos(Vendor.GetFilter("Date Filter"), '..') = 1 then
                        //         RangeMin := RangeMin;
                        //     if strpos(Vendor.GetFilter("Date Filter"), '..') = 1 then
                        //         RangeMax := Vendor.GetRangeMax("Date Filter");
                        // end;
                        // PurchasePrice.SetFilter("Starting Date", '%1..%2', RangeMin, RangeMax);
                        if (Item."Vendor No." = Vendor."No.") or (PurchasePrice.FindFirst()) then begin
                            ExcelBuffer.NewRow();
                            LinesVendorExcelBuffer(ExcelBuffer, Vendor, Item);
                            if PurchasePrice.findset() then begin
                                repeat
                                    LinesVendorPricesExcelBuffer(ExcelBuffer, PurchasePrice);
                                Until PurchasePrice.next() = 0;
                            end;
                        end;
                    Until Item.next() = 0;
            Until Vendor.next() = 0;
        Window.Close();
        ExcelBuffer.WriteSheet('Proveedor - tarifa precios', COMPANYNAME, USERID);
        ExcelBuffer.CloseBook();
        ExcelBuffer.DownloadAndOpenExcel;

    end;

    local procedure HeaderVendorPricesExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; TextoFiltro: text)
    var
        Vendor: Record Vendor;
        Item: Record Item;
        PurchasePrice: Record "Purchase Price";
    begin
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Informe tarifas de Proveedor - precios', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn('Filtro:', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(TextoFiltro, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.NewRow();
        ExcelBuffer.NewRow();
        ExcelBuffer.AddColumn(Vendor.FieldCaption("No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Vendor.FieldCaption(Name), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption("No."), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption(Description), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption(Blocked), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Principal', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption("Base Unit of Measure"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption("Unit Cost"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption("Last Direct Cost"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Precio proveedor', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Fecha ultima compra', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.FieldCaption("Lead Time Calculation"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchasePrice.FieldCaption("Starting Date"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchasePrice.FieldCaption("Ending Date"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchasePrice.FieldCaption("Direct Unit Cost"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchasePrice.FieldCaption("Minimum Quantity"), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure LinesVendorExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; Vendor: Record Vendor; Item: Record Item)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        Unitcost: Decimal;
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedgerEntry.Ascending(false);
        ItemLedgerEntry.SetRange(Positive, true);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange("Item No.", Item."No.");
        ItemLedgerEntry.SetRange("Source No.", Vendor."No.");
        if ItemLedgerEntry.FindFirst() then;
        ExcelBuffer.AddColumn(Vendor."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Vendor.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(format(Item.Blocked), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(format(Item."Vendor No." = Vendor."No."), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item."Base Unit of Measure", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(Item."Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(Item."Last Direct Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
        if ItemLedgerEntry.Quantity <> 0 then
            Unitcost := ItemLedgerEntry."Cost Amount (Actual)" / ItemLedgerEntry.Quantity;
        ExcelBuffer.AddColumn(Unitcost, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ItemLedgerEntry."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(Item."Lead Time Calculation", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure LinesVendorPricesExcelBuffer(var ExcelBuffer: Record "Excel Buffer"; PurchasePrice: Record "Purchase Price")
    begin
        ExcelBuffer.AddColumn(PurchasePrice."Starting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchasePrice."Ending Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(PurchasePrice."Direct Unit Cost", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(PurchasePrice."Minimum Quantity", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
    end;

    local procedure GetVendorRequestFilter(var RefRecord: RecordRef): Text
    var
        TempBlob: Record TempBlob;
        RequestPageParametersHelper: Codeunit "Request Page Parameters Helper";
        XMLParameters: text;
        OStream: OutStream;
    begin
        XMLParameters := Report.RunRequestPage(Report::"Vendor - Top 10 List");
        if XMLParameters = '' then
            exit;
        RefRecord.Open(Database::Vendor);
        TempBlob.Blob.CREATEOUTSTREAM(OStream);
        OStream.WRITETEXT(XMLParameters);
        RequestPageParametersHelper.ConvertParametersToFilters(RefRecord, TempBlob);

        exit(RefRecord.GetFilters());
    end;

    // ======================================================================================================        
}
