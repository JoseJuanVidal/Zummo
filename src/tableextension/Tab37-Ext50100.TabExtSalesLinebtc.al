tableextension 50100 "TabExtSalesLine_btc" extends "Sales Line"  //37
{
    fields
    {
        field(50001; "Line Discount1 %_btc"; Integer)
        {
            Caption = 'Line Discount1 %', Comment = 'ESP="% Descuento línea1"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = true;
            ObsoleteState = Removed;
            ObsoleteReason = 'Cambio a decimal';
        }

        field(50002; "Line Discount2 %_btc"; Integer)
        {
            Caption = 'Line Discount2 %', Comment = 'ESP="% Descuento línea2"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = true;
            ObsoleteState = Removed;
            ObsoleteReason = 'Cambio a decimal';
        }

        //Cambio de integer a decimal
        field(50011; "DecLine Discount1 %_btc"; Decimal)
        {
            Caption = 'Line Discount1 %', Comment = 'ESP="% Descuento línea1"';
            DecimalPlaces = 2 : 5;
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = true;

            trigger OnValidate()
            begin
                if "DecLine Discount1 %_btc" = 0 then begin
                    Validate("Line Discount %", "DecLine Discount2 %_btc");
                    exit;
                end;
                if "DecLine Discount2 %_btc" <> 0 then
                    Validate("Line Discount %", (1 - ((1 - "DecLine Discount1 %_btc" / 100) * (1 - "DecLine Discount2 %_btc" / 100))) * 100)
                else
                    Validate("Line Discount %", "DecLine Discount1 %_btc");
            end;
        }

        //Cambio de integer a decimal
        field(50012; "DecLine Discount2 %_btc"; Decimal)
        {
            Caption = 'Line Discount2 %', Comment = 'ESP="% Descuento línea2"';
            DecimalPlaces = 2 : 5;
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = true;

            trigger OnValidate()
            begin
                if "DecLine Discount2 %_btc" = 0 then begin
                    Validate("Line Discount %", "DecLine Discount1 %_btc");
                    exit;
                end;

                if "DecLine Discount1 %_btc" <> 0 then
                    Validate("Line Discount %", (1 - ((1 - "DecLine Discount1 %_btc" / 100) * (1 - "DecLine Discount2 %_btc" / 100))) * 100)
                else
                    Validate("Line Discount %", "DecLine Discount2 %_btc");
            end;
        }

        field(50003; "Tariff No_btc"; code[20])
        {
            Caption = 'Cód. arancelario', Comment = 'ESP="Tariff No_"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = false;
        }

        field(50004; NombreCliente_btc; Text[100])
        {
            Description = 'Bitec';
            Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Sell-to Customer No.")));
        }

        field(50005; StockAlmacen_btc; Decimal)
        {
            Description = 'Bitec';
            Caption = 'Stock', comment = 'ESP="Stock"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Location Code" = FIELD("Location Code")));
        }

        field(50006; TieneComentarios_btc; Boolean)
        {
            Description = 'Bitec';
            Caption = 'Comments', comment = 'ESP="Comentarios"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("Sales Comment Line" where(
                "Document Type" = field("Document Type"),
                "No." = field("Document No."),
                "Document Line No." = field("Line No.")
            ));
        }

        field(50007; FechaFinValOferta_btc; Date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Quote Valid Until Date" where(
                "Document Type" = field("Document Type"),
                "No." = field("Document No.")
            ));
        }

        field(50008; MotivoRetraso_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Motivo Retraso"), TipoRegistro = const(Tabla));
            Caption = 'Delay Motive', comment = 'ESP="Motivo retraso"';
        }

        field(50009; TextoMotivoRetraso_btc; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Delay Motive Description', comment = 'ESP="Desc. Motivo Retraso"';
        }

        field(50010; FechaAlta_btc; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Order Date', comment = 'ESP="Fecha Alta"';
        }
        field(50019; SinPrecioTarifa; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sin precio tarifa', comment = 'ESP="Sin precio tarifa"';
        }
        field(50013; PedidoServicio_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Order', comment = 'ESP="Pedido Servicio"';
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';

        }
        field(50014; LinPedidoServicio_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Service Order Line', comment = 'ESP="Lin.Pedido Servicio"';
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';

        }
        field(50015; OfertaServicio_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Service Quote', comment = 'ESP="Oferta Servicio"';
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';

        }
        field(50016; LinOfertaServicio_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Service Quote Line', comment = 'ESP="Lin.Oferta Servicio"';
            ObsoleteState = Removed;
            ObsoleteReason = 'Borrar';
        }
        field(50017; "Estado_btc"; Option)
        {
            BlankZero = true;
            Caption = 'Line Status', comment = 'ESP="Estado Lin.Pedido"';
            Editable = false;
            OptionCaption = ' ,Facturado Completo,Albaranes Bloqueados,PdteFact Completo,PdteFact No Completo,En Preparacion Completo,En Preparacion Incompleto,En Picking Completo,En Picking No Completo,Reservado Completo,Reservado No Completo,Stock Completo,Stock No Completo';
            OptionMembers = " ","Facturado Completo","Albaranes Bloqueados","PdteFact Completo","PdteFact No Completo","En Preparacion Completo","En Preparacion Incompleto","En Picking Completo","En Picking No Completo","Reservado Completo","Reservado No Completo","Stock Completo","Stock No Completo";
            ObsoleteState = Removed;
        }
        field(50018; QuoteNoSalesOrder; code[20])
        {
            Caption = 'Quote No.', comment = 'ESP="Nº de oferta"';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Quote No." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            editable = false;
        }

        field(50107; ExternalDocument; Code[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."External Document No." where(
                "Document Type" = field("Document Type"),
                "No." = field("Document No.")
            ));
        }
        field(50200; ParentLine; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50201; ParentLineNo; Integer)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        //#region Integracion Intercompany
        field(50300; "Source Purch. Order No"; Code[20])
        {
            Caption = 'Source Purch. Order No', Comment = 'Nº Ped. Compra origen';
            DataClassification = CustomerContent;
        }
        field(50301; "Source Purch Order Line"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Purch. Order Line', Comment = 'Nº Linea Ped. Compra origen';
        }
        field(50305; "Source Purch Order Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Source Purch. Order Price', Comment = 'Precio Ped. Compra origen';
        }
        //-region Integracion Intercompany
        field(50912; "No contemplar planificacion"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'No contemplar planificaciòn', comment = 'ESP="No contemplar planificación"';
        }
    }

    fieldgroups
    {
        addlast(Brick; "No.")
        {

        }
    }
}

