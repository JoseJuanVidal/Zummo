page 17444 "ZM Daily Task"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ZM Daily Task";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("User Id"; "User Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}