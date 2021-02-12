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
            field(CostProduction; CostProduction)
            {
                ApplicationArea = all;
                Caption = 'Ult. Coste producción', comment = 'ESP="Ult. Coste producción"';
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
        }
    }

    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Inventory: Decimal;
        CostProduction: Decimal;
        StyleExp: text;

    trigger OnAfterGetRecord()
    var
        Unitcost: Decimal;
    begin
        CostProduction := 0;
        Inventory := 0;
        case Type of
            type::Item:
                begin
                    Item.Get("No.");
                    item.CalcFields(Inventory);
                    Inventory := Item.Inventory;
                    case "Replenishment System" of
                        "Replenishment System"::"Prod. Order":
                            Begin
                                ItemLedgerEntry.SetRange("Item No.", "No.");
                                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
                                if ItemLedgerEntry.FindLast() then begin
                                    ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                                    ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
                                    ValueEntry.CalcSums("Invoiced Quantity", "Cost Amount (Actual)");
                                    if ValueEntry."Invoiced Quantity" <> 0 then
                                        CostProduction := ValueEntry."Cost Amount (Actual)" / ValueEntry."Invoiced Quantity";
                                    Unitcost := CostProduction;
                                end;
                            End;
                        else
                            Unitcost := Rec.LastUnitCost;
                    end;
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
}
