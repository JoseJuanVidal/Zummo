table 17415 "ZM CONSULTIA Invoice Line"
{
    DataClassification = CustomerContent;
    Caption = 'CONSULTIA Invoice Line', comment = 'ESP="CONSULTIA Líneas Facturas"';
    LookupPageId = "ZM CONSULTIA Invoice Lines";
    DrillDownPageId = "ZM CONSULTIA Invoice Lines";

    fields
    {
        field(1; Id; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "N_Factura"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº Factura', comment = 'ESP="Nº Factura"';
        }
        field(3; Numero; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Numero', comment = 'ESP="Numero"';
        }
        field(4; "Desc_servicio"; text[250])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(5; "Proveedor"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(6; "F_Ini"; Date)
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(7; "F_Fin"; Date)
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(8; "IdCorp_Usuario"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
            TableRelation = Employee;
        }
        field(9; "Usuario"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(10; "Ref_Usuario"; text[100])  // CECO Dimension
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(11; "Ref_DPTO"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(12; "Producto"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(13; "Base"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(14; "Porc_IVA"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(15; "Imp_IVA"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(16; "Tasas"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(17; "PVP"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(18; "IdCorp_Sol"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(19; "IdServicio"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(20; "NumeroLineaServicio"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
        field(21; "CodigoProducto"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = '', comment = 'ESP=""';
        }
    }

    keys
    {
        key(PK; Id, Numero)
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