table 17423 "SCRAP Item - Tipo de Envase"
{
    DataClassification = CustomerContent;
    Caption = 'Tipo de Envase productos', comment = 'ESP="Tipo de Envase productos"';
    LookupPageId = "SCRAP Item - Tipo de Envases";
    DrillDownPageId = "SCRAP Item - Tipo de Envases";

    fields
    {
        field(1; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. producto"';
            TableRelation = Item;
        }
        field(2; SUBMATERIAL; code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "SCRAP SUBMATERIAL";
        }
        field(3; "Tipo de Envase"; text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "SCRAP SubMaterial Tipo Envases" where(SUBMATERIAL = field(SUBMATERIAL));
        }
        field(5; Flexible; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(10; Tarifa; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
    }

    keys
    {
        key(PK; "Item No.", SUBMATERIAL, "Tipo de Envase")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; SUBMATERIAL, "Tipo de Envase", Flexible, Tarifa)
        { }
        fieldgroup(Brick; SUBMATERIAL, "Tipo de Envase", Flexible, Tarifa)
        { }
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