page 50101 "Analisis Plan Renove"
{
    Caption = 'Análisis Plan Renove', comment = 'ESP="Análisis Plan Renove"';
    PageType = Worksheet;
    UsageCategory = None;
    SourceTable = "Item Tracing Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowAsTree = true;
                IndentationColumn = Rec.level;
                field(Level; Level)
                {
                    ApplicationArea = all;
                    Visible = false;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field(LineNo; LineNo)
                {
                    ApplicationArea = all;
                    Caption = 'Line No.', comment = 'ESP="Nº Línea"';
                    Visible = false;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Source Name"; "Source Name")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Created by"; "Created by")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Created on"; "Created on")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Already Traced"; "Already Traced")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Item Ledger Entry No."; "Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Parent Item Ledger Entry No."; "Parent Item Ledger Entry No.")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Country Region/Code"; "Country Region/Code")
                {
                    ApplicationArea = all;
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("Country/Region Name"; "Country/Region Name")
                {
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }
                field("EU Country/Region Code"; "EU Country/Region Code")
                {
                    Style = Favorable;
                    StyleExpr = ApplyStyleExpr;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(TraceItemPlanRenove)
            {
                ApplicationArea = All;
                Caption = 'Seguimiento productos', comment = 'ESP="Seguimiento productos"';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TraceItemsPlanRenove();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ApplyStyleExpr := Rec.Positive;
    end;

    var
        LineNo: Integer;
        ApplyStyleExpr: Boolean;

    local procedure TraceItemsPlanRenove()
    var
        ItemRenove: Record Item;
        Window: Dialog;
        lblConfirm: Label '¿Desea realizar el seguimientos de %1 productos con Plan Renove?', comment = 'ESP="¿Desea realizar el seguimientos de %1 productos con Plan Renove?"';
        lblDialog: Label 'Item No.: #1#################\Entry No.: #2##############', comment = 'ESP="Cód. producto: #1#################\Nº Mov.: #2##############"';
    begin
        ItemRenove.Reset();
        ItemRenove.SetRange("Renovate Plan", true);
        if not Confirm(lblConfirm, true, ItemRenove.Count) then
            exit;
        Window.Open(lblDialog);
        Rec.DeleteAll();
        CurrPage.Update();
        LineNo := 0;
        if ItemRenove.FindFirst() then
            repeat
                Window.Update(1, ItemRenove."No.");
                TraceItemFindSerial(ItemRenove, Window);
            Until ItemRenove.next() = 0;
        Window.Close();
        CurrPage.Update();
    end;

    local procedure TraceItemFindSerial(Item: Record Item; var Window: Dialog)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LevelNo: Integer;
    begin
        ItemLedgerEntry.SetRange("Item No.", Item."No.");
        ItemLedgerEntry.SetRange(Positive, true);

        if ItemLedgerEntry.FindFirst() then
            repeat
                Window.Update(1, ItemLedgerEntry."Item No.");
                Window.Update(2, ItemLedgerEntry."Entry No.");
                case ItemLedgerEntry."Entry Type" of
                    ItemLedgerEntry."Entry Type"::Output, ItemLedgerEntry."Entry Type"::Purchase, ItemLedgerEntry."Entry Type"::Sale,
                    ItemLedgerEntry."Entry Type"::" ", ItemLedgerEntry."Entry Type"::"Positive Adjmt.":
                        begin
                            AddPageRecord(Rec, ItemLedgerEntry, true, LevelNo);
                            if not ItemLedgerEntry.Open then
                                ApplyItemLedger(Rec, ItemLedgerEntry, LevelNo + 1);
                        end;

                end;
            Until ItemLedgerEntry.next() = 0;
    end;

    procedure AddPageRecord(Var ItemTrackingBuffer: Record "Item Tracing Buffer"; ItemLedgEntry: Record "Item Ledger Entry"; Initial: Boolean; LevelNo: Integer)
    var
        CountryRegion: Record "Country/Region";
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        LineNo += 1;
        ItemTrackingBuffer.Init();
        ItemTrackingBuffer."Line No." := LineNo;
        ItemTrackingBuffer.Level := LevelNo;
        ItemTrackingBuffer.SetDescription := STRSUBSTNO('%1 %2', ItemLedgEntry."Entry Type", "Document No.");
        ItemTrackingBuffer."Item No." := ItemLedgEntry."Item No.";
        ItemTrackingBuffer."Serial No." := ItemLedgEntry."Serial No.";
        ItemTrackingBuffer."Lot No." := ItemLedgEntry."Lot No.";
        ItemTrackingBuffer."Item Ledger Entry No." := ItemLedgEntry."Entry No.";
        ItemTrackingBuffer."Entry Type" := ItemLedgEntry."Entry Type";
        ItemTrackingBuffer."Source Type" := ItemLedgEntry."Source Type";
        ItemTrackingBuffer."Source No." := ItemLedgEntry."Source No.";
        ItemTrackingBuffer."Item Description" := GetItemDescription(ItemLedgEntry."Item No.");
        ItemTrackingBuffer."Document No." := ItemLedgEntry."Document No.";
        ItemTrackingBuffer."Posting Date" := ItemLedgEntry."Posting Date";
        ItemTrackingBuffer."Source Type" := ItemLedgEntry."Source Type";
        ItemTrackingBuffer."Source No." := ItemLedgEntry."Source No.";
        case ItemLedgEntry."Source Type" of
            ItemLedgEntry."Source Type"::Customer:
                begin
                    if Customer.get(ItemLedgEntry."Source No.") then
                        ItemTrackingBuffer."Source Name" := Customer.Name;
                end;
            ItemLedgEntry."Source Type"::Vendor:
                begin
                    if Vendor.get(ItemLedgEntry."Source No.") then
                        ItemTrackingBuffer."Source Name" := Vendor.Name;
                end;
        end;
        ItemTrackingBuffer."Location Code" := ItemLedgEntry."Location Code";
        ItemTrackingBuffer.Quantity := ItemLedgEntry.Quantity;
        ItemTrackingBuffer."Remaining Quantity" := ItemLedgEntry."Remaining Quantity";
        ItemTrackingBuffer.Positive := Initial;
        ItemTrackingBuffer."Parent Item Ledger Entry No." := ItemLedgEntry."Entry No.";
        ItemTrackingBuffer."Country Region/Code" := ItemLedgEntry."Country/Region Code";
        if not CountryRegion.Get(ItemLedgEntry."Country/Region Code") then
            Clear(CountryRegion);
        ItemTrackingBuffer.Insert();
    end;

    LOCAL procedure GetItemDescription(ItemNo: Code[20]): Text[100]
    var
        Item: Record Item;
    begin
        IF ItemNo <> Item."No." THEN
            IF NOT Item.GET(ItemNo) THEN
                CLEAR(Item);
        EXIT(Item.Description);
    End;

    local procedure ApplyItemLedger(Var ItemTrackingBuffer: Record "Item Tracing Buffer"; LiqLdgEntry: Record "Item Ledger Entry"; LevelNo: Integer)
    var
        ItemLdgEntry: Record "Item Ledger Entry";
        ItemApplicationEntry: Record "Item Application Entry";
        ItemApply: Record "Item Application Entry";
    begin
        if LiqLdgEntry.Open then begin
            ItemTrackingBuffer."Location Code" := LiqLdgEntry."Location Code";
            ItemTrackingBuffer."Remaining Quantity" := LiqLdgEntry."Remaining Quantity";
            ItemTrackingBuffer.Modify();
            exit;
        end;
        ItemApplicationEntry.RESET;
        ItemApplicationEntry.SETRANGE("Inbound Item Entry No.", LiqLdgEntry."Entry No.");
        ItemApplicationEntry.SETFILTER("Outbound Item Entry No.", '<>0');
        ItemApplicationEntry.SETFILTER(Quantity, '<0');
        if ItemApplicationEntry.FINDFIRST then
            repeat
                ItemLdgEntry.GET(ItemApplicationEntry."Outbound Item Entry No.");

                case ItemLdgEntry."Entry Type" of
                    ItemLdgEntry."Entry Type"::Transfer:
                        begin
                            ItemApply.RESET;
                            ItemApply.SETRANGE("Outbound Item Entry No.", ItemApplicationEntry."Outbound Item Entry No.");
                            ItemApply.SETFILTER(Quantity, '>0');
                            if ItemApply.FINDFIRST then
                                repeat
                                    ItemLdgEntry.GET(ItemApply."Inbound Item Entry No.");
                                    ApplyItemLedger(ItemTrackingBuffer, ItemLdgEntry, LevelNo);
                                until ItemApply.NEXT = 0;
                        end;
                    ItemLdgEntry."Entry Type"::Consumption:
                        begin
                            ApplyItemLedgerConsumption(ItemTrackingBuffer, ItemLdgEntry, LevelNo + 1);
                        end;
                    else begin
                        AddPageRecord(ItemTrackingBuffer, ItemLdgEntry, false, LevelNo);

                        ApplyItemLedger(ItemTrackingBuffer, ItemLdgEntry, LevelNo + 1);
                    end;
                END;
            until ItemApplicationEntry.Next() = 0;
    end;

    local procedure ApplyItemLedgerConsumption(Var ItemTrackingBuffer: Record "Item Tracing Buffer"; LiqLdgEntry: Record "Item Ledger Entry"; LevelNo: Integer)
    var
        ItemLdgEntry: Record "Item Ledger Entry";
    begin
        // buscamos la salida de fabrica de esa linea de orden de producción, para ver la maquina creada
        ItemLdgEntry.Reset();
        ItemLdgEntry.SetRange("Entry Type", ItemLdgEntry."Entry Type"::Output);
        ItemLdgEntry.SetRange("Order No.", LiqLdgEntry."Order No.");
        ItemLdgEntry.SetRange("Order Line No.", LiqLdgEntry."Order Line No.");
        if ItemLdgEntry.FindFirst() then begin
            // añadimos esa linea con un level mas
            AddPageRecord(ItemTrackingBuffer, ItemLdgEntry, false, LevelNo + 1);

            ApplyItemLedger(ItemTrackingBuffer, ItemLdgEntry, LevelNo + 2);
        end;

    end;
}