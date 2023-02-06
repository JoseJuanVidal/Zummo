pageextension 50181 "ServiceLines" extends "Service Lines"
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
        addbefore("Service Item No.")

        {
            field("Line No."; "Line No.")
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
    }

    trigger OnAfterGetRecord()
    var
        cduSalesEvents: Codeunit SalesEvents;
    begin
        txtBloqueado := '';

        if type = Type::Item then begin
            clear(cduSalesEvents);
            txtBloqueado := cduSalesEvents.GetTipoBloqueoProducto("No.", StyleExpBloqueado);
        end;
    end;

    var
        txtBloqueado: Text;
        StyleExpBloqueado: Text;
}