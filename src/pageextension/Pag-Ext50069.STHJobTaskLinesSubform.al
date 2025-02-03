pageextension 50069 "STH JobTaskLinesSubform" extends "Job Task Lines Subform"
{
    layout
    {
        addbefore("Start Date")
        {
            field("Job Task Group"; "Job Task Group")
            {
                ApplicationArea = all;
            }
            field("Percentage progress"; "Percentage progress")
            {
                ApplicationArea = all;
            }
        }
        addafter("Start Date")
        {
            field("Fecha inicial planificada"; "Fecha inicial planificada")
            {
                ApplicationArea = all;
            }
        }
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
            field("Presupuesto Coste Horas"; "Presupuesto Coste Horas")
            {
                ApplicationArea = all;
            }
            field("Presupuesto Coste Material"; "Presupuesto Coste Material")
            {
                ApplicationArea = all;
            }
            field("Real Coste Horas"; "Real Coste Horas")
            {
                ApplicationArea = all;
            }
            field("Real Coste Material"; "Real Coste Material")
            {
                ApplicationArea = all;
            }
        }
    }
}