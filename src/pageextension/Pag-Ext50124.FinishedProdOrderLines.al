pageextension 50124 "FinishedProdOrderLines" extends "Finished Prod. Order Lines"
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
    }
}