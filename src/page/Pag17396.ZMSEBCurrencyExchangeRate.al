page 17396 "ZM SEB Currency Exchange Rate"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ZM SEB Currency Exchange Rate";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = all;
                }
                field("Exchange Rate Amount"; "Exchange Rate Amount")
                {
                    ApplicationArea = all;
                }
                field("G/L Budget Exchange Rate Amount"; "G/L Budget Exchange Rate Amount")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}