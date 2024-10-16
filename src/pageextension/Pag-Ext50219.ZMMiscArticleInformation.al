pageextension 50219 "ZM Misc. Article Information" extends "Misc. Article Information"
{
    layout
    {
        addafter("Employee No.")
        {
            field("Employee Name"; "Employee Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addbefore("Serial No.")
        {
            field(Model; Model)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
    }



    var
        Employee: Record Employee;
}