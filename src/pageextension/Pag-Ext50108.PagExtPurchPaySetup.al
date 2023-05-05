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
                    field(WarningPlasticReceiptIntra; WarningPlasticReceiptIntra)
                    {
                        ApplicationArea = all;
                    }
                }
            }
            group("Sharepoint")
            {
                Caption = 'Sharepoint', comment = 'ESP="Sharepoint"';

                field("Sharepoint Connection"; "Sharepoint Connection")
                {
                    ApplicationArea = all;
                }
                field("Sharepoint Folder"; "Sharepoint Folder")
                {
                    ApplicationArea = all;
                }
                field(driveId; driveId)
                {
                    ApplicationArea = all;
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