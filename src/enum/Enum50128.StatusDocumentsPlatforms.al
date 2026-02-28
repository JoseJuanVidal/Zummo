enum 50128 "Status Documents Platforms"
{
    Extensible = true;
    value(0; " ") { }
    value(1; Valid)
    {
        Caption = 'Valid', comment = 'ESP="Vigente"';
    }
    value(2; Employee)
    {
        Caption = 'Obsolete', comment = 'ESP="Obsoleto"';
    }
}