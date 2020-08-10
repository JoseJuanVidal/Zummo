pageextension 50013 "LocationCard" extends "Location Card"
{
    //Ordenación almacenes

    layout
    {
        addafter("Use As In-Transit")
        {
            field(Ordenacion_btc; Ordenacion_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}