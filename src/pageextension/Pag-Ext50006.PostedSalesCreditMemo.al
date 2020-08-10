pageextension 50006 "PostedSalesCreditMemo" extends "Posted Sales Credit Memo"
{
    //Guardar Nº asiento y Nº documento

    layout
    {
        addafter("Corrected Invoice No.")
        {

            field(CorreoEnviado_btc; CorreoEnviado_btc) { } 
            field(FacturacionElec_btc; FacturacionElec_btc) { }           
        }

    }
    actions
    {

        addafter(SendCustom)
        {
            action(Email_btc)
            {
                ApplicationArea = All;
                Image = Email;
                Promoted = true;
                PromotedCategory = Category6;
                Caption = '&Email', comment = 'ESP="&Correo electrónico"';
                trigger onAction()
                var
                    cduCron: Codeunit CU_Cron;
                begin
                    cduCron.EnvioPersonalizado(Rec);
                end;
            }

        }
        modify("Send by &Email")
        {
            Visible = false;
        }

        modify(SendCustom)
        {
            Visible = false;
        }
    }
}