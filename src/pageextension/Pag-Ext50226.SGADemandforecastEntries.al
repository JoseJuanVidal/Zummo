pageextension 50226 "SGA Demand forecast Entries" extends "Demand Forecast Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing)
        {
            action(ExplodeItem)
            {
                ApplicationArea = all;
                Caption = 'Explode Item', comment = 'ESP="Desglosar Artículo"';
                Image = ExplodeBOM;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                begin
                    Action_ExplodeItem();
                end;
            }
        }
    }

    var
        Item: Record Item;
        ProdBOMLine: Record "Production BOM Line";
        BOMComponent: Record "BOM Component";
        ProdForecastEntry: Record "Production Forecast Entry";
        ProdForecastEntry2: Record "Production Forecast Entry";
        lblConfirmExplode: Label '¿Do you want to break down the selected items %1?', comment = 'ESP="¿Desea desglosar los artículos seleccionados %1?"';

    local procedure Action_ExplodeItem()
    var
        EntryNo: Integer;
    begin
        ProdForecastEntry.Reset();
        CurrPage.SetSelectionFilter(ProdForecastEntry);
        if not Confirm(lblConfirmExplode, false, ProdForecastEntry.Count()) then
            exit;
        EntryNo := GetLastEntryNo();
        if ProdForecastEntry.FindFirst() then
            repeat
                EntryNo += 1;
                ExplodeBomItem(EntryNo);

            Until ProdForecastEntry.next() = 0;
    end;

    local procedure ExplodeBomItem(var EntryNo: Integer)
    var
        myInt: Integer;
    begin
        Item.Get(ProdForecastEntry."Item No.");
        case Item."Replenishment System" of
            Item."Replenishment System"::Assembly:
                begin
                    BOMComponent.Reset();
                    BOMComponent.SetRange("Parent Item No.", Item."No.");
                    BOMComponent.SetRange(Type, BOMComponent.Type::Item);
                    if BOMComponent.FindFirst() then
                        repeat
                            AddLastProdForecastEntry(BOMComponent."No.", EntryNo, BOMComponent."Quantity per" * ProdForecastEntry."Forecast Quantity (Base)");
                            EntryNo += 1;
                        Until BOMComponent.next() = 0;
                end;
            Item."Replenishment System"::"Prod. Order":
                begin
                    ProdBOMLine.Reset();
                    ProdBOMLine.SetRange("Production BOM No.", Item."Production BOM No.");
                    ProdBOMLine.SetRange(Type, ProdBOMLine.Type::Item);
                    if ProdBOMLine.FindFirst() then
                        repeat
                            AddLastProdForecastEntry(ProdBOMLine."No.", EntryNo, ProdBOMLine."Quantity per" * ProdForecastEntry."Forecast Quantity (Base)");
                            EntryNo += 1;
                        Until ProdBOMLine.next() = 0;
                end;
        end;
    end;

    local procedure AddLastProdForecastEntry(ItemNo: Code[20]; EntryNo: Integer; Quantity: Decimal)
    begin
        ProdForecastEntry2.Reset();
        ProdForecastEntry2.SetRange("Production Forecast Name", Rec."Production Forecast Name");
        ProdForecastEntry2.SetRange("Item No.", ItemNo);
        if not ProdForecastEntry2.FindFirst() then begin

            ProdForecastEntry2.Init();
            ProdForecastEntry2."Production Forecast Name" := Rec."Production Forecast Name";
            ProdForecastEntry2."Entry No." := EntryNo;
            ProdForecastEntry2.Validate("Item No.", ItemNo);
            ProdForecastEntry2."Component Forecast" := true;
            ProdForecastEntry2."Forecast Date" := ProdForecastEntry."Forecast Date";
            ProdForecastEntry2."Unit of Measure Code" := ProdForecastEntry."Unit of Measure Code";
            ProdForecastEntry2."Location Code" := ProdForecastEntry."Location Code";
            ProdForecastEntry2.Insert();
        end;
        ProdForecastEntry2.Validate("Forecast Quantity (Base)", ProdForecastEntry2."Forecast Quantity (Base)" + Quantity);
        ProdForecastEntry2.Modify();
    end;

    local procedure GetLastEntryNo(): Integer
    begin
        ProdForecastEntry2.Reset();
        ProdForecastEntry2.SetRange("Production Forecast Name", Rec."Production Forecast Name");
        if ProdForecastEntry2.FindLast() then
            exit(ProdForecastEntry2."Entry No.")
        else
            exit(0); // Return 0 if no entries found
    end;
}