tableextension 50141 "FinanceCue" extends "Finance Cue"  //9054
{
    //Validar productos
    fields
    {
        field(50100; ProdPdteValidar_btc; Integer)
        {
            Caption = 'Products pending validation', comment = 'ESP="Productos pdtes validar"';
            FieldClass = FlowField;
            CalcFormula = count (Item where(ValidadoContabiliad_btc = const(false)));
            Editable = false;
        }
    }
}