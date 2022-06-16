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
    assembly("Sothis.PDF")
    {

        Culture = 'neutral';
        PublicKeyToken = 'null';

        type("Sothis.PDF.Tools"; MySothisPDF) { }
    }
    assembly("mscorlib")
    {
        Version = '2.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Collections.Generic.List`1"; Myfiles) { }
    }
    // System.Collections.Generic.List`1.'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'    
}