pageextension 50091 "FA Subclasses" extends "FA Subclasses"
{
    layout
    {
        addlast(Control1)
        {
            field("Molde/Utillaje"; "Molde/Utillaje")
            { ApplicationArea = all; }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}