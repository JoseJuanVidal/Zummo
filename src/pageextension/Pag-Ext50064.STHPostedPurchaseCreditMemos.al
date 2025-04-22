pageextension 50064 "STH PostedPurchaseCreditMemos" extends "Posted Purchase Credit Memos"
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
    }

    actions
    {
        addafter("Co&mments")
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
                    PurchCRMemoHeader: Record "Purch. Cr. Memo Hdr.";
                    Funciones: Codeunit Funciones;
                    lblConfirm: Label '¿Do you want to Export %1 selected documents to PDF in %2?', comment = 'ESP="¿Desea Exportar %1 documentos seleccionados a PDF en %2?"';
                    lblMessage: Label 'The process of exporting documents to PDF has been completed.', comment = 'ESP="Finalizado el proceso de exportación de documentos a PDF.';
                begin
                    PurchSetup.Get();
                    PurchSetup.TestField("Path File Export");
                    CurrPage.SetSelectionFilter(PurchCRMemoHeader);
                    if not Confirm(lblConfirm, false, PurchCRMemoHeader.Count, PurchSetup."Path File Export") then
                        exit;
                    Funciones.PurchCRMemoExportPdf(PurchCRMemoHeader);
                    Message(lblMessage);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin


        ImpTotalDL := 0;
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::"Credit Memo");
        VendorLedgerEntry.SetRange("Document No.", "No.");
        VendorLedgerEntry.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
        if VendorLedgerEntry.FindSet() then begin
            VendorLedgerEntry.CalcFields("Amount (LCY)");
            ImpTotalDL := VendorLedgerEntry."Amount (LCY)";
        end;

        BaseImpDL := 0;
        PurchCRMemoLine.Reset();
        PurchCRMemoLine.SetRange("Document No.", Rec."No.");
        if PurchCRMemoLine.FindSet() then begin
            PurchCRMemoLine.CalcSums(Amount);
            if rec."Currency Factor" = 0 then
                BaseImpDL := PurchCRMemoLine.Amount
            else
                BaseImpDL := PurchCRMemoLine.Amount / rec."Currency Factor";
        end;
    end;


    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchCRMemoLine: Record "Purch. Cr. Memo Line";
        BaseImpDL: Decimal;
        ImpTotalDL: Decimal;
}