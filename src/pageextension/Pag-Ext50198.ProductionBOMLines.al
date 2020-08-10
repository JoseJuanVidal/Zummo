pageextension 50198 "Production BOM Lines" extends "Production BOM Lines"
{
    layout
    {
        modify("No.")
        {
            trigger OnDrillDown()
            var
                Item: Record Item;
            begin
                Item.reset;
                Item.SetRange("No.", Rec."No.");
                Item.FindFirst();
                page.run(30, Item);
            end;

        }
        addafter(Description)
        {
            field(Coste; Coste)
            {
                ApplicationArea = all;
            }
        }
    }
    var
        Coste: Decimal;

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        Coste := 0;
        Item.reset;
        Item.SetRange("No.", Rec."No.");
        if Item.FindFirst() then;
        Coste := Item."Last Direct Cost";
    end;

}