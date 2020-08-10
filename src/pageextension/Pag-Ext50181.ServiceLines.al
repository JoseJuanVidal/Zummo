pageextension 50181 "ServiceLines" extends "Service Lines"
{
    layout
    {
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
            txtBloqueado := cduSalesEvents.GetTipoBloqueoProducto("No.");
        end;
    end;

    var
        txtBloqueado: Text;
}