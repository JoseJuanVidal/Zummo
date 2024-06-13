codeunit 60002 "STH Task Scheduler Failure"
{
    var
        cduSmtp: Codeunit "SMTP Mail";
        txtCuerpo: Text;
        txtAsunto: Text;
        recSMTPSetup: Record "SMTP Mail Setup";
        itbidSetup: Record "Sales & Receivables Setup";
        error_Lbl: Label 'Fallo en intregración de compras';

    trigger OnRun()
    begin
        if not recSMTPSetup.Get() then
            exit;

        itbidSetup.Get();

        txtAsunto := error_Lbl;
        txtCuerpo := GetLastErrorText();

        clear(cduSmtp);
        cduSmtp.CreateMessage(CompanyName, recSMTPSetup."User ID", itbidSetup.STHemail, txtAsunto, txtCuerpo, true);

        if not cduSmtp.TrySend() then
            Message(cduSmtp.GetLastSendMailErrorText());
    end;
}
