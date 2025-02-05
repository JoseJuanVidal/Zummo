table 17386 "ZM General Ledger Mapeo Zummo"
{
    DataClassification = CustomerContent;
    Caption = 'General Ledger Mapeo Zummo', comment = 'ESP="Conf. Contabilidad Mapeo Zummo"';
    LookupPageId = "ZM General Ledger Mapeo ZUMMO";
    DrillDownPageId = "ZM General Ledger Mapeo ZUMMO";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "G/L Account"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            ValidateTableRelation = false;
        }
        field(3; Empresa; code[50])
        {
            Caption = 'Empresa', comment = 'ESP="Empresa"';
        }
        field(4; Informe; code[50])
        {
            Caption = 'Informe', comment = 'ESP="Informe"';
        }
        field(5; Ajuste; code[50])
        {
            Caption = 'Ajuste', comment = 'ESP="Ajuste"';
        }
        field(6; C1; code[50])
        {
            Caption = 'C1', comment = 'ESP="C1"';
        }
        field(7; C2; code[50])
        {
            Caption = 'C2', comment = 'ESP="C2"';
        }
        field(8; C3; code[50])
        {
            Caption = 'C3', comment = 'ESP="C3"';
        }
        field(9; C4; code[50])
        {
            Caption = 'C4', comment = 'ESP="C4"';
        }
        field(10; C5; code[50])
        {
            Caption = 'C5', comment = 'ESP="C5"';
        }
        field(11; C6; code[50])
        {
            Caption = 'C6', comment = 'ESP="C6"';
        }
        field(12; Tipo; code[50])
        {
            Caption = 'Tipo', comment = 'ESP="Tipo"';
        }
        field(13; H1; text[50])
        {
            Caption = 'H1', comment = 'ESP="H1"';
        }
        field(14; H2; text[50])
        {
            Caption = 'H2', comment = 'ESP="H2"';
        }
        field(15; H3; text[100])
        {
            Caption = 'H3', comment = 'ESP="H3"';
        }
        field(16; H4; text[100])
        {
            Caption = 'H4', comment = 'ESP="H4"';
        }
        field(17; H5; text[100])
        {
            Caption = 'H5', comment = 'ESP="H5"';
        }
        field(18; H6; text[100])
        {
            Caption = 'H6', comment = 'ESP="H6"';
        }
        field(19; DescCuentaEspañol; text[100])
        {
            Caption = 'Desc Cuenta Español', comment = 'ESP="Desc Cuenta Español"';
        }
        field(20; CuentaAmericana; text[100])
        {
            Caption = 'Cuenta Americana', comment = 'ESP="Cuenta Americana"';
        }
        field(21; IC1; text[100])
        {
            Caption = 'IC1', comment = 'ESP="IC1"';
        }
        field(22; IC2; text[100])
        {
            Caption = 'IC2', comment = 'ESP="IC2"';
        }
        field(23; IC3; text[100])
        {
            Caption = 'IC3', comment = 'ESP="IC3"';
        }
        field(24; IC4; text[100])
        {
            Caption = 'IC4', comment = 'ESP="IC4"';
        }
        field(25; IC5; text[100])
        {
            Caption = 'IC5', comment = 'ESP="IC5"';
        }
        field(26; IC6; text[100])
        {
            Caption = 'IC6', comment = 'ESP="IC6"';
        }
        field(27; IH1; text[100])
        {
            Caption = 'IH1', comment = 'ESP="IH1"';
        }
        field(28; IH2; text[100])
        {
            Caption = 'IH2', comment = 'ESP="IH2"';
        }
        field(29; IH3; text[100])
        {
            Caption = 'IH3', comment = 'ESP="IH3"';
        }
        field(30; IH4; text[100])
        {
            Caption = 'IH4', comment = 'ESP="IH4"';
        }
        field(31; IH5; text[100])
        {
            Caption = 'IH5', comment = 'ESP="IH5"';
        }
        field(32; IH6; text[100])
        {
            Caption = 'IH6', comment = 'ESP="IH6"';
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

}