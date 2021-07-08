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
                Caption = 'Calcular Coste Fabricación', comment = 'ESP="Calcular Coste Fabricación"';
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    UpdateMfgCoste;
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
        CalculateStandarCost.SetProperties(WORKDATE, FALSE, false, FALSE, '', FALSE);
        if StdaCostWhse.findset() then
            repeat
                Item.SetRange("No.", StdaCostWhse."No.");
                CalculateStandarCost.CalcItems(Item, NewtmpItem);



                Ventana.Update(1, 'Actualizando: ' + NewtmpItem."No.");
                StdaCostWhse.SetRange("Standard Cost Worksheet Name", Rec."Standard Cost Worksheet Name");
                StdaCostWhse.SetRange(Type, StdaCostWhse.Type::Item);
                StdaCostWhse.SetRange("No.", NewtmpItem."No.");
                if StdaCostWhse.FindFirst() then begin
                    StdaCostWhse."New Standard Cost" := Round(NewtmpItem."Standard Cost", 0.01);
                    StdaCostWhse.Modify();
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
}
