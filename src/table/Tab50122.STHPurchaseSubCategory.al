table 50122 "STH Purchase SubCategory"
{
    Caption = 'Purchase SubCategory', Comment = 'ESP="Sub Categoría compras"';
    DataClassification = CustomerContent;

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
            TableRelation = "STH Purchase Category" where("Purch. Familiy code" = field("Purch. Category code"));
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
        field(10; "To Update"; Boolean)
        {
            Caption = 'To update', comment = 'ESP="Act. itbid"';
        }
        field(11; "Last date updated"; Date)
        {
            Caption = 'Last date updated', comment = 'ESP="Ult. Fecha act. itbid"';
        }
    }
    keys
    {
        key(PK; "Purch. Familiy code", Code)
        {
            Clustered = true;
        }
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
}
