table 50120 "STH Purchase Family"
{
    Caption = 'Purchase Family', Comment = 'ESP="Familia de compras"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code', Comment = 'ESP="Código"';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
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
        key(PK; Code)
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
