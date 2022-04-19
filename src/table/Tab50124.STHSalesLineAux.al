table 50124 "STH Sales Line Aux"
{
    Caption = 'STH Sales Line Aux';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.', Comment = 'ESP="Venta-a Nº"';
            DataClassification = CustomerContent;
            TableRelation = "STH Sales Header Aux"."Sell-to Customer No.";
            ObsoleteState = Removed;
            ObsoleteReason = 'El campo "Sell-to Customer" no es necesario';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº Documento"';
            DataClassification = CustomerContent;
            TableRelation = "STH Sales Header Aux"."No.";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº Linea"';
            DataClassification = CustomerContent;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            DataClassification = CustomerContent;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            DataClassification = CustomerContent;
        }
        field(6; "Description 2"; Text[50])
        {
            Caption = 'Description 2', Comment = 'ESP="Descripción 2"';
            DataClassification = CustomerContent;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
            DataClassification = CustomerContent;
        }
        field(8; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %', Comment = 'ESP="% Linea Descuento"';
            DataClassification = CustomerContent;
        }
        field(9; "Line Discount Amount"; Decimal)
        {
            Caption = 'Line Discount Amount', Comment = 'ESP="Total Linea Descuento"';
            DataClassification = CustomerContent;
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Total"';
            DataClassification = CustomerContent;
        }
        field(11; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount', Comment = 'ESP="Total Linea"';
            DataClassification = CustomerContent;
        }
        field(12; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price', Comment = 'ESP="Precio Unitario"';
            DataClassification = CustomerContent;
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            Caption = 'Amount Including VAT', Comment = 'ESP="Importe IVA incl."';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
