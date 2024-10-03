tableextension 50201 "ZM Job Journal Line Ext" extends "Job Journal Line"
{
    fields
    {
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

    var
        myInt: Integer;
}