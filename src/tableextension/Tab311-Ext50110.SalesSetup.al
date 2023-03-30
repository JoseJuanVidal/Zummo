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
    }
}