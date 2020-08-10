//051219 S19/01384
pageextension 50139 "ProdBOMWhereUsed" extends "Prod. BOM Where-Used"
{
    layout
    {
        addafter("Quantity Needed")
        {
            field(ProductoBloqueado_btc; ProductoBloqueado_btc)
            {
                ApplicationArea = All;
            }
        }
    }
}