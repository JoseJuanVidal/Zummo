page 17443 "ZM Daily Time Sheet List"
{
    Caption = 'Daily Time Sheet List', comment = 'ESP="Partes Diarios"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM IT Daily Time Sheet";
    SourceTableView = sorting(Date, "User id", "Employee No.");


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
                field("User id"; "User id")
                {
                    ApplicationArea = all;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateUserId();
                    end;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        ValidateUserId();
                    end;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = all;
                }
                field(Task; Task)
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
                field(TimeDuration; TimeDuration)
                {
                    ApplicationArea = all;
                }
                field("key"; "key")
                {
                    ApplicationArea = all;
                    Caption = 'Proyecto', comment = 'ESP="Proyecto"';
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
            action(ChangeUser)
            {
                ApplicationArea = all;
                Caption = 'Change User', comment = 'ESP="Cambiar usuario"';
                Image = User;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    ChangeEmployee();
                    CurrPage.Update();
                end;
            }

            action(ShowAll)
            {
                ApplicationArea = all;
                Caption = 'Show/Hide All', comment = 'ESP="Mostrar/Ocultar todos"';
                Image = ExpandAll;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SetFilterUserId();
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        if Fecha = 0D then
            Fecha := WorkDate();
        Rec.SetRange(Date, Fecha);
        GetEmployee();
    end;

    trigger OnOpenPage()
    begin
        if Fecha = 0D then
            Fecha := WorkDate();
        Rec.SetRange(Date, Fecha);
        SetFilterUserId();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateTimeDailySheet;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := REc.Type::Proyecto;
        if Rec.GetFilter(Date) <> '' then
            Rec.Date := Rec.GetRangeMin(Date);

        if Rec."Employee No." = '' then
            Rec."Employee No." := Employee."No.";
    end;

    trigger OnModifyRecord(): Boolean
    begin
        UpdateTimeDailySheet();
    end;

    var
        Employee: Record Employee;
        DailyTime: Record "ZM IT Daily Time Sheet";
        DailyUserSession: Record "ZM Daily User Session";
        Fecha: date;
        Total: Duration;
        Showall: Boolean;
        lblPost: Label 'Do you want to create the resource journal of pending records?', comment = 'ESP="¿Desea crear el diario de recursos de los registros pendientes?"';

    local procedure GetEmployee()
    begin
        Employee.Get(DailyUserSession.UserSession());
    end;

    local procedure UpdateTimeDailySheet()
    begin
        DailyTime.Reset();
        DailyTime.SetRange("User id", UserId);
        DailyTime.SetRange("Employee No.", Employee."No.");
        DailyTime.SetRange(date, Fecha);
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
        SWFunciones.JIRAGetAllTickets();
        SWFunciones.JIRAGetAllProjects();
        Message('End/Fin');
    end;

    local procedure SetFilterUserId()
    var
        myInt: Integer;
    begin
        Rec.Reset();
        Rec.FilterGroup := 2;
        Rec.SetRange("User id", UserId);
        Rec.FilterGroup := 0;
        if Showall then
            Rec.SetRange("Employee No.")
        else
            Rec.SetRange("Employee No.", Employee."No.");
        if Showall then
            Rec.SetRange(Date)
        else
            Rec.SetRange(Date, WorkDate());
        Showall := not Showall;

    end;

    local procedure ChangeEmployee()

    begin
        if DailyUserSession.ChangeUserSession(Employee) then
            Rec.SetRange("Employee No.", Employee."No.");
        CurrPage.Update();
    end;
}