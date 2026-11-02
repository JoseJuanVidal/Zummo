table 17213 "ZM Dash IDM Column"
{
    DataClassification = CustomerContent;
    Caption = 'Dashboard IDM Column', comment = 'ESP="Dashboard columna IDM"';
    DrillDownPageId = "ZM Dash IDM Column WS";
    LookupPageId = "ZM Dash IDM Column WS";

    fields
    {
        field(1; Id; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Id', comment = 'ESP="Id"';
        }
        field(10; Title; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Title', comment = 'ESP="Título"';
        }
        field(11; "Sort Order"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sort Order', comment = 'ESP="Orden"';
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
        key(PK; Id)
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
