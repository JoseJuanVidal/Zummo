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
        StyleExp: text;

    trigger OnAfterGetRecord()
    begin
        case Rec.LastUnitCost <> Rec."New Standard Cost" of
            true:
                StyleExp := 'UnFavorable';
            else
                StyleExp := '';
        end;
    end;

    local procedure UpdateLastUnitCost()
    var
        Text000: Label '¿Desea actualizar como coste estandar el valor de Ulltimo coste de las líneas seleccionadas?', comment = 'ESP="¿Desea actualizar como coste estandar el valor de Ulltimo coste de las líneas seleccionadas?"';
        StandardCostWorksheet: Record "Standard Cost Worksheet";
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
