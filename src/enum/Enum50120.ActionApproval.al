enum 50120 "Action Approval"
{
    Extensible = true;

    value(0; " ")
    {
    }
    value(1; New)
    {
        Caption = 'New', comment = 'ESP="Nuevo"';
    }
    value(2; Modify)
    {
        Caption = 'Modify', comment = 'ESP="Cambio"';
    }
    value(4; Delete)
    {
        Caption = 'Delete', comment = 'ESP="Eliminar"';
    }
}