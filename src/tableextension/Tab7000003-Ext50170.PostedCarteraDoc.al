tableextension 50170 "PostedCarteraDoc" extends "Posted Cartera Doc." //7000003
{
    fields
    {
        field(50100; "Direct Debit Mandate ID"; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Direct Debit Mandate ID', Comment = 'ESP="Id. de orden de domiciliación de adeudo directo"';
            TableRelation = "SEPA Direct Debit Mandate".ID WHERE("Customer No." = FIELD("Account No."));
        }
        Field(50101; "ZM Ext Doc No."; text[100])
        {
            Caption = 'Ext. Doc No.', comment = 'ESP="Nº Documento externo"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Cust. Ledger Entry"."External Document No." where("Customer No." = field("Account No."), "Document No." = field("Document No."), "Document Type" = field("Document Type")));
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