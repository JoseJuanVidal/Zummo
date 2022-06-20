tableextension 50199 "Purch. Rcpt. Header" extends "Purch. Rcpt. Header"  //110
{
    fields
    {
        field(50030; PdtFacturar; Decimal)
        {
            Caption = 'Pdt. Facturar', comment = 'ESP="Pdt. Facturar"';
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line"."Qty. Rcd. Not Invoiced" where("Document No." = field("No.")));
        }
        field(50157; BaseImponibleLinea; decimal)
        {
            Caption = 'Base Amount Line', comment = 'ESP="Importe Base IVA"';
            editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line".BaseImponibleLinea where("Document No." = field("No.")));
        }
        field(50158; TotalImponibleLinea; decimal)
        {
            Caption = 'Total Amount Line', comment = 'ESP="Importe Total IVA"';
            editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line".TotalImponibleLinea where("Document No." = field("No.")));
        }
    }
}