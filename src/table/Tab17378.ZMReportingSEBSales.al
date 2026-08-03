table 17378 "ZM Reporting SEB Sales"
{
    DataClassification = CustomerContent;
    Caption = 'Reporting SEB Sales', comment = 'ESP="Reporting SEB Sales"';
    Permissions = tabledata "Item Ledger Entry" = rmid;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "CMMF Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'CMMF Code', comment = 'ESP="CMMF Code"';
        }
        field(3; "MLA"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'MLA', comment = 'ESP="MLA"';
        }
        field(10; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity', comment = 'ESP="Quantity"';
        }
        field(20; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount', comment = 'ESP="Amount"';

        }
        field(21; Value1; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value1', comment = 'ESP="Value1"';
        }
        field(22; Value2; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Value2', comment = 'ESP="Value2"';
        }
        field(30; Costs; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Costs', comment = 'ESP="Costs"';
        }
        field(100; "Period Start"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period Start', comment = 'ESP="Period Start"';
        }
        field(110; "Period End"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period End', comment = 'ESP="Period End"';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        Item: Record Item;
        Customer: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        RepSEBSales: Record "ZM Reporting SEB Sales";


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    procedure UploadItemLedgerEntry(PeriodFilter: Text)
    var
        PeriodStart: date;
        PeriodEnd: date;
        Window: Dialog;
        EntryNo: Integer;
        lblWindow: Label 'Fecha: #1###########\Nº Mov: #2###############';
    begin
        Item.Reset();
        Window.Open('Eliminando');
        RepSEBSales.DeleteAll();
        Window.Close();
        ItemLedgerEntry.Reset();
        Window.Open('Limpiando');
        ItemLedgerEntry.SetFilter("Reporting SEB Entry No", '<>0');
        ItemLedgerEntry.ModifyAll("Reporting SEB Entry No", 0);
        Window.Close();
        ItemLedgerEntry.SetFilter("Posting Date", PeriodFilter);
        PeriodStart := ItemLedgerEntry.GetRangeMin("Posting Date");
        PeriodEnd := ItemLedgerEntry.GetRangeMax("Posting Date");
        Window.Open(lblWindow);
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
        ItemLedgerEntry.SetRange("Reporting SEB", true);
        if ItemLedgerEntry.FindFirst() then
            repeat
                Window.Update(1, ItemLedgerEntry."Posting Date");
                Window.Update(2, ItemLedgerEntry."Entry No.");
                if Item.Get(ItemLedgerEntry."Item No.") then;
                if Customer.Get(ItemLedgerEntry."Source No.") then;
                ItemLedgerEntry.CalcFields("Cost Amount (Actual)", "Sales Amount (Actual)");
                RepSEBSales.SetRange("CMMF Code", Item."CMMF Code");
                RepSEBSales.SetRange(MLA, Customer.MLA);
                if not RepSEBSales.FindFirst() then begin
                    RepSEBSales.Init();
                    RepSEBSales."Entry No." := EntryNo;
                    RepSEBSales."CMMF Code" := Item."CMMF Code";
                    RepSEBSales.MLA := Customer.MLA;
                    RepSEBSales.Insert();
                end;
                RepSEBSales.Quantity -= ItemLedgerEntry.Quantity;
                RepSEBSales.Amount += ItemLedgerEntry."Sales Amount (Actual)";
                RepSEBSales.Costs -= ItemLedgerEntry."Cost Amount (Actual)";
                RepSEBSales."Period Start" := PeriodStart;
                RepSEBSales."Period End" := PeriodEnd;
                RepSEBSales.Modify();
                ItemLedgerEntry."Reporting SEB Entry No" := RepSEBSales."Entry No.";
                ItemLedgerEntry.Modify();
            until ItemLedgerEntry.Next() = 0;
        Window.Close();
    end;

    procedure DrillDrow()
    var
        myInt: Integer;
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Reporting SEB Entry No", Rec."Entry No.");
        page.RunModal(0, ItemLedgerEntry);
    end;
}