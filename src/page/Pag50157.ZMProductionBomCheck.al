page 50157 "ZM Production Bom Check"
{
    PageType = ListPart;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Item Tracing Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                Editable = false;

                Caption = 'Lines', comment = 'ESP="Líneas"';
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Production Bom No.', comment = 'ESP="Nº Lista materiales"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookupDownBom;
                    end;
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = all;
                    Caption = 'Description', comment = 'ESP="Descripción"';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = all;
                    Caption = 'Quantity per', comment = 'ESP="Cantidad por"';
                    DecimalPlaces = 5 : 5;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = all;
                    Caption = 'Unit of Measure Code', comment = 'ESP="Cód. Unidad medida"';
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = all;
                    Caption = 'Routing link code', comment = 'ESP="Cód. conexión ruta"';
                }
                field(Positive; Positive)
                {
                    ApplicationArea = all;
                    Caption = 'Blocked', comment = 'ESP="Bloqueado"';
                }
            }
        }
    }

    var
        Item: Record Item;
        ProductionBomHeader: Record "Production BOM Header";
        ProductionBomLine: Record "Production BOM Line";
        SelectionItemTracingBuffer: record "Item Tracing Buffer" temporary;

    procedure UpdateBom(ItemNo: code[20])
    var
        LineNo: Integer;
    begin
        Rec.Reset();
        Rec.DeleteAll();
        SelectionItemTracingBuffer.DeleteAll();
        ProductionBomLine.Reset();
        ProductionBomLine.SetRange(Type, ProductionBomLine.Type::Item);
        ProductionBomLine.SetRange("Version Code", '');
        if ItemNo <> '' then
            ProductionBomLine.SetRange("No.", ItemNo);
        if ProductionBomLine.FindFirst() then
            repeat
                ProductionBomHeader.Get(ProductionBomLine."Production BOM No.");
                Rec.Reset();
                Rec.SetRange("Item No.", ProductionBomLine."Production BOM No.");
                if not Rec.FindFirst() then begin
                    LineNo += 1;
                    Rec.Reset();
                    Rec.Init();
                    Rec."Line No." := LineNo;
                    Rec."Item No." := ProductionBomLine."Production BOM No.";
                    Rec."Item Description" := ProductionBomHeader.Description;
                    Rec.Quantity := ProductionBomLine."Quantity per";
                    Rec."Location Code" := ProductionBomLine."Unit of Measure Code";
                    Rec."Source No." := ProductionBomLine."Version Code";
                    Rec."Document No." := ProductionBomLine."No.";
                    Rec.Level := ProductionBomLine."Line No.";
                    Rec."Variant Code" := ProductionBomLine."Routing Link Code";
                    if Item.Get(Rec."Item No.") then
                        Rec.Positive := Item.Blocked;
                    Rec.Insert();
                    SelectionItemTracingBuffer.Init();
                    SelectionItemTracingBuffer.TransferFields(Rec);
                    SelectionItemTracingBuffer.Insert();
                end;

            Until ProductionBomLine.next() = 0;

        if Rec.FindFirst() then;
        // CurrPage.Update(false);
    end;

    local procedure LookupDownBom()
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOM: page "Production BOM";
    begin
        ProductionBOMHeader.Reset();
        ProductionBOMHeader.SetRange("No.", Rec."Item No.");
        ProductionBOM.SetTableView(ProductionBOMHeader);
        ProductionBOM.RunModal();
    end;

    procedure GetSelectionRecord(var ItemTracingBuffer: record "Item Tracing Buffer")
    begin
        CurrPage.SetSelectionFilter(SelectionItemTracingBuffer);
        if SelectionItemTracingBuffer.FindFirst() then
            repeat
                ItemTracingBuffer.Init();
                ItemTracingBuffer.TransferFields(SelectionItemTracingBuffer);
                ItemTracingBuffer.Insert();
            until SelectionItemTracingBuffer.Next() = 0;
    end;
}