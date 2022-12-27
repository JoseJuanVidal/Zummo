tableextension 50014 "STH Salesperson/Purchase" extends "Salesperson/Purchaser"
{
    fields
    {
        field(50100; "Send email due invocies"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Envío email Resumens Fact. Vencidas', comment = 'ESP="Envío email Resumens Fact. Vencidas"';
        }
        field(50101; AreaManager_btc; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = TextosAuxiliares.NumReg where(TipoTabla = const("AreaManager"), TipoRegistro = const(Tabla));
            Caption = 'Area Manager', comment = 'ESP="Area Manager"';
        }
    }
}
