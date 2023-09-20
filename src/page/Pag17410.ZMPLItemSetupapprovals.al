page 17410 "ZM PL Item Setup approvals"
{
    Caption = 'Item Setup Departments', Comment = 'ESP="Conf. Departamentos Alta productos"';
    PageType = List;
    SourceTable = "ZM PL Item Setup Approval";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table No."; Rec."Table No.")
                {
                    ApplicationArea = All;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field(Obligatory; Obligatory)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
