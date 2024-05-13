tableextension 50137 "ServiceHeader" extends "Service Header"  //5900
{
    fields
    {
        modify("Service Order Type")
        {
            trigger OnAfterValidate()
            begin
                if "Service Order Type" <> xRec."Service Order Type" then begin
                    TipoPedidoNivel2_btc := '';
                    TipoPedidoNivel3_btc := '';
                end;
            end;
        }

        field(50100; TipoPedidoNivel2_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Type order service level 2', comment = 'ESP="Tipo pedido servicio nivel 2"';
            TableRelation = ClassPedServicio.TipoPedidoNivel2_btc where(TipoPedidoNivel1_btc = field("Service Order Type"));

            trigger OnValidate()
            begin
                if TipoPedidoNivel2_btc <> xRec.TipoPedidoNivel2_btc then
                    TipoPedidoNivel3_btc := '';
            end;
        }

        field(50002; "Cerrado en plataforma"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50003; "Solicitado a Técnico"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50101; TipoPedidoNivel3_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Type order service level 3', comment = 'ESP="Tipo pedido servicio nivel 3"';
            TableRelation = ClassPedServicioNivel3.TipoPedidoNivel3_btc where(
                TipoPedidoNivel1_btc = field("Service Order Type"),
                TipoPedidoNivel2_btc = field(TipoPedidoNivel2_btc)
            );
        }

        field(50102; NumEstanteria_btc; Code[10])
        {
            Editable = false;
            Caption = 'Service Shelf No.', comment = 'ESP="Nº estantería"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Item Line"."Service Shelf No." where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }

        field(50103; ComentarioAlmacen_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Location comment', comment = 'ESP="Comentario almacén"';
        }
        field(50104; CodAnterior_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code Previous', comment = 'ESP="Cód. Anterior"';
        }

        field(50107; NumSerie_btc; Code[20])
        {
            Editable = false;
            Caption = 'Serial No.', comment = 'ESP="Nº Serie"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Item Line"."Serial No." where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }

        field(50108; PedidoArchivado_btc; Code[20])
        {
            Caption = 'Sales Order Archive', comment = 'ESP="Pedido.Venta Archivado"';
            Editable = false;
            FieldClass = FlowField;
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';

        }

        field(50109; CodResolucion_btc; Code[10])
        {
            Editable = false;
            Caption = 'Resolution Code', comment = 'ESP="Cod.Resolucion"';
            FieldClass = FlowField;
            CalcFormula = lookup("Service Item Line"."Resolution Code" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }
        field(50110; IsWarranty; Boolean)
        {
            Caption = 'Es Mto. Garantia', comment = 'ESP="Es Mto. Garantia"';
            Editable = false;
        }
        field(50211; Fechaemtregamaterial_sth; DateTime)
        {
            Caption = 'Fecha entrega material', comment = 'ESP="Fecha resolución en cliente"';
            FieldClass = FlowField;
            CalcFormula = min("Service Item Line".Fechaemtregamaterial_sth where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }
    }
}