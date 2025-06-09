pageextension 50217 "ZM Serial No. Information Card" extends "Serial No. Information Card"
{
    layout
    {
        addafter("Expired Inventory")
        {
            field("Serial No. Cost"; "Serial No. Cost")
            {
                ApplicationArea = all;
            }
            field("Last Date Update Cost"; "Last Date Update Cost")
            {
                ApplicationArea = all;
            }
            field("Update Cost"; "Update Cost")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("Update Cost Production Output")
            {
                ApplicationArea = all;
                Caption = 'Update Cost Production Output', Comment = 'ESP="Actualizar Coste Producción Salida"';
                Image = UpdateUnitCost;
                trigger OnAction()
                begin
                    UpdateCostProductionOutput();
                end;
            }
        }
    }

    local procedure UpdateCostProductionOutput()
    begin
        UpdateItemLedgerEntry();
    end;
}