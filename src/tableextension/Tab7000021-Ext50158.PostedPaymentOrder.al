tableextension 50158 "PostedPaymentOrder" extends "Posted Payment Order"  //7000021
{
    fields
    {
        field(50100; DueDate_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Due Date', comment = 'ESP="Fecha Pago"';
        }
        // Field(50101; "ZM Ext Doc No."; text[100])
        // {
        //     Caption = 'Ext. Doc No.', comment = 'ESP="Nº Documento externo"';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = lookup("Cust. Ledger Entry"."External Document No." where("Customer No." = field("Account No."), "Document No." = field("Document No."), "Document Type" = field("Document Type")));
        // }
        // Field(50102; "ZM Vendor Ext Doc No."; text[100])
        // {
        //     Caption = 'Ext. Doc No.', comment = 'ESP="Nº Documento externo"';
        //     FieldClass = FlowField;
        //     Editable = false;
        //     CalcFormula = lookup("Vendor Ledger Entry"."External Document No." where("Vendor No." = field("Account No."), "Document No." = field("Document No."), "Document Type" = field("Document Type")));
        // }
    }
}