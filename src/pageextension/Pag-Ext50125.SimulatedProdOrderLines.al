pageextension 50125 "SimulatedProdOrderLines" extends "Simulated Prod. Order Lines"
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