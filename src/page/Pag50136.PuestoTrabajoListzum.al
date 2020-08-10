page 50136 "Puesto Trabajo List_zum"
{
    Caption = 'Puesto de Trabajo ', comment = 'ESP="Puesto de Trabajo"';
    PageType = List;
    SourceTable = MultiRRHH_zum;
    SourceTableView = WHERE(tabla = CONST("Puesto Trabajo"));
    ApplicationArea = All;
    UsageCategory = Lists;
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

            systempart(Notes; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }
}

