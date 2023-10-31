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
        field(30; "Vendor No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.', comment = 'ESP="Cód. proveedor"';
            TableRelation = Vendor;
        }
        field(31; "Vendor Name"; text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Name', comment = 'ESP="Nombre proveedor"';
        }
        field(32; "Vat Registration No."; text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vat Registration No.', comment = 'ESP="CIF/NIF"';
        }
        field(50; "Document Type"; Option)
        {
            Caption = 'Pre Invoice No.', comment = 'ESP="Nª PreFactura"';
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(51; "Pre Invoice No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pre Invoice No.', comment = 'ESP="Nª PreFactura"';
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Invoice));
        }
        field(52; "Invoice Header No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Header No.', comment = 'ESP="Nª Factura"';
            TableRelation = "Purch. Inv. Header";
        }
        field(53; "Provisioning"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Provisioning', comment = 'ESP="Aprovisión"';

            trigger OnValidate()
            begin
                if xRec.Provisioning and not Rec.Provisioning then
                    Rec."Provisioning Date" := 0D;
            end;
        }
        field(54; "Provisioning Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Provisioning Date', comment = 'ESP="Fecha Aprovisión"';
        }
        field(55; "Des Provisioning"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Des Provisióning', comment = 'ESP="Desprovisión"';

            trigger OnValidate()
            begin
                if xRec."Des Provisioning" and not Rec."Des Provisioning" then
                    Rec."Des Provisioning Date" := 0D;
            end;
        }
        field(56; "Des Provisioning Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Des Provisioning Date', comment = 'ESP="Fecha desprovisión"';
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
    }

    keys
    {
        key(PK; Id)
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
        DeleteRelationsTable();
    end;

    trigger OnRename()
    begin

    end;

    local procedure DeleteRelationsTable()
    var
        Lines: Record "ZM CONSULTIA Invoice Line";
        DocumentAttachment: Record "Document Attachment";
    begin
        CheckDelete();
        Rec.TestField("Pre Invoice No.", '');
        Rec.TestField("Invoice Header No.", '');
        Lines.Reset();
        Lines.SetRange(Id, Rec.Id);
        lines.DeleteAll();
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("Table ID", Database::"ZM CONSULTIA Invoice Header");
        DocumentAttachment.SetRange("No.", Rec.N_Factura);
        DocumentAttachment.DeleteAll();
    end;

    procedure DownloadFile()
    var
        CONSULTIAFunctions: Codeunit "Zummo Inn. IC Functions";

    begin
        CONSULTIAFunctions.GetInvoicePdf(Rec);
    end;

    local procedure CheckDelete()
    begin
        Rec.TestField(Provisioning, false);
        Rec.TestField("Des Provisioning", false);
        Rec.TestField("Pre Invoice No.");
        Rec.TestField("Invoice Header No.");
    end;

    procedure GetInvoiceState(): Boolean
    begin
        case true of
            Rec.Total_Base >= 0:
                exit(InvoiceState());
            else
                exit(CRMemmoState());
        end;

    end;

    local procedure InvoiceState(): Boolean

    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("Vendor Invoice No.", Rec.N_Factura);
        if PurchInvHeader.FindFirst() then begin
            Rec."Invoice Header No." := PurchInvHeader."No.";
            Rec."Pre Invoice No." := PurchInvHeader."Pre-Assigned No.";
            Rec.Modify();
            exit(true);
        end else begin
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
            PurchaseHeader.SetRange("Vendor Invoice No.", Rec.N_Factura);
            if PurchaseHeader.FindFirst() then begin
                Rec."Pre Invoice No." := PurchaseHeader."No.";
                Rec.Modify();
                exit(true);
            end;
        end;
    end;

    local procedure CRMemmoState(): Boolean

    var
        PurchaseHeader: Record "Purchase Header";
        PurchCRMHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        PurchCRMHeader.Reset();
        PurchCRMHeader.SetRange("Vendor Cr. Memo No.", Rec.N_Factura);
        if PurchCRMHeader.FindFirst() then begin
            Rec."Invoice Header No." := PurchCRMHeader."No.";
            Rec."Pre Invoice No." := PurchCRMHeader."Pre-Assigned No.";
            Rec.Modify();
            exit(true);
        end else begin
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::"Credit Memo");
            PurchaseHeader.SetRange("Vendor Cr. Memo No.", Rec.N_Factura);
            if PurchaseHeader.FindFirst() then begin
                Rec."Pre Invoice No." := PurchaseHeader."No.";
                Rec.Modify();
                exit(true);
            end;
        end;
    end;
}