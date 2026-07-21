pageextension 50232 "ZM G/L Account List" extends "G/L Account List"
{
    layout
    {
        addlast(Control1)
        {
            field(Division; Division)
            { ApplicationArea = all; }
            field("Business Unit"; "Business Unit")
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