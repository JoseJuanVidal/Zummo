table 17371 "ZM Packing List Detail"
{
    Caption = 'ZM Packing List Detail';
    DataClassification = CustomerContent;
    LookupPageId = "ZM Packing List Details";
    DrillDownPageId = "ZM Packing List Details";

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
        field(3; "Packing Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Packing Line No.', comment = 'ESP="Nº Linea Packing"';
            Editable = false;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', comment = 'ESP="Nº Linea"';
            Editable = false;
            AutoIncrement = true;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item no.', comment = 'ESP="Cód. producto"';
            DataClassification = CustomerContent;
            TableRelation = if ("Document type" = const(Order)) "Sales Line"."No." where("Document Type" = const(Order), "Document No." = field("Document No."), Type = const(Item)) else
            if ("Document type" = const("Sales Shipment")) "Sales Shipment Line"."No." where("Document No." = field("Document No."), Type = const(Item)) else
            if ("Document type" = const("Return Receipt")) "Return Receipt Line"."No." where("Document No." = field("Document No."), Type = const(Item));

            trigger OnValidate()
            begin
                ValidateItemNo();
            end;

            trigger OnLookup()
            begin
                LookupItemNo();
            end;
        }
        field(6; Description; text[100])
        {
            Caption = 'Description', comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
            TableRelation = if ("Document type" = const(Order)) "Sales Line".Description where("Document Type" = const(Order), "Document No." = field("Document No."), Type = const(Item));
            Editable = false;
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.', comment = 'ESP="Nº Línea documento"';
            DataClassification = CustomerContent;
        }
        field(10; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity', comment = 'ESP="Cantidad"';
            DecimalPlaces = 0 : 0;
        }
    }
    keys
    {
        key(PK; "Document type", "Document No.", "Packing Line No.", "Line No.")
        {
            Clustered = true;
        }

    }


    local procedure ValidateItemNo()
    var
        SalesLine: Record "Sales Line";
        SalesShipmentLine: Record "Sales Shipment Line";
        ReturnReceiptLine: record "Return Receipt Line";
    begin
        case Rec."Document type" of
            Rec."Document type"::Order:
                begin
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SetRange("Document No.", Rec."Document No.");
                    SalesLine.SetRange("Line Amount", Rec."Document Line No.");
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetRange("No.", Rec."Item No.");
                    if SalesLine.FindFirst() then begin
                        Rec.Description := SalesLine.Description;
                        Rec.Quantity := SalesLine."Qty. to Ship";

                        CheckSalesLineItemNo();
                    end;
                end;
            Rec."Document type"::"Sales Shipment":
                begin
                    SalesShipmentLine.Reset();
                    SalesShipmentLine.SetRange("Document No.", Rec."Document No.");
                    SalesLine.SetRange("Line Amount", Rec."Document Line No.");
                    SalesShipmentLine.SetRange(Type, SalesLine.Type::Item);
                    SalesShipmentLine.SetRange("No.", Rec."Item No.");
                    if SalesShipmentLine.FindFirst() then begin
                        Rec.Description := SalesShipmentLine.Description;
                        Rec.Quantity := SalesShipmentLine.Quantity;

                    end;
                end;
            Rec."Document type"::"Return Receipt":
                begin
                    ReturnReceiptLine.Reset();
                    ReturnReceiptLine.SetRange("Document No.", Rec."Document No.");
                    SalesLine.SetRange("Line Amount", Rec."Document Line No.");
                    ReturnReceiptLine.SetRange(Type, SalesLine.Type::Item);
                    ReturnReceiptLine.SetRange("No.", Rec."Item No.");
                    if ReturnReceiptLine.FindFirst() then begin
                        Rec.Description := ReturnReceiptLine.Description;
                        Rec.Quantity := ReturnReceiptLine.Quantity;


                    end;
                end;
        end;


    end;

    local procedure CheckSalesLineItemNo()
    var
        myInt: Integer;
    begin
        // comprobamos que la cantidad de un mismo producto en el packing no supere las lineas de TODO el packing list

    end;

    local procedure LookupItemNo()
    var
        SalesLine: Record "Sales Line";
        SalesLines: page "Sales Lines";
    begin
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", Rec."Document No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", Rec."Item No.");
        SalesLines.SetTableView(SalesLine);
        SalesLines.LookupMode := true;
        if SalesLines.RunModal() = Action::LookupOK then begin
            SalesLines.GetRecord(SalesLine);
            Rec."Document Line No." := SalesLine."Line No.";
            Rec.Validate("Item No.", SalesLine."No.");


        end;
    end;

}
