pageextension 50117 "GenLedgSetupPage" extends "General Ledger Setup"
{
    layout
    {
        addafter(Application)
        {
            group(Bitec)
            {
                Caption = 'Bitec', comment = 'ESP="Bitec"';

                field(TipoCambioPorFechaEmision_btc; TipoCambioPorFechaEmision_btc)
                {
                    ApplicationArea = All;
                }
                field("Cta. Contable IVA Recupeacion"; "Cta. Contable IVA Recuperacion")
                {
                    ApplicationArea = all;
                }
                field("Proveedor IVA Recuperacion"; "Proveedor IVA Recuperacion")
                {
                    ApplicationArea = all;
                }
            }
            group(ABERTIA)
            {
                Caption = 'Conexión SQL ABERTIA', comment = 'ESP="Conexión SQL ABERTIA"';
                field("Data Source"; "Data Source")
                {
                    ApplicationArea = all;
                }
                field("Initial Catalog"; "Initial Catalog")
                {
                    ApplicationArea = all;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = all;
                }
                field(Password; Password)
                {
                    ApplicationArea = all;
                }
                field("Path LOG"; "Path LOG")
                {
                    ApplicationArea = all;

                    trigger OnAssistEdit()
                    begin
                        Rec."Path LOG" := SelectPathPurchaseDocuments();
                    end;
                }
            }
        }
        addafter("Allow Posting To")
        {
            field(BloqueoCompras; BloqueoCompras)
            {

            }
            field(BloqueoVentas; BloqueoVentas) { }
        }
        addlast(General)
        {
            field("Add Document Type Payments"; "Add Document Type Payments")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Config. Contabilidad" then
            Error(StrSubstNo('El usuario %1 no tiene permisos para la configuración contabilidad', UserId));
    end;

    var
        UserSetup: Record "User Setup";
}