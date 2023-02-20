page 17453 "ERP LINK Role Center"
{
    Caption = 'ERPLINK Role Center', Comment = 'ESP="ERPLINK Role Center"';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = Service;
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(Tasks)
            {
                Caption = 'Tasks', Comment = 'ESP="Tareas"';

                action("ERPLink Items")
                {
                    ApplicationArea = Service;
                    Caption = 'ERPLINK Items', Comment = 'ESP="ERPLINK Productos"';
                    Image = ServiceTasks;
                    RunObject = Page "ZM CIM Items";
                    ToolTip = 'View or edit ERP LINK Items', Comment = 'ESP="Ver o editar los producto de ERPLINK"';
                }
            }
        }
    }
}
