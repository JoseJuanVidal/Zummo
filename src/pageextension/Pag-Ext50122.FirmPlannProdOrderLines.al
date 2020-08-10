pageextension 50122 "FirmPlannProdOrderLines" extends "Firm Planned Prod. Order Lines"
{
    layout
    {
        addafter("Ending Date")
        {
            field(FechaInicial_btc; FechaInicial_btc)
            {
                ApplicationArea = All;
            }
        }
        modify("Starting Date-Time")
        {
            Editable = false;
        }
    }
}