pageextension 50209 "ZM Fixed Asset Setup" extends "Fixed Asset Setup"
{
    layout
    {
        addafter("Automatic Insurance Posting")
        {
            field("Path File Export"; "Path File Export")
            {
                ApplicationArea = all;

                trigger OnAssistEdit()
                begin
                    Rec.OnAssistEditPathFile();
                end;
            }
        }
    }

}