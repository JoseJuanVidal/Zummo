table 17370 "ZM Hist. Reclamaciones ventas"
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
}