table 17210 "ZM Dash Top5"
{
    DataClassification = CustomerContent;
    Caption = 'Dashboard TOP 5 Minutes', comment = 'ESP="Dashboard acta TOP 5"';
    DrillDownPageId = "ZM Dash Top5 WS";
    LookupPageId = "ZM Dash Top5 WS";

    fields
    {
        field(1; "GAP Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'GAP Code', comment = 'ESP="Cód. GAP"';
        }
        field(2; Id; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Id', comment = 'ESP="Id"';
        }
        field(10; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date', comment = 'ESP="Fecha"';
        }
        field(11; "Improvement Point"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Improvement Point', comment = 'ESP="Punto de mejora"';
        }
        field(12; PDA; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'PDA', comment = 'ESP="PDA"';
        }
        field(13; "Supervisor Approval"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Supervisor Approval', comment = 'ESP="V.ºB.º supervisor"';
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
        key(PK; "GAP Code", Id)
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
