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
        Field(50102; "ZM Vendor Ext Doc No."; text[100])
        {
            Caption = 'Ext. Doc No.', comment = 'ESP="Nº Documento externo"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Vendor Ledger Entry"."External Document No." where("Vendor No." = field("Account No."), "Document No." = field("Document No."), "Document Type" = field("Document Type")));
        }
    }
}