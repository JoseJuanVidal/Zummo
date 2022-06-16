page 50018 "STH Purch, Familiy"
{
    ApplicationArea = All;
    Caption = 'Purch. Familys', comment = 'ESP="Familias compra"';
    PageType = List;
    SourceTable = "STH Purchase Family";
    UsageCategory = Lists;

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
