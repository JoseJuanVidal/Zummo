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
                field(Rol; Rol)
                {
                    ApplicationArea = all;
                }
                field(Obligatory; Obligatory)
                {
                    ApplicationArea = all;
                }
                field("Approval Requester"; "Approval Requester")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ItemRegistrationApproval.CheckSUPERUserConfiguration(true);
    end;

    var
        ItemRegistrationApproval: Codeunit "ZM PL Items Regist. aprovals";
}
