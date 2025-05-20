table 17385 "ZM Requesition Buffer Calc."
{
    DataClassification = CustomerContent;
    Caption = 'Requesition Buffer Calc.', comment = 'ESP="Calculo Hoja Demanda Buffer"';

    fields
    {
        field(1; "Session ID"; Guid)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Worksheet Template Name"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. producto"';
        }
        field(5; "Description"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripción', comment = 'ESP="Descripción"';
        }
        field(6; "location Code"; code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code', comment = 'ESP="Cód. Almacén"';
        }
        field(10; "Cantidad Pedir"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cantidad Pedir', comment = 'ESP="Cantidad Pedir"';
        }
        field(11; "Stock de seguridad"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Stock de seguridad', comment = 'ESP="Stock de seguridad"';
        }
        field(12; "Cantidad mínima pedido"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cantidad mínima pedido', comment = 'ESP="Cantidad mínima pedido"';
        }
        field(13; "Lín. venta"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Lín. venta', comment = 'ESP="Lín. venta"';
        }
        field(14; "Línea servicio"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Línea servicio', comment = 'ESP="Línea servicio"';
        }
        field(15; "Línea planificación proyecto"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Línea planificación proyecto', comment = 'ESP="Línea planificación proyecto"';
        }
        field(16; "Componente orden producción"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Componente orden producción', comment = 'ESP="Componente orden producción"';
        }
        field(17; "Demanda Línea de ensamblado"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Demanda Línea de ensamblado', comment = 'ESP="Demanda Línea de ensamblado"';
        }
        field(18; "Planif. componente"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Planif. componente', comment = 'ESP="Planif. componente"';
        }
        field(19; "Demanda Lín. hoja demanda"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Demanda Lín. hoja demanda', comment = 'ESP="Demanda Lín. hoja demanda"';
        }
        field(20; "Demanda Lín. transferencia"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Demanda Lín. transferencia', comment = 'ESP="Demanda Lín. transferencia"';
        }
        field(21; "Inventario"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Inventario', comment = 'ESP="Inventario"';
        }
        field(22; "Aprov. Lín. hoja demanda"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Aprov. Lín. hoja demanda', comment = 'ESP="Aprov. Lín. hoja demanda"';
        }
        field(23; "Lín. compra"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Lín. compra', comment = 'ESP="Lín. compra"';
        }
        field(24; "Lín. orden prod."; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Lín. compra	Lín. orden prod.', comment = 'ESP="Lín. compra	Lín. orden prod."';
        }
        field(26; "Aprov. Línea de ensamblado"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Aprov. Línea de ensamblado', comment = 'ESP="Aprov. Línea de ensamblado"';
        }
        field(27; "Aprov. Lín. transferencia"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Aprov. Lín. transferencia', comment = 'ESP="Aprov. Lín. transferencia"';
        }
        field(28; "Cantidad para stock"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cantidad para stock', comment = 'ESP="Cantidad para stock"';
        }
        field(29; "Cód. proveedor"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cód. proveedor', comment = 'ESP="Cód. proveedor"';
        }
        field(30; "Nombre proveedor"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Nombre proveedor', comment = 'ESP="Nombre proveedor"';
        }
        field(31; "Plazo de entrega"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Plazo de entrega', comment = 'ESP="Plazo de entrega"';
        }
        field(33; "Forecast Requisition"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Forecast Requisition', comment = 'ESP="Previsión de demanda"';
        }
    }

    keys
    {
        key(Key1; "Session ID", "Worksheet Template Name", "Journal Batch Name", "Item No.")
        {
            Clustered = true;
        }
    }

    var
        ActiveSession: Record "Active Session";

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

    procedure GetActiveSession(): Guid
    begin
        ActiveSession.Reset();
        ActiveSession.SetRange("Server Instance ID", ServiceInstanceId());
        ActiveSession.SetRange("Session ID", SessionId());
        if ActiveSession.FindFirst() then
            exit(ActiveSession."Session Unique ID");
    end;

}