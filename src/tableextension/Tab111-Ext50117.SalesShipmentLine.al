tableextension 50117 "SalesShipmentLine" extends "Sales Shipment Line" //111
{
    fields
    {
        field(50001; "Line Discount1 %_btc"; Integer)
        {
            Caption = '% Descuento línea1', Comment = 'ESP="Line Discount1 %"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';

            ObsoleteState = Removed;
            ObsoleteReason = 'Cambio a decimal';
        }
        field(50002; "Line Discount2 %_btc"; Integer)
        {
            Caption = '% Descuento línea2', Comment = 'ESP="Line Discount2 %"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';

            ObsoleteState = Removed;
            ObsoleteReason = 'Cambio a decimal';
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
            Caption = 'Inventario', comment = 'ESP="Inventario"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Location Code" = FIELD("Location Code")));
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

        //Cambio de integer a decimal
        field(50011; "DecLine Discount1 %_btc"; Decimal)
        {
            Caption = 'Line Discount1 %', Comment = 'ESP="% Descuento línea1"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
        }


        field(50012; "DecLine Discount2 %_btc"; Decimal)
        {
            Caption = 'Line Discount2 %', Comment = 'ESP="% Descuento línea2"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
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
        field(50019; SinPrecioTarifa; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Sin precio tarifa', comment = 'ESP="Sin precio tarifa"';
        }
        field(50157; BaseImponibleLinea; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base Amount Line', comment = 'ESP="Importe Base IVA"';
            editable = false;
        }
        field(50158; TotalImponibleLinea; decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Amount Line', comment = 'ESP="Importe Total IVA"';
            editable = false;
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
        field(50202; ParentItemNo; code[20])
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}