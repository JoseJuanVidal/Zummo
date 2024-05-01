tableextension 50138 "UserSetup" extends "User Setup"  // 91
{
    // Validar productos

    fields
    {
        field(50100; PermiteValidarProcutos_bc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allows to validate items', comment = 'ESP="Permite validar productos"';
        }
        field(50101; ImprimirPedVentaComentarios; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Imp. Ped. Venta mostrar comentarios', comment = 'ESP="Imp. Ped. Venta mostrar comentarios"';
        }
        field(50102; "Permite cambiar MMPP"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Permite cambiar MMPP', comment = 'ESP="Permite cambiar MMPP"';
        }
        field(50103; "Permite exportacion costes BOM"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Permite exportacion costes BOM', comment = 'ESP="Permite exportacion costes BOM"';
        }
        field(50105; "Resource No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource No.', comment = 'ESP="Nº Recurso"';
            TableRelation = Resource;
        }
        field(50106; "Venta productos sin tarifa"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Venta productos sin tarifa', comment = 'ESP="Venta productos sin tarifa"';
        }
        field(50110; "Config. Contabilidad"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Config. Contabilidad', comment = 'ESP="Config. Contabilidad"';

            trigger OnValidate()
            var
                ItemRegCodeunit: Codeunit "ZM PL Items Regist. aprovals";
            begin
                ItemRegCodeunit.CheckSUPERUserConfiguration();
            end;
        }
        field(50115; "Ubicaciones pedido por defecto"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Ubicaciones pedido por defecto', comment = 'ESP="Ubicaciones pedido por defecto"';
        }
        field(50120; "Contrats/Suppliers"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Contrats/Suppliers', comment = 'ESP="Contratos/Suministros"';
        }
        field(50125; "Edit Customer List"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Edit Customer List', comment = 'ESP="Editar lista clientes"';
        }
        field(50130; "Informes Almacen"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Informes Almacen', comment = 'ESP="Informes Almacen"';
        }
        field(50140; "Approvals Purch. Request"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Approvals purchase requests', comment = 'ESP="aprobación solicitudes compra"';

            trigger OnValidate()
            var
                ItemRegCodeunit: Codeunit "ZM PL Items Regist. aprovals";
            begin
                ItemRegCodeunit.CheckSUPERUserConfiguration();
            end;
        }
    }
}