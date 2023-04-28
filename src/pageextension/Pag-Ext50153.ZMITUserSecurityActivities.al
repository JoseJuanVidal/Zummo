pageextension 50153 "ZM IT User Security Activities" extends "User Security Activities"
{
    layout
    {
        addbefore("Users - To review")
        {
            field("Daily Time Sheet"; '')
            {
                ApplicationArea = all;
                Caption = 'Daily Time Sheet', comment = 'ESP="Partes Diario"';

                trigger OnDrillDown()
                begin
                    DailyTimeSheet();
                end;
            }
        }
    }
    local procedure DailyTimeSheet()
    var
        myInt: Integer;
    begin
        //lanzamos la lista de Marcajes de este usario
    end;

}
