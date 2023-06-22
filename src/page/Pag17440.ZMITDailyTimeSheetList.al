page 17440 "ZM IT Daily Time Sheet List"
{
    Caption = 'Daily Time Sheet List', comment = 'ESP="Lista partes diarios"';
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "ZM IT Daily Time Sheet";
    //SourceTableView = where(Registered = const(false));

    layout
    {
        area(Content)
        {
            Group(Options)
            {
                Caption = 'Options', comment = 'ESP="Opciones"';
                field(Fecha; Fecha)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Total; Total)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
            repeater(General)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Date; Date)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        ValidateDate();
                    end;
                }
                field(Department; Department)
                {
                    ApplicationArea = all;
                }
                field(TimeDuration; TimeDuration)
                {
                    ApplicationArea = all;
                }
                field("User id"; "User id")
                {
                    ApplicationArea = all;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateUserId();
                    end;
                }
                field("Resource no."; "Resource no.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("key"; "key")
                {
                    ApplicationArea = all;
                }
                field("Key summary"; "Key summary")
                {
                    ApplicationArea = all;
                }
                field("Resource Name"; "Resource Name")
                {
                    ApplicationArea = all;
                }
                field(Subkey; Subkey)
                {
                    ApplicationArea = all;
                }
                field(Notes; Notes)
                {
                    ApplicationArea = all;
                }
                field("Start Time"; "Start Time")
                {
                    ApplicationArea = all;
                }
                field("End Time"; "End Time")
                {
                    ApplicationArea = all;
                }
                field(Registered; Registered)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PreviousDay)
            {
                ApplicationArea = all;
                Caption = 'Previous Day', comment = 'ESP="Dia Anterior"';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ChangeDay(-1);
                end;
            }
            action(NextDay)
            {
                ApplicationArea = all;
                Caption = 'Next Day', comment = 'ESP="Dia Siguiente"';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ChangeDay(1);
                end;
            }
            action(StartTime)
            {
                ApplicationArea = all;
                Caption = 'Start Time', comment = 'ESP="Inicio"';
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.StartTime();
                end;
            }
            action(EndTime)
            {
                ApplicationArea = all;
                Caption = 'End Time', comment = 'ESP="Finalizar"';
                Image = Stop;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.EndTime();
                end;
            }
            action(ShowAll)
            {
                ApplicationArea = all;
                Caption = 'Show All', comment = 'ESP="Mostrar todos"';
                Image = ExpandAll;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Reset();
                    CurrPage.Update();
                end;
            }
            action(Post)
            {
                ApplicationArea = all;
                Caption = 'Post', comment = 'ESP="Registrar"';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    PostTimeSheet();
                end;
            }
            action(Jira)
            {
                ApplicationArea = all;
                Caption = 'JIRA Refresh', comment = 'ESP="JIRA Act."';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    JiraRefresh();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        if Fecha = 0D then
            Fecha := WorkDate();
        Rec.SetRange(Date, Fecha);
    end;

    trigger OnOpenPage()
    begin
        if Fecha = 0D then
            Fecha := WorkDate();
        Rec.SetRange(Date, Fecha);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateTimeDailySheet;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.GetFilter(Date) <> '' then
            Rec.Date := Rec.GetRangeMin(Date);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        UpdateTimeDailySheet();
    end;

    var
        DailyTime: Record "ZM IT Daily Time Sheet";
        Fecha: date;
        Total: Duration;
        lblPost: Label 'Do you want to create the resource journal of pending records?', comment = 'ESP="¿Desea crear el diario de recursos de los registros pendientes?"';

    local procedure UpdateTimeDailySheet()
    begin
        DailyTime.Reset();
        DailyTime.SetRange(date, Fecha);
        DailyTime.SetRange("User id", UserId);
        DailyTime.CalcSums(TimeDuration);
        Total := DailyTime.TimeDuration;
    end;

    local procedure ValidateDate();
    begin
        if Rec."User id" = '' then
            Rec.Validate("User id", UserId);
    end;

    local procedure ValidateUserId();
    begin
        CurrPage.Update();
    end;

    local procedure ChangeDay(Valor: Integer);
    begin
        Fecha := Fecha + Valor;
        Rec.SetRange(Date, Fecha);
    end;


    local procedure PostTimeSheet()
    var
        DailyTimeSheet: Record "ZM IT Daily Time Sheet";
    begin
        if not Confirm(lblPost) then
            exit;
        DailyTimeSheet.Reset();
        DailyTimeSheet.CopyFilters(Rec);
        Rec.PostingJobJournal(Rec);
    end;


    local procedure JiraRefresh()
    var
        SWFunciones: Codeunit "Zummo Inn. IC Functions";
    begin
        SWFunciones.JIRAGetAllTickets('TZ', '');
        SWFunciones.JIRAGetAllProjects();
        Message('End/Fin');
    end;
}