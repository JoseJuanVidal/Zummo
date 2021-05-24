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