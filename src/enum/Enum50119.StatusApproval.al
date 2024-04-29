enum 50119 "Status Approval"
{
    Extensible = true;
    value(0; " ")
    { }

    value(1; Pending)
    {
        Caption = 'Pending', comment = 'ESP="Pendiente"';
    }
    value(2; Approved)
    {
        Caption = 'Approved', comment = 'ESP="Aprobado"';
    }
    value(3; Reject)
    {
        Caption = 'Reject', comment = 'ESP="Rechazado"';
    }
}