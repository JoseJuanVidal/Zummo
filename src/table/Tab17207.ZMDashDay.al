table 17207 "ZM Dash Day"
{
    DataClassification = CustomerContent;
    Caption = 'Dashboard Day', comment = 'ESP="Dashboard día"';
    DrillDownPageId = "ZM Dash Day WS";
    LookupPageId = "ZM Dash Day WS";

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
        field(10; "Working Day"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Working Day', comment = 'ESP="Día laborable"';
        }
        field(11; Remarks; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks', comment = 'ESP="Observaciones"';
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
        key(PK; "GAP Code", Date)
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
