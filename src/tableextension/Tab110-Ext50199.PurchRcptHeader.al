tableextension 50199 "Purch. Rcpt. Header" extends "Purch. Rcpt. Header"  //110
{
    fields
    {
        field(50030; PdtFacturar; Decimal)
        {
            Caption = 'PdtFacturar', comment = 'ESP="PdtFacturar"';
            FieldClass = FlowField;
            CalcFormula = sum ("Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced" where ("Document No." = field ("No.")));
        }

    }
}