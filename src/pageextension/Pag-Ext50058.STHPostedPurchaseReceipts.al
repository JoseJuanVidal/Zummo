pageextension 50058 "STH PostedPurchaseReceipts" extends "Posted Purchase Receipts"
{
    layout
    {
        addlast(Control1)
        {
            field(BaseImponibleLinea; BaseImponibleLinea)
            {
                ApplicationArea = all;
            }
            field(TotalImponibleLinea; TotalImponibleLinea)
            {
                ApplicationArea = all;
            }
            field("Amount Subcontractor"; "Amount Subcontractor")
            {
                ApplicationArea = all;
            }
            field("Amount Inc. VAT Subcontractor"; "Amount Inc. VAT Subcontractor")
            {
                ApplicationArea = all;
            }
            field("Vendor Shipment No."; "Vendor Shipment No.")
            {
                ApplicationArea = all;
            }
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
        addlast(FactBoxes)
        {
            part(Documents; "ZM SH Record Link Sharepoints")
            {
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(calcularImportes)
            {
                ApplicationArea = all;
                Caption = 'Calcular Importes', comment = 'ESP="Calcular importes"';
                Image = Calculate;

                trigger OnAction()
                var
                    PurchRcptLine: Record "Purch. Rcpt. Line";
                    PurchaseLine: Record "Purchase Line";
                    Funciones: Codeunit SalesEvents;
                    Ventana: Dialog;
                begin
                    if Not confirm('¿Desea recalcular los importe de los albaranes') then
                        exit;
                    ventana.Open('Albaran #1###############');
                    if PurchRcptLine.findset() then
                        repeat
                            Ventana.Update(1, PurchRcptLine."Document No.");
                            if PurchaseLine.Get(PurchaseLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.") then begin
                                Funciones.PurchRcptLineInsertUpdateModifyField(PurchRcptLine, PurchaseLine);
                            end;
                        Until PurchRcptLine.next() = 0;
                    Ventana.Close;
                end;
            }
            action(MarcaNoFacturar)
            {
                ApplicationArea = all;
                Caption = 'Marcar no facturar', comment = 'ESP="Marcar no facturar"';
                Image = Check;

                trigger OnAction()
                var
                    Funciones: Codeunit Funciones;

                begin
                    Funciones.MarcarNoFacturar(Rec);
                end;

            }
            action(ExportExcel)
            {
                ApplicationArea = all;
                Caption = 'Excel Normativa', comment = 'ESP="Excel Normativa"';
                Image = Excel;

                trigger OnAction()
                var
                    Funciones: Codeunit SMTP_Trampa;

                begin
                    Funciones.CreatePurchaseReceiptPlastic();
                end;

            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdatedocumentsFilter();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdatedocumentsFilter();
    end;

    local procedure UpdatedocumentsFilter()
    begin
        CurrPage.Documents.Page.SetRecordIR(Rec.RecordId, StrSubstNo('%1 %2', Rec."Buy-from Vendor No.", Rec."No."), Rec."Vendor Shipment No.", Rec."No.");
    end;
}