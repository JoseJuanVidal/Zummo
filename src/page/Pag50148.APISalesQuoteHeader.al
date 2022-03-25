page 50148 "API Sales Quote Header"
{
    PageType = Card;
    SourceTable = "Sales Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(SourcePurchOrder; SourcePurchOrder)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        InsertData();
                    end;
                }
            }
        }

    }

    local procedure InsertData()
    var
    begin
        Rec.Init();
        Rec.Validate("Document Type", Rec."Document Type"::Quote);
        Rec.InitRecord();
        Rec.Validate("Sell-to Customer No.", 'C06646');
        Rec."Source Purch. Order No" := SourcePurchOrder;
        Rec.Modify()
    end;

    var
        SourcePurchOrder: Code[20];
}