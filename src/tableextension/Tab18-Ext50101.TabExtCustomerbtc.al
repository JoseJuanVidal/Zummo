tableextension 50101 "TabExtCustomer_btc" extends Customer  //18
{
    fields
    {
        field(50001; "Credito Maximo Interno_btc"; Integer)
        {
            Caption = 'Crédito Maximo Interno', Comment = 'ESP="Crédito Maximo Interno"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = true;
            trigger OnValidate()
            begin
                validate("Credit Limit (LCY)", "Credito Maximo Aseguradora_btc" + "Credito Maximo Interno_btc");
            end;

        }
        field(50002; "Cred_ Max_ Int_ Autorizado Por_btc"; Code[20])
        {
            Caption = 'Crédito Maximo Interno Autorizado Por', Comment = 'ESP="Crédito Maximo Interno Autorizado Por"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = true;
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(Tabla), TipoTabla = const(Aseguradora));
        }
        field(50003; "Credito Maximo Aseguradora_btc"; Integer)
        {
            Caption = 'Crédito Maximo Aseguradora', Comment = 'ESP="Crédito Maximo Aseguradora"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = true;
            trigger OnValidate()
            begin
                TestField("Cred_ Max_ Aseg. Autorizado Por_btc");
                validate("Credit Limit (LCY)", "Credito Maximo Aseguradora_btc" + "Credito Maximo Interno_btc");
            end;
        }
        field(50004; "Cred_ Max_ Aseg. Autorizado Por_btc"; Code[20])
        {
            Caption = 'Crédito Maximo Aseguradora Autorizado Por', Comment = 'ESP="Crédito Maximo Aseguradora Autorizado Por"';
            DataClassification = ToBeClassified;
            Description = 'Bitec';
            Editable = true;
        }
        modify("Credit Limit (LCY)")
        {
            trigger OnBeforeValidate()
            begin
                "Credit Limit (LCY)" := "Credito Maximo Aseguradora_btc" + "Credito Maximo Interno_btc";
            end;
        }

        field(50005; "Descuento1_btc"; Decimal)
        {
            Caption = 'Descuento1', comment = 'ESP="Descuento1"';
            DecimalPlaces = 2 : 5;


            trigger OnValidate()
            begin
                if Descuento1_btc > 100 then
                    Error('No puede ser mayor de 100');

                if Descuento1_btc + Descuento2_btc > 100 then
                    Error('La suma de los descuentos no puede ser mayor de 100');
            end;
        }

        field(50006; "Descuento2_btc"; Decimal)
        {
            Caption = 'Descuento2', comment = 'ESP="Descuento2"';
            DecimalPlaces = 2 : 5;
            trigger OnValidate()
            begin
                if Descuento2_btc > 100 then
                    Error('No puede ser mayor de 100');

                if Descuento1_btc + Descuento2_btc > 100 then
                    Error('La suma de los descuentos no puede ser mayor de 100');
            end;
        }

        field(50007; CodMotivoBloqueo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Blocking Motives', comment = 'ESP="Motivo Bloqueo"';
            TableRelation = MotivosBloqueo;
        }
        field(50008; "Transaction Specification"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Specification', comment = 'ESP="Especificación transacción"';
            TableRelation = "Transaction Specification";
        }
        field(50009; "Transaction Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type', comment = 'ESP="Naturaleza transacción"';
            TableRelation = "Transaction Type";
        }
        field(50010; "Transport Method"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transport Method', comment = 'ESP="Modo transporte"';
            TableRelation = "Transport Method";
        }
        field(50011; "Exit Point"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Exit Point', comment = 'ESP="Puerto/Aerop. carga';
            TableRelation = "Entry/Exit Point";
        }
        field(50012; Suplemento_aseguradora; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Suplemento aseguradora', comment = 'ESP="Suplemento aseguradora"';
        }
        field(50013; CentralCompras_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Central Compras"), TipoRegistro = const(Tabla));
            Caption = 'Central Compras', comment = 'ESP="Central Compras"';
        }
        field(50014; ClienteCorporativo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Cliente Corporativo"), TipoRegistro = const(Tabla));
            Caption = 'Cliente Corporativo', comment = 'ESP="Cliente Corporativo"';
        }
        field(50015; AreaManager_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("AreaManager"), TipoRegistro = const(Tabla));
            Caption = 'Area Manager', comment = 'ESP="Area Manager"';
        }
        field(50016; Delegado_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Delegado"), TipoRegistro = const(Tabla));
            Caption = 'Delegado', comment = 'ESP="Delegado"';
        }
        field(50017; GrupoCliente_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("GrupoCliente"), TipoRegistro = const(Tabla));
            Caption = 'Cliente Tipo', comment = 'ESP="Cliente Tipo"';
        }

        field(50018; Perfil_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Perfil"), TipoRegistro = const(Tabla));
            Caption = 'Perfil', comment = 'ESP="Perfil"';
        }

        field(50019; SubCliente_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("SubCliente"), TipoRegistro = const(Tabla));
            Caption = 'SubCliente', comment = 'ESP="SubCliente"';
        }

        field(50020; ClienteReporting_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClienteReporting"), TipoRegistro = const(Tabla));
            Caption = 'Cliente Reporting', comment = 'ESP="Cliente Reporting"';
        }

        field(50021; PermiteEnvioMail_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Permite envío mail', comment = 'ESP="Permite envío mail"';
        }

        field(50022; CorreoFactElec_btc; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Correo electrónico', comment = 'ESP="Correo electrónico"';
        }
        field(50023; TipoFormarto_btc; Option)
        {
            OptionMembers = "Exportación","Nacional","Lidl","Brasil";
            Caption = 'SinFormato,Exportación,Nacional,Lidl,Brasil', Comment = 'ESP="SinFormato,Exportación,Nacional,Lidl,Brasil"';

        }

        field(50024; ClienteActividad_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(ClienteActividad), TipoRegistro = const(Tabla));
            Caption = 'Activity Customer', comment = 'ESP="Cliente Actividad"';
        }

        field(50025; CondicionesEspeciales; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Condiciones Especiales', comment = 'ESP="Condiciones Especiales"';
        }
        field(50026; Rappel; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Rappel', comment = 'ESP="Rappel"';
        }
        field(50027; Formadepagosolicitada; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Forma Pago CRM', comment = 'ESP="Forma Pago CRM"';
        }
        field(50028; AlertaMaquina; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Alert Message', comment = 'ESP="Mensaje de Alerta"';
        }
        field(50029; FechaVtoAseg; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Vto. Aseguradora', comment = 'ESP="Fecha Vto. Aseguradora"';
            editable = false;
        }
        field(50030; InsideSales_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("InsideSales"), TipoRegistro = const(Tabla));
            Caption =
             'Inside Sales', comment = 'ESP="Inside Sales"';
        }
        field(50031; Canal_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Canal"), TipoRegistro = const(Tabla));
            Caption = 'Canal', comment = 'ESP="Canal"';

            trigger OnValidate()
            var
                TextosAux: Record TextosAuxiliares;
            begin
                if TextosAux.get(TextosAux.TipoTabla::Canal, TextosAux.TipoRegistro::Tabla, Canal_btc) then
                    Mercado_btc := TextosAux.Mercado;
            end;
        }
        field(50032; Mercado_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Mercados), TipoRegistro = const(Tabla));
            Caption = 'Mercado', comment = 'ESP="Mercado"';
        }
        field(50033; clasificacion_aseguradora; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(ClasifAseguradora), TipoRegistro = const(Tabla));
            Caption = 'Clasif. Aseguradora', comment = 'ESP="Clasif. Aseguradora"';
        }
        field(50034; FechaVtoAseguradora; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry".FechaVtoAsegurador where("Customer No." = field("No."), Open = const(true),
                    Positive = const(true), "Posting Date" = field(FiltroFechaAseg)));
            Caption = 'Fecha Vto. Aseguradora', comment = 'ESP="Fecha Vto. Aseguradora"';
            editable = false;
        }
        field(50035; "FiltroFechaAseg"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Filtro Fecha Aseguradora', comment = 'ESP="Filtro Fecha Aseguradora"';

        }
        field(50036; "Filtro Aseguradora"; code[20])
        {
            FieldClass = FlowFilter;
            Caption = 'Filtro Aseguradora', Comment = 'ESP="Filtro Aseguradora"';
            Editable = true;
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(Tabla), TipoTabla = const(Aseguradora));
            ObsoleteState = Removed;

        }
        field(50037; "FechaVto"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Due Date" where("Customer No." = field("No."), Open = const(true),
                    Positive = const(true), "Posting Date" = field(FiltroFechaAseg)));

            Caption = 'Fecha Vto.', comment = 'ESP="Fecha Vto."';
            Editable = false;
        }
        field(50038; AseguradoraenFiltro; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("STH Hist. Aseguradora".Aseguradora where(CustomerNo = field("No."), "DateFin" = field(FiltroFechaAseg)));
            Caption = 'Aseguradora Vto.', comment = 'ESP="Aseguradora Vto."';
            editable = false;
        }
        field(50039; ImpCreditoAsegaenFiltro; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("STH Hist. Aseguradora"."Credito Maximo Aseguradora_btc" where(CustomerNo = field("No."), "DateFin" = field(FiltroFechaAseg)));
            Caption = 'Importe Credito Vto.', comment = 'ESP="Importe Credito Vto."';
            editable = false;
        }
        field(50040; "Saldo Vencido Aseguradora"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Initial Entry Due Date" = FiELD(UPPERLIMIT("Date Filter")),
                "Initial Entry Posting Date" = field(FiltroFechaAseg), "Excluded from calculation" = CONST(false)));


        }
        field(50041; "EORI"; code[20])
        {
            Caption = 'EORI', comment = 'ESP="EORI"';
        }
        field(50050; "EnviarCRM"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50052; AlertaPedidoServicio; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Alert Message Service Order', comment = 'ESP="Alerta Ped. Servicio"';
        }

        field(50060; "ABC Cliente"; Option)
        {
            OptionMembers = " ","3A","A","B","C","Z";
            OptionCaption = ' ,3A,A,B,C,Z', Comment = 'ESP=" ,3A,A,B,C,Z"';
        }
        field(50061; "Mostrar Documentos Netos"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Mostrar Documentos Netos', comment = 'ESP="Mostrar Documentos Netos"';
        }
        field(50070; "Dto. Exprimidores"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Dto. Exprimidores', comment = 'ESP="Dto. Exprimidores"';
        }
        field(50071; "Dto. Isla"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Dto. Isla', comment = 'ESP="Dto. Isla"';
        }
        field(50072; "Dto. Viva"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Dto. Viva', comment = 'ESP="Dto. Viva"';
        }
        field(50073; "Dto. Repuestos"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Dto. Repuestos', comment = 'ESP="Dto. Repuestos"';
        }
        field(50080; "Importe Facturas"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."), "Initial Entry Due Date" = FiELD(UPPERLIMIT("Date Filter")),
                "Initial Entry Posting Date" = field("Date Filter"), "Document Type" = const(Invoice), "Entry Type" = const("Initial Entry"), "Excluded from calculation" = CONST(false)));

            // trigger OnLookup()
            // var
            //     CustLedgerEntry: Record "Cust. Ledger Entry";
            // begin
            //     CustLedgerEntry.Reset();
            //     CustLedgerEntry.SetRange("Customer No.", Rec."No.");
            //     CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
            //     CustLedgerEntry.SetRange("Posting Date", Rec."Date Filter");
            //     Page.RunModal(0, CustLedgerEntry);
            // end;
        }
        field(50090; "Allows change Prices/Dates"; Boolean)
        {
            Caption = 'Allows change Prices/Dates', Comment = 'ESP="Permite cambio Precios/Dtos."';
            DataClassification = CustomerContent;
        }
        field(50100; FechaAlta; date)
        {
            Caption = 'Date of Registering', comment = 'ESP="Fecha Alta"';
            Editable = False;
        }
    }
    /*local procedure ActualizarFiltroFechasAseguradora()
    var
        HistAseg: Record "STH Hist. Aseguradora";
    begin
        HistAseg.SetRange(CustomerNo, "No.");
        HistAseg.SetRange(Aseguradora, "Filtro Aseguradora");
        if HistAseg.FindLast() then begin
            Rec.SetRange(FiltroFechaAseg, HistAseg.DateIni, HistAseg.DateFin);
        end else begin
            FiltroFechaAseg := 0D;
        end;
    end;*/
    trigger OnInsert()
    begin
        if Rec.FechaAlta = 0D then
            Rec.FechaAlta := Today();
    end;
}