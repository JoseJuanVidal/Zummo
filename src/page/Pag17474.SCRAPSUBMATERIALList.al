page 17474 "SCRAP SUBMATERIAL List"
{
    Caption = 'SubMaterial', comment = 'ESP="SubMaterial"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SCRAP SUBMATERIAL";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}