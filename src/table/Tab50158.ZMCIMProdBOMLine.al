table 50158 "ZM CIM Prod. BOM Line"
{
    Caption = 'Production BOM Line', Comment = 'ESP="Línea L.M. producción"';
    LookupPageId = "ZM CIM Production BOM Lines";
    DrillDownPageId = "ZM CIM Production BOM Lines";

    fields
    {
        field(1; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.', Comment = 'ESP="Nº L.M. producción"';
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº línea"';
        }
        field(3; "Version Code"; Code[20])
        {
            Caption = 'Version Code', Comment = 'ESP="Cód. versión"';
        }
        field(10; Type; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            OptionCaption = ' ,Item,Production BOM,ERPLINK Item', Comment = 'ESP=" ,Producto,L.M. producción,ERPLINK Producto"';
            OptionMembers = " ",Item,"Production BOM",ERPLiNKItem;

        }
        field(11; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            TableRelation = if (type = const(Item)) Item
            else
            if (type = const("Production BOM")) "Production BOM Header"
            else
            if (type = const(ERPLiNKItem)) "ZM CIM Items temporary"."No.";

            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                OnValidate_No();
            end;
        }
        field(12; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(13; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code', Comment = 'ESP="Cód. unidad medida"';
        }
        field(14; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
            DecimalPlaces = 0 : 5;
        }
        field(15; Position; Code[10])
        {
            Caption = 'Position', Comment = 'ESP="Posición"';
        }
        field(16; "Position 2"; Code[10])
        {
            Caption = 'Position 2', Comment = 'ESP="Posición 2"';
        }
        field(17; "Position 3"; Code[10])
        {
            Caption = 'Position 3', Comment = 'ESP="Posición 3"';
        }
        field(18; "Lead-Time Offset"; DateFormula)
        {
            Caption = 'Lead-Time Offset', Comment = 'ESP="Desfase plazo entrega"';
        }
        field(19; "Routing Link Code"; Code[10])
        {
            Caption = 'Routing Link Code', Comment = 'ESP="Cód. conexión ruta"';
        }
        field(20; "Scrap %"; Decimal)
        {
            BlankNumbers = BlankNeg;
            Caption = 'Scrap %', Comment = 'ESP="% Rechazo"';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
        }
        field(21; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code', Comment = 'ESP="Cód. variante"';
        }
        field(40; Length; Decimal)
        {
            Caption = 'Length', Comment = 'ESP="Longitud"';
            DecimalPlaces = 0 : 5;
        }
        field(41; Width; Decimal)
        {
            Caption = 'Width', Comment = 'ESP="Ancho"';
            DecimalPlaces = 0 : 5;
        }
        field(42; Weight; Decimal)
        {
            Caption = 'Weight', Comment = 'ESP="Peso"';
            DecimalPlaces = 0 : 5;
        }
        field(43; Depth; Decimal)
        {
            Caption = 'Depth', Comment = 'ESP="Altura"';
            DecimalPlaces = 0 : 5;
        }
        field(44; "Calculation Formula"; Option)
        {
            Caption = 'Calculation Formula', Comment = 'ESP="Tipo cálculo"';
            OptionCaption = ' ,Length,Length * Width,Length * Width * Depth,Weight', Comment = 'ESP=" ,Largo,Largo * Ancho,Largo * Ancho * Alto,Peso"';
            OptionMembers = " ",Length,"Length * Width","Length * Width * Depth",Weight;
        }
        field(45; "Quantity per"; Decimal)
        {
            Caption = 'Quantity per', Comment = 'ESP="Cantidad por"';
            DecimalPlaces = 0 : 5;
        }
        field(50; "Prod. BOM No. Components"; Code[20])
        {
            Caption = 'Production BOM No. Components', Comment = 'ESP="Nº L.M. Componentes producción"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM CIM Items temporary"."Production BOM No." where("No." = field("No.")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Production BOM No.", "Version Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Type, "No.")
        {
        }
    }


    trigger OnInsert()
    begin
        if Rec."Line No." = 0 then
            Rec."Line No." := GetLastLineno();
    end;

    trigger OnModify()
    begin
        if Rec."Line No." = 0 then
            Rec."Line No." := GetLastLineno();
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    local procedure OnValidate_No()
    var
        Item: Record Item;
        CIMItemstemporary: record "ZM CIM Items temporary";
        CIMProdBOMHeader: Record "ZM CIM Prod. BOM Header";
    begin
        case type of
            Type::" ":
                Rec.Description := '';
            Type::Item:
                begin
                    CheckBomHeader(Rec."Production BOM No.");
                    if Item.get("No.") then
                        Rec.Description := Item.Description;
                end;
            Type::"Production BOM":
                begin
                    CheckBomHeader(Rec."Production BOM No.");
                    if CIMProdBOMHeader.get(Rec."No.") then
                        Rec.Description := CIMProdBOMHeader.Description;
                end;
            Type::ERPLiNKItem:
                begin
                    CheckBomHeader(Rec."Production BOM No.");
                    if CIMItemstemporary.get("No.") then
                        rec.Description := CIMItemstemporary.Description;
                end;

        end;
    end;

    local procedure CheckBomHeader(BomLine: code[20])
    var
        CIMProdBOMHeader: Record "ZM CIM Prod. BOM Header";
    begin
        if BomLine = '' then
            exit;
        if not CIMProdBOMHeader.get(BomLine) then begin
            CIMProdBOMHeader.Init();
            CIMProdBOMHeader."No." := BomLine;
            CIMProdBOMHeader.Description := BomLine;
            CIMProdBOMHeader.Insert();
        end;

    end;

    local procedure GetLastLineno(): Integer
    var
        CIMProdBOMLine: record "ZM CIM Prod. BOM Line";
    begin
        CIMProdBOMLine.Reset();
        CIMProdBOMLine.SetRange("Production BOM No.", Rec."Production BOM No.");
        if CIMProdBOMLine.FindLast() then
            exit(CIMProdBOMLine."Line No." + 1)
        else
            exit(1)
    end;
}
