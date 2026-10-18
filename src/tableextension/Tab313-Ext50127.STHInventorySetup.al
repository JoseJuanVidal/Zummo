tableextension 50127 "STHInventory Setup" extends "Inventory Setup" //313
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Inventory"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Inventory Qty.', comment = 'ESP="Cant. Inventario"';
        }
        field(50101; "Qty. on Assembly Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Assembly Order', comment = 'ESP="Cant. en pedido de ensamblado"';
        }
        field(50102; "Qty. on Prod. Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Prod. Order', comment = 'ESP="Cant. en orden producc."';
        }
        field(50103; "Qty. on Purch. Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Purch. Order', comment = 'ESP="Cant. en pedidos compra"';
        }
        field(50104; "Trans. Ord. Receipt (Qty.)"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Trans. Ord. Receipt (Qty.)', comment = 'ESP="Recep. ped. transfer. (cant.)"';
        }

        field(50105; "Qty. on Asm. Component"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Asm. Component', comment = 'ESP="Cant. componentes"';
        }
        field(50106; "Qty. on Component Lines"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Component Lines', comment = 'ESP="Cant. línea componentes"';
        }
        field(50107; "Qty. on Job Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Job Order', comment = 'ESP="Cant. en pedido de proyecto"';
        }
        field(50108; "Qty. on Sales Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Sales Order', comment = 'ESP="Cant. en pedidos venta"';
        }
        field(50109; "Qty. on Service Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Service Order', comment = 'ESP="Cant. en ped. servicio"';
        }
        field(50110; "Trans. Ord. Shipment (Qty.)"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Trans. Ord. Shipment (Qty.)', comment = 'ESP="Envío ped. transfer. (cant.)"';
        }
        field(50111; "Qty. on Sales Quote"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Sales Quote', comment = 'ESP="Cant. en ofertas venta"';
        }
        field(50112; "Qty. on Component Quote"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Component Quote', comment = 'ESP="Cant. en componentes ofertas"';
        }
        field(50113; "Qty. on Planning MPS Component"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty. on Planning MPS Component', comment = 'ESP="Cant. en componentes Hoja planificación"';
        }
        field(50120; "MRP Bitec Activo"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'MRP Bitec Activo', comment = 'ESP="MRP Bitec Activo"';
        }

        field(50125; "Fecha Diario dentro periodo"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Diario dentro periodo', comment = 'ESP="Fecha Diario dentro periodo"';
        }
        field(50130; "Email aviso revision utiles"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. tools revision warning email', comment = 'ESP="Email aviso revisión útiles"';
        }
        field(50131; "Ult. aviso revision utiles"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Last prod. tools revision warning', comment = 'ESP="Últ. aviso revisión útiles"';
            Editable = false;
        }
        // PDM SolidWorks (la contraseña SQL se guarda en IsolatedStorage, no en la tabla)
        field(50140; "PDM SQL Server"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'PDM SQL Server', comment = 'ESP="Servidor SQL PDM"';
        }
        field(50141; "PDM SQL Database"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'PDM SQL Database', comment = 'ESP="Base de datos PDM"';
        }
        field(50142; "PDM SQL User"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'PDM SQL User', comment = 'ESP="Usuario SQL PDM"';
        }
        field(50143; "PDM Vault Path"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'PDM Vault Path', comment = 'ESP="Ruta almacén PDM"';
        }
        field(50144; "PDM Last Sync"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'PDM Last Sync', comment = 'ESP="Últ. sincronización PDM"';
            Editable = false;
        }
        field(50145; "PDM Sync Mark"; Text[19])
        {
            // fecha/hora del servidor SQL del PDM al iniciar la última sincronización (aaaa-mm-dd hh:mi:ss)
            DataClassification = CustomerContent;
            Caption = 'PDM Sync Mark', comment = 'ESP="Marca sincronización PDM"';
            Editable = false;
        }
    }
}