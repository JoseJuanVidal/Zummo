pageextension 50203 "ZM Service Order Types" extends "Service Order Types"
{
    layout
    {
        addafter(Description)
        {
            field("Exportar BI Reclamaciones"; "Exportar BI Reclamaciones")
            {
                ApplicationArea = all;
            }
        }
    }
}
