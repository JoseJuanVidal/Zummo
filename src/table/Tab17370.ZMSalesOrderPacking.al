table 17370 "ZM Sales Order Packing"
{
    DataClassification = CustomerContent;
    Caption = 'Sales Order Packing', comment = 'ESP="Ped. Venta Packing"';

    fields
    {
        field(1; "Document type"; Enum "ZM Pakcing Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Document type', comment = 'ESP="Tipo Documento"';
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.', comment = 'ESP="Nº Documento"';
            TableRelation = if ("Document type" = const(Order)) "Sales Header"."No." where("Document Type" = const(Order)) else
            if ("Document type" = const("Sales Shipment")) "Sales Shipment Header"."No." else
            if ("Document type" = const("Return Receipt")) "Return Receipt Header"."No.";
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', comment = 'ESP="Nº Linea"';
            Editable = false;
        }
        field(5; "Item No."; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Cód. producto"';
            TableRelation = Item where("Packaging product" = const(true));

            trigger OnValidate()
            begin
                ValidateItemNo();
            end;
        }

        field(6; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', comment = 'ESP="Descripción"';
        }
        field(7; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity', comment = 'ESP="Cantidad"';
            DecimalPlaces = 0 : 0;
        }
        field(10; "Length"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Length', comment = 'ESP="Longitud"';
        }
        field(11; "Width"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Width', comment = 'ESP="Ancho"';
        }
        field(12; "Height"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Height', comment = 'ESP="Alto"';
        }
        field(13; "Cubage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Cubage', comment = 'ESP="Cubicaje"';
        }
        field(14; "Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Weight', comment = 'ESP="Peso"';
        }
        Field(20; "Package Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Package Plastic (kg)', comment = 'ESP="Plástico Bulto (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(21; "Package Recycled plastic (kg)"; decimal)
        {
            Caption = 'Package Recycled Plastic (kg)', comment = 'ESP="Plástico reciclado Bulto (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        field(50; "Item Quantity"; decimal)
        {
            FieldClass = FlowField;
            Caption = 'Item Quantity', comment = 'ESP="Cantidad productos"';
            CalcFormula = sum("ZM Packing List Detail".Quantity where("Document type" = field("Document type"), "Document No." = field("Document No."), "Packing Line No." = field("Line No.")));
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Document type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            AssingLineNo;
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

    var
        Item: Record Item;

    local procedure AssingLineNo()
    var
        SalesOrderPacking: record "ZM Sales Order Packing";
    begin
        if "Line No." <> 0 then
            exit;
        SalesOrderPacking.Reset();
        SalesOrderPacking.SetRange("Document type", Rec."Document type");
        SalesOrderPacking.SetRange("Document No.", Rec."Document No.");
        if SalesOrderPacking.FindLast() then
            Rec."Line No." := SalesOrderPacking."Line No." + 1
        else
            Rec."Line No." := 1;
    end;

    local procedure ValidateItemNo()
    var
        myInt: Integer;
    begin
        Item.Reset();
        initPlastic;
        IF Item.Get(Rec."Item No.") then begin
            Rec.Description := Item.Description;
            Rec.Quantity := 1;
            Rec.Weight := Item."Net Weight";
            Rec."Package Plastic Qty. (kg)" := Item."Packing Plastic Qty. (kg)";
            Rec."Package Recycled plastic (kg)" := Item."Packing Recycled plastic (kg)";

            UpdateBaseUnit();
        end;
    end;

    local procedure UpdateBaseUnit()
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
    begin
        ItemUnitofMeasure.Reset();
        if ItemUnitofMeasure.Get(Item."No.", Item."Base Unit of Measure") then begin
            Rec.Length := ItemUnitofMeasure.Length;
            Rec.Width := ItemUnitofMeasure.Width;
            Rec.Height := ItemUnitofMeasure.Height;
            if Rec.Weight = 0 then
                Rec.Weight := ItemUnitofMeasure.Weight;
            Rec.Cubage := ItemUnitofMeasure.Cubage;
        end;
    end;

    local procedure initPlastic()
    begin
        Rec.Description := '';
        Rec.Weight := 0;
        Rec."Package Plastic Qty. (kg)" := 0;
        Rec."Package Recycled plastic (kg)" := 0;
        Rec.Length := 0;
        Rec.Width := 0;
        Rec.Height := 0;
        Rec.Weight := 0;
        Rec.Cubage := 0;

    end;

}