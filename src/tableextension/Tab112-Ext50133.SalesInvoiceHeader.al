tableextension 50133 "SalesInvoiceHeader" extends "Sales Invoice Header"  //112
{
    fields
    {

        field(50101; FechaRecepcionMail_btc; Date)
        {
            DataClassification = CustomerContent;
            Description = 'Bitec';
            Caption = 'Fecha.Rec.Mail', comment = 'ESP="Fecha.Rec.Mail"';
        }

        field(50102; NumDias_btc; Integer)
        {
            DataClassification = CustomerContent;
            BlankZero = true;
            Caption = 'Lead TIme', comment = 'ESP="Nº días"';
        }

        // Comentario interno pedidos venta
        field(50103; ComentarioInterno_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Internal Comment', comment = 'ESP="Comentario interno"';
        }

        //Guardar Nº asiento y Nº documento
        field(50104; NumAsiento_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction No.', comment = 'ESP="Nº asiento"';
        }
        field(50110; Peso_btc; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Weight', comment = 'ESP="Peso"';
        }

        field(50111; NumPalets_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of pallets', comment = 'ESP="Nº Palets"';
        }


        field(50112; NumBultos_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of packages', comment = 'ESP="Nº Bultos"';
        }
        field(50113; PedidoServicio_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Order', comment = 'ESP="Pedido Servicio"';
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';

        }
        field(50115; OfertaServicio_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Quote', comment = 'ESP="Oferta Servicio"';
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';

        }

        field(50116; ComSerieLoteCreados_btc; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(50117; ComEnsambladoCreados_btc; Boolean)
        {
            DataClassification = CustomerContent;
        }

        field(50020; CentralCompras_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Central Compras"), TipoRegistro = const(Tabla));
            Caption = 'Central Compras', comment = 'ESP="Central Compras"';
        }
        field(50021; ClienteCorporativo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Cliente Corporativo"), TipoRegistro = const(Tabla));
            Caption = 'Cliente Corporativo', comment = 'ESP="Cliente Corporativo"';
        }
        field(50022; AreaManager_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("AreaManager"), TipoRegistro = const(Tabla));
            Caption = 'Area Manager', comment = 'ESP="Area Manager"';
        }
        field(50023; Delegado_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Delegado"), TipoRegistro = const(Tabla));
            Caption = 'Delegado', comment = 'ESP="Delegado"';
        }
        field(50024; GrupoCliente_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("GrupoCliente"), TipoRegistro = const(Tabla));
            Caption = 'GrupoCliente', comment = 'ESP="GrupoCliente"';
        }

        field(50025; Perfil_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Perfil"), TipoRegistro = const(Tabla));
            Caption = 'Perfil', comment = 'ESP="Perfil"';
        }

        field(50026; SubCliente_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("SubCliente"), TipoRegistro = const(Tabla));
            Caption = 'SubCliente', comment = 'ESP="SubCliente"';
        }

        field(50027; ClienteReporting_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClienteReporting"), TipoRegistro = const(Tabla));
            Caption = 'Cliente Reporting', comment = 'ESP="Cliente Reporting"';
        }

        field(50029; GuardadoPdf_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'PDF Saved', comment = 'ESP="PDF Guardado"';
        }

        field(50030; CorreoEnviado_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Email Send', comment = 'ESP="Correo Enviado"';
        }
        field(50031; FacturacionElec_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Facturación electrónica', comment = 'ESP="Facturación electrónica"';
        }
        field(50032; InsideSales_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("InsideSales"), TipoRegistro = const(Tabla));
            Caption = 'Inside Sales', comment = 'ESP="Inside Sales"';
        }
        field(50100; NoFacturar_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Not invoice', comment = 'ESP="No facturar"';
            Editable = false;
            ObsoleteState = Removed;
        }

        field(50910; MotivoBloqueo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("MotivoBloqueo"), TipoRegistro = const(Tabla));
            Caption = 'Block Reason', comment = 'ESP="Motivo Bloqueo"';
        }

        field(50200; NumAbono; Code[20])
        {
            Editable = false;
            Caption = 'Cr. Memo No.', comment = 'ESP="Nº Abono"';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Corrected Invoice No." where("Corrected Invoice No." = field("No.")));
        }
        field(50050; Suplemento_aseguradora; Code[20])
        {
            Caption = 'Suplemento aseguradora', comment = 'ESP="Suplemento aseguradora"';
            FieldClass = FlowField;
            CalcFormula = lookup(customer.Suplemento_aseguradora where("No." = field("Sell-to Customer No.")));
        }
        field(50051; "Credito Maximo Aseguradora_btc"; Integer)
        {
            Caption = 'Crédito Maximo Aseguradora', Comment = 'ESP="Crédito Maximo Aseguradora"';
            FieldClass = FlowField;
            CalcFormula = lookup(customer."Credito Maximo Aseguradora_btc" where("No." = field("Sell-to Customer No.")));
        }
        field(50052; Aseguradora_comunicacion; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Comunicado Aseguradora', comment = 'ESP="Comunicado Aseguradora"';

        }
        field(50053; Fecha_Aseguradora_comunicacion; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Aseguradora', comment = 'ESP="Fecha Aseguradora"';

        }
        field(50054; "Cred_ Max_ Aseg. AutorizadoPor"; Code[20])
        {
            Caption = 'Crédito Maximo Aseguradora Autorizado Por', Comment = 'ESP="Crédito Maximo Aseguradora Autorizado Por"';
            FieldClass = FlowField;
            CalcFormula = lookup(customer."Cred_ Max_ Aseg. Autorizado Por_btc" where("No." = field("Sell-to Customer No.")));
        }
        field(50055; clasificacion_aseguradora; Code[20])
        {
            Caption = 'Clasif. Aseguradora', comment = 'ESP="Clasif. Aseguradora"';
            FieldClass = FlowField;
            CalcFormula = lookup(customer.clasificacion_aseguradora where("No." = field("Sell-to Customer No.")));
        }
        field(50056; "ABC Cliente"; option)
        {
            OptionMembers = " ","3A","A","B","C","Z";
            OptionCaption = ' ,3A,A,B,C,Z', Comment = 'ESP=" ,3A,A,B,C,Z"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."ABC Cliente" where("No." = field("Sell-to Customer No.")));
        }
        field(50070; CurrencyChange; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cambio divisa', comment = 'ESP="Cambio divisa"';
        }
        field(51000; ImporteReport; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(51001; ImporteDLReport; Decimal)
        {
            DataClassification = CustomerContent;
        }

    }

}