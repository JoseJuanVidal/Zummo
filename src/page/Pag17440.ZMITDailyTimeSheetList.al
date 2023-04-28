page 17440 "ZM IT Daily Time Sheet List"
{
    Caption = 'Daily Time Sheet List', comment = 'ESP="Lista partes diarios"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ZM IT Daily Time Sheet";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Date; Date)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        ValidateDate();
                    end;
                }
                field(Department; Department)
                {
                    ApplicationArea = all;
                }
                field(Time; Time)
                {
                    ApplicationArea = all;
                }
                field("User id"; "User id")
                {
                    ApplicationArea = all;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateUserId();
                    end;
                }
                field("Resource no."; "Resource no.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = all;
                }
                field("Resource Name"; "Resource Name")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Editable)
            {
                ApplicationArea = All;
                Caption = 'Edit', comment = 'ESP="Editar"';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.Editable(true);
                end;
            }
        }
    }

    var
        myInt: Integer;

    local procedure ValidateDate();
    begin
        if Rec."User id" = '' then
            Rec.Validate("User id", UserId);
    end;

    local procedure ValidateUserId();
    begin
        CurrPage.Update();
    end;

}