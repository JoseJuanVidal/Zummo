enum 50113 "ZM PL State Creation Item"
{
    Extensible = true;

    value(0; " ")
    {
    }
    value(1; Requested)
    {
        Caption = 'Requested', comment = 'ESP="Solicitado"';
    }
    value(2; "Released")
    {
        Caption = 'Releades', comment = 'ESP="En curso"';
    }
    value(3; Finished)
    {
        Caption = 'Finished', comment = 'ESP="Finalizado"';
    }
}