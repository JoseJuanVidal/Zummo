table 17440 "ZM IT Daily Time Sheet"
{
    DataClassification = CustomerContent;
    Caption = 'Daily Time Sheet', comment = 'ESP="Partes Diarios"';
    LookupPageId = "ZM IT Daily Time Sheet List";
    DrillDownPageId = "ZM IT Daily Time Sheet List";

    fields
    {
        field(1; id; Guid)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha registro"';
            Editable = false;
        }
        field(3; "User id"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User Id', comment = 'ESP="Id. Usuario"';
            TableRelation = "User Setup";
        }
        field(4; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date', comment = 'ESP="Fecha"';
        }
        field(5; Time; Duration)
        {
            DataClassification = CustomerContent;
            Caption = 'Time', comment = 'ESP="Tiempo"';
        }
        field(10; "Resource no."; code[20])
        {
            Caption = 'Resource No.', comment = 'ESP="Cód. Recurso"';
            FieldClass = FlowField;
            CalcFormula = lookup("User Setup"."Resource No." where("User ID" = field("User id")));
            Editable = false;
        }
        field(11; "Resource Name"; text[100])
        {
            Caption = 'Resource Name', comment = 'ESP="Nombre"';
            FieldClass = FlowField;
            CalcFormula = lookup(Resource.Name where("No." = field("Resource no.")));
            Editable = false;
        }
        field(20; Department; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Department', comment = 'ESP="Departamento"';
            TableRelation = MultiRRHH_zum.Codigo WHERE(tabla = CONST("IT Departamentos"));
        }
        field(30; "Type"; Enum "ZM IT Time Sheet Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Tipo', comment = 'ESP="Tipo"';
        }
    }

    keys
    {
        key(Key1; id)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        if IsNullGuid(Rec.id) then
            Rec.id := CreateGuid();
        if Rec."Posting Date" = 0D then
            Rec."Posting Date" := Workdate();
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

    procedure GetDuration(TimeType: enum "ZM IT Time Setup"; Value: Duration): decimal
    begin
        case TimeType of
            TimeType::" ":
                exit(Value);
            TimeType::"100/Hour":
                exit(Value / 36000);
            TimeType::Days:
                exit(Value / 86400000);
            TimeType::Hours:
                exit(Value / 3600000);
            TimeType::Minutes:
                exit(Value / 60000);
        end;
    end;

}