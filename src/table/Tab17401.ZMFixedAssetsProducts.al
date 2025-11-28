table 17401 "ZM Fixed Assets Products"
{
    Caption = 'Fixed Assets Products', Comment = 'ESP="Productos de Activos Fijos"';
    Description = 'Fixed Assets Products';
    LookupPageId = "ZM Fixed Assets Products";
    DrillDownPageId = "ZM Fixed Assets Products";

    fields
    {
        field(1; "FA No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'FA No.', comment = 'ESP="Nº Activo fijo"';
            TableRelation = "Fixed Asset";
        }
        field(2; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. producto"';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                UpdateItem();
            end;
        }
        field(3; Description; text[100])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
            // FieldClass = FlowField;
            // CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            // Editable = false;
        }
        field(5; "Dependent"; Boolean)
        {
            Caption = 'Dependent', comment = 'ESP="Dependiente"';
        }
        field(10; "FA Name"; text[100])
        {
            Caption = 'FA Name', comment = 'ESP="Nombre Act. Fijo"';
            FieldClass = FlowField;
            CalcFormula = lookup("Fixed Asset".Description where("No." = field("FA No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "FA No.", "Item No.")
        {
            Clustered = true;
        }
    }

    var
        Item: Record Item;

    local procedure UpdateItem()
    begin
        IF Item.gET("Item No.") then
            Rec.Description := Item.Description;
    end;
}