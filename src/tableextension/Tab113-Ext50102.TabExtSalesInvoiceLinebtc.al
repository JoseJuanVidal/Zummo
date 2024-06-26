tableextension 50102 "TabExtSalesInvoiceLine_btc" extends "Sales Invoice Line"  //113
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
            Caption = 'Stock', comment = 'ESP="Stock"';
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
        field(50018; LineaComentarioSerie; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50030; Promociones; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Promociones), TipoRegistro = const(Tabla));
            Caption = 'Promociones', comment = 'ESP="Promociones"';
            Editable = false;
        }
        field(50040; PricesApprovalStatus; Enum "Status Approval")
        {
            DataClassification = CustomerContent;
            Caption = 'Price approval status', comment = 'ESP="Estado aprobación precios"';
        }
        field(50050; "IdCorp_Sol"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ID Corporativo Solicitante', comment = 'ESP="ID Corporativo Solicitante"';
            Editable = false;
        }
        field(50051; "Nombre Empleado"; code[250])
        {
            Caption = 'ID Corporativo Solicitante', comment = 'ESP="ID Corporativo Solicitante"';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Search Name" where("No." = field(IdCorp_Sol)));
            Editable = false;
        }
        field(50110; Peso_btc; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Weight', comment = 'ESP="Peso"';
        }

        //  Nº bultos
        field(50111; NumPalets_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of pallets', comment = 'ESP="Nº Palets"';
        }

        //  Nº bultos
        field(50112; NumBultos_btc; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Number of packages', comment = 'ESP="Nº Bultos"';
        }
        // Adaptación
        field(50108; ComentarioAut_btc; Boolean)
        {

        }
        field(50114; selClasVtas_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Classification', comment = 'ESP="Clasificación Ventas"';
            //TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClasificacionVentas"), TipoRegistro = const(Tabla));
        }
        field(50115; selFamilia_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Family', comment = 'ESP="Familia"';
        }
        field(50116; selGama_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Gamma', comment = 'ESP="Gama"';
        }
        field(50120; desClasVtas_btc; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Desc. Sales Classification', comment = 'ESP="Desc. Clasificación Ventas"';
            Editable = false;
        }
        field(50121; desFamilia_btc; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Desc. Familia', comment = 'ESP="Desc. Familia"';
            Editable = false;
        }
        field(50122; desGama_btc; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Desc. Gamma', comment = 'ESP="Desc. Gama"';
            Editable = false;
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
        field(50203; ContractParent; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}

