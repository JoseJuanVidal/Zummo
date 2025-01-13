page 17418 "ZM BCD Travel Empleado"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ZM BCD Travel Empleado";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Codigo; Codigo)
                {
                    ApplicationArea = All;
                }
                field(Nombre; Nombre)
                {
                    ApplicationArea = all;
                }
                field("G/L Account"; "G/L Account")
                {
                    ApplicationArea = all;
                }
                field("Employee Code"; "Employee Code")
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
            action(Employee)
            {
                ApplicationArea = all;
                Caption = 'Employee', comment = 'ESP="Empleado"';
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                RunPageMode = View;
                RunObject = page "Employee Card";
                RunPageLink = "No." = field("Employee Code");
            }
        }
    }
}