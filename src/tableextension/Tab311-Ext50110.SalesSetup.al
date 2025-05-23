tableextension 50110 "SalesSetup" extends "Sales & Receivables Setup"  // 311
{
    fields
    {
        field(50100; "PmtTermsRepuesto_btc"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Replacement payment term', comment = 'ESP="Término pago repuesto"';
            TableRelation = "Payment Terms";
            Description = 'Bitec';
        }

        field(50101; "PmtMethodRepuesto_btc"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Replacement payment method', comment = 'ESP="Forma pago repuesto"';
            TableRelation = "Payment Method";
        }

        field(50102; "ClasificacionRepuesto_btc"; enum ClasVtas)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Replacement Classification', comment = 'ESP="Clasificación Repuesto"';
            ObsoleteState = Removed;
        }

        field(50103; "OptClasificacionRepuesto_btc"; Option)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Sales Classification', comment = 'ESP="Clasificación Ventas"';
            OptionMembers = " ","Envases y Embalajes",Accesorios,"Bloque Máquina",Box,"Conjunto Máquina",Mueble,Repuestos,Otros,Servicios;
            OptionCaption = ' ,Containers and packaging,Accessories,Machine block,Box,Machine set,Price of furniture,Spare parts,Others,Services', comment = 'ESP=" ,Envases y Embalajes,Accesorios,Bloque Máquina,Box,Conjunto Máquina,Mueble,Repuestos,Otros,Servicios"';
        }

        field(50104; "NumDiasAvisoVencimiento_btc"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Nº días prox. vencimiento', comment = 'ESP="Nº días prox. vencimiento"';
        }

        field(50105; "RutaPdfPedidos_btc"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Orders PDF path', comment = 'ESP="Ruta PDF Pedidos"';
        }

        field(50107; "CalendarioOfertas"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Calendario Ofertas', comment = 'ESP="Calendario Ofertas"';
            TableRelation = "Base Calendar";
        }

        field(50108; "CodProvinciaDefecto_btc"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Default Area Code', comment = 'ESP="Cód. Provincia por defecto"';
            TableRelation = Area;
        }
        field(50109; "NumDiasAvisoVencido_btc"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Nº días fact vencidas', comment = 'ESP="Nº días fact vencidas"';
        }
        field(50110; DiasVtoAseguradora; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Días Vto. Aseguradora', comment = 'ESP="Días Vto. Aseguradora"';
        }
        field(50111; "WS Base URL IC Zummo Innc."; Text[150])
        {
            Caption = 'WS Base URL IC Zummo Innc.', Comment = 'WS URL Base IC Zummo Innc.';
            DataClassification = CustomerContent;
            Description = 'Intercompany Zummo Innc.';
        }
        field(50112; "WS Name - Purch. Order Header"; Text[100])
        {
            Caption = 'WS Name - Purch. Order Header', Comment = 'Nombre WS - Cab. Ped. Compra';
            DataClassification = CustomerContent;
            Description = 'Intercompany Zummo Innc.';
        }
        field(50113; "WS Name - Purch. Order Line"; Text[100])
        {
            Caption = 'WS Name - Purch. Order Line', Comment = 'Nombre WS - Lin. Ped. Compra';
            DataClassification = CustomerContent;
            Description = 'Intercompany Zummo Innc.';
        }
        field(50114; "WS User Id"; Text[20])
        {
            Caption = 'WS User Id', Comment = 'Id Usuario';
            DataClassification = CustomerContent;
            Description = 'Intercompany Zummo Innc.';
        }
        field(50115; "WS Key"; Text[150])
        {
            Caption = 'WS Key', Comment = 'Clave del WS';
            DataClassification = CustomerContent;
            Description = 'Intercompany Zummo Innc.';
        }
        field(50116; "Send Mail Notifications"; Boolean)
        {
            Caption = 'Send Mail Notifications', Comment = 'Enviar notificaciones por email';
            DataClassification = CustomerContent;
            Description = 'Intercompany Zummo Innc.';
        }
        field(50117; "Recipient Mail Notifications"; Text[100])
        {
            Caption = 'Recipient Mail Notifications', Comment = 'Destinatario notificaciones por email';
            DataClassification = CustomerContent;
            Description = 'Intercompany Zummo Innc.';
        }


        field(50120; LanguageFilter; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Language Filter', comment = 'ESP="Filtro Idioma L. M."';
            TableRelation = Language;

        }
        field(50130; "Ruta exportar pdf facturas"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ruta exportar pdf facturas', comment = 'ESP="Ruta exportar pdf facturas"';

        }
        field(50140; "Customer Quote IC"; Code[20])
        {
            Caption = 'Customer Quote Zummo Inc.', Comment = 'ESP="Cliente oferta Zummo Inc."';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(50150; "Envío email Fact. Vencidas"; DateFormula)
        {
            Caption = 'Envío email Fact. Vencidas', Comment = 'ESP="Envío email Fact. Vencidas"';
            DataClassification = CustomerContent;
        }
        field(50160; "Ult. Envío Fact. Vencidas"; Date)
        {
            Caption = 'Ult. email Fact. Vencidas', Comment = 'ESP="Ult. email Fact. Vencidas"';
            DataClassification = CustomerContent;
        }
        field(50170; "Show Doc. Plastic Regulations"; Boolean)
        {
            Caption = 'Show Documents Plastic Regulations', Comment = 'ESP="Documentos mostrar Normativa Plástico"';
            DataClassification = CustomerContent;
        }
        field(50180; "Legend Regulations Plastic"; Text[100])
        {
            Caption = 'Legend Regulations Plastic', Comment = 'ESP="Leyenda Normativa Plástico"';
            FieldClass = FlowField;
            CalcFormula = lookup("Account Translation".Description where("G/L Account No." = Const('LegendReg')));
        }
        field(50190; "Legend Regulations Plastic 2"; Text[100])
        {
            Caption = 'Legend Regulations Plastic 2', Comment = 'ESP="Leyenda Normativa Plástico 2"';
            FieldClass = FlowField;
            CalcFormula = lookup("Account Translation"."Description" where("G/L Account No." = Const('LegendReg2')));
        }
        field(50200; "Show Item alert without tariff"; Boolean)
        {
            Caption = 'Show Item alert without tariff', Comment = 'ESP="Mostrar alerta producto sin tarifa"';
            DataClassification = CustomerContent;

        }
        field(50210; "Location Code Credit Memo"; code[10])
        {
            Caption = 'Location Code Credit Memo', Comment = 'ESP="Cód. Almacén Abonos"';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(50220; "Bin Code Credit Memo"; code[20])
        {
            Caption = 'Bin Code Credit Memo', Comment = 'ESP="Cód. Ubicación Abonos"';
            DataClassification = CustomerContent;
            TableRelation = Bin where("Location Code" = field("Location Code Credit Memo"));
        }
        field(50230; "Active Price/Discounts Control"; Boolean)
        {
            Caption = 'Active Price/Discounts Control', Comment = 'ESP="Activar Control Precios/Dtos."';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ItemRegCodeunit: Codeunit "ZM PL Items Regist. aprovals";
            begin
                ItemRegCodeunit.CheckSUPERUserConfiguration(true);
            end;
        }

        field(50240; "Recipient Mail Invoice Summary"; Text[100])
        {
            Caption = 'Recipient Mail  Invoice Summary', Comment = 'ESP="Destinatario Resumen Facturas"';
            DataClassification = CustomerContent;
        }
        field(50250; "Maximun Discounts Approval"; Decimal)
        {
            Caption = 'Maximun Discounts Approval', Comment = 'ESP="Dtos. Máximo Aprobación"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ItemRegCodeunit: Codeunit "ZM PL Items Regist. aprovals";
            begin
                ItemRegCodeunit.CheckSUPERUserConfiguration(true);
            end;
        }
        field(50260; "Maximun Discounts Users"; Decimal)
        {
            Caption = 'Maximun Discounts Usuario', Comment = 'ESP="Dtos. Máximo Usuario"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ItemRegCodeunit: Codeunit "ZM PL Items Regist. aprovals";
            begin
                ItemRegCodeunit.CheckSUPERUserConfiguration(true);
            end;
        }
        field(50270; "GTIN Nos."; code[20])
        {
            Caption = 'GTIN Nos.', Comment = 'ESP="Nº Serie GTIN"';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        // SCRAP CONFIGURACION PRECIOS
        field(50300; "Taxes Steel"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Taxes Steel (€/kg)', comment = 'ESP="Tasa Acero (€/kg)"';
            Description = 'Importe SCRAP Acero que se utiliza para el envío del producto';
            DecimalPlaces = 6 : 6;
        }
        field(50301; "Taxes Carton"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '"Taxes Carton (€/kg)', comment = 'ESP="Importe SCRAP Cartón (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50302; "Taxes Wood"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '"Taxes Wood (€/kg)', comment = 'ESP="Importe SCRAP Madera (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50310; "Taxes Aluminium"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Taxes Aluminium (€/kg)', comment = 'ESP="Tasas Aluminio (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50311; "Taxes PAPER & CARTON (With plastic)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PAPER & CARTON (With plastic)  (€/kg)', comment = 'ESP="PAPEL Y CARTON (Con plástico)  (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50312; "Taxes PLASTICS EPS Flexible"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS EPS Flexible (€/kg)', comment = 'ESP="PLASTICOS EPS Flexibles (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50313; "Taxes PLASTICS OTHERS"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS OTHERS (€/kg)', comment = 'ESP="PLASTICOS OTROS (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50314; "Taxes PLASTICS PET FLEXIBLE"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PET FLEXIBLE (€/kg)', comment = 'ESP="PLASTICOS PET FLEXIBLES (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50315; "Taxes PLASTICS PET OTHER"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PET OTHERS (€/kg)', comment = 'ESP="PLASTICOS PET Resto (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50316; "Taxes PLASTICS PP FLEXIBLE"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PP FLEXIBLE (€/kg)', comment = 'ESP="PLASTICOS PP Flexibles (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50317; "Taxes PLASTICS PVC FLEXIBLE"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PVC FLEXIBLE (€/kg)', comment = 'ESP="PLASTICOS PVC Flexibles (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50318; "Taxes PLASTICS PVC OTHER"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PLASTICS PVC OTHER (€/kg)', comment = 'ESP="PLASTICOS PVC Resto (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        field(50319; "Taxes RUBBER/SILICON Flexibles"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'RUBBER/SILICON Flexibles (€/kg)', comment = 'ESP="CAUCHO/SILICONAS Flexibles (€/kg)"';
            DecimalPlaces = 6 : 6;
        }
        //- SCRAP CONFIGURACION PRECIOS    

        // ITBID
        field(60002; STHurlAccessToken; Text[250])
        {
            Caption = 'URL Access Token';
            DataClassification = CustomerContent;
        }
        field(60003; STHurlPut; Text[250])
        {
            Caption = 'URL Put';
            DataClassification = CustomerContent;
        }
        field(60004; "STHRequires Authentication"; Boolean)
        {
            Caption = 'Requires Authenticacion';
            DataClassification = CustomerContent;
            InitValue = true;
        }
        field(60005; "STHclient_id"; Text[250])
        {
            Caption = 'client_id';
            DataClassification = CustomerContent;
        }
        field(60006; "STHclient_secret"; Text[250])
        {
            Caption = 'client_secret';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(60007; "STHgrant_type"; Text[30])
        {
            Caption = 'grant_type';
            DataClassification = CustomerContent;
        }
        field(60008; "STHredirect_url"; Text[100])
        {
            Caption = 'redirect_url';
            DataClassification = CustomerContent;
        }
        field(60009; STHusername; Text[50])
        {
            Caption = 'username';
            DataClassification = CustomerContent;
        }
        field(60010; STHpassword; Text[50])
        {
            Caption = 'password';
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(60011; STHemail; Text[100])
        {
            Caption = 'Email errores';
            DataClassification = CustomerContent;
        }
        field(60020; emailVendor; Text[100])
        {
            Caption = 'Notify Email Vendor', Comment = 'ESP="Notificacion proveedor"';
            DataClassification = CustomerContent;
        }
        field(60022; emailVendorBank; Text[100])
        {
            Caption = 'Notify Email Vendor Bank', Comment = 'ESP="Notificación Banco proveedor"';
            DataClassification = CustomerContent;
        }
        // ITBID 

    }

}