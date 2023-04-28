table 17440 "ZM IT Daily Time Sheet"
{
    DataClassification = CustomerContent;
    Caption = 'Daily Time Sheet', comment = 'ESP="Partes Diarios"';

    fields
    {
        field(1; id; Guid)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha registro"';
        }
        field(3; "User id"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User Id', comment = 'ESP="Id. Usuario"';
            TableRelation = "User Setup";
        }
        field(4; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date', comment = 'ESP="Fecha"';
        }
        field(5; Quantity; Duration)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; id)
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

    procedure GetDuration(TimeType: enum "ZM IT Time Setup"; Value: Duration): decimal
    begin
        case TimeType of
            TimeType::" ":
                exit(Value);
            TimeType::"100/Hour":
                exit(Value / 36000);
            TimeType::Days:
                exit(Value / 86400000);
            TimeType::Hours:
                exit(Value / 3600000);
            TimeType::Minutes:
                exit(Value / 60000);
        end;
    end;

}