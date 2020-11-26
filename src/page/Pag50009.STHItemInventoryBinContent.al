page 50009 "STH Item Inventory Bin Content"
{
    PageType = Worksheet;
    SourceTable = "Bin Content Buffer";
    SourceTableTemporary = true;
    Caption = 'Item - Inventory Bin Content', Comment = 'Productos - Inventario por Ubicación';
    ApplicationArea = All;
    UsageCategory = Documents;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    layout
    {
        area(content)
        {
            group(Opciones)
            {
                Caption = 'Filter Options', Comment = 'Opciones filtro';
                field("Item No. Filter"; ItemNoFilter)
                {
                    Caption = 'Item No. filter', Comment = 'Filtro Cód. Producto';
                    ApplicationArea = All;
                    TableRelation = Item;
                }
                field("Item Desc. Filter"; ItemDescFilter)
                {
                    Caption = 'Item Desc. filter', Comment = 'Filtro Desc. Producto';
                    ApplicationArea = All;
                }
                field("Item Category Code filter"; ItemCategoryCode)
                {
                    Caption = 'Item Category Code filter', Comment = 'Filtro Cód. Categoria';
                    ApplicationArea = All;
                    TableRelation = "Item Category";
                }
                field(ItemClientFilter; ItemClientFilter)
                {
                    Caption = 'Customer Filter', comment = 'Filtro Cliente';
                    ApplicationArea = All;
                    TableRelation = Customer;
                }
                field(HideItemInventory; HideItemInventory)
                {
                    ApplicationArea = All;
                    Caption = 'Hide Items not inventory', Comment = 'Ocultar los productos sin Inventario';
                }
                field(NotShowEmptyLocation; NotShowEmptyLocation)
                {
                    ApplicationArea = All;
                    Caption = 'Not show empty Location', Comment = 'Ocultar Sin Almacén';
                }
            }
            repeater(General)
            {
                Caption = 'General', Comment = 'General';
                IndentationColumn = DocumentNoIndent;
                IndentationControls =;
                ShowAsTree = true;
                field("Location Code"; "Location Code")
                {
                    Caption = 'Location Code', Comment = 'Cód. Almacén';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                }
                field("Bin Code"; "Bin Code")
                {
                    Caption = 'Item No.', Comment = 'Cód. Producto';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                    // sustituye este campo a item no. 
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record item;
                        ItemList: Page "Item Lookup";
                    begin
                        Item.get("Bin Code");
                        ItemList.SetTableView(Item);
                        ItemList.RunModal();
                    end;
                }
                field(Description; item.Description)
                {
                    Caption = 'Description', Comment = 'Descripción';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                }
                field("Item No."; "Item No.")
                {
                    Caption = 'Bin Code', Comment = 'Cód. Ubicación';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                    // sustituye este campo a item no. 
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        BinContent: Record "Bin Content";
                        BinContentList: page "Bin Contents List";
                    begin
                        BinContent.SetRange("Location Code", "Location Code");
                        BinContent.SetRange("Item No.", "Bin Code");
                        BinContent.SetRange("Bin Code", "Item No.");
                        BinContentList.SetTableView(BinContent);
                        BinContentList.RunModal();
                    end;
                }
                field("Lot No."; "Lot No.")
                {
                    Caption = 'Lot No.', Comment = 'Nº Lote';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                }
                field("Serial No."; "Serial No.")
                {
                    Caption = 'Serial No', Comment = 'Nº Serie';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                }
                field("Qty. to Handle (Base)"; "Qty. to Handle (Base)")
                {
                    Caption = 'Inventory', Comment = 'Inventario';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                }
                field(GrossRequirement; GrossRequirement)
                {
                    Caption = 'GrossRequirement', Comment = 'Necesidades brutas';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ShowItemAvailLineList(0);
                    end;
                }
                field(ScheduledRcpt; ScheduledRcpt)
                {
                    Caption = 'ScheduledRcpt', Comment = 'Recepción programada';
                    ApplicationArea = All;
                    StyleExpr = StyleExp;
                    Editable = false;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ShowItemAvailLineList(2);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Preview', Comment = 'Previsualizar';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    LoadItemInventory();
                end;
            }
        }

    }

    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        if not item.get("Bin Code") then
            Clear(Item);
        Item.SetRange("Location Filter", "Location Code");
        item.CalcFields(Inventory, "Qty. on Sales Order", item."Purchases (LCY)", "Qty. on Prod. Order", "Scheduled Need (Qty.)", "Scheduled Receipt (Qty.)");
        ScheduledRcpt := 0;
        GrossRequirement := 0;
        case Cubage of
            1:
                begin
                    DocumentNoIndent := 1;
                    Description := item.Description;
                end;
            2:
                begin
                    DocumentNoIndent := 2;
                    Description := item.Description;
                    item.SetRange("Date Filter", 0D, 29991231D);
                    ItemAvailFormsMgt.CalcAvailQuantities(Item, AmountType = AmountType::"Balance at Date",
                        GrossRequirement, PlannedOrderRcpt, ScheduledRcpt,
                        PlannedOrderReleases, ProjAvailableBalance, ExpectedInventory, QtyAvailable);
                    if not item.get("Bin Code") then
                        Clear(Item);
                end;
            else begin
                    DocumentNoIndent := 3;
                    Description := item.Description;
                end;
        end;
        StyleExpresion;
    end;

    var
        Item: Record Item;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ItemNoFilter: Code[20];
        ItemDescFilter: Text;
        ItemClientFilter: Text;
        ItemCategoryCode: code[20];
        CusTomerFilter: Code[20];
        DocumentNoIndent: Integer;
        StyleExp: Text;
        Description: Text;
        linea: Integer;
        GrossRequirement: Decimal;
        ScheduledRcpt: Decimal;
        PlannedOrderRcpt: Decimal;
        PlannedOrderReleases: Decimal;
        ProjAvailableBalance: Decimal;
        ExpectedInventory: Decimal;
        QtyAvailable: Decimal;
        AmountType: Option "Net Change","Balance at Date";
        Window: Dialog;
        HideItemInventory: Boolean;
        NotShowEmptyLocation: Boolean;
        LabelLocation: Label 'Location:', comment = 'Almacén:';
        LabelItemNo: Label 'Item No:', Comment = 'Cód. Producto:';
        LabelBinCode: Label 'Bin Code:', Comment = 'Cód. Ubicación.';

    LOCAL procedure ShowItemAvailLineList(What: Integer)
    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
    begin
        Item.SETRANGE("Location Filter", "Location Code");
        ItemAvailFormsMgt.ShowItemAvailLineList(Item, What);
    end;

    local procedure LoadItemInventory()
    var
        Location: record Location;
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        RecNo: Integer;
        TotalRecNo: Integer;
    begin
        Window.OPEN(LabelLocation + '#1#############\' + LabelItemNo + '#2#######################\' + LabelBinCode + '#3################\@4@@@@@@@@@@@@@@@@@@@@@\');
        Window.UPDATE(1, 0);
        DeleteAll();
        if not NotShowEmptyLocation then
            AddLocationItem('', RecNo, TotalRecNo);
        RecNo := 0;
        if location.FindSet() then
            repeat
                AddLocationItem(location.code, RecNo, TotalRecNo);
            until Location.Next() = 0;
        Window.Close();
        Reset();
        if FindSet() then;
    end;

    local procedure AddLocationItem(LocationNo: code[20]; var RecNo: integer; var TotalRecNo: Integer)
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        Item.SetRange("Location Filter", LocationNo);
        Item.SetRange(Type, item.Type::Inventory);
        if itemNoFilter <> '' then
            Item.SetFilter("No.", '%1', itemNoFilter);
        if HideItemInventory then
            item.SetFilter(Inventory, '<>%1', 0);
        TotalRecNo := Item.COUNT;
        if Item.FindSet() then
            repeat
                Window.Update(1, LocationNo);
                Window.Update(2, item."No.");
                Item.SetRange("Location Filter", LocationNo);
                Item.SetRange("Date Filter", 19010101D, 29991231D);
                ItemAvailFormsMgt.CalcAvailQuantities(Item, AmountType = AmountType::"Balance at Date",
                        GrossRequirement, PlannedOrderRcpt, ScheduledRcpt,
                        PlannedOrderReleases, ProjAvailableBalance, ExpectedInventory, QtyAvailable);
                item.CalcFields(Inventory);
                if (item.Inventory <> 0) or (ScheduledRcpt <> 0) or (GrossRequirement <> 0) then begin
                    RecNo := RecNo + 1;
                    IF CheckFilters(Item) then begin
                        ItemLedgerEntry.Reset;
                        ItemLedgerEntry.SetCurrentKey("Location Code", "Item No.");
                        ItemLedgerEntry.SetRange("Location Code", LocationNo);
                        ItemLedgerEntry.SetRange("Item No.", item."No.");
                        ItemLedgerEntry.SetRange(Open, true);
                        if ItemLedgerEntry.FindSet() then begin
                            repeat
                                Window.UPDATE(4, ROUND(RecNo / TotalRecNo * 10000, 1));

                                AddLocation(ItemLedgerEntry."Location Code");
                                AddLocationItem(ItemLedgerEntry."Location Code", ItemLedgerEntry."Item No.");
                                AddLocationItemBin(ItemLedgerEntry);
                            until ItemLedgerEntry.Next() = 0;
                        end else begin
                            RecNo := RecNo + 1;
                            Window.Update(1, LocationNo);
                            Window.Update(2, Item."No.");
                            Window.UPDATE(4, ROUND(RecNo / TotalRecNo * 10000, 1));

                            AddLocation(LocationNo);
                            AddLocationItem(LocationNo, Item."No.");
                        end;
                    end;
                end;
            until Item.Next() < 1;
    end;

    local procedure CheckFilters(Item: Record "Item"): Boolean;
    var
        tmpItem: Record item;
    begin
        tmpItem.SetRange("No.", item."No.");
        if tmpItem.FindSet() then begin
            if ItemCategoryCode <> '' then begin
                if CheckItemCategoryFilter(tmpItem."Item Category Code", ItemCategoryCode) then
                    exit(true);
            end else
                exit(true);
        end;
    end;

    local procedure AddLocation(Location: Code[10])
    begin
        Reset();
        SetRange("Location Code", Location);
        SetRange("Bin Code", '');
        SetRange(Cubage, 1);
        if not FindSet() then begin
            Init();
            "Location Code" := Location;
            "Bin Code" := '';
            Cubage := 1;
            Insert();
        end;
        Reset();
    end;

    local procedure AddLocationItem(LocationCode: Code[10]; ItemNo: Code[20])
    begin
        item.Reset();
        item.SetRange("No.", ItemNo);
        item.SetRange("Location Filter", LocationCode);
        item.FindSet();
        item.CalcFields(Inventory, "Qty. on Sales Order", item."Purchases (LCY)", "Qty. on Prod. Order");
        Reset();
        SetRange("Location Code", LocationCode);
        SetRange("Bin Code", ItemNo);
        SetRange(Cubage, 2);
        if not FindSet() then begin
            Init();
            "Location Code" := LocationCode;
            "Bin Code" := ItemNo;
            "Qty. to Handle (Base)" := item.Inventory;
            "Qty. Outstanding (Base)" := item."Qty. on Sales Order";
            Cubage := 2;
            Insert();
        end;
        Reset();
    end;

    local procedure AddLocationItemBin(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        BinContent: Record "Bin Content";
    begin
        item.get(ItemLedgerEntry."Item No.");
        if item."Item Tracking Code" = '' then begin
            BinContent.Reset();
            BinContent.SetRange("Location Code", ItemLedgerEntry."Location Code");
            BinContent.SetRange("Item No.", ItemLedgerEntry."Item No.");
            BinContent.SetRange("Lot No. Filter", ItemLedgerEntry."Lot No.");
            BinContent.SetRange("Serial No. Filter", ItemLedgerEntry."Serial No.");
            BinContent.SetFilter("Quantity (Base)", '>0');
            if BinContent.FindSet() then
                repeat
                    Window.Update(3, BinContent."Bin Code");
                    BinContent.CalcFields("Quantity (Base)");
                    Reset();
                    SetRange("Location Code", ItemLedgerEntry."Location Code");
                    SetRange("Bin Code", ItemLedgerEntry."Item No.");
                    SetRange("Item No.", BinContent."Bin Code");
                    SetRange(Cubage, 3);
                    if not FindSet() then begin
                        Init();
                        "Location Code" := ItemLedgerEntry."Location Code";
                        "Bin Code" := ItemLedgerEntry."Item No.";
                        "Item No." := BinContent."Bin Code";
                        "Qty. to Handle (Base)" := BinContent."Quantity (Base)";
                        Cubage := 3;
                        Insert();
                    end;
                until BinContent.Next() = 0;
            Reset();
        end else begin
            BinContent.Reset();
            BinContent.SetRange("Location Code", ItemLedgerEntry."Location Code");
            BinContent.SetRange("Item No.", ItemLedgerEntry."Item No.");
            BinContent.SetRange("Lot No. Filter", ItemLedgerEntry."Lot No.");
            BinContent.SetRange("Serial No. Filter", ItemLedgerEntry."Serial No.");
            BinContent.SetFilter("Quantity (Base)", '>0');
            if BinContent.FindSet() then
                repeat
                    Window.Update(3, BinContent."Bin Code");
                    BinContent.CalcFields("Quantity (Base)");
                    Reset();
                    SetRange("Location Code", ItemLedgerEntry."Location Code");
                    SetRange("Bin Code", ItemLedgerEntry."Item No.");
                    SetRange("Item No.", BinContent."Bin Code");
                    SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                    SetRange("Serial No.", ItemLedgerEntry."Serial No.");
                    SetRange(Cubage, 3);
                    if not FindSet() then begin
                        Init();
                        "Location Code" := ItemLedgerEntry."Location Code";
                        "Bin Code" := ItemLedgerEntry."Item No.";
                        "Item No." := BinContent."Bin Code";
                        "Lot No." := ItemLedgerEntry."Lot No.";
                        "Serial No." := ItemLedgerEntry."Serial No.";
                        "Qty. to Handle (Base)" := BinContent."Quantity (Base)";
                        Cubage := 3;
                        Insert();
                    end;

                until BinContent.Next() = 0;
            Reset();
        end;

    end;

    local procedure StyleExpresion()
    begin
        CASE Cubage OF
            1:
                StyleExp := 'Strong';
            2:
                StyleExp := 'StandardAccent';
            3:
                StyleExp := '';
            ELSE
                StyleExp := 'Subordinate';
        END;
    end;

    local procedure CheckItemCategoryFilter(ItemCategoryCode: Code[20]; ItemCategoryFilter: Code[20]): Boolean;
    var
        ItemCategory: Record "Item Category";
    begin
        // si es la misma categoria que filtramos
        if ItemCategoryCode = ItemCategoryFilter then
            exit(true);
        // si el parent es el mismo del filtro
        ItemCategory.SetRange(Code, ItemCategoryCode);
        ItemCategory.SetRange("Parent Category", ItemCategoryFilter);
        if ItemCategory.FindSet() then
            exit(true);
        // aqui ya buscamos si los padres tienen mas padres, (funcion recursiva)
        ItemCategory.SetRange("Parent Category");  // quitamos el filtro del padre para posicionar en esa categoria y comprobar el padre
        if ItemCategory.FindSet() then
            if ItemCategory."Parent Category" <> '' then
                if CheckItemCategoryFilter(ItemCategory."Parent Category", ItemCategoryFilter) then
                    exit(true);

    end;

}
