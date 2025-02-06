pageextension 50224 "ZM Job Task Lines" extends "Job Task Lines"
{
    layout
    {
        addafter("Job Task Type")
        {
            field("Status Task"; "Status Task")
            {
                ApplicationArea = all;
            }
        }
    }
}