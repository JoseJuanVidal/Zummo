pageextension 50038 "ItemJournal" extends "Item Journal"
{
    layout
    {
        addafter(Description)
        {
            field(Desc2_btc; Desc2_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}