pageextension 50100 "CRMIntegrationTableMappingList" extends "Integration Table Mapping List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(SynchronizeAll)
        {
            action(CreateTask)
            {
                ApplicationArea = all;
                Image = ServiceTasks;

                trigger OnAction()
                begin
                    RecreateJobQueueEntry;
                end;
            }
        }
    }

    var
        myInt: Integer;

    local procedure RecreateJobQueueEntry()
    var
        Funtions: Codeunit Integracion_crm_btc;
    begin
        Funtions.RecreateJobQueueEntry(Rec, 30, true);
    end;
}