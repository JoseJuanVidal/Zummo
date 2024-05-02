page 17212 "Purchase Request less 200"
{
    ApplicationArea = All;
    Caption = 'Purchase Request less 200', Comment = 'ESP="Solicitudes de Compra menos 200"';
    PageType = List;
    SourceTable = "Purchase Requests less 200";
    UsageCategory = Lists;
    CardPageId = "Purchase Request less 200 Card";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name 2"; Rec."Vendor Name 2")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterUser();
    end;

    var
        UserSetup: Record "User Setup";

    local procedure FilterUser()
    begin
        UserSetup.Reset();
        if UserSetup.Get(UserId) then
            if UserSetup."Approvals Purch. Request" then
                exit;
        Rec.SetRange("User Id", UserId);
    end;
}
