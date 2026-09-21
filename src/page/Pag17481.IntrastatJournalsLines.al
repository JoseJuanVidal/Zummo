page 17481 "Intrastat Journals Lines"
{
    Caption = 'Intrastat Journals Lines', comment = 'ESP="Lineas Diario Intrastat"';
    PageType = List;
    Editable = false;
    //    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Intrastat Jnl. Line";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Journal_Template_Name; "Journal Template Name") { }
                field(Journal_Batch_Name; "Journal Batch Name") { }
                field(Line_No; "Line No.") { }
                field(Type; Type) { }
                field(Date; Date) { }
                field(Tariff_No; "Tariff No.") { }
                field("Item_Description"; "Item Description") { }
                field(Country_Region_Code; "Country/Region Code") { }
                field(Transaction_Type; "Transaction Type") { }
                field(Transport_Method; "Transport Method") { }
                field(Source_Type; "Source Type") { }
                field(Source_Entry_No; "Source Entry No.") { }
                field(Net_Weight; "Net Weight") { }
                field(Amount; Amount) { }
                field(Quantity; Quantity) { }
                field(Cost_Regulation_Percent; "Cost Regulation %") { }
                field(Indirect_Cost; "Indirect Cost") { }
                field(Statistical_Value; "Statistical Value") { }
                field(Document_No; "Document No.") { }
                field(Item_No; "Item No.") { }
                field(Name; Name) { }
                field(Total_Weight; "Total Weight") { }
                field(Supplementary_Units; "Supplementary Units") { }
                field(Internal_Ref_No; "Internal Ref. No.") { }
                field(Country_Region_of_Origin_Code; "Country/Region of Origin Code") { }
                field(Entry_Exit_Point; "Entry/Exit Point") { }
                field("Area"; "Area") { }
                field(Transaction_Specification; "Transaction Specification") { }
                field(Shpt_Method_Code; "Shpt. Method Code") { }
                field(Place_of_Receipt; "Place of Receipt") { }
                field("Shipment_Method_Code_#1"; "Shipment Method Code #1") { }
                field("Shipment_Method_Code_#2"; "Shipment Method Code #2") { }
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
                    Caption = 'Customer Name', comment = 'ESP="Nombre Cliente"';
                    ApplicationArea = All;
                }
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Customer Name"; "Customer Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
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

    trigger OnOpenPage()
    begin
        filter := StrSubstNo('*%1*', Date2DMY(WorkDate(), 3));
        Rec.SetFilter("Journal Batch Name", Filter);
    end;


    var
        codFactura: Code[20];
        codCliente: Code[20];
        nombreCliente: Text[100];
        Filter: text;
}