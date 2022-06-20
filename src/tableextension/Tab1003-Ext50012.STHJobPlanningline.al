tableextension 50012 "STH Job Planning line" extends "Job Planning Line" //1003
{
    fields
    {
        field(50000; "Es Material"; Boolean)
        {
            Caption = 'Es Materal', comment = 'ESP="Es Material"';
            FieldClass = FlowField;
            CalcFormula = lookup(Resource."Es Material" where("No." = field("No.")));
            Editable = false;
        }
    }
}