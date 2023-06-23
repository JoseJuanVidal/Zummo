tableextension 50104 "TabExtPurchaseHeader_btc" extends "Purchase Header"  //38
{
    fields
    {
        field(50000; "Pendiente_btc"; Boolean)
        {
            Caption = 'Has pending amount', Comment = 'ESP="Tiene cantidad pendiente"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("Purchase Line" WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Outstanding Quantity" = FILTER(<> 0)));
        }
        field(50001; "Motivo rechazo"; Text[100])
        {
            Caption = 'Motivo rechazo', Comment = 'ESP="Motivo rechazo"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line".TextoRechazo WHERE
            ("Document Type" = FIELD("Document Type"),
             "Document No." = FIELD("No."),
            "Outstanding Quantity" = FILTER(> 0),
            TextoRechazo = filter(<> '')
            ));
        }
        field(50002; "Fecha Mas Temprana"; Date)
        {
            Caption = 'Fecha Mas Temprana', Comment = 'ESP="Fecha Mas Temprana"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = min("Purchase Line"."Expected Receipt Date" where("Document Type" = FIELD("Document Type"),
             "Document No." = FIELD("No."),
            "Outstanding Quantity" = FILTER(> 0)));
        }
        field(50023; "Amount Subcontractor"; Decimal)
        {
            Caption = 'Amount Subcontractor', Comment = 'ESP="Importe subcontratación"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Order No." = filter(<> '')));
        }
        field(50024; "Amount Inc. VAT Subcontractor"; Decimal)
        {
            Caption = 'Amount Inc. VAT Subcontractor', Comment = 'ESP="Importe con IVA subcontr."';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"), "Document No." = FIELD("No."), "Order No." = filter(<> '')));
        }
        field(50125; "CONSULTIA ID Factura"; Integer)
        {
            Caption = 'CONSULTIA Id Factura', Comment = 'ESP="CONSULTIA Id Factura"';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "ZM CONSULTIA Invoice Header";
        }
        field(50126; "CONSULTIA N Factura"; code[20])
        {
            Caption = 'CONSULTIA Id Factura', Comment = 'ESP="CONSULTIA Id Factura"';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "ZM CONSULTIA Invoice Header".N_Factura where(Id = field("CONSULTIA ID Factura"));
        }
        //+  NORMATIVA MEDIO AMBIENTAL
        Field(50200; "Plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic (kg)', comment = 'ESP="Plástico (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50201; "Recycled plastic Qty. (kg)"; decimal)
        {
            Caption = 'Plastic Recycled (kg)', comment = 'ESP="Plástico reciclado (kg)"';
            DataClassification = CustomerContent;
            DecimalPlaces = 5 : 5;
        }
        Field(50202; "Plastic Date Declaration"; Date)
        {
            Caption = 'Plastic Date Declaration', comment = 'ESP="Fecha Declaración plástico"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //-  NORMATIVA MEDIO AMBIENTAL
    }
}