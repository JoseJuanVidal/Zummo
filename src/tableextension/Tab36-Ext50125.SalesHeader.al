tableextension 50125 "SalesHeader" extends "Sales Header"  //36
{

    fields
    {
        field(50001; Abono; code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Abono';
        }

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

        field(50103; ComentarioInterno_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Internal Comment', comment = 'ESP="Comentario interno"';
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
            TableRelation = "Service Header"."No." where("Document Type" = const(Quote));
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';

        }
        field(50017; "Estado_btc"; Option)
        {
            BlankZero = true;
            Caption = 'Order Status', comment = 'ESP="Estado Pedido"';
            Editable = false;
            OptionCaption = ' ,Facturado Completo,Albaranes Bloqueados,PdteFact Completo,PdteFact No Completo,En Preparacion Completo,En Preparacion Incompleto,En Picking Completo,En Picking No Completo,Reservado Completo,Reservado No Completo,Stock Completo,Stock No Completo';
            OptionMembers = " ","Facturado Completo","Albaranes Bloqueados","PdteFact Completo","PdteFact No Completo","En Preparacion Completo","En Preparacion Incompleto","En Picking Completo","En Picking No Completo","Reservado Completo","Reservado No Completo","Stock Completo","Stock No Completo";
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';

        }
        field(50199; DescuentoFactura; Decimal)
        {
            Caption = '% Descuento Factura';
            DataClassification = CustomerContent;
        }

        field(50198; DescuentoProntoPago; Decimal)
        {
            Caption = '% Descuento Pronto Pago';
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
        field(50028; ImpresoAlmacen_btc; Boolean)
        {
            Caption = 'Impreso Alm';
        }

        field(50029; GuardadoPdf_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'PDF Saved', comment = 'ESP="PDF Guardado"';
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

        field(5068; FechaAltaPedido; Date)
        {
            DataClassification = CustomerContent;

        }

    }
}