table 17211 "ZM Dash Routine Check"
{
    DataClassification = CustomerContent;
    Caption = 'Dashboard Routine Check', comment = 'ESP="Dashboard check rutina"';
    DrillDownPageId = "ZM Dash Routine Check WS";
    LookupPageId = "ZM Dash Routine Check WS";

    fields
    {
        field(1; "GAP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'GAP Code', comment = 'ESP="Cód. GAP"';
        }
        field(2; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date', comment = 'ESP="Fecha"';
        }
        field(3; "Check Key"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Check Key', comment = 'ESP="Clave check"';
        }
        field(10; Status; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Status', comment = 'ESP="Estado"';
        }
        field(11; Notes; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Notes', comment = 'ESP="Notas"';
        }
        field(900; "Created By"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Created By', comment = 'ESP="Creado por"';
        }
        field(901; "Created At"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Created At', comment = 'ESP="Fecha creación"';
        }
        field(902; "Modified By"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Modified By', comment = 'ESP="Modificado por"';
        }
        field(903; "Modified At"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Modified At', comment = 'ESP="Fecha modificación"';
        }
    }

    keys
    {
        key(PK; "GAP Code", Date, "Check Key")
        {
            Clustered = true;
        }
    }

    // "Created By" / "Modified By" los rellena el servicio DashboardProduccion con el usuario Windows
    trigger OnInsert()
    begin
        "Created At" := CurrentDateTime;
        "Modified At" := "Created At";
    end;

    trigger OnModify()
    begin
        "Modified At" := CurrentDateTime;
    end;
}
