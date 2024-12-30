tableextension 50108 "Item" extends Item  //27
{
    fields
    {
        field(50000; ClasVtas_btc; enum ClasVtas)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Sales Classification', comment = 'ESP="Clasificación Ventas"';
            ObsoleteState = Removed;
        }

        field(50001; Familia_btc; enum Familia)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Family old', comment = 'ESP="Familia anterior"';
            ObsoleteState = Removed;
        }

        field(50002; Gama_btc; enum Gama)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Gamma', comment = 'ESP="Gama"';
            ObsoleteState = Removed;
        }

        field(50003; CentroTrabajp_btc; code[20])
        {
            Editable = false;
            Caption = 'Work Center', comment = 'ESP="Centro Trabajo"';
            FieldClass = FlowField;
            CalcFormula = lookup("Routing Line"."Work Center No." where("Routing No." = field("Routing No."), "Work Center No." = filter(<> '')));
            TableRelation = "Work Center";
        }

        field(50004; Ordenacion_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Ordination', comment = 'ESP="Ordenación"';
        }
        field(50005; ValidadoContabiliad_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Validated Accounting', comment = 'ESP="Validado contabilidad"';

            trigger OnValidate()
            var
                recUserSetup: Record "User Setup";
                lbNoConfUsuariosErr: Label 'User not has permission', comment = 'ESP="Usuario no permitido"';
            begin
                if (rec.ValidadoContabiliad_btc) and (xRec.ValidadoContabiliad_btc = false) then begin
                    if not recUserSetup.Get(UserId()) then
                        Error(lbNoConfUsuariosErr);

                    recUserSetup.TestField(PermiteValidarProcutos_bc);
                    Blocked := false;
                end else
                    if (rec.ValidadoContabiliad_btc = false) and (xRec.ValidadoContabiliad_btc) then
                        Blocked := true;
            end;
        }

        field(50006; OptClasVtas_btc; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Sales Classification List', comment = 'ESP="Lista Clasificación Ventas"';
            OptionMembers = " ","Envases y Embalajes",Accesorios,"Bloque Máquina",Box,"Conjunto Máquina",Mueble,Repuestos,Otros,Servicios;
            OptionCaption = ' ,Containers and packaging,Accessories,Machine block,Box,Machine set,Price of furniture,Spare parts,Others,Services', comment = 'ESP=" ,Envases y Embalajes,Accesorios,Bloque Máquina,Box,Conjunto Máquina,Mueble,Repuestos,Otros,Servicios"';
            //ObsoleteState = Removed;
        }

        field(50007; OptFamilia_btc; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Family old', comment = 'ESP="Familia anterior"';
            OptionMembers = " ",Z40,Z14,Z06,Z1,Z22,ZV25,Z10,KIOSKO;
            OptionCaption = ' ,Z40,Z14,Z06,Z1,Z22,ZV25,Z10,KIOSKO', comment = 'ESP=" ,Z40,Z14,Z06,Z1,Z22,ZV25,Z10,KIOSKO"';
            //ObsoleteState = Removed;
        }

        field(50008; OptGama_btc; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Gamma', comment = 'ESP="Gama"';
            OptionMembers = " ",NATURE,CLASSIC;
            OptionCaption = ' ,NATURE,CLASSIC', comment = 'ESP=" ,NATURE,CLASSIC"';
            //ObsoleteState = Removed;
        }

        field(50009; "QtyonQuotesOrder"; Decimal)
        {
            Editable = false;
            Caption = 'Cant. en ofertas de venta', comment = 'ESP="Cant. en ofertas de venta"';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Outstanding Quantity" where("Document Type" = const(Quote), FechaFinValOferta_btc = filter('>T')
            , Type = const(Item), "No." = field("No.")));
            TableRelation = "Sales Line";
            trigger OnLookup()
            var
                salesLine: Record "Sales Line";
                PSalesLine: Page "Sales Lines";
            begin
                salesLine.reset;
                salesLine.SetRange("Document Type", salesLine."Document Type"::Quote);
                salesLine.SetFilter("Outstanding Quantity", '>0');
                salesLine.SetRange("No.", Rec."No.");
                salesLine.SetFilter(FechaFinValOferta_btc, '>t');
                PSalesLine.SetTableView(salesLine);
                PSalesLine.Run();
            end;
        }

        field(50010; "ContraStock/BajoPedido"; Option)
        {
            Editable = true;
            Caption = 'ContraStock/BajoPedido', comment = 'ESP="ContraStock/BajoPedido"';
            OptionMembers = " ",ContraStock,BajoPedido;
            OptionCaption = ' ,ContraStock,BajoPedido', comment = 'ESP=" ,ContraStock,BajoPedido"';
        }

        field(50011; PedidoMaximo; Decimal)
        {
            Editable = true;
            Caption = 'Pedido Maximo', comment = 'ESP="Pedido Maximo"';
        }
        field(50012; "ProveedorBloqueado"; Boolean)
        {
            Editable = false;
            Caption = 'ProveedorBloqueado', comment = 'ESP="ProveedorBloqueado"';
            FieldClass = FlowField;
            CalcFormula = exist(Vendor where("No." = field("Vendor No."), Blocked = const(All)));

        }

        field(50013; "Cant_ componentes Oferta"; Decimal)
        {
            Editable = false;
            Caption = 'Cant. componentes Oferta', comment = 'ESP="Cant. componentes Oferta"';
            FieldClass = FlowField;
            CalcFormula = sum("Assembly Line"."Remaining Quantity"
            where
            ("Document Type" = const(Quote), "Fecha Fin Oferta_btc" = filter('>T')
            , Type = const(Item), "No." = field("No.")));
            TableRelation = "Assembly Line";
            trigger OnLookup()
            var
                salesLine: Record "Assembly Line";
                PSalesLine: Page "Assembly Lines";
            begin
                salesLine.reset;
                salesLine.SetRange("Document Type", salesLine."Document Type"::Quote);
                salesLine.SetFilter("Remaining Quantity", '>0');
                salesLine.SetRange("No.", Rec."No.");
                salesLine.SetFilter("Fecha Fin Oferta_btc", '>t');
                PSalesLine.SetTableView(salesLine);
                PSalesLine.Run();
            end;
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
        field(50019; TasaRAEE; Decimal)
        {
            Editable = true;
            Caption = 'Tasa RAEE ', comment = 'ESP="Tasa RAEE"';
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
        Field(50024; StockSeguridadBase; Decimal) // campo que guarda la politica BASE del stock de seguridad, para poder cambiar politicas segun necesidad
        {
            Caption = 'Stock de seguridad (Base)', comment = 'ESP="Stock de seguridad (Base)"';
        }
        field(50030; Canal; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Zummo Canal de venta';
            Caption = 'Canal', comment = 'ESP="Canal"';
            OptionMembers = "Food Service","Retail";
            OptionCaption = 'Retail,Food Service', comment = 'ESP="Retail,Food Service"';
        }
        field(50075; "Renovate Plan"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Renovate Plan (Cost. Serie)', comment = 'ESP="Plan Renove (Cost. Serie)"';

            trigger OnValidate()
            var
                ItemTracking: Record "Item Tracking Code";
                lblError: Label 'The product must have %1 enabled.', comment = 'ESP="El producto debe tener activado %1."';
            begin
                if not Rec."Renovate Plan" then begin
                    CheckSerialInfo();
                    exit;
                end;
                // comprobamos que tiene seguimiento Serie
                if ItemTracking.Get(Rec."Item Tracking Code") then
                    if ItemTracking."SN Specific Tracking" then
                        exit;
                Error(lblError, lblError);
            end;

        }
        field(50100; "STHQuantityWhse"; Decimal)
        {
            Caption = 'Quantity Warehouse', comment = 'ESP="Cantidad Almacén"';
            FieldClass = FlowField;
            CalcFormula = sum("Warehouse Entry"."Qty. (Base)" where("Item No." = field("No."), "Location Code" = field("Location Filter")));
            DecimalPlaces = 0 : 5;
        }
        Field(50101; "STHUseLocationGroup"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Usar Agrup. Almacenes', comment = 'ESP="Usar Agrup. Almacenes"';
        }
        field(50102; STHNoEvaluarPurchase; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'No Contemplar Ped. Compra', comment = 'ESP="No Contemplar Ped. Compra"';
        }
        field(50103; STHFilterLocation; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Filtro almacen hoja demanda Agrup', comment = 'ESP="Filtro almacen hoja demanda Agrup"';
        }
        field(50104; STHWorksheetName; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'WorksheetName', comment = 'ESP="WorksheetName"';
        }
        field(50105; ZMQuoteAssemblyLine; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'ZMQuoteAssemblyLine', comment = 'ESP="ZMQuoteAssemblyLine"';
        }
        field(50120; STHCostEstandarOLD; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Costes Estandar Previo', comment = 'ESP="Costes Estandar Previo"';
        }
        field(50121; CambiadoCoste; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cambiado Coste', comment = 'ESP="Cambiado Coste"';
        }
        field(50122; RecalcularCosteEstandar; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Recalcular Coste Estandar', comment = 'ESP="Recalcular Coste Estandar"';
        }
        // ITBID Integracion
        field(50125; "STH To Update"; Boolean)
        {
            Caption = 'To update', comment = 'ESP="Act. ITBID"';
        }
        field(50126; "STH Last Update Date"; Date)
        {
            Caption = 'Last date updated', comment = 'Ult. Fecha act. itbid';
        }
        // ITBID Integracion
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
        field(50136; "Inventory to date"; Decimal)
        {
            Caption = 'Inventory to date', comment = 'ESP="Inventario a Fecha"';
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter")));

            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50137; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name', comment = 'ESP="Nombre proveedor"';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            Editable = false;
        }
        field(50140; "Obtener Serie Consumo"; Boolean)
        {
            Caption = 'Obtener Serie Consumo', comment = 'ESP="Obtener Serie Consumo"';
            DataClassification = CustomerContent;
        }
        field(50150; Material; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Material', comment = 'ESP="Material"';
        }
        field(50155; "CRM Updated"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'CRM Updated', comment = 'ESP="Actualizar CRM"';
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
        field(50160; "Update BI BOM Costs"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Update BI BOM Costs', comment = 'ESP="Actualizar BI BOM Costes"';

            trigger OnValidate()
            begin
                Validate_UpdateBIBOMCosts();
            end;
        }
        field(50170; "Purch. Request minor 200"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Purch. Request minor 200', comment = 'ESP="Solicitud compras menor 200€"';
        }
        //+ 22/11/2022 NORMATIVA MEDIO AMBIENTAL
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
        field(50220; Aluminium; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Aluminium', comment = 'ESP="Aluminio"';
            DecimalPlaces = 6 : 6;
        }
        field(50221; "PAPER & CARTON (With plastic)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PAPER & CARTON (With plastic)', comment = 'ESP="PAPEL Y CARTON (Con plástico)"';
            DecimalPlaces = 6 : 6;
        }
        field(50222; "PLASTICS EPS Flexible"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS EPS Flexible', comment = 'ESP="PLASTICOS EPS Flexibles"';
            DecimalPlaces = 6 : 6;
        }
        field(50223; "PLASTICS OTHERS"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS OTHERS', comment = 'ESP="PLASTICOS OTROS"';
            DecimalPlaces = 6 : 6;
        }
        field(50224; "PLASTICS PET FLEXIBLE"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PET FLEXIBLE', comment = 'ESP="PLASTICOS PET FLEXIBLES"';
            DecimalPlaces = 6 : 6;
        }
        field(50225; "PLASTICS PET OTHER"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PET OTHERS', comment = 'ESP="PLASTICOS PET Resto"';
            DecimalPlaces = 6 : 6;
        }
        field(50226; "PLASTICS PP FLEXIBLE"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PP FLEXIBLE', comment = 'ESP="PLASTICOS PP Flexibles"';
            DecimalPlaces = 6 : 6;
        }
        field(50227; "PLASTICS PVC FLEXIBLE"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PVC FLEXIBLE', comment = 'ESP="PLASTICOS PVC Flexibles"';
            DecimalPlaces = 6 : 6;
        }
        field(50228; "PLASTICS PVC OTHER"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PVC OTHER', comment = 'ESP="PLASTICOS PVC Resto"';
            DecimalPlaces = 6 : 6;
        }
        //-  NORMATIVA MEDIO AMBIENTAL

    }
    var
        SalesSetup: Record "Sales & Receivables Setup";

    local procedure Validate_UpdateBIBOMCosts();
    var
        HistCost: Record "ZM Hist. BOM Costs";
        lblConfirm: Label '¿Desea eliminar todos los calculos realizados sobre el producto %1?', comment = 'ESP="¿Desea eliminar todos los calculos realizados sobre el producto %1?"';
        lblEnd: Label 'En process', comment = 'ESP="Fin proceso"';
    begin
        if not Rec."Update BI BOM Costs" then
            if Confirm(lblConfirm, false, Rec."No.") then begin
                HistCost.DeleteResultsItem(Rec);
                Message(lblEnd);
            end;
    end;

    local procedure CheckSerialInfo()
    var
        SerialNoInfo: Record "Serial No. Information";
        lblErrorExist: Label 'Existing Serial information No. with costs.', comment = 'ESP="Existen información Nº de series con costes."';
    begin
        SerialNoInfo.SetRange("Item No.", Rec."No.");
        if SerialNoInfo.FindFirst() then
            Error(lblErrorExist);
    end;

    procedure GetTaxesSteel(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec.Steel);
    end;


    procedure GetTaxesAluminium(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec.Aluminium);
    end;

    procedure GetTaxesCarton(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec.Carton);
    end;

    procedure GetTaxesWood(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec.Wood);
    end;

    procedure GetTaxesPaperCartoon(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec."PAPER & CARTON (With plastic)");
    end;

    procedure GetTaxesPLASTICSEPSFlexible(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec."PLASTICS EPS Flexible");
    end;

    procedure GetTaxesPLASTICSOTHERS(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec."PLASTICS OTHERS");
    end;

    procedure GetTaxesPLASTICSPETFLEXIBLE(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec."PLASTICS PET FLEXIBLE");
    end;

    procedure GetTaxesPLASTICSPETOTHER(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec."PLASTICS PET OTHER");
    end;

    procedure GetTaxesPLASTICSPPFLEXIBLE(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec."PLASTICS PP FLEXIBLE");
    end;

    procedure GetTaxesPLASTICSPVCFLEXIBLE(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec."PLASTICS PVC FLEXIBLE");
    end;

    procedure GetTaxesPLASTICSPVCOTHER(): decimal
    begin
        SalesSetup.Get();
        exit(SalesSetup."Taxes Steel" * Rec."PLASTICS PVC OTHER");
    end;
}