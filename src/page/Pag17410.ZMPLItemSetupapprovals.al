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
                    Visible = Mandatory;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Visible = Mandatory;
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
                field(Mandatory; Mandatory)
                {
                    ApplicationArea = all;
                    Visible = Mandatory;
                }
                field(Requester; Requester)
                {
                    ApplicationArea = all;
                    Visible = Mandatory;
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
        if Mandatory then
            Rec.SetFilter("Field No.", '<>0')
        else
            Rec.SetRange("Field No.", 0);
        ItemRegistrationApproval.CheckSUPERUserConfiguration(true);
    end;

    var
        Mandatory: Boolean;
        ItemRegistrationApproval: Codeunit "ZM PL Items Regist. aprovals";

    procedure SetFieldmandatory()
    var
        myInt: Integer;
    begin
        Mandatory := true;
    end;
}
