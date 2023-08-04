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
            field("Venta productos sin tarifa"; "Venta productos sin tarifa")
            {
                ApplicationArea = all;
            }
            field("Resource No."; "Resource No.")
            {
                ApplicationArea = all;
            }
            field("Config. Contabilidad"; "Config. Contabilidad")
            {
                ApplicationArea = all;
            }
            field("Contrats/Suppliers"; "Contrats/Suppliers")
            {
                ApplicationArea = all;
            }
            field("Ubicaciones pedido por defecto"; "Ubicaciones pedido por defecto")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CheckUserConfiguration();
    end;

    local procedure CheckUserConfiguration()
    var
        User: Record User;
        AccessControl: Record "Access Control";
    begin
        User.SetRange("User Name", UserID);
        User.FindFirst();
        AccessControl.Reset();
        AccessControl.SetRange("User Security ID", User."User Security ID");
        AccessControl.SetRange("Role ID", 'D365 FULL ACCESS');
        if not AccessControl.FindFirst() then
            ERROR(StrSubstNo('El usuario %1 no tiene permisos para editar estos datos', "User ID"));
    end;

}