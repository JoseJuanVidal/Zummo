table 17409 "ZM BCD Travel Empleado"
{
    DataClassification = CustomerContent;
    Caption = 'BCD Travel Empleado', comment = 'ESP="BCD Travel Empleado"';
    LookupPageId = "ZM BCD Travel Empleado";
    DrillDownPageId = "ZM BCD Travel Empleado";

    fields
    {
        field(1; "Codigo"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Código', comment = 'ESP="Código"';
        }
        field(2; Nombre; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Nombre', comment = 'ESP="Nombre"';
        }
        field(3; "Proyecto"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Proyecto', comment = 'ESP="Proyecto"';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(10; "G/L Account"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Account', comment = 'ESP="Cuenta contableW"';
            TableRelation = "G/L Account" where("Account Type" = const(Posting), "Direct Posting" = const(true));
        }
    }

    keys
    {
        key(PK; Codigo)
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