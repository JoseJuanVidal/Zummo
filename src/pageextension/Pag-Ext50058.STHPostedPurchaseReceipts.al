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
                                Funciones.PurchRcptLineInsertUpdateField(PurchRcptLine, PurchaseLine);
                                PurchRcptLine.Modify();
                                Commit();
                            end;
                        Until PurchRcptLine.next() = 0;
                    Ventana.Close;
                end;
            }
        }
    }

}