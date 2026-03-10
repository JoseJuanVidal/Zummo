page 17221 "ZM Job Requirement Compliances"
{
    PageType = List;
    // ApplicationArea = All;
    Caption = 'Requirements Compliance', comment = 'ESP="Cumplimiento Requisitos"';
    UsageCategory = None;
    SourceTable = "ZM Job Requirements Compliance";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; "Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                    Visible = false;
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field(Category; Category)
                {
                    ApplicationArea = all;
                }
                field(RP0; RP0)
                {
                    ApplicationArea = all;
                }
                field(RP1; RP1)
                {
                    ApplicationArea = all;
                }
                field(RP2; RP2)
                {
                    ApplicationArea = all;
                }
                field(RP4; RP4)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}