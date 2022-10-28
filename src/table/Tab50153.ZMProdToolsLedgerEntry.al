table 50153 "ZM Prod. Tools Ledger Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Prod. Tools code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. Tools code', comment = 'ESP="Cód. utiles producción"';
            TableRelation = "ZM Productión Tools";
        }
        field(10; "Vendor No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.', comment = 'ESP="Cód. proveedor"';
            TableRelation = Vendor;
        }
        field(11; "Vendor Name"; text[100])
        {
            Caption = 'Vendor Name', comment = 'ESP="Nombre proveedor"';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            Editable = false;
        }
        field(20; "Ref. Certificate"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Ref. Certificate', comment = 'ESP="Ref. Certificado"';
        }
        field(21; "Posting Date"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha registro"';
        }
        field(22; Periodicity; DateFormula)
        {
            Caption = 'Periodicity', Comment = 'ESP="Periodicidad"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM Productión Tools".Periodicity where(Code = field("Prod. Tools code")));
            Editable = false;
        }
        field(23; "Last date revision"; Date)
        {
            Caption = 'Last date revision', Comment = 'ESP="Ult. fecha revisión"';
            DataClassification = CustomerContent;
        }
        field(24; "Resolution"; enum "ZM Production tools resolution")
        {
            DataClassification = CustomerContent;
        }
        field(50; "Reason"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP="Motivo"';
            TableRelation = TextosAuxiliares.NumReg where(TipoRegistro = const(Tabla), TipoTabla = const(motivoCalibracion));
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}