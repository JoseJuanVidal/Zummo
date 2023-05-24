table 17414 "ZM CONSULTIA Invoice Header"
{
    DataClassification = CustomerContent;
    Caption = 'CONSULTIA Invoice Header', comment = 'ESP="CONSULTIA Cab. Facturas"';
    LookupPageId = "ZM CONSULTIA Invoice Headers";
    DrillDownPageId = "ZM CONSULTIA Invoice Headers";

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
        field(3; "N_Pedido"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº Pedido', comment = 'ESP="Nº Pedido"';
        }
        field(4; "F_Factura"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Fecha Factura', comment = 'ESP="Fecha Factura"';
        }
        field(5; "Descripcion"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Descripción', comment = 'ESP="Descripción"';
        }
        field(6; "IdCorp_Sol"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ID Corporativo Solicitante', comment = 'ESP="ID Corporativo Solicitante"';
        }
        field(7; "Nombre_Sol"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Nombre Solicitante', comment = 'ESP="Nombre Solicitante"';
        }
        field(8; "Proyecto"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Proyecto', comment = 'ESP="Proyecto"';
        }
        field(9; "Ref_Ped_Cl"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Ref. Pedido Cliente', comment = 'ESP="Ref. Pedido Cliente"';
        }
        field(10; "Responsable_compra"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsable compra', comment = 'ESP="Responsable_compra"';
        }
        field(11; "Tipo"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Tipo', comment = 'ESP="Tipo"';
        }
        field(12; "FacturaRectificada"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Nº Factura Recitificativa', comment = 'ESP="Nº Factura Recitificativa"';
        }
        field(13; "Total_Base"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Base', comment = 'ESP="Total Base"';
        }
        field(14; "Total_Impuesto"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Impuesto', comment = 'ESP="Total Impuesto"';
        }
        field(15; "Total_Tasas_Exentas"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Tasas Exentas', comment = 'ESP="Total Tasas Exentas"';
        }
        field(16; "Total"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total', comment = 'ESP="Total"';
        }
    }

    keys
    {
        key(PK; id)
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

    procedure DownloadFile()
    var
        CONSULTIAFunctions: Codeunit "Zummo Inn. IC Functions";
    begin
        CONSULTIAFunctions.GetInvoicePdf(Rec);
    end;
}