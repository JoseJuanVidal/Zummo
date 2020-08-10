report 50143 "Settle Docs. in Posted PO_BTC"
{
    Caption = 'Liq. docs. en orden regis.';
    Permissions = TableData 21 = imd,
                  TableData 25 = imd,
                  TableData 45 = m,
                  TableData 7000003 = imd,
                  TableData 7000004 = imd,
                  TableData 7000021 = imd,
                  TableData 7000022 = imd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PostedDoc; "Posted Cartera Doc.")
        {
            DataItemTableView = SORTING("Bill Gr./Pmt. Order No.", Status, "Category Code", Redrawn, "Due Date")
                                WHERE(Status = CONST(Open));

            trigger OnAfterGetRecord()
            var
                FromJnl: Boolean;
            begin
                IsRedrawn := CarteraManagement.CheckFromRedrawnDoc("No.");
                IF "Document Type" = "Document Type"::Invoice THEN
                    ExistInvoice := TRUE;

                PostedPmtOrd.GET("Bill Gr./Pmt. Order No.");
                BankAcc.GET(PostedPmtOrd."Bank Account No.");
                Delay := BankAcc."Delay for Notices";

                IF DueOnly AND (PostingDate < "Due Date" + Delay) THEN
                    CurrReport.SKIP;

                DocCount := DocCount + 1;
                Window.UPDATE(1, DocCount);

                CASE "Document Type" OF
                    "Document Type"::Invoice, 1:
                        BEGIN
                            WITH GenJnlLine DO BEGIN
                                GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                                CLEAR(GenJnlLine);
                                INIT;
                                "Line No." := GenJnlLineNextNo;
                                "Posting Date" := PostingDate;
                                "Reason Code" := PostedPmtOrd."Reason Code";
                                "Document Date" := "Document Date";
                                VALIDATE("Account Type", "Account Type"::Vendor);
                                VendLedgEntry.GET(PostedDoc."Entry No.");
                                VALIDATE("Account No.", VendLedgEntry."Vendor No.");
                                "Document Type" := "Document Type"::Payment;
                                Description := COPYSTR(STRSUBSTNO(Text1100001, PostedDoc."Document No."), 1, MAXSTRLEN(Description));
                                "Document No." := PostedPmtOrd."No.";
                                VALIDATE("Currency Code", PostedDoc."Currency Code");
                                IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, FALSE) THEN
                                    VALIDATE(Amount, PostedDoc."Remaining Amount" + VendLedgEntry."Remaining Pmt. Disc. Possible")
                                ELSE
                                    VALIDATE(Amount, PostedDoc."Remaining Amount");
                                "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                                "Applies-to Doc. No." := VendLedgEntry."Document No.";
                                "Applies-to Bill No." := VendLedgEntry."Bill No.";
                                "Source Code" := SourceCode;
                                "Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                                "System-Created Entry" := TRUE;
                                "Shortcut Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                                "Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                                "Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                                INSERT;
                                SumLCYAmt := SumLCYAmt + "Amount (LCY)";
                            END;
                            GroupAmount := GroupAmount + "Remaining Amount";
                            IF PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, FALSE) THEN
                                CalcBankAccount("No.", "Remaining Amount" + VendLedgEntry."Remaining Pmt. Disc. Possible", VendLedgEntry."Entry No.", PostedPmtOrd."No.")
                            ELSE
                                CalcBankAccount("No.", "Remaining Amount", VendLedgEntry."Entry No.", PostedPmtOrd."No.");
                            VendLedgEntry."Document Status" := VendLedgEntry."Document Status"::Honored;
                            VendLedgEntry.MODIFY;
                        END;
                    "Document Type"::Bill:
                        BEGIN
                            WITH GenJnlLine DO BEGIN
                                GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                                CLEAR(GenJnlLine);
                                INIT;
                                "Line No." := GenJnlLineNextNo;
                                "Posting Date" := PostingDate;
                                "Document Type" := "Document Type"::Payment;
                                "Document No." := PostedPmtOrd."No.";
                                "Reason Code" := PostedPmtOrd."Reason Code";
                                VALIDATE("Account Type", "Account Type"::Vendor);
                                VendLedgEntry.GET(PostedDoc."Entry No.");

                                IF GLSetup."Unrealized VAT" THEN BEGIN
                                    FromJnl := FALSE;
                                    IF PostedDoc."From Journal" THEN
                                        FromJnl := TRUE;
                                    ExistsNoRealVAT := GenJnlPostLine.VendFindVATSetup(VATPostingSetup, VendLedgEntry, FromJnl);
                                END;

                                VALIDATE("Account No.", VendLedgEntry."Vendor No.");
                                Description := COPYSTR(STRSUBSTNO(Text1100002, PostedDoc."Document No.", PostedDoc."No."), 1, MAXSTRLEN(Description));
                                VALIDATE("Currency Code", PostedDoc."Currency Code");
                                VALIDATE(Amount, PostedDoc."Remaining Amount");
                                "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                                "Applies-to Doc. No." := VendLedgEntry."Document No.";
                                "Applies-to Bill No." := VendLedgEntry."Bill No.";
                                "Source Code" := SourceCode;
                                "System-Created Entry" := TRUE;
                                "Shortcut Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
                                "Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
                                "Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                                INSERT;
                                SumLCYAmt := SumLCYAmt + "Amount (LCY)";
                            END;
                            IF GLSetup."Unrealized VAT" AND ExistsNoRealVAT AND (NOT IsRedrawn) THEN BEGIN
                                VendLedgEntry.CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");

                                CarteraManagement.VendUnrealizedVAT2(
                                  VendLedgEntry,
                                  VendLedgEntry."Remaining Amt. (LCY)",
                                  GenJnlLine,
                                  ExistVATEntry,
                                  FirstVATEntryNo,
                                  LastVATEntryNo,
                                  NoRealVATBuffer,
                                  FromJnl,
                                  "Document No.");

                                TempCurrCode := "Currency Code";
                                "Currency Code" := '';

                                IF NoRealVATBuffer.FIND('-') THEN BEGIN
                                    REPEAT
                                    BEGIN
                                        InsertGenJournalLine(
                                          GenJnlLine."Account Type"::"G/L Account",
                                          NoRealVATBuffer.Account,
                                          NoRealVATBuffer.Amount,
                                          "Global Dimension 1 Code",
                                          "Global Dimension 2 Code",
                                          "Dimension Set ID");
                                        InsertGenJournalLine(
                                          GenJnlLine."Account Type"::"G/L Account",
                                          NoRealVATBuffer."Balance Account",
                                          -NoRealVATBuffer.Amount,
                                          "Global Dimension 1 Code",
                                          "Global Dimension 2 Code",
                                          "Dimension Set ID");
                                    END;
                                    UNTIL NoRealVATBuffer.NEXT = 0;
                                    NoRealVATBuffer.DELETEALL;
                                END;

                                "Currency Code" := TempCurrCode;
                            END;
                            GroupAmount := GroupAmount + "Remaining Amount";
                            CalcBankAccount("No.", "Remaining Amount", VendLedgEntry."Entry No.", PostedPmtOrd."No.");
                            VendLedgEntry."Document Status" := VendLedgEntry."Document Status"::Honored;
                            VendLedgEntry.MODIFY;
                        END;
                END;
            end;

            trigger OnPostDataItem()
            var
                VendLedgEntry2: Record "Vendor Ledger Entry";
                PostedDoc2: Record "Posted Cartera Doc.";
            begin
                IF (DocCount = 0) OR (GroupAmount = 0) THEN BEGIN
                    IF DueOnly THEN
                        ERROR(Text1100003 + Text1100004);

                    ERROR(Text1100003 + Text1100005);
                END;
                IF BankAccPostBuffer.FIND('-') THEN
                    REPEAT
                        VendLedgEntry2.GET(BankAccPostBuffer."Entry No.");
                        PostedDoc2.GET(1, VendLedgEntry2."Entry No.");
                        PostedPmtOrd.GET(PostedDoc2."Bill Gr./Pmt. Order No.");
                        BankAcc.GET(PostedPmtOrd."Bank Account No.");
                        GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                        WITH GenJnlLine DO BEGIN
                            CLEAR(GenJnlLine);
                            INIT;
                            "Line No." := GenJnlLineNextNo;
                            "Posting Date" := PostingDate;
                            "Document Type" := "Document Type"::Payment;
                            "Document No." := PostedPmtOrd."No.";
                            "Reason Code" := PostedPmtOrd."Reason Code";
                            VALIDATE("Account Type", "Account Type"::"Bank Account");
                            VALIDATE("Account No.", BankAcc."No.");
                            Description := COPYSTR(STRSUBSTNO(Text1100006, PostedPmtOrd."No."), 1, MAXSTRLEN(Description));
                            VALIDATE("Currency Code", PostedPmtOrd."Currency Code");
                            VALIDATE(Amount, -BankAccPostBuffer.Amount);
                            "Source Code" := SourceCode;
                            "Dimension Set ID" :=
                              CarteraManagement.GetCombinedDimSetID(GenJnlLine, BankAccPostBuffer."Dimension Set ID");
                            "System-Created Entry" := TRUE;
                            INSERT;

                            SumLCYAmt := SumLCYAmt + "Amount (LCY)";
                        END;
                    UNTIL BankAccPostBuffer.NEXT = 0;

                IF PostedPmtOrd."Currency Code" <> '' THEN BEGIN
                    IF SumLCYAmt <> 0 THEN BEGIN
                        Currency.SETFILTER(Code, PostedPmtOrd."Currency Code");
                        Currency.FINDFIRST;
                        IF SumLCYAmt > 0 THEN BEGIN
                            Currency.TESTFIELD("Residual Gains Account");
                            Acct := Currency."Residual Gains Account";
                        END ELSE BEGIN
                            Currency.TESTFIELD("Residual Losses Account");
                            Acct := Currency."Residual Losses Account";
                        END;
                        GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                        WITH GenJnlLine DO BEGIN
                            CLEAR(GenJnlLine);
                            INIT;
                            "Line No." := GenJnlLineNextNo;
                            "Posting Date" := PostingDate;
                            "Document Type" := "Document Type"::Payment;
                            "Document No." := PostedPmtOrd."No.";
                            "Reason Code" := PostedPmtOrd."Reason Code";
                            VALIDATE("Account Type", "Account Type"::"G/L Account");
                            VALIDATE("Account No.", Acct);
                            Description := Text1100007;
                            VALIDATE("Currency Code", '');
                            VALIDATE(Amount, -SumLCYAmt);
                            "Source Code" := SourceCode;
                            "System-Created Entry" := TRUE;
                            INSERT;
                        END;
                    END;
                END;
                PostedPmtOrd.MODIFY;
                DocPost.PostSettlementForPostedPmtOrder(GenJnlLine, PostingDate);

                Window.CLOSE;

                IF (Counter > 1) AND GLSetup."Unrealized VAT" AND ExistVATEntry AND ExistInvoice THEN BEGIN
                    IF VATEntry.FINDLAST THEN
                        ToVATEntryNo := VATEntry."Entry No.";
                    GLReg.FINDLAST;
                    GLReg."From VAT Entry No." := FromVATEntryNo;
                    GLReg."To VAT Entry No." := ToVATEntryNo;
                    GLReg.MODIFY;
                END ELSE BEGIN
                    IF ExistVATEntry THEN BEGIN
                        GLReg.FINDLAST;
                        GLReg."From VAT Entry No." := FirstVATEntryNo;
                        GLReg."To VAT Entry No." := LastVATEntryNo;
                        GLReg.MODIFY;
                    END;
                END;

                COMMIT;

                IF NOT HidePrintDialog THEN
                    MESSAGE(Text1100008, DocCount, GroupAmount);
            end;

            trigger OnPreDataItem()
            begin
                DocPost.CheckPostingDate(PostingDate);

                SourceCodeSetup.GET;
                SourceCode := SourceCodeSetup."Cartera Journal";
                DocCount := 0;
                SumLCYAmt := 0;
                GenJnlLineNextNo := 0;
                ExistInvoice := FALSE;
                ExistVATEntry := FALSE;
                Window.OPEN(
                  Text1100000);
                Counter := COUNT;
                IF (Counter > 1) AND GLSetup."Unrealized VAT" THEN BEGIN
                    VATEntry.LOCKTABLE;
                    IF VATEntry.FINDLAST THEN
                        FromVATEntryNo := VATEntry."Entry No." + 1;
                END;
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
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                        NotBlank = true;
                        ToolTip = 'Specifies the posting date for the document.';
                    }
                    field(DueOnly; DueOnly)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Due bills only';
                        ToolTip = 'Specifies if you want to only include documents that have become overdue. If it does not matter if a document is overdue at the time of settlement, leave this field blank.';
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

    trigger OnInitReport()
    begin
        PostingDate := WORKDATE;
    end;

    trigger OnPreReport()
    begin
        GLSetup.GET;
    end;

    var
        Text1100000: Label 'Liquidando documentos a pagar        #1######', Comment = 'Settling payable documents     #1######';
        Text1100001: Label 'Liq. efecto %1/%2', Comment = 'Payable document settlement %1';
        Text1100002: Label 'Liq. documento %1', Comment = 'Payable bill settlement %1/%2';
        Text1100003: Label 'No hay documentos a pagar que liquidar.', Comment = 'No payable documents have been found that can be settled.';
        Text1100004: Label 'Compruebe que ha seleccionado al menos un documento a pagar pdte. y vencido.', Comment = 'Please check that the selection is not empty and at least one receivable documents is open and due.';
        Text1100005: Label 'Compruebe que ha seleccionado al menos un documento a pagar pendiente.', Comment = 'Please check that the selection is not empty and at least one payable document is open.';
        Text1100006: Label 'Liquidación remesa %1', Comment = 'Payment Order settlement %1';
        Text1100007: Label 'Ajuste por redondeo', Comment = 'Residual adjust generated by rounding Amount';
        Text1100008: Label 'Se han liquidado %1 documentos a pagar por un importe de %2.', Comment = '%1 documents totaling %2 have been settled.';
        Text1100009: Label 'Liquida remesa %1 proveedor nº %2', Comment = 'Document settlement %1/%2';
        SourceCodeSetup: Record "Source Code Setup";
        PostedPmtOrd: Record "Posted Payment Order";
        GenJnlLine: Record "Gen. Journal Line" temporary;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        Currency: Record "Currency";
        GLReg: Record "G/L Register";
        GLSetup: Record "General Ledger Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        VATEntry: Record "VAT Entry";
        BankAccPostBuffer: Record "BG/PO Post. Buffer" temporary;
        NoRealVATBuffer: Record "BG/PO Post. Buffer" temporary;
        DocPost: Codeunit "Document-Post";
        CarteraManagement: Codeunit "CarteraManagement";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Window: Dialog;
        PostingDate: Date;
        DueOnly: Boolean;
        Delay: Decimal;
        SourceCode: Code[10];
        Acct: Code[20];
        DocCount: Integer;
        GroupAmount: Decimal;
        GenJnlLineNextNo: Integer;
        SumLCYAmt: Decimal;
        ExistVATEntry: Boolean;
        FirstVATEntryNo: Integer;
        LastVATEntryNo: Integer;
        IsRedrawn: Boolean;
        ExistInvoice: Boolean;
        FromVATEntryNo: Integer;
        ToVATEntryNo: Integer;
        Counter: Integer;
        TempCurrCode: Code[10];
        ExistsNoRealVAT: Boolean;
        HidePrintDialog: Boolean;

    local procedure InsertGenJournalLine(AccType: Integer; AccNo: Code[20]; Amount2: Decimal; Dep: Code[20]; Proj: Code[20]; DimSetID: Integer)
    begin
        GenJnlLineNextNo := GenJnlLineNextNo + 10000;

        WITH GenJnlLine DO BEGIN
            CLEAR(GenJnlLine);
            INIT;
            "Line No." := GenJnlLineNextNo;
            "Posting Date" := PostingDate;
            "Document Type" := "Document Type"::Payment;
            "Document No." := PostedPmtOrd."No.";
            "Reason Code" := PostedPmtOrd."Reason Code";
            "Account Type" := AccType;
            "Account No." := AccNo;
            IF PostedDoc."Document Type" = PostedDoc."Document Type"::Bill THEN
                Description := COPYSTR(STRSUBSTNO(Text1100009, PostedDoc."Document No.", PostedDoc."No."), 1, MAXSTRLEN(Description))
            ELSE
                Description := COPYSTR(STRSUBSTNO(Text1100009, PostedDoc."Document No.", PostedDoc."No."), 1, MAXSTRLEN(Description));
            VALIDATE("Currency Code", PostedDoc."Currency Code");
            VALIDATE(Amount, -Amount2);
            "Applies-to Doc. Type" := VendLedgEntry."Document Type";
            "Applies-to Doc. No." := '';
            "Applies-to Bill No." := VendLedgEntry."Bill No.";
            "Source Code" := SourceCode;
            "System-Created Entry" := TRUE;
            "Shortcut Dimension 1 Code" := Dep;
            "Shortcut Dimension 2 Code" := Proj;
            "Dimension Set ID" := DimSetID;
            SumLCYAmt := SumLCYAmt + "Amount (LCY)";
            INSERT;
        END;
    end;

    procedure CalcBankAccount(BankAcc2: Code[20]; Amount2: Decimal; EntryNo: Integer; NoRemesa: Code[20])
    begin

        Clear(BankAccPostBuffer);
        BankAccPostBuffer.SetRange("Account", NoRemesa);
        if BankAccPostBuffer.FindFirst() then begin
            BankAccPostBuffer.Amount := BankAccPostBuffer.Amount + Amount2;
            BankAccPostBuffer.Modify();
        end else begin
            BankAccPostBuffer.Init;
            BankAccPostBuffer.Account := NoRemesa;
            BankAccPostBuffer.Amount := Amount2;
            BankAccPostBuffer."Entry No." := EntryNo;
            BankAccPostBuffer."Global Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
            BankAccPostBuffer."Global Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
            BankAccPostBuffer.Insert;
        end;
    end;



    procedure SetHidePrintDialog(NewHidePrintDialog: Boolean)
    begin
        HidePrintDialog := NewHidePrintDialog;
    end;
}

