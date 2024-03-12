table 17456 "ZM Contracts/Supplies Lines"
{
    Caption = 'Contracts/Supplies Lines', Comment = 'ESP="Contratos/Suministros Cabecera"';
    DrillDownPageId = "ZM Contracts/Supplies Lines";
    LookupPageId = "ZM Contracts/Supplies Lines";

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº Documento"';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Línea"';
            DataClassification = CustomerContent;
        }
        field(3; Type; enum "ZM Contracts Lines Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            DataClassification = CustomerContent;

            TableRelation = if (type = const(Item)) Item else
            if (type = const("G/L Account")) "G/L Account" else
            if (type = const("Fixed Asset")) "Fixed Asset";

            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if Rec.IsTemporary then
                    exit;
                Case Type of
                    Type::Item:
                        begin
                            if Item.Get("No.") then begin
                                Description := Item.Description;
                                "Precio negociado" := Item."Last Direct Cost";
                                "Unit of measure" := Item."Base Unit of Measure";
                            end;
                        end;
                    Type::"G/L Account":
                        begin
                            if GLAccount.Get("No.") then
                                Description := GLAccount.Name;
                        end;
                    Type::"Fixed Asset":
                        begin
                            if FixedAsset.Get("No.") then
                                Description := FixedAsset.Description;
                        end;
                end;

            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(6; "Buy-from Vendor No."; text[100])
        {
            Caption = 'Buy-from Vendor No.', comment = 'ESP="Compra a-Nº proveedor"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM Contracts/Supplies Header"."Buy-from Vendor No." where("No." = field("Document No.")));
        }
        field(7; Status; Enum "ZM Contracts Status")
        {
            Caption = 'Status', comment = 'ESP="Estado"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM Contracts/Supplies Header".Status where("No." = field("Document No.")));
        }
        field(8; "Date End Validity"; Date)
        {
            Caption = 'Date End Validity', Comment = 'ESP="Fecha Fin Vigencia"';
            FieldClass = FlowField;
            CalcFormula = lookup("ZM Contracts/Supplies Header"."Date End Validity" where("No." = field("Document No.")));
        }
        field(10; "Precio negociado"; Decimal)
        {
            Caption = 'Precio negociado', Comment = 'ESP="Precio negociado"';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                CalcLineAmount();
            end;
        }
        field(11; "Unidades"; Decimal)
        {
            Caption = 'Unidades', Comment = 'ESP="Unidades"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Validate_Unidades();
            end;
        }
        field(12; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount', Comment = 'ESP="Importe Línea"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Unidades Entregadas"; Decimal)
        {
            Caption = 'Unidades Entregadas', Comment = 'ESP="Unidades Entregadas"';
            FieldClass = FlowField;
            CalcFormula = sum("Purch. Rcpt. Line".Quantity where("Contracts No." = field("Document No."), "Contracts Line No." = field("Line No.")));
            Editable = false;
        }
        field(15; "Unidades Devolución"; Decimal)
        {
            Caption = 'Kilos Devolución', comment = 'ESP="Kilos Devolución"';
            FieldClass = FlowField;
            CalcFormula = sum("Return Shipment Line".Quantity where("Contracts No." = field("Document No."), "Contracts Line No." = field("Line No.")));
            Editable = false;
        }
        field(16; "Quantity in Purch. Order"; Decimal)
        {
            Caption = 'Quantity in Purch. Order', comment = 'ESP="Cantidad pdte. Pedidos Compra"';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const(Order), "Contracts No." = field("Document No."), "Contracts Line No." = field("Line No.")));
            Editable = false;
        }
        field(20; "Global Dimension 1 code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 1 code', comment = 'ESP="Global Dimension 1 code"';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Global Dimension 2 code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 2 code', comment = 'ESP="Global Dimension 2 code"';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(35; "Unit of measure"; code[10])
        {
            Caption = 'Unit of measure', Comment = 'ESP="Unidad de medida"';
            DataClassification = CustomerContent;
            TableRelation = if (type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No.")) else
            "Unit of Measure".Code;
        }
        field(36; "Lead Time Calculation"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Lead Time Calculation', comment = 'ESP="Plazo entrega (días)"';
        }
        field(40; "Minimum Order Quantity"; Decimal)
        {
            Caption = 'Minimum Order Quantity', Comment = 'ESP="Cantidad mínima pedido"';
            DataClassification = CustomerContent;
        }
        field(42; "Order Multiple"; Decimal)
        {
            Caption = 'Order Multiple', Comment = 'ESP="Multiplos pedido"';
            DataClassification = CustomerContent;
        }
        field(50; "Global Dimension 3 code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 3 code', comment = 'ESP="Global Dimension 3 code"';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(51; "Global Dimension 4 code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 4 code', comment = 'ESP="Global Dimension 4 code"';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(52; "Global Dimension 5 code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 5 code', comment = 'ESP="Global Dimension 5 code"';
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(53; "Global Dimension 6 code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 6 code', comment = 'ESP="Global Dimension 6 code"';
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(54; "Global Dimension 7 code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 7 code', comment = 'ESP="Global Dimension 7 code"';
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(60; "Global Dimension 8 code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Global Dimension 8 code', comment = 'ESP="Global Dimension 8 code"';
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestStatusOpen;
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
    end;

    trigger OnDelete()
    begin
        CheckDeleteLine;
    end;

    var
        ContractHeader: Record "ZM Contracts/supplies Header";
        GLAccount: Record "G/L Account";
        Item: Record Item;
        ItemCategory: Record "Item Category";
        FixedAsset: Record "Fixed Asset";
        MsgDuplicity: Label 'No se pueden insertar dos lineas con la misma categoria o Cód. Producto.', Comment = 'ESP="No se pueden insertar dos lineas con la misma categoria o Cód. Producto"';
        MsgErrorCategoryParent: Label 'La categoria elegida para el contrato, debe ser del último nivel', Comment = 'ESP="La categoria elegida para el contrato, debe ser del último nivel"';
        MsgDelete: Label 'No se puede eliminar la línea porque tiene Albaranes/Devoluciones en este contrato', Comment = 'ESP="No se puede eliminar la línea porque tiene Albaranes/Devoluciones en este contrato"';

    local procedure GetHeader()
    begin
        ContractHeader.Get("Document No.");
    end;

    local procedure TestStatusOpen()
    begin
        if Rec.IsTemporary then
            exit;
        GetHeader();
        ContractHeader.TestField(Status, ContractHeader.Status::Abierto);
        ContractHeader.TestField(Blocked, false);
    end;

    local procedure CheckDeleteLine()
    begin
        CalcFields("Unidades Entregadas", "Unidades Devolución");
        if ("Unidades Entregadas" <> 0) or ("Unidades Devolución" <> 0) then
            Error(MsgDelete);
    end;

    local procedure Validate_Unidades()
    var
        PurchasePrice: Record "Purchase Price";
        lblMsg: Label 'The price has been updated to Tariff Lot.', comment = 'ESP="Se ha actualizado el precio a tarifa de lotes."';
    begin
        if not (Rec.Type in [Rec.Type::Item]) then
            exit;
        PurchasePrice.Reset();
        PurchasePrice.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
        PurchasePrice.SetRange("Item No.", Rec."No.");
        PurchasePrice.SetFilter("Ending Date", '%1..', WorkDate());
        PurchasePrice.SetFilter("Unit of Measure Code", Rec."Unit of measure");
        PurchasePrice.SetFilter("Minimum Quantity", '>=%1', Rec.Unidades);
        if PurchasePrice.FindFirst() then begin
            Rec."Precio negociado" := PurchasePrice."Direct Unit Cost";
            Message(lblMsg);
        end;

        CalcLineAmount();
    end;

    local procedure CalcLineAmount()
    var
        myInt: Integer;
    begin
        Rec."Line Amount" := Rec."Precio negociado" * Rec.Unidades;
    end;
}
