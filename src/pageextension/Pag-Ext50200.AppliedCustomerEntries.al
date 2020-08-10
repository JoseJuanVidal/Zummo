pageextension 50200 "AppliedCustomerEntries" extends "Applied Customer Entries"
{
    layout
    {
        addafter(Control1)
        {
            field("Closed by Amount (LCY)"; "Closed by Amount (LCY)")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}