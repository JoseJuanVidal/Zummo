report 50142 "SettleDocsinPostBillGrTSR_BTC"
{
 
    Caption = 'Liq. docs. en remesa regis.';
    Permissions = TableData "Cust. Ledger Entry" = imd,
                  TableData "Vendor Ledger Entry" = imd,
                  TableData "G/L Register" = m,
                  TableData "Posted Cartera Doc." = imd,
                  TableData "Closed Cartera Doc." = imd,
                  TableData "Posted Bill Group" = imd,
                  TableData "Closed Bill Group" = imd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PostedDoc; "Posted Cartera Doc.")
        {
            DataItemTableView = SORTING("Bill Gr./Pmt. Order No.", Status, "Category Code", Redrawn, "Due Date") WHERE(Status = CONST(Open));

            trigger OnAfterGetRecord()
            var
                FromJnl: Boolean;
            begin
                IsRedrawn := CarteraManagement.CheckFromRedrawnDoc("No.");

                PostedBillGr.Get("Bill Gr./Pmt. Order No.");
                BankAcc.Get(PostedBillGr."Bank Account No.");
                Delay := BankAcc."Delay for Notices";

                if DueOnly and (PostingDate < "Due Date" + Delay) then
                    CurrReport.Skip;

                DocCount := DocCount + 1;
                Window.Update(1, DocCount);

                with GenJnlLine do begin
                    GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                    Clear(GenJnlLine);
                    Init();
                    "Line No." := GenJnlLineNextNo;
                    "Posting Date" := PostingDate;
                    "Document Type" := "Document Type"::Payment;
                    "Document No." := PostedBillGr."No.";
                    "Reason Code" := PostedBillGr."Reason Code";
                    Validate("Account Type", "Account Type"::Customer);
                    CustLedgEntry.Get(PostedDoc."Entry No.");

                    if GLSetup."Unrealized VAT" and (PostedDoc."Document Type" = PostedDoc."Document Type"::Bill) then begin
                        FromJnl := false;
                        if PostedDoc."From Journal" then
                            FromJnl := true;
                        ExistsNoRealVAT := GenJnlPostLine.CustFindVATSetup(VATPostingSetup, CustLedgEntry, FromJnl)
                    end;

                    Validate("Account No.", CustLedgEntry."Customer No.");
                    if PostedDoc."Document Type" = PostedDoc."Document Type"::Bill then
                        Description := CopyStr(
                            StrSubstNo(Text1100001, PostedDoc."Document No.", PostedDoc."No."),
                            1, MaxStrLen(Description))
                    else
                        Description := CopyStr(
                            StrSubstNo(Text1100002, PostedDoc."Document No."),
                            1, MaxStrLen(Description));
                    Validate("Currency Code", PostedDoc."Currency Code");
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) then
                        Validate(Amount, -PostedDoc."Remaining Amount" + CustLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        Validate(Amount, -PostedDoc."Remaining Amount");
                    "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                    "Applies-to Doc. No." := CustLedgEntry."Document No.";
                    "Applies-to Bill No." := CustLedgEntry."Bill No.";
                    "Source Code" := SourceCode;
                    "System-Created Entry" := true;
                    "Shortcut Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";
                    "Dimension Set ID" :=
                      CarteraManagement.GetDimSetIDFromCustLedgEntry(GenJnlLine, CustLedgEntry, true);
                    Insert;
                    SumLCYAmt := SumLCYAmt + "Amount (LCY)";
                end;

                if ("Document Type" = "Document Type"::Bill) and
                   GLSetup."Unrealized VAT" and
                   ExistsNoRealVAT and
                   (not IsRedrawn)
                then begin
                    CustLedgEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    CarteraManagement.CustUnrealizedVAT2(
                      CustLedgEntry,
                      CustLedgEntry."Remaining Amt. (LCY)",
                      GenJnlLine,
                      ExistVATEntry,
                      FirstVATEntryNo,
                      LastVATEntryNo,
                      NoRealVATBuffer,
                      FromJnl,
                      "Document No.");

                    TempCurrCode := "Currency Code";
                    "Currency Code" := '';

                    if NoRealVATBuffer.Find('-') then begin
                        repeat
                        begin
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
                        end;
                        until NoRealVATBuffer.Next = 0;
                        NoRealVATBuffer.DeleteAll;
                    end;
                    "Currency Code" := TempCurrCode;
                end;

                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) then
                    CalcBankAccount("No.", "Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible", CustLedgEntry."Entry No.", PostedBillGr."No.")
                else
                    CalcBankAccount("No.", "Remaining Amount", CustLedgEntry."Entry No.", PostedBillGr."No.");

                GroupAmount := GroupAmount + "Remaining Amount";
                CustLedgEntry."Document Status" := CustLedgEntry."Document Status"::Honored;
                CustLedgEntry.Modify;

                if (PostedBillGr."Dealing Type" = PostedBillGr."Dealing Type"::Discount) and
                   (PostedBillGr.Factoring <> PostedBillGr.Factoring::" ")
                then
                    DiscFactLiabs(PostedDoc);
            end;

            trigger OnPostDataItem()
            var
                CustLedgEntry2: Record "Cust. Ledger Entry";
                PostedDoc2: Record "Posted Cartera Doc.";
            begin
                if (DocCount = 0) or (GroupAmount = 0) then begin
                    if DueOnly then
                        Error(
                          Text1100003 +
                          Text1100004);

                    Error(
                      Text1100003 +
                      Text1100005);
                end;
                if BankAccPostBuffer.Find('-') then
                    repeat
                        CustLedgEntry2.Get(BankAccPostBuffer."Entry No.");
                        PostedDoc2.Get(0, CustLedgEntry2."Entry No.");
                        PostedBillGr.Get(PostedDoc2."Bill Gr./Pmt. Order No.");
                        BankAcc.Get(PostedBillGr."Bank Account No.");
                        if PostedBillGr.Factoring = PostedBillGr.Factoring::" " then begin
                            GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                            with GenJnlLine do begin
                                Clear(GenJnlLine);
                                Init;
                                "Line No." := GenJnlLineNextNo;
                                "Posting Date" := PostingDate;
                                "Document Type" := "Document Type"::Payment;
                                "Document No." := PostedBillGr."No.";
                                "Reason Code" := PostedBillGr."Reason Code";
                                if PostedBillGr."Dealing Type" = PostedBillGr."Dealing Type"::Discount then begin
                                    BankAcc.TestField("Bank Acc. Posting Group");
                                    BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
                                    Validate("Account Type", "Account Type"::"G/L Account");
                                    BankAccPostingGr.TestField("Liabs. for Disc. Bills Acc.");
                                    Validate("Account No.", BankAccPostingGr."Liabs. for Disc. Bills Acc.");
                                    Validate("Source Type", "Account Type"::"Bank Account");
                                    Validate("Source No.", BankAcc."No.");
                                end else begin
                                    Validate("Account Type", "Account Type"::"Bank Account");
                                    Validate("Account No.", BankAcc."No.");
                                end;
                                Description := CopyStr(StrSubstNo(Text1100006, PostedBillGr."No."), 1, MaxStrLen(Description));
                                Validate("Currency Code", PostedBillGr."Currency Code");
                                Validate(Amount, BankAccPostBuffer.Amount);
                                "Source Code" := SourceCode;
                                "System-Created Entry" := true;
                                "Shortcut Dimension 1 Code" := BankAccPostBuffer."Global Dimension 1 Code";
                                "Shortcut Dimension 2 Code" := BankAccPostBuffer."Global Dimension 2 Code";
                                "Dimension Set ID" :=
                                  CarteraManagement.GetDimSetIDFromCustLedgEntry(GenJnlLine, CustLedgEntry2, true);


                                Insert;
                                SumLCYAmt := SumLCYAmt + "Amount (LCY)";
                            end;
                        end; // ELSE
                             // FactBankAccounting;
                    until BankAccPostBuffer.Next = 0;

                if PostedBillGr.Factoring <> PostedBillGr.Factoring::" " then
                    FactBankAccounting;

                if PostedBillGr."Currency Code" <> '' then begin
                    if SumLCYAmt <> 0 then begin
                        Currency.SetFilter(Code, PostedBillGr."Currency Code");
                        Currency.FindFirst;
                        if SumLCYAmt > 0 then begin
                            Currency.TestField("Residual Gains Account");
                            Acct := Currency."Residual Gains Account";
                        end else begin
                            Currency.TestField("Residual Losses Account");
                            Acct := Currency."Residual Losses Account";
                        end;
                        GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                        with GenJnlLine do begin
                            Clear(GenJnlLine);
                            Init;
                            "Line No." := GenJnlLineNextNo;
                            "Posting Date" := PostingDate;
                            "Document No." := PostedBillGr."No.";
                            "Reason Code" := PostedBillGr."Reason Code";
                            Validate("Account Type", "Account Type"::"G/L Account");
                            Validate("Account No.", Acct);
                            Description := Text1100007;
                            Validate("Currency Code", '');
                            Validate(Amount, -SumLCYAmt);
                            "Source Code" := SourceCode;
                            "System-Created Entry" := true;
                            "Shortcut Dimension 1 Code" := CustLedgEntry2."Global Dimension 1 Code";
                            "Shortcut Dimension 2 Code" := CustLedgEntry2."Global Dimension 2 Code";
                            "Dimension Set ID" :=
                              CarteraManagement.GetDimSetIDFromCustLedgEntry(GenJnlLine, CustLedgEntry2, true);
                            Insert;
                        end;
                    end;
                end;
                PostedBillGr.Modify;
                DocPost.PostSettlementForPostedBillGroup(GenJnlLine, PostingDate);

                Window.Close;

                if ExistVATEntry then begin
                    GLReg.FindLast;
                    GLReg."From VAT Entry No." := FirstVATEntryNo;
                    GLReg."To VAT Entry No." := LastVATEntryNo;
                    GLReg.Modify;
                end;

                Commit();

                if not HidePrintDialog then
                    Message(Text1100008, DocCount, GroupAmount);
            end;

            trigger OnPreDataItem()
            begin
                DocPost.CheckPostingDate(PostingDate);

                SourceCodeSetup.Get;
                SourceCode := SourceCodeSetup."Cartera Journal";
                DocCount := 0;
                SumLCYAmt := 0;
                GenJnlLineNextNo := 0;
                ExistVATEntry := false;

                Window.Open(
                  Text1100000);
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
                    Caption = 'Options';
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fecha de Registro', Comment = 'Posting Date';
                        NotBlank = true;
                        ToolTip = 'Especifica la fecha de Registro', Comment = 'Specifies the posting date.';
                    }
                    field(DueOnly; DueOnly)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Solo Facturas Vencidas', Comment = 'Due bills only';
                        ToolTip = 'Especifica si desea incluir solo documentos que se han retrasado. Si no importa si un documento está vencido en el momento de la liquidación, deje este campo en blanco.', Comment = 'Specifies if you want to only include documents that have become overdue. If it does not matter if a document is overdue at the time of settlement, leave this field blank.';
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
        PostingDate := WorkDate;
    end;

    trigger OnPreReport()
    begin
        GLSetup.Get;
    end;

    var
        Text1100000: Label 'Liquidando documentos a cobrar        #1######', Comment = 'Settling receivable documents         #1######';
        Text1100001: Label 'Liq. efecto %1/%2', Comment = 'Bill settlement %1/%2';
        Text1100002: Label 'Liq. documento %1', Comment = 'Document settlement %1';
        Text1100003: Label 'No hay documentos a cobrar que liquidar.', Comment = 'No receivable documents have been found that can be settled.';
        Text1100004: Label 'Compruebe que ha seleccionado al menos un documento a cobrar pdte. y vencido.', Comment = 'Please check that the selection is not empty and at least one receivable documents is open and due.';
        Text1100005: Label 'Compruebe que ha seleccionado al menos un documento a cobrar pendiente.', Comment = 'Please check that the selection is not empty and at least one receivable documents is open.';
        Text1100006: Label 'Liquidación remesa %1', Comment = 'Bill Group settlement %1';
        Text1100007: Label 'Ajuste por redondeo', Comment = 'Residual adjust generated by rounding Amount';
        Text1100008: Label 'Se han liquidado %1 documentos a cobrar por un importe de %2.', Comment = '%1 receivable documents totaling %2 have been settled.';
        Text1100009: Label 'Liquida remesa %1 cliente nº %2', Comment = 'Bill Group settlement %1 Customer No. %2';
        Text1100010: Label 'Liq. documento a cobrar %1/%2', Comment = 'Receivable document settlement %1/%2';
        SourceCodeSetup: Record "Source Code Setup";
        PostedBillGr: Record "Posted Bill Group";
        GenJnlLine: Record "Gen. Journal Line" temporary;
        CustLedgEntry: Record "Cust. Ledger Entry";
        BankAccPostingGr: Record "Bank Account Posting Group";
        BankAcc: Record "Bank Account";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        GLReg: Record "G/L Register";
        VATPostingSetup: Record "VAT Posting Setup";
        BankAccPostBuffer: Record "BG/PO Post. Buffer" temporary;
        NoRealVATBuffer: Record "BG/PO Post. Buffer" temporary;
        DocPost: Codeunit "Document-Post";
        CarteraManagement: Codeunit CarteraManagement;
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
        TotalDisctdAmt: Decimal;
        ExistVATEntry: Boolean;
        IsRedrawn: Boolean;
        FirstVATEntryNo: Integer;
        LastVATEntryNo: Integer;
        TempCurrCode: Code[10];
        ExistsNoRealVAT: Boolean;
        HidePrintDialog: Boolean;
        "----FINBITEC": Integer;

    procedure DiscFactLiabs(PostedDoc2: Record "Posted Cartera Doc.")
    var
        DisctedAmt: Decimal;
        Currency2: Record Currency;
        RoundingPrec: Decimal;
    begin
        DisctedAmt := 0;
        GenJnlLineNextNo := GenJnlLineNextNo + 10000;

        if PostedDoc2."Currency Code" <> '' then begin
            Currency2.Get(PostedDoc2."Currency Code");
            RoundingPrec := Currency2."Amount Rounding Precision";
        end else
            RoundingPrec := GLSetup."Amount Rounding Precision";

        DisctedAmt := Round(DocPost.FindDisctdAmt(
              PostedDoc2."Remaining Amount",
              PostedDoc2."Account No.",
              PostedDoc2."Bank Account No."), RoundingPrec);

        CalcBankAccount(PostedDoc2."No.", -DisctedAmt, CustLedgEntry."Entry No.", PostedBillGr."No.");
        TotalDisctdAmt := TotalDisctdAmt + DisctedAmt;

        with GenJnlLine do begin
            Clear(GenJnlLine);
            Init;
            "Line No." := GenJnlLineNextNo;
            "Posting Date" := PostingDate;
            "Document Type" := "Document Type"::Payment;
            "Document No." := PostedBillGr."No.";
            "Reason Code" := PostedBillGr."Reason Code";
            BankAcc.TestField("Bank Acc. Posting Group");
            BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
            Validate("Account Type", "Account Type"::"G/L Account");
            BankAccPostingGr.TestField("Liabs. for Factoring Acc.");
            Validate("Account No.", BankAccPostingGr."Liabs. for Factoring Acc.");
            Description := CopyStr(
                StrSubstNo(Text1100009,
                  PostedBillGr."No.",
                  PostedDoc2."Account No."), 1, MaxStrLen(Description));
            Validate("Currency Code", PostedBillGr."Currency Code");
            Validate(Amount, DisctedAmt);
            "Source Code" := SourceCode;
            "System-Created Entry" := true;
            "Shortcut Dimension 1 Code" := PostedDoc2."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PostedDoc2."Global Dimension 2 Code";
            "Dimension Set ID" := PostedDoc2."Dimension Set ID";
            Insert;
            SumLCYAmt := SumLCYAmt + "Amount (LCY)";
        end;
    end;

    procedure FactBankAccounting()
    var
        CustLedgEntry2: Record "Cust. Ledger Entry";
    begin
        case true of
            PostedDoc."Dealing Type" = PostedDoc."Dealing Type"::Discount:
                begin
                    if BankAccPostBuffer.Find('-') then
                        repeat
                            GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                            CustLedgEntry2.Get(BankAccPostBuffer."Entry No.");
                            with GenJnlLine do begin
                                Clear(GenJnlLine);
                                Init;
                                "Line No." := GenJnlLineNextNo;
                                "Posting Date" := PostingDate;
                                "Document Type" := "Document Type"::Payment;
                                "Document No." := PostedBillGr."No.";
                                "Reason Code" := PostedBillGr."Reason Code";
                                BankAcc.TestField("Bank Acc. Posting Group");
                                BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
                                Validate("Account Type", "Account Type"::"Bank Account");
                                Validate("Account No.", BankAcc."No.");
                                Description := CopyStr(StrSubstNo(Text1100006, PostedBillGr."No."), 1, MaxStrLen(Description));
                                Validate("Currency Code", PostedBillGr."Currency Code");
                                // VALIDATE(Amount,GroupAmount - TotalDisctdAmt);
                                Validate(Amount, BankAccPostBuffer.Amount);
                                "Source Code" := SourceCode;
                                "System-Created Entry" := true;
                                "Shortcut Dimension 1 Code" := BankAccPostBuffer."Global Dimension 1 Code";
                                "Shortcut Dimension 2 Code" := BankAccPostBuffer."Global Dimension 2 Code";
                                "Dimension Set ID" := BankAccPostBuffer."Dimension Set ID";
                                Insert;
                                SumLCYAmt := SumLCYAmt + "Amount (LCY)";
                            end;
                        until BankAccPostBuffer.Next = 0;
                end;
            else begin
                    if BankAccPostBuffer.Find('-') then
                        repeat
                            GenJnlLineNextNo := GenJnlLineNextNo + 10000;
                            CustLedgEntry2.Get(BankAccPostBuffer."Entry No.");
                            with GenJnlLine do begin
                                Clear(GenJnlLine);
                                Init;
                                "Line No." := GenJnlLineNextNo;
                                "Posting Date" := PostingDate;
                                "Document Type" := "Document Type"::Payment;
                                "Document No." := PostedBillGr."No.";
                                "Reason Code" := PostedBillGr."Reason Code";
                                BankAcc.TestField("Bank Acc. Posting Group");
                                BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");
                                Validate("Account Type", "Account Type"::"Bank Account");
                                Validate("Account No.", BankAcc."No.");
                                Description := CopyStr(StrSubstNo(Text1100006, PostedBillGr."No."), 1, MaxStrLen(Description));
                                Validate("Currency Code", PostedBillGr."Currency Code");
                                Validate(Amount, BankAccPostBuffer.Amount);
                                "Source Code" := SourceCode;
                                "System-Created Entry" := true;
                                "Shortcut Dimension 1 Code" := BankAccPostBuffer."Global Dimension 1 Code";
                                "Shortcut Dimension 2 Code" := BankAccPostBuffer."Global Dimension 2 Code";
                                "Dimension Set ID" := BankAccPostBuffer."Dimension Set ID";
                                Insert;
                                SumLCYAmt := SumLCYAmt + "Amount (LCY)";
                            end;
                        until BankAccPostBuffer.Next = 0;
                end;
        end;
    end;

    local procedure InsertGenJournalLine(AccType: Integer; AccNo: Code[20]; Amount2: Decimal; Dep: Code[20]; Proj: Code[20]; DimSetID: Integer)
    begin
        GenJnlLineNextNo := GenJnlLineNextNo + 10000;

        with GenJnlLine do begin
            Clear(GenJnlLine);
            Init;
            "Line No." := GenJnlLineNextNo;
            "Posting Date" := PostingDate;
            "Document Type" := "Document Type"::Payment;
            "Document No." := PostedBillGr."No.";
            "Reason Code" := PostedBillGr."Reason Code";
            "Account Type" := AccType;
            "Account No." := AccNo;
            Description := CopyStr(
                StrSubstNo(Text1100010, PostedDoc."Document No.", PostedDoc."No."),
                1, MaxStrLen(Description));
            Validate("Currency Code", PostedDoc."Currency Code");
            Validate(Amount, -Amount2);
            "Applies-to Doc. Type" := CustLedgEntry."Document Type";
            "Applies-to Doc. No." := '';
            "Applies-to Bill No." := CustLedgEntry."Bill No.";
            "Source Code" := SourceCode;
            "System-Created Entry" := true;
            "Shortcut Dimension 1 Code" := Dep;
            "Shortcut Dimension 2 Code" := Proj;
            "Dimension Set ID" := DimSetID;
            SumLCYAmt := SumLCYAmt + "Amount (LCY)";
            Insert;
        end;
    end;

    procedure CalcBankAccount(BankAcc2: Code[20]; Amount2: Decimal; EntryNo: Integer; NoRemesa: Code[20])
    var

    begin
        //S20/00324 PSL 18/05/2020 BTC

        Clear(BankAccPostBuffer);
        BankAccPostBuffer.SetRange("Account", NoRemesa);
        if BankAccPostBuffer.FindFirst() then begin
            BankAccPostBuffer.Amount := BankAccPostBuffer.Amount + Amount2;
            BankAccPostBuffer.Modify();
        end else begin
            BankAccPostBuffer.Init();
            BankAccPostBuffer.Account := NoRemesa;
            BankAccPostBuffer.Amount := Amount2;
            BankAccPostBuffer."Entry No." := EntryNo;
            BankAccPostBuffer."Global Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
            BankAccPostBuffer."Global Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";
            BankAccPostBuffer.Insert();
        end;
        //FIN S20/00324
    end;

    procedure SetHidePrintDialog(NewHidePrintDialog: Boolean)
    begin
        HidePrintDialog := NewHidePrintDialog;
    end;
}

