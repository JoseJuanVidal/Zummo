pageextension 50218 "ZM Serial No. Information List" extends "Serial No. Information List"
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
            field("Last Cost"; "Last Cost")
            {
                ApplicationArea = all;
            }
            field("Last Item ldg Entry"; "Last Item ldg Entry")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
    actions
    {
        addlast(Navigation)
        {
            action(AnalisisPlanRenove)
            {
                ApplicationArea = all;
                Caption = 'Análisis Plan Renove', comment = 'ESP="Análisis Plan Renove"';
                Image = AnalysisView;
                RunObject = page "Analisis Plan Renove";
            }
        }
        addlast(Processing)
        {
            action(CrearDiario)
            {
                ApplicationArea = all;
                Caption = 'Diario Revalorización', comment = 'ESP="Diario Revalorización"';
                Image = Revenue;


                trigger OnAction()
                var
                    RevaluationJournal: page "Revaluation Journal";
                    FuntionEvents: Codeunit Eventos_btc;
                    Texto: Text;
                    lblConfirm: Label '¿Desea crear el diario de revalorizacion por el importe de coste indicado?', comment = 'ESP="¿Desea crear el diario de revalorizacion por el importe de coste indicado?"';
                begin
                    if not Confirm(lblConfirm) then
                        exit;
                    FuntionEvents.AdjustCostItemEntries(Rec, texto);
                    RevaluationJournal.Run();
                    CurrPage.Update(true);
                end;
            }
        }

    }
}