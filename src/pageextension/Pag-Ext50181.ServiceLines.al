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

    actions
    {
        addafter("&Create Lines from Time Sheets")
        {
            action(ExcludeWaranty)
            {
                Caption = 'Check Exclude Warranty', comment = 'ESP="Marcar Excluir Garantía"';
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ExcludeWarantySelection();
                end;
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
        lblExclude: Label '¿Do you want to check Exclude Warranty on %1 selected records?', comment = 'ESP="¿Desea marcar Excluir Garantía en %1 registros seleccionados?"';

    local procedure ExcludeWarantySelection()
    var
        ServiceLine: Record "Service Line";
    begin
        CurrPage.SetSelectionFilter(ServiceLine);
        if not Confirm(lblExclude, true, ServiceLine.Count) then
            exit;
        if ServiceLine.FindFirst() then
            repeat
                ServiceLine.SetHideWarrantyWarning(true);
                ServiceLine.Validate("Exclude Warranty", true);
                ServiceLine.SetHideWarrantyWarning(False);
                ServiceLine.Modify();
            Until ServiceLine.next() = 0;
        //ServiceLine.ModifyAll("Exclude Warranty", true, true);
    end;
}