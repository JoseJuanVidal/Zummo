page 17412 "ZM PL Item Setup Departments"
{
    Caption = 'Item Setup Departments', comment = 'ESP="Conf. Departamentos Alta productos"';
    PageType = Card;
    UsageCategory = None;
    // ApplicationArea = all;
    SourceTable = "ZM PL Item Setup Department";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
            group(Setup)
            {
                field(Email; Email)
                {
                    ApplicationArea = all;
                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(showEmployee)
            {
                ApplicationArea = all;
                Caption = 'Show Employee', comment = 'ESP="Mostrar empleados"';
                Image = Employee;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                RunObject = page "Employee List";
                RunPageLink = "Approval Department User Id" = field("User Id");

            }
        }
    }
}
