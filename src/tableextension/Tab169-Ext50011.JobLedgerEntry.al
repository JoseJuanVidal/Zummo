tableextension 50011 "Job Ledger Entry" extends "Job Ledger Entry" // 169 
{
    fields
    {
        field(50104; "Es Material"; Boolean)
        {
            Caption = 'Es Materal', comment = 'ESP="Es Material"';
            FieldClass = FlowField;
            CalcFormula = lookup(Resource."Es Material" where("No." = field("No.")));
            Editable = false;
        }
    }

    var
        myInt: Integer;
}