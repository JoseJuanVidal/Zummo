page 17411 "ZM PL Item Setup Depart. List"
{
    Caption = 'Item Setup Departments List', comment = 'ESP="Lista Conf. Departamentos Alta productos"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ZM PL Item Setup Department";
    CardPageId = "ZM PL Item Setup Departments";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
