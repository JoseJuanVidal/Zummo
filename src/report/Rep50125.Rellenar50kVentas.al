report 50125 "Rellenar50kVentas"
{
    Permissions = tabledata "Sales Invoice Header" = m;
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Update 50000 fields in Posted Sales Invoice', Comment = 'ESP="Rellenar campos 50000 Hist. Fa. ventas"';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                DataItemTableView = sorting("Sell-to Customer No.");
                DataItemLinkReference = Customer;
                DataItemLink = "Sell-to Customer No." = field("No.");

                trigger OnAfterGetRecord()
                begin
                    CentralCompras_btc := Customer.CentralCompras_btc;
                    ClienteCorporativo_btc := Customer.ClienteCorporativo_btc;
                    AreaManager_btc := Customer.AreaManager_btc;
                    Delegado_btc := Customer.Delegado_btc;
                    GrupoCliente_btc := Customer.GrupoCliente_btc;
                    Perfil_btc := Customer.Perfil_btc;
                    SubCliente_btc := Customer.SubCliente_btc;
                    ClienteReporting_btc := Customer.ClienteReporting_btc;

                    Modify();
                end;
            }

            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = sorting("Document Type", "Sell-to Customer No.");
                DataItemLinkReference = Customer;
                DataItemLink = "Sell-to Customer No." = field("No.");

                trigger OnAfterGetRecord()
                begin
                    CentralCompras_btc := Customer.CentralCompras_btc;
                    ClienteCorporativo_btc := Customer.ClienteCorporativo_btc;
                    AreaManager_btc := Customer.AreaManager_btc;
                    Delegado_btc := Customer.Delegado_btc;
                    GrupoCliente_btc := Customer.GrupoCliente_btc;
                    Perfil_btc := Customer.Perfil_btc;
                    SubCliente_btc := Customer.SubCliente_btc;
                    ClienteReporting_btc := Customer.ClienteReporting_btc;

                    Modify();
                end;
            }
        }
    }

    trigger OnPreReport()
    var
        LabelName_Qst: Label '¿Do you want to update 50000 fields?', comment = 'ESP="¿Desea actualizar los campos 50000?"';
    begin
        if not Confirm(LabelName_Qst) then
            Error('');
    end;

    trigger OnPostReport()
    var
        LbMsg: Label 'Process completed', comment = 'ESP="Proceso completado"';
    begin
        Message(LbMsg);
    end;
}