tableextension 50041 "GLEntry" extends "G/L Entry" //17
{//17
    fields
    {
        field(50100; "IdFactAbno_btc"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice/Cr. Memo No.', comment = 'ESP="Nº factura/abono"';
        }

        field(50101; "Liquidado_btc"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Applied', comment = 'ESP="Liquidado"';
        }

        field(50110; "Global Dimension 3 Code"; Code[20])
        {
            Editable = false;
            Caption = 'Detalle', comment = 'ESP="Detalle"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = filter('DETALLE')));
        }
        field(50111; "Global Dimension 8 Code"; Code[20])
        {
            Editable = false;
            Caption = 'Partida', comment = 'ESP="Partida"';
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"), "Dimension Code" = filter('PARTIDA')));
        }
    }
}