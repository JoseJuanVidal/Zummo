pageextension 50180 "RegisteredWhseActLines" extends "Registered Whse. Act.-Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Serial No."; "Serial No.")
            {
                ApplicationArea = All;
            }
        }
    }
}