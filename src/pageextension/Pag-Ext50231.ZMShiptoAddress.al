pageextension 50231 "ZM Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; "Name 2")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Last Date Modified")
        {
            field("Codigo Anterior"; "Codigo Anterior")
            {
                ApplicationArea = all;
            }
        }
    }
}