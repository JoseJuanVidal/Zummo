report 50128 "Extracto Proveedor"
{


    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50128.ExtractoProveedor.rdl';
    Caption = 'Estracto Proveedor', Comment = 'Vendor - Detail Trial Balance';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group";

            column(lbFechaVto; lbFechaVto) { }
            column(lbDescription; lbDescription) { }
            column(lbImportePendiente; lbImportePendiente) { }
            column(FiltrosMovProveedor; "Vendor Ledger Entry".TABLECAPTION + ': ' + FiltrosMovProveedor)
            {
            }
            column(DateFilter; STRSUBSTNO(Text000, VendDateFilter))
            {
            }
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(TableFilter; Vendor.TABLECAPTION + ': ' + VendFilter)
            {
            }
            column(VendFilter; VendFilter)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(PrintAmountsInLCY; PrintAmountsInLCY)
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(RemainingAmtCaption; RemainingAmtCaption)
            {
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
            }
            column(No_Vend; "No.")
            {
            }
            column(Name_Vend; Name)
            {
            }
            column(PhoneNo_Vend; "Phone No.")
            {
                IncludeCaption = true;
            }
            column(StartBalanceLCY; StartBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(StartVendDebitAmtAdj; StartVendDebitAmountAdj)
            {
                AutoFormatType = 1;
            }
            column(StartVendCreditAmtAdj; StartVendCreditAmountAdj)
            {
                AutoFormatType = 1;
            }
            column(VendBalanceLCY; VendBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(BalLBalAdjLVendLedgEntryAmtLCY; StartBalanceLCY + StartBalAdjLCY + "Vendor Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding)
            {
                AutoFormatType = 1;
            }
            column(VendDebitAmtDebitCorrDebit; StartVendDebitAmount + DebitCorrection + DebitApplicationRounding)
            {
                AutoFormatType = 1;
            }
            column(StartBalanceLCYStartBalAdjLCY; StartBalanceLCY + StartBalAdjLCY)
            {
                AutoFormatType = 1;
            }
            column(VendCreditAmtCreditCredit; StartVendCreditAmount + CreditCorrection + CreditApplicationRounding)
            {
                AutoFormatType = 1;
            }
            column(StartVendDebitAmtTotal; StartVendDebitAmountTotal)
            {
            }
            column(StartVendCreditAmtTotal; StartVendCreditAmountTotal)
            {
            }
            column(CreditAppRound; CreditApplicationRounding)
            {
            }
            column(DebitAppRound; DebitApplicationRounding)
            {
            }
            column(CreditCorrect; CreditCorrection)
            {
            }
            column(DebitCorrect; DebitCorrection)
            {
            }
            column(DateFilter1_Vend; "Date Filter")
            {
            }
            column(GlobalDim2Filter_Vend; "Global Dimension 2 Filter")
            {
            }
            column(VendorDetailTrialBalCaption; VendorDetailTrialBalCaptionLbl)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(AllamountsareinLCYCaption; AllamountsareinLCYCaptionLbl)
            {
            }
            column(vendorsbalancesCaption; vendorsbalancesCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(DocumentTypeCaption; DocumentTypeCaptionLbl)
            {
            }
            column(BalanceLCYCaption; BalanceLCYCaptionLbl)
            {
            }
            column(DueDateCaption; DueDateCaptionLbl)
            {
            }
            column(CreditCaption; CreditCaptionLbl)
            {
            }
            column(DebitCaption; DebitCaptionLbl)
            {
            }
            column(AdjofOpeningBalanceCaption; AdjofOpeningBalanceCaptionLbl)
            {
            }
            column(TotalLCYCaption; TotalLCYCaptionLbl)
            {
            }
            column(TotalAdjofOpeningBalCaption; TotalAdjofOpeningBalCaptionLbl)
            {
            }
            column(TotalLCYBeforePeriodCaption; TotalLCYBeforePeriodCaptionLbl)
            {
            }
            column(LiqTipoDocCaptionLbl; LiqTipoDocCaptionLbl)
            {
            }
            column(LiqNoDocCaptionLbl; LiqNoDocCaptionLbl)
            {
            }
            column(NoDocumentoCaptionLbl; NoDocumentoCaptionLbl)
            {
            }
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"), "Date Filter" = FIELD("Date Filter");
                DataItemTableView = SORTING("Vendor No.", "Posting Date");
                RequestFilterFields = "Document Type", Open, "Due Date", "Posting Date";
                column(StartBalLCYAmtLCY; StartBalanceLCY + "Amount (LCY)")
                {
                    AutoFormatType = 1;
                }
                column(PostingDate_VendLedgEntry; FORMAT("Posting Date"))
                {
                }
                column(DocType_VendLedgEntry; "Document Type")
                {
                }
                column(DocNo_VendLedgEntry; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(VendLedgEntryDescp; Description)
                {
                    IncludeCaption = true;
                }
                column(VendCreditAmt; VendCreditAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendDebitAmt; VendDebitAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendBalLCY; VendBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(VendRemainAmt; VendRemainAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendEntryDueDate; FORMAT(VendEntryDueDate))
                {
                }
                column(EntryNo_VendLedgEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(VendCurrencyCode; VendCurrencyCode)
                {
                }
                column(VendorNo_VendLedgEntry; "Vendor No.")
                {
                }
                column(GlbalDim1Code_VendLedgEntry; "Global Dimension 1 Code")
                {
                }
                column(DateFilter_VendLedgEntry; "Date Filter")
                {
                }
                column(VendorLedgerEntry_ExternalDocumentNo; "Vendor Ledger Entry"."External Document No.")
                {
                }
                column(AppliesToDocType_VendorLedgerEntry; "Applies-to Doc. Type")
                {
                }
                column(AppliesToDocNo_VendorLedgerEntry; "Applies-to Doc. No.")
                {
                }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No." = FIELD("Entry No.");
                    DataItemTableView = SORTING("Vendor Ledger Entry No.", "Entry Type", "Posting Date") WHERE("Entry Type" = CONST("Correction of Remaining Amount"));
                    column(DocNo1_VendLedgEntry; "Vendor Ledger Entry"."Document No.")
                    {
                    }
                    column(EntryType_DtdVendLedgEntry; "Entry Type")
                    {
                    }
                    column(DebitCorrection; DebitCorrection)
                    {
                        AutoFormatType = 1;
                    }
                    column(CreditCorrection; CreditCorrection)
                    {
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord();
                    begin
                        Correction := Correction + "Amount (LCY)";
                        VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    end;

                    trigger OnPostDataItem();
                    begin
                        SumCorrections := SumCorrections + Correction;
                    end;

                    trigger OnPreDataItem();
                    begin
                        SETFILTER("Posting Date", VendDateFilter);
                        Correction := 0;
                    end;
                }
                dataitem("Detailed Vendor Ledg. Entry2"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No." = FIELD("Entry No.");
                    DataItemTableView = SORTING("Vendor Ledger Entry No.", "Entry Type", "Posting Date") WHERE("Entry Type" = CONST("Appln. Rounding"));
                    column(EntryType_DtdVendLedgEntry2; "Entry Type")
                    {
                    }
                    column(VendBalanceLCY1; VendBalanceLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(DebitAppRounding; DebitApplicationRounding)
                    {
                        AutoFormatType = 1;
                    }
                    column(CreditApplicationRounding; CreditApplicationRounding)
                    {
                        AutoFormatType = 1;
                    }
                    column(DocType_VendLedgEntry2; "Vendor Ledger Entry"."Document Type")
                    {
                    }
                    column(VendLEtrNo_DtdVendLedgEntry2; "Vendor Ledger Entry No.")
                    {
                    }

                    trigger OnAfterGetRecord();
                    begin
                        ApplicationRounding := ApplicationRounding + "Amount (LCY)";
                        VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    end;

                    trigger OnPreDataItem();
                    begin

                        SETFILTER("Posting Date", VendDateFilter);
                    end;
                }

                trigger OnAfterGetRecord();
                begin
                    CALCFIELDS(Amount, "Remaining Amount", "Credit Amount (LCY)", "Debit Amount (LCY)", "Amount (LCY)", "Remaining Amt. (LCY)",
                      "Credit Amount", "Debit Amount");

                    VendLedgEntryExists := true;
                    if PrintAmountsInLCY then begin
                        VendCreditAmount := "Credit Amount (LCY)";
                        VendDebitAmount := "Debit Amount (LCY)";
                        VendRemainAmount := "Remaining Amt. (LCY)";
                        VendCurrencyCode := '';
                    end else begin
                        VendCreditAmount := "Credit Amount";
                        VendDebitAmount := "Debit Amount";
                        VendRemainAmount := "Remaining Amount";
                        VendCurrencyCode := "Currency Code";
                    end;
                    VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                    StartVendCreditAmount := StartVendCreditAmount + "Credit Amount (LCY)";
                    StartVendDebitAmount := StartVendDebitAmount + "Debit Amount (LCY)";
                    if ("Document Type" = "Document Type"::Payment) or ("Document Type" = "Document Type"::Refund) then
                        VendEntryDueDate := 0D
                    else
                        VendEntryDueDate := "Due Date";

                    StartVendCreditAmountTotal := StartVendCreditAmountTotal + "Credit Amount (LCY)";
                    StartVendDebitAmountTotal := StartVendDebitAmountTotal + "Debit Amount (LCY)";
                end;

                trigger OnPreDataItem();
                begin

                    VendLedgEntryExists := false;
                    CurrReport.CREATETOTALS(VendAmount, VendDebitAmount, VendCreditAmount, "Amount (LCY)");
                    StartVendDebitAmount := 0;
                    StartVendCreditAmount := 0;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(VendorName; Vendor.Name)
                {
                }
                column(VendBalanceLCY2; VendBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(StartBalAdjLCY; StartBalAdjLCY)
                {
                }
                column(StartBalanceLCY1; StartBalanceLCY)
                {
                }
                column(VendBalLCYDebitAmtDebitAmtAdj; StartVendDebitAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }
                column(VendBalLCYCreditAmtCreditAmtAdj; StartVendCreditAmount)
                {
                    AutoFormatExpression = VendCurrencyCode;
                    AutoFormatType = 1;
                }

                trigger OnAfterGetRecord();
                begin
                    if not VendLedgEntryExists and ((StartBalanceLCY = 0) or ExcludeBalanceOnly) then begin
                        StartBalanceLCY := 0;
                        CurrReport.SKIP;
                    end;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if PrintOnlyOnePerPage then
                    PageGroupNo := PageGroupNo + 1;

                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                StartBalanceLCY := 0;
                StartBalAdjLCY := 0;
                if VendDateFilter <> '' then begin
                    if GETRANGEMIN("Date Filter") <> 0D then begin
                        SETRANGE("Date Filter", 0D, GETRANGEMIN("Date Filter") - 1);
                        CALCFIELDS("Net Change (LCY)");
                        StartBalanceLCY := -"Net Change (LCY)";
                        StartVendDebitAmount := "Vendor Ledger Entry"."Debit Amount (LCY)";
                        StartVendCreditAmount := "Vendor Ledger Entry"."Credit Amount (LCY)";
                    end;
                    SETFILTER("Date Filter", VendDateFilter);
                    CALCFIELDS("Net Change (LCY)");
                    StartBalAdjLCY := -"Net Change (LCY)";
                    VendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                    VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                    VendorLedgerEntry.SETFILTER("Posting Date", VendDateFilter);
                    if VendorLedgerEntry.FIND('-') then
                        repeat
                            VendorLedgerEntry.SETFILTER("Date Filter", VendDateFilter);
                            VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
                            StartBalAdjLCY := StartBalAdjLCY - VendorLedgerEntry."Amount (LCY)";
                            "Detailed Vendor Ledg. Entry".SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type", "Posting Date");
                            "Detailed Vendor Ledg. Entry".SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                            "Detailed Vendor Ledg. Entry".SETFILTER("Entry Type", '%1|%2',
                              "Detailed Vendor Ledg. Entry"."Entry Type"::"Correction of Remaining Amount",
                              "Detailed Vendor Ledg. Entry"."Entry Type"::"Appln. Rounding");
                            "Detailed Vendor Ledg. Entry".SETFILTER("Posting Date", VendDateFilter);
                            if "Detailed Vendor Ledg. Entry".FIND('-') then
                                repeat
                                    StartBalAdjLCY := StartBalAdjLCY - "Detailed Vendor Ledg. Entry"."Amount (LCY)";
                                until "Detailed Vendor Ledg. Entry".NEXT = 0;
                            "Detailed Vendor Ledg. Entry".RESET;
                        until VendorLedgerEntry.NEXT = 0;
                end;
                CurrReport.PRINTONLYIFDETAIL := ExcludeBalanceOnly or (StartBalanceLCY = 0);
                VendBalanceLCY := StartBalanceLCY + StartBalAdjLCY;
                if StartBalAdjLCY > 0 then begin
                    StartVendDebitAmountAdj := StartBalAdjLCY;
                    StartVendCreditAmountAdj := 0;
                end else begin
                    StartVendDebitAmountAdj := 0;
                    StartVendCreditAmountAdj := StartBalAdjLCY;
                end;
            end;

            trigger OnPreDataItem();
            begin
                PageGroupNo := 1;
                SumCorrections := 0;

                //CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                CurrReport.CREATETOTALS("Vendor Ledger Entry"."Amount (LCY)", StartBalanceLCY, StartBalAdjLCY, Correction, ApplicationRounding,
                                        "Vendor Ledger Entry"."Debit Amount (LCY)", "Vendor Ledger Entry"."Credit Amount (LCY)",
                                        StartBalanceLCY, StartVendDebitAmount, StartVendCreditAmount);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Opciones)
                {

                    Caption = 'Opciones', Comment = 'Options';
                    field(ShowAmountsInLCY; PrintAmountsInLCY)
                    {
                        ApplicationArea = Basic, Suite;

                        Caption = 'Muestra importes en DL', Comment = 'Show Amounts in LCY';


                    }
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;

                        Caption = 'Página nueva por proveedor', Comment = 'New Page per Vendor';

                    }
                    field(ExcludeBalanceOnly; ExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic, Suite;

                        Caption = 'Excluye sólo proveedores con saldo a fecha', Comment = 'Exclude Vendors That Have A Balance Only';
                        MultiLine = true;

                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    var
        CaptionManagement: Codeunit CaptionManagement;
    begin
        // VendFilter := CaptionManagement.GetRecordFiltersWithCaptions(Vendor);
        VendDateFilter := Vendor.GETFILTER("Date Filter");
        //VendDateFilter := "Vendor Ledger Entry".GetFilter("Posting Date");
        FiltrosMovProveedor := "Vendor Ledger Entry".GETFILTERS;

        with "Vendor Ledger Entry" do
            if PrintAmountsInLCY then begin
                AmountCaption := FIELDCAPTION("Amount (LCY)");
                RemainingAmtCaption := FIELDCAPTION("Remaining Amt. (LCY)");
            end else begin
                AmountCaption := FIELDCAPTION(Amount);
                RemainingAmtCaption := FIELDCAPTION("Remaining Amount");
            end;
        CompanyInformation.GET;
    end;

    var
        Text000: Label 'Period: %1', Comment = 'ESP="Periodo: %1"';
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VendFilter: Text;
        VendDateFilter: Text;
        VendAmount: Decimal;
        VendRemainAmount: Decimal;
        VendBalanceLCY: Decimal;
        VendEntryDueDate: Date;
        StartBalanceLCY: Decimal;
        StartBalAdjLCY: Decimal;
        Correction: Decimal;
        ApplicationRounding: Decimal;
        ExcludeBalanceOnly: Boolean;
        PrintAmountsInLCY: Boolean;
        PrintOnlyOnePerPage: Boolean;
        VendLedgEntryExists: Boolean;
        AmountCaption: Text[30];
        RemainingAmtCaption: Text[30];
        VendCurrencyCode: Code[10];
        PageGroupNo: Integer;
        SumCorrections: Decimal;
        VendDebitAmount: Decimal;
        VendCreditAmount: Decimal;
        StartVendCreditAmount: Decimal;
        StartVendDebitAmount: Decimal;
        StartVendDebitAmountAdj: Decimal;
        StartVendCreditAmountAdj: Decimal;
        DebitCorrection: Decimal;
        CreditCorrection: Decimal;
        DebitApplicationRounding: Decimal;
        CreditApplicationRounding: Decimal;
        StartVendDebitAmountTotal: Decimal;
        StartVendCreditAmountTotal: Decimal;
        StartBalAdjLCYTotal: Decimal;
        VendorDetailTrialBalCaptionLbl: Label 'Vendor - Detail Trial Balance', Comment = 'ESP="Proveedor - Balance de comprobación detallado"';
        PageNoCaptionLbl: Label 'Page', Comment = 'ESP="Pág."';
        AllamountsareinLCYCaptionLbl: Label 'All amounts are in LCY.', Comment = 'ESP="Importes en divisa local."';  //TextConst ENU = 'All amounts are in LCY.', ESP='Importes en divisa local.';
        vendorsbalancesCaptionLbl: Label 'This report also includes vendors that only have balances.', Comment = 'ESP="Este informe también incluye proveedores que solo tienen saldos."';
        PostingDateCaptionLbl: Label 'Posting Date', Comment = 'ESP="Fecha registro"';  // TextConst ENU = '', ESP='';
        DocumentTypeCaptionLbl: Label 'Document Type', Comment = 'ESP="Tipo doc."';  //TextConst ENU = '', ESP='';
        BalanceLCYCaptionLbl: Label 'Balance (LCY)', Comment = 'ESP="Saldo (DL)"'; // TextConst ENU = '', ESP='';
        DueDateCaptionLbl: Label 'Due Date', Comment = 'ESP="Fecha vencimiento"';//  TextConst ENU = '', ESP='';
        CreditCaptionLbl: Label 'Credit', Comment = 'ESP="Haber"';
        DebitCaptionLbl: Label 'Debit', Comment = 'ESP="Debe"';  //TextConst ENU = '', ESP='Debe';
        AdjofOpeningBalanceCaptionLbl: Label 'Adj. of Opening Balance', Comment = 'ESP="Ajuste saldo apertura"';//TextConst ENU = '', ESP='Ajuste saldo apertura';
        TotalLCYCaptionLbl: Label 'Total (LCY)', Comment = 'ESP="Total (DL)"';
        TotalAdjofOpeningBalCaptionLbl: Label 'Total Adj. of Opening Balance', Comment = 'ESP="Ajuste total saldo apertura"'; //TextConst ENU = '', ESP='';
        TotalLCYBeforePeriodCaptionLbl: Label 'Total (LCY) Before Period', Comment = 'ESP="Total (DL) antes del periodo"'; //TextConst ENU = '', ESP='';
        FiltrosMovProveedor: Text;
        CompanyInformation: Record "Company Information";
        LiqTipoDocCaptionLbl: Label 'Liq. by doc. type', Comment = 'ESP="Liq. por tipo doc."';
        LiqNoDocCaptionLbl: Label 'Liq. by doc. No.', Comment = 'ESP="Liq. por Nº doc."';
        NoDocumentoCaptionLbl: Label 'Doc No.', Comment = 'ESP="Nº doc."';
        Language: Record Language;
        lbFechaVto: Label 'Due Date', comment = 'ESP="Fecha Vto."';
        lbDescription: Label 'Description', Comment = 'ESP="Descripción"';
        lbImportePendiente: Label 'Pending Amount', comment = 'ESP="Importe pendiente"';

    procedure InitializeRequest(NewPrintAmountsInLCY: Boolean; NewPrintOnlyOnePerPage: Boolean; NewExcludeBalanceOnly: Boolean);
    begin
        PrintAmountsInLCY := NewPrintAmountsInLCY;
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        ExcludeBalanceOnly := NewExcludeBalanceOnly;
    end;
}

