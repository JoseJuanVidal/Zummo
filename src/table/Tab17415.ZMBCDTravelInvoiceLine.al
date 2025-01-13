table 17415 "ZM BCD Travel Invoice Line"
{
    DataClassification = CustomerContent;
    Caption = 'BCD Travel Invoice Line', comment = 'ESP="BCD Travel Líneas Facturas"';
    LookupPageId = "ZM BCD Travel Invoice Lines";
    DrillDownPageId = "ZM BCD Travel Invoice Lines";

    fields
    {
        field(1; Nro_Albarán; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nro Albarán', comment = 'ESP="Nro Albarán"';
            TableRelation = "ZM BCD Travel Invoice Header";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', comment = 'ESP="Nº Línea"';
        }

        field(4; "Fecha Albarán"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Albarán', comment = 'ESP="Fecha Albarán"';
        }
        field(5; "Descripcion"; text[500])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripción', comment = 'ESP="Descripción"';
        }

        field(10; "Cod. Centro Coste"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cod. Centro Coste', comment = 'ESP="Cod. Centro Coste"';
            TableRelation = "Dimension Value" where("Global Dimension No." = const(1));
        }
        field(14; "Fec Inicio Srv"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fec Inicio Servicio', comment = 'ESP="Fec Inicio Servicio"';
        }
        field(15; "Fec Fin Srv"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fec Fin Servicio', comment = 'ESP="Fec Fin Servicio"';
        }
        field(16; "Ciudad Destino"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ciudad Destino', comment = 'ESP="Ciudad Destino"';
        }
        field(17; "Tipo Servicio"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Tipo Servicio', comment = 'ESP="Tipo Servicio"';
            TableRelation = "ZM BCD Travel Proyecto";
        }
        field(18; "Nº Billete o Bono"; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº Billete o Bono', comment = 'ESP="Nº Billete o Bono"';
        }
        field(19; "%Impuesto"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '% Impuesto', comment = 'ESP="% Impuesto"';
        }
        field(20; "Imp Base Imponible"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Base Imponible', comment = 'ESP="Base Imponible"';
        }
        field(21; "Imp Cuota Impuesto"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cuota Impuesto', comment = 'ESP="Cuota Impuesto"';
        }
        field(22; "Imp Total"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total', comment = 'ESP="Total"';
        }
        field(24; "Trayecto Servicio"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Trayecto Servicio', comment = 'ESP="Trayecto Servicio"';
        }
        field(25; "Cod Empleado"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Cod. Empleado', comment = 'ESP="Cod. Empleado"';
            TableRelation = "ZM BCD Travel Empleado";
        }
        field(26; "Nombre Empleado"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Nombre Empleado', comment = 'ESP="Nombre Empleado"';
        }

        field(50; "Proyecto"; code[50])
        {
            Caption = 'Proyecto', comment = 'ESP="Proyecto"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM BCD Travel Proyecto".Proyecto where(Codigo = field("Tipo Servicio")));
            Editable = false;
        }
        // field(51; "Proyecto Manual"; code[50])
        // {
        //     Caption = 'Proyecto manual', comment = 'ESP="Proyecto manual"';
        //     DataClassification = CustomerContent;
        //     TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        // }
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
        key(PK; "Nro_Albarán", "Line No.")
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