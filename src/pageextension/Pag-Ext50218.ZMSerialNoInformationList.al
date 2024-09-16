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

    }
}