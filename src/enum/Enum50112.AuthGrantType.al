enum 50112 "Auth. Grant Type"
{
    value(0; "Authorization Code")
    {
        Caption = 'Authorization Code', Comment = 'ES="Código de Autorización"';
    }
    value(1; "Password Credentials")
    {
        Caption = 'Password Credentials', Comment = 'ES="Credenciales de contraseña"';
    }
    value(2; "Client Credentials")
    {
        Caption = 'Client Credentials', Comment = 'ES="Credenciales del cliente"';
    }
}
