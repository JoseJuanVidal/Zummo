pageextension 50121 "PlannedProdOrderLines" extends "Planned Prod. Order Lines"
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