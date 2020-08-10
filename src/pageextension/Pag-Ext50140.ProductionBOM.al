//051219 S19/01385

pageextension 50140 "ProductionBOM" extends "Production BOM"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field(ProductoBloqueado_btc; ProductoBloqueado_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}