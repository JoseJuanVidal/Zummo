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
            CalcFormula = lookup ("Sales Cr.Memo Header"."Corrected Invoice No." where("Corrected Invoice No." = field("No.")));
        }
    }
}