enum 50104 "Tipo Almacen"
{
    Extensible = true;

    value(0; Ninguno)
    {
        Caption = ' ', comment = 'ESP=" "';
    }

    value(1; "Externo")
    {
        Caption = 'Externo', comment = 'ESP="Externo"';
    }
    value(2; "Interno")
    {
        Caption = 'Interno', comment = 'ESP="Interno"';
    }
}