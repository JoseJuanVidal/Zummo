table 17209 "ZM Dash Action Plan"
{
    DataClassification = CustomerContent;
    Caption = 'Dashboard Action Plan', comment = 'ESP="Dashboard plan de acción"';
    DrillDownPageId = "ZM Dash Action Plan WS";
    LookupPageId = "ZM Dash Action Plan WS";

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
        field(10; "Action No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Action No.', comment = 'ESP="Nº acción"';
        }
        field(11; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(12; Action; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Action', comment = 'ESP="Acción"';
        }
        field(13; Responsible; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsible', comment = 'ESP="Responsable"';
        }
        field(14; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date', comment = 'ESP="Fecha objetivo"';
        }
        field(15; "Close Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Close Date', comment = 'ESP="Fecha cierre"';
        }
        field(16; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status', comment = 'ESP="Estado"';
            OptionMembers = Open,"In Progress",Closed;
            OptionCaption = 'Open,In Progress,Closed', comment = 'ESP="Abierto,En curso,Cerrado"';
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
