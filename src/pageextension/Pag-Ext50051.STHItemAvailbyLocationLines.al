pageextension 50051 "STH ItemAvailbyLocationLines" extends "Item Avail. by Location Lines"
{
    layout
    {
        addafter(Name)
        {
            field(Ordenacion_btc; Ordenacion_btc)
            {
                ApplicationArea = all;
                Caption = 'Ordenación', comment = 'ESP="Ordenación"';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}