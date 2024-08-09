pageextension 50216 "ZM Fixed Asset G/L Journal" extends "Fixed Asset G/L Journal"
{
    layout
    {
        addafter(Amount)
        {
            field("Purch. Request less 200"; "Purch. Request less 200")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}