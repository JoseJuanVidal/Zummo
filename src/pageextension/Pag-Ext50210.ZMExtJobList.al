pageextension 50210 "ZM Ext Job List" extends "Job List"
{
    layout
    {
        addafter(Status)
        {
            field("Ending Date"; "Ending Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter(Status, '<>%1', Rec.Status::Completed);
    end;

}