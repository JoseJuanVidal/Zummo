table 20351 "ZM Documents for Platforms"
{
    DataClassification = CustomerContent;
    Caption = 'Documents for Platforms', comment = 'ESP="Documentos para Plataformas"';
    LookupPageId = "ZM Documents for Platforms";
    DrillDownPageId = "ZM Documents for Platforms";

    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', comment = 'ESP="Código"';
        }
        field(2; Name; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name', comment = 'ESP="Nombre"';
        }
        field(3; Type; Enum "Type Documents Platforms")
        {
            DataClassification = CustomerContent;
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(5; Department; text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Department', comment = 'ESP="Departamento"';
            TableRelation = MultiRRHH_zum.Codigo where(tabla = const(Departamentos));
        }
        field(6; "Owner"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Owner', comment = 'ESP="Propietario"';
        }
        field(10; Origin; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Origin', comment = 'ESP="Origen"';
        }
        field(12; "Response time"; Option)
        {
            Caption = 'Response time', comment = 'ESP="Tiempo respuesta"';
            OptionMembers = Annual,"Half-yearly",Quarter,Monthly;
            OptionCaption = 'Annual, Half-yearly,Quarter, Monthly', comment = 'ESP="Anual,Semestral,Trimestre,Mensual"';

            trigger OnValidate()
            begin
                UpdateResponseTime()
            end;
        }
        field(22; "Response time Duration"; text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Response time Duration', comment = 'ESP="Tiempo respuesta Duration"';
            Editable = false;
        }
        field(14; State; Enum "Status Documents Platforms")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', comment = 'ESP="Estado"';
        }
        field(16; Mandatory; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Mandatory', comment = 'ESP="Obligatorio"';
        }
        field(18; "Employee Nos."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Nos.', comment = 'ESP="Nº Empleados"';
        }
        field(20; "Expired Documents"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Expired Documents', comment = 'ESP="Documentos Caducados"';
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        UpdateResponseTime();
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

    local procedure UpdateResponseTime()
    begin
        case Rec."Response time" of
            Rec."Response time"::Annual:
                Rec."Response time Duration" := '<+1Y>';
            Rec."Response time"::"Half-yearly":
                Rec."Response time Duration" := '<+6M>';
            Rec."Response time"::Quarter:
                Rec."Response time Duration" := '<+3M>';
            Rec."Response time"::Monthly:
                Rec."Response time Duration" := '<+1M>';
        end;
    end;
}