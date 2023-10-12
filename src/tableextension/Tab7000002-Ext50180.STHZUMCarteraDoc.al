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
        Field(50105; "Cred_ Max_ Aseg. Autorizado Por_btc"; code[20])
        {
            Caption = 'Crédito Maximo Aseguradora Autorizado Por', Comment = 'ESP="Crédito Maximo Aseguradora Autorizado Por"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer."Cred_ Max_ Aseg. Autorizado Por_btc" where("No." = field("Account No.")));
        }
        Field(50106; "Suplemento_aseguradora"; code[20])
        {
            Caption = 'Suplemento aseguradora', comment = 'ESP="Suplemento aseguradora"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer.Suplemento_aseguradora where("No." = field("Account No.")));
        }
        Field(50107; "Payment Terms Code"; code[10])
        {
            Caption = 'Payment Terms Code', comment = 'ESP="Cód. términos pago"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Cust. Ledger Entry"."Payment Terms Code" where("Entry No." = field("Entry No.")));
        }
        Field(50108; "Credito Maximo Aseguradora_btc"; Integer)
        {
            Caption = 'Crédito Maximo Aseguradora', Comment = 'ESP="Crédito Maximo Aseguradora"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer."Credito Maximo Aseguradora_btc" where("No." = field("Account No.")));
        }
        Field(50109; "clasificacion_aseguradora"; code[20])
        {
            Caption = 'Clasif. Aseguradora', comment = 'ESP="Clasif. Aseguradora"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Customer.clasificacion_aseguradora where("No." = field("Account No.")));
        }
    }
}