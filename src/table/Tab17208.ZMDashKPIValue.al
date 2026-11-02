table 17208 "ZM Dash KPI Value"
{
    DataClassification = CustomerContent;
    Caption = 'Dashboard KPI Value', comment = 'ESP="Dashboard valor KPI"';
    DrillDownPageId = "ZM Dash KPI Value WS";
    LookupPageId = "ZM Dash KPI Value WS";

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
        field(3; "KPI Code"; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'KPI Code', comment = 'ESP="Cód. KPI"';
        }
        field(10; Value; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value', comment = 'ESP="Valor"';
            DecimalPlaces = 0 : 5;
        }
        field(11; "Has Value"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Has Value', comment = 'ESP="Informado"';
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
        key(PK; "GAP Code", Date, "KPI Code")
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
