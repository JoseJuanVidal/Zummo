table 17387 "ZM General Ledger Mapeo SEB"
{
    DataClassification = CustomerContent;
    Caption = 'General Ledger Mapeo SEB', comment = 'ESP="Conf. Contabilidad Mapeo SEB"';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Company or."; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; Company; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(4; Reparto; decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Account Number (7d)"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            ValidateTableRelation = false;
        }
        field(6; Nombre; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Account Number (4d)"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
            ValidateTableRelation = false;
        }
        field(8; "CECO"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Conso item code"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Conso item description"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Nature code"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Nature description"; text[100])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Chart of accounts 1"; code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Chart of accounts by function (Lvl.1)';
        }
        field(14; "Chart of accounts 2"; code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Chart of accounts by function (Lvl.2)';
        }
        field(15; "ROPA-UNDER ROPA"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(16; "Reporting Zummo C1 - Clasif1"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Reporting Zummo C2 - Clasif2"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(18; "Reporting Zummo C3 - Clasif3"; code[50])
        {
            DataClassification = CustomerContent;
        }
        field(19; "EBITDA-UNDER EBITDA"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(20; "CONCILIACIÓN"; code[20])
        {
            DataClassification = CustomerContent;
        }
        field(21; "LEVEL 2"; code[50])
        {
            DataClassification = CustomerContent;
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

    procedure DistributionCheck()
    var
        MapeoSEB: record "ZM General Ledger Mapeo SEB";
        lblMSG: Label 'The sum of Distribution %1 is %2 divisible by 1', comment = 'ESP="La suma del Reparto %1 %2 es divisible entre 1"';
        lblNOT: Label 'NOT', comment = 'ESP="NO"';
    begin
        MapeoSEB.Reset();
        MapeoSEB.CalcSums(Reparto);
        case (MapeoSEB.Reparto mod 1) = 0 of
            true:
                Message(lblMSG, MapeoSEB.Reparto, '');
            else
                Error(lblMSG, MapeoSEB.Reparto, lblNOT);
        end;
    end;
}