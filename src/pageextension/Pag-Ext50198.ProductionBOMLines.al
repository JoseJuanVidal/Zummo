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
                Editable = false;
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
        case Item."Costing Method" of
            Item."Costing Method"::Average, Item."Costing Method"::FIFO, Item."Costing Method"::LIFO, Item."Costing Method"::Specific:
                Coste := Item."Last Direct Cost";
            Item."Costing Method"::Standard:
                coste := Item."Standard Cost";

        end;
    end;

}