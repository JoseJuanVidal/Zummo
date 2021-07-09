pageextension 50056 "STHPagStandardCostWorksheetExt" extends "Standard Cost Worksheet"
{
    layout
    {
        modify("New Standard Cost")
        {
            StyleExpr = StyleExp;
        }
        addlast(Control1)
        {
            field(LastUnitCost; LastUnitCost)
            {
                ApplicationArea = all;
                StyleExpr = StyleExp;
                Editable = false;
            }
            field(Inventory; Inventory)
            {
                Caption = 'Inventario', comment = 'ESP="Inventario"';
                ApplicationArea = all;
                Editable = false;
            }

        }
    }
    actions
    {
        addafter("&Implement Standard Cost Changes")
        {
            action(ActualizarUltimoCoste)
            {
                ApplicationArea = all;
                Caption = 'Actualizar ultimo coste', comment = 'ESP="Actualizar ultimo coste"';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    UpdateLastUnitCost;
                end;

            }
            action(CalcularMfgCost)
            {
                ApplicationArea = all;
                Caption = 'Calcular Coste estandar Fabricación', comment = 'ESP="Calcular Coste estandar Fabricación"';
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    UpdateMfgCoste;
                end;
            }
            action(LoadWhereUsedLine)
            {
                ApplicationArea = all;
                Caption = 'Añadir productos puntos de Uso', comment = 'ESP="Añadir productos puntos de Uso"';
                Image = "Where-Used";

                trigger OnAction()
                begin
                    LoadWhereUsedLine(Rec."No.");
                end;
            }
        }
    }

    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Inventory: Decimal;

        StyleExp: text;

    trigger OnAfterGetRecord()
    var
        Unitcost: Decimal;
    begin

        Inventory := 0;
        case Type of
            type::Item:
                begin
                    Item.Get("No.");
                    item.CalcFields(Inventory);
                    Inventory := Item.Inventory;
                end;
        end;

        case Round(Unitcost, 0.01) <> Round(Rec."New Standard Cost", 0.01) of
            true:
                StyleExp := 'UnFavorable';
            else
                StyleExp := '';
        end;
    end;

    local procedure UpdateLastUnitCost()
    var
        Text000:
            Label '¿Desea actualizar como coste estandar el valor de Ulltimo coste de las líneas seleccionadas?', comment = 'ESP="¿Desea actualizar como coste estandar el valor de Ulltimo coste de las líneas seleccionadas?"';
        StandardCostWorksheet:
                Record "Standard Cost Worksheet";
    begin
        if Confirm(text000) then begin
            CurrPage.SetSelectionFilter(StandardCostWorksheet);
            if StandardCostWorksheet.findset() then
                repeat
                    StandardCostWorksheet.CalcFields(LastUnitCost);
                    StandardCostWorksheet."New Standard Cost" := StandardCostWorksheet.LastUnitCost;
                    StandardCostWorksheet.Modify();
                Until StandardCostWorksheet.next() = 0;
            CurrPage.Update();
        end;
    end;

    local procedure UpdateMfgCoste()
    var
        StdaCostWhse: Record "Standard Cost Worksheet";
        StdaCostWhse2: Record "Standard Cost Worksheet";
        Item: Record item;
        tmpItem2: Record item temporary;
        NewtmpItem: Record item temporary;
        CalculateStandarCost: Codeunit "Calculate Standard Cost";
        lblConfirm: Label '¿Desea realizar el cálculo de coste estandar de los registros seleccionados?'
            , comment = 'ESP="¿Desea realizar el cálculo de coste estandar de los registros seleccionados?"';
        Text000: Label '#1#############################################';
        Ventana: Dialog;
    begin
        if not Confirm(lblConfirm) then
            exit;
        Ventana.open(Text000);

        CurrPage.SetSelectionFilter(StdaCostWhse);
        //Ventana.Update(1, 'Cargando....');
        //LoadtmpItem(tmpItem);
        Ventana.Update(1, 'Calculando....');
        if StdaCostWhse.findset() then
            repeat
                item.Reset();
                Item.SetRange("No.", StdaCostWhse."No.");
                item.FindFirst();
                clear(CalculateStandarCost);
                CalculateStandarCost.SetProperties(WORKDATE, FALSE, false, FALSE, '', FALSE);
                CalculateStandarCost.CalcItems(Item, NewtmpItem);

                Ventana.Update(1, 'Actualizando: ' + NewtmpItem."No.");
                StdaCostWhse2.SetRange("Standard Cost Worksheet Name", Rec."Standard Cost Worksheet Name");
                StdaCostWhse2.SetRange(Type, StdaCostWhse.Type::Item);
                StdaCostWhse2.SetRange("No.", NewtmpItem."No.");
                if StdaCostWhse2.FindFirst() then begin
                    StdaCostWhse2."New Standard Cost" := Round(NewtmpItem."Standard Cost", 0.0001);
                    StdaCostWhse2.Modify();
                end;
            Until StdaCostWhse.next() = 0;

        Commit();
        CurrPage.Update();
    end;

    local procedure LoadtmpItem(var tmpItem: Record Item)
    var
        StdaCostWhse: Record "Standard Cost Worksheet";
    begin
        CurrPage.SetSelectionFilter(StdaCostWhse);
        if StdaCostWhse.findset() then
            repeat
                if StdaCostWhse.Type in [StdaCostWhse.Type::Item] then
                    if not tmpItem.get(StdaCostWhse."No.") then begin
                        tmpItem.Init();
                        tmpItem."No." := StdaCostWhse."No.";
                        tmpItem.Insert();
                    end;
            Until StdaCostWhse.next() = 0;
    end;

    local procedure LoadWhereUsedLine(ItemNo: code[20])
    var
        Item: Record Item;
        StdCostWhse: Record "Standard Cost Worksheet";
        WhereUsedLine: Record "Where-Used Line" temporary;
        WhereUsedMgt: Codeunit "Where-Used Management";
        Instruction: Text;
        NewCalcMultiLevel: Boolean;
        Text001: Label '&Nivel superior,&Todos los niveles', comment = 'ESP="&Nivel superior,&Todos los niveles"';
        lblInstr: Label 'Añadir la L.M. del producto %1 %2. Seleccione Todos los niveles para incluir L.M. de todos los semiterminados.'
            , comment = 'ESP="Añadir la L.M. del producto %1 %2. Seleccione Todos los niveles para incluir L.M. de todos los semiterminados."';
    begin
        item.Get(ItemNo);
        Instruction := StrSubstNo(lblInstr, Item."No.", Item.Description);
        CASE STRMENU(Text001, 1, Instruction) OF
            0:
                EXIT;
            1:
                NewCalcMultiLevel := FALSE;
            2:
                NewCalcMultiLevel := TRUE;
        END;
        // indicamos el producto al que mirar la lista        
        WhereUsedMgt.WhereUsedFromItem(Item, WorkDate(), NewCalcMultiLevel);
        if WhereUsedMgt.FindRecord('-', WhereUsedLine) then
            repeat
                StdCostWhse.Init();
                StdCostWhse."Standard Cost Worksheet Name" := Rec."Standard Cost Worksheet Name";
                StdCostWhse.Type := StdCostWhse.Type::Item;
                StdCostWhse.Validate("No.", WhereUsedLine."Item No.");
                StdCostWhse.Insert()
            until WhereUsedMgt.NextRecord(1, WhereUsedLine) = 0;

    end;
}
