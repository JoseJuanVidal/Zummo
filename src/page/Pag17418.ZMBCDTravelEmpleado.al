page 17418 "ZM BCD Travel Empleado"
{
    PageType = List;
    // ApplicationArea = All;
    UsageCategory = None;
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
                    Editable = false;
                }
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = all;
                }
                field("G/L Account"; "G/L Account")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}