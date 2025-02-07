tableextension 50201 "ZM Job Journal Line Ext" extends "Job Journal Line"
{
    fields
    {
        modify("Job Task No.")
        {
            trigger OnAfterValidate()
            var
                JobTask: Record "Job Task";
                lblError: Label 'The %1 of the task %2 should be %3', comment = 'ESP="El %1 de la tarea %2 debe ser %3"';
            begin
                if not JobTask.get(Rec."Job No.", Rec."Job Task No.") then
                    exit;
                if (JobTask."Status Task" <> JobTask."Status Task"::"En Curso") then
                    Error(lblError, JobTask.FieldCaption("Status Task"), Rec."Job Task No.", JobTask."Status Task"::"En Curso");
                if (JobTask."Job Task Type" <> JobTask."Job Task Type"::Posting) then
                    Error(lblError, JobTask.FieldCaption("Job Task Type"), Rec."Job Task No.", JobTask."Job Task Type"::Posting);
            end;
        }
        field(50000; "Job Category"; code[20])
        {
            Caption = 'Job Category', Comment = 'ESP="Categoría proyecto"';
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(tabla), TipoTabla = const("Job Clasification"));
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
}