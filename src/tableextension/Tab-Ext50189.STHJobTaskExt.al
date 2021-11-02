tableextension 50189 "STH JobTask Ext" extends "Job Task"
{
    fields
    {
        field(50000; "Status Task"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Estado tarea', comment = 'ESP="Estado tarea"';
            OptionMembers = "No iniciada","En Curso",Completada,Bloqueada;
            OptionCaption = 'No iniciada,En Curso,Completada,Bloqueada', Comment = 'ESP="No iniciada,En Curso,Completada,Bloqueada"';
        }
        field(50001; "Responsable"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsable', comment = 'ESP="Responsable"';
            TableRelation = Resource;

            trigger OnValidate()
            begin
                ValidateResponsable;
            end;
        }
        field(50002; "Nombre Responsable"; text[100])
        {
            FieldClass = FlowField;
            Caption = 'Nombre Responsable', comment = 'ESP="Nombre Responsable"';
            CalcFormula = lookup(Resource.Name where("No." = field(Responsable)));
            Editable = false;
        }
        field(50003; "Fecha inicio real"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha inicio real', comment = 'ESP="Fecha inicio real"';
        }
        field(50004; "Fecha fin real"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha fin real', comment = 'ESP="Fecha fin real"';
        }
        field(50005; "Fecha inicial planificada"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha inicial planificada', comment = 'ESP="Fecha inicial planificada"';
        }
        field(50010; "Presupuesto Coste Horas"; decimal)
        {
            Caption = 'Presupuesto Coste Horas', comment = 'ESP="Presupuesto Coste Horas"';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Planning Line"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No."),
                "Es Material" = const(false), "Schedule Line" = CONST(true), "Planning Date" = FIELD("Planning Date Filter")));
            Editable = false;
        }
        field(50011; "Presupuesto Coste Material"; decimal)
        {
            Caption = 'Presupuesto Coste Material', comment = 'ESP="Presupuesto Coste Material"';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Planning Line"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No."),
            "Es Material" = const(true), "Schedule Line" = CONST(true), "Planning Date" = FIELD("Planning Date Filter")));
            Editable = false;
        }
        field(50012; "Real Coste Horas"; decimal)
        {
            Caption = 'Real Coste Horas', comment = 'ESP="Real Coste Horas"';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No."),
                "Es Material" = const(false), "Entry Type" = CONST(Usage), "Posting Date" = FIELD("Posting Date Filter")));
            Editable = false;
        }
        field(50013; "Real Coste Material"; decimal)
        {
            Caption = 'Real Coste Material', comment = 'ESP="Real Coste Material"';
            FieldClass = FlowField;
            CalcFormula = Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."), "Job Task No." = FIELD("Job Task No."),
                 "Es Material" = const(true), "Entry Type" = CONST(Usage), "Posting Date" = FIELD("Posting Date Filter")));
            Editable = false;
        }
    }

    var
        Resource: Record Resource;

    local procedure ValidateResponsable()
    begin
        if Resource.Get(Responsable) then
            "Nombre Responsable" := Resource.Name;
    end;
}