tableextension 50125 "SalesHeader" extends "Sales Header"  //36
{

    fields
    {
        field(50001; Abono; code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Abono';
        }
        field(50002; "Is comment"; Boolean)
        {
            Caption = 'Is Sales Comment', comment = 'ESP="Comentarios venta"';
            FieldClass = FlowField;
            CalcFormula = exist("Sales Comment Line" where("Document Type" = field("Document Type"), "No." = field("No.")));
            Editable = false;
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
        field(50105; "Sell-to Search Name"; code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sell-to Search Name', comment = 'ESP="Venta a-Alias"';
            Editable = false;
        }
        field(50107; Rappel; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Rappel', comment = 'ESP="Rappel"';
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
            Caption = 'Impreso Almacén.';
            ObsoleteState = Pending;
        }

        field(50029; GuardadoPdf_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'PDF Saved', comment = 'ESP="PDF Guardado"';
        }
        field(50032; InsideSales_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("InsideSales"), TipoRegistro = const(Tabla));
            Caption = 'Inside Sales', comment = 'ESP="Inside Sales"';
        }
        field(50042; Canal_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Canal"), TipoRegistro = const(Tabla));
            Caption = 'Canal', comment = 'ESP="Canal"';
        }
        field(50050; ofertaprobabilidad; Option)
        {
            Caption = 'Probabilidad', comment = 'ESP="Probabilidad"';
            OptionCaption = ' ,Baja,Media,Alta,Muy Baja';
            OptionMembers = " ","Baja","Media","Alta","Muy Baja";
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
            DecimalPlaces = 0 : 4;
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
        field(50911; OfertaSales; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Oferta Sales', comment = 'ESP="Oferta Sales"';
        }
        field(50912; "No contemplar planificacion"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'No contemplar planificaciòn', comment = 'ESP="No contemplar planificación"';

            trigger OnValidate()

            begin
                UpdateNoComplarPlanificacion;
            end;
        }
        field(50013; "Aviso Oferta bajo pedido"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Aviso Oferta bajo pedido', comment = 'ESP="Aviso Oferta bajo pedido"';
        }

        field(5068; FechaAltaPedido; Date)
        {
            DataClassification = CustomerContent;
        }

        //#region Integracion Intercompany
        field(50120; "Source Purch. Order No"; Code[20])
        {
            Caption = 'Source Purch. Order No', Comment = 'Nº Ped. Compra origen';
            DataClassification = CustomerContent;
        }
        field(50121; "Source Purch. Order Updated"; Boolean)
        {
            Caption = 'Source Purch. Order Updated', Comment = 'Ped. Compra origen actualizado';
            DataClassification = CustomerContent;
        }
        field(50130; "Fecha Entrega en destino"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Entrega en destino', comment = 'ESP="Fecha Entrega en destino"';
        }
        //#endregion Integracion Intercompany

        //+  NORMATIVA MEDIO AMBIENTAL
        Field(50250; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic (kg)', comment = 'ESP="Plástico (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50251; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Recycled (kg)', comment = 'ESP="Plástico reciclado (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50252; "Plastic Date Declaration"; Date)
        {
            Caption = 'Plastic Date Declaration', comment = 'ESP="Fecha Declaración plástico"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //-  NORMATIVA MEDIO AMBIENTAL
    }
    local procedure UpdateNoComplarPlanificacion()
    var
        funciones: Codeunit Funciones;
    begin
        funciones.UpdateNoContemplarPlanificacion(Rec);
    end;


    procedure CalcAmountcostLines(): decimal
    var
        SalesLines: Record "Sales Line";
        CostLines: Decimal;
    begin
        Saleslines.Reset();
        Saleslines.SetRange("Document Type", Rec."Document Type");
        Saleslines.SetRange("Document No.", Rec."No.");
        if Saleslines.findset() then
            repeat
                CostLines += Saleslines."Unit Cost (LCY)" * Saleslines.Quantity;
            Until Saleslines.next() = 0;
        exit(round(CostLines, 0.01));
    end;
}