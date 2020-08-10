dotnet
{
    assembly("System")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Net.Mail.SmtpClient"; MySmtpClient) { }
        type("System.Net.Mail.MailMessage"; MyMailMessage) { }
        type("System.Net.Mail.MailAddress"; MyMailAddress) { }
        type("System.Net.NetworkCredential"; MyNetworkCredential) { }
    }
}