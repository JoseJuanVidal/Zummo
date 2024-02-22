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
                field(SourcePurchOrderComment; SourcePurchOrderComment)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        InsertDataComment();
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
        Rec."External Document No." := copystr(SourcePurchOrder, 1, MaxStrLen(Rec."External Document No."));
        Rec."Source Purch. Order No" := copystr(SourcePurchOrder, 1, MaxStrLen(Rec."Source Purch. Order No"));
        Rec."Quote Valid Until Date" := CalcDate('+3M', WorkDate());
        Rec.Modify();
    end;


    local procedure InsertDataComment()
    var
        myInt: Integer;
    begin
        Rec.ComentarioInterno_btc := CopyStr(SourcePurchOrderComment, 1, MaxStrLen(Rec.ComentarioInterno_btc));
        Rec.Modify();
    end;

    var
        SourcePurchOrder: Code[20];
        SourcePurchOrderComment: text;
        ZummoINCFunctions: Codeunit "Zummo Inn. IC Functions";
}