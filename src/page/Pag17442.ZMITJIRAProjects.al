page 17442 "ZM IT JIRA Projects"
{
    ApplicationArea = All;
    Caption = 'JIRA Projects';
    PageType = List;
    SourceTable = "ZM IT JIRA Projects";
    UsageCategory = Administration;
    //Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("key"; Rec."key")
                {
                    ApplicationArea = All;
                }
                field(summary; Rec.name)
                {
                    ApplicationArea = All;
                }
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(JIRAGetAllTickets)
            {
                Caption = 'Refresh', comment = 'ESP="Actualizar"';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SWFunciones: Codeunit "Zummo Inn. IC Functions";
                begin
                    SWFunciones.JIRAGetAllProjects();
                end;
            }
        }
    }
}
