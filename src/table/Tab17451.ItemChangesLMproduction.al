table 17451 "Item Changes L.M. production"
{
    DataClassification = CustomerContent;
    LookupPageId = "ZM Item Changes L.M. prod.";
    DrillDownPageId = "ZM Item Changes L.M. prod.";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Item No."; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. producto"';
            TableRelation = Item;

            trigger OnValidate()
            begin
                ValidateItemNo();
            end;
        }
        field(20; "Item Description"; text[100])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(30; Task; Enum "ZM Task Production Bom change")
        {
            DataClassification = CustomerContent;
            Caption = 'Tasks', comment = 'ESP="Tareas"';
        }
        field(40; "Quantity per"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity per', comment = 'ESP="Cantidad por"';
        }
        field(50; "Quantity add"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity add', comment = 'ESP="Cantidad añadir"';
        }
        field(60; "Unit of measure"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of measure', comment = 'ESP="Unidad de medida"';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(70; "Routing Link Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Routing Link Code', comment = 'ESP="Cód. conexión ruta"';
        }
        field(80; "Item No. to be replaced"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No. to be replaced', comment = 'ESP="Cód. producto a reemplazar"';
            TableRelation = Item;
        }
        field(90; "Replaced Item Description"; text[100])
        {
            Caption = 'Description to be replaced', comment = 'ESP="Descripción a reemplazar"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No. to be replaced")));
        }
        field(100; "New Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'New Item No.', comment = 'ESP="Nuevo Cód. producto"';
            TableRelation = Item;
        }
        field(110; "New Item Description"; text[100])
        {
            Caption = 'New Item Description', comment = 'ESP="Descripción nuevo"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("New Item No.")));
        }
        field(120; "New Unit of measure"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of measure', comment = 'ESP="Unidad de medida"';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("New Item No."));
        }
        field(1000; "Production BOM No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Production BOM No.', Comment = 'ESP="Nº L.M. producción"';
        }
        field(1002; "Action"; Enum "ZM Action Changes Items")
        {
            DataClassification = CustomerContent;
            Caption = 'Action', comment = 'ESP="Acción"';
        }
        field(1003; "Original Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Original Quantity', comment = 'ESP="Cantidad original"';
        }
        field(1004; "Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Action Quantity', comment = 'ESP="Cantidad acción"';
        }
        field(1007; "New Action"; Enum "ZM Action Changes Items")
        {
            DataClassification = CustomerContent;
            Caption = 'New Action', comment = 'ESP="Acción nuevo"';
        }
        field(1008; "New Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'New Quantity', comment = 'ESP="Cantidad nuevo"';
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

    local procedure ValidateItemNo()
    begin
        if Rec."Item No. to be replaced" = '' then
            Rec."Item No. to be replaced" := Rec."Item No.";
    end;

}
