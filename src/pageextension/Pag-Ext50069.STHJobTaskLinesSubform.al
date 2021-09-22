pageextension 50069 "STH JobTaskLinesSubform" extends "Job Task Lines Subform"
{
    layout
    {
        addafter("Amt. Rcd. Not Invoiced")
        {
            field("Status Task"; "Status Task")
            {
                ApplicationArea = all;
            }
            field(Responsable; Responsable)
            {
                ApplicationArea = all;
            }
            field("Nombre Responsable"; "Nombre Responsable")
            {
                ApplicationArea = all;
            }
            field("Fecha inicio real"; "Fecha inicio real")
            {
                ApplicationArea = all;
            }
            field("Fecha fin real"; "Fecha fin real")
            {
                ApplicationArea = all;
            }
        }
    }
}