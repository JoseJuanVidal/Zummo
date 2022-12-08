pageextension 50080 "ZM Posted Sales Invoice Lines" extends "Posted Sales Invoice Lines"
{

    layout
    {
        addlast(Control1)
        {
            field(selClasVtas_btc; selClasVtas_btc)
            {
                ApplicationArea = all;
            }
            field(selFamilia_btc; selFamilia_btc)
            {
                ApplicationArea = all;
            }
            field(selGama_btc; selGama_btc)
            {
                ApplicationArea = all;
            }
            field(desClasVtas_btc; desClasVtas_btc)
            {
                ApplicationArea = all;
            }
            field(desFamilia_btc; desFamilia_btc)
            {
                ApplicationArea = all;
            }
            field(desGama_btc; desGama_btc)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(updateClasifItem)
            {
                Caption = 'Actualizar Clasif. producto', comment = 'ESP="Actualizar Clasif. producto"';
                Image = UpdateDescription;

                trigger OnAction()
                var
                    SalesEvent: Codeunit SalesEvents;
                    lblConfirm: Label '¿Desea actualizar los datos de todas las lineas de venta?', comment = 'ESP="¿Desea actualizar los datos de todas las lineas de venta?"';
                begin
                    if Confirm(lblConfirm) then
                        SalesEvent.UpdateSalesInvoiceLine_ClasifItems();
                end;
            }
        }
    }
}
