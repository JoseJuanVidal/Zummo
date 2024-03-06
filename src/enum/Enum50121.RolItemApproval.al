enum 50121 "Rol Item Approval"
{
    Extensible = true;

    value(0; " ")
    {
    }
    value(1; Owner)
    {
        Caption = 'Owner', comment = 'ESP="Propietario"';
    }
    value(2; Approval)
    {
        Caption = 'Approval', comment = 'ESP="Aprobador"';

    }
    value(3; Both)
    {
        Caption = 'Both', comment = 'ESP="Ambos"';
    }
}