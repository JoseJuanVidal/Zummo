page 50001 Descuentos
{
    PageType = Card;
    SourceTable = "Sales Header";
    Caption = 'Descuentos', comment = 'ESP="Descuentos",FRA="Descuentos"';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field(DescuentoFactura; DescuentoFactura)
            {
                ApplicationArea = All;
            }
            field(DescuentoProntoPago; DescuentoProntoPago)
            {
                ApplicationArea = All;
            }
        }
    }
    var
        DocumentTotals: Codeunit "Document Totals";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        DtoPorc: Boolean;

    trigger OnClosePage()
    begin
        if DtoPorc then
            CalcularDescuentoFacTotal()
        else
            CalcularDescuentoTotal();
        CalcularProntoPago;
        commit;
    end;

    procedure SetDtoPorc()
    begin
        DtoPorc := true;
    end;

    procedure CalcularProntoPago()
    var
        SalesLine: record "Sales Line";
        SalesHeader: record "Sales Header";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
    begin

        SalesLine.reset;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange("Allow Invoice Disc.", true);
        SalesLine.SetFilter(Type, '%1|%2', SalesLine.Type::Item, SalesLine.Type::"G/L Account");
        if SalesLine.FindSet() then begin
            repeat
                SalesLine.validate("Pmt. Discount Amount",
              (SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") * DescuentoProntoPago / 100);
                SalesLine.Modify();
            until SalesLine.Next() = 0;
        end;
        SalesHeader.get("Document Type", "No.");
        SalesHeader."Payment Discount %" := DescuentoProntoPago;
        SalesHeader.Modify();
    end;

    procedure CalcularDescuentoTotal()
    var
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        AmountWithDiscountAllowed: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        SalesLine: record "Sales Line";
        InvoiceDiscountAmount: Decimal;
        Currency: record Currency;
    begin
        Currency.InitRoundingPrecision;
        SalesLine.reset;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.FindFirst();
        AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(SalesLine);
        InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * DescuentoFactura / 100, Currency."Amount Rounding Precision");
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, Rec);
    end;

    procedure CalcularDescuentoFacTotal()
    var
        AmountWithDiscountAllowed: Decimal;
        SalesLine: record "Sales Line";
        InvoiceDiscountAmount: Decimal;
        Currency: record Currency;
    begin
        Currency.InitRoundingPrecision;
        SalesLine.reset;
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.FindFirst();
        Rec."Invoice Discount Calculation" := Rec."Invoice Discount Calculation"::Amount;
        Rec.Modify();
        DocumentTotals.SalesDocTotalsNotUpToDate;
        AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(SalesLine);
        InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * DescuentoFactura / 100, Currency."Amount Rounding Precision");
        ValidateInvoiceDiscountAmount;
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: record "Sales Header";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
    begin
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(DescuentoFactura, Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate;
        CurrPage.UPDATE(FALSE);
    end;
}