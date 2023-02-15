page 17452 "ZM Area Manager statistic"
{
    PageType = List;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTable = Customer;
    SourceTableView = where(AreaManager_btc = filter(<> ''));

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = all;
                }
                field(AreaManager_btc; AreaManager_btc)
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}