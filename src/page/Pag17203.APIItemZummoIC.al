page 17203 "API Item Zummo IC"
{
    PageType = List;
    SourceTable = Item;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.") { ApplicationArea = all; }
                field(Description; Description) { ApplicationArea = all; }
                field(Blocked; Blocked) { ApplicationArea = all; }
                field("Sales Blocked"; "Sales Blocked") { ApplicationArea = all; }
                field("Block Reason"; "Block Reason") { ApplicationArea = all; }
                field("Item Category Code"; "Item Category Code") { ApplicationArea = all; }
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