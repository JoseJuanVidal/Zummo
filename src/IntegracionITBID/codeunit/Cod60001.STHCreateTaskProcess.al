codeunit 60001 "STH Create Task Process"
{
    TableNo = Item;

    trigger OnRun()
    var
        IsUpdate: Boolean;
    begin
        JsonText := zummoFunctions.GetJSON_Item(Rec);
        zummoFunctions.PutBody(JsonText, Rec."No.", IsUpdate);
        if IsUpdate then begin
            Rec."STH To Update" := false;
            Rec."STH Last Update Date" := Today;
            Rec.Modify();
        end;
    end;

    var
        zummoFunctions: Codeunit "STH Zummo Functions";
        JsonText: TexT;
}