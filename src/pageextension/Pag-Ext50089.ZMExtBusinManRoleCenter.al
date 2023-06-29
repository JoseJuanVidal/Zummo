pageextension 50089 "ZM Ext Busin. Man. Role Center" extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Vendor)
        {
            action(DailyTimeSheet)
            {
                Caption = 'Daily Time Sheet', comment = 'ESP="Partes Diarios"';
                ApplicationArea = all;
                image = Timesheet;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;

                RunObject = page "ZM Daily Time Sheet List";
            }
        }
    }

    var
        myInt: Integer;
}