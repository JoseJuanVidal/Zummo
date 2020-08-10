pageextension 50113 "SalesInvoiceSubform" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            //231219 S19/01434 Mostar iva en compras y ventas
            field("VAT %"; "VAT %")
            {
                ApplicationArea = All;
            }

            //231219 S19/01434 Mostar iva en compras y ventas
            field("VAT Identifier"; "VAT Identifier")
            {
                ApplicationArea = All;
            }
            field("DecLine Discount1 %_btc"; "DecLine Discount1 %_btc")
            {
                ApplicationArea = All;
            }
            field("DecLine Discount2 %_btc"; "DecLine Discount2 %_btc")
            {
                ApplicationArea = All;
            }
        }

        addafter("No.")
        {
            field(txtBloqueado; txtBloqueado)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Blocked', comment = 'ESP="Bloqueado"';
            }
        }
    }

    actions
    {
        modify(GetShipmentLines)
        {
            trigger OnAfterAction()
            begin
                CurrPage.Update();
            end;
        }
    }

    trigger OnAfterGetRecord()
    var
        cduSalesEvents: Codeunit SalesEvents;
    begin
        txtBloqueado := '';

        if type = Type::Item then begin
            clear(cduSalesEvents);
            txtBloqueado := cduSalesEvents.GetTipoBloqueoProducto("No.");
        end;
    end;

    var
        txtBloqueado: Text;
}