table 17440 "ZM IT Daily Time Sheet"
{
    DataClassification = CustomerContent;
    Caption = 'Daily Time Sheet', comment = 'ESP="Partes Diarios"';
    LookupPageId = "ZM IT Daily Time Sheet List";
    DrillDownPageId = "ZM IT Daily Time Sheet List";

    fields
    {
        field(1; id; Guid)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha registro"';
            Editable = false;
        }
        field(3; "User id"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User Id', comment = 'ESP="Id. Usuario"';
            TableRelation = "User Setup";
        }
        field(4; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date', comment = 'ESP="Fecha"';
        }
        field(5; TimeDuration; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Time Duration', comment = 'ESP="Tiempo"';
        }
        field(10; "Resource no."; code[20])
        {
            Caption = 'Resource No.', comment = 'ESP="Cód. Recurso"';
            FieldClass = FlowField;
            CalcFormula = lookup("User Setup"."Resource No." where("User ID" = field("User id")));
            Editable = false;
        }
        field(11; "Resource Name"; text[100])
        {
            Caption = 'Resource Name', comment = 'ESP="Nombre"';
            FieldClass = FlowField;
            CalcFormula = lookup(Resource.Name where("No." = field("Resource no.")));
            Editable = false;
        }
        field(20; Department; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Department', comment = 'ESP="Departamento"';
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST("IT Departamentos"));
        }
        field(30; Type; Enum "ZM IT Time Sheet Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Tipo', comment = 'ESP="Tipo"';
        }
        field(31; "key"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Key', comment = 'ESP="Código"';
            TableRelation = if (Type = const("JIRA Ticket")) "ZM IT JIRA Tickets"."key" where(Type = const(Ticket)) else
            if (Type = const("JIRA Proyecto")) "ZM IT JIRA Projects"."key" else
            if (Type = const(Proyecto)) Job."No.";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                KeyOnValidate();
            end;
        }
        field(32; "Key summary"; text[250])
        {
            Caption = 'Key summary', comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(35; "Subkey"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Ticket', comment = 'ESP="Ticket"';
            TableRelation = "ZM IT JIRA Tickets"."key" where(Project = field("key"));


            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                SubKeyOnValidate();
            end;
        }
        field(50; "Start Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Time', comment = 'ESP="Hora Inicio"';

            trigger OnValidate()
            begin
                ValidateStarEnd();
            end;
        }
        field(51; "End Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'End Time', comment = 'ESP="Hora Fin"';

            trigger OnValidate()
            begin
                ValidateStarEnd();
            end;
        }
        field(60; "Employee No."; code[20])
        {
            Caption = 'Employee No.', comment = 'ESP="Cód. Persona"';
            DataClassification = CustomerContent;
            TableRelation = Employee where("User Id" = field("User id"));
        }
        field(61; "Employee Name"; text[100])
        {
            Caption = 'Employee Name', comment = 'ESP="Nombre"';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee.Name where("No." = field("Employee no.")));
            Editable = false;
        }
        field(62; Task; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Task', comment = 'ESP="Tarea"';
            TableRelation = "ZM Daily Task".Code where("User Id" = field("User id"));
        }
        field(100; Registered; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Registered', comment = 'ESP="Registrado"';
        }
        field(110; Notes; text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Notes', comment = 'ESP="Notas"';
        }
    }

    keys
    {
        key(Key1; id)
        {
            Clustered = true;
        }
        key(key2; Date, "User id", "Employee No.")
        {

        }
    }

    var
        JobsSetup: Record "Jobs Setup";
        Job: Record Job;
        Resource: Record Resource;
        JIRATickets: record "ZM IT JIRA Tickets";
        JIRAProjects: Record "ZM IT JIRA Projects";
        lblStart: Label '¿Do you want to START the time registration %1?', comment = 'ESP="¿Desea INICIAR el fichaje %1?"';
        lblEnd: Label '¿Do you want to FINISH the time registration.\START: %1\END: %2?', comment = 'ESP="¿Desea FINALIZAR el fichaje.\INICIO: %1\FIN: %2?"';
        lblErrorStart: Label 'Task %1 has already been started at %2 o''clock.', comment = 'ESP="Ya se ha iniciado la tarea %1 a las %2."';
        lblErrorEnd: Label 'Task has not been started %1', comment = 'ESP="No se ha iniciado la tarea %1"';
        lblConfirmEnd: Label 'The time has already expired at %1.\¿Do you want to change the end time?', comment = 'ESP="Ya se ha finalizado el tiempo a las %1.\¿Desea cambiar la hora de finalización?"';
        lblError: Label 'The time registration is already done. The end time must be deleted before the end', comment = 'ESP="El marcaje ya esta realizado. Hay que eliminar el tiempo final antes de finalizar"';


    trigger OnInsert()
    begin
        if IsNullGuid(Rec.id) then
            Rec.id := CreateGuid();
        if Rec."Posting Date" = 0D then
            Rec."Posting Date" := Workdate();
        if "User id" = '' then
            "User id" := UserId;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure GetDuration(TimeType: enum "ZM IT Time Setup"; Value: Duration): decimal
    begin
        case TimeType of
            TimeType::" ":
                exit(Value);
            TimeType::"100/Hour":
                exit(Value / 36000);
            TimeType::Days:
                exit(Value / 86400000);
            TimeType::Hours:
                exit(Value / 3600000);
            TimeType::Minutes:
                exit(Value / 60000);
        end;
    end;

    local procedure KeyOnValidate()
    var
        SubKey: Guid;
    begin
        Rec."Key summary" := '';
        case Rec.Type of
            Rec.Type::"JIRA Ticket":
                begin
                    JIRATickets.Reset();
                    if JIRATickets.Get(Rec."key") then
                        Rec."Key summary" := JIRATickets.summary;
                end;
            Rec.Type::"JIRA Proyecto":
                begin
                    JIRAProjects.Reset();
                    if JIRAProjects.Get(Rec."key") then
                        Rec."Key summary" := JIRAProjects.name;
                end;
            Rec.Type::"Proyecto":
                begin
                    Job.Reset();
                    if Job.Get(Rec."key") then
                        Rec."Key summary" := Job.Description;
                end;
        end;
    end;

    local procedure SubKeyOnValidate()
    begin
        case Rec.Type of

            Rec.Type::"JIRA Proyecto":
                begin
                    JIRATickets.Reset();
                    if JIRATickets.Get(Rec."key") then
                        Rec.Notes := JIRATickets.summary;
                end;
        end;
    end;

    procedure PostingJobJournal(var DailyTimeSheet: record "ZM IT Daily Time Sheet")
    var
        myInt: Integer;
    begin
        JobsSetup.Get();
        JobsSetup.TestField("Journal Template Name");
        JobsSetup.TestField("Journal Batch Name");
        if DailyTimeSheet.FindFirst() then
            repeat
                if not DailyTimeSheet.Registered then begin
                    CreateJobJournalLine(DailyTimeSheet, JobsSetup."Journal Template Name", JobsSetup."Journal Batch Name");

                    DailyTimeSheet.Registered := true;
                    DailyTimeSheet.Modify();
                end;
            Until DailyTimeSheet.next() = 0;
    end;

    local procedure CreateJobJournalLine(DailyTimeSheet: record "ZM IT Daily Time Sheet"; JournalTemplateName: code[10]; JournalBatchName: code[10])
    var
        UserSetup: Record "User Setup";
        ResJournalLine: record "Res. Journal Line";
        LineNo: Integer;
    begin
        UserSetup.Get(DailyTimeSheet."User id");
        UserSetup.TestField("Resource No.");
        ResJournalLine.Reset();
        ResJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        ResJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        if ResJournalLine.FindLast() then
            LineNo := ResJournalLine."Line No." + 10000
        else
            LineNo := 10000;

        ResJournalLine.Reset();
        ResJournalLine.Init();
        ResJournalLine."Journal Template Name" := JournalTemplateName;
        ResJournalLine."Journal Batch Name" := JournalBatchName;
        ResJournalLine."Line No." := LineNo;
        ResJournalLine.Validate("Posting Date", DailyTimeSheet.Date);
        ResJournalLine."Entry Type" := ResJournalLine."Entry Type"::Usage;
        ResJournalLine."Document No." := CopyStr(StrSubstNo('%1 %2 %3', DailyTimeSheet.Department, DailyTimeSheet.Type, DailyTimeSheet."Key summary"), 1, MaxStrLen(ResJournalLine.Description));
        ResJournalLine.Validate("Resource No.", UserSetup."Resource No.");
        ResJournalLine.Validate(Quantity, ConvertDurationtoResourceTime(UserSetup."Resource No.", DailyTimeSheet.TimeDuration));
        ResJournalLine."External Document No." := CopyStr(DailyTimeSheet."key", 1, MaxStrLen(ResJournalLine."External Document No."));
        ResJournalLine.Insert();
    end;

    local procedure ConvertDurationtoResourceTime(ResourceNo: code[20]; TimeDuration: Duration): Decimal
    begin
        Resource.Reset();
        Resource.Get(ResourceNo);

        case UpperCase(Resource."Base Unit of Measure") of
            'HORAS':
                exit(GetDuration("ZM IT Time Setup"::Hours, TimeDuration));
            'MINUTOS':
                exit(GetDuration("ZM IT Time Setup"::Minutes, TimeDuration));
            'DAYS':
                exit(GetDuration("ZM IT Time Setup"::Days, TimeDuration));
            '100/Hour':
                exit(GetDuration("ZM IT Time Setup"::"100/Hour", TimeDuration));
            Else
                exit(GetDuration("ZM IT Time Setup"::Hours, TimeDuration));
        end;
    end;

    local procedure ValidateStarEnd()
    begin
        Rec.TimeDuration := 0;
        if Rec."End Time" > Rec."Start Time" then
            Rec.TimeDuration := Rec."End Time" - Rec."Start Time";
    end;


    procedure StartTime()
    begin
        if (Rec."Start Time" <> 0DT) and (Rec."End Time" <> 0DT) then
            Error(lblError);
        if Rec."Start Time" <> 0DT then
            Error(lblErrorStart, Rec."Key summary", Rec."Start Time");
        Rec.Validate("Start Time", RoundDateTime(CreateDateTime(WorkDate(), Time()), 60000));
    end;

    procedure EndTime()
    begin
        if (Rec."Start Time" = 0DT) then
            Error(lblErrorEnd);
        if Rec."End Time" <> 0DT then
            if not Confirm(lblConfirmEnd, false, Rec."End Time") then
                exit;
        Rec.Validate("End Time", RoundDateTime(CreateDateTime(WorkDate(), Time()), 60000));
    end;

}