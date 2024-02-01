table 17371 "ZM Hist. BOM Costs"
{
    Caption = 'ZM Hist. BOM Cost';
    DataClassification = CustomerContent;
    LookupPageId = "ZM Hist. BOM Costs list";
    DrillDownPageId = "ZM Hist. BOM Costs list";

    fields
    {
        field(1; "BOM Item No."; Code[20])
        {
            Caption = 'BOM Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(2; Periodo; Text[20])
        {
            Caption = 'Periodo';
            DataClassification = CustomerContent;
        }
        field(3; "Period Start"; Date)
        {
            Caption = 'Inicio Periodo';
            DataClassification = CustomerContent;
        }
        field(5; "Item Nº"; Code[20])
        {
            Caption = 'Item Nº';
            DataClassification = CustomerContent;
            TableRelation = Item;
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
            DecimalPlaces = 2 : 5;
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
            DecimalPlaces = 2 : 5;
        }
        field(12; "Coste unitario"; Decimal)
        {
            Caption = 'Coste unitario';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
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
            DecimalPlaces = 2 : 5;
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
        field(25; "Parent BOM No."; Code[20])
        {
            Caption = 'Parent BOM No.';
            DataClassification = CustomerContent;
        }

    }
    keys
    {
        key(PK; "BOM Item No.", Periodo, "Item Nº")
        {
            Clustered = true;
        }
    }
    var
        HISTBOMProduction: Record "ZM HIST BOM Production";

    procedure UpdateTableBOMCosts()
    var
        Item: Record Item;
        Window: Dialog;
    begin
        Window.Open('Cód. producto #1###########################\Fecha #2##########');

        Item.SetRange("Update BI BOM Costs", true);
        Item.SetFilter("Production BOM No.", '<>%1', '');
        if Item.FindFirst() then
            repeat
                AddHistProductionBomLine(Item."No.", Item."Production BOM No.");
            Until Item.next() = 0;
        Window.Close();
    end;

    local procedure AddHistProductionBomLine(ItemNo: code[20]; ProductionBOMNo: code[20])
    var
        ItemBOM: Record Item;
        Fechas: Record Date;
        Periode: code[20];
        Window: Dialog;
    begin
        Window.Open('Fecha #1###############\BOM #2##############\Producto #3########################');
        Fechas.Reset();
        Fechas.SetRange("Period Type", Fechas."Period Type"::Month);
        Fechas.SetFilter("Period Start", '%1..%2', 20200101D, Today());
        if Fechas.FindFirst() then
            repeat
                DeleteHistBOMCosts(ProductionBOMNo, Fechas."Period Start");
                // comprobamos si ya se ha realizado este producto en esta fecha
                if ExistProductionItem(ProductionBOMNo, Fechas."Period Start") then begin
                    Periode := StrSubstNo('%1 %2 %3', Date2DMY(Fechas."Period End", 3),
                        PADSTR('0', 2 - STRLEN(FORMAT(Date2DMY(Fechas."Period End", 2)))) + format(Date2DMY(Fechas."Period End", 2)), Fechas."Period Name");
                    Window.Update(1, Periode);
                    HISTBOMProduction.Reset();
                    HISTBOMProduction.SetRange("Production BOM No.", ProductionBOMNo);
                    HISTBOMProduction.SetRange("Period Start", Fechas."Period Start");
                    if HISTBOMProduction.FindFirst() then
                        repeat
                            Window.Update(2, ProductionBOMNo);
                            Window.Update(3, HISTBOMProduction."No.");
                            ItemBOM.Get(HISTBOMProduction."No.");
                            ItemBomtoBufferExcel(ProductionBOMNo, ProductionBOMNo, ItemBOM, Periode, Fechas."Period Start", Fechas."Period End",
                                HISTBOMProduction."Quantity per", HISTBOMProduction."Production BOM No.");

                        Until HISTBOMProduction.next() = 0;
                end;
            Until Fechas.next() = 0;
    end;

    local procedure DeleteHistBOMCosts(ProductionBOMNo: code[20]; PeriodStart: date)
    var
        HistBOMCosts: Record "ZM Hist. BOM Costs";
    begin
        HistBOMCosts.Reset();
        HistBOMCosts.SetRange("BOM Item No.", ProductionBOMNo);
        HistBOMCosts.SetRange("Period Start", PeriodStart);
        HistBOMCosts.DeleteAll();
    end;

    local procedure AddProductionBomLine(ItemNo: code[20]; ProductionBOMNo: code[20])
    var
        ItemBOM: Record Item;
        ProductionBomLine: Record "Production BOM Line";
        Fechas: Record Date;
        Periode: code[20];
        Window: Dialog;
    begin
        Window.Open('Fecha #1###############\BOM #2##############\Producto #3########################');
        Fechas.Reset();
        Fechas.SetRange("Period Type", Fechas."Period Type"::Month);
        Fechas.SetFilter("Period Start", '%1..%2', 20210101D, Today());
        if Fechas.FindFirst() then
            repeat
                // comprobamos si ya se ha realizado este producto en esta fecha
                //if ExistProductionItem(ItemNo, Fechas."Period End") then begin
                Periode := StrSubstNo('%1 %2 %3', Date2DMY(Fechas."Period End", 3),
                    PADSTR('0', 2 - STRLEN(FORMAT(Date2DMY(Fechas."Period End", 2)))) + format(Date2DMY(Fechas."Period End", 2)), Fechas."Period Name");
                Window.Update(1, Periode);
                ProductionBomLine.Reset();
                ProductionBomLine.SetRange("Production BOM No.", ProductionBOMNo);
                ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
                ProductionBomLine.SetRange("Version Code", '');
                if ProductionBomLine.FindFirst() then
                    repeat
                        Window.Update(2, ProductionBOMNo);
                        Window.Update(3, ProductionBomLine."No.");
                        if ItemBOM.Get(ProductionBomLine."No.") then begin
                            if ItemBOM."Production BOM No." = '' then
                                ItemBomtoBufferExcel(ProductionBOMNo, ProductionBOMNo, ItemBOM, Periode, Fechas."Period Start", Fechas."Period End",
                                    ProductionBomLine."Quantity per", ProductionBomLine."Production BOM No.")
                            else
                                GetBOMProduction(ProductionBOMNo, ItemBOM, Periode, Fechas."Period Start", Fechas."Period End", ProductionBomLine."Quantity per");
                        end;
                    Until ProductionBomLine.next() = 0;
            // end;
            Until Fechas.next() = 0;
    end;

    local procedure ExistProductionItem(ProductionBOMNo: code[20]; PeriodStart: Date): Boolean
    var
    begin
        HISTBOMProduction.Reset();
        HISTBOMProduction.SetRange("Production BOM No.", ProductionBOMNo);
        HISTBOMProduction.SetRange("Period Start", PeriodStart);
        if HISTBOMProduction.FindFirst() then
            exit(true);
    end;

    local procedure GetBOMProduction(BomNo: code[20]; ItemBom: Record Item; Periode: code[20]; StartPeriode: date; EndPeriode: date; QTQPer: Decimal)
    var
        ItemBOMLine: Record Item;
        ProductionBomLine: Record "Production BOM Line";
    begin
        ItemBomtoBufferExcel(BomNo, '', ItemBOM, Periode, StartPeriode, StartPeriode, 0, ProductionBomLine."Production BOM No.");
        ProductionBomLine.Reset();
        ProductionBomLine.SetRange("Production BOM No.", ItemBom."Production BOM No.");
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        ProductionBomLine.SetRange("Version Code", '');
        if ProductionBomLine.FindFirst() then
            repeat
                if ItemBOM.Get(ProductionBomLine."No.") then begin
                    if (ItemBOM."Production BOM No." = '') or (ItemBom."Replenishment System" in [ItemBom."Replenishment System"::Purchase]) then
                        ItemBomtoBufferExcel(BomNo, ProductionBomLine."Production BOM No.", ItemBOM, Periode, StartPeriode, EndPeriode, ProductionBomLine."Quantity per", ProductionBomLine."Production BOM No.")
                    else
                        GetBOMProduction(BomNo, ItemBOM, Periode, StartPeriode, EndPeriode, QTQPer * ProductionBomLine."Quantity per");
                end;
            Until ProductionBomLine.next() = 0;

    end;

    local procedure ItemBomtoBufferExcel(BomNo: code[20]; ParentBomNo: code[20];
        ItemBom: Record Item;
        Periode: code[20];
        StartPeriode: date;
        EndPeriode: date;
        QTQPer: Decimal;
        ParentItemNo: code[20])
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
            AddItemBomtoBufferExcel(BomNo, ParentBomNo, ItemBOM, Periode, StartPeriode, EndPeriode, QTQPer);
        end;
    end;

    local procedure AddItemBomtoBufferExcel(BomNo: code[20]; ParentBomNo: code[20]; ItemBom: Record Item; Periode: code[20]; StartPeriode: date; EndPeriode: date; QTQPer: Decimal)
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
        ItemLedgerEntry.SetFilter("Posting Date", '..%1', EndPeriode);
        if ItemLedgerEntry.FindLast() then;
        ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
        if PurchReceiptHeader.get(ItemLedgerEntry."Document No.") then;
        HistBOMCosts.Reset();
        HistBOMCosts.Init();
        HistBOMCosts."BOM Item No." := BomNo;
        HistBOMCosts.Periodo := Periode;
        HistBOMCosts."Period Start" := StartPeriode;
        HistBOMCosts."Item Nº" := ItemBom."No.";
        HistBOMCosts.Descripcion := ItemBom.Description;
        HistBOMCosts."Cantidad en BOM" := QTQPer;
        HistBOMCosts."Coste Periodo" := CalcCostItemPeriod(ItemBom."No.", EndPeriode);
        HistBOMCosts."Importe por maquina" := QTQPer * ItemBom."Unit Cost";
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
            HistBOMCosts."Ultimo precio de compra" := Round((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") / ItemLedgerEntry.Quantity, 0.01);
        ItemBom.CalcFields("Desc. Purch. Family", "Desc. Purch. Category", "Desc. Purch. SubCategory");
        HistBOMCosts.Familia := ItemBom."Desc. Purch. Family";
        HistBOMCosts.Categoria := ItemBom."Desc. Purch. Category";
        HistBOMCosts.SubCategoria := ItemBom."Desc. Purch. SubCategory";
        HistBOMCosts."Parent BOM No." := ParentBomNo;
        HistBOMCosts.Insert();
    end;

    local procedure UpdateItem()
    var
        Item: Record Item;
        HistBOMCosts: Record "ZM Hist. BOM Costs";
        Window: Dialog;
    begin
        Window.Open('BOM: #1###########################\Producto: #2##################################');
        if HistBOMCosts.FindFirst() then
            repeat
                Window.Update(1, HistBOMCosts."BOM Item No.");
                Window.Update(2, HistBOMCosts."Item Nº");
                if Item.Get(HistBOMCosts."Item Nº") then begin
                    Item.CalcFields("Desc. Purch. Family", "Desc. Purch. Category", "Desc. Purch. SubCategory");
                    HistBOMCosts.Familia := Item."Desc. Purch. Family";
                    HistBOMCosts.Categoria := Item."Desc. Purch. Category";
                    HistBOMCosts.SubCategoria := Item."Desc. Purch. SubCategory";
                    HistBOMCosts.Modify();
                end
            Until HistBOMCosts.next() = 0;
        Window.Close();
    end;

    local procedure CalcCostItemPeriod(ItemNo: code[20]; EndPerid: date): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange(Positive, true);
        ItemLedgerEntry.SetFilter("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::Purchase, ItemLedgerEntry."Entry Type"::Output);
        ItemLedgerEntry.SetFilter("Posting Date", '..%1', EndPerid);
        if ItemLedgerEntry.FindLast() then begin
            ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
            if ItemLedgerEntry.Quantity <> 0 then
                exit(round((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") / ItemLedgerEntry.Quantity, 0.00001));
        end else begin
            ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::"Positive Adjmt.");
            if ItemLedgerEntry.FindLast() then begin
                ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Cost Amount (Expected)");
                if ItemLedgerEntry.Quantity <> 0 then
                    exit(round((ItemLedgerEntry."Cost Amount (Actual)" + ItemLedgerEntry."Cost Amount (Expected)") / ItemLedgerEntry.Quantity, 0.00001));

            end;
        end;
    end;

    procedure DeleteResultsItem(Item: Record Item)
    var
        HistCost: Record "ZM Hist. BOM Costs";
    begin
        HistCost.Reset();
        HistCost.SetRange("BOM Item No.", Item."Production BOM No.");
        HistCost.DeleteAll();
    end;
}
