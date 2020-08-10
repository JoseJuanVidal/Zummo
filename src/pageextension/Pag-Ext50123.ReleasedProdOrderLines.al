pageextension 50123 "ReleasedProdOrderLines" extends "Released Prod. Order Lines"
{
    layout
    {
        addafter("Ending Date")
        {
            field(FechaInicial_btc; FechaInicial_btc)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    Validate("Starting Date", FechaInicial_btc);
                end;
            }
        }
        modify("Starting Date-Time")
        {
            Editable = false;
        }
    }
}