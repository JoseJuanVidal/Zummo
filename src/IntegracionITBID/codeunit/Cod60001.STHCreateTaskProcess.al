codeunit 60001 "STH Create Task Process"
{
    TableNo = Item;

    trigger OnRun()
    begin
        JsonText := zummoFunctions.GetJSON_Item(Rec);
        zummoFunctions.PutBody(JsonText, Rec);
    end;

    var
        zummoFunctions: Codeunit "STH Zummo Functions";
        JsonText: TexT;
}