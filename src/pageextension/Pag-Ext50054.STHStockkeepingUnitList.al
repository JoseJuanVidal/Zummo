pageextension 50054 "STHStockkeepingUnitList" extends "Stockkeeping Unit List"
{
    layout
    {
        addlast(Control1)
        {
            field(STHQuantityWhse; STHQuantityWhse)
            {
                ApplicationArea = all;
                ToolTip = 'Qty. en Stockkeeping Unit', Comment = 'ESP="Cantidad en contenido de almacén"';
                Visible = false;
            }
        }
    }
}