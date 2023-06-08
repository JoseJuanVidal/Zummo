pageextension 50050 "STHReqWkshNames" extends "Req. Wksh. Names"
{
    layout
    {
        addlast(Control1)
        {
            field(STHUseCalcPersonalizado; STHUseCalcPersonalizado)
            {
                ApplicationArea = all;
                ToolTip = 'Se cambia en configuración inventario', comment = 'ESP="Se cambia en configuración inventario"';
            }
            field(STHUseLocationGroup; STHUseLocationGroup)
            {
                ApplicationArea = all;
                ToolTip = 'Se configura en la configuración de cada Almacén', comment = 'ESP="Se configura en la configuración de cada Almacén"';
            }
            field(STHNoEvaluarPurchase; STHNoEvaluarPurchase)
            {
                ApplicationArea = all;
            }
            field(ZMQuoteAssemblyLine; ZMQuoteAssemblyLine)
            {
                ApplicationArea = all;
            }
        }
    }
}