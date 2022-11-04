table 50153 "ZM Prod. Tools Ledger Entry"
{
    DataClassification = ToBeClassified;
    Caption = '', comment = 'ESP=""';
    LookupPageId = "ZM Prod. Tools Ledger Entry";
    DrillDownPageId = "ZM Prod. Tools Ledger Entry";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Prod. Tools code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prod. Tools code', comment = 'ESP="Cód. Utiles producción"';
            TableRelation = "ZM Productión Tools";
            Editable = false;
        }
        field(3; "Prod. Tools Name"; text[100])
        {
            Caption = 'Prod. Tools Name', comment = 'ESP="Nombre Utiles producción"';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            Editable = false;
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

            trigger OnValidate()
            begin
                ValidatePostingDate;
            end;
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
            Caption = 'Last date revision', Comment = 'ESP="Ult. Revisión"';
            DataClassification = CustomerContent;
        }
        field(24; "Resolution"; enum "ZM Production tools resolution")
        {
            DataClassification = CustomerContent;
        }
        field(25; "Next date revision"; Date)
        {
            Caption = 'Next date revision', Comment = 'ESP="Próxima Revisión"';
            DataClassification = CustomerContent;
            Editable = false;
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
        key(Key2; "Prod. Tools code", "Last date revision")
        {

        }
        key(Key3; "Prod. Tools code", "Next date revision")
        {

        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        if Rec."Entry No." = 0 then
            Rec."Entry No." := GetNewEntryNo();
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

    local procedure ValidatePostingDate()
    var

    begin
        Rec.CalcFields(Periodicity);
        Rec."Next date revision" := CalcDate(rec.Periodicity, Rec."Posting Date");

    end;

    procedure AddRevisionProdTools(tmpProdToolsLdgEntry: Record "ZM Prod. Tools Ledger Entry" temporary)
    var
        ProdToolsLdgEntry: Record "ZM Prod. Tools Ledger Entry";
    begin
        ProdToolsLdgEntry.Init();
        ProdToolsLdgEntry.TransferFields(tmpProdToolsLdgEntry);
        ProdToolsLdgEntry.Insert(true);
    end;

    local procedure GetNewEntryNo() EntryNo: Integer;
    var
        ProdToolsLdgEntry: Record "ZM Prod. Tools Ledger Entry";
    begin
        ProdToolsLdgEntry.Reset();
        if ProdToolsLdgEntry.FindLast() then
            EntryNo := ProdToolsLdgEntry."Entry No." + 1
        else
            EntryNo := 1;
    end;


}