table 17379 "ZM Reporting SEB Detail"
{
    DataClassification = CustomerContent;
    Caption = 'Reporting SEB Details', comment = 'ESP="Reporting SEB Details"';
    LookupPageId = "ZM Reporting SEB Details";
    DrillDownPageId = "ZM Reporting SEB Details";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "CMMF Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CMMF Code', comment = 'ESP="CMMF Code"';
        }
        field(3; "MLA"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'MLA', comment = 'ESP="MLA"';
        }
        field(5; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. producto"';
        }
        field(6; Description; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(7; "Document No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.', comment = 'ESP="Nº Documento"';
        }
        field(8; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', comment = 'ESP="Fecha registro"';
        }
        field(10; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity', comment = 'ESP="Cantidad"';
        }
        field(20; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Amount', comment = 'ESP="Importe Ventas"';
        }
        field(30; Costs; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Costs Amount', comment = 'ESP="Importe Coste"';
        }
        field(31; UnitCosts; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Unit Cost', comment = 'ESP="Coste Unitario"';
        }
        field(50; "Reporting SEB Entry No"; integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Reporting SEB Entry No"', comment = 'ESP="Reporting SEB Entry No"';
        }
        field(60; "Source No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Source No.', comment = 'ESP="Código"';
        }
        field(70; "Source Name"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Source Name', comment = 'ESP="Nombre"';
        }
        field(80; "Vat Registration Name"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vat Registration Name', comment = 'ESP="CIF/NIF"';
        }
        field(100; "Period Start"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period Start', comment = 'ESP="Period Start"';
        }
        field(110; "Period End"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period End', comment = 'ESP="Period End"';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "CMMF Code", MLA)
        { }
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