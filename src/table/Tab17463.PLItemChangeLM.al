table 17463 "PL Item Change LM"
{
    DataClassification = CustomerContent;
    Caption = 'Sustitución en Lista Materiales', comment = 'ESP="Sustitución en Lista Materiales"';

    fields
    {
        field(1; "Request No."; Code[20])
        {
            Caption = 'Request No.', Comment = 'ESP="Nº Solicitud"';
            DataClassification = CustomerContent;
            TableRelation = "ZM PL Items Temporary";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', comment = 'ESP="Nº Línea"';
        }
        field(3; "Production BOM No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Production BOM No.', comment = 'ESP="Cód. L.M. Producción"';
            TableRelation = "Production BOM Header";
        }
        field(4; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. producto"';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                Validate_ItemNo();
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
            // Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = lookup(item.Description where("No." = field("Item No.")));
        }
        field(6; "Production BOM Name"; text[100])
        {
            Caption = 'Production BOM Name', comment = 'ESP="Nombre L.M."';
            FieldClass = FlowField;
            CalcFormula = lookup("Production BOM Header".Description where("No." = field("Production BOM No.")));
            Editable = false;
        }
        field(10; Action; Enum "Cambio LM Accion linea")
        {
            DataClassification = CustomerContent;
            Caption = 'Action', comment = 'ESP="Acción"';
        }
        field(20; "Quantity per"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cantidad por', comment = 'ESP="Cantidad por"';
        }
    }

    keys
    {
        key(PK; "Request No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        Item: Record Item;

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


    local procedure Validate_ItemNo()
    begin
        if Item.Get("Item No.") then
            Rec.Description := Item.Description;
    end;
}