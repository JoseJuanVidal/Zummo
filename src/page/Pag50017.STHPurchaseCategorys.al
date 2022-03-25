page 50017 "STH Purchase Categorys"
{
    ApplicationArea = All;
    Caption = 'Purch. Categorys', comment = 'ESP="Categorias compra"';
    PageType = List;
    SourceTable = "STH Purchase Category";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Purch. Familiy code"; Rec."Purch. Familiy code")
                {
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Last date updated"; Rec."Last date updated")
                {
                    ApplicationArea = All;
                }
                field("To Update"; Rec."To Update")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
