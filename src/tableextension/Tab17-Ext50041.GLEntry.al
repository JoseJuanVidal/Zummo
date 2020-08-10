tableextension 50041 "GLEntry" extends "G/L Entry" //17
{//17
    fields
    {
        field(50100; IdFactAbno_btc; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice/Cr. Memo No.', comment = 'ESP="Nº factura/abono"';
        }

        field(50101; Liquidado_btc; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Applied', comment = 'ESP="Liquidado"';
        }
    }
}