pageextension 50033 "DocsinPostedPOSubform" extends "Docs. in Posted PO Subform"
{
    layout
    {
        addafter("Account No.")
        {
            field(txtNomb; txtNombre)
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Name', comment = 'ESP="Nombre"';
            }
        }
        addafter("Document No.")
        {
            field("ZM Vendor Ext Doc No."; "ZM Vendor Ext Doc No.")
            {
                ApplicationArea = all;
            }
        }

    }
    actions
    {
        modify(TotalSettlement)
        {
            Visible = false;
        }
        addafter(TotalSettlement)
        {
            action("Total SettlementTSR_BTC")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Liq. total', Comment = 'ESP="Liq. total"';
                Ellipsis = true;
                ToolTip = 'Permite ver los documentos registrados que se han liquidado totalmente.', Comment = 'ESP="Permite ver los documentos registrados que se han liquidado totalmente."';

                trigger OnAction()
                var
                    PostedDoc: Record "Posted Cartera Doc.";
                    FuncionesZUMMO: codeunit Funciones;
                begin
                    CurrPage.SetSelectionFilter(PostedDoc);
                    FuncionesZUMMO.PagDocsPostedBGAction(PostedDoc);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recCustomer: Record customer;
        recVendor: Record Vendor;
    begin
        txtNombre := '';

        if Type = Type::Payable then begin
            if recVendor.Get("Account No.") then
                txtNombre := recVendor.Name;
        end else
            if recCustomer.Get("Account No.") then
                txtNombre := recCustomer.Name;
    end;

    var
        txtNombre: Text[100];
}