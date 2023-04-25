page 17412 "ZM PL Item Setup Departments"
{
    Caption = 'Item Setup Departments', comment = 'ESP="Conf. Departamentos Alta productos"';
    PageType = Card;
    UsageCategory = None;
    // ApplicationArea = all;
    SourceTable = "ZM PL Item Setup Department";

    layout
    {
        area(Content)
        {
            group(General)
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
            group(Setup)
            {
                field(Email; Email)
                {
                    ApplicationArea = all;
                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
