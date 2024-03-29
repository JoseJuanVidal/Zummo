report 50137 "Libro facturas recibidas"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/Rep50137.Librofacturasrecibidas.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Purchases Invoice Book (VAT Rec.)', Comment = 'ESP="Libro facturas recibidas (Iva Rec.)"';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("<Integer3>"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(USERID; UserId)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
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
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(SortPostDate; SortPostDate)
            {
            }
            column(PrintAmountsInAddCurrency; PrintAmountsInAddCurrency)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(AuxVatEntry; AuxVatEntry)
            {
            }
            column(Integer3__Number; Number)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Purchases_Invoice_BookCaption; Purchases_Invoice_BookCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(EC_Caption; EC_CaptionLbl)
            {
            }
            column(VAT_Caption; VAT_CaptionLbl)
            {
            }
            column(BaseCaption; BaseCaptionLbl)
            {
            }
            column(VAT_RegistrationCaption; VAT_RegistrationCaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(External_Document_No_Caption; External_Document_No_CaptionLbl)
            {
            }
            column(Posting_DateCaption; Posting_DateCaptionLbl)
            {
            }
            column(Document_DateCaption; Document_DateCaptionLbl)
            {
            }
            column(Document_No_Caption; Document_No_CaptionLbl)
            {
            }
            column(Epedition_DateCaption; Epedition_DateCaptionLbl)
            {
            }
            column(gruporegistroIVAnegLbl; gruporegistroIVAnegLbl)
            {
            }
            column(gruporegistroIVAProdLbl; gruporegistroIVAProdLbl) { }
            dataitem(VATEntry; "VAT Entry")
            {
                DataItemTableView = SORTING("No. Series", "Posting Date") WHERE(Type = CONST(Purchase));
                RequestFilterFields = "Posting Date", "Document Date", "Document Type", "Document No.";
                column(Base_TotalBaseImport; Base - TotalBaseImport)
                {
                }
                column(AmountVatReverse3; AmountVatReverse3)
                {
                }
                column(Base_AmountVatReverse3; Base + AmountVatReverse3)
                {
                }
                column(Additional_Currency_Base__TotalBaseImport; "Additional-Currency Base" - TotalBaseImport)
                {
                }
                column(AmountVatReverse3_Control30; AmountVatReverse3)
                {
                }
                column(Additional_Currency_Base__AmountVatReverse3; "Additional-Currency Base" + AmountVatReverse3)
                {
                }
                column(Base_Base2__TotalBaseImport; (Base + Base2) - TotalBaseImport)
                {
                }
                column(AmountVatReverse3_Amount2; AmountVatReverse3 + Amount2)
                {
                }
                column(Base_Base2___AmountVatReverse3_Amount2_; (Base + Base2) + (AmountVatReverse3 + Amount2))
                {
                }
                column(Additional_Currency_Base__Base2__TotalBaseImport; ("Additional-Currency Base" + Base2) - TotalBaseImport)
                {
                }
                column(AmountVatReverse3___Amount2; AmountVatReverse3 + Amount2)
                {
                }
                column(Additional_Currency_Base__Base2___AmountVatReverse3_Amount2_; ("Additional-Currency Base" + Base2) + (AmountVatReverse3 + Amount2))
                {
                }
                column(VATEntry__No__Series_; "No. Series")
                {
                }
                column(Base_AmountVatReverse; Base + AmountVatReverse)
                {
                }
                column(AmountVatReverse; AmountVatReverse)
                {
                }
                column(Base_TotalBaseImport_Control74; Base - TotalBaseImport)
                {
                }
                column(VATEntry__No__Series__Control75; "No. Series")
                {
                }
                column(VATEntry__No__Series__Control80; "No. Series")
                {
                }
                column(Additional_Currency_Base__TotalBaseImport_Control84; "Additional-Currency Base" - TotalBaseImport)
                {
                }
                column(AmountVatReverse_Control85; AmountVatReverse)
                {
                }
                column(Additional_Currency_Base__AmountVatReverse; "Additional-Currency Base" + AmountVatReverse)
                {
                }
                column(Base_TotalBaseImport_Control23; Base - TotalBaseImport)
                {
                }
                column(AmountVatReverse3_Control40; AmountVatReverse3)
                {
                }
                column(Base_AmountVatReverse3_Control65; Base + AmountVatReverse3)
                {
                }
                column(Additional_Currency_Base__TotalBaseImport_Control33; "Additional-Currency Base" - TotalBaseImport)
                {
                }
                column(AmountVatReverse3_Control34; AmountVatReverse3)
                {
                }
                column(Additional_Currency_Base__AmountVatReverse3_Control35; "Additional-Currency Base" + AmountVatReverse3)
                {
                }
                column(Base_Base2__TotalBaseImport_Control131; (Base + Base2) - TotalBaseImport)
                {
                }
                column(AmountVatReverse3_Amount2_Control132; AmountVatReverse3 + Amount2)
                {
                }
                column(Base_Base2___AmountVatReverse3_Amount2__Control133; (Base + Base2) + (AmountVatReverse3 + Amount2))
                {
                }
                column(Additional_Currency_Base__TotalBaseImport_Control135; "Additional-Currency Base" - TotalBaseImport)
                {
                }
                column(AmountVatReverse3_Control136; AmountVatReverse3)
                {
                }
                column(Additional_Currency_Base__AmountVatReverse3_Control137; "Additional-Currency Base" + AmountVatReverse3)
                {
                }
                column(Base_Base2__TotalBaseImport_Control57; (Base + Base2) - TotalBaseImport)
                {
                }
                column(AmountVatReverse_Amount2; AmountVatReverse + Amount2)
                {
                }
                column(Base_Base2___AmountVatReverse_Amount2_; (Base + Base2) + (AmountVatReverse + Amount2))
                {
                }
                column(Additional_Currency_Base__Base2__TotalBaseImport_Control124; ("Additional-Currency Base" + Base2) - TotalBaseImport)
                {
                }
                column(AmountVatReverse___Amount2; AmountVatReverse + Amount2)
                {
                }
                column(Additional_Currency_Base__Base2___AmountVatReverse_Amount2_; ("Additional-Currency Base" + Base2) + (AmountVatReverse + Amount2))
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
                column(ContinuedCaption_Control48; ContinuedCaption_Control48Lbl)
                {
                }
                column(ContinuedCaption_Control49; ContinuedCaption_Control49Lbl)
                {
                }
                column(VATEntry__No__Series_Caption; FieldCaption("No. Series"))
                {
                }
                column(VATEntry__No__Series__Control75Caption; FieldCaption("No. Series"))
                {
                }
                column(TotalCaption_Control77; TotalCaption_Control77Lbl)
                {
                }
                column(TotalCaption_Control78; TotalCaption_Control78Lbl)
                {
                }
                column(VATEntry__No__Series__Control80Caption; FieldCaption("No. Series"))
                {
                }
                column(ContinuedCaption_Control18; ContinuedCaption_Control18Lbl)
                {
                }
                column(ContinuedCaption_Control32; ContinuedCaption_Control32Lbl)
                {
                }
                column(ContinuedCaption_Control130; ContinuedCaption_Control130Lbl)
                {
                }
                column(ContinuedCaption_Control134; ContinuedCaption_Control134Lbl)
                {
                }
                column(TotalCaption_Control54; TotalCaption_Control54Lbl)
                {
                }
                column(TotalCaption_Control127; TotalCaption_Control127Lbl)
                {
                }
                column(VATBusPostingGroup; "VAT Bus. Posting Group")
                {
                }
                column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group")
                {
                }
                dataitem(VATEntry6; "VAT Entry")
                {
                    DataItemTableView = SORTING(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.") WHERE(Type = CONST(Purchase));
                    column(VATEntry6_Entry_No_; "Entry No.")
                    {
                    }
                    column(VATEntry6_Type; Type)
                    {
                    }
                    column(VATEntry6_Posting_Date; "Posting Date")
                    {
                    }
                    column(VATEntry6_Document_Date; "Document Date")
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
                        DataItemLink = Type = FIELD(Type), "Posting Date" = FIELD("Posting Date"), "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No.");
                        DataItemTableView = SORTING(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.");

                        trigger OnAfterGetRecord()
                        begin
                            VATBuffer3."VAT %" := "VAT %";
                            VATBuffer3."EC %" := "EC %";
                            if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then begin
                                if not PrintAmountsInAddCurrency then
                                    if VATBuffer3.Find then begin
                                        VATBuffer3.Base := VATBuffer3.Base + Base;
                                        VATBuffer3.Amount := VATBuffer3.Amount + Amount;
                                        VATBuffer3.Modify;
                                    end else begin
                                        VATBuffer3.Base := Base;
                                        VATBuffer3.Amount := Amount;
                                        VATBuffer3.Insert;
                                    end
                                else
                                    if VATBuffer3.Find then begin
                                        VATBuffer3.Base := VATBuffer3.Base + "Additional-Currency Base";
                                        VATBuffer3.Amount := VATBuffer3.Amount + "Additional-Currency Amount";
                                        VATBuffer3.Modify;
                                    end else begin
                                        VATBuffer3.Base := "Additional-Currency Base";
                                        VATBuffer3.Amount := "Additional-Currency Amount";
                                        VATBuffer3.Insert;
                                    end
                            end;
                            if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then begin
                                NotBaseReverse := NotBaseReverse + VATBuffer3.Base;
                                NotAmountReverse := NotAmountReverse + VATBuffer3.Amount;
                            end;
                        end;

                        trigger OnPostDataItem()
                        begin
                            VATEntry6 := VATEntry7;
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(PurchCrMemoHeader);
                            Clear(PurchInvHeader);
                            Clear(Vendor);
                            PurchInvHeader.Reset;
                            PurchCrMemoHeader.Reset;
                            Vendor.Reset;
                            VendLedgEntry.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                            case VATEntry6."Document Type" of
                                "Document Type"::"Credit Memo":
                                    if PurchCrMemoHeader.Get(VATEntry6."Document No.") then begin
                                        Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                        Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                        VendLedgEntry.SetRange("Document No.", VATEntry6."Document No.");
                                        VendLedgEntry.SetRange("Document Type", "Document Type"::"Credit Memo");
                                        if VendLedgEntry.FindFirst then
                                            AutoDocNo := VendLedgEntry."Autodocument No.";
                                        exit;
                                    end;
                                "Document Type"::Invoice:
                                    if PurchInvHeader.Get(VATEntry6."Document No.") then begin
                                        Vendor.Name := PurchInvHeader."Pay-to Name";
                                        Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                        VendLedgEntry.SetRange("Document No.", VATEntry6."Document No.");
                                        VendLedgEntry.SetRange("Document Type", "Document Type"::Invoice);
                                        if VendLedgEntry.FindFirst then
                                            AutoDocNo := VendLedgEntry."Autodocument No.";
                                        exit;
                                    end;
                            end;

                            if not Vendor.Get(VATEntry6."Bill-to/Pay-to No.") then
                                Vendor.Name := Text1100003;
                            VendLedgEntry.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                            VendLedgEntry.SetRange("Document No.", VATEntry6."Document No.");
                            VendLedgEntry.SetFilter("Document Type", Text1100004);
                            if VendLedgEntry.FindFirst then;
                        end;
                    }
                    dataitem("<Integer4>"; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATBuffer4_Base_VATBuffer4_Amount; VATBuffer4.Base + VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4_Amount; VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4_Base; VATBuffer4.Base)
                        {
                        }
                        column(CompanyInfo_Name; CompanyInfo.Name)
                        {
                        }
                        column(VATEntry7__Document_No__; VATEntry7."Document No.")
                        {
                        }
                        column(VATEntry7__Posting_Date_; Format(VATEntry7."Posting Date"))
                        {
                        }
                        column(VATEntry7__Document_Date_; Format(VATEntry7."Document Date"))
                        {
                        }
                        column(AutoDocNo; AutoDocNo)
                        {
                        }
                        column(DocType; DocType)
                        {
                        }
                        column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                        {
                        }
                        column(VATBuffer4__VAT___; VATBuffer4."VAT %")
                        {
                        }
                        column(VATBuffer4__EC___; VATBuffer4."EC %")
                        {
                        }
                        column(FORMAT_VATEntry7__Document_Date__; Format(VATEntry7."Document Date"))
                        {
                        }
                        column(VATBuffer4_Base_VATBuffer4_Amount_Control43; VATBuffer4.Base + VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4_Amount_Control44; VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4_Base_Control47; VATBuffer4.Base)
                        {
                        }
                        column(VATBuffer4__VAT____Control10; VATBuffer4."VAT %")
                        {
                        }
                        column(VATBuffer4__EC____Control19; VATBuffer4."EC %")
                        {
                        }
                        column(Integer4__Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Fin then
                                CurrReport.Break;
                            VATBuffer4 := VATBuffer3;
                            Fin := VATBuffer3.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            VATBuffer3.Find('-');
                            Fin := false;
                            LineNo := 0;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not Show then
                            CurrReport.Break;
                        VATBuffer3.DeleteAll;
                        NoSeriesAuxPrev := NoSeriesAux;
                        if "Document Type" = "Document Type"::"Credit Memo" then begin
                            GLSetup.Get;
                            NoSeriesAux := GLSetup."Autocredit Memo Nos.";
                        end;
                        if "Document Type" = "Document Type"::Invoice then begin
                            GLSetup.Get;
                            NoSeriesAux := GLSetup."Autoinvoice Nos.";
                        end;
                        if NoSeriesAux <> NoSeriesAuxPrev then begin
                            NotBaseReverse := 0;
                            NotAmountReverse := 0;
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        PrevData := VATEntry."Posting Date" + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not SortPostDate or not ShowAutoInvCred then
                            CurrReport.Break;

                        SetRange("Generated Autodocument", true);
                        if Find('-') then;
                        if i = 1 then begin
                            repeat
                                VatEntryTemporary.Init;
                                VatEntryTemporary.Copy(VATEntry6);
                                VatEntryTemporary.Insert;
                                VatEntryTemporary.Next;
                            until Next = 0;
                            if Find('-') then;
                            i := 0;
                        end;
                        SetFilter("Posting Date", '%1..%2', PrevData, VATEntry."Posting Date");
                        SetFilter("Document No.", VATEntry.GetFilter("Document No."));
                        SetFilter("Document Type", VATEntry.GetFilter("Document Type"));
                        if VatEntryTemporary.Find('-') then;
                        VatEntryTemporary.SetRange("Generated Autodocument", true);
                        VatEntryTemporary.SetFilter("Posting Date", '%1..%2', PrevData, VATEntry."Posting Date");
                        if VatEntryTemporary.Find('-') then begin
                            Show := true;
                            VatEntryTemporary.DeleteAll;
                        end else
                            Show := false;
                    end;
                }
                dataitem(VATEntry2; "VAT Entry")
                {
                    DataItemLink = Type = FIELD(Type), "Posting Date" = FIELD("Posting Date"), "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No.");
                    DataItemTableView = SORTING("No. Series", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        if ShowAutoInvCred and ("VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT") then begin
                            VATBuffer."VAT %" := 0;
                            VATBuffer."EC %" := 0;
                        end else begin
                            VATBuffer."VAT %" := "VAT %";
                            VATBuffer."EC %" := "EC %";
                        end;
                        if not PrintAmountsInAddCurrency then begin
                            if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then
                                Base := 0;
                            if VATBuffer.Find then begin
                                VATBuffer.Base := VATBuffer.Base + Base;
                                if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then
                                    BaseImport := BaseImport + Base;
                                if (not ShowAutoInvCred) or ("VAT Calculation Type" <> "VAT Calculation Type"::"Reverse Charge VAT") then begin
                                    VATBuffer.Amount := VATBuffer.Amount + Amount;
                                    AmountVatReverse := AmountVatReverse + Amount;
                                end;
                                VATBuffer.Modify;
                            end else begin
                                VATBuffer.Base := Base;
                                if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then
                                    BaseImport := Base;
                                if (not ShowAutoInvCred) or ("VAT Calculation Type" <> "VAT Calculation Type"::"Reverse Charge VAT") then begin
                                    VATBuffer.Amount := Amount;
                                    AmountVatReverse := AmountVatReverse + Amount;
                                end else
                                    VATBuffer.Amount := 0;
                                VATBuffer.Insert;
                            end;
                        end else begin
                            if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then
                                "Additional-Currency Base" := 0;
                            if VATBuffer.Find then begin
                                VATBuffer.Base := VATBuffer.Base + "Additional-Currency Base";
                                if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then
                                    BaseImport := BaseImport + "Additional-Currency Base";
                                if (not ShowAutoInvCred) or ("VAT Calculation Type" <> "VAT Calculation Type"::"Reverse Charge VAT") then begin
                                    VATBuffer.Amount := VATBuffer.Amount + "Additional-Currency Amount";
                                    AmountVatReverse := AmountVatReverse + "Additional-Currency Amount";
                                end;
                                VATBuffer.Modify;
                            end else begin
                                VATBuffer.Base := "Additional-Currency Base";
                                if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then
                                    BaseImport := "Additional-Currency Base";
                                if (not ShowAutoInvCred) or ("VAT Calculation Type" <> "VAT Calculation Type"::"Reverse Charge VAT") then begin
                                    VATBuffer.Amount := "Additional-Currency Amount";
                                    AmountVatReverse := AmountVatReverse + "Additional-Currency Amount";
                                end else
                                    VATBuffer.Amount := 0;
                                VATBuffer.Insert;
                            end;
                        end;
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then
                            TotalBaseImport := TotalBaseImport + BaseImport;
                        TempVATEntry := VATEntry2;
                        if not TempVATEntry.Find then
                            TempVATEntry.Insert;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if SortPostDate then
                            SetCurrentKey(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.")
                        else
                            SetCurrentKey("No. Series", "Posting Date");

                        SetRange("No. Series", VATEntry."No. Series");
                        Clear(PurchCrMemoHeader);
                        Clear(PurchInvHeader);
                        Clear(Vendor);

                        if not PrintAmountsInAddCurrency then
                            GLSetup.Get
                        else begin
                            GLSetup.Get;
                            Currency.Get(GLSetup."Additional Reporting Currency");
                        end;
                        case VATEntry."Document Type" of
                            "Document Type"::"Credit Memo":
                                if PurchCrMemoHeader.Get(VATEntry."Document No.") then begin
                                    Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                    exit;
                                end;
                            "Document Type"::Invoice:
                                if PurchInvHeader.Get(VATEntry."Document No.") then begin
                                    Vendor.Name := PurchInvHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                    exit;
                                end;
                        end;

                        if not Vendor.Get(VATEntry."Bill-to/Pay-to No.") then
                            Vendor.Name := Text1100003;

                        VendLedgEntry.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                        VendLedgEntry.SetRange("Document Type", VATEntry."Document Type");
                        VendLedgEntry.SetRange("Document No.", VATEntry."Document No.");
                        VendLedgEntry.SetFilter("Document Type", Text1100004);
                        if VendLedgEntry.FindFirst then begin
                            if VendLedgEntry."Succeeded Company Name" <> '' then
                                vendor.Name := copystr(VendLedgEntry."Succeeded Company Name", 1, MaxStrLen(Vendor.Name));
                            Vendor."VAT Registration No." := VATEntry."VAT Registration No.";
                        end
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(VATEntry2__Document_No__; VATEntry2."Document No.")
                    {
                    }
                    column(VATBuffer2_Base; VATBuffer2.Base)
                    {
                    }
                    column(VATEntry2__Posting_Date_; Format(VATEntry2."Posting Date"))
                    {
                    }
                    column(VATEntry2__Document_Date_; Format(VATEntry2."Document Date"))
                    {
                    }
                    column(Vendor_Name; Vendor.Name)
                    {
                    }
                    column(DocType_Control11; DocType)
                    {
                    }
                    column(VATBuffer2_Amount; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(VATEntry2__External_Document_No__; VATEntry2."External Document No.")
                    {
                    }
                    column(Vendor__VAT_Registration_No__; Vendor."VAT Registration No.")
                    {
                    }
                    column(VATBuffer2__VAT___; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2__EC___; VATBuffer2."EC %")
                    {
                    }
                    column(FORMAT_VATEntry2__Document_Date__; Format(VATEntry2."Document Date"))
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control53; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Amount_Control58; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_Control61; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2__VAT____Control59; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2__EC____Control60; VATBuffer2."EC %")
                    {
                    }
                    column(VATBuffer2_Base_Control62; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2_Amount_Control63; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control64; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(Integer_Number; Number)
                    {
                    }
                    column(TotalCaption_Control26; TotalCaption_Control26Lbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Fin then
                            CurrReport.Break;
                        VATBuffer2 := VATBuffer;
                        Fin := VATBuffer.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATBuffer.Find('-');
                        Fin := false;
                        LineNo := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    VATBuffer.DeleteAll;
                    TempVATEntry := VATEntry;
                    if TempVATEntry.Find then
                        CurrReport.Skip;
                    AmountVatReverse3 := AmountVatReverse;

                    DocType := Format("Document Type");
                    if "Document Type" = "Document Type"::"Credit Memo" then
                        DocType := Text1100005;
                end;

                trigger OnPreDataItem()
                begin
                    if GetFilter("Posting Date") = '' then
                        PrevData := 0D
                    else
                        PrevData := GetRangeMin("Posting Date");
                    i := 1;
                    if SortPostDate then
                        SetCurrentKey(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.")
                    else
                        SetCurrentKey("No. Series", "Posting Date", "Document No.");
                    TempVATEntry.Reset;
                    TempVATEntry.DeleteAll;
                end;
            }
            dataitem(VATEntry3; "VAT Entry")
            {
                DataItemTableView = SORTING("Document Type", "No. Series", "Posting Date") WHERE(Type = CONST(Purchase));
                column(VarNotAmountReverse; VarNotAmountReverse)
                {
                }
                column(VarNotBaseReverse; VarNotBaseReverse)
                {
                }
                column(VarNotBaseReverse_VarNotAmountReverse; VarNotBaseReverse + VarNotAmountReverse)
                {
                }
                column(No_SeriesAux_; NoSeriesAux)
                {
                }
                column(No_SeriesAux__Control107; NoSeriesAux)
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
                column(VarNotBaseReverse_Control120; VarNotBaseReverse)
                {
                }
                column(VarNotAmountReverse_Control156; VarNotAmountReverse)
                {
                }
                column(VarNotBaseReverse_VarNotAmountReverse_Control159; VarNotBaseReverse + VarNotAmountReverse)
                {
                }
                column(VATEntry3_Entry_No_; "Entry No.")
                {
                }
                column(VATEntry3_Document_Type; "Document Type")
                {
                }
                column(VATEntry3_Type; Type)
                {
                }
                column(VATEntry3_Posting_Date; "Posting Date")
                {
                }
                column(VATEntry3_Document_No_; "Document No.")
                {
                }
                column(ContinuedCaption_Control103; ContinuedCaption_Control103Lbl)
                {
                }
                column(No_SerieCaption; No_SerieCaptionLbl)
                {
                }
                column(TotalCaption_Control96; TotalCaption_Control96Lbl)
                {
                }
                column(No_SerieCaption_Control97; No_SerieCaption_Control97Lbl)
                {
                }
                column(ContinuedCaption_Control119; ContinuedCaption_Control119Lbl)
                {
                }
                dataitem(VATEntry4; "VAT Entry")
                {
                    DataItemLink = Type = FIELD(Type), "Posting Date" = FIELD("Posting Date"), "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No.");
                    DataItemTableView = SORTING("No. Series", "Posting Date");
                    column(VATEntry4_Type; Type)
                    {
                    }
                    column(VATEntry4_Entry_No_; "Entry No.")
                    {
                    }
                    column(VATEntry4_Posting_Date; "Posting Date")
                    {
                    }
                    column(VATEntry4_Document_Date; "Document Date")
                    {
                    }
                    column(VATEntry4_Document_Type; "Document Type")
                    {
                    }
                    column(VATEntry4_Document_No_; "Document No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATBuffer."VAT %" := "VAT %";
                        VATBuffer."EC %" := "EC %";
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then begin
                            if not PrintAmountsInAddCurrency then
                                if VATBuffer.Find then begin
                                    VarBase2 := (VATBuffer.Base + Base) - VATBuffer.Base;
                                    VarAmount2 := (VATBuffer.Amount + Amount) - VATBuffer.Amount;
                                    VATBuffer.Base := VATBuffer.Base + Base;
                                    VATBuffer.Amount := VATBuffer.Amount + Amount;
                                    VATBuffer.Modify;
                                end else begin
                                    VarBase2 := Base;
                                    VarAmount2 := Amount;
                                    VATBuffer.Base := Base;
                                    VATBuffer.Amount := Amount;
                                    VATBuffer.Insert;
                                end
                            else
                                if VATBuffer.Find then begin
                                    VATBuffer.Base := VATBuffer.Base + "Additional-Currency Base";
                                    VATBuffer.Amount := VATBuffer.Amount + "Additional-Currency Amount";
                                    VATBuffer.Modify;
                                end else begin
                                    VATBuffer.Base := "Additional-Currency Base";
                                    VATBuffer.Amount := "Additional-Currency Amount";
                                    VATBuffer.Insert;
                                end
                        end;
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" then begin
                            if not PrintAmountsInAddCurrency then begin
                                NotBaseReverse := NotBaseReverse + VarBase2;
                                NotAmountReverse := NotAmountReverse + VarAmount2;
                            end else begin
                                NotBaseReverse := NotBaseReverse + VATBuffer.Base;
                                NotAmountReverse := NotAmountReverse + VATBuffer.Amount;
                            end;
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        VATEntry3 := VATEntry4;
                    end;

                    trigger OnPreDataItem()
                    begin
                        Clear(PurchCrMemoHeader);
                        Clear(PurchInvHeader);
                        Clear(Vendor);
                        PurchInvHeader.Reset;
                        PurchCrMemoHeader.Reset;
                        Vendor.Reset;

                        VendLedgEntry.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                        case VATEntry3."Document Type" of
                            "Document Type"::"Credit Memo":
                                if PurchCrMemoHeader.Get(VATEntry3."Document No.") then begin
                                    Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                    VendLedgEntry.SetRange("Document No.", VATEntry3."Document No.");
                                    VendLedgEntry.SetRange("Document Type", "Document Type"::"Credit Memo");
                                    if VendLedgEntry.FindFirst then
                                        AutoDocNo := VendLedgEntry."Autodocument No.";
                                    exit;
                                end;
                            "Document Type"::Invoice:
                                if PurchInvHeader.Get(VATEntry3."Document No.") then begin
                                    Vendor.Name := PurchInvHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                    VendLedgEntry.SetRange("Document No.", VATEntry3."Document No.");
                                    VendLedgEntry.SetRange("Document Type", "Document Type"::Invoice);
                                    if VendLedgEntry.FindFirst then
                                        AutoDocNo := VendLedgEntry."Autodocument No.";
                                    exit;
                                end;
                        end;

                        if not Vendor.Get(VATEntry3."Bill-to/Pay-to No.") then
                            Vendor.Name := Text1100003;
                        //ZM aqui para Iva Recuperación, cargamos el nombre del proveedor correctamente
                        if VendLedgEntry."Succeeded Company Name" <> '' then begin
                            vendor.Name := copystr(VendLedgEntry."Succeeded Company Name", 1, MaxStrLen(Vendor.Name));
                        end;

                        VendLedgEntry.SetCurrentKey("Document No.", "Document Type", "Vendor No.");
                        VendLedgEntry.SetRange("Document No.", VATEntry3."Document No.");
                        VendLedgEntry.SetFilter("Document Type", Text1100004);
                        if VendLedgEntry.FindFirst then;


                    end;
                }
                dataitem("<Integer2>"; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control81; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Amount_Control82; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2__EC____Control83; VATBuffer2."EC %")
                    {
                    }
                    column(VATBuffer2__VAT____Control87; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2_Base_Control88; VATBuffer2.Base)
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No___Control89; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfo_Name_Control90; CompanyInfo.Name)
                    {
                    }
                    column(VATEntry4__Document_No__; VATEntry4."Document No.")
                    {
                    }
                    column(VATEntry4__Document_Type_; VATEntry4."Document Type")
                    {
                    }
                    column(AutoDocNo_Control93; AutoDocNo)
                    {
                    }
                    column(VATEntry4__Posting_Date_; Format(VATEntry4."Posting Date"))
                    {
                    }
                    column(FORMAT_VATEntry4__Document_Date__; Format(VATEntry4."Document Date"))
                    {
                    }
                    column(VATBuffer2_Base_Control98; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2__VAT____Control99; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2__EC____Control100; VATBuffer2."EC %")
                    {
                    }
                    column(VATBuffer2_Amount_Control101; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control102; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_Control22; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2_Amount_Control24; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2_Base_VATBuffer2_Amount_Control27; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(Integer2__Number; Number)
                    {
                    }
                    column(TotalCaption_Control21; TotalCaption_Control21Lbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Fin then
                            CurrReport.Break;
                        VATBuffer2 := VATBuffer;
                        Fin := VATBuffer.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATBuffer.Find('-');
                        Fin := false;
                        LineNo := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    VATBuffer.DeleteAll;
                    NoSeriesAuxPrev := NoSeriesAux;
                    if "Document Type" = "Document Type"::"Credit Memo" then begin
                        GLSetup.Get;
                        NoSeriesAux := GLSetup."Autocredit Memo Nos.";
                    end;
                    if "Document Type" = "Document Type"::Invoice then begin
                        GLSetup.Get;
                        NoSeriesAux := GLSetup."Autoinvoice Nos.";
                    end;
                    if NoSeriesAux <> NoSeriesAuxPrev then begin
                        NotBaseReverse := 0;
                        NotAmountReverse := 0;
                        VarNotBaseReverse := 0;
                        VarNotAmountReverse := 0;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if SortPostDate or not ShowAutoInvCred then
                        CurrReport.Break;

                    SetRange("Generated Autodocument", true);
                    if Find('-') then;
                    SetFilter("Posting Date", VATEntry.GetFilter("Posting Date"));
                    SetFilter("Document No.", VATEntry.GetFilter("Document No."));
                    SetFilter("Document Type", VATEntry.GetFilter("Document Type"));
                    NotBaseReverse := 0;
                    NotAmountReverse := 0;
                end;
            }
            dataitem("No Taxable Entry"; "No Taxable Entry")
            {
                DataItemTableView = SORTING("Entry No.") WHERE(Type = CONST(Purchase), Reversed = CONST(false));
                column(PostingDate_NoTaxableEntry; Format("Posting Date"))
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
                column(SourceName_NoTaxableEntry; Vendor.Name)
                {
                }
                column(ExternalDocumentNo_NoTaxableEntry; "External Document No.")
                {
                }
                column(NoSeriesCaption_NoTaxableEntry; FieldCaption("No. Series"))
                {
                }
                column(NoSeries_NoTaxableEntry; "No. Series")
                {
                }
                column(DocumentDate_NoTaxableEntry; Format("Document Date"))
                {
                }
                column(DocumentDateFormat_NoTaxableEntry; Format("Document Date"))
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
                    if not Vendor.Get("Source No.") then
                        Vendor.Name := Text1100003;
                    if PrintAmountsInAddCurrency then
                        NoTaxableAmount := "Base (ACY)"
                    else
                        NoTaxableAmount := "Base (LCY)";
                    if NoTaxablePrinted then
                        NoTaxableText := '';
                    NoTaxablePrinted := true;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Posting Date", VATEntry.GetFilter("Posting Date"));
                    if SortPostDate then
                        SetCurrentKey(Type, "Posting Date", "Document Type", "Document No.", "Source No.")
                    else
                        SetCurrentKey("No. Series", "Posting Date", "Document No.");
                    NoTaxableText := NoTaxableVATTxt;

                    if noMostrarNoTaxable then
                        CurrReport.Break();
                end;
            }

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
                if PrintAmountsInAddCurrency then
                    HeaderText := StrSubstNo(Text1100002, GLSetup."Additional Reporting Currency")
                else begin
                    GLSetup.TestField("LCY Code");
                    HeaderText := StrSubstNo(Text1100002, GLSetup."LCY Code");
                end;

                CompanyInfo.Get;
                CompanyAddr[1] := CompanyInfo.Name;
                CompanyAddr[2] := CompanyInfo."Name 2";
                CompanyAddr[3] := CompanyInfo.Address;
                CompanyAddr[4] := CompanyInfo."Address 2";
                CompanyAddr[5] := CompanyInfo.City;
                CompanyAddr[6] := CompanyInfo."Post Code" + ' ' + CompanyInfo.County;
                if CompanyInfo."VAT Registration No." <> '' then
                    CompanyAddr[7] := Text1100000 + CompanyInfo."VAT Registration No."
                else
                    Error(Text1100001);
                CompressArray(CompanyAddr);
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
                    field(ShowAutoInvCred; ShowAutoInvCred)
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
            ShowAutoInvCred := false;
            noMostrarNoTaxable := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        AuxVatEntry := VATEntry.GetFilters;
        MaxLines := 52;
    end;

    var
        noMostrarNoTaxable: Boolean;
        Text1100000: Label 'VAT Registration No.: ', Comment = 'ESP="CIF/NIF "';
        Text1100001: Label 'Specify the VAT registration number of your company in the Company information window.'
            , Comment = 'ESP=""Especifique el CIF/NIF de su empresa en la ventana Información empresa.';
        Text1100002: Label 'All amounts are in %1.', Comment = 'ESP="Todos los importes se expresan en %1."';
        Text1100003: Label 'UNKNOWN', Comment = 'ESP="DESCONOCIDO"';
        Text1100004: Label 'Invoice|Credit Memo', Comment = 'ESP="Factura|Abono"';
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        Vendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        VATBuffer: Record "Sales/Purch. Book VAT Buffer" temporary;
        VATBuffer2: Record "Sales/Purch. Book VAT Buffer";
        VATBuffer3: Record "Sales/Purch. Book VAT Buffer" temporary;
        VATBuffer4: Record "Sales/Purch. Book VAT Buffer" temporary;
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        VendLedgEntry: Record "Vendor Ledger Entry";
        VatEntryTemporary: Record "VAT Entry" temporary;
        HeaderText: Text[250];
        CompanyAddr: array[7] of Text[100];
        LineNo: Decimal;
        Fin: Boolean;
        PrintAmountsInAddCurrency: Boolean;
        NoSeriesAux: Code[20];
        AutoDocNo: Code[20];
        AmountVatReverse: Decimal;
        NotBaseReverse: Decimal;
        NotAmountReverse: Decimal;
        NoSeriesAuxPrev: Code[20];
        AuxVatEntry: Text[250];
        SortPostDate: Boolean;
        Show: Boolean;
        i: Integer;
        PrevData: Date;
        Base2: Decimal;
        Amount2: Decimal;
        ShowAutoInvCred: Boolean;
        VarBase2: Decimal;
        VarAmount2: Decimal;
        VarNotBaseReverse: Decimal;
        VarNotAmountReverse: Decimal;
        AmountVatReverse3: Decimal;
        BaseImport: Decimal;
        TotalBaseImport: Decimal;
        MaxLines: Integer;
        Text1100005: Label 'Corrective Invoice', Comment = 'ESP="Factura rectificativa"';
        DocType: Text[30];
        CurrReport_PAGENOCaptionLbl: Label 'Page', Comment = 'ESP="Pág."';
        Purchases_Invoice_BookCaptionLbl: Label 'Purchases Invoice Book', Comment = 'ESP="Libro facturas recibidas"';
        TotalCaptionLbl: Label 'Total', Comment = 'ESP="Total"';
        AmountCaptionLbl: Label 'Amount', Comment = 'ESP="Importe"';
        EC_CaptionLbl: Label 'EC%', Comment = 'ESP="%RE"';
        VAT_CaptionLbl: Label 'VAT%', Comment = 'ESP="% IVA"';
        BaseCaptionLbl: Label 'Base', Comment = 'ESP="Base"';
        VAT_RegistrationCaptionLbl: Label 'VAT Registration', Comment = 'ESP="CIF/NIF"';
        NameCaptionLbl: Label 'Name', Comment = 'ESP="Nombre"';
        External_Document_No_CaptionLbl: Label 'External Document No.', Comment = 'ESP="Nº documento externo"';
        Posting_DateCaptionLbl: Label 'Posting Date', Comment = 'ESP="Fecha registro"';
        Document_DateCaptionLbl: Label 'Document Date', Comment = 'ESP="Fecha de documento"';
        Document_No_CaptionLbl: Label 'Document No.', Comment = 'ESP="Nº documento"';
        Epedition_DateCaptionLbl: Label 'Expedition Date', Comment = 'ESP="Fecha expedición"';
        ContinuedCaptionLbl: Label 'Continued';
        ContinuedCaption_Control28Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        ContinuedCaption_Control48Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        ContinuedCaption_Control49Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        TotalCaption_Control77Lbl: Label 'Total', Comment = 'ESP="Total"';
        TotalCaption_Control78Lbl: Label 'Total', Comment = 'ESP="Total"';
        ContinuedCaption_Control18Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        ContinuedCaption_Control32Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        ContinuedCaption_Control130Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        ContinuedCaption_Control134Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        TotalCaption_Control54Lbl: Label 'Total', Comment = 'ESP="Total"';
        TotalCaption_Control127Lbl: Label 'Total', Comment = 'ESP="Total"';
        TotalCaption_Control26Lbl: Label 'Total', Comment = 'ESP="Total"';
        ContinuedCaption_Control103Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        No_SerieCaptionLbl: Label 'No. Series', Comment = 'ESP="Nos. serie"';
        TotalCaption_Control96Lbl: Label 'Total', Comment = 'ESP="Total"';
        No_SerieCaption_Control97Lbl: Label 'No. Series', Comment = 'ESP="Nos. serie"';
        ContinuedCaption_Control119Lbl: Label 'Continued', Comment = 'ESP="Continuación"';
        TotalCaption_Control21Lbl: Label 'Total', Comment = 'ESP="Total"';
        TempVATEntry: Record "VAT Entry" temporary;
        NoTaxableAmount: Decimal;
        NoTaxableVATTxt: Label 'No Taxable VAT', Comment = 'ESP="Ningún IVA sujeto"';
        NoTaxableText: Text;
        NoTaxablePrinted: Boolean;
        gruporegistroIVAnegLbl: Label 'Grupo registro IVA neg ';
        gruporegistroIVAProdLbl: Label 'Grupo registro IVA Producto ';
}

