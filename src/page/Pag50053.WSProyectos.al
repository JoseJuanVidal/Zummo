page 50053 "WS Proyectos"
{
    PageType = List;
    ApplicationArea = none;
    UsageCategory = Administration;
    SourceTable = "Job Task";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job No."; "Job No.")
                {
                    ApplicationArea = all;
                }
                field("Job Description"; JobDesc)
                {
                    ApplicationArea = all;
                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Job Task Type"; "Job Task Type")
                {
                    ApplicationArea = all;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = all;
                }
                field("Fecha inicial planificada"; "Fecha inicial planificada")
                {
                    ApplicationArea = all;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = all;
                }

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
    trigger OnAfterGetRecord()
    begin
        if job.Get(Rec."Job No.") then
            JobDesc := Job.Description
        else
            JobDesc := '';
    end;

    var
        Job: Record Job;
        JobDesc: Text;
}