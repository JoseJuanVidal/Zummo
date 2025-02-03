table 17202 "ZM Job Amount BOM"
{
    DataClassification = CustomerContent;
    Caption = 'Amount BOM', comment = 'ESP="Importe Lista de materiales"';
    LookupPageId = "ZM Job Amount BOM";
    DrillDownPageId = "ZM Job Amount BOM";

    fields
    {
        field(1; "Job No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No.', comment = 'ESP="Cód. Proyecto"';
            TableRelation = Job;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', comment = 'ESP="Nº Línea"';
            AutoIncrement = true;
        }
        field(10; Comment; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment', comment = 'ESP="Comentario"';
        }
        field(20; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha Registro"';
        }
        field(30; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount', comment = 'ESP="Importe"';
        }
    }

    keys
    {
        key(PK; "Job No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Posting Date")
        { }
        fieldgroup(DropDown; "Posting Date", Comment)
        { }
    }
}