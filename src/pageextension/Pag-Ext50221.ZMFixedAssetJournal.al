pageextension 50221 "ZM Fixed Asset Journal" extends "Fixed Asset Journal"
{
    layout
    {
        addafter("FA Error Entry No.")
        {
            field(DIVISION; DIVISION)
            { ApplicationArea = all; }
            field("Business Unit"; "Business Unit")
            { ApplicationArea = all; }
            field("Purch. Request less 200"; "Purch. Request less 200")
            {
                ApplicationArea = all;
            }
        }
    }
}