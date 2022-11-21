page 50134 "ZM Item Where Used"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Item;
    SourceTableView = where(Blocked = const(false), "Production BOM No." = filter(<> ''));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Production BOM No."; "Production BOM No.")
                {
                    ApplicationArea = all;
                }
                part(Lines; "ZM Item Where Used detail")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //CurrPage.Lines.Page.ItemWhereUsed(Rec);
    end;
}