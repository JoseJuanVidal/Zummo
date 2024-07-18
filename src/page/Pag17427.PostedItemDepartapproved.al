page 17427 "Posted Item Depart. approved"
{
    Caption = 'Posted Item Department approved', Comment = 'ESP="Hist. Aprobaciones Departamento"';
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
                field(Rol; Rol)
                {
                    ApplicationArea = all;
                }
                field(Obligatory; Obligatory)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
