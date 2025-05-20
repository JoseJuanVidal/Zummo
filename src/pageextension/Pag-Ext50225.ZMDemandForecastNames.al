pageextension 50225 "ZM Demand Forecast Names" extends "Demand Forecast Names"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Edit Demand Forecast")
        {
            action(NavigateEntries)
            {
                ApplicationArea = all;
                Caption = 'Movs. prevision', comment = 'ESP="Movs. prevision"';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ProductionForecastEntry: Record "Production Forecast Entry";
                begin
                    ProductionForecastEntry.SetRange("Production Forecast Name", Rec.Name);
                    Page.Run(0, ProductionForecastEntry);
                end;
            }
        }
    }
}