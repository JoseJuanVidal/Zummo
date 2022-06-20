pageextension 50072 "STH Assemble-to-Order Lines" extends "Assemble-to-Order Lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("No contemplar planificacion"; "No contemplar planificacion")
            {
                ApplicationArea = all;
            }
        }
    }
}
