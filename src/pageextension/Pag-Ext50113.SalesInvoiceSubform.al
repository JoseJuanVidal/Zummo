pageextension 50113 "SalesInvoiceSubform" extends "Sales Invoice Subform"
{
    layout
    {
        modify("No.")
        {
            StyleExpr = StyleExpBloqueado;
        }
        modify(Description)
        {
            StyleExpr = StyleExpBloqueado;
        }
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
                StyleExpr = StyleExpBloqueado;
            }
        }
        addlast(Control1)
        {
            field(DIVISION; DIVISION)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Business Unit"; "Business Unit")
            {
                ApplicationArea = all;
                Visible = false;
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
        StyleExpBloqueado := '';

        if type = Type::Item then begin
            clear(cduSalesEvents);
            txtBloqueado := cduSalesEvents.GetTipoBloqueoProducto("No.", StyleExpBloqueado);
        end;
    end;

    var
        txtBloqueado: Text;
        StyleExpBloqueado: Text;
}