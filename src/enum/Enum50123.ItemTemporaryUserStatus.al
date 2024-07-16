enum 50123 "Item Temporary User Status"
{
    Extensible = true;

    value(0; " ")
    {
    }
    value(1; Pending)
    {
        Caption = 'Pending', comment = 'ESP="Pendiente"';
    }
    value(2; Comprobado)
    {
        Caption = 'Check', comment = 'ESP="Comprobado"';
    }
}