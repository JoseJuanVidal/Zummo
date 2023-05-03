pageextension 50153 "ZM IT User Security Activities" extends "User Security Activities"
{
    layout
    {
        addbefore("Users - To review")
        {
            field("Daily Time Sheet"; GetDailyTimeSheet)
            {
                ApplicationArea = all;
                Caption = 'Daily Time Sheet', comment = 'ESP="Partes Diario"';

                trigger OnDrillDown()
                begin
                    DrillDownDailyTimeSheet();
                end;
            }
        }
    }
    var
        DailyTimeSheet: record "ZM IT Daily Time Sheet";

    local procedure DrillDownDailyTimeSheet()
    begin
        //lanzamos la lista de Marcajes de este usario
        DailyTimeSheet.Reset();
        DailyTimeSheet.SetRange(date, WorkDate());
        DailyTimeSheet.SetRange("User id", UserId);
        page.Run(page::"ZM IT Daily Time Sheet List", DailyTimeSheet);
    end;

    local procedure GetDailyTimeSheet(): Integer
    begin
        DailyTimeSheet.Reset();
        DailyTimeSheet.SetRange("User id", UserId);
        DailyTimeSheet.SetRange(date, WorkDate());
        exit(DailyTimeSheet.Count);
    end;

}
