codeunit 50116 "SepaPrepareSourceRegClos"
{
    TableNo = "Direct Debit Collection Entry";

    trigger OnRun()
    var
        DirectDebitCollectionEntry: Record "Direct Debit Collection Entry";
    begin
        DirectDebitCollectionEntry.CopyFilters(Rec);
        CopyLines(DirectDebitCollectionEntry, Rec);
    end;

    local procedure CopyLines(var FromDirectDebitCollectionEntry: Record "Direct Debit Collection Entry"; var ToDirectDebitCollectionEntry: Record "Direct Debit Collection Entry")
    begin
        if not FromDirectDebitCollectionEntry.IsEmpty then begin
            FromDirectDebitCollectionEntry.SetFilter(Status, '%1|%2',
              FromDirectDebitCollectionEntry.Status::New, FromDirectDebitCollectionEntry.Status::"File Created");
            if FromDirectDebitCollectionEntry.FindSet then
                repeat
                    ToDirectDebitCollectionEntry := FromDirectDebitCollectionEntry;
                    ToDirectDebitCollectionEntry.Insert;
                until FromDirectDebitCollectionEntry.Next = 0
        end else
            CreateTempCollectionEntries(FromDirectDebitCollectionEntry, ToDirectDebitCollectionEntry);
    end;

    local procedure CreateTempCollectionEntries(var FromDirectDebitCollectionEntry: Record "Direct Debit Collection Entry"; var ToDirectDebitCollectionEntry: Record "Direct Debit Collection Entry")
    var
        BillGroup: Record "Posted Bill Group";
        BillGroup2: Record "Closed Bill Group";
        CarteraDoc: Record "Posted Cartera Doc.";
        CarteraDoc2: Record "Closed Cartera Doc.";
        DirectDebitCollection: Record "Direct Debit Collection";
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        ToDirectDebitCollectionEntry.Reset;
        DirectDebitCollection.Get(FromDirectDebitCollectionEntry.GetRangeMin("Direct Debit Collection No."));

        if DirectDebitCollection."Source Table ID" = DATABASE::"Posted Bill Group" then begin
            BillGroup.Get(DirectDebitCollection.Identifier);
            CarteraDoc.SetCurrentKey(Type, "Collection Agent", "Bill Gr./Pmt. Order No.");
            CarteraDoc.SetRange(Type, CarteraDoc.Type::Receivable);
            CarteraDoc.SetRange("Collection Agent", CarteraDoc."Collection Agent"::Bank);
            CarteraDoc.SetRange("Bill Gr./Pmt. Order No.", BillGroup."No.");
            if CarteraDoc.FindSet then
                repeat
                    ToDirectDebitCollectionEntry.Init;
                    ToDirectDebitCollectionEntry."Direct Debit Collection No." := DirectDebitCollection."No.";
                    ToDirectDebitCollectionEntry."Entry No." := CarteraDoc."Entry No.";
                    ToDirectDebitCollectionEntry."Customer No." := CarteraDoc."Account No.";
                    ToDirectDebitCollectionEntry.Validate("Applies-to Entry No.", CarteraDoc."Entry No.");
                    ToDirectDebitCollectionEntry.Validate("Mandate ID", CarteraDoc."Direct Debit Mandate ID");
                    ToDirectDebitCollectionEntry.Insert;
                until CarteraDoc.Next = 0;
        end else begin  // Cartera cerrada
            BillGroup2.Get(DirectDebitCollection.Identifier);
            CarteraDoc2.SetCurrentKey(Type, "Collection Agent", "Bill Gr./Pmt. Order No.");
            CarteraDoc2.SetRange(Type, CarteraDoc2.Type::Receivable);
            CarteraDoc2.SetRange("Collection Agent", CarteraDoc2."Collection Agent"::Bank);
            CarteraDoc2.SetRange("Bill Gr./Pmt. Order No.", BillGroup2."No.");
            if CarteraDoc2.FindSet then
                repeat
                    ToDirectDebitCollectionEntry.Init;
                    ToDirectDebitCollectionEntry."Direct Debit Collection No." := DirectDebitCollection."No.";
                    ToDirectDebitCollectionEntry."Entry No." := CarteraDoc2."Entry No.";
                    ToDirectDebitCollectionEntry."Customer No." := CarteraDoc2."Account No.";

                     ToDirectDebitCollectionEntry."Applies-to Entry No." := CarteraDoc2."Entry No.";
                    CustLedgerEntry.GET(ToDirectDebitCollectionEntry."Applies-to Entry No.");
                    ToDirectDebitCollectionEntry."Transfer Date" := CustLedgerEntry."Due Date";
                    ToDirectDebitCollectionEntry."Currency Code" := CustLedgerEntry."Currency Code";
                    ToDirectDebitCollectionEntry."Transfer Amount" := CarteraDoc2."Amount for Collection";
                    ToDirectDebitCollectionEntry."Transaction ID" := STRSUBSTNO('%1/%2', DirectDebitCollection.Identifier, ToDirectDebitCollectionEntry."Entry No.");

                    ToDirectDebitCollectionEntry.Validate("Mandate ID", CarteraDoc2."Direct Debit Mandate ID");
                    ToDirectDebitCollectionEntry.Insert;
                until CarteraDoc2.Next = 0;
        end;

        OnAfterCreateTempCollectionEntries(FromDirectDebitCollectionEntry, ToDirectDebitCollectionEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateTempCollectionEntries(var FromDirectDebitCollectionEntry: Record "Direct Debit Collection Entry"; var ToDirectDebitCollectionEntry: Record "Direct Debit Collection Entry")
    begin
    end;
}