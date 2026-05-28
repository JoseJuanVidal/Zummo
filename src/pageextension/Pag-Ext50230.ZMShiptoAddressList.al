pageextension 50230 "ZM Ship-to Address List" extends "Ship-to Address List"
{
    layout
    {
        addafter(Name)
        {
            field("Name 2"; "Name 2")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addlast(Control1)
        {
            field("Customer No."; "Customer No.")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Codigo Anterior"; "Codigo Anterior")
            {
                ApplicationArea = all;
            }
        }
    }
}