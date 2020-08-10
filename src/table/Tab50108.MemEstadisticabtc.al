table 50108 "MemEstadistica_btc"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; NoMov; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; NoLote; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Noproducto; Code[20])
        {
            Caption = 'MyField';
            DataClassification = ToBeClassified;
        }
        field(4; NoSerie; Code[20])
        {
            Caption = 'MyField';
            DataClassification = ToBeClassified;
        }
        field(5; Contador; Integer)
        {
            Caption = 'MyField';
            DataClassification = ToBeClassified;
        }



    }

    keys
    {
        key(PK; NoMov)
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