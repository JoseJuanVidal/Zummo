table 17416 "Posted PL Items temporary"
{
    DataClassification = CustomerContent;
    LookupPageId = "Posted PL Items temporary list";
    DrillDownPageId = "Posted PL Items temporary list";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            TableRelation = Item;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(6; "Assembly BOM"; Boolean)
        {
            Caption = 'Assembly BOM', Comment = 'ESP="L.M. de Ensamblado"';
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure', Comment = 'ESP="Unidad medida base"';
            TableRelation = "Unit of Measure";
        }
        field(10; Type; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Type', comment = 'ESP="Tipo"';
            OptionCaption = 'Inventory,Service,Non-Inventory', comment = 'ESP="Inventario,Servicio,Fuera de inventario"';
            OptionMembers = Inventory,Service,"Non-Inventory";
        }
        field(11; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group', Comment = 'ESP="Grupo registro inventario"';
            TableRelation = "Inventory Posting Group";
        }
        field(14; "Item Disc. Group"; Code[20])
        {
            Caption = 'Item Disc. Group', Comment = 'ESP="Grupo dto. producto"';
            TableRelation = "Item Discount Group";
        }
        field(18; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price', Comment = 'ESP="Precio venta"';
            MinValue = 0;
        }
        field(21; "Costing Method"; Option)
        {
            Caption = 'Costing Method', Comment = 'ESP="Valoración existencias"';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
        field(22; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost', Comment = 'ESP="Coste unitario"';
            MinValue = 0;
        }
        field(31; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.', Comment = 'ESP="Nº proveedor"';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;
        }
        field(32; "Vendor Item No."; Text[20])
        {
            Caption = 'Vendor Item No.', Comment = 'ESP="Cód. producto proveedor';
        }
        field(33; "Lead Time Calculation"; DateFormula)
        {
            AccessByPermission = TableData 120 = R;
            Caption = 'Lead Time Calculation', Comment = 'ESP="Plazo entrega (días)"';
        }
        field(34; "Reorder Point"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Reorder Point', Comment = 'ESP="Punto pedido"';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Maximum Inventory"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Maximum Inventory', Comment = 'ESP="Stock máximo"';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Reorder Quantity"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Reorder Quantity', Comment = 'ESP="Cantidad a pedir"';
            DecimalPlaces = 0 : 5;
        }
        field(37; "Alternative Item No."; Code[20])
        {
            Caption = 'Alternative Item No.', Comment = 'ESP="Nº producto alternativo"';
            TableRelation = Item;
        }
        field(41; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight', Comment = 'ESP="Peso bruto"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(42; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight', Comment = 'ESP="Peso neto"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(43; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel', Comment = 'ESP="Unidades por lote"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(44; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume', Comment = 'ESP="Volumen"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(45; Durability; Code[10])
        {
            Caption = 'Durability', Comment = 'ESP="Duración"';
        }
        field(46; "Freight Type"; Code[10])
        {
            Caption = 'Freight Type', Comment = 'ESP="Tipo flete"';
        }
        field(47; "Tariff No."; Code[20])
        {
            Caption = 'Tariff No.', Comment = 'ESP="Cód. arancelario"';
            TableRelation = "Tariff Number";
            ValidateTableRelation = false;
        }
        field(54; Blocked; Boolean)
        {
            Caption = 'Blocked', Comment = 'ESP="Bloqueado"';
        }
        field(90; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)', Comment = 'ESP="Gr.regis. IVA negocio (precio)"';
            TableRelation = "VAT Business Posting Group";
        }
        field(91; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group', Comment = 'ESP="Grupo registro prod. gen."';
            TableRelation = "Gen. Product Posting Group";
        }
        field(92; Picture; MediaSet)
        {
            Caption = 'Picture', Comment = 'ESP="Imagen"';
        }
        field(97; "Nos. series"; code[20])
        {
            Caption = 'Nos. series', Comment = 'ESP="Nº. Series"';
        }
        field(99; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group', Comment = 'ESP="Grupo registro IVA prod."';
            TableRelation = "VAT Product Posting Group";
        }
        field(100; Reserve; Option)
        {
            AccessByPermission = TableData 120 = R;
            Caption = 'Reserve', Comment = 'ESP="Reserva"';
            InitValue = Optional;
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(910; "Assembly Policy"; Option)
        {
            AccessByPermission = TableData 90 = R;
            Caption = 'Assembly Policy', Comment = 'ESP="Directiva de ensamblado"';
            OptionCaption = 'Assemble-to-Stock,Assemble-to-Order', Comment = 'ESP="Ensamblar para stock,Ensamblar para pedido"';
            OptionMembers = "Assemble-to-Stock","Assemble-to-Order";
        }
        field(1217; GTIN; Code[14])
        {
            Caption = 'GTIN', Comment = 'ESP="GTIN"';
            Numeric = true;
        }
        field(5402; "Serial Nos."; Code[20])
        {
            Caption = 'Serial Nos.';
            TableRelation = "No. Series";
        }
        field(5411; "Minimum Order Quantity"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Minimum Order Quantity', Comment = 'ESP="Cantidad mínima pedido"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5412; "Maximum Order Quantity"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Maximum Order Quantity', Comment = 'ESP="Cantidad máxima pedido"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5413; "Safety Stock Quantity"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Safety Stock Quantity', Comment = 'ESP="Stock de seguridad"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5414; "Order Multiple"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Order Multiple', Comment = 'ESP="Múltiplos de pedido"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5415; "Safety Lead Time"; DateFormula)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Safety Lead Time', Comment = 'ESP="Plazo de seguridad"';
        }
        field(5417; "Flushing Method"; Option)
        {
            AccessByPermission = TableData 5405 = R;
            Caption = 'Flushing Method', Comment = 'ESP="Método de baja"';
            OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward', Comment = 'ESP="Manual,Adelante,Atrás,Pick + Adelante,Pick + Atrás"';
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward";
        }
        field(5419; "Replenishment System"; Option)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Replenishment System', Comment = 'ESP="Sistema reposición"';
            OptionCaption = 'Purchase,Prod. Order,,Assembly', Comment = 'ESP="Compra,Prod. Pedido,,Ensamblado"';
            OptionMembers = Purchase,"Prod. Order",,Assembly;
        }
        field(5422; "Rounding Precision"; Decimal)
        {
            AccessByPermission = TableData 5405 = R;
            Caption = 'Rounding Precision', Comment = 'ESP="Precisión redondeo"';
            DecimalPlaces = 0 : 5;
            InitValue = 1;
        }
        field(5425; "Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure', Comment = 'ESP="Unidad medida venta"';
            TableRelation = IF ("No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        field(5426; "Purch. Unit of Measure"; Code[10])
        {
            Caption = 'Purch. Unit of Measure', Comment = 'ESP="Unidad medida compra"';
            TableRelation = IF ("No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        field(5428; "Time Bucket"; DateFormula)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Time Bucket', Comment = 'ESP="Ciclo"';
        }
        field(5440; "Reordering Policy"; Option)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Reordering Policy', Comment = 'ESP="Directiva reaprov."';
            OptionCaption = ' ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot', Comment = 'ESP=" ,Cant. fija reaprov.,Cant. máxima,Pedido,Lote a lote"';
            OptionMembers = " ","Fixed Reorder Qty.","Maximum Qty.","Order","Lot-for-Lot";
        }
        field(5441; "Include Inventory"; Boolean)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Include Inventory', Comment = 'ESP="Incluir inventario"';
        }
        field(5442; "Manufacturing Policy"; Option)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Manufacturing Policy', Comment = 'ESP="Directiva fabricación"';
            OptionCaption = 'Make-to-Stock,Make-to-Order', Comment = 'ESP="Fab-contra-stock,Fab-contra-pedido"';
            OptionMembers = "Make-to-Stock","Make-to-Order";
        }
        field(5443; "Rescheduling Period"; DateFormula)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Rescheduling Period', Comment = 'ESP="Periodo de reprogramación"';

        }
        field(5701; "Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code', Comment = 'ESP="Cód. fabricante"';
            TableRelation = Manufacturer;
        }
        field(5702; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code', Comment = 'ESP="Cód. categoría producto"';
            TableRelation = "Item Category";
        }
        field(5900; "Service Item Group"; Code[10])
        {
            Caption = 'Service Item Group', Comment = 'ESP="Grupo prod. servicio"';
            TableRelation = "Service Item Group".Code;
        }
        field(6500; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code', Comment = 'ESP="Cód. seguim. prod."';
            TableRelation = "Item Tracking Code";
        }
        field(6501; "Lot Nos."; Code[20])
        {
            Caption = 'Lot Nos.', Comment = 'ESP="Nº serie lote"';
            TableRelation = "No. Series";

        }
        field(6502; "Expiration Calculation"; DateFormula)
        {
            Caption = 'Expiration Calculation', Comment = 'ESP="Cálculo caducidad"';
        }
        field(8003; "Sales Blocked"; Boolean)
        {
            Caption = 'Sales Blocked', Comment = 'ESP="Ventas bloqueadas"';
            DataClassification = CustomerContent;
        }
        field(8004; "Purchasing Blocked"; Boolean)
        {
            Caption = 'Purchasing Blockedtco', Comment = 'ESP="Compras bloqueadas"';
            DataClassification = CustomerContent;
        }
        field(50125; "STH To Update"; Boolean)
        {
            Caption = 'To update', comment = 'Act. itbid';
        }
        field(50126; "STH Last Update Date"; Date)
        {
            Caption = 'Last date updated', comment = 'Ult. Fecha act. itbid';
        }
        Field(50127; Material; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Material', comment = 'ESP="Material"';
        }
        Field(50128; "ITBID Status"; Option)
        {
            Caption = 'ITBID Status', comment = 'ESP="Estado ITBID"';
            OptionMembers = " ",Created;
            OptionCaption = ' ,Created', Comment = 'ESP=" ,Creado"';
        }
        Field(50129; "ITBID Create"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'ITBID Create', comment = 'ESP="Crear para solicitudes"';
        }
        field(59001; Largo; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Largo', comment = 'ESP="Largo"';
        }
        field(59002; Ancho; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Ancho', comment = 'ESP="Ancho"';
        }
        field(59003; Alto; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Alto', comment = 'ESP="Alto"';
        }
        field(50805; EnglishDescription; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'English Description', comment = 'ESP="Descripción Ingles"';
        }
        field(50806; Packaging; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Packaging', comment = 'ESP="Embalaje"';
        }
        field(50807; Color; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Color', comment = 'ESP="Color"';
        }
        field(50810; "State Creation"; Enum "ZM PL State Creation Item")
        {
            DataClassification = CustomerContent;
            Caption = 'State Creation', comment = 'ESP="Estado Alta"';
            Editable = false;
        }
        field(50820; Department; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Department', comment = 'ESP="Departamento"';
            TableRelation = "ZM PL Item Setup Department";
        }
        field(50821; "Product manager"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Product manager', comment = 'ESP="Responsable"';

            trigger OnLookup()
            begin
                OnLookup_Product_Manager();
            end;
        }
        field(50822; Reason; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Reason', comment = 'ESP="Motivo"';
        }
        field(50823; Activity; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Activity', comment = 'ESP="Actividad"';
        }
        field(50824; Prototype; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prototype', comment = 'ESP="Prototipo"';
        }
        field(50825; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha Registro"';
        }
        field(50826; "User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Cód. Usuario', comment = 'ESP="Cód. Usuario"';
            TableRelation = User."User Name";
            ValidateTableRelation = true;
            Editable = false;
        }
        field(50827; "Codigo Empleado"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Codigo Empleado', comment = 'ESP="Codigo Empleado"';
            TableRelation = Employee."No." where("User Id" = field("User ID"));
            ValidateTableRelation = true;
            //Editable = false;
        }
        field(50828; "Reason Blocked"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Reason Blocked/UnBlock', comment = 'ESP="Motivo Bloqueo/Desbloqueo"';
        }
        field(50829; "Nombre Empleado"; text[100])
        {
            Caption = 'Nombre Empleado', comment = 'ESP="Nombre Empleado"';
            Editable = false;
        }

        field(99000750; "Routing No."; Code[20])
        {
            Caption = 'Routing No.', Comment = 'ESP="Nº ruta"';
        }
        field(99000751; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.', Comment = 'ESP="Nº L.M. producción"';
            TableRelation = "ZM CIM Prod. BOM Header";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        Item: Record Item;
        Vend: Record Vendor;
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
        ZMCIMProdBOMHeader: Record "ZM CIM Prod. BOM Header";
        ZMCIMProdBOMLine: Record "ZM CIM Prod. BOM Line";
        ZMItemPurchasePrices: Record "ZM PL Item Purchase Prices";
        Employee: Record Employee;
        SetupPreItemReg: record "ZM PL Setup Item registration";
        TempBlob: Record TempBlob;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Funciones: Codeunit Funciones;
        Text027: Label 'must be greater than 0.', Comment = 'ESP="Debe ser mayor que 0"';
        lblConfirmBOM: Label 'El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?', comment = 'ESP="El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?"';
        lblConfirmUpdateItem: Label 'El producto %1 %2 ya existe, si actualiza se perderan los datos temporales actuales.\¿Desea actualizar los datos?',
            comment = 'ESP="El producto %1 %2 ya existe, si actualiza se perderan los datos temporales actuales.\¿Desea actualizar los datos?"';

    local procedure GetPreItemSetup()
    begin
        SetupPreItemReg.GET;
    end;


    procedure SetWorkDescription(NewWorkDescription: Text)
    begin
        CLEAR(Reason);
        IF NewWorkDescription = '' THEN
            EXIT;
        TempBlob.Blob := Reason;
        TempBlob.WriteAsText(NewWorkDescription, TEXTENCODING::UTF8);
        Reason := TempBlob.Blob;
        Modify();
    end;

    procedure GetWorkDescription(): Text
    var
        CR: text;
    begin
        CALCFIELDS(Reason);
        if not Reason.HASVALUE then
            exit('');
        CR[1] := 10;
        TempBlob.Blob := Reason;
        EXIT(TempBlob.ReadAsText(CR, TEXTENCODING::UTF8));
    end;


    local procedure GetCodEmpleado(): code[20]
    begin
        exit(UserId);
    end;

    local procedure OnLookup_Product_Manager()
    begin
        Page.RunModal(0, Employee);
    end;



    procedure Navigate_ProductionML()
    var
        ZMProdBOM: record "ZM CIM Prod. BOM Header";
        ZMProductionBOMList: page "ZM CIM Production BOM List";
    begin
        ZMProdBOM.SetRange("No.", Rec."Production BOM No.");
        ZMProductionBOMList.SetTableView(ZMProdBOM);
        ZMProductionBOMList.Run();
    end;

    procedure Navigate_PurchasesPrices()
    var
        ZMItemPurchasePrice: record "ZM PL Item Purchase Prices";
        ZMItemPurchasesPrices: page "ZM PL Item Purchases Prices";
    begin
        ZMItemPurchasePrice.SetRange("Item No.", Rec."No.");
        ZMItemPurchasesPrices.SetTableView(ZMItemPurchasePrice);
        ZMItemPurchasesPrices.SetItemNo(Rec."No.");
        ZMItemPurchasesPrices.Run();
    end;

}