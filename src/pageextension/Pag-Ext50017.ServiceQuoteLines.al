pageextension 50017 "ServiceQuoteLines" extends "Service Quote Lines"
{
    // Personalizaciones servicios

    layout
    {
        addafter("Location Code")
        {
            field("Bin Code"; "Bin Code")
            {
                ApplicationArea = All;
            }
        }
    }
}