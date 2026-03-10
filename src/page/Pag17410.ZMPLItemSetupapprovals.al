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
                field("Table Name"; "Table Name")
                {
                    ApplicationArea = all;
                }
                field("Field No."; Rec."Field No.")
                {
                    ApplicationArea = All;
                    Visible = ShowMandatory;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Visible = ShowMandatory;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = all;
                }
                field(Rol; Rol)
                {
                    ApplicationArea = all;
                }
                field("Registration Information"; "Registration Information")
                {
                    ApplicationArea = all;
                }
                field(Mandatory; Mandatory)
                {
                    ApplicationArea = all;
                    Visible = ShowMandatory;
                }
                field(Requester; Requester)
                {
                    ApplicationArea = all;
                    Visible = ShowMandatory;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Fields)
            {
                ApplicationArea = all;
                Caption = 'Campos', comment = 'ESP="Campos"';
                Image = FilterLines;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Visible = not ShowMandatory;

                trigger OnAction()
                var
                    ItemSetupApproval: record "ZM PL Item Setup Approval";
                    ItemSetupapprovals: page "ZM PL Item Setup approvals";
                begin
                    ItemSetupApproval.SetRange("Table No.", Rec."Table No.");
                    ItemSetupapprovals.SetTableView(ItemSetupApproval);
                    ItemSetupapprovals.SetFieldmandatory();
                    ItemSetupapprovals.RunModal();
                end;

            }
        }
    }
    trigger OnOpenPage()
    begin
        if ShowMandatory then
            Rec.SetFilter("Field No.", '<>0')
        else
            Rec.SetRange("Field No.", 0);
        ItemRegistrationApproval.CheckSUPERUserConfiguration(true);
    end;

    var
        ShowMandatory: Boolean;
        ItemRegistrationApproval: Codeunit "ZM PL Items Regist. aprovals";

    procedure SetFieldmandatory()
    begin
        ShowMandatory := true;
    end;
}
