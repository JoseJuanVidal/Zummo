pageextension 50001 "ServiceOrder" extends "Service Order"
{
    layout
    {
        modify("Response Date")
        {
            Editable = true;
        }
        addafter("Service Order Type")
        {
            field(TipoPedidoNivel2_btc; TipoPedidoNivel2_btc)
            {
                ApplicationArea = All;
            }

            field(TipoPedidoNivel3_btc; TipoPedidoNivel3_btc)
            {
                ApplicationArea = All;
            }
            field("Cerrado en plataforma"; "Cerrado en plataforma") { }
            field("Solicitado a Técnico"; "Solicitado a Técnico") { }
            field(TickMarksurvey_zm; TickMarksurvey_zm) { }
            field(NumEstanteria_btc; NumEstanteria_btc)
            {
                ApplicationArea = all;
            }
            field(CodResolucion_btc; CodResolucion_btc)
            {
                ApplicationArea = All;
            }


            field(ComentarioAlmacen_btc; ComentarioAlmacen_btc)
            {
                ApplicationArea = all;
            }

        }

        addafter(Description)
        {
            field("Operation Description"; "Operation Description")
            {
                ApplicationArea = all;
            }

            field("Operation Description 2"; "Operation Description 2")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(Duplicate)
            {
                Caption = 'Duplicar', comment = 'ESP="Duplicar"';
                ApplicationArea = all;
                Image = CopyDocument;

                trigger OnAction()
                begin
                    DuplicateServiceOrder;
                end;
            }
        }
        addafter("&Customer Card")
        {
            action(AlertaPedServicio)
            {
                Caption = 'Alerta Ped. Servicios', comment = 'ESP="Alerta Ped. Servicio"';
                ApplicationArea = all;
                Image = Alerts;
                trigger OnAction()
                begin
                    OnAction_AlertaPedServicio();
                end;
            }
        }
    }

    local procedure DuplicateServiceOrder()
    var
        Funciones: Codeunit Funciones;
    begin
        Funciones.DuplicateServiceOrder(Rec);
    end;


    local procedure OnAction_AlertaPedServicio()
    var
        Customer: Record Customer;
        InputValue: page "ZM Input Date";
        Alerta: text;
        lblConfirm: Label '¿Do you want to update %1 with "%2"?', comment = 'ESP="¿Desea actualizar la %1 con "%2"?"';
    begin
        Customer.Get(Rec."Customer No.");
        InputValue.SetTexto(Customer.AlertaPedidoServicio, Customer.FieldCaption(AlertaPedidoServicio));
        InputValue.LookupMode(true);
        if not (InputValue.RunModal() = action::LookupOk) then
            exit;
        Alerta := CopyStr(InputValue.GetTexto(), 1, MaxStrLen(Customer.AlertaPedidoServicio));
        if Confirm(lblConfirm, false, Customer.FieldCaption(AlertaPedidoServicio), Alerta) then begin
            Customer.AlertaPedidoServicio := CopyStr(Alerta, 1, MaxStrLen(Customer.AlertaPedidoServicio));
            Customer.Modify();
        end
    end;
}