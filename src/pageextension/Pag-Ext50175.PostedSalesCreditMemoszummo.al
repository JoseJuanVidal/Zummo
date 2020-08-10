pageextension 50175 "PostedSalesCreditMemos_zummo" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Location Code")
        {
            field(CorreoEnviado_btc; CorreoEnviado_btc) { }
            field(FacturacionElec_btc; FacturacionElec_btc) { }
            field("Corrected Invoice No."; "Corrected Invoice No.")
            {
                ApplicationArea = All;
            }
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