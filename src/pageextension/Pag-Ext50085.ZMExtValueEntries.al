pageextension 50085 "ZM Ext Value Entries" extends "Value Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Prod. Order State"; "Prod. Order State")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(Update)
            {
                Caption = 'Update Costs', comment = 'ESP="Actualizar costes"';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    ValueEntry: Record "Value Entry";
                    FuncionesIC: Codeunit "Zummo Inn. IC Functions";
                    DateFilter: text;

                    lblError: Label 'You have to indicate a Date filter.\%1 to %2', comment = 'ESP="Debe indicar un filtro de Fecha.\%1 a %2"';
                    lblConfirm: Label '¿Desea actualizar los movimientos de Costes.\Filtro Fecha: %1?', comment = 'ESP="¿Desea actualizar los movimientos de Costes.\Filtro Fecha %1?"';
                begin
                    CurrPage.SetSelectionFilter(ValueEntry);
                    DateFilter := ValueEntry.GetFilter("Posting Date");
                    if not Confirm(lblConfirm, false, Customer.GetFilter("Date Filter")) then
                        exit;
                    FuncionesIC.Inventario_UpdateEntries(ValueEntry);
                end;
            }
        }
    }
}
