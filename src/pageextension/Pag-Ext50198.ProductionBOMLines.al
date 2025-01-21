pageextension 50198 "Production BOM Lines" extends "Production BOM Lines"
{
    layout
    {
        addlast(Content)
        {
            Field(Language; Language)
            {
                ApplicationArea = all;
                Caption = 'Language Filter', comment = 'ESP="Filtro Idioma"';
                TableRelation = Language;

                trigger OnValidate()
                begin
                    Rec.SetRange("Language Filter", Language);
                    CurrPage.Update();
                end;
            }

        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Item.Get("No.") then
                    Item.TestField(Blocked, false);
            end;

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
            field("Description Language"; "Description Language")
            {
                ApplicationArea = all;
            }
            field(Coste; Coste)
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter("Routing Link Code")
        {
            field(Blocked; Blocked)
            {
                ApplicationArea = all;
            }
            field(Steel; Steel)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Carton; Carton)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(Wood; Wood)
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }
    var
        SalesRecivablesSetup: record "Sales & Receivables Setup";
        Language: code[10];
        Coste: Decimal;

    trigger OnOpenPage()
    begin
        SalesRecivablesSetup.get();
        if SalesRecivablesSetup.LanguageFilter <> '' then
            Rec.SetRange("Language Filter", SalesRecivablesSetup.LanguageFilter);
    end;

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