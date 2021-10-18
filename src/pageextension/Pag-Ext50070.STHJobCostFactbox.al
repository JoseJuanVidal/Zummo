pageextension 50070 "STH Job Cost Factbox" extends "Job Cost Factbox"
{
    layout
    {
        addafter(ScheduleCostLCY)
        {
            field(PresupCostHrs; PresupCostHrs)
            {
                ApplicationArea = all;
                Caption = '   Hrs.', comment = 'ESP="   Hrs."';
            }
            field(PresupCostMaterial; PresupCostMaterial)
            {
                ApplicationArea = all;
                Caption = '   Material', comment = '   Material';
            }
        }
        addafter(UsageCostLCY)
        {
            field(RealCostHrs; RealCostHrs)
            {
                ApplicationArea = all;
                Caption = '   Hrs.', comment = 'ESP="   Hrs."';
            }
            field(RealCostMaterial; RealCostMaterial)
            {
                ApplicationArea = all;
                Caption = '   Material', comment = '   Material';
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }


    trigger OnAfterGetRecord()
    begin
        PresupCostHrs := 0;
        PresupCostMaterial := 0;
        RealCostHrs := 0;
        RealCostMaterial := 0;
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("Job No.", Rec."No.");
        JobPlanningLine.SetRange("Es Material", false);
        JobPlanningLine.CalcSums("Total Cost");
        PresupCostHrs := JobPlanningLine."Total Cost";
        JobPlanningLine.SetRange("Es Material", true);
        JobPlanningLine.CalcSums("Total Cost");
        PresupCostMaterial := JobPlanningLine."Total Cost";

        JobLedgerEntry.Reset();
        JobLedgerEntry.SetRange("Job No.", Rec."No.");
        JobLedgerEntry.SetRange("Es Material", false);
        JobLedgerEntry.CalcSums("Total Cost");
        RealCostMaterial := JobLedgerEntry."Total Cost";
        JobLedgerEntry.SetRange("Es Material", true);
        JobLedgerEntry.CalcSums("Total Cost");
        RealCostMaterial := JobLedgerEntry."Total Cost";


    end;

    var
        JobPlanningLine: Record "Job Planning Line";
        JobLedgerEntry: Record "Job Ledger Entry";
        PresupCostHrs: Decimal;
        PresupCostMaterial: Decimal;
        RealCostHrs: Decimal;
        RealCostMaterial: Decimal;
}