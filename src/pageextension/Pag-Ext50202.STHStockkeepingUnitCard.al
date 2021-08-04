pageextension 50202 "STH Stockkeeping Unit Card" extends "Stockkeeping Unit Card"
{
    layout
    {
        addafter("Qty. on Component Lines")
        {
            field(QtyonQuotesOrder; QtyonQuotesOrder)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}