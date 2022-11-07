table 50103 "ZM CIM Items temporary"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(42; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight', Comment = 'ESP="Peso Neto"';
        }
        field(44; "Unit Volume"; Decimal)
        {
            Caption = 'Unit Volume', Comment = 'ESP="Volumen"';
        }
        field(50125; Material; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Material', comment = 'ESP="Material"';
        }
        field(59001; Largo; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Material', comment = 'ESP="Material"';
        }
        field(59002; Ancho; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Material', comment = 'ESP="Material"';
        }
        field(59003; Alto; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Material', comment = 'ESP="Material"';
        }
        field(50005; EnglishDescription; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'English Description', comment = 'ESP="Descripción Ingles"';
        }
    }

    keys
    {
        key(Key1; "No.")
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

}