table 17381 "ZM Visit log"
{
    DataClassification = CustomerContent;
    Caption = 'Visit log', comment = 'ESP="Registro de Visitas"';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Fecha/hora entrada"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Fecha/hora salida"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Nombre completo"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Empresa"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(8; "Trabajo"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Autorizado por"; text[250])
        {
            DataClassification = CustomerContent;
        }
        field(10; Estado; text[50])
        {
            DataClassification = CustomerContent;
        }
        field(20; Firma; MediaSet)
        {
            DataClassification = CustomerContent;
            Caption = 'Signature', comment = 'ESP="Firma"';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        InitLastNo();
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

    procedure InitLastNo(): Integer
    var
        Visitlog: Record "ZM Visit log";
    begin
        if Rec."Entry No." <> 0 then
            exit;
        Visitlog.Reset();
        if Visitlog.FindLast() then
            Rec."Entry No." := Visitlog."Entry No." + 1
        else
            Rec."Entry No." := 1;
    end;

}