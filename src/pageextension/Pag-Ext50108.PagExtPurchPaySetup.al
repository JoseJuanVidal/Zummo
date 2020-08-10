pageextension 50108 "PagExtPurchPaySetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Default Accounts")
        {
            group(Bitec)
            {
                Caption = 'Bitec', comment = 'ESP="Bitec"';

                group(GrTextoEmail)
                {
                    Caption = 'Text e-mail purchase order', comment = 'ESP="Texto e-mail pedido compra"';

                    field(textoEmail; textoEmail)
                    {
                        ApplicationArea = All;
                        ShowCaption = false;
                        MultiLine = true;

                        trigger OnValidate()
                        begin
                            SetTextoEmail(textoEmail);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        textoEmail := GetTextoEmail();
    end;

    var
        textoEmail: Text;
}