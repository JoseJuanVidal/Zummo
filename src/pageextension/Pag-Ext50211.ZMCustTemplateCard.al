pageextension 50211 "ZM Cust. Template Card" extends "Cust. Template Card"
{
    layout
    {
        addlast(Content)
        {
            group(Classification)
            {
                Caption = 'Classification', comment = 'ESP="Clasificación"';
                field(CentralCompras_btc; CentralCompras_btc) { }
                field(ClienteCorporativo_btc; ClienteCorporativo_btc) { }
                field(Perfil_btc; Perfil_btc) { }
                field(AreaManager_btc; AreaManager_btc) { }
                field(InsideSales_btc; InsideSales_btc) { }
                field(Canal_btc; Canal_btc) { }
                field(Mercado_btc; Mercado_btc) { }
                field(Delegado_btc; Delegado_btc) { }
                field(GrupoCliente_btc; GrupoCliente_btc) { }
                field(ClienteActividad_btc; ClienteActividad_btc) { }
                field(SubCliente_btc; SubCliente_btc) { }
                field(ClienteReporting_btc; ClienteReporting_btc) { }
                field("ABC Cliente"; "ABC Cliente") { }

            }
            group("Shipment Method")
            {
                Caption = 'Shipment Method', comment = 'ESP="Condiciones envío"';

                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = all;
                }
                field("Transaction Specification"; "Transaction Specification")
                {
                    ApplicationArea = all;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = all;
                }
                field("Transport Method"; "Transport Method")
                {
                    ApplicationArea = all;
                }
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