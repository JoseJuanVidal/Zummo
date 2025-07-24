table 17422 "SCRAP SubMaterial Tipo Envases"
{
    DataClassification = CustomerContent;
    Caption = 'Submaterial - Tipo de Envase', comment = 'ESP="Submaterial - Tipo de Envase"';
    LookupPageId = "SCRAP Submaterial Tipo Envases";
    DrillDownPageId = "SCRAP Submaterial Tipo Envases";

    fields
    {
        field(1; SUBMATERIAL; code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "SCRAP SUBMATERIAL";
        }
        field(2; "Tipo de Envase"; text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "SCRAP Tipo de Envases";
        }
        field(5; Rigidez; code[1])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("SCRAP Tipo de Envases".Rigidez where(Code = field("Tipo de Envase")));
            Editable = false;
        }
        field(10; Tarifa; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        field(20; "Tipo Mercado"; code[20])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; SUBMATERIAL, "Tipo de Envase")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; SUBMATERIAL, "Tipo de Envase", Rigidez, Tarifa)
        { }
        fieldgroup(Brick; SUBMATERIAL, "Tipo de Envase", Rigidez, Tarifa)
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