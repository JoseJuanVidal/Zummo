pageextension 50190 "IntrastatJournal" extends "Intrastat Journal"
{
      layout
    {
        addafter("Document No.")
        {
            field(factura; codFactura)
            {
                Editable = false;
                Caption = 'Invoice No.', comment = 'ESP="Nº Factura"';
                ApplicationArea = All;
            }

            field(cliente; codCliente)
            {
                Editable = false;
                Caption = 'Customer No.', comment = 'ESP="Cód. Cliente"';
                ApplicationArea = All;
            }

            field(clienteNombre; nombreCliente)
            {
                Editable = false;
                Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recSalesShptHead: Record "Sales Shipment Header";
        recCustomer: Record Customer;
        RecVendor: Record Vendor;
        ReturnReceiptHeader: Record "Return Receipt Header";
        ValueEntry: Record "Value Entry";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        codFactura := '';
        codCliente := '';
        nombreCliente := '';

        if recSalesShptHead.Get("Document No.") then begin
            codCliente := recSalesShptHead."Bill-to Customer No.";

            if recCustomer.get(codCliente) then
                nombreCliente := recCustomer.Name;

            ValueEntry.reset;
            ValueEntry.SetRange("Item Ledger Entry No.", rec."Source Entry No.");
            ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
            if ValueEntry.FindFirst() then
                codFactura := ValueEntry."Document No.";
        end else

            if ReturnReceiptHeader.Get("Document No.") then begin
                codCliente := ReturnReceiptHeader."Bill-to Customer No.";

                if recCustomer.get(codCliente) then
                    nombreCliente := recCustomer.Name;

                ValueEntry.reset;
                ValueEntry.SetRange("Item Ledger Entry No.", rec."Source Entry No.");
                ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Credit Memo");
                if ValueEntry.FindFirst() then
                    codFactura := ValueEntry."Document No.";

                /*if ReturnReceiptHeader."Order No." <> '' then begin
                    recSalesInvLine.Reset();
                    recSalesInvLine.SetRange("Bill-to Customer No.", codCliente);
                    recSalesInvLine.SetRange("Order No.", ReturnReceiptHeader."Order No.");
                    if recSalesInvLine.FindFirst() then
                        codFactura := recSalesInvLine."Document No.";
                end;
                */
            end else

                if PurchRcptHeader.Get("Document No.") then begin
                    codCliente := PurchRcptHeader."Buy-from Vendor No.";

                    if RecVendor.get(codCliente) then
                        nombreCliente := RecVendor.Name;

                    ValueEntry.reset;
                    ValueEntry.SetRange("Item Ledger Entry No.", rec."Source Entry No.");
                    ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
                    if ValueEntry.FindFirst() then
                        codFactura := ValueEntry."Document No.";

                    /*if ReturnReceiptHeader."Order No." <> '' then begin
                        recSalesInvLine.Reset();
                        recSalesInvLine.SetRange("Bill-to Customer No.", codCliente);
                        recSalesInvLine.SetRange("Order No.", ReturnReceiptHeader."Order No.");
                        if recSalesInvLine.FindFirst() then
                            codFactura := recSalesInvLine."Document No.";
                    end;
                    */
                end;
    end;

    var
        codFactura: Code[20];
        codCliente: Code[20];
        nombreCliente: Text[100];
}