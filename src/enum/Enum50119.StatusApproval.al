enum 50119 "Status Approval"
{
    Extensible = true;

    value(0; Pending)
    {
        Caption = 'Pending', comment = 'ESP="Pendiente"';
    }
    value(1; Approved)
    {
        Caption = 'Approved', comment = 'ESP="Aprobado"';
    }
    value(2; Reject)
    {
        Caption = 'Reject', comment = 'ESP="Rechazado"';
    }
}