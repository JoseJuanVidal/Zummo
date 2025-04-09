table 17414 "ZM BCD Travel Invoice Header"
{
    DataClassification = CustomerContent;
    Caption = 'CONSULTIA Invoice Header', comment = 'ESP="CONSULTIA Cab. Facturas"';
    LookupPageId = "ZM BCD Travel Invoice Headers";
    DrillDownPageId = "ZM BCD Travel Invoice Headers";

    fields
    {
        field(1; Nro_Albarán; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nro Albarán', comment = 'ESP="Nro Albarán"';
        }
        field(4; "Fecha Albarán"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Albarán', comment = 'ESP="Fecha Albarán"';
        }
        field(5; "Descripcion"; text[250])
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
        field(15; "Fec Fin Srv"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fec Fin Servicio', comment = 'ESP="Fec Fin Servicio"';
        }
        field(16; "Ciudad Destino"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ciudad Destino', comment = 'ESP="Ciudad Destino"';
        }

        field(25; "Cod Empleado"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cod Empleado', comment = 'ESP="Cod Empleado"';
            TableRelation = "ZM BCD Travel Empleado";
        }
        field(26; "Nombre Empleado"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Nombre Empleado', comment = 'ESP="Nombre Empleado"';
        }
        field(30; "Total_Base"; Decimal)
        {
            Caption = 'Total Base', comment = 'ESP="Total Base"';
            FieldClass = FlowField;
            CalcFormula = sum("ZM BCD Travel Invoice Line"."Imp Base Imponible" where("Nro_Albarán" = field("Nro_Albarán")));
        }
        field(31; "Total_Impuesto"; Decimal)
        {
            Caption = 'Total Impuesto', comment = 'ESP="Total Impuesto"';
            FieldClass = FlowField;
            CalcFormula = sum("ZM BCD Travel Invoice Line"."Imp Cuota Impuesto" where("Nro_Albarán" = field("Nro_Albarán")));
        }
        field(33; "Total"; Decimal)
        {
            Caption = 'Total', comment = 'ESP="Total"';
            FieldClass = FlowField;
            CalcFormula = sum("ZM BCD Travel Invoice Line"."Imp Total" where("Nro_Albarán" = field("Nro_Albarán")));
        }

        field(60; "G/L Account Fair"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'G/L Account Fair', comment = 'ESP="Cuenta contable Feria"';
            TableRelation = "G/L Account";
        }
        field(61; "Global Dimension 1 code Fair"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 1 code Fair', comment = 'ESP="Dimension CECO Feria"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(62; "Dimension Detalle Fair"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Detalle Fair', comment = 'ESP="Dimensión Detalle Feria"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(63; "Dimension Partida Fair"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Dimension Partida Fair', comment = 'ESP="Dimensión Partida Feria"';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        field(100; Status; Enum "ZM Contracts Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', comment = 'ESP="Estado"';
        }
        field(105; "Receipt created"; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Receipt created', comment = 'ESP="Albarán creado"';
            // Editable = false;
        }
        field(110; "Purchase Order"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Order', comment = 'ESP="Pedido Compra"';
            Editable = false;
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(120; "Purch. Rcpt. Order"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purch. Rcpt. Order', comment = 'ESP="Recepción Pedido Compra"';
            Editable = false;
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
    }

    keys
    {
        key(PK; "Nro_Albarán")
        {
            Clustered = true;
        }
        key(Key1; "Fecha Albarán", "Nro_Albarán")
        {
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
        Rec.TestField("Receipt created", false);
        DeleteRelationsTable();
    end;

    trigger OnRename()
    begin

    end;

    var
        Lines: Record "ZM BCD Travel Invoice Line";

    local procedure DeleteRelationsTable()
    begin
        CheckDelete();
        Lines.Reset();
        Lines.SetRange("Nro_Albarán", Rec."Nro_Albarán");
        lines.DeleteAll(true);
    end;



    local procedure CheckDelete()
    begin

    end;
}