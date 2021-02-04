pageextension 50055 "STH AssemblyBOMExt" extends "Assembly BOM"
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

    actions
    {
        // Add changes to page actions here
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
        /*case Item."Costing Method" of
            Item."Costing Method"::Average, Item."Costing Method"::FIFO, Item."Costing Method"::LIFO, Item."Costing Method"::Specific:
                Coste := Item."Last Direct Cost";
            Item."Costing Method"::Standard:
                coste := Item."Standard Cost";

        end;*/
        coste := Item."Standard Cost";
    end;

}