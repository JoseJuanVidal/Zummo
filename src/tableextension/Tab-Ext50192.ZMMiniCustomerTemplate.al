tableextension 50192 "ZM Mini Customer Template" extends "Mini Customer Template"
{
    fields
    {

        field(30; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code', comment = 'ESP="Cód. condiciones envío"';
            TableRelation = "Shipment Method";

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo("Shipment Method Code"), Rec."Shipment Method Code");
            end;
        }
        field(50008; "Transaction Specification"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Specification', comment = 'ESP="Especificación transacción"';
            TableRelation = "Transaction Specification";

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo("Transaction Specification"), Rec."Transaction Specification");
            end;
        }
        field(50009; "Transaction Type"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type', comment = 'ESP="Naturaleza transacción"';
            TableRelation = "Transaction Type";

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo("Transaction Type"), Rec."Transaction Type");
            end;
        }
        field(50010; "Transport Method"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Transport Method', comment = 'ESP="Modo transporte"';
            TableRelation = "Transport Method";

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo("Transport Method"), Rec."Transport Method");
            end;
        }

        field(50013; CentralCompras_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Central Compras"), TipoRegistro = const(Tabla));
            Caption = 'Central Compras', comment = 'ESP="Central Compras"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(CentralCompras_btc), Rec.CentralCompras_btc);
            end;
        }
        field(50014; ClienteCorporativo_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Cliente Corporativo"), TipoRegistro = const(Tabla));
            Caption = 'Cliente Corporativo', comment = 'ESP="Cliente Corporativo"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(ClienteCorporativo_btc), Rec.ClienteCorporativo_btc);
            end;
        }
        field(50015; AreaManager_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("AreaManager"), TipoRegistro = const(Tabla));
            Caption = 'Area Manager', comment = 'ESP="Area Manager"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(AreaManager_btc), Rec.AreaManager_btc);
            end;
        }
        field(50016; Delegado_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Delegado"), TipoRegistro = const(Tabla));
            Caption = 'Delegado', comment = 'ESP="Delegado"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(Delegado_btc), Rec.Delegado_btc);
            end;
        }
        field(50017; GrupoCliente_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("GrupoCliente"), TipoRegistro = const(Tabla));
            Caption = 'Cliente Tipo', comment = 'ESP="Cliente Tipo"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(GrupoCliente_btc), Rec.GrupoCliente_btc);
            end;
        }

        field(50018; Perfil_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("Perfil"), TipoRegistro = const(Tabla));
            Caption = 'Perfil', comment = 'ESP="Perfil"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(Perfil_btc), Rec.Perfil_btc);
            end;
        }

        field(50019; SubCliente_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("SubCliente"), TipoRegistro = const(Tabla));
            Caption = 'SubCliente', comment = 'ESP="SubCliente"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(SubCliente_btc), Rec.SubCliente_btc);
            end;
        }

        field(50020; ClienteReporting_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("ClienteReporting"), TipoRegistro = const(Tabla));
            Caption = 'Cliente Reporting', comment = 'ESP="Cliente Reporting"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(ClienteReporting_btc), Rec.ClienteReporting_btc);
            end;
        }
        field(50024; ClienteActividad_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(ClienteActividad), TipoRegistro = const(Tabla));
            Caption = 'Activity Customer', comment = 'ESP="Cliente Actividad"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(ClienteActividad_btc), Rec.ClienteActividad_btc);
            end;
        }
        field(50030; InsideSales_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("InsideSales"), TipoRegistro = const(Tabla));
            Caption = 'Inside Sales', comment = 'ESP="Inside Sales"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(InsideSales_btc), Rec.InsideSales_btc);
            end;

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

                UpdateConfigTemplateLine(Rec.FieldNo(Canal_btc), Rec.Canal_btc);

            end;
        }
        field(50032; Mercado_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const(Mercados), TipoRegistro = const(Tabla));
            Caption = 'Mercado', comment = 'ESP="Mercado"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo(Mercado_btc), Rec.Mercado_btc);
            end;
        }
        field(50060; "ABC Cliente"; Option)
        {
            OptionMembers = " ","3A","A","B","C","Z";
            OptionCaption = ' ,3A,A,B,C,Z', Comment = 'ESP=" ,3A,A,B,C,Z"';

            trigger OnValidate()
            begin
                UpdateConfigTemplateLine(Rec.FieldNo("ABC Cliente"), format(Rec."ABC Cliente"));
            end;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        ConfigTemplateLine: record "Config. Template Line";


    local procedure UpdateConfigTemplateLine(UpdateFieldNo: Integer; DefaultValue: Text)
    var
        TemplateRef: RecordRef;
    begin
        ConfigTemplateLine.Reset();
        ConfigTemplateLine.SetRange("Data Template Code", Rec.Code);
        ConfigTemplateLine.SetRange("Table ID", Database::Customer);
        ConfigTemplateLine.SetRange("Field ID", UpdateFieldNo);
        if not ConfigTemplateLine.FindFirst() then begin
            ConfigTemplateLine.Reset();
            ConfigTemplateLine.INIT;
            ConfigTemplateLine."Data Template Code" := Rec.Code;
            ConfigTemplateLine.Type := ConfigTemplateLine.Type::Field;
            ConfigTemplateLine."Line No." := GetNextLineNo(Rec.Code);
            ConfigTemplateLine."Field ID" := UpdateFieldNo;
            ConfigTemplateLine."Table ID" := Database::Customer;
            ConfigTemplateLine.INSERT(TRUE);
        end;
        ConfigTemplateLine."Default Value" := DefaultValue;
        ConfigTemplateLine.Modify();
    end;

    local procedure GetNextLineNo(ConfigTemplateHeaderCode: Code[10]): Integer
    var
        ConfigTemplateLine: Record "Config. Template Line";
    begin
        ConfigTemplateLine.SETRANGE("Data Template Code", ConfigTemplateHeaderCode);
        IF ConfigTemplateLine.FINDLAST THEN
            EXIT(ConfigTemplateLine."Line No." + 10000);

        EXIT(10000);
    end;
}