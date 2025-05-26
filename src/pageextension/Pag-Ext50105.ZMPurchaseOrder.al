pageextension 50105 "ZM PurchaseOrder" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field(Pendiente_btc; Pendiente_btc)
            {
                ApplicationArea = All;
            }
        }
        addlast(Content)
        {
            group(Plastic)
            {
                Caption = 'Normativa Plástico', comment = 'ESP="Normativa Plástico"';

                field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
                {
                    ApplicationArea = all;
                }
                field("Plastic Date Declaration"; "Plastic Date Declaration")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(ChangeCurrencyCode)
            {
                ApplicationArea = all;
                Caption = 'Change Currenci', comment = 'ESP="Cambiar Divisa"';
                Image = Currency;

                trigger OnAction()
                begin
                    ChangeCurrencyPurchaseOder
                end;
            }
        }
        addafter(Print)
        {
            action(ExportPDF)
            {
                ApplicationArea = all;
                Image = SendAsPDF;
                Promoted = true;
                PromotedCategory = Category10;

                trigger OnAction()
                begin
                    ExportMergePDF();
                end;
            }
        }
    }
    var
        Funciones: Codeunit Funciones;

    local procedure ExportMergePDF()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", Rec."Document Type");
        PurchaseHeader.SetRange("No.", Rec."No.");
        PurchaseHeader.FindFirst();
        Funciones.ExportarPDFPurchaseOrder(PurchaseHeader);
    end;

    local procedure ChangeCurrencyPurchaseOder()
    var
        PurchaseLine: Record "Purchase Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        Currency: Record Currency;
        Currencies: page Currencies;
        CurrencyExcRate: Record "Currency Exchange Rate";
        lblMessage: Label 'No order lines have been received. You can change the data from the Currency Code field.', comment = 'ESP="No se han recibido líneas de pedidos. Puede cambiar el dato desde el campo Cód. Divisa."';
        lblConfirm: Label '¿Do you want to change the currency of the order to %1?', comment = 'ESP="¿Desea cambiar la divisa del pedido a %1?"';
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", Rec."Document Type");
        PurchaseLine.SetRange("Document No.", Rec."No.");
        PurchaseLine.SetFilter("Qty. Received (Base)", '>0');
        if not PurchaseLine.FindSet() then begin
            Message(lblMessage);
            exit;
        end;
        Currencies.Editable(false);
        Currencies.LookupMode(true);
        if Currencies.RunModal() = Action::LookupOK then begin
            Currencies.GetRecord(Currency);
            if not Confirm(lblConfirm, false, Currency.Code) then
                exit;
            Rec."Currency Code" := Currency.Code;
            CurrencyExcRate.Reset();
            CurrencyExcRate.SetRange("Currency Code", Currency.Code);
            CurrencyExcRate.SetFilter("Starting Date", '<=%1', Rec."Document Date");
            if CurrencyExcRate.FindLast() then
                Rec."Currency Factor" := CurrencyExcRate."Exchange Rate Amount";
            Rec.Modify(true);
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", Rec."Document Type");
            PurchaseLine.SetRange("Document No.", Rec."No.");
            PurchaseLine.ModifyAll("Currency Code", Currency.Code);

            PurchRcptHeader.Reset();
            PurchRcptHeader.SetRange("Order No.", Rec."No.");
            if PurchRcptHeader.FindSet() then
                repeat
                    PurchRcptHeader."Currency Code" := Rec."Currency Code";
                    PurchRcptHeader."Currency Factor" := Rec."Currency Factor";
                    PurchRcptHeader.Modify();
                until PurchRcptHeader.Next() = 0;

        end;


    end;
}