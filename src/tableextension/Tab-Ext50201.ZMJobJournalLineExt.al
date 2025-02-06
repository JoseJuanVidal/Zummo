tableextension 50201 "ZM Job Journal Line Ext" extends "Job Journal Line"
{
    fields
    {
        modify("Job Task No.")
        {
            trigger OnAfterValidate()
            var
                JobTask: Record "Job Task";
            begin
                JobTask.get(Rec."Job No.", Rec."Job Task No.");
                JobTask.TestField("Status Task", JobTask."Status Task"::"En Curso");
                JobTask.TestField("Job Task Type", JobTask."Job Task Type"::Posting);
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