table 50122 "STH Purchase SubCategory"
{
    Caption = 'Purchase SubCategory', Comment = 'ESP="Sub Categoría compras"';
    DataClassification = CustomerContent;
    LookupPageId = "STH Purchase SubCategorys";
    DrillDownPageId = "STH Purchase SubCategorys";


    fields
    {
        field(1; "Purch. Familiy code"; Code[20])
        {
            Caption = 'Purch. Familiy code', Comment = 'ESP="Cód. Familía"';
            DataClassification = CustomerContent;
            TableRelation = "STH Purchase Family";
        }
        field(2; "Purch. Category code"; Code[20])
        {
            Caption = 'Purch. Category code', Comment = 'ESP="Cód. Category"';
            DataClassification = CustomerContent;
            TableRelation = "STH Purchase Category".Code where("Purch. Familiy code" = field("Purch. Familiy code"));
        }
        field(3; Code; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            DataClassification = CustomerContent;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = ToBeClassified;
        }
        field(5; "Description 2"; Text[100])
        {
            Caption = 'Description 2', Comment = 'ESP="Descripción 2"';
            DataClassification = ToBeClassified;
        }
        field(10; "To Update"; Boolean)
        {
            Caption = 'To update', comment = 'ESP="Act. itbid"';
        }
        field(11; "Last date updated"; Date)
        {
            Caption = 'Last date updated', comment = 'ESP="Ult. Fecha act. itbid"';
        }
        field(20; "Items No."; integer)
        {
            Caption = 'Items No.', comment = 'ESP="Nª productos"';
            FieldClass = FlowField;
            CalcFormula = count(Item where("Purch. Family" = field("Purch. Familiy code"), "Purch. Category" = field("Purch. Category code"), "Purch. SubCategory" = field(Code)));
        }
    }
    keys
    {
        key(PK; "Purch. Familiy code", "Purch. Category code", Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; code, Description, "Description 2") { }
        fieldgroup(Brick; code, Description, "Description 2") { }
    }
    trigger OnInsert()
    begin
        rec."To Update" := true;
    end;

    trigger OnModify()
    begin
        rec."To Update" := true;
    end;

    trigger OnRename()
    begin
        rec."To Update" := true;
    end;

    trigger OnDelete()
    begin
        Rec.CalcFields("Items No.");
        Rec.TestField("Items No.", 0);
    end;
}
