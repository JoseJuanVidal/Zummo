table 17413 "ZM PL Items temporary"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then
                    if xRec."No." = '' then begin
                        GetPreItemSetup();
                        NoSeriesMgt.TestManual(SetupPreItemReg."Temporary Nos.");
                    end;
            end;

        }
        field(3; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(6; "Assembly BOM"; Boolean)
        {
            Caption = 'Assembly BOM', Comment = 'ESP="L.M. de Ensamblado"';
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure', Comment = 'ESP="Unidad medida base"';
        }
        field(42; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight', Comment = 'ESP="Peso Neto"';
        }
        field(44; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume', Comment = 'ESP="Volumen"';
        }
        field(68; Inventory; Decimal)
        {
            Caption = 'Inventory', Comment = 'ESP="Inventario"';
        }
        field(92; Picture; MediaSet)
        {
            Caption = 'Picture', Comment = 'ESP="Picture"';
        }
        field(97; "Nos. series"; code[20])
        {
            Caption = 'Nos. series', Comment = 'ESP="No. Series"';
        }
        Field(50125; Material; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Material', comment = 'ESP="Material"';
        }
        field(59001; Largo; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Largo', comment = 'ESP="Largo"';
        }
        field(59002; Ancho; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Ancho', comment = 'ESP="Ancho"';
        }
        field(59003; Alto; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Alto', comment = 'ESP="Alto"';
        }
        field(50805; EnglishDescription; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'English Description', comment = 'ESP="Descripción Ingles"';
        }
        field(50806; Packaging; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Packaging', comment = 'ESP="Embalaje"';
        }
        field(50807; Color; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Color', comment = 'ESP="Color"';
        }
        field(50810; "State Creation"; Enum "ZM PL State Creation Item")
        {
            DataClassification = CustomerContent;
            Caption = 'State Creation', comment = 'ESP="Estado Alta"';
            Editable = false;
        }
        field(50820; Department; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Department', comment = 'ESP="Departamento"';
            TableRelation = "ZM PL Item Setup Department";
        }
        field(50821; "Product manager"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Product manager', comment = 'ESP="Responsable"';
        }
        field(50822; Reason; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Reason', comment = 'ESP="Motivo"';
        }
        field(50823; Activity; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Activity', comment = 'ESP="Actividad"';
        }
        field(50824; Prototype; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Prototype', comment = 'ESP="Prototipo"';
        }
        field(50825; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha Registro"';
        }
        field(99000750; "Routing No."; Code[20])
        {
            Caption = 'Routing No.', Comment = 'ESP="Nº ruta"';
        }
        field(99000751; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.', Comment = 'ESP="Nº L.M. producción"';
            TableRelation = "ZM CIM Prod. BOM Header";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    var
        Item: Record Item;
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMLine: Record "Production BOM Line";
        ZMCIMProdBOMHeader: Record "ZM CIM Prod. BOM Header";
        ZMCIMProdBOMLine: Record "ZM CIM Prod. BOM Line";
        ZMCIMProdDocuments: Record "ComentariosPredefinidos";
        lblConfirmBOM: Label 'El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?', comment = 'ESP="El producto %1 %2 tiene una lista de ensamblado o producción,¿Desea insertar esta también?"';

    trigger OnInsert()
    begin
        GetPreItemSetup();
        SetupPreItemReg.TESTFIELD("Temporary Nos.");
        if "No." = '' then begin
            NoSeriesMgt.InitSeries(SetupPreItemReg."Temporary Nos.", xRec."Nos. series", 0D, Rec."No.", Rec."Nos. series");
        end;
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

    var
        SetupPreItemReg: record "ZM PL Setup Item registration";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure GetPreItemSetup()
    begin
        SetupPreItemReg.GET;
    end;

    procedure AssistEdit(): Boolean
    begin
        GetPreItemSetup;
        SetupPreItemReg.TESTFIELD("Temporary Nos.");
        if NoSeriesMgt.SelectSeries(SetupPreItemReg."Temporary Nos.", xRec."Nos. Series", "Nos. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            EXIT(TRUE);
        end;
    end;
}