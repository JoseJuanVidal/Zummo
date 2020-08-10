pageextension 50178 "SEPADirectDebitMandates" extends "SEPA Direct Debit Mandates"
{
    layout
    {
        modify(ID)
        {
            StyleExpr = Estilo;

        }
    }
    var
        Estilo: Code[20];

    trigger OnAfterGetRecord()
    var
        Customer: record Customer;
    begin
        Estilo := '';
        Customer.reset;
        Customer.SetRange("No.", Rec."Customer No.");
        if Customer.FindFirst() then begin
            if "Customer Bank Account Code" = Customer."Preferred Bank Account Code" then
                Estilo := 'Strong';
        end;
    end;
}


