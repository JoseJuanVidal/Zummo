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
            Caption = 'Desc_servicio', comment = 'ESP="Desc_servicio"';
        }
        field(5; "Proveedor"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Proveedor', comment = 'ESP="Proveedor"';
        }
        field(6; "F_Ini"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'F_Ini', comment = 'ESP="F_Ini"';
        }
        field(7; "F_Fin"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'F_Fin', comment = 'ESP="F_Fin"';
        }
        field(8; "IdCorp_Usuario"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'IdCorp_Usuario', comment = 'ESP="IdCorp_Usuario"';
            TableRelation = Employee;
        }
        field(9; "Usuario"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Usuario', comment = 'ESP="Usuario"';
        }
        field(10; "Ref_Usuario"; text[100])  // CECO Dimension
        {
            DataClassification = CustomerContent;
            Caption = 'Ref_Usuario', comment = 'ESP="Ref_Usuario"';
        }
        field(11; "Ref_DPTO"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ref_DPTO', comment = 'ESP="Ref_DPTO"';

            TableRelation = "G/L Account";
            ValidateTableRelation = false;

        }
        field(12; "Producto"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Producto', comment = 'ESP="Producto"';
        }
        field(13; "Base"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base', comment = 'ESP="Base"';
        }
        field(14; "Porc_IVA"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Porc_IVA', comment = 'ESP="Porc_IVA"';
        }
        field(15; "Imp_IVA"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Imp_IVA', comment = 'ESP="Imp_IVA"';
        }
        field(16; "Tasas"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Tasas', comment = 'ESP="Tasas"';
        }
        field(17; "PVP"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'PVP', comment = 'ESP="PVP"';
        }
        field(18; "IdCorp_Sol"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'IdCorp_Sol', comment = 'ESP="IdCorp_Sol"';
        }
        field(19; "IdServicio"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'IdServicio', comment = 'ESP="IdServicio"';
        }
        field(20; "NumeroLineaServicio"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'NumeroLineaServicio', comment = 'ESP="NumeroLineaServicio"';
        }
        field(21; "CodigoProducto"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'CodigoProducto', comment = 'ESP="CodigoProducto"';
        }
        field(50; "Proyecto"; code[50])
        {
            Caption = 'Proyecto', comment = 'ESP="Proyecto"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM CONSULTIA Producto-Proyecto".Proyecto where(CodigoProducto = field(CodigoProducto)));
        }
        field(51; "Proyecto Manual"; code[50])
        {
            Caption = 'Proyecto manual', comment = 'ESP="Proyecto manual"';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(53; "Partida"; code[50])
        {
            Caption = 'Partida', comment = 'ESP="Partida"';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8));
        }
        field(54; "Detalle"; code[50])
        {
            Caption = 'Detalle', comment = 'ESP="Detalle"';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(55; "DEPART"; code[50])
        {
            Caption = 'DEPART', comment = 'ESP="DEPART"';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
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