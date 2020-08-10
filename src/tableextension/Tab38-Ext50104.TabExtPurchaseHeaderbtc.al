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
            CalcFormula = Exist ("Purchase Line" WHERE ("Document Type" = FIELD ("Document Type"), "Document No." = FIELD ("No."), "Outstanding Quantity" = FILTER (<> 0)));
        }
        field(50001; "Motivo rechazo"; Text[100])
        {
            Caption = 'Motivo rechazo', Comment = 'ESP="Motivo rechazo"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("Purchase Line".TextoRechazo WHERE
            ("Document Type" = FIELD ("Document Type"),
             "Document No." = FIELD ("No."),
            "Outstanding Quantity" = FILTER (> 0),
            TextoRechazo = filter (<> '')
            ));
        }
        field(50002; "Fecha Mas Temprana"; Date)
        {
            Caption = 'Fecha Mas Temprana', Comment = 'ESP="Fecha Mas Temprana"';
            Description = 'Bitec';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = min ("Purchase Line"."Expected Receipt Date" where ("Document Type" = FIELD ("Document Type"),
             "Document No." = FIELD ("No."),
            "Outstanding Quantity" = FILTER (> 0)));
        }
    }
}