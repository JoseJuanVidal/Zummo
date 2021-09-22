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
    }

    var
        Resource: Record Resource;

    local procedure ValidateResponsable()
    begin
        if Resource.Get(Responsable) then
            "Nombre Responsable" := Resource.Name;
    end;
}