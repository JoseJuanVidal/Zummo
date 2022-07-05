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
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.TestField("Customer Quote IC");
        Rec.Init();
        Rec.Validate("Document Type", Rec."Document Type"::Quote);
        Rec.InitRecord();
        Rec.Validate("Sell-to Customer No.", SalesReceivablesSetup."Customer Quote IC");
        Rec."Source Purch. Order No" := SourcePurchOrder;
        Rec.Modify()
    end;

    var
        SourcePurchOrder: Code[20];
}