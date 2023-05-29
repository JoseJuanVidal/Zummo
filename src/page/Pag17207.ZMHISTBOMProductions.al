page 17207 "ZM HIST BOM Productions"
{
    Caption = 'HIST BOM Productions', Comment = 'ESP="Hist. L.M. Producción"';
    PageType = List;
    SourceTable = "ZM HIST BOM Production";
    ApplicationArea = all;
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Period Start"; Rec."Period Start")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
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
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = All;
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    ApplicationArea = all;
                }
                field(Level; Level)
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
            action(Cargar)
            {
                ApplicationArea = all;
                Image = Loaner;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    rec.UpdateBomHist();
                end;
            }
        }
    }
}
