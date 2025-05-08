pageextension 50049 "STH Employee List" extends "Employee List"
{
    layout
    {
        addlast(Control1)
        {
            field("Company E-Mail"; "Company E-Mail")
            {
                ApplicationArea = all;
            }
            field(Area_zum; Area_zum)
            {
                ApplicationArea = all;
            }
            field(Departamento_zum; Departamento_zum)
            {
                ApplicationArea = all;
            }
            field(Sucursal_zum; Sucursal_zum)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter(PayEmployee)
        {
            action(ImportExcel)
            {
                ApplicationArea = all;
                Caption = 'Importar Excel', comment = 'ESP="Importar Excel"';
                Image = Excel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;
                begin
                    Funciones.ImportExcelEmployee();
                end;
            }
        }
    }
}