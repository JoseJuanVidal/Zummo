page 50020 "STH Purchase SubCategorys"
{
    ApplicationArea = All;
    Caption = 'Purch. SubCategorys', comment = 'ESP="SubCategorias compra"';
    PageType = List;
    SourceTable = "STH Purchase SubCategory";
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
                field("Purch. Category code"; Rec."Purch. Category code")
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
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = all;
                }
                field("Last date updated"; Rec."Last date updated")
                {
                    ApplicationArea = All;
                }
                field("To Update"; Rec."To Update")
                {
                    ApplicationArea = All;
                }
                field("Items No."; "Items No.")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
            }
        }
    }
}
