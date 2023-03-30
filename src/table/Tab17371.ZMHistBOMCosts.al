table 17371 "ZM Hist. BOM Costs"
{
    Caption = 'ZM Hist. BOM Cost';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "BOM Item No."; Code[20])
        {
            Caption = 'BOM Item No.';
            DataClassification = CustomerContent;
        }
        field(2; Periodo; Text[10])
        {
            Caption = 'Periodo';
            DataClassification = CustomerContent;
        }
        field(5; "Item Nº"; Code[20])
        {
            Caption = 'Item Nº';
            DataClassification = CustomerContent;
        }
        field(6; Descripcion; Text[100])
        {
            Caption = 'Descripción';
            DataClassification = CustomerContent;
        }
        field(7; "Cantidad en BOM"; Decimal)
        {
            Caption = 'Cantidad en BOM';
            DataClassification = CustomerContent;
        }
        field(8; "Coste Periodo"; Decimal)
        {
            Caption = 'Coste Periodo';
            DataClassification = CustomerContent;
        }
        field(9; "Importe por maquina"; Decimal)
        {
            Caption = 'Importe por maquina';
            DataClassification = CustomerContent;
        }
        field(10; "Tipo coste"; Code[20])
        {
            Caption = 'Método coste';
            DataClassification = CustomerContent;
        }
        field(11; "Coste estandar"; Decimal)
        {
            Caption = 'Coste estandar';
            DataClassification = CustomerContent;
        }
        field(12; "Coste unitario"; Decimal)
        {
            Caption = 'Coste unitario';
            DataClassification = CustomerContent;
        }
        field(13; Proveedor; Code[20])
        {
            Caption = 'Proveedor';
            DataClassification = CustomerContent;
        }
        field(14; "Nombre Proveedor"; text[100])
        {
            Caption = 'Nombre Proveedor';
            DataClassification = CustomerContent;
        }
        field(15; "Ultimo proveedor"; Code[20])
        {
            Caption = 'Ultimo proveedor';
            DataClassification = CustomerContent;
        }
        field(16; "Nombre Ult. Proveedor"; text[100])
        {
            Caption = 'Nombre Ult. Proveedor';
            DataClassification = CustomerContent;
        }
        field(17; "Ultimo pedido"; Code[20])
        {
            Caption = 'Ultimo pedido';
            DataClassification = CustomerContent;
        }
        field(18; "Ultima Fecha de compra"; date)
        {
            Caption = 'Ultima Fecha de compra';
            DataClassification = CustomerContent;
        }
        field(19; "Ultimo precio de compra"; Decimal)
        {
            Caption = 'Ultimo precio de compra';
            DataClassification = CustomerContent;
        }
        field(20; Familia; Text[100])
        {
            Caption = 'Familia';
            DataClassification = CustomerContent;
        }
        field(21; Categoria; Text[100])
        {
            Caption = 'Categoria';
            DataClassification = CustomerContent;
        }
        field(22; SubCategoria; Text[100])
        {
            Caption = 'SubCategoria';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "BOM Item No.")
        {
            Clustered = true;
        }
    }

    procedure UpdateTableBOMCosts()
    var
        Item: Record Item;
        Window: Dialog;
    begin
        Window.Open('Cód. producto #1###########################\Fecha #2##########');

        if Item.FindFirst() then
            repeat
                AddProductionBomLine(Item."Production BOM No.");
            Until Item.next() = 0;
        Window.Close();




    end;

    local procedure AddProductionBomLine(ProductionBOMNo: code[20])
    var
        ItemBOM: Record Item;
        ProductionBomLine: Record "Production BOM Line";
        Periode: code[10];
    begin
        // TODO Calcular los periodos y poner filtro de productos marcados

        ProductionBomLine.Reset();
        ProductionBomLine.SetRange("Production BOM No.", ProductionBOMNo);
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        if ProductionBomLine.FindFirst() then
            repeat
                if ItemBOM.Get(ProductionBomLine."No.") then begin
                    if ItemBOM."Production BOM No." = '' then
                        ItemBomtoBufferExcel(ProductionBOMNo, ItemBOM, Periode, ProductionBomLine."Quantity per", ProductionBomLine."Production BOM No.")
                    else
                        GetBOMProduction(ProductionBOMNo, ItemBOM, Periode, ProductionBomLine."Quantity per");
                end;
            Until ProductionBomLine.next() = 0;
    end;

    local procedure GetBOMProduction(BomNo: code[20]; ItemBom: Record Item; Periode: code[10]; QTQPer: Decimal)
    var
        ItemBOMLine: Record Item;
        ProductionBomLine: Record "Production BOM Line";

    begin
        ItemBomtoBufferExcel(BomNo, ItemBOM, Periode, 0, ProductionBomLine."Production BOM No.");
        ProductionBomLine.Reset();
        ProductionBomLine.SetRange("Production BOM No.", ItemBom."Production BOM No.");
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        if ProductionBomLine.FindFirst() then
            repeat
                if ItemBOM.Get(ProductionBomLine."No.") then begin
                    if ItemBOM."Production BOM No." = '' then
                        ItemBomtoBufferExcel(BomNo, ItemBOM, Periode, ProductionBomLine."Quantity per", ProductionBomLine."Production BOM No.")
                    else
                        GetBOMProduction(BomNo, ItemBOM, Periode, ProductionBomLine."Quantity per");
                end;
            Until ProductionBomLine.next() = 0;

    end;

    local procedure ItemBomtoBufferExcel(BomNo: code[20]; ItemBom: Record Item; Periode: code[10]; QTQPer: Decimal; ParentItemNo: code[20])
    var
        HistBOMCosts: Record "ZM Hist. BOM Costs";
        AddNEW: Boolean;
    begin
        HistBOMCosts.Reset();
        HistBOMCosts.SetRange("BOM Item No.", BomNo);
        HistBOMCosts.SetRange("Item Nº", ItemBom."No.");
        HistBOMCosts.SetRange(Periodo, Periode);
        if HistBOMCosts.FindFirst() then begin
            HistBOMCosts."Cantidad en BOM" += QTQPer;
            HistBOMCosts."Importe por maquina" := HistBOMCosts."Cantidad en BOM" * HistBOMCosts."Coste Periodo";
            HistBOMCosts.Modify();

            AddNEW := true;
        end;

        if not AddNEW then begin
            AddItemBomtoBufferExcel(BomNo, ItemBOM, Periode, QTQPer);
        end;
    end;

    local procedure AddItemBomtoBufferExcel(BomNo: code[20]; ItemBom: Record Item; Periode: code[10]; QTQPer: Decimal)
    var
        Vendor: Record Vendor;
        HistBOMCosts: Record "ZM Hist. BOM Costs";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchReceiptHeader: Record "Purch. Rcpt. Header";
    begin
        ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", ItemBom."No.");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        if ItemLedgerEntry.FindLast() then;
        ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
        if PurchReceiptHeader.get(ItemLedgerEntry."Document No.") then;
        HistBOMCosts.Reset();
        HistBOMCosts.Init();
        HistBOMCosts."BOM Item No." := BomNo;
        HistBOMCosts.Periodo := Periode;
        HistBOMCosts."Item Nº" := ItemBom."No.";
        HistBOMCosts.Descripcion := ItemBom.Description;
        HistBOMCosts."Cantidad en BOM" := QTQPer;

        case ItemBom."Costing Method" of
            ItemBom."Costing Method"::Average, ItemBom."Costing Method"::FIFO, ItemBom."Costing Method"::LIFO:
                begin
                    HistBOMCosts."Coste Periodo" := ItemBom."Unit Cost";
                    HistBOMCosts."Importe por maquina" := QTQPer * ItemBom."Unit Cost";
                end;
            else begin
                HistBOMCosts."Coste Periodo" := ItemBom."Standard Cost";
                HistBOMCosts."Importe por maquina" := QTQPer * ItemBom."Standard Cost";
            end;
        end;
        HistBOMCosts."Tipo coste" := format(ItemBom."Costing Method");
        HistBOMCosts."Coste estandar" := ItemBom."Standard Cost";
        HistBOMCosts."Coste unitario" := ItemBom."Unit Cost";
        if Vendor.Get(ItemBom."Vendor No.") then;
        HistBOMCosts.Proveedor := ItemBom."Vendor No.";
        HistBOMCosts."Nombre Proveedor" := Vendor.Name;
        HistBOMCosts."Ultimo proveedor" := ItemLedgerEntry."Source No.";
        if Vendor.Get(ItemLedgerEntry."Source No.") then;
        HistBOMCosts."Nombre Ult. Proveedor" := Vendor.Name;
        HistBOMCosts."Ultimo pedido" := PurchReceiptHeader."Order No.";
        HistBOMCosts."Ultima Fecha de compra" := ItemLedgerEntry."Posting Date";

        if ItemLedgerEntry.Quantity = 0 then
            HistBOMCosts."Ultimo precio de compra" := 0
        else
            HistBOMCosts."Ultimo precio de compra" := Round(ItemLedgerEntry."Cost Amount (Actual)" / ItemLedgerEntry.Quantity, 0.01);
        ItemBom.CalcFields("Desc. Purch. Family", "Desc. Purch. Category", "Desc. Purch. SubCategory");
        HistBOMCosts.Familia := ItemBom."Desc. Purch. Family";
        HistBOMCosts.Categoria := ItemBom."Desc. Purch. Category";
        HistBOMCosts.SubCategoria := ItemBom."Desc. Purch. SubCategory";
        HistBOMCosts.Modify();
    end;

}
