tableextension 50171 "ClosedCarteraDoc" extends "Closed Cartera Doc." //7000004
{
    fields
    {
        field(50100; "Direct Debit Mandate ID"; Code[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Direct Debit Mandate ID', Comment = 'ESP="Id. de orden de domiciliación de adeudo directo"';
            TableRelation = "SEPA Direct Debit Mandate".ID WHERE("Customer No." = FIELD("Account No."));
        }
    }
}