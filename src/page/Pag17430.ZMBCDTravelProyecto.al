page 17430 "ZM BCD Travel Proyecto"
{
    PageType = List;
    Caption = 'BCD Travel Proyecto', comment = 'ESP="BCD Travel Proyecto"';
    //    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "ZM BCD Travel Proyecto";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Codigo; Codigo)
                {
                    ApplicationArea = All;
                }
                field(Proyecto; Proyecto)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}