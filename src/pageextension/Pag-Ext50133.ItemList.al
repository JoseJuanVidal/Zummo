pageextension 50133 "ItemList" extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field(Ordenacion_btc; Ordenacion_btc)
            {
                ApplicationArea = All;
                BlankZero = true;
            }

            // Validar productos
            field(ValidadoContabiliad_btc; ValidadoContabiliad_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}