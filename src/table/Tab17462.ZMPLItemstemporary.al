table 17462 "ZM PL Items Temporary"
{
    DataClassification = CustomerContent;
    Caption = 'Items temporary', comment = 'ESP="Alta productos temporales"';
    LookupPageId = "ZM PL Items temporary list";
    DrillDownPageId = "ZM PL Items temporary list";
    Permissions = tabledata "Change Log Entry" = rmid;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Request No.', Comment = 'ESP="Nº Solicitud"';

            trigger OnValidate()
            begin
                OnValidate_No();

                ChangeFieldNo(Rec.FieldNo("No."));
            end;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if Rec."Request Type" in [Rec."Request Type"::New, Rec."Request Type"::Change] then
                    SetupPreItemReg.CheckMaxLengthItemNo(Rec."Item No.");
                OnValidate_ItemNo();

                ChangeFieldNo(Rec.FieldNo("Item No."));
            end;
        }

        field(3; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';

            trigger OnValidate()
            begin
                OnValidate_Description();

                ChangeFieldNo(Rec.FieldNo(Description));
            end;
        }
        field(6; "Assembly BOM"; Boolean)
        {
            Caption = 'Assembly BOM', Comment = 'ESP="L.M. de Ensamblado"';

            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Assembly BOM"));
            end;
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure', Comment = 'ESP="Unidad medida base"';
            TableRelation = "Unit of Measure";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Base Unit of Measure"));
            end;
        }
        field(10; Type; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Type', comment = 'ESP="Tipo"';
            OptionCaption = 'Inventory,Service,Non-Inventory', comment = 'ESP="Inventario,Servicio,Fuera de inventario"';
            OptionMembers = Inventory,Service,"Non-Inventory";
            Editable = false;

            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Type));
            end;
        }
        field(11; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group', Comment = 'ESP="Grupo registro inventario"';
            TableRelation = "Inventory Posting Group";

            trigger OnValidate()
            begin
                IF "Inventory Posting Group" <> '' THEN
                    TESTFIELD(Type, Type::Inventory);

                ChangeFieldNo(Rec.FieldNo("Inventory Posting Group"));

            end;
        }
        field(14; "Item Disc. Group"; Code[20])
        {
            Caption = 'Item Disc. Group', Comment = 'ESP="Grupo dto. producto"';
            TableRelation = "Item Discount Group";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Item Disc. Group"));
            end;
        }
        field(18; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price', Comment = 'ESP="Precio venta"';
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Unit Price"));
            end;
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

                ChangeFieldNo(Rec.FieldNo("Costing Method"));

            end;
        }
        field(22; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost', Comment = 'ESP="Coste unitario"';
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Unit Cost"));
            end;
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

                ChangeFieldNo(Rec.FieldNo("Vendor No."));

            end;
        }
        field(32; "Vendor Item No."; Text[20])
        {
            Caption = 'Vendor Item No.', Comment = 'ESP="Cód. producto proveedor';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Vendor Item No."));
            end;
        }
        field(33; "Lead Time Calculation"; DateFormula)
        {
            AccessByPermission = TableData 120 = R;
            Caption = 'Lead Time Calculation', Comment = 'ESP="Plazo entrega (días)"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Lead Time Calculation"));
            end;
        }
        field(34; "Reorder Point"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Reorder Point', Comment = 'ESP="Punto pedido"';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Reorder Point"));
            end;
        }
        field(35; "Maximum Inventory"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Maximum Inventory', Comment = 'ESP="Stock máximo"';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Maximum Inventory"));
            end;
        }
        field(36; "Reorder Quantity"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Reorder Quantity', Comment = 'ESP="Cantidad a pedir"';
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Reorder Quantity"));
            end;
        }
        field(37; "Alternative Item No."; Code[20])
        {
            Caption = 'Alternative Item No.', Comment = 'ESP="Nº producto alternativo"';
            TableRelation = Item;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Alternative Item No."));
            end;
        }
        field(41; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight', Comment = 'ESP="Peso bruto"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Gross Weight"));
            end;
        }
        field(42; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight', Comment = 'ESP="Peso neto"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Net Weight"));
            end;
        }
        field(43; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel', Comment = 'ESP="Unidades por lote"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Units per Parcel"));
            end;
        }
        field(44; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume', Comment = 'ESP="Volumen"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Unit Volume"));
            end;
        }
        field(45; Durability; Code[10])
        {
            Caption = 'Durability', Comment = 'ESP="Duración"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Durability));
            end;
        }
        field(46; "Freight Type"; Code[10])
        {
            Caption = 'Freight Type', Comment = 'ESP="Tipo flete"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Freight Type"));
            end;
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

                ChangeFieldNo(Rec.FieldNo("Tariff No."));

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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Blocked));
            end;
        }
        field(90; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)', Comment = 'ESP="Gr.regis. IVA negocio (precio)"';
            TableRelation = "VAT Business Posting Group";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("VAT Bus. Posting Gr. (Price)"));
            end;
        }
        field(91; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group', Comment = 'ESP="Grupo registro prod. gen."';
            TableRelation = "Gen. Product Posting Group";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Gen. Prod. Posting Group"));
            end;
        }
        field(92; Picture; MediaSet)
        {
            Caption = 'Picture', Comment = 'ESP="Imagen"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Picture));
            end;
        }
        field(97; "Nos. series"; code[20])
        {
            Caption = 'Nos. series', Comment = 'ESP="Nº. Series"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Nos. series"));
            end;
        }
        field(99; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group', Comment = 'ESP="Grupo registro IVA prod."';
            TableRelation = "VAT Product Posting Group";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("VAT Prod. Posting Group"));
            end;
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

                ChangeFieldNo(Rec.FieldNo(Reserve));

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

                ChangeFieldNo(Rec.FieldNo("Assembly Policy"));

            end;
        }
        field(1217; GTIN; Code[14])
        {
            Caption = 'GTIN', Comment = 'ESP="GTIN"';
            Numeric = true;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(GTIN));
            end;
        }
        field(5402; "Serial Nos."; Code[20])
        {
            Caption = 'Serial Nos.';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "Serial Nos." <> '' THEN
                    TESTFIELD("Item Tracking Code");

                ChangeFieldNo(Rec.FieldNo("Serial Nos."));

            end;
        }
        field(5411; "Minimum Order Quantity"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Minimum Order Quantity', Comment = 'ESP="Cantidad mínima pedido"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Minimum Order Quantity"));
            end;
        }
        field(5412; "Maximum Order Quantity"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Maximum Order Quantity', Comment = 'ESP="Cantidad máxima pedido"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Maximum Order Quantity"));
            end;
        }
        field(5413; "Safety Stock Quantity"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Safety Stock Quantity', Comment = 'ESP="Stock de seguridad"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Safety Stock Quantity"));
            end;
        }
        field(5414; "Order Multiple"; Decimal)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Order Multiple', Comment = 'ESP="Múltiplos de pedido"';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Order Multiple"));
            end;
        }
        field(5415; "Safety Lead Time"; DateFormula)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Safety Lead Time', Comment = 'ESP="Plazo de seguridad"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Safety Lead Time"));
            end;
        }
        field(5417; "Flushing Method"; Option)
        {
            AccessByPermission = TableData 5405 = R;
            Caption = 'Flushing Method', Comment = 'ESP="Método de baja"';
            OptionCaption = 'Manual,Forward,Backward,Pick + Forward,Pick + Backward', Comment = 'ESP="Manual,Adelante,Atrás,Pick + Adelante,Pick + Atrás"';
            OptionMembers = Manual,Forward,Backward,"Pick + Forward","Pick + Backward";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Flushing Method"));
            end;

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

                ChangeFieldNo(Rec.FieldNo("Replenishment System"));

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

                ChangeFieldNo(Rec.FieldNo("Rounding Precision"));

            end;
        }
        field(5425; "Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure', Comment = 'ESP="Unidad medida venta"';
            TableRelation = IF ("No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Sales Unit of Measure"));
            end;
        }
        field(5426; "Purch. Unit of Measure"; Code[10])
        {
            Caption = 'Purch. Unit of Measure', Comment = 'ESP="Unidad medida compra"';
            TableRelation = IF ("No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Purch. Unit of Measure"));
            end;
        }
        field(5428; "Time Bucket"; DateFormula)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Time Bucket', Comment = 'ESP="Ciclo"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Time Bucket"));
            end;
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

                ChangeFieldNo(Rec.FieldNo("Reordering Policy"));

            end;
        }
        field(5441; "Include Inventory"; Boolean)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Include Inventory', Comment = 'ESP="Incluir inventario"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Include Inventory"));
            end;
        }
        field(5442; "Manufacturing Policy"; Option)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Manufacturing Policy', Comment = 'ESP="Directiva fabricación"';
            OptionCaption = 'Make-to-Stock,Make-to-Order', Comment = 'ESP="Fab-contra-stock,Fab-contra-pedido"';
            OptionMembers = "Make-to-Stock","Make-to-Order";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Manufacturing Policy"));
            end;
        }
        field(5443; "Rescheduling Period"; DateFormula)
        {
            AccessByPermission = TableData 244 = R;
            Caption = 'Rescheduling Period', Comment = 'ESP="Periodo de reprogramación"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Rescheduling Period"));
            end;

        }
        field(5701; "Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code', Comment = 'ESP="Cód. fabricante"';
            TableRelation = Manufacturer;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Manufacturer Code"));
            end;
        }
        field(5702; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code', Comment = 'ESP="Cód. categoría producto"';
            TableRelation = "Item Category";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Item Category Code"));
            end;
        }
        field(5900; "Service Item Group"; Code[10])
        {
            Caption = 'Service Item Group', Comment = 'ESP="Grupo prod. servicio"';
            TableRelation = "Service Item Group".Code;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Service Item Group"));
            end;
        }
        field(6500; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code', Comment = 'ESP="Cód. seguim. prod."';
            TableRelation = "Item Tracking Code";
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Item Tracking Code"));
            end;
        }
        field(6501; "Lot Nos."; Code[20])
        {
            Caption = 'Lot Nos.', Comment = 'ESP="Nº serie lote"';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                IF "Lot Nos." <> '' THEN
                    TESTFIELD("Item Tracking Code");

                ChangeFieldNo(Rec.FieldNo("Lot Nos."));

            end;
        }
        field(6502; "Expiration Calculation"; DateFormula)
        {
            Caption = 'Expiration Calculation', Comment = 'ESP="Cálculo caducidad"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Expiration Calculation"));
            end;
        }
        field(8003; "Sales Blocked"; Boolean)
        {
            Caption = 'Sales Blocked', Comment = 'ESP="Ventas bloqueadas"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Sales Blocked"));
            end;
        }
        field(8004; "Purchasing Blocked"; Boolean)
        {
            Caption = 'Purchasing Blockedtco', Comment = 'ESP="Compras bloqueadas"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Purchasing Blocked"));
            end;
        }
        field(50014; selClasVtas_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Sales Classification', comment = 'ESP="Clasificación Ventas"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClasificacionVentas"), TipoRegistro = const(Tabla));
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(selClasVtas_btc));
            end;

        }

        field(50015; selFamilia_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Family', comment = 'ESP="Familia"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Familia"), TipoRegistro = const(Tabla));
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(selFamilia_btc));
            end;

        }

        field(50016; selGama_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Gamma', comment = 'ESP="Gama"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Gamma"), TipoRegistro = const(Tabla));
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(selGama_btc));
            end;
        }
        field(50017; selLineaEconomica_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Linea Economica', comment = 'ESP="Linea Economica"';
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("LineaEconomica"), TipoRegistro = const(Tabla));
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(selLineaEconomica_btc));
            end;
        }
        field(50018; "ABC"; Option)
        {
            Editable = true;
            Caption = 'ABC', comment = 'ESP="ABC"';
            OptionMembers = " ",ContraStock,BajoPedido;
            OptionCaption = ' ,A,B,C,D', comment = 'ESP=" ,A,B,C,D"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(ABC));
            end;
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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Canal));
            end;
        }
        field(50080; "CMMF Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CMMF Code', comment = 'ESP="CMMF Code"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("CMMF Code"));
            end;
        }
        field(50081; "SEB PI2 Code"; code[15])
        {
            DataClassification = CustomerContent;
            Caption = 'PI2 Code', comment = 'ESP="PI2 Code"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("SEB PI2 Code"));
            end;
        }
        field(50082; "SEB PI2 Description"; Text[40])
        {
            DataClassification = CustomerContent;
            Caption = 'PI2 Description', comment = 'ESP="PI2 Description"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("SEB PI2 Description"));
            end;
        }
        field(50083; "SEB PI2 Description English"; Text[40])
        {
            DataClassification = CustomerContent;
            Caption = 'PI2 Description English', comment = 'ESP="PI2 Description English"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("SEB PI2 Description English"));
            end;
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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Material));
            end;
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

            trigger OnValidate()
            begin
                if xRec."ITBID Create" then
                    Rec.TestField("ITBID Status", Rec."ITBID Status"::" ");
            end;
        }
        field(50130; "Purch. Family"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purch. Family', comment = 'ESP="Familia compra"';
            TableRelation = "STH Purchase Family".Code;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Purch. Family"));
            end;
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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Purch. Category"));
            end;
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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Purch. SubCategory"));
            end;
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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Manufacturer));
            end;
        }
        field(50157; "Item No. Manufacturer"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No. Manufacturer', comment = 'ESP="Cód. Fabricante"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Item No. Manufacturer"));
            end;

        }
        Field(50200; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic packing (kg)', comment = 'ESP="Plástico embalaje (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Plastic Qty. (kg)"));
            end;
        }
        Field(50201; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Recycled packing (kg)', comment = 'ESP="Plástico reciclado embalaje(kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Recycled plastic Qty. (kg)"));
            end;
        }
        Field(50202; "Recycled plastic %"; decimal)
        {
            Caption = 'Plastic Recycled packing %', comment = 'ESP="% Plástico reciclado embalaje"';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Recycled plastic %"));
            end;
        }
        Field(50203; "Packing Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Package Plastic (kg)', comment = 'ESP="Plástico Bulto (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Packing Plastic Qty. (kg)"));
            end;
        }
        Field(50204; "Packing Recycled plastic (kg)"; decimal)
        {
            Caption = 'Package Recycled Plastic (kg)', comment = 'ESP="Plástico reciclado Bulto (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Packing Recycled plastic (kg)"));
            end;
        }
        Field(50205; "Packing Recycled plastic %"; decimal)
        {
            Caption = 'Package Plastic %', comment = 'ESP="% Plástico reciclado Bulto"';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Packing Recycled plastic %"));
            end;
        }
        field(50206; Steel; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Steel Packing (kg)', comment = 'ESP="Acero Embalaje (kg)"';
            Description = 'Acero que se utiliza para el envío del producto';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Steel));
            end;
        }
        field(50207; Carton; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Carton Packing (kg)', comment = 'ESP="Cartón Embalaje (kg)"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Carton));
            end;
        }
        field(50208; Wood; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Wood Packing (kg)', comment = 'ESP="Madera Embalaje (kg)"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Wood));
            end;
        }
        field(50210; "Show detailed documents"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Show detailed documents', comment = 'ESP="Mostrar en detalle documentos"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Show detailed documents"));
            end;
        }
        field(50211; "Packaging product"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Packaging product', comment = 'ESP="Producto de bulto"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Packaging product"));
            end;
        }
        field(50215; "Vendor Packaging product KG"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Plastic packing (kg/ud)', comment = 'ESP="Plástico embalaje proveedor (kg/ud)"';
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Vendor Packaging product KG"));
            end;
        }
        field(50216; "Vendor Packaging Steel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Steel Packing (kg)', comment = 'ESP="Acero Embalaje proveedor(kg)"';
            Description = 'Acero que se utiliza para el envío del producto';
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Vendor Packaging Steel"));
            end;
        }
        field(50217; "Vendor Packaging Carton"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Carton Packing (kg)', comment = 'ESP="Cartón Embalaje proveedor (kg)"';
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Vendor Packaging Carton"));
            end;
        }
        field(50218; "Vendor Packaging Wood"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Wood Packing (kg)', comment = 'ESP="Madera Embalaje proveedor (kg)"';
            DecimalPlaces = 6 : 6;
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Vendor Packaging Wood"));
            end;
        }
        field(50800; "Clasification Type"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Clasification Type', comment = 'ESP="Clasificación"';
            OptionCaption = ' ,Raw Material/Item,Service,Item Out of stock', comment = 'ESP=" ,Materia Prima/Productos,Servicio,Productos sin Stock"';
            OptionMembers = " ",Inventory,Service,"Non-Inventory";
            Editable = false;

            trigger OnValidate()
            begin
                case Rec."Clasification Type" of
                    Rec."Clasification Type"::Inventory:
                        Rec.Type := Rec.Type::Inventory;
                    Rec."Clasification Type"::"Non-Inventory":
                        Rec.Type := Rec.Type::"Non-Inventory";
                    Rec."Clasification Type"::Service:
                        Rec.Type := Rec.Type::Service;
                end;
                ChangeFieldNo(Rec.FieldNo("Clasification Type"));
            end;
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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Packaging));
            end;
        }
        field(50807; Color; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Color', comment = 'ESP="Color"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Color));
            end;
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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Department));
            end;
        }
        field(50821; "Product manager"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Product manager', comment = 'ESP="Responsable"';

            trigger OnLookup()
            begin
                OnLookup_Product_Manager();

                ChangeFieldNo(Rec.FieldNo("Product manager"));

            end;
        }
        field(50822; Reason; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Reason', comment = 'ESP="Motivo"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Reason));
            end;
        }
        field(50823; Activity; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Activity', comment = 'ESP="Actividad"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Activity));
            end;
        }
        field(50824; Prototype; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prototype', comment = 'ESP="Prototipo"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Prototype));
            end;
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
            ValidateTableRelation = false;
            // Editable = false;
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
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Reason Blocked"));
            end;
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
        field(50831; "Requires Final Artwork"; Boolean)
        {
            Caption = 'Requires Final Artwork', comment = 'ESP="Requiere Arte Final"';
        }
        field(50840; "E-mail sent"; Boolean)
        {
            Caption = 'E-mail sent', comment = 'ESP="Email enviado"';
        }
        field(50850; "GUID Creation"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'State Creation', comment = 'ESP="Estado Alta"';
            Editable = false;
        }
        field(50860; "Request Type"; Option)
        {
            Caption = 'Request Type', comment = 'ESP="Tipo Solicitud"';
            OptionMembers = " ",New,Change,Blocked,Unlocking,Delete;
            OptionCaption = ' ,New,Change,Blocked,Unlocking,Delete', Comment = 'ESP=" ,Nuevo,Cambio,Bloqueo,Desbloqueo,Eliminación"';
        }
        field(65100; "Sujeto a Control de Calidad"; Boolean)
        {
            Caption = 'Sujeto a Control de Calidad', comment = 'ESP="Sujeto a Control de Calidad"';  // 65100
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Sujeto a Control de Calidad"));
            end;
        }
        field(50871; "Control Certificado proveedor"; Boolean)
        {
            Caption = 'Control Certificado proveedor', comment = 'ESP="Control Certificado proveedor"';  // 65110
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Control Certificado proveedor"));
            end;
        }

        field(59001; Largo; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Largo (mm)', comment = 'ESP="Largo (mm)"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Largo));
            end;
        }
        field(59002; Ancho; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Ancho (mm)', comment = 'ESP="Ancho (mm)"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Ancho));
            end;
        }
        field(59003; Alto; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Alto (mm)', comment = 'ESP="Alto (mm)"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo(Alto));
            end;
        }
        field(59010; "IS Requested"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("ZM PL Item Setup Approval" where("Table No." = const(17462), "Field No." = const(0), "User Id" = field("User ID Filter")));
        }
        field(59020; "User ID Filter"; code[50])
        {
            FieldClass = FlowFilter;
        }
        field(50930; "Production BOM Lines"; integer)
        {
            Caption = 'Production BOM Lines', Comment = 'ESP="Líneas L.M. producción"';
            FieldClass = FlowField;
            CalcFormula = count("ZM CIM Prod. BOM Line" where("Production BOM No." = field("Production BOM No.")));
            Editable = false;
        }
        field(99000750; "Routing No."; Code[20])
        {
            Caption = 'Routing No.', Comment = 'ESP="Nº ruta"';
            trigger OnValidate()
            begin
                ChangeFieldNo(Rec.FieldNo("Routing No."));
            end;
        }
        field(99000751; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.', Comment = 'ESP="Nº L.M. producción"';
            TableRelation = "ZM CIM Prod. BOM Header";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                OnValidate_ProductionBOMNo();

                ChangeFieldNo(Rec.FieldNo("Production BOM No."));

            end;
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

        // ItemsRegistration.LogInsertion(Rec);
    end;

    trigger OnModify()
    begin
        // InitRecord();
    end;

    trigger OnDelete()
    begin
        // Rec.TestField("ITBID Status", Rec."ITBID Status"::" ");
        case Rec."State Creation" of
            Rec."State Creation"::Released, Rec."State Creation"::Requested:
                begin
                    if not Confirm('El producto ya se ha enviado para su revisión.\¿Desea eliminarlo igualmente') then
                        error('Cancelado por usuario')
                end;

        end;
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
        ItemsRegistration: Codeunit "ZM PL Items Regist. aprovals";
        Text027: Label 'must be greater than 0.', Comment = 'ESP="Debe ser mayor que 0"';
        lblConfirmNewCopy: Label '¿Do you want to create a new product with the data from %1 %2?', comment = 'ESP="¿Desea crear nuevo Producto con los datos de %1 %2?"';
        lblItemExist: Label 'El producto %1 ya existe %2, no se puede indicar Tipo solicitud %3', comment = 'ESP="El producto %1 ya existe %2, no se puede indicar Tipo solicitud %3"';
        lblConfirmBOM: Label 'El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?', comment = 'ESP="El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?"';
        lblConfirmUpdateItem: Label 'El producto %1 %2 ya existe, si actualiza se perderan los datos temporales actuales.\¿Desea actualizar los datos?',
            comment = 'ESP="El producto %1 %2 ya existe, si actualiza se perderan los datos temporales actuales.\¿Desea actualizar los datos?"';

        lblErrorNotApprovals: Label 'No existen aprobadores configurados para la tabla %1.', comment = 'ESP="No existen aprobadores configurados para la tabla %1."';
        lblConfirmEmail: Label 'La solicitud del alta ya ha sido enviada.\¿Desea volver a enviarla?', comment = 'ESP="La solicitud del alta ya ha sido enviada.\¿Desea volver a enviarla?"';
        lblErrorItemExitst: Label 'Product %1 already exists %2', comment = 'ESP="El producto %1 ya exites %2"';


    local procedure ChangeFieldNo(FieldNo: Integer)
    var

    begin
        ItemsRegistration.LogModification(Rec, FieldNo);
    end;

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
        if IsNullGuid(Rec."GUID Creation") then
            Rec."GUID Creation" := CreateGuid();
        Modified := true;
        if Rec."Posting Date" = 0D then
            Rec."Posting Date" := WorkDate();
        if "User ID" = '' then
            Rec."User ID" := GetCodEmpleado();
        Rec.validate("Codigo Empleado", AutLoginMgt.GetEmpleado());
        Rec."E-mail sent" := false;
        UpdateDepartmentsApprovals();
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

    local procedure OnValidate_No()
    var
        myInt: Integer;
    begin
        GetPreItemSetup();
        if "No." <> xRec."No." then begin
            InitRecord();
            if Rec."No." = '' then begin
                NoSeriesMgt.TestManual(SetupPreItemReg."Temporary Nos.");
            end;
        end;
    end;

    local procedure OnValidate_ItemNo()
    begin
        case Rec."Request Type" of
            Rec."Request Type"::New:
                Begin
                    // comprobamos que si existe el producto de un error
                    if Item.Get(Rec."Item No.") then
                        Error(lblErrorItemExitst, Rec."Item No.", Item.Description);
                End;
            Rec."Request Type"::Blocked, Rec."Request Type"::Change, Rec."Request Type"::Delete, Rec."Request Type"::Unlocking:
                begin
                    // comprobamos si existe el producto y traemos los datos para su modificación     
                    UpdateItem();
                end;
        end;
    end;

    local procedure OnValidate_Description()
    var
        myInt: Integer;
    begin
        if Rec."Request Type" in [Rec."Request Type"::New, Rec."Request Type"::Change] then
            SetupPreItemReg.CheckMaxLengthItemDescription(Rec.Description);
    end;

    procedure CopyItem()
    var
        OldRequestNo: code[20];
    begin
        Rec.TestField("Item No.");
        Rec.TestField("Request Type", Rec."Request Type"::New);
        OldRequestNo := Rec."Item No.";
        if not confirm(lblConfirmNewCopy, false, Item."No.", item.Description) then
            exit;
        Rec.TransferFields(Item);
        Rec."No." := OldRequestNo;
        Rec."ITBID Status" := Rec."ITBID Status"::" ";
        Rec.CalcFields(Reason);
        Clear(Rec.Reason);
        Rec.Blocked := false;
        case Item.type of
            Item.type::Inventory:
                Rec.Type := Rec.Type::Inventory;
            Item.type::"Non-Inventory":
                Rec.Type := Rec.Type::"Non-Inventory";
            Item.type::Service:
                Rec.Type := Rec.Type::Service;
        end;
        UpdateItemExtendedFields(Item."No.");
        // comprobamos si el producto tiene lista de Producción orignal
        ProdBOMHeader.Reset();
        ProdBOMHeader.SetRange("No.", Item."Production BOM No.");
        if ProdBOMHeader.FindFirst() then
            // if Confirm(lblConfirmBOM, false, Rec."No.", Rec.Description) then
            UpdateProductionBom(Item."Production BOM No.");
        UpdatePurchasePrice(Rec."No.");
    end;

    procedure UpdateProductionBom(ItemNo: code[20])
    begin
        ZMCIMProdBOMHeader.Reset();
        if not ZMCIMProdBOMHeader.Get(ProdBOMHeader."No.") then begin
            ZMCIMProdBOMHeader.Init();
            ZMCIMProdBOMHeader.TransferFields(ProdBOMHeader);
            ZMCIMProdBOMHeader."No." := Rec."Item No.";
            ZMCIMProdBOMHeader.Insert();
        end;
        UpdateProductionBomLM(ZMCIMProdBOMHeader."No.", ProdBOMHeader);
        Rec."Production BOM No." := Rec."Item No.";
    end;

    local procedure UpdateProductionBomLM(BOMHeaderNo: code[20]; ProdBOMHeader: Record "Production BOM Header")
    begin
        ProdBOMLine.Reset();
        ProdBOMLine.SetRange("Production BOM No.", ProdBOMHeader."No.");
        if ProdBOMLine.FindFirst() then
            repeat
                ZMCIMProdBOMLine.Reset();
                if ZMCIMProdBOMLine.Get(BOMHeaderNo, ProdBOMLine."Version Code", ProdBOMLine."Line No.") then begin
                    ZMCIMProdBOMLine."Quantity per" := ProdBOMLine."Quantity per";
                    ZMCIMProdBOMLine.Quantity := ProdBOMLine.Quantity;
                    ZMCIMProdBOMLine.Modify();
                end else begin
                    ZMCIMProdBOMLine.Init();
                    ZMCIMProdBOMLine.TransferFields(ProdBOMLine);
                    ZMCIMProdBOMLine."Production BOM No." := BOMHeaderNo;
                    ZMCIMProdBOMLine.Insert();
                end;
            Until ProdBOMLine.next() = 0;
    end;

    local procedure OnValidate_ProductionBOMNo()
    var
        lblConfirm: Label '¿Desea renombrar la lista de materiales a %1?', comment = 'ESP="¿Desea renombrar la lista de materiales a %1?"';
    begin
        if Rec."Production BOM No." <> xRec."Production BOM No." then
            if not Confirm(lblConfirm, false, Rec."Production BOM No.") then begin
                Rec."Production BOM No." := xRec."Production BOM No.";
                exit;
            end;
        if Rec."Production BOM No." = xRec."Production BOM No." then
            exit;
        if not ZMCIMProdBOMHeader.Get(xRec."Production BOM No.") then
            exit;
        ZMCIMProdBOMHeader.Rename(Rec."Production BOM No.");
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
        if Rec."Production BOM No." = '' then begin
            Rec."Production BOM No." := Rec."Item No.";
            Rec.Modify();
        end;
        if not ZMProdBOM.Get(Rec."Production BOM No.") then begin
            ZMProdBOM.Init();
            ZMProdBOM."No." := Rec."Production BOM No.";
            ZMProdBOM.Description := Rec.Description;
            ZMProdBOM."Unit of Measure Code" := Rec."Base Unit of Measure";
            ZMProdBOM.Insert();
        end;
        ZMProdBOM.SetRange("No.", Rec."Production BOM No.");
        ZMProductionBOMList.SetTableView(ZMProdBOM);
        ZMProductionBOMList.Run();
    end;

    procedure Navigate_PurchasesPrices()
    var
        ZMItemPurchasePrice: record "ZM PL Item Purchase Prices";
        ZMItemPurchasesPrices: page "ZM PL Item Purchases Prices";
    begin
        ZMItemPurchasePrice.SetRange("Item No.", Rec."Item No.");
        ZMItemPurchasesPrices.SetTableView(ZMItemPurchasePrice);
        ZMItemPurchasesPrices.SetItemNo(Rec."Item No.");
        ZMItemPurchasesPrices.Run();
    end;

    procedure ITBIDUpdate(): Boolean
    var
        Item: Record Item;
        zummoFunctions: Codeunit "STH Zummo Functions";
        JsonText: Text;
        ItemNo: code[20];
        IsUpdate: Boolean;
    begin
        Rec.TestField("ITBID Create", true);
        JsonText := zummoFunctions.GetJSON_ItemTemporay(Rec, ItemNo);
        // zummoFunctions.PutBody(JsonText, ItemNo, IsUpdate);
        // TODO comentamos para que no suba a ITBID
        Message(StrSubstNo('ITBID Update %1\%2', ItemNo, JsonText));
        IsUpdate := true;
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

    procedure LaunchRegisterItemTemporary(Requested: Boolean)
    var
        ItemApprovalDepartment: Record "ZM Item Approval Department";
        Dpto: code[20];
        RField: fieldRef;
        lblRequestError: Label 'You must select a value in %1.', comment = 'ESP="Debe seleccionar un valor en %1."';
        lblConfirm: Label '¿Desea Solicitar el alta/modificacion del producto %1 "% %32"?', comment = 'ESP="¿Desea Solicitar el alta/modificacion del producto %1 "%2 %4"?"';
        lblRelease: Label '¿Desea enviar la revisión de los departamentos para %1\ %2 %3?', comment = 'ESP="¿Desea enviar la revisión de los departamentos para %1\ %2 %3?"';
        lblError: Label 'El estado de la solicitud de %1 %2 es %3', comment = 'ESP="El estado de la solicitud de %1 %2 es %3"';
    begin
        Rec.TestField(Reason);
        // Check Request Type
        if Rec."Request Type" in [Rec."Request Type"::" "] then
            Error(lblRequestError, Rec.FieldCaption("Request Type"));
        if rec."State Creation" in [Rec."State Creation"::Finished] then
            Error(lblError, Rec."No.", Rec.Description);
        CheckItemsTemporary(Dpto);
        case Requested of
            false:  // lanzamiento por el primer usuario que lo crea
                begin
                    CheckObligatoryFieldsUser(true);
                    if not Confirm(lblConfirm, false, Rec."No.", Rec."Item No.", Rec.Description) then
                        exit;
                    SendItemTemporaryFirstRegister();
                end;
            else begin
                if not Confirm(lblRelease, false, Rec."No.", rec."Item No.", Rec.Description) then
                    exit;
                SendItemTemporaryRegister();
                Rec.UpdateStatusReleased();
                ItemApprovalDepartment.CreateRequestDepartment(Rec);
            end;
        end;
    end;

    // =============SendItemTemporaryFirstRegister====================
    // ==  
    // ==  solicitud al departamento de planificacion del alta de productos
    // ==  
    // ======================================================================================================
    local procedure SendItemTemporaryFirstRegister()
    var
        Employee: Record Employee;
        Recipients: text;
        CodEmpleado: code[20];
    begin
        CodEmpleado := AutLoginMgt.GetEmpleado();
        SetupPreItemReg.Get();
        SetupPreItemReg.TestField("First Department");
        if ItemSetupDepartment.get(SetupPreItemReg."First Department") then begin
            if ItemSetupDepartment.Email <> '' then begin
                if Recipients <> '' then
                    Recipients += ';';
                Recipients += ItemSetupDepartment.Email;
            end;
            // miramos los empleados que tienen ese departamento
            if ItemSetupDepartment."User Id" <> '' then begin
                Employee.Reset();
                Employee.SetRange("Approval Department User Id", ItemSetupDepartment."User Id");
                if Employee.FindFirst() then
                    repeat
                        if Recipients <> '' then
                            Recipients += ';';
                        Recipients += Employee."Company E-Mail";
                    Until Employee.next() = 0;
            end;
        end;
        if Recipients = '' then
            Error(lblErrorNotApprovals, Rec.TableCaption);

        // añadimos los usuarios del departamento que crea
        Employee.Reset();
        Employee.SetRange("User Id", UserId);
        if Employee.FindFirst() then
            repeat
                if Recipients <> '' then
                    Recipients += ';';
                Recipients += Employee."Company E-Mail";
            Until Employee.next() = 0;
        Employee.Reset();
        if Employee.get(CodEmpleado) then begin
            if Recipients <> '' then
                Recipients += ';';
            Recipients += Employee."Company E-Mail";
        end;

        if Rec."E-mail sent" then
            if not Confirm(lblConfirmEmail) then
                exit;
        SendMailItemTemporaryFirstRegister(Recipients, ItemSetupDepartment.Code);
        Rec."E-mail sent" := true;
        Rec."State Creation" := Rec."State Creation"::Requested;
        Rec.Modify();
    end;

    procedure SendMailItemTemporaryFirstRegister(Recipients: Text; Department: code[20])
    var
        SalesHeader2: Record "Sales Header";
        Quotepdf: Report PedidoCliente;
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Subject: text;
        Body: text;
        SubjectLbl: Label 'Solicitud de Alta de Producto - %1 (%2 - %3)';
    begin
        SMTPMailSetup.Get();
        SMTPMailSetup.TestField("User ID");
        Subject := StrSubstNo(SubjectLbl, Rec."No.", rec."Item No.", Rec.Description);
        Body := EnvioEmailBody(Subject, Department);
        // enviamos el email 
        SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", Recipients, Subject, Body, true);
        SMTPMail.Send();
    end;

    local procedure EnvioEmailBody(Subject: text; Department: code[20]) Body: Text
    var
        Companyinfo: Record "Company Information";
        Employee: Record Employee;
        CodEmpleado: code[20];
        Color: text;
    begin
        Companyinfo.Get();
        CodEmpleado := AutLoginMgt.GetEmpleado();
        if Employee.Get(CodEmpleado) then;
        Body := '<p>&nbsp;</p>';
        Body += '<h1 style="color: #5e9ca0;">' + Companyinfo.Name + '</h1>';
        Body += '<h2 style="color: #2e6c80;">' + Subject + '</h2>';
        Body += '<h3 style="color: #2e6c80;">Product Manager: ' + Rec."Product manager" + '</h3>';
        Body += '<h3 style="color: #2e6c80;">USER: ' + Rec."User ID" + '</h3>';
        Body += '<h3 style="color: #2e6c80;">Usuario: ' + StrSubstNo('%1 (%2)', Employee.FullName(), CodEmpleado) + '</h3>';
        Body += '<h4 style="color: #2e6c80;">Departamento Revision: ' + Department + '</h4>';
        Body += '<p><strong>' + Rec.FieldCaption("Item No.") + '</strong>: ' + Rec."Item No." + '</p>';
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
        if Rec."Request Type" in [Rec."Request Type"::Change] then
            Body += CheckChangesRec();
    end;

    local procedure CheckChangesRec() Changes: Text
    var
        ChangeLogEntry: Record "Change Log Entry";
        RefRecord: RecordRef;
    begin
        RefRecord.Open(Database::Item);
        ChangeLogEntry.Reset();
        ChangeLogEntry.SetRange("Table No.", Database::"ZM PL Items Temporary");
        ChangeLogEntry.SetRange("Primary Key Field 1 Value", Rec."No.");
        if ChangeLogEntry.FindFirst() then
            repeat
                if ChangeLogEntry."Field No." > 2 then
                    if RefRecord.FieldExist(ChangeLogEntry."Field No.") then begin
                        ChangeLogEntry.CalcFields("Field Caption");
                        Changes += '<p><strong>' + ChangeLogEntry."Field Caption" + '</strong>: ' + StrSubstNo('%1 (<span style="color: #ff0000;">antes: %2</span>)', ChangeLogEntry."New Value", ChangeLogEntry."Old Value") + '</p>';
                    end;
            Until ChangeLogEntry.next() = 0;
        if Changes <> '' then
            Changes := '<h3 style="color: #2e6c80;">Cambios:</h3>' + Changes;

    end;
    // =============SendItemTemporaryRegister====================
    // ==  
    // ==  Lanzamos el circuito de que los usuarios tengan cosas pendientes de revisar 
    // ==  
    // ======================================================================================================
    local procedure SendItemTemporaryRegister()
    var
        tmpEmployee: Record Employee temporary;
        tmpItemDepartment: Record "ZM PL Item Setup Department" temporary;
        RefRecord: RecordRef;
        Recipients: text;
        Sending: Boolean;
        Numreg: Integer;
    begin
        RefRecord.GetTable(Rec);
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetRange(Requester, false);
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Approval, ItemSetupApproval.Rol::Both);
        if not ItemSetupApproval.FindFirst() then
            Error(lblErrorNotApprovals, Rec.TableCaption);
        // preparamos la tabla para los aprobadores y enviamos email
        if ItemSetupApproval.FindFirst() then
            repeat
                if not tmpItemDepartment.get(ItemSetupApproval.Department) then
                    if ItemSetupDepartment.Get(ItemSetupApproval.Department) then begin
                        tmpItemDepartment.Init();
                        tmpItemDepartment.TransferFields(ItemSetupDepartment);
                        tmpItemDepartment.Insert();
                    end;
            until ItemSetupApproval.Next() = 0;
        if tmpItemDepartment.FindFirst() then
            repeat
                if tmpItemDepartment.Email <> '' then
                    Recipients := tmpItemDepartment.Email;

                // miramos los empleados que tienen ese departamento
                if tmpItemDepartment."User Id" <> '' then begin
                    Employee.Reset();
                    Employee.SetRange("Approval Department User Id", tmpItemDepartment."User Id");
                    if Employee.FindFirst() then
                        repeat
                            // comprobamos que no dupliquemos el empleado 
                            if not tmpEmployee.get(Employee."No.") then begin
                                if Recipients <> '' then
                                    Recipients += ';';
                                Recipients += Employee."Company E-Mail";
                                tmpEmployee.Init();
                                tmpEmployee.TransferFields(Employee);
                                tmpEmployee.Insert();
                            end;
                        Until Employee.next() = 0;
                end;
                if Recipients <> '' then begin
                    SendMailItemTemporaryRegister(tmpItemDepartment, Recipients);
                    Sending := true;
                end;
            Until tmpItemDepartment.next() = 0;
        if Sending then begin
            Rec."State Creation" := Rec."State Creation"::Requested;
            Rec.Modify();

        end;
    end;

    procedure SendMailItemTemporaryRegister(tmpItemDepartment: Record "ZM PL Item Setup Department"; Recipients: Text)
    var
        SalesHeader2: Record "Sales Header";
        Quotepdf: Report PedidoCliente;
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Subject: text;
        Body: text;
        SubjectLbl: Label 'Solicitud REVISION Alta de Producto para revision- %1 (%2 - %3)';
    begin
        SMTPMailSetup.Get();
        SMTPMailSetup.TestField("User ID");
        Subject := StrSubstNo(SubjectLbl, Rec."No.", rec."Item No.", Rec.Description);
        Body := EnvioEmailBody(Subject, tmpItemDepartment.Code);
        // enviamos el email 
        SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", Recipients, Subject, Body, true);
        SMTPMail.Send();
    end;

    procedure NavigateItemsReview()
    var
        ItemstemporaryReview: Record "ZM PL Items temporary";
        Itemstemporaryreviewlist: page "ZM Items temporary Review list";
        Department: code[20];
        Result: Boolean;
        lblError: Label 'No existe ningun producto pendiente de revision del departamento %1.', comment = 'ESP="No existe ningun producto pendiente de revision del departamento %1."';
    begin
        ItemstemporaryReview.reset;
        ItemstemporaryReview.SetRange("State Creation", ItemstemporaryReview."State Creation"::Released);
        if ItemstemporaryReview.FindFirst() then
            repeat
                Result := CheckItemsTemporary(Department);
                ItemstemporaryReview.Mark(Result)
            Until ItemstemporaryReview.next() = 0;
        ItemstemporaryReview.MarkedOnly(true);
        if ItemstemporaryReview.Count = 0 then
            Error(lblError, "User ID");
        Itemstemporaryreviewlist.SetTableView(ItemstemporaryReview);
        Itemstemporaryreviewlist.RunModal();
    end;

    local procedure GetDepartmentUser(): Code[20]
    var
        myInt: Integer;
    begin
        ItemSetupDepartment.Reset();
        ItemSetupDepartment.SetRange("User Id", UserId);
        if ItemSetupDepartment.FindSet() then
            exit(ItemSetupDepartment.Code);
    end;

    procedure CheckItemsTemporary(var Department: code[20]): Boolean
    var
        RefRecord: RecordRef;
    begin
        RefRecord.GetTable(Rec);
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetRange(Requester, false);
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Approval, ItemSetupApproval.Rol::Both);
        if ItemSetupApproval.FindFirst() then
            repeat
                if ItemSetupDepartment.get(ItemSetupApproval.Department) then
                    if ItemSetupDepartment."User Id" = UserId then begin
                        Department := ItemSetupDepartment.Code;
                        exit(true);
                    end;
            until ItemSetupApproval.Next() = 0;
    end;

    procedure CheckUserItemsCreate(): Boolean
    var
        RefRecord: RecordRef;
    begin
        RefRecord.GetTable(Rec);
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetRange("Field No.", 0);
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Owner, ItemSetupApproval.Rol::Both);
        if ItemSetupApproval.FindFirst() then
            repeat
                if ItemSetupDepartment.get(ItemSetupApproval.Department) then
                    if ItemSetupDepartment."User Id" = UserId then
                        exit(true);
            until ItemSetupApproval.Next() = 0;
    end;

    procedure CheckIsOwnerUser(): Boolean
    begin
        GetPreItemSetup();
        ItemSetupDepartment.Reset();
        ItemSetupDepartment.SetRange("User Id", UserId);
        if ItemSetupDepartment.FindFirst() then
            repeat
                if SetupPreItemReg."Last Department" = ItemSetupDepartment.Code then
                    exit(True);
            Until ItemSetupDepartment.next() = 0;
    end;

    procedure UpdateStatusReleased()
    begin
        Rec.TestField("State Creation", Rec."State Creation"::Requested);
        Rec."State Creation" := Rec."State Creation"::Released;
        Rec.Modify();
    end;

    procedure UpdateItemRequest()
    var
        ItemApprovalDepartment: Record "ZM Item Approval Department";
        PermisosAut: Record "AUT Permisos";
        AutLoging: Codeunit "AUT Login Mgt.";
        RefRecord: RecordRef;
        Department: code[20];
        lblNotUserApproval: Label 'El usuario %1 del departamento %2, no tiene asignada ninguna aprobacion de campos.', comment = 'ESP="El usuario %1 del departamento %2, no tiene asignada ninguna aprobacion de campos."';
        lblConfirmUpdateRequest: Label '¿Desea confirmar la revisión de los campos asignados a %1 de %2?', comment = 'ESP="¿Desea confirmar la revisión de los campos asignados a %1 de %2?"';
        lblItBID: Label 'Se ha marcado la opcion de Crear ITBID.\¿Desea Crearlo?', comment = 'ESP="Se ha marcado la opcion de Crear ITBID.\¿Desea Crearlo?"';
    begin
        RefRecord.GetTable(Rec);
        CheckItemsTemporary(Department);
        if Department = '' then
            Error(lblNotUserApproval, UserId, Department);
        if not confirm(lblConfirmUpdateRequest, false, Userid, Department) then
            exit;
        if CheckUserReviewItemFieldNo(Department, Rec.FieldNo(Rec."ITBID Create")) then
            if Rec."ITBID Create" then
                if confirm(lblItBID) then
                    Rec.ITBIDUpdate();
        ItemApprovalDepartment.Reset();
        ItemApprovalDepartment.SetRange("Table No.", RefRecord.Number);
        ItemApprovalDepartment.SetRange(Department, Department);
        ItemApprovalDepartment.SetRange("Request No.", Rec."No.");
        if not ItemApprovalDepartment.FindFirst() then begin
            ItemApprovalDepartment.Init();
            ItemApprovalDepartment."Table No." := RefRecord.Number;
            ItemApprovalDepartment.Department := Department;
            ItemApprovalDepartment."Request No." := Rec."No.";
            ItemApprovalDepartment.Insert();
        end;
        ItemApprovalDepartment."Request Date" := WorkDate();
        AutLoging.GetAUTPermisosCodEmpleado(PermisosAut);
        ItemApprovalDepartment."Codigo Empleado" := PermisosAut."Codigo Empleado";
        ItemApprovalDepartment.Modify();

        if not UpdateDepartmentsApprovals() then begin
            // si no quedan revisiones, marcamos como revisado completamente
            Rec."State Creation" := Rec."State Creation"::"Create Pendindg";
            Rec.modify();
        end
    end;

    procedure CheckUserReviewItem(Dpto: code[20]): Boolean
    var
        ItemApprovalDepartment: Record "ZM Item Approval Department";
        RefRecord: RecordRef;
    begin
        RefRecord.GetTable(Rec);
        ItemApprovalDepartment.Reset();
        ItemApprovalDepartment.SetRange("Table No.", RefRecord.Number);
        ItemApprovalDepartment.SetRange("Request No.", Rec."No.");
        ItemApprovalDepartment.SetRange(Department, Dpto);
        if ItemApprovalDepartment.FindFirst() then
            if ItemApprovalDepartment."Request Date" <> 0D then
                exit(true);
    end;

    procedure CheckUserReviewItemFieldNo(Dpto: code[20]; fieldNo: Integer): Boolean
    var
        // ItemApprovalDepartment: Record "ZM Item Approval Department";
        RefRecord: RecordRef;
    begin
        // Vemos si tiene permiso aprobador de un campo en concreto, por ejemplo ITBID
        RefRecord.GetTable(Rec);
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetRange("Field No.", fieldNo);
        ItemSetupApproval.SetRange(Department, Dpto);
        if ItemSetupApproval.FindFirst() then
            exit(true);
    end;

    procedure CheckUserOwneerItem(): Boolean
    var
        ItemApprovalDepartment: Record "ZM Item Approval Department";
    begin
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", Rec.RecordId.TableNo);
        ItemSetupApproval.SetRange("Field No.", 0);
        if ItemSetupApproval.FindFirst() then
            repeat
                if ItemSetupDepartment.get(ItemSetupApproval.Department) then
                    if ItemSetupDepartment."User Id" = UserId then
                        exit(true);
            until ItemSetupApproval.Next() = 0;
    end;

    procedure UpdateDepartmentsApprovals() Pending: Boolean
    var
        ItemApprovalDepartment: Record "ZM Item Approval Department";
        RefRecord: RecordRef;
    begin
        RefRecord.GetTable(Rec);
        ItemApprovalDepartment.Reset();
        ItemApprovalDepartment.SetRange("Table No.", RefRecord.Number);
        ItemApprovalDepartment.SetRange("Request No.", Rec."No.");
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetFilter("Field No.", '>0');
        ItemSetupApproval.SetRange(Requester, false);
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Approval, ItemSetupApproval.Rol::Both);
        if ItemSetupApproval.FindFirst() then
            repeat
                ItemApprovalDepartment.SetRange(Department, ItemSetupApproval.Department);
                if not ItemApprovalDepartment.FindFirst() then begin
                    ItemApprovalDepartment.Init();
                    ItemApprovalDepartment."Table No." := RefRecord.Number;
                    ItemApprovalDepartment.Department := ItemSetupApproval.Department;
                    ItemApprovalDepartment."Request No." := Rec."No.";
                    ItemApprovalDepartment.Insert();
                    Pending := true;
                end else
                    if ItemApprovalDepartment."Request Date" = 0D then
                        Pending := true;
            until ItemSetupApproval.Next() = 0;
    end;

    procedure SendMailItemTemporaryFinalize()
    var
        SetupItemregistration: Record "ZM PL Setup Item registration";
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Subject: text;
        Body: text;
        Recipients: text;
        SubjectLbl: Label 'COMPLETADA Solicitud de Alta de Producto (Pdte. alta producto)- %1 (%2)';
    begin
        SetupItemregistration.Get();
        if ItemSetupDepartment.get(SetupPreItemReg."Last Department") then begin
            if ItemSetupDepartment.Email <> '' then begin
                if Recipients <> '' then
                    Recipients += ';';
                Recipients += ItemSetupDepartment.Email;
            end;
            // miramos los empleados que tienen ese departamento
            if ItemSetupDepartment."User Id" <> '' then begin
                Employee.Reset();
                Employee.SetRange("Approval Department User Id", ItemSetupDepartment."User Id");
                if Employee.FindFirst() then
                    repeat
                        if Recipients <> '' then
                            Recipients += ';';
                        Recipients += Employee."Company E-Mail";
                    Until Employee.next() = 0;
            end;
        end;
        // otros usuarios como mejora y quique
        GetDepartmentNewItemRecipients(Recipients);

        if Recipients = '' then
            Recipients := 'jvidal@zummo.es';

        // recogemos los usuarios finales configurados
        SMTPMailSetup.Get();
        SMTPMailSetup.TestField("User ID");
        Subject := StrSubstNo(SubjectLbl, Rec."No.", Rec.Description);
        Body := EnvioEmailBody(Subject, Department);
        // enviamos el email 
        SMTPMail.CreateMessage(CompanyName, SMTPMailSetup."User ID", Recipients, Subject, Body, true);
        SMTPMail.Send();
    end;

    local procedure GetDepartmentNewItemRecipients(var Recipients: text)
    var
        myInt: Integer;
    begin
        ItemSetupApproval.reset();
        ItemSetupApproval.SetRange(Rol, ItemSetupApproval.rol::"Confirm creation");
        if ItemSetupApproval.FindFirst() then
            repeat
                if ItemSetupDepartment.get(ItemSetupApproval.Department) then begin
                    if Recipients <> '' then
                        Recipients += ';';
                    Recipients += ItemSetupDepartment.Email;
                    // miramos los empleados que tienen ese departamento
                    if ItemSetupDepartment."User Id" <> '' then begin
                        Employee.Reset();
                        Employee.SetRange("Approval Department User Id", ItemSetupDepartment."User Id");
                        if Employee.FindFirst() then
                            repeat
                                if Recipients <> '' then
                                    Recipients += ';';
                                Recipients += Employee."Company E-Mail";
                            Until Employee.next() = 0;
                    end;
                end;
            Until ItemSetupApproval.next() = 0;
    end;

    local procedure UpdateItem()
    var
        OldRequestNo: code[20];
    begin
        OldRequestNo := Rec."No.";
        Item.Reset();
        Item.Get(Rec."Item No.");
        // if Confirm(lblConfirmUpdateItem, false, Rec."Item No.", Item.Description) then begin
        Rec.TransferFields(Item);
        Rec."No." := OldRequestNo;
        Rec."Item No." := Item."No.";
        Rec."ITBID Status" := Rec."ITBID Status"::Created;
        case Item.Type of
            Item.Type::Inventory:
                Rec."Clasification Type" := Rec."Clasification Type"::Inventory;
            Item.Type::"Non-Inventory":
                Rec."Clasification Type" := Rec."Clasification Type"::"Non-Inventory";
            Item.Type::Service:
                Rec."Clasification Type" := Rec."Clasification Type"::Service;
        end;
        UpdateItemExtendedFields(Item."No.");

        // comprobamos si el producto tiene lista de Producción orignal
        ProdBOMHeader.Reset();
        ProdBOMHeader.SetRange("No.", Rec."Production BOM No.");
        if ProdBOMHeader.FindFirst() then
            // if Confirm(lblConfirmBOM, false, Rec."No.", Rec.Description) then
            UpdateProductionBom(Item."No.");
        UpdatePurchasePrice(Rec."No.");
    end;

    procedure CreateItemTemporary()
    var
        PostedItemstemporary: Record "Posted PL Items temporary";
        lblConfirm: Label '¿Desea Crear/Actualizar el producto %1 - %2?', comment = 'ESP="¿Desea Crear/Actualizar el producto %1 - %2?"';
        lblConfirm1: Label 'El producto no ha pasado por revision de departamentos.\', comment = 'ESP="El producto no ha pasado por revision de departamentos.\"';
        lblConfirmNew: Label 'El producto %1 no existe y el estado es %2.\', comment = 'ESP="El producto %1 no existe y el estado es %2.\"';
    begin
        Item.Reset();
        if Rec."State Creation" in [Rec."State Creation"::"Create Pendindg"] then begin
            if not confirm(lblConfirm, false, Rec."No.", Rec.Description) then
                exit;
        end else begin
            if not Rec.UpdateDepartmentsApprovals() then
                if not confirm(lblConfirm1 + lblConfirm, false, Rec."No.", Rec.Description) then
                    exit;
        end;
        case Rec."Request Type" of
            Rec."Request Type"::New:
                CreateNewItem();
            else
                if not Item.Get(Rec."Item No.") then
                    if confirm(lblConfirmNew + lblConfirm, false, Rec."Item No.", Rec."State Creation") then
                        CreateNewItem();
        end;

        UpdateItemTranslation();

        UpdateItemLM();

        // update Precios de compra TODO


        PostedItemstemporary.Init();
        PostedItemstemporary.TransferFields(Rec);
        PostedItemstemporary.Insert();
        Rec.Delete();
        // enviamos email de alta pendiente
        SendMailItemTemporaryFinalize();
    end;

    local procedure CreateNewItem()
    var

    begin
        if not Item.Get(Rec."Item No.") then begin
            // aqui creamos el nuevo producto
            Item.Reset();
            Item.Init();
            Item.TransferFields(Rec);
            Item.validate("No.", Rec."Item No.");
            Item.Insert();
        end;
        // guardamos el historico de alta de producto

        // actualizamos datos auxiliares,
        ItemUnitofMeasure();
    end;

    local procedure ItemUnitofMeasure()
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        // comprobamos si existe la unidad de medida y se crea, con los datos de medidas
        if not ItemUnitofMeasure.Get(Rec."Item No.", Rec."Base Unit of Measure") then begin
            ItemUnitofMeasure.Init();
            ItemUnitofMeasure."Item No." := Rec."Item No.";
            ItemUnitofMeasure.Code := Rec."Base Unit of Measure";
            ItemUnitofMeasure.Insert();
        end;
        ItemUnitofMeasure.Height := Rec.Alto;
        ItemUnitofMeasure.Weight := Rec.Ancho;
        ItemUnitofMeasure.Length := Rec.Largo;
        ItemUnitofMeasure.Cubage := Rec."Unit Volume";
        ItemUnitofMeasure.Modify();
    end;

    local procedure UpdateItemTranslation()
    var
        ItemTranslation: Record "Item Translation";
        ItemTranslationtemporary: Record "ZM Item Translation temporary";
    begin
        ItemTranslationtemporary.Reset();
        ItemTranslationtemporary.SetRange("Item No.", Rec."No.");
        if ItemTranslationtemporary.FindFirst() then
            repeat
                ItemTranslation.Reset();
                ItemTranslation.SetRange("Item No.", ItemTranslationtemporary."Item No.");
                ItemTranslation.SetRange("Language Code", ItemTranslationtemporary."Language Code");
                ItemTranslation.SetRange("Variant Code", ItemTranslationtemporary."Variant Code");
                if not ItemTranslation.FindFirst() then begin
                    ItemTranslation.Init();
                    ItemTranslation.TransferFields(ItemTranslationtemporary);
                    ItemTranslation.Insert();
                end else begin
                    ItemTranslation.TransferFields(ItemTranslationtemporary);
                    ItemTranslation.Modify();
                end;
            Until ItemTranslationtemporary.next() = 0;
    end;


    local procedure UpdateItemPurchasePrice()
    var
        PurchasePrice: Record "Purchase Price";
        PurchasePricetemporary: Record "ZM PL Item Purchase Prices";
    begin
        PurchasePricetemporary.Reset();
        PurchasePricetemporary.SetRange("Item No.", Rec."No.");
        if PurchasePricetemporary.FindFirst() then
            repeat
                PurchasePrice.Reset();
                PurchasePrice.SetRange("Item No.", PurchasePricetemporary."Item No.");
                if not PurchasePrice.FindFirst() then begin
                    PurchasePrice.Init();
                    PurchasePrice.TransferFields(PurchasePricetemporary);
                    PurchasePrice.Insert();
                end else begin
                    PurchasePrice.TransferFields(PurchasePricetemporary);
                    PurchasePrice.Modify();
                end;
            Until PurchasePricetemporary.next() = 0;
    end;

    local procedure UpdateItemLM()
    var
        ProdBomHeader: Record "Production BOM Header";
        ProdBomLine: Record "Production BOM Line";
        CIMProdBOMHeader: Record "ZM CIM Prod. BOM Header";
        CIMProdBOMLine: Record "ZM CIM Prod. BOM Line";
        lblConfir: Label 'Ya existe la lista de materiales %1, se elimanarán la lista y se cargará toda la lista.\¿Desea continuar?'
            , comment = 'ESP="Ya existe la lista de materiales %1, se elimanarán la lista y se cargará toda la lista.\¿Desea continuar?"';
    begin
        // Confirmar  que hacemos con las listas de materiales certificadas
        CIMProdBOMHeader.Reset();
        if CIMProdBOMHeader.Get(Rec."No.") then
            if not confirm(lblConfir, false, Rec."No.") then
                exit;
        CIMProdBOMHeader.SetRange("No.", Rec."No.");
        if CIMProdBOMHeader.FindFirst() then
            repeat
                ProdBomHeader.Reset();
                ProdBomHeader.SetRange("No.", CIMProdBomHeader."No.");
                if not ProdBomHeader.FindFirst() then begin
                    ProdBomHeader.Init();
                    ProdBomHeader.TransferFields(CIMProdBomHeader);
                    ProdBomHeader.Insert();
                end else begin
                    ProdBomHeader.TransferFields(CIMProdBomHeader);
                    ProdBomHeader.Modify();
                end;
                // Revisamos las líneas tambien
                // primero borramos todas las líneas actuales y creamos las nuevas
                ProdBomLine.SetRange("Production BOM No.", CIMProdBOMHeader."No.");
                ProdBomLine.DeleteAll();
                CIMProdBOMLine.Reset();
                CIMProdBOMLine.SetRange("Production BOM No.", CIMProdBOMHeader."No.");
                if CIMProdBOMLine.FindFirst() then
                    repeat
                        ProdBomLine.Init();
                        ProdBomLine.TransferFields(CIMProdBomLine);
                        ProdBomLine.Insert();
                    Until CIMProdBOMLine.next() = 0;
            Until CIMProdBOMHeader.next() = 0;
    end;


    procedure UploadExcel()
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Text000: label 'Cargar Fichero de Excel';
        NVInStream: InStream;
        FileName: Text;
        Sheetname: Text;
        UploadResult: Boolean;
        Rows: Integer;
    begin
        ExcelBuffer.DeleteAll();
        UploadResult := UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream);
        If FileName <> '' then
            Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream)
        else
            exit;

        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        // Commit();
        // ExcelBuffer.Reset();

        ExcelBuffer.SetRange("Column No.", 1);

        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";

        Message(StrSubstNo('Cargando Excel %1 de %2 filas', Sheetname, Rows));
    end;

    local procedure CheckObligatoryFieldsUser(Requested: Boolean)
    var
        RefRecord: RecordRef;
        CIMProdBOMHeader: record "ZM CIM Prod. BOM Header"; // (50134)
        CIMProdBOMLine: record "ZM CIM Prod. BOM Line"; //  (50158)
        PLItemPurchasePrices: record "ZM PL Item Purchase Prices"; //  (17398)
        ItemTranslationtemporary: record "ZM Item Translation temporary"; // (17420)
    begin
        RefRecord.GetTable(Rec);
        CheckObligatoryRecord(RefRecord);
        RefRecord.Close();
        // temporal Lista de materiales, header y lines
        if CIMProdBOMHeader.Get(Rec."Production BOM No.") then begin
            RefRecord.GetTable(CIMProdBOMHeader);
            CheckObligatoryRecord(RefRecord);
            RefRecord.Close();
            CIMProdBOMLine.SetRange("Production BOM No.", CIMProdBOMHeader."No.");
            if CIMProdBOMLine.FindFirst() then
                repeat
                    RefRecord.GetTable(CIMProdBOMLine);
                    CheckObligatoryRecord(RefRecord);
                    RefRecord.Close();
                Until CIMProdBOMLine.next() = 0;
        end;
        // temporal lista de precios de compras
        PLItemPurchasePrices.SetRange("Item No.", Rec."Item No.");
        if PLItemPurchasePrices.FindSet() then
            repeat
                RefRecord.GetTable(PLItemPurchasePrices);
                CheckObligatoryRecord(RefRecord);
                RefRecord.Close();
            Until PLItemPurchasePrices.next() = 0;
        //
    end;

    local procedure CheckObligatoryRecord(RefRecord: RecordRef)
    var
        myInt: Integer;
    begin
        ItemSetupApproval.Reset();
        ItemSetupApproval.SetRange("Table No.", RefRecord.Number);
        ItemSetupApproval.SetFilter("Field No.", '<>%1', 0);
        ItemSetupApproval.SetRange(Mandatory, true);
        // if Requested then
        //   ItemSetupApproval.SetRange("Approval Requester", true);
        ItemSetupApproval.SetFilter(Rol, '%1|%2', ItemSetupApproval.Rol::Owner, ItemSetupApproval.Rol::Both);
        if ItemSetupApproval.FindFirst() then
            repeat
                // if ItemSetupDepartment.get(ItemSetupApproval.Department) then
                //     if ItemSetupDepartment."User Id" = UserId then begin
                if ItemSetupApproval."Field No." > 0 then
                    CheckObligatoryField(RefRecord, ItemSetupApproval."Field No.");
            // end;
            until ItemSetupApproval.Next() = 0;

    end;

    local procedure CheckObligatoryField(RefRecord: RecordRef; FieldNo: Integer)
    var
        RefField: FieldRef;
    begin
        RefField := RefRecord.Field(FieldNo);
        RefField.TestField();
    end;

    procedure ValidateRequestType()
    begin
        Item.Reset();
        case Rec."Request Type" of
            Rec."Request Type"::Blocked:
                Item.SetRange(Blocked, false);
            Rec."Request Type"::Unlocking:
                Item.SetRange(Blocked, true);
            Rec."Request Type"::Change:
                if not (Page.RunModal(page::"Item Lookup", Item) = Action::LookupOK) then
                    exit;

        end;
        Rec.Validate("Item No.", Item."No.");
    end;

    procedure UpdateItemExtendedFields(ItemNo: code[20])
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        ItemUnitofMeasure.Reset();
        ItemUnitofMeasure.SetRange("Item No.", ItemNo);
        ItemUnitofMeasure.SetRange(Code, Item."Base Unit of Measure");
        if ItemUnitofMeasure.FindSet() then begin
            Rec.Largo := ItemUnitofMeasure.Length;
            Rec.Ancho := ItemUnitofMeasure.Weight;
            Rec.Alto := ItemUnitofMeasure.Height;
        end;
    end;

    procedure RunReport()
    var
        ItemRequest: Record "ZM PL Items Temporary";
        reportItemRequest: Report "Items Request";
    begin
        ItemRequest.SetRange("No.", Rec."No.");
        reportItemRequest.SetTableView(ItemRequest);
        reportItemRequest.Run();
    end;

    procedure CheckUserOwner() IsOwner: Boolean;
    begin
        SetupPreItemReg.Get();
        if not CheckUserOwneerItem() then
            exit;
        IsOwner := Rec."State Creation" = Rec."State Creation"::Requested;
    end;

    procedure CopySameItem(Item: Record Item)
    var
        tmpItemRequested: Record "ZM PL Items Temporary" temporary;
    begin
        tmpItemRequested := Rec;
        Rec."Request Type" := Rec."Request Type"::Change;
        Rec.TransferFields(Item);
        Rec."Request Type" := tmpItemRequested."Request Type";
        Rec.Description := tmpItemRequested.Description;
        Rec.Validate("Clasification Type", tmpItemRequested."Clasification Type");
        Rec.Department := tmpItemRequested.Department;
        Rec."Product manager" := tmpItemRequested."Product manager";
        Rec.Activity := tmpItemRequested.Activity;
        Rec."Posting Date" := tmpItemRequested."Posting Date";
        Rec.Prototype := tmpItemRequested.Prototype;
        Rec."Purch. Family" := tmpItemRequested."Purch. Family";
        Rec."Purch. Category" := tmpItemRequested."Purch. Category";
        Rec."Purch. SubCategory" := tmpItemRequested."Purch. SubCategory";
    end;

    procedure CheckIsApproved(DepartmentNo: code[20]): Boolean
    var
        ApprovalDepartment: Record "ZM Item Approval Department";
        RefRecord: RecordRef;
    begin
        RefRecord.GetTable(Rec);
        ApprovalDepartment.Reset();
        ApprovalDepartment.SetRange("Table No.", RefRecord.Number);
        ApprovalDepartment.SetRange("Request No.", Rec."No.");
        ApprovalDepartment.SetRange(Department, DepartmentNo);
        if ApprovalDepartment.FindFirst() then begin
            if ApprovalDepartment."Request Date" <> 0D then
                exit(true);
        end;
    end;
}