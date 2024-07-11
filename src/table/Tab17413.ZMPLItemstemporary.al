table 17413 "ZM PL Items temporary"
{
    DataClassification = CustomerContent;
    Caption = '', comment = 'ESP=""';
    LookupPageId = "ZM PL Items temporary list";
    DrillDownPageId = "ZM PL Items temporary list";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            TableRelation = Item;

            trigger OnValidate()
            begin
                OnValidate_ItemNo()
            end;

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

            trigger OnValidate()
            begin
                IF "Inventory Posting Group" <> '' THEN
                    TESTFIELD(Type, Type::Inventory);
            end;
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

            trigger OnValidate()
            begin
                IF "Costing Method" = xRec."Costing Method" THEN
                    EXIT;

                IF "Costing Method" <> "Costing Method"::FIFO THEN
                    TESTFIELD(Type, Type::Inventory);

                IF "Costing Method" = "Costing Method"::Specific THEN BEGIN
                    TESTFIELD("Item Tracking Code");
                END;
            end;
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

            trigger OnValidate()
            begin
                IF (xRec."Vendor No." <> "Vendor No.") AND
                   ("Vendor No." <> '')
                THEN
                    IF Vend.GET("Vendor No.") THEN
                        "Lead Time Calculation" := Vend."Lead Time Calculation";
            end;
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

            trigger OnValidate()
            var
                TariffNumber: Record "Tariff Number";
            begin
                IF "Tariff No." = '' THEN
                    EXIT;

                IF (NOT TariffNumber.WRITEPERMISSION) OR
                   (NOT TariffNumber.READPERMISSION)
                THEN
                    EXIT;

                IF TariffNumber.GET("Tariff No.") THEN
                    EXIT;

                TariffNumber.INIT;
                TariffNumber."No." := "Tariff No.";
                TariffNumber.INSERT;
            end;
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

            trigger OnValidate()
            begin
                IF Reserve <> Reserve::Never THEN
                    TESTFIELD(Type, Type::Inventory);
            end;
        }
        field(910; "Assembly Policy"; Option)
        {
            AccessByPermission = TableData 90 = R;
            Caption = 'Assembly Policy', Comment = 'ESP="Directiva de ensamblado"';
            OptionCaption = 'Assemble-to-Stock,Assemble-to-Order', Comment = 'ESP="Ensamblar para stock,Ensamblar para pedido"';
            OptionMembers = "Assemble-to-Stock","Assemble-to-Order";

            trigger OnValidate()
            begin
                IF "Assembly Policy" = "Assembly Policy"::"Assemble-to-Order" THEN
                    TESTFIELD("Replenishment System", "Replenishment System"::Assembly);
                IF type in [type::"Non-Inventory", type::Service] THEN
                    TESTFIELD("Assembly Policy", "Assembly Policy"::"Assemble-to-Stock");
            end;
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

            trigger OnValidate()
            begin
                IF "Serial Nos." <> '' THEN
                    TESTFIELD("Item Tracking Code");
            end;
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

            trigger OnValidate()
            begin
                IF "Replenishment System" <> "Replenishment System"::Assembly THEN
                    TESTFIELD("Assembly Policy", "Assembly Policy"::"Assemble-to-Stock");
                IF "Replenishment System" <> "Replenishment System"::Purchase THEN
                    TESTFIELD(Type, Type::Inventory);
            end;
        }
        field(5422; "Rounding Precision"; Decimal)
        {
            AccessByPermission = TableData 5405 = R;
            Caption = 'Rounding Precision', Comment = 'ESP="Precisión redondeo"';
            DecimalPlaces = 0 : 5;
            InitValue = 1;

            trigger OnValidate()
            begin
                IF "Rounding Precision" <= 0 THEN
                    FIELDERROR("Rounding Precision", Text027);
            end;
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

            trigger OnValidate()
            begin
                "Include Inventory" :=
                  "Reordering Policy" IN ["Reordering Policy"::"Lot-for-Lot",
                                          "Reordering Policy"::"Maximum Qty.",
                                          "Reordering Policy"::"Fixed Reorder Qty."];

                IF "Reordering Policy" <> "Reordering Policy"::" " THEN
                    TESTFIELD(Type, Type::Inventory);
            end;
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

            trigger OnValidate()
            begin
                IF "Lot Nos." <> '' THEN
                    TESTFIELD("Item Tracking Code");
            end;
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
        field(50014; selClasVtas_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Sales Classification', comment = 'ESP="Clasificación Ventas"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClasificacionVentas"), TipoRegistro = const(Tabla));

        }

        field(50015; selFamilia_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Family', comment = 'ESP="Familia"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Familia"), TipoRegistro = const(Tabla));

        }

        field(50016; selGama_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Gamma', comment = 'ESP="Gama"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Gamma"), TipoRegistro = const(Tabla));

        }
        field(50017; selLineaEconomica_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Linea Economica', comment = 'ESP="Linea Economica"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("LineaEconomica"), TipoRegistro = const(Tabla));

        }
        field(50018; "ABC"; Option)
        {
            Editable = true;
            Caption = 'ABC', comment = 'ESP="ABC"';
            OptionMembers = " ",ContraStock,BajoPedido;
            OptionCaption = ' ,A,B,C,D', comment = 'ESP=" ,A,B,C,D"';
        }
        field(50020; desClasVtas_btc; text[100])
        {
            Caption = 'Desc. Sales Classification', comment = 'ESP="Desc. Clasificación Ventas"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(ClasificacionVentas), NumReg = field(selClasVtas_btc)));
        }
        field(50021; desFamilia_btc; text[100])
        {
            Caption = 'Desc. Familia', comment = 'ESP="Desc. Familia"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(Familia), NumReg = field(selFamilia_btc)));
        }
        field(50022; desGama_btc; text[100])
        {
            Caption = 'Desc. Gamma', comment = 'ESP="Desc. Gama"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(Gamma), NumReg = field(selGama_btc)));
        }
        field(50023; desLineaEconomica_btc; text[100])
        {
            Caption = 'Desc. Linea Economica', comment = 'ESP="Desc. Linea Economica"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(TextosAuxiliares.Descripcion where(TipoRegistro = const(Tabla), TipoTabla = const(LineaEconomica), NumReg = field(selLineaEconomica_btc)));
        }
        field(50030; Canal; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Zummo Canal de venta';
            Caption = 'Canal', comment = 'ESP="Canal"';
            OptionMembers = "Food Service","Retail";
            OptionCaption = 'Retail,Food Service', comment = 'ESP="Retail,Food Service"';
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
        field(50130; "Purch. Family"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purch. Family', comment = 'ESP="Familia compra"';
            TableRelation = "STH Purchase Family".Code;
        }
        field(50131; "Desc. Purch. Family"; Text[100])
        {
            Caption = 'Desc. Purch. Family', comment = 'ESP="Nombre Familia compra"';
            FieldClass = FlowField;
            CalcFormula = lookup("STH Purchase Family".Description where(Code = field("Purch. Family")));
            Editable = false;
        }
        field(50132; "Purch. Category"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purch. Category', comment = 'ESP="Categoria compra"';
            TableRelation = "STH Purchase Category".Code where("Purch. Familiy code" = field("Purch. Family"));
        }
        field(50133; "Desc. Purch. Category"; Text[100])
        {
            Caption = 'Desc. Purch. Category', comment = 'ESP="Nombre Categoria compra"';
            FieldClass = FlowField;
            CalcFormula = lookup("STH Purchase Category".Description where("Purch. Familiy code" = field("Purch. Family"), Code = field("Purch. Category")));
            Editable = false;
        }
        field(50134; "Purch. SubCategory"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purch. SubCategory', comment = 'ESP="SubCategoria compra"';
            TableRelation = "STH Purchase SubCategory".Code where("Purch. Familiy code" = field("Purch. Family"), "Purch. Category code" = field("Purch. Category"));
        }
        field(50135; "Desc. Purch. SubCategory"; Text[100])
        {
            Caption = 'Desc. Purch. SubCategory', comment = 'ESP="Nombre SubCategoria compra"';
            FieldClass = FlowField;
            CalcFormula = lookup("STH Purchase SubCategory".Description where("Purch. Familiy code" = field("Purch. Family"),
                "Purch. Category code" = field("Purch. Category"), code = field("Purch. SubCategory")));
            Editable = false;
        }
        field(50156; Manufacturer; text[100])
        {
            Caption = 'Manufacturer', comment = 'ESP="Fabricante"';
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Fabricante), TipoRegistro = const(Tabla));
        }
        field(50157; "Item No. Manufacturer"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No. Manufacturer', comment = 'ESP="Cód. Fabricante"';

        }
        Field(50200; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic packing (kg)', comment = 'ESP="Plástico embalaje (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
        }
        Field(50201; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Recycled packing (kg)', comment = 'ESP="Plástico reciclado embalaje(kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
        }
        Field(50202; "Recycled plastic %"; decimal)
        {
            Caption = 'Plastic Recycled packing %', comment = 'ESP="% Plástico reciclado embalaje"';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        Field(50203; "Packing Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Package Plastic (kg)', comment = 'ESP="Plástico Bulto (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
        }
        Field(50204; "Packing Recycled plastic (kg)"; decimal)
        {
            Caption = 'Package Recycled Plastic (kg)', comment = 'ESP="Plástico reciclado Bulto (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
        }
        Field(50205; "Packing Recycled plastic %"; decimal)
        {
            Caption = 'Package Plastic %', comment = 'ESP="% Plástico reciclado Bulto"';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
        field(50206; Steel; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Steel Packing (kg)', comment = 'ESP="Acero Embalaje (kg)"';
            Description = 'Acero que se utiliza para el envío del producto';
        }
        field(50207; Carton; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Carton Packing (kg)', comment = 'ESP="Cartón Embalaje (kg)"';
        }
        field(50208; Wood; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Wood Packing (kg)', comment = 'ESP="Madera Embalaje (kg)"';
        }
        field(50210; "Show detailed documents"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show detailed documents', comment = 'ESP="Mostrar en detalle documentos"';
        }
        field(50211; "Packaging product"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Packaging product', comment = 'ESP="Producto de bulto"';
        }
        field(50212; "Vendor Packaging product"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Plastic packing (kg)', comment = 'ESP="Plástico embalaje proveedor (kg)"';
            ObsoleteState = Removed;
            ObsoleteReason = 'Sustuido por 50215';
        }
        field(50215; "Vendor Packaging product KG"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Plastic packing (kg/ud)', comment = 'ESP="Plástico embalaje proveedor (kg/ud)"';
            DecimalPlaces = 6 : 6;
        }
        field(50216; "Vendor Packaging Steel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Steel Packing (kg)', comment = 'ESP="Acero Embalaje proveedor(kg)"';
            Description = 'Acero que se utiliza para el envío del producto';
            DecimalPlaces = 6 : 6;
        }
        field(50217; "Vendor Packaging Carton"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Carton Packing (kg)', comment = 'ESP="Cartón Embalaje proveedor (kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50218; "Vendor Packaging Wood"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Wood Packing (kg)', comment = 'ESP="Madera Embalaje proveedor (kg)"';
            DecimalPlaces = 6 : 6;
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
        // field(50805; EnglishDescription; text[100])
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'English Description', comment = 'ESP="Descripción Ingles"';
        // }
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
            TableRelation = Employee;
            ValidateTableRelation = true;
            Editable = false;

            trigger OnValidate()
            begin
                OnValidate_CodEmpleado();
            end;
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
        field(50830; "Modified"; Boolean)
        {
            Caption = 'Modified', comment = 'ESP="Modificado"';
        }
        field(50840; "E-mail sent"; Boolean)
        {
            Caption = 'E-mail sent', comment = 'ESP="Email enviado"';
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


    trigger OnInsert()
    begin
        GetPreItemSetup();
        SetupPreItemReg.TESTFIELD("Temporary Nos.");
        if "No." = '' then begin
            NoSeriesMgt.InitSeries(SetupPreItemReg."Temporary Nos.", xRec."Nos. series", 0D, Rec."No.", Rec."Nos. series");
        end;
        InitRecord();
    end;

    trigger OnModify()
    begin
        InitRecord();
    end;

    trigger OnDelete()
    begin
        Rec.TestField("ITBID Status", Rec."ITBID Status"::" ");
        ZMCIMProdBOMHeader.Reset();
        if ZMCIMProdBOMHeader.Get(Rec."Production BOM No.") then
            ZMCIMProdBOMHeader.Delete(true);
        ZMItemPurchasePrices.Reset();
        ZMItemPurchasePrices.SetRange("Item No.", Rec."No.");
        ZMItemPurchasePrices.DeleteAll();
    end;

    trigger OnRename()
    begin
    end;

    var
        Item: Record Item;
        Vend: Record Vendor;
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
        ZMCIMProdBOMHeader: Record "ZM CIM Prod. BOM Header";
        ZMCIMProdBOMLine: Record "ZM CIM Prod. BOM Line";
        ZMItemPurchasePrices: Record "ZM PL Item Purchase Prices";
        ItemSetupApproval: Record "ZM PL Item Setup Approval";
        ItemSetupDepartment: Record "ZM PL Item Setup Department";
        Employee: Record Employee;
        SetupPreItemReg: record "ZM PL Setup Item registration";
        TempBlob: Record TempBlob;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AutLoginMgt: Codeunit "AUT Login Mgt.";
        Funciones: Codeunit Funciones;
        Text027: Label 'must be greater than 0.', Comment = 'ESP="Debe ser mayor que 0"';
        lblConfirmBOM: Label 'El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?', comment = 'ESP="El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?"';
        lblConfirmUpdateItem: Label 'El producto %1 %2 ya existe, si actualiza se perderan los datos temporales actuales.\¿Desea actualizar los datos?',
            comment = 'ESP="El producto %1 %2 ya existe, si actualiza se perderan los datos temporales actuales.\¿Desea actualizar los datos?"';

    local procedure GetPreItemSetup()
    begin
        SetupPreItemReg.GET;
    end;

    procedure AssistEdit(): Boolean
    begin
        GetPreItemSetup;
        SetupPreItemReg.TESTFIELD("Temporary Nos.");
        if NoSeriesMgt.SelectSeries(SetupPreItemReg."Temporary Nos.", xRec."Nos. Series", "Nos. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            EXIT(TRUE);
        end;
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

    local procedure InitRecord()
    begin
        Modified := true;
        if Rec."Posting Date" = 0D then
            Rec."Posting Date" := WorkDate();
        if "User ID" = '' then
            Rec."User ID" := GetCodEmpleado();
        Rec.validate("Codigo Empleado", AutLoginMgt.GetEmpleado());
        Rec."E-mail sent" := false;
    end;

    local procedure GetCodEmpleado(): code[50]
    begin
        exit(copystr(UserId, 1, MaxStrLen(Rec."User ID")));
    end;

    local procedure OnLookup_Product_Manager()
    begin
        Page.RunModal(0, Employee);
    end;

    local procedure OnValidate_CodEmpleado()
    var
    begin
        "Nombre Empleado" := '';
        if Employee.Get(Rec."Codigo Empleado") then
            "Nombre Empleado" := copystr(Employee.FullName(), 1, MaxStrLen(Rec."Nombre Empleado"));
    end;

    local procedure OnValidate_ItemNo()
    begin
        GetPreItemSetup();
        if "No." <> xRec."No." then begin
            InitRecord();
            if Rec."No." = '' then begin
                NoSeriesMgt.TestManual(SetupPreItemReg."Temporary Nos.");
            end else begin
                // comprobamos si existe el producto y traemos los datos para su modificación                
                item.Reset();
                if item.Get(Rec."No.") then begin
                    if Confirm(lblConfirmUpdateItem, false, Rec."No.", Item.Description) then begin
                        Rec.TransferFields(Item);
                        Rec."ITBID Status" := Rec."ITBID Status"::Created;
                    end;
                    // comprobamos si el producto tiene lista de Producción orignal
                    ProdBOMHeader.Reset();
                    ProdBOMHeader.SetRange("No.", Rec."Production BOM No.");
                    if ProdBOMHeader.FindFirst() then
                        // if Confirm(lblConfirmBOM, false, Rec."No.", Rec.Description) then
                            UpdateProductionBom(Item."No.");
                    UpdatePurchasePrice(Rec."No.");

                end;
            end;

        end;
    end;

    procedure UpdateProductionBom(ItemNo: code[20])
    begin
        Item.Reset();
        if Item.Get(Rec."No.") then begin
            ProdBOMHeader.Reset();
            ProdBOMHeader.SetRange("No.", ItemNo);
            if ProdBOMHeader.FindFirst() then begin
                ZMCIMProdBOMHeader.Reset();
                if not ZMCIMProdBOMHeader.Get(ProdBOMHeader."No.") then begin
                    ZMCIMProdBOMHeader.Init();
                    ZMCIMProdBOMHeader.TransferFields(ProdBOMHeader);
                    ZMCIMProdBOMHeader.Insert();

                end;
                UpdateProductionBomLM(ZMCIMProdBOMHeader."No.");
            end;
        end;
    end;

    local procedure UpdateProductionBomLM(BOMHeaderNo: code[20])
    var
        myInt: Integer;
    begin
        ProdBOMLine.Reset();
        ProdBOMLine.SetRange("Production BOM No.", BOMHeaderNo);
        if ProdBOMLine.FindFirst() then
            repeat
                ZMCIMProdBOMLine.Reset();
                if ZMCIMProdBOMLine.Get(ProdBOMLine."Production BOM No.", ProdBOMLine."Version Code", ProdBOMLine."Line No.") then begin
                    ZMCIMProdBOMLine."Quantity per" := ProdBOMLine."Quantity per";
                    ZMCIMProdBOMLine.Quantity := ProdBOMLine.Quantity;
                    ZMCIMProdBOMLine.Modify();
                end else begin
                    ZMCIMProdBOMLine.Init();
                    ZMCIMProdBOMLine.TransferFields(ProdBOMLine);
                    ZMCIMProdBOMLine.Insert();
                end;
            Until ProdBOMLine.next() = 0;
    end;

    local procedure UpdatePurchasePrice(ItemNo: code[20])
    var
        PurchasePrices: Record "Purchase Price";
    begin
        PurchasePrices.Reset();
        PurchasePrices.SetRange("Item No.", ItemNo);
        if PurchasePrices.FindFirst() then
            repeat
                ZMCIMProdBOMLine.Reset();
                if not ZMItemPurchasePrices.Get() then begin
                    ZMItemPurchasePrices.Init();
                    ZMItemPurchasePrices.TransferFields(PurchasePrices);
                    ZMItemPurchasePrices.Insert();
                end;
            Until PurchasePrices.next() = 0;
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

    procedure ITBIDUpdate(): Boolean
    var
        Item: Record Item;
        zummoFunctions: Codeunit "STH Zummo Functions";
        JsonText: Text;
        IsUpdate: Boolean;
    begin
        Rec.TestField("ITBID Create", true);
        JsonText := zummoFunctions.GetJSON_ItemTemporay(Rec);
        zummoFunctions.PutBody(JsonText, Rec."No.", IsUpdate);
        if IsUpdate then begin
            Rec."STH To Update" := false;
            Rec."STH Last Update Date" := Today;
            Rec."ITBID Status" := Rec."ITBID Status"::Created;
            Rec.Modify();
        end;
        exit(IsUpdate);
    end;

    procedure Navigate_PostedItemList()
    var
        PostedItemstemporarylist: page "Posted PL Items temporary list";
    begin
        PostedItemstemporarylist.Run;
    end;

    procedure LaunchRegisterItemTemporary()
    var
        lblConfirm: Label '¿Desea Solicitar el alta/modificacion del producto %1 "%2"?', comment = 'ESP="¿Desea Solicitar el alta/modificacion del producto %1 "%2"?"';
        lblRelease: Label 'La solicitud ya ha sido enviada.\', comment = 'ESP="La solicitud ya ha sido enviada.\"';
        lblError: Label 'El estado de la solicitud de %1 %2 es %3', comment = 'ESP="El estado de la solicitud de %1 %2 es %3"';
    begin
        Rec.TestField(Reason);
        case Rec."State Creation" of
            Rec."State Creation"::" ":
                begin
                    if not Confirm(lblConfirm, false, Rec."No.", Rec.Description) then
                        exit;
                end;
            Rec."State Creation"::Requested, Rec."State Creation"::Released:
                begin
                    if not Confirm(lblRelease + lblConfirm, false, Rec."No.", Rec.Description) then
                        exit;
                end;
            Rec."State Creation"::Finished:
                Error(lblError, Rec."No.", Rec.Description);
        end;


        // enviamos la solicitud para la alta de los productos.
        // primero aprobacion planificacion de la alta de producto en ITBID y envio de alta de campos a los departamentos
        // if Rec."ITBID Status" in [Rec."ITBID Status"::" "] then
        //     SendItemTemporaryFirstRegister()
        // else
        SendItemTemporaryRegister();

    end;

    local procedure SendItemTemporaryFirstRegister()
    var
        Employee: Record Employee;
        RefRecord: RecordRef;
        Recipients: text;
        lblErrorNotApprovals: Label 'No existen aprobadores configurados para la tabla %1.', comment = 'ESP="No existen aprobadores configurados para la tabla %1."';
        lblConfirmEmail: Label 'La solicitud del alta ya ha sido enviada.\¿Desea volver a enviarla?', comment = 'ESP="La solicitud del alta ya ha sido enviada.\¿Desea volver a enviarla?"';
    begin
        RefRecord.GetTable(Rec);
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Approval, ItemSetupApproval.Rol::Both);
        if not ItemSetupApproval.FindFirst() then
            Error(lblErrorNotApprovals, Rec.TableCaption);
        // preparamos la tabla para los aprobadores y enviamos email
        if ItemSetupApproval.FindFirst() then
            repeat
                if ItemSetupDepartment.get(ItemSetupApproval.Department) then begin
                    if ItemSetupDepartment.Email <> '' then begin
                        if Recipients <> '' then
                            Recipients += ';';
                        Recipients += ItemSetupDepartment.Email;
                    end;
                    // miramos los empleados que tienen ese departamento
                    Employee.Reset();
                    Employee.SetRange("Approval Department User Id", ItemSetupDepartment."User Id");
                    if Employee.FindFirst() then
                        repeat
                            if Recipients <> '' then
                                Recipients += ';';
                            Recipients += Employee."Company E-Mail";
                        Until Employee.next() = 0;
                end;
            Until ItemSetupApproval.next() = 0;

        if Recipients = '' then
            Error(lblErrorNotApprovals, Rec.TableCaption);

        if Rec."E-mail sent" then
            if not Confirm(lblConfirmEmail) then
                exit;
        SendMailItemTemporaryFirstRegister(Recipients);
        Rec."E-mail sent" := true;
        Rec."State Creation" := Rec."State Creation"::Requested;
        Rec.Modify();
    end;

    procedure SendMailItemTemporaryFirstRegister(Recipients: Text)
    var
        SalesHeader2: Record "Sales Header";
        Quotepdf: Report PedidoCliente;
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Subject: text;
        Body: text;
        SubjectLbl: Label 'Solicitud de Alta de Producto - %1 (%2)';
    begin
        SMTPMailSetup.Get();
        SMTPMailSetup.TestField("User ID");
        Subject := StrSubstNo(SubjectLbl, Rec."No.", Rec.Description);
        Body := EnvioEmailBody;
        // enviamos el email 
        SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", Recipients, Subject, Body, true);
        SMTPMail.Send();
    end;

    local procedure EnvioEmailBody() Body: Text
    var
        Companyinfo: Record "Company Information";
        Employee: Record Employee;
        RefRecord: RecordRef;
        xRefRecord: RecordRef;
        CodEmpleado: code[20];
        Color: text;
    begin
        Companyinfo.Get();
        CodEmpleado := AutLoginMgt.GetEmpleado();
        if Employee.Get(CodEmpleado) then;
        Body := '<p>&nbsp;</p>';
        Body += '<h1 style="color: #5e9ca0;">' + Companyinfo.Name + '</h1>';
        Body += '<h2 style="color: #2e6c80;">Solicitud de Alta de Producto No.: ' + Rec."No." + '</h2>';
        Body += '<h3 style="color: #2e6c80;">Usuario: ' + StrSubstNo('%1 (%2)', Employee.FullName(), CodEmpleado) + '</h3>';
        Body += '<p><strong>' + Rec.FieldCaption(Description) + '</strong>: ' + Rec.Description + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Base Unit of Measure") + '</strong>: ' + Rec."Base Unit of Measure" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(Type) + '</strong>: ' + format(Rec.Type) + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(Blocked) + '</strong>: ' + format(Rec.Blocked) + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Reason Blocked") + '</strong>: ' + Rec."Reason Blocked" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("ITBID Status") + '</strong>: ' + format(Rec."ITBID Status") + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("User ID") + '</strong>: ' + Rec."User ID" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Codigo Empleado") + '</strong>: ' + Rec."Codigo Empleado" + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(Reason) + '</strong>: ' + Rec.GetWorkDescription() + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption("Posting Date") + '</strong>: ' + format(Rec."Posting Date") + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(Activity) + '</strong>: ' + Rec.Activity + '</p>';
        Body += '<p><strong>' + Rec.FieldCaption(Prototype) + '</strong>: ' + Rec.Prototype + '</p>';
        if Item.Get(Rec."No.") then begin
            RefRecord.GetTable(Rec);
            xRefRecord.GetTable(Item);
            Body += CheckChangesRec(RefRecord, xRefRecord);
        end;
    end;

    local procedure CheckChangesRec(RefRecord: RecordRef; xRefRecord: RecordRef) Changes: Text
    var
        RefField: FieldRef;
        xRefField: FieldRef;
        FieldCount: Integer;
        Count: Integer;
        I: Integer;
    begin
        for i := 1 to 60000 do begin
            if xRefRecord.FieldExist(i) then
                FieldCount += 1;
        end;
        for i := 1 to FieldCount do begin
            xRefField := xRefRecord.FieldIndex(i);
            if RefRecord.FieldExist(xRefField.Number) then begin
                RefField := RefRecord.Field(xRefField.Number);
                if xRefField.Value <> RefField.Value then
                    Changes += '<p><strong>' + xRefField.Caption + '</strong>: ' + StrSubstNo('%1 (antes: %2)', xRefField.Value, RefField.Value) + '</p>';
            end;
        end;
        if Changes <> '' then
            Changes := '<h3 style="color: #2e6c80;">Cambios:</h3>' + Changes;

    end;

    local procedure SendItemTemporaryRegister()
    var
        myInt: Integer;
    begin

    end;

    procedure NavigateItemsReview()
    var
        ItemstemporaryReview: Record "ZM PL Items temporary";
        Itemstemporaryreviewlist: page "ZM Items temporary Review list";
        Result: Boolean;
        lblError: Label 'No existe ningun producto pendiente de revision del departamento %1.', comment = 'ESP="No existe ningun producto pendiente de revision del departamento %1."';
    begin
        ItemstemporaryReview.reset;
        if ItemstemporaryReview.FindFirst() then
            repeat
                Result := CheckItemsTemporary(Rec);
                ItemstemporaryReview.Mark(Result)
            Until ItemstemporaryReview.next() = 0;
        ItemstemporaryReview.MarkedOnly(true);
        if ItemstemporaryReview.Count = 0 then
            Error(lblError, "User ID");
        Itemstemporaryreviewlist.SetTableView(ItemstemporaryReview);
        Itemstemporaryreviewlist.RunModal();
    end;

    local procedure CheckItemsTemporary(ItemstemporaryReview: Record "ZM PL Items temporary"): Boolean
    var
        myInt: Integer;
    begin

    end;
}