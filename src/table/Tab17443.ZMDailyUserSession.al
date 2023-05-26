table 17443 "ZM Daily User Session"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Session ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Server Instance ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(3; "User ID"; text[132])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Employee No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
    }

    keys
    {
        key(PK; "Session ID", "Server Instance ID", "User Id")
        {
            Clustered = true;
        }
    }

    var
        lblErrorEmployee: Label 'You must select a person to perform the markings..', comment = 'ESP="Debe seleccionar una Persona para realizar los marcajes."';

    trigger OnInsert()
    begin

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

    procedure UserSession(): code[20]
    var
        DailyUserSession: Record "ZM Daily User Session";
        Employee: Record Employee;
    begin
        DailyUserSession.Reset();
        DailyUserSession.SetRange("Session ID", SessionId());
        DailyUserSession.SetRange("Server Instance Id", ServiceInstanceId());
        DailyUserSession.SetRange("User ID", UserId);
        if DailyUserSession.FindFirst() then begin
            if (DailyUserSession."Employee No." <> '') then
                exit(DailyUserSession."Employee No.");
        end else begin
            DailyUserSession.Reset();
            DailyUserSession.Init();
            DailyUserSession."Session ID" := SessionId();
            DailyUserSession."Server Instance ID" := ServiceInstanceId();
            DailyUserSession."User ID" := UserId;
            DailyUserSession.Insert()
        end;

        Commit();
        if not GetEmployee(Employee) then
            Error(lblErrorEmployee);

        // limpiamos historico de seleccion usuario
        DeleteDailyUserSession(Employee);

        DailyUserSession."Employee No." := Employee."No.";
        DailyUserSession.Modify();
        Commit();
        exit(DailyUserSession."Employee No.");
    end;

    procedure ChangeUserSession(var Employee: Record Employee): Boolean
    var
        DailyUserSession: Record "ZM Daily User Session";

    begin
        if not GetEmployee(Employee) then
            exit;
        DailyUserSession.Reset();
        DailyUserSession.SetRange("Session ID", SessionId());
        DailyUserSession.SetRange("Server Instance Id", ServiceInstanceId());
        DailyUserSession.SetRange("User ID", UserId);
        if not DailyUserSession.FindFirst() then begin
            DailyUserSession.Reset();
            DailyUserSession.Init();
            DailyUserSession."Session ID" := SessionId();
            DailyUserSession."Server Instance ID" := ServiceInstanceId();
            DailyUserSession."User ID" := UserId;
            DailyUserSession.Insert()
        end;

        DailyUserSession."Employee No." := Employee."No.";
        DailyUserSession.Modify();
        // Commit();
        exit(true);
    end;

    local procedure GetEmployee(var Employee: Record Employee): Boolean
    var
        Employee2: Record Employee;
        EmployeeList: Page "Employee List";
    begin
        Employee2.FilterGroup := 2;
        Employee2.SetRange("User Id", UserId);
        Employee2.FilterGroup := 0;
        EmployeeList.SetTableView(Employee2);
        EmployeeList.LookupMode := true;
        if EmployeeList.RunModal() = Action::LookupOK then begin
            EmployeeList.GetRecord(Employee);
            exit(true);
        end
    end;

    local procedure DeleteDailyUserSession(Employee: Record Employee)
    var
        DailyUserSession: Record "ZM Daily User Session";
    begin
        DailyUserSession.Reset();
        DailyUserSession.SetFilter("Session ID", '<>%1', SessionId());
        DailyUserSession.SetRange("Employee No.", Employee."No.");
        DailyUserSession.DeleteAll();
    end;

}