tableextension 50180 "STH ZUM Cartera Doc." extends "Cartera Doc." //7000002
{
    fields
    {
        Field(50000; "STH Vendor Name"; text[100])
        {
            Caption = 'Vendor Name', comment = 'ESP="Nombre Proveedor"';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Account No.")));
        }
    }
}