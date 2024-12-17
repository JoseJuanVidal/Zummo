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
            field("Aviso Final fecha"; "Aviso Final fecha")
            {
                ApplicationArea = all;
            }
            field("Aviso Act. ABERTIA"; "Aviso Act. ABERTIA")
            {
                ApplicationArea = all;
            }
            field("Contrats/Suppliers"; "Contrats/Suppliers")
            {
                ApplicationArea = all;
            }
            field("Approvals Purch. Request"; "Approvals Purch. Request")
            {
                ApplicationArea = all;
            }
            field("Edit Customer List"; "Edit Customer List")
            {
                ApplicationArea = all;
            }
            field("Ubicaciones pedido por defecto"; "Ubicaciones pedido por defecto")
            {
                ApplicationArea = all;
            }
            field("Informes Almacen"; "Informes Almacen")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(CheckGLSetupPeriode)
            {
                ApplicationArea = all;
                Caption = 'Aviso periodo contable', comment = 'ESP="Aviso periodo contable"';
                Image = CheckLedger;

                trigger OnAction()
                var
                    CUCRON: Codeunit CU_Cron;
                begin
                    CUCRON.CheckFechaRegistroConfiguracionContabilidad();
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CheckUserConfiguration();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CheckUserConfiguration();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CheckUserConfiguration();
    end;

    local procedure CheckUserConfiguration()
    var
        ItemRegistrationCodes: Codeunit "ZM PL Items Regist. aprovals";
    begin
        ItemRegistrationCodes.CheckSUPERUserConfiguration(true);
    end;

}