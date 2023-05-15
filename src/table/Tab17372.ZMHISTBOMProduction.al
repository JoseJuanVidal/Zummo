table 17372 "ZM HIST BOM Production"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Production BOM No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Production BOM No.', comment = 'ESP="Nº L.M. producción"';
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
                AddLMProductionBOM(Item."No.", Item."Production BOM No.");
            Until Item.next() = 0;
        Window.Close();
    end;

    local procedure AddLMProductionBOM(ItemNo: code[20]; ProductionBOMNo: code[20])
    var
        Fechas: Record Date;

    begin
        // revisamos por periodos, las ordenes de producción y ponemos los productos y cantidad
        Fechas.Reset();
        Fechas.SetRange("Period Type", Fechas."Period Type"::Month);
        Fechas.SetFilter("Period Start", '%1..%2', 20210101D, Today());
        if Fechas.FindFirst() then
            repeat
                ItemLdgEntry.Reset();
                ItemLdgEntry.SetRange("Item No.", ItemNo);
                ItemLdgEntry.SetRange("Posting Date", Fechas."Period Start", Fechas."Period End");
                ItemLdgEntry.SetRange(Positive, true);
                if ItemLdgEntry.FindLast() then begin
                    AddLMProduction(ItemLdgEntry, Fechas."Period End");
                end else begin
                    ItemLdgEntry.Reset();
                    ItemLdgEntry.SetRange("Item No.", ItemNo);
                    ItemLdgEntry.SetFilter("Posting Date", '..%1', Fechas."Period End");
                    if ItemLdgEntry.FindLast() then
                        AddLMProduction(ItemLdgEntry, Fechas."Period End");
                end;
            until Fechas.Next() = 0;
    end;

    local procedure AddLMProduction(ItemLdgEntry: Record "Item Ledger Entry"; EndPeriod: Date)
    var
        myInt: Integer;
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
                    AddHistBOMLine(ProdOrderLine, ProdOrderComponent, EndPeriod)
                Until ProdOrderComponent.next() = 0;
        end;
    end;

    local procedure AddHistBOMLine(ProdOrderLine: record "Prod. Order Line"; ProdOrderComponent: Record "Prod. Order Component"; EndPeriod: Date)
    var
        myInt: Integer;
    begin
        HISTBOMProduction.Reset();
        HISTBOMProduction.SetRange("Production BOM No.", ProdOrderLine."Production BOM No.");
        HISTBOMProduction.SetRange("Period Start", EndPeriod);

    end;

}