pageextension 50226 "SGA Demand forecast Entries" extends "Demand Forecast Entries"
{
    layout
    {
        modify("Entry No.")
        {
            Visible = true;
        }
        addbefore("Entry No.")
        {
            field("Lead Time Calculation"; "Lead Time Calculation")
            {
                ApplicationArea = all;
            }
        }
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
            action(ImportExcel)
            {
                ApplicationArea = all;
                Caption = 'Import Excel', comment = 'ESP="Importar Excel"';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                begin
                    ImportExcel();
                end;
            }
        }
    }

    var
        Item: Record Item;
        ProdBOMLine: Record "Production BOM Line";
        BOMComponent: Record "BOM Component";
        ProdForecastEntry2: Record "Production Forecast Entry";
        tmpProdForecastEntry: Record "Production Forecast Entry" temporary;
        lblConfirmExplode: Label '¿Do you want to break down the selected items %1?\First Date: %2', comment = 'ESP="¿Desea desglosar los artículos seleccionados %1?\Fecha inicial %2"';
        lblWindow: Label 'Setp: #1##########\Item No.: #2####################################', comment = 'ESP="Pasp: #1#####\Cód. Producto: #2####################################"';

    local procedure Action_ExplodeItem()
    var
        ProdForecastEntry: Record "Production Forecast Entry";
        FirstDate: date;
        EntryNo: Integer;
        Window: Dialog;
    begin
        Window.Open(lblWindow);
        ProdForecastEntry.Reset();
        CurrPage.SetSelectionFilter(ProdForecastEntry);
        ProdForecastEntry.SetCurrentKey("Forecast Date");
        if ProdForecastEntry.FindFirst() then
            FirstDate := ProdForecastEntry."Forecast Date";
        if not Confirm(lblConfirmExplode, false, ProdForecastEntry.Count(), FirstDate) then
            exit;
        EntryNo := GetLastEntryNo(Rec."Production Forecast Name");
        tmpProdForecastEntry.DeleteAll();
        if ProdForecastEntry.FindFirst() then
            repeat
                Window.Update(1, 1);
                tmpProdForecastEntry := ProdForecastEntry;
                tmpProdForecastEntry.Insert();
            until ProdForecastEntry.next() = 0;
        if tmpProdForecastEntry.FindFirst() then
            repeat
                Window.Update(1, 2);
                Window.Update(2, tmpProdForecastEntry."Item No.");
                EntryNo += 1;
                ExplodeBomItem(tmpProdForecastEntry."Item No.", EntryNo, FirstDate, tmpProdForecastEntry."Forecast Quantity");
            Until tmpProdForecastEntry.next() = 0;
        Window.Close();
    end;

    local procedure ExplodeBomItem(ItemNo: code[20]; var EntryNo: Integer; FirstDate: date; Quantity: Decimal)
    var
        ItemDate: Date;
    begin
        Item.Get(ItemNo);

        case Item."Replenishment System" of
            Item."Replenishment System"::Assembly:
                begin
                    BOMComponent.Reset();
                    BOMComponent.SetRange("Parent Item No.", Item."No.");
                    BOMComponent.SetRange(Type, BOMComponent.Type::Item);
                    if BOMComponent.FindFirst() then
                        repeat
                            Item.Get(BOMComponent."No.");
                            // comprobamos si el plazo de entrega del producto es menor que la fecha de necesidad        
                            ItemDate := CalcDate(Item."Lead Time Calculation", FirstDate);
                            ItemDate := CalcDate('+15D', ItemDate);
                            if tmpProdForecastEntry."Forecast Date" >= ItemDate then begin
                                AddLastProdForecastEntry(BOMComponent."No.", FirstDate, EntryNo, BOMComponent."Quantity per" * Quantity);
                                EntryNo += 1;
                                ExplodeBomItem(BOMComponent."No.", EntryNo, FirstDate, BOMComponent."Quantity per" * Quantity);
                            end;
                        Until BOMComponent.next() = 0;
                end;
            Item."Replenishment System"::"Prod. Order":
                begin
                    ProdBOMLine.Reset();
                    ProdBOMLine.SetRange("Production BOM No.", Item."Production BOM No.");
                    ProdBOMLine.SetRange(Type, ProdBOMLine.Type::Item);
                    if ProdBOMLine.FindFirst() then
                        repeat
                            Item.Get(ProdBOMLine."No.");
                            // comprobamos si el plazo de entrega del producto es menor que la fecha de necesidad        
                            ItemDate := CalcDate(Item."Lead Time Calculation", FirstDate);
                            ItemDate := CalcDate('+15D', ItemDate);
                            if tmpProdForecastEntry."Forecast Date" >= ItemDate then begin
                                AddLastProdForecastEntry(ProdBOMLine."No.", FirstDate, EntryNo, ProdBOMLine."Quantity per" * Quantity);
                                EntryNo += 1;
                                ExplodeBomItem(ProdBOMLine."No.", EntryNo, FirstDate, ProdBOMLine."Quantity per" * Quantity);
                            end;
                        Until ProdBOMLine.next() = 0;
                end;
        end;
    end;

    local procedure AddLastProdForecastEntry(ItemNo: Code[20]; FirstDate: date; EntryNo: Integer; Quantity: Decimal)
    begin
        ProdForecastEntry2.Reset();
        ProdForecastEntry2.SetRange("Production Forecast Name", Rec."Production Forecast Name");
        ProdForecastEntry2.SetRange("Item No.", ItemNo);
        ProdForecastEntry2.SetRange("Forecast Date", tmpProdForecastEntry."Forecast Date");
        if not ProdForecastEntry2.FindFirst() then begin
            Item.Get(ItemNo);

            ProdForecastEntry2.Init();
            ProdForecastEntry2."Production Forecast Name" := Rec."Production Forecast Name";
            ProdForecastEntry2."Entry No." := EntryNo;
            ProdForecastEntry2.Validate("Item No.", ItemNo);
            ProdForecastEntry2."Component Forecast" := true;
            ProdForecastEntry2."Forecast Date" := tmpProdForecastEntry."Forecast Date";
            ProdForecastEntry2."Unit of Measure Code" := Item."Base Unit of Measure";
            ProdForecastEntry2."Location Code" := tmpProdForecastEntry."Location Code";
            ProdForecastEntry2.Insert();
        end;
        ProdForecastEntry2.Validate("Forecast Quantity (Base)", tmpProdForecastEntry."Forecast Quantity (Base)" + Quantity);
        ProdForecastEntry2.Modify();
    end;

    local procedure GetLastEntryNo(ProdForecastName: code[20]): Integer
    begin
        ProdForecastEntry2.Reset();
        // ProdForecastEntry2.SetRange("Production Forecast Name", ProdForecastName);
        if ProdForecastEntry2.FindLast() then
            exit(ProdForecastEntry2."Entry No.")
        else
            exit(0); // Return 0 if no entries found
    end;

    local procedure ImportExcel()
    var
        Item: Record Item;
        ExcelBuffer: Record "Excel Buffer" temporary;
        FileManagement: Codeunit "File Management";
        IStream: InStream;
        ServerFileName: Text;
        SheetName: text;
        Rows: Integer;
        i: Integer;
        EntryNo: Integer;
        Celda: Text;
        ItemNo: code[20];
        ForecastDate: Date;
        Quantity: Decimal;
        ProdForecastName: code[20];
        lblError: Label 'Page must be filtered %1', comment = 'ESP="La pagina debe estar filtrada %1"';
        lblConfirmDelete: Label 'The %1 has data, ¿do you want to delete this data?', comment = 'ESP="La %1 tiene datos. ¿Desea eliminar estos?"';
    begin
        if Rec.GetFilter("Production Forecast Name") = '' then
            Error(lblError, Rec.FieldName("Production Forecast Name"));
        ProdForecastName := Rec.GetFilter("Production Forecast Name");
        ProdForecastEntry2.Reset();
        ProdForecastEntry2.SetRange("Production Forecast Name", Rec.GetFilter("Production Forecast Name"));
        if ProdForecastEntry2.FindFirst() then
            if Confirm(lblConfirmDelete, false, Rec.TableCaption) then
                Rec.DeleteAll();
        EntryNo := GetLastEntryNo(ProdForecastEntry2."Production Forecast Name");

        ExcelBuffer.DELETEALL;
        UploadIntoStream('Excel', '', '', ServerFileName, IStream);
        SheetName := ExcelBuffer.SelectSheetsNameStream(IStream);
        ExcelBuffer.OpenBookStream(IStream, SheetName);
        ExcelBuffer.ReadSheet;
        ExcelBuffer.SETRANGE("Column No.", 2);
        Rows := ExcelBuffer.COUNT;
        ExcelBuffer.SETRANGE("Row No.", 2);
        ExcelBuffer.SETRANGE("Column No.", 3);
        if ExcelBuffer.FINDFIRST then begin
            if ExcelBuffer."Cell Type" in [ExcelBuffer."Cell Type"::Date] then begin
                Celda := ExcelBuffer."Cell Value as Text";
                Evaluate(ForecastDate, Celda);
                for i := 2 to Rows do begin
                    ExcelBuffer.SETRANGE("Row No.", i);
                    ExcelBuffer.SETRANGE("Column No.", 2);
                    if ExcelBuffer.FINDFIRST then begin
                        ItemNo := copystr(ExcelBuffer."Cell Value as Text", 1, MaxStrLen(ItemNo));
                        if Item.Get(ItemNo) then begin
                            if GetCellQuantity(ExcelBuffer, Quantity, 3) then begin // primer MES
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, ForecastDate, Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 4) then begin // MES 2
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+1M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 5) then begin // MES 3
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+2M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 6) then begin // MES 4
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+3M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 7) then begin // MES 5
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+4M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 8) then begin // MES 6
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+5M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 9) then begin // MES 7
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+6M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 10) then begin // MES 8
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+7M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 11) then begin // MES 9
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+8M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 12) then begin // MES 10
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+9M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 13) then begin // MES 11
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+10M', ForecastDate), Quantity)
                            end;
                            if GetCellQuantity(ExcelBuffer, Quantity, 14) then begin // MES 12
                                EntryNo += 1;
                                AddProdForecastEntry(ItemNo, ProdForecastName, EntryNo, calcdate('+11M', ForecastDate), Quantity)
                            end;
                        end
                    end;
                end;
            end;
        end;
    end;

    local procedure GetCellQuantity(var ExcelBuffer: Record "Excel Buffer"; var Quantity: Decimal; ColumnNo: Integer): Boolean
    var
        myInt: Integer;
    begin
        ExcelBuffer.SETRANGE("Column No.", ColumnNo);
        if ExcelBuffer.FINDFIRST then begin
            if Evaluate(Quantity, ExcelBuffer."Cell Value as Text") then
                if Quantity <> 0 then
                    exit(true);
        end;
    end;

    local procedure AddProdForecastEntry(ItemNo: Code[20]; ProdForecastName: code[20]; EntryNo: Integer; ForecastDate: date; Quantity: Decimal)
    begin
        Item.Get(ItemNo);
        ProdForecastEntry2.Init();
        ProdForecastEntry2."Production Forecast Name" := ProdForecastName;
        ProdForecastEntry2."Entry No." := EntryNo;
        ProdForecastEntry2.Validate("Item No.", ItemNo);
        ProdForecastEntry2."Component Forecast" := true;
        ProdForecastEntry2."Forecast Date" := ForecastDate;
        ProdForecastEntry2."Unit of Measure Code" := Item."Base Unit of Measure";
        ProdForecastEntry2."Location Code" := 'MMPP';
        ProdForecastEntry2.Validate("Forecast Quantity (Base)", Quantity);
        ProdForecastEntry2.Insert();
    end;
}