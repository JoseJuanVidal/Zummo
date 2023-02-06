
page 17200 "API FinSales Quote Header"
{
    PageType = Card;
    SourceTable = "Dimension ID Buffer";
    SourceTableTemporary = true;

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
                        if SourcePurchOrder <> '' then
                            InsertData();
                    end;
                }
                field(DocumentNo; DocumentNo)
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    var
                    begin
                        if DocumentNo <> '' then
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
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        if SourcePurchOrder = '' then
            SalesHeader.SetRange("No.", DocumentNo)
        else
            SalesHeader.SetRange("Source Purch. Order No", SourcePurchOrder);
        if SalesHeader.FindFirst() then begin
            DocumentNo := SalesHeader."No.";
            SourcePurchOrder := SalesHeader."Source Purch. Order No";

            // ZummoINCFunctions.SendMailOnCreateQuote(SalesHeader);

            ZummoINCFunctions.TaskSendMailOnCreateQuote(SalesHeader);

        end;

    end;

    var
        SalesHeader: Record "Sales Header";
        SourcePurchOrder: Code[20];
        DocumentNo: Code[20];
        ZummoINCFunctions: Codeunit "Zummo Inn. IC Functions";
}