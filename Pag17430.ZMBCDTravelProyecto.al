page 17430 "ZM BCD Travel Proyecto"
{
    PageType = List;
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