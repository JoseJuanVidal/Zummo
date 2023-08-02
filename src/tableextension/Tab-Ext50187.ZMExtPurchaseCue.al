tableextension 50187 "ZM Ext Purchase Cue" extends "Purchase Cue"
{
    fields
    {
        field(17200; "Contract/Suppliers"; Integer)
        {
            Caption = 'Contract/Supplier', comment = 'ESP="Contratos y suminitros"';
            FieldClass = FlowField;
            CalcFormula = count("ZM Contracts/Supplies Header" where(Status = filter(Abierto | Lanzado)));

        }
    }
}
