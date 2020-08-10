pageextension 50031 "DocsinPostedBGSubform" extends "Docs. in Posted BG Subform"
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

            field("Direct Debit Mandate ID"; "Direct Debit Mandate ID")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if Modify() then;
                end;
            }
        }
    }
    actions
    {
        modify("Total Settlement")
        {
            Visible = false;
        }
        addafter("Total Settlement")
        {
            action(SettleTSR_BTC)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Liquidar Total', Comment = 'ESP="Liquidar Total"';
                ToolTip = 'Fully settle documents included in the posted bill group.', Comment = 'ESP="Liquida totalmente los documentos incluidos en la remesa registrada."';

                trigger OnAction()
                var
                    PostedDoc: Record "Posted Cartera Doc.";
                    FuncionesZUMMO: codeunit Funciones;
                begin
                    // BTC PSL S20/00324
                    CurrPage.SetSelectionFilter(PostedDoc);
                    FuncionesZUMMO.PagPostedBillsSettleAction(PostedDoc);
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