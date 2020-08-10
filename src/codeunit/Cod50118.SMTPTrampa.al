codeunit 50118 "SMTP_Trampa"
{
    Permissions = tabledata "Service Password" = RIMD;

    trigger OnRun()
    begin

    end;

    var
        SmtpClient: DotNet MySmtpClient;
        MailMessage: DotNet MyMailMessage;

    procedure CreateMessage(SenderName: Text; SenderAddress: Text; Recipients: Text; Subject: Text; Body: Text; ReplyToName: Text; ReplyToAddress: Text)
    var
        FromAddress: DotNet MyMailAddress;
        ReplyAddress: DotNet MyMailAddress;
    begin
        // create from address
         FromAddress := FromAddress.MailAddress(ReplyToAddress, ReplyToName);

        // create mail message
        IF NOT ISNULL(MailMessage) THEN
            CLEAR(MailMessage);

        MailMessage := MailMessage.MailMessage;
        MailMessage.From := FromAddress;
        MailMessage.Body := Body;
        MailMessage.Subject := Subject;
        MailMessage."To".Clear;
        MailMessage."To".Add(Recipients);
        MailMessage.IsBodyHtml := true;
        MailMessage.Sender := FromAddress.MailAddress(ReplyToAddress, ReplyToName);

        // create and add reply-to-address
        ReplyAddress := ReplyAddress.MailAddress(ReplyToAddress, ReplyToName);
        MailMessage.ReplyTo := ReplyAddress;
    end;

    procedure SendSmtpMail()
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        NetworkCredential: DotNet MyNetworkCredential;
        userAux: text[250];
        passAux: text[250];
    begin
        SMTPMailSetup.FindFirst();

        userAux := SMTPMailSetup."User ID";
        passAux := SMTPMailSetup.GetPassword();

        SMTPMailSetup."User ID" := SMTPMailSetup.UsuarioVencimientos;
        SMTPMailSetup.SetPassword(getPassw2());

        SMTPMailSetup.Modify();
        Commit();

        WITH SMTPMailSetup DO BEGIN
            SmtpClient := SmtpClient.SmtpClient("SMTP Server", "SMTP Server Port");
            SmtpClient.EnableSsl := "Secure Connection";
            IF Authentication <> Authentication::Anonymous THEN
                IF "User ID" <> '' THEN BEGIN
                    SmtpClient.UseDefaultCredentials := FALSE;
                    NetworkCredential := NetworkCredential.NetworkCredential("User ID", SMTPMailSetup.GetPassword());
                    SmtpClient.Credentials := NetworkCredential;
                END ELSE BEGIN
                    CLEAR(NetworkCredential);
                    SmtpClient.Credentials := NetworkCredential;
                    SmtpClient.UseDefaultCredentials := TRUE;
                END
            ELSE BEGIN
                CLEAR(NetworkCredential);
                SmtpClient.Credentials := NetworkCredential;
                SmtpClient.UseDefaultCredentials := FALSE;
            END;

            IF ISNULL(MailMessage) THEN
                ERROR('Mail msg was not created');

            SmtpClient.Send(MailMessage);
            MailMessage.Dispose;
            SmtpClient.Dispose;

            CLEAR(MailMessage);
            CLEAR(SmtpClient);
        END;

        SMTPMailSetup."User ID" := userAux;
        SMTPMailSetup.SetPassword(passAux);

        SMTPMailSetup.Modify();
        Commit();
    end;

    local procedure getPassw2(): Text
    var
        ServicePassword: Record "Service Password";
        recSmtp: Record "SMTP Mail Setup";
    begin
        recSmtp.Get();
        recSmtp.TestField(PassVencimientos);

        IF NOT ISNULLGUID(recSmtp.PassVencimientos) THEN
            IF ServicePassword.GET(recSmtp.PassVencimientos) THEN
                EXIT(ServicePassword.GetPassword);

        EXIT('');
    end;
}