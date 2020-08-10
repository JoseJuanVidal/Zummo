tableextension 50178 "SMTPMailSetup" extends "SMTP Mail Setup"  //409
{
    fields
    {
        field(50100; UsuarioVencimientos; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Statements User', comment = 'ESP="Usuario Vencimientos"';
        }

        field(50101; PassVencimientos; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Statements Password', comment = 'ESP="Password Vencimientos"';
        }
    }
}