pageextension 50221 "ZM Fixed Asset Journal" extends "Fixed Asset Journal"
{
    layout
    {
        addafter("FA Error Entry No.")
        {
            field("Purch. Request less 200"; "Purch. Request less 200")
            {
                ApplicationArea = all;
            }
        }
    }
}