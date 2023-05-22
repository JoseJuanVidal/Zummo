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
    }

    keys
    {
        key(Key1; "Production BOM No.", "Period Start", "No.")
        {
            Clustered = true;
        }
    }

    var
        HISTBOMProduction: Record "ZM HIST BOM Production";
        ItemLdgEntry: Record "Item Ledger Entry";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComponent: Record "Prod. Order Component";
        Dates: Record Date;

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
        Window: Dialog;
    begin
        Window.Open('Cód. producto #1###########################\Fecha #2##########');

        Item.SetRange("Update BI BOM Costs", true);
        Item.SetFilter("Production BOM No.", '<>%1', '');
        if Item.FindFirst() then
            repeat
                FechasLMProductionBOM(Item."No.", Item."Production BOM No.");
            Until Item.next() = 0;
        Window.Close();
    end;


    local procedure FechasLMProductionBOM(ItemNo: code[20]; ProductionBOMNo: code[20])
    var
        Fechas: Record Date;
    begin
        Fechas.Reset();
        Fechas.SetRange("Period Type", Fechas."Period Type"::Month);
        Fechas.SetFilter("Period Start", '%1..%2', 20210101D, Today());
        if Fechas.FindFirst() then
            repeat
                AddLMProductionBOM(ItemNo, ProductionBOMNo, Fechas."Period Start", Fechas."Period End");
            until Fechas.Next() = 0;
    end;

    local procedure AddLMProductionBOM(ItemNo: code[20]; ProductionBOMNo: code[20]; PeriodStart: Date; PeriodEnd: date)
    var

        Ventana: Dialog;
    begin
        Ventana.Open('Producto: #1###########################\Fecha: #2#############\Orden: #3#################');
        Ventana.Update(1, ProductionBOMNo);
        // revisamos por periodos, las ordenes de producción y ponemos los productos y cantidad        

        Ventana.Update(2, PeriodStart);
        ItemLdgEntry.Reset();
        ItemLdgEntry.SetRange("Item No.", ItemNo);
        ItemLdgEntry.SetRange("Entry Type", ItemLdgEntry."Entry Type"::Output);
        ItemLdgEntry.SetRange("Posting Date", PeriodStart, PeriodEnd);
        ItemLdgEntry.SetRange(Positive, true);
        if ItemLdgEntry.FindLast() then begin
            Ventana.Update(3, ItemLdgEntry."Document No.");
            AddLMProduction(ItemLdgEntry, ProductionBOMNo, PeriodStart, PeriodEnd);
        end else begin
            ItemLdgEntry.Reset();
            ItemLdgEntry.SetRange("Item No.", ItemNo);
            ItemLdgEntry.SetFilter("Posting Date", '..%1', PeriodEnd);
            if ItemLdgEntry.FindLast() then begin
                Ventana.Update(3, ItemLdgEntry."Document No.");
                AddLMProduction(ItemLdgEntry, ProductionBOMNo, PeriodStart, PeriodEnd);
            end;
        end;

    end;

    local procedure AddLMProduction(ItemLdgEntry: Record "Item Ledger Entry"; ProductionBOMNo: code[20]; PeriodStart: Date; PeriodEnd: date)
    begin
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange("Prod. Order No.", ItemLdgEntry."Document No.");
        ProdOrderLine.SetRange("Line No.", ItemLdgEntry."Order Line No.");
        if ProdOrderLine.FindFirst() then begin
            ProdOrderComponent.Reset();
            ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
            ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
            ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
            if ProdOrderComponent.FindFirst() then
                repeat
                    AddHistBOMLine(ProdOrderLine, ProdOrderComponent, ProductionBOMNo, PeriodStart, PeriodEnd);
                Until ProdOrderComponent.next() = 0;
        end;
    end;

    local procedure AddHistBOMLine(ProdOrderLine: record "Prod. Order Line"; ProdOrderComponent: Record "Prod. Order Component"; ProductionBOMNo: code[20]; PeriodStart: Date; PeriodEnd: date)
    var
        Item: Record Item;
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
        HISTBOMProduction.Insert();
        if (Item."Replenishment System" in [item."Replenishment System"::"Prod. Order"]) and (Item."Production BOM No." <> '') then begin
            AddLMProductionBOM(ProdOrderComponent."Item No.", ProductionBOMNo, PeriodStart, PeriodEnd);
        end;
    end;

}