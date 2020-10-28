pageextension 50049 "STH Employee List" extends "Employee List"
{
    layout
    {
        addlast(Control1)
        {
            field("Company E-Mail"; "Company E-Mail")
            {
                ApplicationArea = all;
            }
        }
    }
}