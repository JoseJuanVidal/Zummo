page 50129 "Productions tools"
{
    ApplicationArea = All;
    Caption = 'Productions tool', Comment = 'ESP="Lista Utiles producción"';
    PageType = List;
    SourceTable = "ZM Productión Tools";
    UsageCategory = Lists;
    CardPageId = "Productions tool";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }
                field("Last date revision"; Rec."Last date revision")
                {
                    ApplicationArea = All;
                }
                field(Periodicity; Rec.Periodicity)
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Resolution; Rec.Resolution)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ShowProdToolLdgEntry)
            {
                ApplicationArea = all;
                Caption = 'Prod. Tools Ledger Entrys', comment = 'ESP="Movs. Utiles Prod."';
                Image = Ledger;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ShowProdToolLdgEntrys;
                end;


            }
        }
    }


}

