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
            field("Projects Daily Time"; GetDailyTimeProjects)
            {
                ApplicationArea = all;
                Caption = 'Projects Daily Time', comment = 'ESP="Proyectos"';

                trigger OnDrillDown()
                begin
                    DrillDownDailyTimeProject();
                end;
            }
        }
    }
    var
        DailyTimeSheet: record "ZM IT Daily Time Sheet";
        DailyProjects: record "ZM IT JIRA Projects";

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

    local procedure GetDailyTimeProjects(): Integer
    begin
        DailyProjects.Reset();
        DailyProjects.SetRange(Type, DailyProjects.Type::Intern);
        exit(DailyProjects.Count);
    end;

    local procedure DrillDownDailyTimeProject()
    var
        ITProjects: page "ZM IT JIRA Projects";
    begin
        //lanzamos la lista de Marcajes de este usario
        DailyProjects.Reset();
        DailyProjects.SetRange(Type, DailyProjects.Type::Intern);
        ITProjects.SetTableView(DailyProjects);
        ITProjects.Run();
        // page.Run(page::"ZM IT JIRA Projects", DailyProjects);

    end;


}
