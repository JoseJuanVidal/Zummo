table 17378 "ZM Reporting SEB Sales"
{
    DataClassification = CustomerContent;
    Caption = 'Reporting SEB Sales', comment = 'ESP="Reporting SEB Sales"';
    LookupPageId = "ZM Bussiness Unit Sales";
    DrillDownPageId = "ZM Bussiness Unit Sales";

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
        field(4; "Business Unit"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Business Unit', comment = 'ESP="Business Unit"';
        }
        field(5; Fl1; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fl1', comment = 'ESP="Fl1"';
        }
        field(6; Fl2; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Fl2', comment = 'ESP="Fl2"';
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
        key(Key1; "Period Start", "Business Unit", MLA, "CMMF Code")
        { }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        Item: Record Item;
        Customer: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        RepSEBSales: Record "ZM Reporting SEB Sales";
        RepSEBSalesDetail: Record "ZM Reporting SEB Detail";


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

    // Recalcula solo los meses completos que cubre el filtro; el resto del histórico no se toca
    procedure UploadItemLedgerEntry(PeriodFilter: Text)
    var
        FromDate: Date;
        ToDate: Date;
        PeriodStart: date;
        PeriodEnd: date;
        Window: Dialog;
        EntryNo: Integer;
        EntryNoDetail: Integer;
        UnitCost: Decimal;
        lblWindow: Label 'Fecha: #1###########\Nº Mov: #2###############';
    begin
        GetMonthRange(PeriodFilter, FromDate, ToDate);

        Window.Open('Eliminando');
        RepSEBSales.Reset();
        RepSEBSales.SetRange("Period Start", FromDate, ToDate);
        RepSEBSales.DeleteAll();
        RepSEBSalesDetail.Reset();
        RepSEBSalesDetail.SetRange("Period Start", FromDate, ToDate);
        RepSEBSalesDetail.DeleteAll();
        Window.Close();

        RepSEBSales.Reset();
        if RepSEBSales.FindLast() then
            EntryNo := RepSEBSales."Entry No.";
        RepSEBSalesDetail.Reset();
        if RepSEBSalesDetail.FindLast() then
            EntryNoDetail := RepSEBSalesDetail."Entry No.";

        Clear(Item);
        Clear(Customer);
        Clear(ItemLedgerEntry);
        RepSEBSales.Reset();
        RepSEBSales.SetCurrentKey("Period Start", "Business Unit", MLA, "CMMF Code");

        Window.Open(lblWindow);
        ValueEntry.Reset();
        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntry.SetRange("Posting Date", FromDate, ToDate);
        ValueEntry.SetFilter("Invoiced Quantity", '<>0');
        if ValueEntry.FindSet() then
            repeat
                Window.Update(1, ValueEntry."Posting Date");
                Window.Update(2, ValueEntry."Entry No.");
                if Item."No." <> ValueEntry."Item No." then begin
                    Clear(Item);
                    if Item.Get(ValueEntry."Item No.") then;
                end;
                if (Customer."No." <> ValueEntry."Source No.") or (ValueEntry."Source Type" <> ValueEntry."Source Type"::Customer) then begin
                    Clear(Customer);
                    if ValueEntry."Source Type" = ValueEntry."Source Type"::Customer then
                        if Customer.Get(ValueEntry."Source No.") then;
                end;
                if ItemLedgerEntry."Entry No." <> ValueEntry."Item Ledger Entry No." then begin
                    Clear(ItemLedgerEntry);
                    UnitCost := 0;
                    if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                        ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                        if ItemLedgerEntry.Quantity <> 0 then
                            UnitCost := ItemLedgerEntry."Cost Amount (Actual)" / ItemLedgerEntry.Quantity;
                    end;
                end;
                PeriodStart := CalcDate('<-CM>', ValueEntry."Posting Date");
                PeriodEnd := CalcDate('<CM>', ValueEntry."Posting Date");

                RepSEBSales.SetRange("Period Start", PeriodStart);
                RepSEBSales.SetRange("Business Unit", Item."Business Unit");
                RepSEBSales.SetRange(MLA, Customer.MLA);
                RepSEBSales.SetRange("CMMF Code", Item."CMMF Code");
                if not RepSEBSales.FindFirst() then begin
                    EntryNo += 1;
                    RepSEBSales.Init();
                    RepSEBSales."Entry No." := EntryNo;
                    RepSEBSales."Period Start" := PeriodStart;
                    RepSEBSales."Period End" := PeriodEnd;
                    RepSEBSales."Business Unit" := Item."Business Unit";
                    RepSEBSales.MLA := Customer.MLA;
                    RepSEBSales."CMMF Code" := Item."CMMF Code Reporting";
                    RepSEBSales.Fl1 := Item.Fl1;
                    RepSEBSales.Fl2 := Item.Fl2;
                    RepSEBSales.Insert();
                end;
                RepSEBSales.Quantity -= ValueEntry."Invoiced Quantity";
                RepSEBSales.Amount += ValueEntry."Sales Amount (Actual)";
                RepSEBSales.Costs -= UnitCost * ValueEntry."Invoiced Quantity";
                RepSEBSales.Modify();

                RepSEBSalesDetail.Init();
                EntryNoDetail += 1;
                RepSEBSalesDetail."Entry No." := EntryNoDetail;
                RepSEBSalesDetail."Business Unit" := Item."Business Unit";
                RepSEBSalesDetail."CMMF Code" := Item."CMMF Code Reporting";
                RepSEBSalesDetail.MLA := Customer.MLA;
                RepSEBSalesDetail.Fl1 := Item.Fl1;
                RepSEBSalesDetail.Fl2 := Item.Fl2;
                RepSEBSalesDetail."Item No." := ValueEntry."Item No.";
                RepSEBSalesDetail.Description := Item.Description;
                RepSEBSalesDetail."Document No." := ValueEntry."Document No.";
                RepSEBSalesDetail."Posting Date" := ValueEntry."Posting Date";
                RepSEBSalesDetail.Quantity := -ValueEntry."Invoiced Quantity";
                RepSEBSalesDetail.Costs := -UnitCost * ValueEntry."Invoiced Quantity";
                RepSEBSalesDetail.Amount := ValueEntry."Sales Amount (Actual)";
                RepSEBSalesDetail."Reporting SEB Entry No" := RepSEBSales."Entry No.";
                RepSEBSalesDetail."Source No." := ValueEntry."Source No.";
                RepSEBSalesDetail."Source Name" := Customer.Name;
                RepSEBSalesDetail."Vat Registration Name" := Customer."VAT Registration No.";
                RepSEBSalesDetail."Period Start" := PeriodStart;
                RepSEBSalesDetail."Period End" := PeriodEnd;
                RepSEBSalesDetail.Insert(true);
            until ValueEntry.Next() = 0;
        Window.Close();
    end;

    // Convierte un filtro de fechas en el rango de meses completos que lo cubre
    procedure GetMonthRange(PeriodFilter: Text; var FromDate: Date; var ToDate: Date)
    var
        Fechas: Record Date;
        lblErrFilter: Label 'Indique un filtro de fecha con fecha inicial y final.', comment = 'ESP="Indique un filtro de fecha con fecha inicial y final."';
    begin
        Fechas.SetFilter("Period Start", PeriodFilter);
        FromDate := Fechas.GetRangeMin("Period Start");
        ToDate := Fechas.GetRangeMax("Period Start");
        if (FromDate = 0D) or (ToDate = 0D) or (ToDate = DMY2Date(31, 12, 9999)) then
            Error(lblErrFilter);
        FromDate := CalcDate('<-CM>', FromDate);
        ToDate := CalcDate('<CM>', ToDate);
    end;

    procedure DrillDrow()
    var
        myInt: Integer;
    begin
        RepSEBSalesDetail.Reset();
        RepSEBSalesDetail.SetRange("Reporting SEB Entry No", Rec."Entry No.");
        page.RunModal(0, RepSEBSalesDetail);
    end;
}