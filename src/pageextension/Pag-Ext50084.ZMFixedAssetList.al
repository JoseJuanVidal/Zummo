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
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = all;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = all;
            }
            field(Active; "Status Use")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Previous AF changes"; "Previous AF changes")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Item No."; "Item No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
}
