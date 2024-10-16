pageextension 50220 "ZM Misc. Articles" extends "Misc. Articles"
{
    PromotedActionCategories = 'New,Process,Report,Navigate,Setup', Comment = 'ESP="Nuevo,Procesar,Informe,Información,Configuración"';


    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // addlast(Processing)
        // {
        //     action(AssingEmployee)
        //     {
        //         ApplicationArea = all;
        //         Caption = 'Assing Employee', comment = 'ESP="Asignar Empleados"';
        //         Image = SelectLineToApply;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         PromotedCategory = Process;
        //         RunObject = page "Misc. Article Information";
        //         RunPageLink = "Misc. Article Code" = field(code);

        //     }
        // }
        addlast(Navigation)
        {
            action(EmployeeUses)
            {
                ApplicationArea = all;
                Caption = 'Employee', comment = 'ESP="Empleados"';
                Image = Employee;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category4;
                RunObject = page "Misc. Article Information";
                RunPageLink = "Misc. Article Code" = field(code);

            }
        }
    }

    var
        myInt: Integer;
}