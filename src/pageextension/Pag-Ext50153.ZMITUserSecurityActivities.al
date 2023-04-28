pageextension 50153 "ZM IT User Security Activities" extends "User Security Activities"
{
    layout
    {
        addbefore("Users - To review")
        {
            field("Daily Time Sheet"; '')
            {
                ApplicationArea = all;
                Caption = 'Daily Time Sheet', comment = 'ESP="Partes Diario"';

                trigger OnDrillDown()
                begin
                    DailyTimeSheet();
                end;
            }
        }
    }
    local procedure DailyTimeSheet()
    var
        DailyTimeSheet: record "ZM IT Daily Time Sheet";
    begin
        //lanzamos la lista de Marcajes de este usario
        DailyTimeSheet.Reset();
        DailyTimeSheet.SetRange("User id", UserId);
        page.Run(page::"ZM IT Daily Time Sheet List", DailyTimeSheet);
    end;

}
