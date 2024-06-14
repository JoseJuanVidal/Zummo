pageextension 50023 "ZM PurchInvoiceSubform" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            //231219 S19/01434 Mostar iva en compras y ventas
            field("VAT %"; "VAT %")
            {
                ApplicationArea = All;
            }

            //231219 S19/01434 Mostar iva en compras y ventas
            field("VAT Identifier"; "VAT Identifier")
            {
                ApplicationArea = All;
            }
        }
        addafter("Direct Unit Cost")
        {
            field(StandarCost; StandarCost)
            {
                ApplicationArea = all;
            }
        }
        addafter("VAT Prod. Posting Group")
        {
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field(IdCorp_Sol; IdCorp_Sol)
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Nombre Empleado"; "Nombre Empleado")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Purch. Order No."; "Purch. Order No.")
            {
                ApplicationArea = all;
                Visible = False;
            }
        }
    }

    // actions
    // {
    //     addafter(GetReceiptLines)
    //     {
    //         action(GetShipmentLines)
    //         {
    //             ApplicationArea = all;
    //             Caption = 'Traer Lin. Envíos', comment = 'ESP="Traer Lin. Envíos"';
    //             Image = ReturnReceipt;

    //             trigger OnAction()
    //             begin
    //                 GetShipmentLinestoInvoice;
    //             end;
    //         }
    //     }
    // }

    local procedure GetShipmentLinestoInvoice()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ReturnShipmentLine: Record "Return Shipment Line";
    begin
        PurchHeader.get(rec."Document Type", Rec."Document No.");
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."Document No.");
        PurchLine."Document Type" := Rec."Document Type";
        PurchLine."Document No." := rec."Document No.";

        ReturnShipmentLine.Get('105004', 60000);
        ReturnShipmentLine.Quantity := -ReturnShipmentLine.Quantity;
        ReturnShipmentLine.InsertInvLineFromRetShptLine(PurchLine);
    end;

    // local procedure InsertInvLineFromRetShptLine(var PurchLine: Record "Purchase Line"; DocumentNo: code[20])
    // var
    //     ReturnShipmentLine: Record "Return Shipment Line";
    //     TempPurchLine: record "Purchase Line";
    //     NextLineNo: Integer;
    // begin
    //     ReturnShipmentLine.SETRANGE("Document No.", DocumentNo);

    //     TempPurchLine := PurchLine;
    //     IF PurchLine.FIND('+') THEN
    //         NextLineNo := PurchLine."Line No." + 10000
    //     ELSE
    //         NextLineNo := 10000;

    //     IF PurchHeader."No." <> TempPurchLine."Document No." THEN
    //         PurchHeader.GET(TempPurchLine."Document Type", TempPurchLine."Document No.");

    //     IF PurchLine."Return Shipment No." <> "Document No." THEN BEGIN
    //         PurchLine.INIT;
    //         PurchLine."Line No." := NextLineNo;
    //         PurchLine."Document Type" := TempPurchLine."Document Type";
    //         PurchLine."Document No." := TempPurchLine."Document No.";
    //         PurchLine.Description := STRSUBSTNO(Text000, "Document No.");
    //         PurchLine.INSERT;
    //         NextLineNo := NextLineNo + 10000;
    //     END;

    //     TransferOldExtLines.ClearLineNumbers;
    //     PurchSetup.GET;
    //     REPEAT
    //         ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

    //         IF NOT PurchOrderLine.GET(
    //              PurchOrderLine."Document Type"::"Return Order", "Return Order No.", "Return Order Line No.")
    //         THEN BEGIN
    //             IF ExtTextLine THEN BEGIN
    //                 PurchOrderLine.INIT;
    //                 PurchOrderLine."Line No." := "Return Order Line No.";
    //                 PurchOrderLine.Description := Description;
    //                 PurchOrderLine."Description 2" := "Description 2";
    //             END ELSE
    //                 ERROR(Text001);
    //         END ELSE BEGIN
    //             IF (PurchHeader2."Document Type" <> PurchOrderLine."Document Type"::"Return Order") OR
    //                (PurchHeader2."No." <> PurchOrderLine."Document No.")
    //             THEN
    //                 PurchHeader2.GET(PurchOrderLine."Document Type"::"Return Order", "Return Order No.");

    //             InitCurrency("Currency Code");

    //             IF PurchHeader."Prices Including VAT" THEN BEGIN
    //                 IF NOT PurchHeader2."Prices Including VAT" THEN
    //                     PurchOrderLine."Direct Unit Cost" :=
    //                       ROUND(
    //                         PurchOrderLine."Direct Unit Cost" * (1 + PurchOrderLine."VAT %" / 100),
    //                         Currency."Unit-Amount Rounding Precision");
    //             END ELSE BEGIN
    //                 IF PurchHeader2."Prices Including VAT" THEN
    //                     PurchOrderLine."Direct Unit Cost" :=
    //                       ROUND(
    //                         PurchOrderLine."Direct Unit Cost" / (1 + PurchOrderLine."VAT %" / 100),
    //                         Currency."Unit-Amount Rounding Precision");
    //             END;
    //         END;
    //         PurchLine := PurchOrderLine;
    //         PurchLine."Line No." := NextLineNo;
    //         PurchLine."Document Type" := TempPurchLine."Document Type";
    //         PurchLine."Document No." := TempPurchLine."Document No.";
    //         PurchLine."Variant Code" := "Variant Code";
    //         PurchLine."Location Code" := "Location Code";
    //         PurchLine."Return Reason Code" := "Return Reason Code";
    //         PurchLine."Quantity (Base)" := 0;
    //         PurchLine.Quantity := 0;
    //         PurchLine."Outstanding Qty. (Base)" := 0;
    //         PurchLine."Outstanding Quantity" := 0;
    //         PurchLine."Return Qty. Shipped" := 0;
    //         PurchLine."Return Qty. Shipped (Base)" := 0;
    //         PurchLine."Quantity Invoiced" := 0;
    //         PurchLine."Qty. Invoiced (Base)" := 0;
    //         PurchLine."Sales Order No." := '';
    //         PurchLine."Sales Order Line No." := 0;
    //         PurchLine."Drop Shipment" := FALSE;
    //         PurchLine."Return Shipment No." := "Document No.";
    //         PurchLine."Return Shipment Line No." := "Line No.";
    //         PurchLine."Appl.-to Item Entry" := 0;
    //         OnAfterCopyFieldsFromReturnShipmentLine(Rec, PurchLine);

    //         IF NOT ExtTextLine THEN BEGIN
    //             PurchLine.VALIDATE(Quantity, Quantity - "Quantity Invoiced");
    //             PurchLine.VALIDATE("Direct Unit Cost", PurchOrderLine."Direct Unit Cost");
    //             PurchLine.VALIDATE("Line Discount %", PurchOrderLine."Line Discount %");
    //             IF PurchOrderLine.Quantity = 0 THEN
    //                 PurchLine.VALIDATE("Inv. Discount Amount", 0)
    //             ELSE
    //                 PurchLine.VALIDATE(
    //                   "Inv. Discount Amount",
    //                   ROUND(
    //                     PurchOrderLine."Inv. Discount Amount" * PurchLine.Quantity / PurchOrderLine.Quantity,
    //                     Currency."Amount Rounding Precision"));
    //         END;
    //         PurchLine."Attached to Line No." :=
    //           TransferOldExtLines.TransferExtendedText(
    //             "Line No.",
    //             NextLineNo,
    //             "Attached to Line No.");
    //         PurchLine."Shortcut Dimension 1 Code" := PurchOrderLine."Shortcut Dimension 1 Code";
    //         PurchLine."Shortcut Dimension 2 Code" := PurchOrderLine."Shortcut Dimension 2 Code";
    //         PurchLine."Dimension Set ID" := PurchOrderLine."Dimension Set ID";

    //         OnBeforeInsertInvLineFromRetShptLine(PurchLine, PurchOrderLine);
    //         PurchLine.INSERT;
    //         OnAfterInsertInvLineFromRetShptLine(PurchLine);

    //         ItemTrackingMgt.CopyHandledItemTrkgToInvLine2(PurchOrderLine, PurchLine);

    //         NextLineNo := NextLineNo + 10000;
    //         IF "Attached to Line No." = 0 THEN
    //             SETRANGE("Attached to Line No.", "Line No.");
    //     UNTIL (NEXT = 0) OR ("Attached to Line No." = 0);
    // end;
}