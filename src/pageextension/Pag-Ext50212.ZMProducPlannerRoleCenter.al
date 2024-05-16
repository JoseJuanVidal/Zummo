pageextension 50212 "ZM Produc- Planner Role Center" extends "Production Planner Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore("Item &Journal")
        {
            action(JobJournal)
            {
                ApplicationArea = all;
                Caption = 'Job Journal', comment = 'ESP="Diario pr&oyectos"';
                Image = JobJournal;
                Promoted = true;
                PromotedCategory = New;
                RunObject = PAGE "Job Journal";

            }
        }
    }

    var
        myInt: Integer;
}