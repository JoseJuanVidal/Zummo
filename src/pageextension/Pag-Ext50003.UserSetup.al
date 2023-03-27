pageextension 50003 "UserSetup" extends "User Setup"
{
    // 161219 S19/01406 Validar productos
    layout
    {
        addafter(Email)
        {
            field(PermiteValidarProcutos_bc; PermiteValidarProcutos_bc)
            {
                ApplicationArea = all;
            }
            field(ImprimirPedVentaComentarios; ImprimirPedVentaComentarios)
            {
                ApplicationArea = all;
            }
            field("Permite cambiar MMPP"; "Permite cambiar MMPP")
            {
                ApplicationArea = all;
            }
            field("Permite exportacion costes BOM"; "Permite exportacion costes BOM")
            {
                ApplicationArea = all;
            }
        }
    }
}