pageextension 50173 "FAPostingGroups" extends "FA Posting Groups"
{
    layout
    {
        addafter(Code)
        {
            field(PorcAmort_btc; PorcAmort_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}