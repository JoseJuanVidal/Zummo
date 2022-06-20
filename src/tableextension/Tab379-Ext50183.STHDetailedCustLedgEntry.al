tableextension 50183 "STH Detailed Cust. Ledg. Entry" extends "Detailed Cust. Ledg. Entry" //379
{
    fields
    {
        field(50001; "Initial Entry Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Posting Date" where("Entry No." = field("Cust. Ledger Entry No.")));
        }
    }

    var
        myInt: Integer;
}