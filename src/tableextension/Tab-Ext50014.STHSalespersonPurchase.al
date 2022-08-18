tableextension 50014 "STH Salesperson/Purchase" extends "Salesperson/Purchaser"
{
    fields
    {
        field(50100; "Send email due invocies"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Envío email Resumens Fact. Vencidas', comment = 'ESP="Envío email Resumens Fact. Vencidas"';
        }
    }
}
