pageextension 50063 "ZM STH PostedPurchaseInvoices" extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field("Importe (DL)"; BaseImpDL)
            {
                ApplicationArea = all;
            }
            field("Importe IVA Incl. (DL)"; ImpTotalDL)
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Plastic Qty. (kg)"; "Plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Recycled plastic Qty. (kg)"; "Recycled plastic Qty. (kg)")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Plastic Date Declaration"; "Plastic Date Declaration")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addlast(Control1)
        {
            field("Purch. Request less 200"; "Purch. Request less 200")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Co&mments")
        {
            action(PaymentsDays)
            {
                ApplicationArea = all;
                Caption = 'Payments Days', comment = 'ESP="Plazos de pago"';
                Image = PaymentDays;
                Promoted = true;
                PromotedCategory = Category5;

                trigger OnAction()
                var
                    PurchInvoiceHeader: Record "Purch. Inv. Header";
                    Funciones: Codeunit SMTP_Trampa;
                begin
                    CurrPage.SetSelectionFilter(PurchInvoiceHeader);
                    Funciones.CreateSalesInvoicePaymentTerms(PurchInvoiceHeader);
                end;


            }
        }
        addafter(Vendor)
        {
            action(ExportPDFPath)
            {
                ApplicationArea = all;
                Caption = 'Export PDF', comment = 'ESP="Exportar PDF"';
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    PurchSetup: record "Purchases & Payables Setup";
                    PurchInvHeader: Record "Purch. Inv. Header";
                    Funciones: Codeunit Funciones;
                    lblConfirm: Label '¿Do you want to Export %1 selected documents to PDF in %2?', comment = 'ESP="¿Desea Exportar %1 documentos seleccionados a PDF en %2?"';
                    lblMessage: Label 'The process of exporting documents to PDF has been completed.', comment = 'ESP="Finalizado el proceso de exportación de documentos a PDF.';
                begin
                    PurchSetup.Get();
                    PurchSetup.TestField("Path File Export");
                    CurrPage.SetSelectionFilter(PurchInvHeader);
                    if not Confirm(lblConfirm, false, PurchInvHeader.Count, PurchSetup."Path File Export") then
                        exit;
                    Funciones.PurchInvoiceExportPdf(PurchInvHeader);
                    Message(lblMessage);
                end;
            }
            action(PurchRequestless200)
            {
                ApplicationArea = all;
                Caption = 'Purch. Request less 200', comment = 'ESP="Seleccionar Compra Menor 200 €"';
                Image = Purchasing;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    PurchRequestless200: record "Purchase Requests less 200";
                begin
                    PurchRequestless200.UpdatePurchaseInvoice(Rec);
                    CurrPage.Update();
                end;

            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        ImpTotalDL := 0;
        BaseImpDL := 0;
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendorLedgerEntry.SetRange("Document No.", "No.");
        VendorLedgerEntry.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
        if VendorLedgerEntry.FindSet() then begin
            VendorLedgerEntry.CalcFields("Amount (LCY)");
            ImpTotalDL := -VendorLedgerEntry."Amount (LCY)";
            if not (rec."Currency Factor" in [0, 1]) then
                BaseImpDL := VendorLedgerEntry."Amount (LCY)";
        end;


        PurchInvLine.Reset();
        PurchInvLine.SetRange("Document No.", Rec."No.");
        if PurchInvLine.FindSet() then begin
            PurchInvLine.CalcSums(Amount);
            if rec."Currency Factor" = 0 then
                BaseImpDL := PurchInvLine.Amount
            else
                BaseImpDL := PurchInvLine.Amount / rec."Currency Factor";
        end;
    end;


    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvLine: Record "Purch. Inv. Line";
        BaseImpDL: Decimal;
        ImpTotalDL: Decimal;
}