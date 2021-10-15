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
            Caption = 'Family', comment = 'ESP="Familia"';
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
            // ObsoleteState = Removed;
        }

        field(50007; OptFamilia_btc; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Family', comment = 'ESP="Familia"';
            OptionMembers = " ",Z40,Z14,Z06,Z1,Z22,ZV25,Z10,KIOSKO;
            OptionCaption = ' ,Z40,Z14,Z06,Z1,Z22,ZV25,Z10,KIOSKO', comment = 'ESP=" ,Z40,Z14,Z06,Z1,Z22,ZV25,Z10,KIOSKO"';
            //  ObsoleteState = Removed;
        }

        field(50008; OptGama_btc; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Gamma', comment = 'ESP="Gama"';
            OptionMembers = " ",NATURE,CLASSIC;
            OptionCaption = ' ,NATURE,CLASSIC', comment = 'ESP=" ,NATURE,CLASSIC"';
            //  ObsoleteState = Removed;
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
        field(50103; STHFilterLocation; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No Contemplar Ped. Compra', comment = 'ESP="No Contemplar Ped. Compra"';
        }
        field(50104; STHWorksheetName; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'WorksheetName', comment = 'ESP="WorksheetName"';
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
    }
}