page 17441 "ZM IT JIRA Tickets"
{
    ApplicationArea = All;
    Caption = 'JIRA Tickets';
    PageType = List;
    SourceTable = "ZM IT JIRA Tickets";
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
                field(summary; Rec.summary)
                {
                    ApplicationArea = All;
                }
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                }
                field(State; Rec.State)
                {
                    ApplicationArea = All;
                }
                field(Assignee; Assignee)
                {
                    ApplicationArea = all;
                }
                field("Description Status"; Rec."Description Status")
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
                    SWFunciones.JIRAGetAllTickets('TZ', '');
                end;
            }
        }
    }
}
