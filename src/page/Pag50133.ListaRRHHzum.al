page 50133 "Lista RRHH_zum"
{
    Caption = 'Lista', comment = 'ESP="Lista"';
    PageType = List;
    SourceTable = MultiRRHH_zum;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Codigo; Codigo)
                {
                }
                field(Descripcion; Descripcion)
                {
                }
            }
        }
        area(factboxes)
        {

            systempart(Control1120020001; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }
}

