table 17212 "ZM Dash Routine Finding"
{
    DataClassification = CustomerContent;
    Caption = 'Dashboard Routine Finding', comment = 'ESP="Dashboard hallazgo rutina"';
    DrillDownPageId = "ZM Dash Routine Finding WS";
    LookupPageId = "ZM Dash Routine Finding WS";

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
        field(11; "Check Key"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Check Key', comment = 'ESP="Clave check"';
        }
        field(12; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(13; Action; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Action', comment = 'ESP="Acción"';
        }
        field(14; Status; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Status', comment = 'ESP="Estado"';
            OptionMembers = Open,Closed;
            OptionCaption = 'Open,Closed', comment = 'ESP="Abierto,Cerrado"';
        }
        field(15; "Opened Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Opened Date', comment = 'ESP="Fecha apertura"';
        }
        field(16; "Close Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Close Date', comment = 'ESP="Fecha cierre"';
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
