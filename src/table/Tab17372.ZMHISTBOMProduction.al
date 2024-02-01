table 17372 "ZM HIST BOM Production"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "ZM HIST BOM Productions";
    LookupPageId = "ZM HIST BOM Productions";

    fields
    {
        field(1; "Production BOM No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Production BOM No.', comment = 'ESP="Nº L.M. producción"';
            TableRelation = "Production BOM Header";
        }
        field(2; "Period Start"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period Start', comment = 'ESP=""';
        }
        field(4; "No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.', comment = 'ESP="Nº"';
            TableRelation = Item;
        }
        field(5; "Description"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(6; "Unit of Measure Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure Code', comment = 'ESP="Cód. unidad medida"';
        }
        field(7; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity', comment = 'ESP="Cantidad"';
        }
        field(8; "Routing Link Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Routing Link Code', comment = 'ESP="Cód. conexión ruta"';
        }
        field(9; "Quantity per"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(10; "Prod. Order No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. Order No.', comment = 'ESP="Nº Orden producción"';
        }
        field(11; "No manufacturing"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'No manufacturing', comment = 'ESP="Sin fabricación"';
        }
        field(15; Level; Integer)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Production BOM No.", "Period Start", "No.")
        {
            Clustered = true;
        }
    }

    var

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure UpdateBomHist()
    var
        Item: Record Item;
    begin
        Item.SetRange("Update BI BOM Costs", true);
        Item.SetFilter("Production BOM No.", '<>%1', '');
        if Item.FindFirst() then
            repeat
                FechasLMProductionBOM(Item."No.", Item."Production BOM No.");
            Until Item.next() = 0;
    end;


    procedure FechasLMProductionBOM(ItemNo: code[20]; ProductionBOMNo: code[20])
    var
        Fechas: Record Date;
    begin
        Fechas.Reset();
        Fechas.SetRange("Period Type", Fechas."Period Type"::Month);
        Fechas.SetFilter("Period Start", '%1..%2', 20200101D, Today());
        if Fechas.FindFirst() then
            repeat
                DeleteItemPeriodBom(ProductionBOMNo, Fechas."Period Start");
                AddLMProductionBOM(ItemNo, ProductionBOMNo, Fechas."Period Start", Fechas."Period End", 1);
            until Fechas.Next() = 0;
    end;

    procedure AddLMProductionBOM(ItemNo: code[20]; ProductionBOMNo: code[20]; PeriodStart: Date; PeriodEnd: date; Level: Integer)
    var
        ItemLdgEntry: Record "Item Ledger Entry";
        IsProductionOrder: Boolean;
        Ventana: Dialog;
    begin
        Ventana.Open('Producto: #1###########################\Fecha: #2#############\Orden: #3#################');
        Ventana.Update(1, ProductionBOMNo);
        // revisamos por periodos, las ordenes de producción y ponemos los productos y cantidad        

        Ventana.Update(2, PeriodStart);
        Ventana.Update(3, Level);
        ItemLdgEntry.Reset();
        ItemLdgEntry.SetRange("Item No.", ItemNo);
        ItemLdgEntry.SetRange("Entry Type", ItemLdgEntry."Entry Type"::Output);
        ItemLdgEntry.SetRange("Posting Date", PeriodStart, PeriodEnd);
        ItemLdgEntry.SetRange(Positive, true);
        if ItemLdgEntry.FindLast() then
            repeat
                if AddLMProduction(ItemLdgEntry, ItemNo, ProductionBOMNo, PeriodStart, PeriodEnd, Level) then
                    IsProductionOrder := true;
            until (ItemLdgEntry.Next() = 0) OR IsProductionOrder;
        if not IsProductionOrder then begin
            ItemLdgEntry.Reset();
            ItemLdgEntry.Ascending := false;
            ItemLdgEntry.SetRange("Item No.", ItemNo);
            ItemLdgEntry.SetRange("Entry Type", ItemLdgEntry."Entry Type"::Output);
            ItemLdgEntry.SetFilter("Posting Date", '..%1', PeriodEnd);
            if ItemLdgEntry.FindFirst() then
                repeat
                    if AddLMProduction(ItemLdgEntry, ItemNo, ProductionBOMNo, PeriodStart, PeriodEnd, Level) then
                        IsProductionOrder := true;
                until (ItemLdgEntry.Next() = 0) OR IsProductionOrder;
        end;

        if not IsProductionOrder then begin
            AddLMProductionItem(ProductionBOMNo, ItemNo, PeriodStart, PeriodEnd, Level);
        end;
    end;

    local procedure CheckOPSameItem(ProdOrderLine: Record "Prod. Order Line"; ItemNo: code[20]): Boolean
    var
        ProdOrderComponent: Record "Prod. Order Component";
    begin
        ProdOrderComponent.Reset();
        ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        ProdOrderComponent.SetRange("Item No.", ItemNo);
        if ProdOrderComponent.FindFirst() then
            exit(true);
    end;

    local procedure AddLMProduction(ItemLdgEntry: Record "Item Ledger Entry"; ParentItemNo: code[20]; ProductionBOMNo: code[20]; PeriodStart: Date; PeriodEnd: date; Level: Integer) OrdenBuena: Boolean
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComponent: Record "Prod. Order Component";
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange("Prod. Order No.", ItemLdgEntry."Document No.");
        ProdOrderLine.SetRange("Line No.", ItemLdgEntry."Order Line No.");
        if ProdOrderLine.FindFirst() then begin
            if not CheckOPSameItem(ProdOrderLine, ParentItemNo) then begin
                OrdenBuena := true;
                ProdOrderComponent.Reset();
                ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
                ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
                ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                if ProdOrderComponent.FindFirst() then
                    repeat
                        AddHistBOMLine(ProdOrderLine, ProdOrderComponent, ProductionBOMNo, PeriodStart, PeriodEnd, Level);
                    Until ProdOrderComponent.next() = 0;
            end;
        end;
    end;

    local procedure DeleteItemPeriodBom(ProductionBOMNo: code[20]; PeriodStart: date)
    var
        HISTBOMProduction: Record "ZM HIST BOM Production";
    begin
        HISTBOMProduction.Reset();
        HISTBOMProduction.SetRange("Production BOM No.", ProductionBOMNo);
        HISTBOMProduction.SetRange("Period Start", PeriodStart);
        HISTBOMProduction.DeleteAll();
    end;

    local procedure AddHistBOMLine(ProdOrderLine: record "Prod. Order Line"; ProdOrderComponent: Record "Prod. Order Component"; ProductionBOMNo: code[20]; PeriodStart: Date; PeriodEnd: date; Level: Integer)
    var
        Item: Record Item;
        HISTBOMProduction: Record "ZM HIST BOM Production";
    begin
        HISTBOMProduction.Reset();
        HISTBOMProduction.SetRange("Production BOM No.", ProductionBOMNo);
        HISTBOMProduction.SetRange("Period Start", PeriodStart);
        HISTBOMProduction.SetRange("No.", ProdOrderComponent."Item No.");
        if HISTBOMProduction.FindFirst() then begin
            HISTBOMProduction.Quantity := ProdOrderComponent.Quantity + ProdOrderComponent."Quantity per";
            HISTBOMProduction."Quantity per" := HISTBOMProduction."Quantity per" + ProdOrderComponent."Quantity per";
            exit;
        end;
        Item.Get(ProdOrderComponent."Item No.");
        HISTBOMProduction.Init();
        HISTBOMProduction."Production BOM No." := ProductionBOMNo;
        HISTBOMProduction."Period Start" := PeriodStart;
        HISTBOMProduction."No." := ProdOrderComponent."Item No.";
        HISTBOMProduction.Description := ProdOrderComponent.Description;
        HISTBOMProduction."Unit of Measure Code" := ProdOrderComponent."Unit of Measure Code";
        HISTBOMProduction.Quantity := ProdOrderComponent."Quantity per";
        HISTBOMProduction."Routing Link Code" := ProdOrderComponent."Routing Link Code";
        HISTBOMProduction."Quantity per" := ProdOrderComponent."Quantity per";
        HISTBOMProduction."Prod. Order No." := ProdOrderLine."Prod. Order No.";
        HISTBOMProduction.Level := Level;
        HISTBOMProduction.Insert();
        if (Item."Replenishment System" in [item."Replenishment System"::"Prod. Order"]) and (Item."Production BOM No." <> '') then begin
            AddLMProductionBOM(ProdOrderComponent."Item No.", ProductionBOMNo, PeriodStart, PeriodEnd, Level + 1);
        end;
    end;

    local procedure AddLMProductionItem(ProductionBOMNo: code[20]; ItemNo: code[20]; PeriodStart: Date; PeriodEnd: date; level: Integer)
    var
        Item: Record Item;
        ItemBOM: Record Item;
        ProductionBomLine: Record "Production BOM Line";
    begin
        item.Get(ItemNo);
        ProductionBomLine.Reset();
        ProductionBomLine.SetRange("Production BOM No.", Item."Production BOM No.");
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        ProductionBomLine.SetRange("Version Code", '');
        if ProductionBomLine.FindFirst() then
            repeat
                if ItemBOM.Get(ProductionBomLine."No.") then begin
                    if ItemBOM."Production BOM No." = '' then
                        AddHistBOMLineItem(ProductionBOMNo, ItemBOM, PeriodStart, PeriodEnd, ProductionBomLine."Quantity per", level)
                    else
                        AddLMProductionBOM(ItemBOM."No.", ProductionBOMNo, PeriodStart, PeriodEnd, level + 1);
                end;
            Until ProductionBomLine.next() = 0;
    end;

    local procedure AddHistBOMLineItem(ProductionBOMNo: code[20]; ItemBOM: Record Item; PeriodStart: Date; PeriodEnd: date; Quantityper: Decimal; Level: Integer)
    var
        HISTBOMProduction: Record "ZM HIST BOM Production";
    begin
        HISTBOMProduction.Reset();
        HISTBOMProduction.SetRange("Production BOM No.", ProductionBOMNo);
        HISTBOMProduction.SetRange("Period Start", PeriodStart);
        HISTBOMProduction.SetRange("No.", ItemBOM."No.");
        if HISTBOMProduction.FindFirst() then begin
            HISTBOMProduction.Quantity := Quantityper;
            HISTBOMProduction."Quantity per" := Quantityper;
            exit;
        end;
        HISTBOMProduction.Init();
        HISTBOMProduction."Production BOM No." := ProductionBOMNo;
        HISTBOMProduction."Period Start" := PeriodStart;
        HISTBOMProduction."No." := ItemBOM."No.";
        HISTBOMProduction.Description := HISTBOMProduction.Description;
        HISTBOMProduction."Unit of Measure Code" := ItemBOM."Base Unit of Measure";
        HISTBOMProduction.Quantity := Quantityper;
        HISTBOMProduction."Routing Link Code" := '';
        if (ItemBOM."Replenishment System" in [ItemBOM."Replenishment System"::"Prod. Order"]) and (ItemBOM."Production BOM No." <> '') then
            HISTBOMProduction."Quantity per" := 0
        else
            HISTBOMProduction."Quantity per" := Quantityper;
        HISTBOMProduction."Prod. Order No." := '';
        HISTBOMProduction.Level := Level;
        HISTBOMProduction."No manufacturing" := true;
        HISTBOMProduction.Insert();
        if (ItemBOM."Replenishment System" in [ItemBOM."Replenishment System"::"Prod. Order"]) and (ItemBOM."Production BOM No." <> '') then begin
            AddLMProductionBOM(ItemBOM."No.", ProductionBOMNo, PeriodStart, PeriodEnd, Level + 1);
        end;
    end;
}