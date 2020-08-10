report 50136 "LibroFacturaemitida"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50136.LibroFacturaemitida.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Libro Factura Emitidas';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("<Integer3>"; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(CompanyAddr_7_; CompanyAddr[7])
            {
            }
            column(CompanyAddr_4_; CompanyAddr[4])
            {
            }
            column(CompanyAddr_5_; CompanyAddr[5])
            {
            }
            column(CompanyAddr_6_; CompanyAddr[6])
            {
            }
            column(CompanyAddr_3_; CompanyAddr[3])
            {
            }
            column(CompanyAddr_2_; CompanyAddr[2])
            {
            }
            column(CompanyAddr_1_; CompanyAddr[1])
            {
            }
            column(PrintAmountsInAddCurrency; PrintAmountsInAddCurrency)
            {
            }
            column(ShowAutoInvCred; ShowAutoInvCred)
            {
            }
            column(SortPostDate; SortPostDate)
            {
            }
            column(AuxVatEntry; AuxVatEntry)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(Integer3__Number; Number)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Invoice_BookCaption; Sales_Invoice_BookCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(External_Document_No_Caption; External_Document_No_CaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(VAT_RegistrationCaption; VAT_RegistrationCaptionLbl)
            {
            }
            column(BaseCaption; BaseCaptionLbl)
            {
            }
            column(VAT_Caption; VAT_CaptionLbl)
            {
            }
            column(EC_Caption; EC_CaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Expedition_DateCaption; Expedition_DateCaptionLbl)
            {
            }
            column(gruporegistroIVAnegLbl; gruporegistroIVAnegLbl)
            {
            }
            column(gruporegistroIVAProdLbl; gruporegistroIVAProdLbl) { }
            dataitem(VATEntry; "VAT Entry")
            {
                DataItemTableView = SORTING("No. Series", "Posting Date")
                                    WHERE(Type = CONST(Sale));
                RequestFilterFields = "Posting Date", "Document Type", "Document No.";
                column("Base1"; Base * (-1))
                {
                }
                column(Amount; -Amount)
                {
                }
                column(Base_Amount_; -(Base + Amount))
                {
                }
                column(Additional_Currency_Base_; -"Additional-Currency Base")
                {
                }
                column(Additional_Currency_Amount_; -"Additional-Currency Amount")
                {
                }
                column(Additional_Currency_Base___Additional_Currency_Amount__; -("Additional-Currency Base" + "Additional-Currency Amount"))
                {
                }
                column(Base_Base2; -Base + Base2)
                {
                }
                column(Amount_Amount2; -Amount + Amount2)
                {
                }
                column(Base_Base2____Amount_Amount2_; (-Base + Base2) + (-Amount + Amount2))
                {
                }
                column(Additional_Currency_Base__Base2_____Additional_Currency_Amount__Amount2_; (-"Additional-Currency Base" + Base2) + (-"Additional-Currency Amount" + Amount2))
                {
                }
                column(Additional_Currency_Base__Base2; -"Additional-Currency Base" + Base2)
                {
                }
                column(Additional_Currency_Amount__Amount2; -"Additional-Currency Amount" + Amount2)
                {
                }
                column(VATEntry__No__Series_; "No. Series")
                {
                }
                column(VATEntry__No__Series__Control49; "No. Series")
                {
                }
                column(Additional_Currency_Base__Control74; -"Additional-Currency Base")
                {
                }
                column(Additional_Currency_Amount__Control80; -"Additional-Currency Amount")
                {
                }
                column(Additional_Currency_Base___Additional_Currency_Amount___Control81; -("Additional-Currency Base" + "Additional-Currency Amount"))
                {
                }
                column(Base_Control73; -Base)
                {
                }
                column(Amount_Control75; -Amount)
                {
                }
                column(Base_Amount__Control76; -(Base + Amount))
                {
                }
                column(VATEntry__No__Series__Control79; "No. Series")
                {
                }
                column(Base_Base2_Control50; -Base + Base2)
                {
                }
                column(Amount_Amount2_Control54; -Amount + Amount2)
                {
                }
                column(Base_Base2____Amount_Amount2__Control104; (-Base + Base2) + (-Amount + Amount2))
                {
                }
                column(Additional_Currency_Base__Base2_____Additional_Currency_Amount__Amount2__Control135; (-"Additional-Currency Base" + Base2) + (-"Additional-Currency Amount" + Amount2))
                {
                }
                column(Additional_Currency_Base__Base2_Control137; -"Additional-Currency Base" + Base2)
                {
                }
                column(Additional_Currency_Amount__Amount2_Control138; -"Additional-Currency Amount" + Amount2)
                {
                }
                column(Base_Control61; -Base)
                {
                }
                column(Amount_Control62; -Amount)
                {
                }
                column(Base_Amount__Control63; -(Base + Amount))
                {
                }
                column(Additional_Currency_Base__Control33; -"Additional-Currency Base")
                {
                }
                column(Additional_Currency_Amount__Control34; -"Additional-Currency Amount")
                {
                }
                column(Additional_Currency_Base___Additional_Currency_Amount___Control35; -("Additional-Currency Base" + "Additional-Currency Amount"))
                {
                }
                column(Base_Base2_Control55; -Base + Base2)
                {
                }
                column(Amount_Amount2_Control56; -Amount + Amount2)
                {
                }
                column(Base_Base2____Amount_Amount2__Control57; (-Base + Base2) + (-Amount + Amount2))
                {
                }
                column(Additional_Currency_Base__Base2_Control106; -"Additional-Currency Base" + Base2)
                {
                }
                column(Additional_Currency_Amount__Amount2_Control118; -"Additional-Currency Amount" + Amount2)
                {
                }
                column(Additional_Currency_Base__Base2_____Additional_Currency_Amount__Amount2__Control119; (-"Additional-Currency Base" + Base2) + (-"Additional-Currency Amount" + Amount2))
                {
                }
                column(VATEntry_Entry_No_; "Entry No.")
                {
                }
                column(VATEntry_Type; Type)
                {
                }
                column(VATEntry_Posting_Date; "Posting Date")
                {
                }
                column(VATEntry_Document_Type; "Document Type")
                {
                }
                column(VATEntry_Document_No_; "Document No.")
                {
                }
                column(ContinuedCaption; ContinuedCaptionLbl)
                {
                }
                column(ContinuedCaption_Control28; ContinuedCaption_Control28Lbl)
                {
                }
                column(ContinuedCaption_Control128; ContinuedCaption_Control128Lbl)
                {
                }
                column(ContinuedCaption_Control136; ContinuedCaption_Control136Lbl)
                {
                }
                column(VATEntry__No__Series_Caption; FIELDCAPTION("No. Series"))
                {
                }
                column(VATEntry__No__Series__Control49Caption; FIELDCAPTION("No. Series"))
                {
                }
                column(TotalCaption_Control72; TotalCaption_Control72Lbl)
                {
                }
                column(TotalCaption_Control77; TotalCaption_Control77Lbl)
                {
                }
                column(VATEntry__No__Series__Control79Caption; FIELDCAPTION("No. Series"))
                {
                }
                column(ContinuedCaption_Control105; ContinuedCaption_Control105Lbl)
                {
                }
                column(ContinuedCaption_Control120; ContinuedCaption_Control120Lbl)
                {
                }
                column(ContinuedCaption_Control60; ContinuedCaption_Control60Lbl)
                {
                }
                column(ContinuedCaption_Control32; ContinuedCaption_Control32Lbl)
                {
                }
                column(TotalCaption_Control48; TotalCaption_Control48Lbl)
                {
                }
                column(TotalCaption_Control70; TotalCaption_Control70Lbl)
                {
                }
                column(VATBusPostingGroup; "VAT Bus. Posting Group")
                {
                }
                column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }
                dataitem(VATEntry6; "VAT Entry")
                {
                    DataItemTableView = SORTING(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.")
                                        WHERE(Type = CONST(Purchase));
                    column(VATEntry6_Entry_No_; "Entry No.")
                    {
                    }
                    column(VATEntry6_Type; Type)
                    {
                    }
                    column(VATEntry6_Posting_Date; "Posting Date")
                    {
                    }
                    column(VATEntry6_Document_Type; "Document Type")
                    {
                    }
                    column(VATEntry6_Document_No_; "Document No.")
                    {
                    }
                    dataitem(VATEntry7; "VAT Entry")
                    {
                        DataItemLink = Type = FIELD(Type),
                                       "Posting Date" = FIELD("Posting Date"),
                                       "Document Type" = FIELD("Document Type"),
                                       "Document No." = FIELD("Document No.");
                        DataItemTableView = SORTING(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.");

                        trigger OnAfterGetRecord()
                        begin
                            VATBuffer3."VAT %" := "VAT %";
                            VATBuffer3."EC %" := "EC %";

                            IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                                IF NOT PrintAmountsInAddCurrency THEN
                                    IF VATBuffer3.FIND THEN BEGIN
                                        VATBuffer3.Base := VATBuffer3.Base + Base;
                                        VATBuffer3.Amount := VATBuffer3.Amount + Amount;
                                        VATBuffer3.MODIFY;
                                    END ELSE BEGIN
                                        VATBuffer3.Base := Base;
                                        VATBuffer3.Amount := Amount;
                                        VATBuffer3.INSERT;
                                    END
                                ELSE
                                    IF VATBuffer3.FIND THEN BEGIN
                                        VATBuffer3.Base := VATBuffer3.Base + "Additional-Currency Base";
                                        VATBuffer3.Amount := VATBuffer3.Amount + "Additional-Currency Amount";
                                        VATBuffer3.MODIFY;
                                    END ELSE BEGIN
                                        VATBuffer3.Base := "Additional-Currency Base";
                                        VATBuffer3.Amount := "Additional-Currency Amount";
                                        VATBuffer3.INSERT;
                                    END
                            END;
                        end;

                        trigger OnPostDataItem()
                        begin
                            VATEntry6 := VATEntry7;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CLEAR(PurchCrMemoHeader);
                            CLEAR(PurchInvHeader);
                            CLEAR(Vendor);
                            PurchInvHeader.RESET;
                            PurchCrMemoHeader.RESET;
                            Vendor.RESET;
                            VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                            CASE VATEntry6."Document Type" OF
                                "Document Type"::"Credit Memo":
                                    IF PurchCrMemoHeader.GET(VATEntry6."Document No.") THEN BEGIN
                                        Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                        Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                        VendLedgEntry.SETRANGE("Document No.", VATEntry6."Document No.");
                                        VendLedgEntry.SETRANGE("Document Type", "Document Type"::"Credit Memo");
                                        IF VendLedgEntry.FINDFIRST THEN
                                            AutoDocNo := VendLedgEntry."Autodocument No.";
                                        EXIT;
                                    END;
                                "Document Type"::Invoice:
                                    IF PurchInvHeader.GET(VATEntry6."Document No.") THEN BEGIN
                                        Vendor.Name := PurchInvHeader."Pay-to Name";
                                        Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                        VendLedgEntry.SETRANGE("Document Type", "Document Type"::Invoice);
                                        VendLedgEntry.SETRANGE("Document No.", VATEntry6."Document No.");
                                        IF VendLedgEntry.FINDFIRST THEN
                                            AutoDocNo := VendLedgEntry."Autodocument No.";
                                        EXIT;
                                    END;
                            END;
                            IF NOT Vendor.GET(VATEntry6."Bill-to/Pay-to No.") THEN
                                Vendor.Name := Text1100003;
                            VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                            VendLedgEntry.SETRANGE("Document No.", VATEntry6."Document No.");
                            VendLedgEntry.SETFILTER("Document Type", Text1100004);
                            IF VendLedgEntry.FINDFIRST THEN;
                        end;
                    }
                    dataitem("<Integer4>"; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATBuffer4_Base_VATBuffer4_Amount; VATBuffer4.Base + VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4_Amount; VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4__EC___; VATBuffer4."EC %")
                        {
                        }
                        column(VATBuffer4__VAT___; VATBuffer4."VAT %")
                        {
                        }
                        column(VATBuffer4_Base; VATBuffer4.Base)
                        {
                        }
                        column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                        {
                        }
                        column(CompanyInfo_Name; CompanyInfo.Name)
                        {
                        }
                        column(VATEntry6__Document_No__; VATEntry6."Document No.")
                        {
                        }
                        column(VATEntry6__Posting_Date_; FORMAT(VATEntry6."Posting Date"))
                        {
                        }
                        column(AutoDocNo; AutoDocNo)
                        {
                        }
                        column(DocType; DocType)
                        {
                        }
                        column(FORMAT_VATEntry6__Document_Date__; FORMAT(VATEntry6."Document Date"))
                        {
                        }
                        column(VATBuffer4_Base_VATBuffer4_Amount_Control43; VATBuffer4.Base + VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4_Amount_Control44; VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4__EC____Control45; VATBuffer4."EC %")
                        {
                        }
                        column(VATBuffer4__VAT____Control46; VATBuffer4."VAT %")
                        {
                        }
                        column(VATBuffer4_Base_Control47; VATBuffer4.Base)
                        {
                        }
                        column(Integer4__Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF NOT SortPostDate THEN BEGIN
                                IF VATBuffer4.Amount = 0 THEN BEGIN
                                    VATBuffer4."VAT %" := 0;
                                    VATBuffer4."EC %" := 0;
                                END;
                                Base2 := Base2 + VATBuffer4.Base;
                                Amount2 := Amount2 + VATBuffer4.Amount;
                            END;

                            IF Fin THEN
                                CurrReport.BREAK;
                            VATBuffer4 := VATBuffer3;
                            Fin := VATBuffer3.NEXT = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATBuffer3.FIND('-');
                            Fin := FALSE;
                            LineNo := 0;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT Show THEN
                            CurrReport.BREAK;
                        VATBuffer3.DELETEALL;
                        NoSeriesAuxPrev := NoSeriesAux;

                        IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                            GLSetup.GET;
                            NoSeriesAux := GLSetup."Autocredit Memo Nos.";
                        END;
                        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                            GLSetup.GET;
                            NoSeriesAux := GLSetup."Autoinvoice Nos.";
                        END;

                        IF NoSeriesAux <> NoSeriesAuxPrev THEN BEGIN
                            NotBaseReverse := 0;
                            NotAmountReverse := 0;
                        END;
                    end;

                    trigger OnPostDataItem()
                    begin
                        PrevData := VATEntry."Posting Date" + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT SortPostDate OR NOT ShowAutoInvCred THEN
                            CurrReport.BREAK;
                        SETRANGE("Generated Autodocument", TRUE);
                        IF FIND('-') THEN;
                        IF i = 1 THEN BEGIN
                            REPEAT
                                VatEntryTemporary.INIT;
                                VatEntryTemporary.COPY(VATEntry6);
                                VatEntryTemporary.INSERT;
                                VatEntryTemporary.NEXT;
                            UNTIL NEXT = 0;
                            IF FIND('-') THEN;
                            i := 0;
                        END;
                        SETFILTER("Posting Date", '%1..%2', PrevData, VATEntry."Posting Date");
                        SETFILTER("Document No.", VATEntry.GETFILTER("Document No."));
                        SETFILTER("Document Type", VATEntry.GETFILTER("Document Type"));
                        IF VatEntryTemporary.FIND('-') THEN;
                        VatEntryTemporary.SETRANGE("Generated Autodocument", TRUE);
                        VatEntryTemporary.SETFILTER("Posting Date", '%1..%2', PrevData, VATEntry."Posting Date");
                        IF VatEntryTemporary.FIND('-') THEN BEGIN
                            Show := TRUE;
                            VatEntryTemporary.DELETEALL;
                        END ELSE
                            Show := FALSE;
                    end;
                }
                dataitem(VATEntry2; "VAT Entry")
                {
                    DataItemLink = Type = FIELD(Type),
                                   "Posting Date" = FIELD("Posting Date"),
                                   "Document Type" = FIELD("Document Type"),
                                   "Document No." = FIELD("Document No.");
                    DataItemTableView = SORTING("No. Series", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                            VATBuffer."VAT %" := 0;
                            VATBuffer."EC %" := 0;
                        END ELSE BEGIN
                            VATBuffer."VAT %" := "VAT %";
                            VATBuffer."EC %" := "EC %";
                        END;
                        IF NOT PrintAmountsInAddCurrency THEN BEGIN
                            IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN
                                Base := 0;
                            IF VATBuffer.FIND THEN BEGIN
                                VATBuffer.Base := VATBuffer.Base - Base;
                                VATBuffer.Amount := VATBuffer.Amount - Amount;
                                VATBuffer.MODIFY;
                            END ELSE BEGIN
                                VATBuffer.Base := -Base;
                                VATBuffer.Amount := -Amount;
                                VATBuffer.INSERT;
                            END;
                        END ELSE BEGIN
                            IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN
                                "Additional-Currency Base" := 0;
                            IF VATBuffer.FIND THEN BEGIN
                                VATBuffer.Base := VATBuffer.Base - "Additional-Currency Base";
                                VATBuffer.Amount := VATBuffer.Amount - "Additional-Currency Amount";
                                VATBuffer.MODIFY;
                            END ELSE BEGIN
                                VATBuffer.Base := -"Additional-Currency Base";
                                VATBuffer.Amount := -"Additional-Currency Amount";
                                VATBuffer.INSERT;
                            END;
                        END;
                        TempVATEntry := VATEntry2;
                        IF NOT TempVATEntry.FIND THEN
                            TempVATEntry.INSERT;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF SortPostDate THEN
                            SETCURRENTKEY(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.")
                        ELSE
                            SETCURRENTKEY("No. Series", "Posting Date");

                        SETRANGE("No. Series", VATEntry."No. Series");
                        CLEAR(SalesCrMemoHeader);
                        CLEAR(SalesInvHeader);
                        CLEAR(Customer);

                        IF NOT PrintAmountsInAddCurrency THEN
                            GLSetup.GET
                        ELSE BEGIN
                            GLSetup.GET;
                            Currency.GET(GLSetup."Additional Reporting Currency");
                        END;

                        CASE VATEntry."Document Type" OF
                            "Document Type"::"Credit Memo":
                                BEGIN
                                    IF SalesCrMemoHeader.GET(VATEntry."Document No.") THEN BEGIN
                                        Customer.Name := SalesCrMemoHeader."Bill-to Name";
                                        Customer."VAT Registration No." := SalesCrMemoHeader."VAT Registration No.";
                                        EXIT;
                                    END;
                                    IF ServiceCrMemoHeader.GET(VATEntry."Document No.") THEN BEGIN
                                        Customer.Name := ServiceCrMemoHeader."Bill-to Name";
                                        Customer."VAT Registration No." := ServiceCrMemoHeader."VAT Registration No.";
                                        EXIT;
                                    END;
                                END;
                            "Document Type"::Invoice:
                                BEGIN
                                    IF SalesInvHeader.GET(VATEntry."Document No.") THEN BEGIN
                                        Customer.Name := SalesInvHeader."Bill-to Name";
                                        Customer."VAT Registration No." := SalesInvHeader."VAT Registration No.";
                                        EXIT;
                                    END;
                                    IF ServiceInvHeader.GET(VATEntry."Document No.") THEN BEGIN
                                        Customer.Name := ServiceInvHeader."Bill-to Name";
                                        Customer."VAT Registration No." := ServiceInvHeader."VAT Registration No.";
                                        EXIT;
                                    END;
                                END;
                        END;

                        IF NOT Customer.GET(VATEntry."Bill-to/Pay-to No.") THEN
                            Customer.Name := Text1100003;
                    end;
                }
                dataitem(DataItem5444; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(VATEntry2__Document_No__; VATEntry2."Document No.")
                    {
                    }
                    column(VATBuffer2_Base; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2_Amount; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2__VAT___; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2__EC___; VATBuffer2."EC %")
                    {
                    }
                    column(VATEntry2__Posting_Date_; FORMAT(VATEntry2."Posting Date"))
                    {
                    }
                    column(Customer_Name; Customer.Name)
                    {
                    }
                    column(Customer__VAT_Registration_No__; Customer."VAT Registration No.")
                    {
                    }
                    column(DocType_Control25; DocType)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(FORMAT_VATEntry2__Document_Date__; FORMAT(VATEntry2."Document Date"))
                    {
                    }
                    column(VATBuffer2_Base_Control13; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2__VAT____Control15; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2__EC____Control16; VATBuffer2."EC %")
                    {
                    }
                    column(VATBuffer2_Amount_Control14; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control12; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_Control17; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2_Amount_Control18; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control23; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(Integer_Number; Number)
                    {
                    }
                    column(TotalCaption_Control26; TotalCaption_Control26Lbl)
                    {
                    }
                    column(VATEntry2_External_Document_No__; VATEntry2."External Document No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Fin THEN
                            CurrReport.BREAK;
                        VATBuffer2 := VATBuffer;
                        Fin := VATBuffer.NEXT = 0;
                        LineNo := LineNo + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATBuffer.FIND('-');
                        Fin := FALSE;
                        LineNo := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    VATBuffer.DELETEALL;
                    TempVATEntry := VATEntry;
                    IF TempVATEntry.FIND THEN
                        CurrReport.SKIP;

                    DocType := FORMAT("Document Type");
                    IF "Document Type" = "Document Type"::"Credit Memo" THEN
                        DocType := Text1100005;
                end;

                trigger OnPreDataItem()
                begin
                    IF GETFILTER("Posting Date") = '' THEN
                        PrevData := 0D
                    ELSE
                        PrevData := GETRANGEMIN("Posting Date");
                    i := 1;
                    IF SortPostDate THEN
                        SETCURRENTKEY(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.")
                    ELSE
                        SETCURRENTKEY("No. Series", "Posting Date", "Document No.");
                    TempVATEntry.RESET;
                    TempVATEntry.DELETEALL;
                end;
            }
            dataitem(VATEntry4; "VAT Entry")
            {
                DataItemTableView = SORTING("Document Type", "No. Series", "Posting Date")
                                    WHERE(Type = CONST(Purchase));
                column(VarNotBaseReverse; VarNotBaseReverse)
                {
                }
                column(VarNotAmountReverse; VarNotAmountReverse)
                {
                }
                column(VarNotBaseReverse_VarNotAmountReverse; VarNotBaseReverse + VarNotAmountReverse)
                {
                }
                column(No_SeriesAux_; NoSeriesAux)
                {
                }
                column(No_SeriesAux__Control101; NoSeriesAux)
                {
                }
                column(NotBaseReverse; NotBaseReverse)
                {
                }
                column(NotAmountReverse; NotAmountReverse)
                {
                }
                column(NotBaseReverse_NotAmountReverse; NotBaseReverse + NotAmountReverse)
                {
                }
                column(VarNotBaseReverse_Control108; VarNotBaseReverse)
                {
                }
                column(VarNotAmountReverse_Control110; VarNotAmountReverse)
                {
                }
                column(VarNotBaseReverse_VarNotAmountReverse_Control112; VarNotBaseReverse + VarNotAmountReverse)
                {
                }
                column(VATEntry4_Entry_No_; "Entry No.")
                {
                }
                column(VATEntry4_Document_Type; "Document Type")
                {
                }
                column(VATEntry4_Type; Type)
                {
                }
                column(VATEntry4_Posting_Date; "Posting Date")
                {
                }
                column(VATEntry4_Document_No_; "Document No.")
                {
                }
                column(ContinuedCaption_Control129; ContinuedCaption_Control129Lbl)
                {
                }
                column(No_SerieCaption; No_SerieCaptionLbl)
                {
                }
                column(TotalCaption_Control99; TotalCaption_Control99Lbl)
                {
                }
                column(No_SerieCaption_Control100; No_SerieCaption_Control100Lbl)
                {
                }
                column(ContinuedCaption_Control117; ContinuedCaption_Control117Lbl)
                {
                }
                dataitem(VATEntry5; "VAT Entry")
                {
                    DataItemLink = Type = FIELD(Type),
                                   "Posting Date" = FIELD("Posting Date"),
                                   "Document Type" = FIELD("Document Type"),
                                   "Document No." = FIELD("Document No.");
                    DataItemTableView = SORTING("No. Series", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        VATBuffer."VAT %" := "VAT %";
                        VATBuffer."EC %" := "EC %";

                        IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                            IF NOT PrintAmountsInAddCurrency THEN
                                IF VATBuffer.FIND THEN BEGIN
                                    VarBase2 := (VATBuffer.Base + Base) - VATBuffer.Base;
                                    VarAmount2 := (VATBuffer.Amount + Amount) - VATBuffer.Amount;
                                    VATBuffer.Base := VATBuffer.Base + Base;
                                    VATBuffer.Amount := VATBuffer.Amount + Amount;
                                    VATBuffer.MODIFY;
                                END ELSE BEGIN
                                    VarBase2 := Base;
                                    VarAmount2 := Amount;
                                    VATBuffer.Base := Base;
                                    VATBuffer.Amount := Amount;
                                    VATBuffer.INSERT;
                                END
                            ELSE
                                IF VATBuffer.FIND THEN BEGIN
                                    VATBuffer.Base := VATBuffer.Base + "Additional-Currency Base";
                                    VATBuffer.Amount := VATBuffer.Amount + "Additional-Currency Amount";
                                    VATBuffer.MODIFY;
                                END ELSE BEGIN
                                    VATBuffer.Base := "Additional-Currency Base";
                                    VATBuffer.Amount := "Additional-Currency Amount";
                                    VATBuffer.INSERT;
                                END
                        END;
                        IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                            IF NOT PrintAmountsInAddCurrency THEN BEGIN
                                NotBaseReverse := NotBaseReverse + VarBase2;
                                NotAmountReverse := NotAmountReverse + VarAmount2;
                            END ELSE BEGIN
                                NotBaseReverse := NotBaseReverse + VATBuffer.Base;
                                NotAmountReverse := NotAmountReverse + VATBuffer.Amount;
                            END;
                        END;
                    end;

                    trigger OnPostDataItem()
                    begin
                        VATEntry4 := VATEntry5;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CLEAR(PurchCrMemoHeader);
                        CLEAR(PurchInvHeader);
                        CLEAR(Vendor);
                        PurchInvHeader.RESET;
                        PurchCrMemoHeader.RESET;
                        Vendor.RESET;

                        VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                        CASE VATEntry4."Document Type" OF
                            "Document Type"::"Credit Memo":
                                IF PurchCrMemoHeader.GET(VATEntry4."Document No.") THEN BEGIN
                                    Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                    VendLedgEntry.SETRANGE("Document No.", VATEntry4."Document No.");
                                    VendLedgEntry.SETRANGE("Document Type", "Document Type"::"Credit Memo");
                                    IF VendLedgEntry.FINDFIRST THEN
                                        AutoDocNo := VendLedgEntry."Autodocument No.";
                                    EXIT;
                                END;
                            "Document Type"::Invoice:
                                IF PurchInvHeader.GET(VATEntry4."Document No.") THEN BEGIN
                                    Vendor.Name := PurchInvHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                    VendLedgEntry.SETRANGE("Document No.", VATEntry4."Document No.");
                                    VendLedgEntry.SETRANGE("Document Type", "Document Type"::Invoice);
                                    IF VendLedgEntry.FINDFIRST THEN
                                        AutoDocNo := VendLedgEntry."Autodocument No.";
                                    EXIT;
                                END;
                        END;

                        IF NOT Vendor.GET(VATEntry4."Bill-to/Pay-to No.") THEN
                            Vendor.Name := Text1100003;
                        VendLedgEntry.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                        VendLedgEntry.SETRANGE("Document No.", VATEntry4."Document No.");
                        VendLedgEntry.SETFILTER("Document Type", Text1100004);
                        IF VendLedgEntry.FINDFIRST THEN;
                    end;
                }
                dataitem("<Integer2>"; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control82; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Amount_Control83; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2__EC____Control84; VATBuffer2."EC %")
                    {
                    }
                    column(VATBuffer2__VAT____Control85; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2_Base_Control86; VATBuffer2.Base)
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No___Control87; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfo_Name_Control88; CompanyInfo.Name)
                    {
                    }
                    column(VATEntry4__Posting_Date_; FORMAT(VATEntry4."Posting Date"))
                    {
                    }
                    column(AutoDocNo_Control91; AutoDocNo)
                    {
                    }
                    column(VATEntry4__Document_Type_; VATEntry4."Document Type")
                    {
                    }
                    column(VATEntry4__Document_No__; VATEntry4."Document No.")
                    {
                    }
                    column(FORMAT_VATEntry4__Document_Date__; FORMAT(VATEntry4."Document Date"))
                    {
                    }
                    column(VATBuffer2_Base_Control93; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2__VAT____Control94; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2__EC____Control95; VATBuffer2."EC %")
                    {
                    }
                    column(VATBuffer2_Amount_Control96; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control97; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_Control114; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2_Amount_Control115; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control116; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(Integer2__Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Fin THEN
                            CurrReport.BREAK;
                        VATBuffer2 := VATBuffer;
                        Fin := VATBuffer.NEXT = 0;
                        IF VATBuffer2.Amount = 0 THEN BEGIN
                            VATBuffer2."VAT %" := 0;
                            VATBuffer2."EC %" := 0;
                        END;

                        LineNo := LineNo + 1;
                        VarNotBaseReverse := VarNotBaseReverse + VATBuffer2.Base;
                        VarNotAmountReverse := VarNotAmountReverse + VATBuffer2.Amount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATBuffer.FIND('-');
                        Fin := FALSE;
                        LineNo := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    VATBuffer.DELETEALL;
                    NoSeriesAuxPrev := NoSeriesAux;

                    IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                        GLSetup.GET;
                        NoSeriesAux := GLSetup."Autocredit Memo Nos.";
                    END;
                    IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                        GLSetup.GET;
                        NoSeriesAux := GLSetup."Autoinvoice Nos.";
                    END;

                    IF NoSeriesAux <> NoSeriesAuxPrev THEN BEGIN
                        NotBaseReverse := 0;
                        NotAmountReverse := 0;
                        VarNotBaseReverse := 0;
                        VarNotAmountReverse := 0;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    IF NOT ShowAutoInvCred THEN
                        CurrReport.BREAK;
                    SETRANGE("Generated Autodocument", TRUE);
                    IF FIND('-') THEN;
                    SETFILTER("Posting Date", VATEntry.GETFILTER("Posting Date"));
                    SETFILTER("Document No.", VATEntry.GETFILTER("Document No."));
                    SETFILTER("Document Type", VATEntry.GETFILTER("Document Type"));
                end;
            }
            dataitem(DataItem1100011; "No Taxable Entry")
            {
                DataItemTableView = SORTING("Entry No.")
                                    WHERE(Type = CONST(Sale),
                                          Reversed = CONST(false));
                column(PostingDate_NoTaxableEntry; FORMAT("Posting Date"))
                {
                }
                column(DocumentNo_NoTaxableEntry; "Document No.")
                {
                }
                column(DocumentType_NoTaxableEntry; "Document Type")
                {
                }
                column(Type_NoTaxableEntry; Type)
                {
                }
                column(Base_NoTaxableEntry; NoTaxableAmount)
                {
                }
                column(SourceNo_NoTaxableEntry; "Source No.")
                {
                }
                column(SourceName_NoTaxableEntry; Customer.Name)
                {
                }
                column(ExternalDocumentNo_NoTaxableEntry; "External Document No.")
                {
                }
                column(NoSeriesCaption_NoTaxableEntry; FIELDCAPTION("No. Series"))
                {
                }
                column(NoSeries_NoTaxableEntry; "No. Series")
                {
                }
                column(DocumentDate_NoTaxableEntry; "Document Date")
                {
                }
                column(DocumentDateFormat_NoTaxableEntry; FORMAT("Document Date"))
                {
                }
                column(VATRegistrationNo_NoTaxableEntry; "VAT Registration No.")
                {
                }
                column(NoTaxableTitleText; NoTaxableText)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    IF NOT Customer.GET("Source No.") THEN
                        Customer.Name := Text1100003;
                    IF PrintAmountsInAddCurrency THEN
                        NoTaxableAmount := -"Base (ACY)"
                    ELSE
                        NoTaxableAmount := -"Base (LCY)";
                    IF NoTaxablePrinted THEN
                        NoTaxableText := '';
                    NoTaxablePrinted := TRUE;
                end;

                trigger OnPreDataItem()
                begin
                    IF SortPostDate THEN
                        SETCURRENTKEY(Type, "Posting Date", "Document Type", "Document No.", "Source No.")
                    ELSE
                        SETCURRENTKEY("No. Series", "Posting Date", "Document No.");
                    SETFILTER("Posting Date", VATEntry.GETFILTER("Posting Date"));
                    NoTaxableText := NoTaxableVATTxt;

                    if noMostrarNoTaxable then
                        CurrReport.Break();
                end;
            }

            trigger OnPreDataItem()
            begin
                GLSetup.GET;
                IF PrintAmountsInAddCurrency THEN
                    HeaderText := STRSUBSTNO(Text1100002, GLSetup."Additional Reporting Currency")
                ELSE BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    HeaderText := STRSUBSTNO(Text1100002, GLSetup."LCY Code");
                END;

                CompanyInfo.GET;
                CompanyAddr[1] := CompanyInfo.Name;
                CompanyAddr[2] := CompanyInfo."Name 2";
                CompanyAddr[3] := CompanyInfo.Address;
                CompanyAddr[4] := CompanyInfo."Address 2";
                CompanyAddr[5] := CompanyInfo.City;
                CompanyAddr[6] := CompanyInfo."Post Code" + ' ' + CompanyInfo.County;
                IF CompanyInfo."VAT Registration No." <> '' THEN
                    CompanyAddr[7] := Text1100000 + CompanyInfo."VAT Registration No."
                ELSE
                    ERROR(Text1100001);
                COMPRESSARRAY(CompanyAddr);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESP="Opciones"';
                    field(PrintAmountsInAddCurrency; PrintAmountsInAddCurrency)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Amounts in Add. Currency', Comment = 'ESP="Mostrar importes en divisa adicional"';
                        ToolTip = 'Specifies if amounts in the additional currency are included.', Comment = 'ESP="Especifica si se muestran los importes en divisa adicional"';
                    }
                    field(SortPostDate; SortPostDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Order by posting date', Comment = 'ESP="Ordenar por fecha registro"';
                        ToolTip = 'Specifies that the entries are sorted by posting date.', Comment = 'ESP="Especifica que los movimientos se ordenarán por fecha registro"';
                    }
                    field(ShowAutoInvoicesAutoCrMemo; ShowAutoInvCred)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Autoinvoices/Autocr. memo', Comment = 'ESP="Mostrar Autofacturas/Autoabonos"';
                        ToolTip = 'Specifies if the view includes invoices and credit memos that are created automatically.', Comment = 'ESP=""';
                    }
                    field(noMostrarNoTaxable; noMostrarNoTaxable)
                    {
                        ApplicationArea = All;
                        Caption = 'Do not show exemptions', comment = 'ESP="No mostrar exentas"';
                        ToolTip = 'Do not show VAT exempt movements', comment = 'ESP="No mostrar movimientos exentos de IVA"';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ShowAutoInvCred := FALSE;
            noMostrarNoTaxable := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        AuxVatEntry := VATEntry.GETFILTERS;
    end;

    var
        noMostrarNoTaxable: Boolean;
        Text1100000: Label 'VAT Registration No.: ';
        Text1100001: Label 'Specify the VAT registration number of your company in the Company information window.';
        Text1100002: Label 'All amounts are in %1.', Comment = '%1 - currency code';
        Text1100003: Label 'UNKNOWN';
        Text1100004: Label 'Invoice|Credit Memo';
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Customer: Record "customer";
        CompanyInfo: Record "Company Information";
        VATBuffer: Record "Sales/Purch. Book VAT Buffer" temporary;
        VATBuffer2: Record "Sales/Purch. Book VAT Buffer";
        VATBuffer3: Record "Sales/Purch. Book VAT Buffer" temporary;
        VATBuffer4: Record "Sales/Purch. Book VAT Buffer" temporary;
        GLSetup: Record "General Ledger Setup";
        Currency: Record "Currency";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record "Vendor";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VatEntryTemporary: Record "VAT Entry" temporary;
        HeaderText: Text[250];
        CompanyAddr: array[7] of Text[100];
        LineNo: Decimal;
        Fin: Boolean;
        PrintAmountsInAddCurrency: Boolean;
        NoSeriesAux: Code[20];
        AutoDocNo: Code[20];
        NotBaseReverse: Decimal;
        NotAmountReverse: Decimal;
        NoSeriesAuxPrev: Code[20];
        AuxVatEntry: Text[250];
        PrevData: Date;
        SortPostDate: Boolean;
        Show: Boolean;
        i: Integer;
        ShowAutoInvCred: Boolean;
        Base2: Decimal;
        Amount2: Decimal;
        VarBase2: Decimal;
        VarAmount2: Decimal;
        VarNotBaseReverse: Decimal;
        VarNotAmountReverse: Decimal;
        DocType: Text[30];
        Text1100005: Label 'Corrective Invoice';
        ServiceInvHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Sales_Invoice_BookCaptionLbl: Label 'Sales Invoice Book';
        Document_No_CaptionLbl: Label 'Document No.';
        Posting_DateCaptionLbl: Label 'Posting Date';
        External_Document_No_CaptionLbl: Label 'External Document No.';
        NameCaptionLbl: Label 'Name';
        VAT_RegistrationCaptionLbl: Label 'VAT Registration';
        BaseCaptionLbl: Label 'Base';
        VAT_CaptionLbl: Label 'VAT%';
        EC_CaptionLbl: Label 'EC%';
        AmountCaptionLbl: Label 'Amount';
        TotalCaptionLbl: Label 'Total';
        Expedition_DateCaptionLbl: Label 'Expedition Date';
        ContinuedCaptionLbl: Label 'Continued';
        ContinuedCaption_Control28Lbl: Label 'Continued';
        ContinuedCaption_Control128Lbl: Label 'Continued';
        ContinuedCaption_Control136Lbl: Label 'Continued';
        TotalCaption_Control72Lbl: Label 'Total';
        TotalCaption_Control77Lbl: Label 'Total';
        ContinuedCaption_Control105Lbl: Label 'Continued';
        ContinuedCaption_Control120Lbl: Label 'Continued';
        ContinuedCaption_Control60Lbl: Label 'Continued';
        ContinuedCaption_Control32Lbl: Label 'Continued';
        TotalCaption_Control48Lbl: Label 'Total';
        TotalCaption_Control70Lbl: Label 'Total';
        TotalCaption_Control26Lbl: Label 'Total';
        ContinuedCaption_Control129Lbl: Label 'Continued';
        No_SerieCaptionLbl: Label 'No. Series';
        TotalCaption_Control99Lbl: Label 'Total';
        No_SerieCaption_Control100Lbl: Label 'No. Series';
        ContinuedCaption_Control117Lbl: Label 'Continued';
        TempVATEntry: Record "VAT Entry" temporary;
        NoTaxableAmount: Decimal;
        NoTaxableVATTxt: Label 'No Taxable VAT';
        NoTaxableText: Text;
        NoTaxablePrinted: Boolean;
        gruporegistroIVAnegLbl: Label 'grupo registro IVA neg ';
        gruporegistroIVAProdLbl: Label 'grupo registro IVA Producto ';
}

