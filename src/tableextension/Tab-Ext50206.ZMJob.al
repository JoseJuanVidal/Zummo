tableextension 50206 "ZM Job" extends Job
{
    fields
    {
        field(50000; Cancelled; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cancelled', comment = 'ESP="Cancelado"';
        }
        field(50001; "Percentage progress"; Decimal)
        {
            Caption = '% Progress', comment = 'ESP="% Avance"';
            FieldClass = FlowField;
            CalcFormula = average("Job Task"."Percentage progress" where("Job No." = field("No.")));
            Editable = false;
        }
        field(50010; Machine; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Machine', comment = 'ESP="Máquina"';
            TableRelation = "ZM JOB Clasification".Code where("Field No." = const(50010));
        }
        field(50020; Typology; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Typology', comment = 'ESP="Tipología"';
            TableRelation = "ZM JOB Clasification".Code where("Field No." = const(50020));
        }
        field(50030; Criticality; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Criticality', comment = 'ESP="Criticidad "';
            TableRelation = "ZM JOB Clasification".Code where("Field No." = const(50030));
        }
        field(50040; Laboratory; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Laboratory', comment = 'ESP="Laboratorio"';
            TableRelation = "ZM JOB Clasification".Code where("Field No." = const(50040));
        }
        field(50050; "Country/Region code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country/Region Code', comment = 'ESP="Cód. País"';
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}