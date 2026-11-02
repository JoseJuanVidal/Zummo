table 17214 "ZM Dash IDM Card"
{
    DataClassification = CustomerContent;
    Caption = 'Dashboard IDM Card', comment = 'ESP="Dashboard tarjeta IDM"';
    DrillDownPageId = "ZM Dash IDM Card WS";
    LookupPageId = "ZM Dash IDM Card WS";

    fields
    {
        field(1; Id; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Id', comment = 'ESP="Id"';
        }
        field(10; Title; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Title', comment = 'ESP="Título"';
        }
        field(11; "Column Id"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Column Id', comment = 'ESP="Id columna"';
            TableRelation = "ZM Dash IDM Column".Id;
        }
        field(12; "Sort Order"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sort Order', comment = 'ESP="Orden"';
        }
        field(13; "Card Created At"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Card Created At', comment = 'ESP="Fecha creación tarjeta"';
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
