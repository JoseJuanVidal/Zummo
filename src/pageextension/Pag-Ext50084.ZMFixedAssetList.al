pageextension 50084 "ZMFixed Asset List" extends "Fixed Asset List"
{
    layout
    {
        addlast(Control1)
        {
            field("Date Ini. Amort"; "Date Ini. Amort")
            {
                ApplicationArea = all;
            }
            field("Date Fin. Amort"; "Date Fin. Amort")
            {
                ApplicationArea = all;
            }
        }
    }
}
