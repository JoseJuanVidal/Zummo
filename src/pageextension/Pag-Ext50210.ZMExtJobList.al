pageextension 50210 "ZM Ext Job List" extends "Job List"
{
    layout
    {
        // Add changes to page layout here
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