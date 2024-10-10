table 17452 "ABERTIA SalesFacturas"
{
    Caption = 'ABERTIA SalesFacturas';
    Description = 'ABERTIA - Actualizacion datos Facturas';
    ExternalName = 'SalesFacturas';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {
        field(1; "Document No_"; code[20]) { ExternalName = 'Document No_'; }
        field(2; "Line No_"; Integer) { ExternalName = 'Line No_'; }
        field(3; "Sell-to Customer No_"; code[20]) { ExternalName = 'Sell-to Customer No_'; }
        field(4; "Type"; Integer) { ExternalName = 'Type'; }
        field(5; "No_"; code[20]) { ExternalName = 'No_'; }
        field(6; "Location Code"; code[20]) { ExternalName = 'Location Code'; }
        field(7; "Posting Group"; code[20]) { ExternalName = 'Posting Group'; }
        field(8; "Shipment Date"; date) { ExternalName = 'Shipment Date'; }
        field(9; "Description"; text[100]) { ExternalName = 'Description'; }
        field(10; "Description 2"; text[50]) { ExternalName = 'Description 2'; }
        field(11; "Unit of Measure"; text[50]) { ExternalName = 'Unit of Measure'; }
        field(12; "Quantity"; Decimal) { ExternalName = 'Quantity'; }
        field(13; "Unit Price"; Decimal) { ExternalName = 'Unit Price'; }
        field(14; "Unit Cost (LCY)"; Decimal) { ExternalName = 'Unit Cost (LCY)'; }
        field(15; "VAT _"; Decimal) { ExternalName = 'VAT _'; }
        field(16; "Line Discount _"; Decimal) { ExternalName = 'Line Discount _'; }
        field(17; "Line Discount Amount"; Decimal) { ExternalName = 'Line Discount Amount'; }
        field(18; "Amount"; Decimal) { ExternalName = 'Amount'; }
        field(19; "Amount Including VAT"; Decimal) { ExternalName = 'Amount Including VAT'; }
        field(20; "Allow Invoice Disc_"; Boolean) { ExternalName = 'Allow Invoice Disc_'; }
        field(21; "Gross Weight"; Decimal) { ExternalName = 'Gross Weight'; }
        field(22; "Net Weight"; Decimal) { ExternalName = 'Net Weight'; }
        field(23; "Units per Parcel"; Decimal) { ExternalName = 'Units per Parcel'; }
        field(24; "Unit Volume"; Decimal) { ExternalName = 'Unit Volume'; }
        field(25; "Appl_-to Item Entry"; Integer) { ExternalName = 'Appl_-to Item Entry'; }
        field(26; "Shortcut Dimension 1 Code"; code[20]) { ExternalName = 'Shortcut Dimension 1 Code'; }
        field(27; "Shortcut Dimension 2 Code"; code[20]) { ExternalName = 'Shortcut Dimension 2 Code'; }
        field(28; "Customer Price Group"; code[10]) { ExternalName = 'Customer Price Group'; }
        field(29; "Job No_"; code[20]) { ExternalName = 'Job No_'; }
        field(30; "Work Type Code"; code[10]) { ExternalName = 'Work Type Code'; }
        field(31; "Shipment No_"; code[20]) { ExternalName = 'Shipment No_'; }
        field(32; "Shipment Line No_"; Integer) { ExternalName = 'Shipment Line No_'; }
        field(33; "Order No_"; code[20]) { ExternalName = 'Order No_'; }
        field(34; "Order Line No_"; Integer) { ExternalName = 'Order Line No_'; }
        field(35; "Bill-to Customer No_"; code[20]) { ExternalName = 'Bill-to Customer No_'; }
        field(36; "Inv_ Discount Amount"; Decimal) { ExternalName = 'Inv_ Discount Amount'; }
        field(37; "Drop Shipment"; Boolean) { ExternalName = 'Drop Shipment'; }
        field(38; "Gen_ Bus_ Posting Group"; code[20]) { ExternalName = 'Gen_ Bus_ Posting Group'; }
        field(39; "Gen_ Prod_ Posting Group"; code[20]) { ExternalName = 'Gen_ Prod_ Posting Group'; }
        field(40; "VAT Calculation Type"; Integer) { ExternalName = 'VAT Calculation Type'; }
        field(41; "Transaction Type"; code[10]) { ExternalName = 'Transaction Type'; }
        field(42; "Transport Method"; code[10]) { ExternalName = 'Transport Method'; }
        field(43; "Attached to Line No_"; Integer) { ExternalName = 'Attached to Line No_'; }
        field(44; "Exit Point"; code[10]) { ExternalName = 'Exit Point'; }
        field(45; "Area"; code[10]) { ExternalName = 'Area'; }
        field(46; "Transaction Specification"; code[10]) { ExternalName = 'Transaction Specification'; }
        field(47; "Tax Category"; code[10]) { ExternalName = 'Tax Category'; }
        field(48; "Tax Area Code"; code[20]) { ExternalName = 'Tax Area Code'; }
        field(49; "Tax Liable"; Boolean) { ExternalName = 'Tax Liable'; }
        field(50; "Tax Group Code"; code[20]) { ExternalName = 'Tax Group Code'; }
        field(51; "VAT Clause Code"; code[20]) { ExternalName = 'VAT Clause Code'; }
        field(52; "VAT Bus_ Posting Group"; code[20]) { ExternalName = 'VAT Bus_ Posting Group'; }
        field(53; "VAT Prod_ Posting Group"; code[20]) { ExternalName = 'VAT Prod_ Posting Group'; }
        field(54; "Blanket Order No_"; code[20]) { ExternalName = 'Blanket Order No_'; }
        field(55; "Blanket Order Line No_"; Integer) { ExternalName = 'Blanket Order Line No_'; }
        field(56; "VAT Base Amount"; Decimal) { ExternalName = 'VAT Base Amount'; }
        field(57; "Unit Cost"; Decimal) { ExternalName = 'Unit Cost'; }
        field(58; "System-Created Entry"; Boolean) { ExternalName = 'System-Created Entry'; }
        field(59; "Line Amount"; Decimal) { ExternalName = 'Line Amount'; }
        field(60; "VAT Difference"; Decimal) { ExternalName = 'VAT Difference'; }
        field(61; "VAT Identifier"; code[20]) { ExternalName = 'VAT Identifier'; }
        field(62; "IC Partner Ref_ Type"; Integer) { ExternalName = 'IC Partner Ref_ Type'; }
        field(63; "IC Partner Reference"; code[20]) { ExternalName = 'IC Partner Reference'; }
        field(64; "Prepayment Line"; Boolean) { ExternalName = 'Prepayment Line'; }
        field(65; "IC Partner Code"; code[20]) { ExternalName = 'IC Partner Code'; }
        field(66; "Posting Date"; date) { ExternalName = 'Posting Date'; }
        field(67; "Pmt_ Discount Amount"; Decimal) { ExternalName = 'Pmt_ Discount Amount'; }
        field(68; "Line Discount Calculation"; Integer) { ExternalName = 'Line Discount Calculation'; }
        field(69; "Dimension Set ID"; Integer) { ExternalName = 'Dimension Set ID'; }
        field(70; "Job Task No_"; code[20]) { ExternalName = 'Job Task No_'; }
        field(71; "Job Contract Entry No_"; Integer) { ExternalName = 'Job Contract Entry No_'; }
        field(72; "Deferral Code"; code[10]) { ExternalName = 'Deferral Code'; }
        field(73; "Variant Code"; code[20]) { ExternalName = 'Variant Code'; }
        field(74; "Bin Code"; code[20]) { ExternalName = 'Bin Code'; }
        field(75; "Qty_ per Unit of Measure"; Decimal) { ExternalName = 'Qty_ per Unit of Measure'; }
        field(76; "Unit of Measure Code"; code[20]) { ExternalName = 'Unit of Measure Code'; }
        field(77; "Quantity (Base)"; Decimal) { ExternalName = 'Quantity (Base)'; }
        field(78; "FA Posting Date"; date) { ExternalName = 'FA Posting Date'; }
        field(79; "Depreciation Book Code"; code[10]) { ExternalName = 'Depreciation Book Code'; }
        field(80; "Depr_ until FA Posting Date"; Boolean) { ExternalName = 'Depr_ until FA Posting Date'; }
        field(81; "Duplicate in Depreciation Book"; code[10]) { ExternalName = 'Duplicate in Depreciation Book'; }
        field(82; "Use Duplication List"; Boolean) { ExternalName = 'Use Duplication List'; }
        field(83; "Responsibility Center"; code[10]) { ExternalName = 'Responsibility Center'; }
        field(84; "Cross-Reference No_"; code[20]) { ExternalName = 'Cross-Reference No_'; }
        field(85; "Unit of Measure (Cross Ref_)"; code[10]) { ExternalName = 'Unit of Measure (Cross Ref_)'; }
        field(86; "Cross-Reference Type"; Integer) { ExternalName = 'Cross-Reference Type'; }
        field(87; "Cross-Reference Type No_"; code[20]) { ExternalName = 'Cross-Reference Type No_'; }
        field(88; "Item Category Code"; code[20]) { ExternalName = 'Item Category Code'; }
        field(89; "Nonstock"; Boolean) { ExternalName = 'Nonstock'; }
        field(90; "Purchasing Code"; code[20]) { ExternalName = 'Purchasing Code'; }
        field(91; "Product Group Code"; code[20]) { ExternalName = 'Product Group Code'; }
        field(92; "Appl_-from Item Entry"; Integer) { ExternalName = 'Appl_-from Item Entry'; }
        field(93; "Return Reason Code"; code[20]) { ExternalName = 'Return Reason Code'; }
        field(94; "Allow Line Disc_"; Boolean) { ExternalName = 'Allow Line Disc_'; }
        field(95; "Customer Disc_ Group"; code[20]) { ExternalName = 'Customer Disc_ Group'; }
        field(96; "Price description"; code[20]) { ExternalName = 'Price description'; }
        field(97; "Pmt_ Disc_ Given Amount (Old)"; Decimal) { ExternalName = 'Pmt_ Disc_ Given Amount (Old)'; }
        field(98; "EC _"; Decimal) { ExternalName = 'EC _'; }
        field(99; "EC Difference"; Decimal) { ExternalName = 'EC Difference'; }
        field(100; "Nombre Cliente"; text[100]) { ExternalName = 'Nombre Cliente'; }
        field(101; "Payment Discount _"; Decimal) { ExternalName = 'Payment Discount _'; }
        field(102; "AREAMANAGER"; code[20]) { ExternalName = 'AREAMANAGER'; }
        field(103; "Post Code"; code[20]) { ExternalName = 'Post Code'; }
        field(104; "County"; text[50]) { ExternalName = 'County'; }
        field(105; "grupocliente_btc"; code[20]) { ExternalName = 'grupocliente_btc'; }
        field(106; "Delegado_btc"; code[20]) { ExternalName = 'Delegado_btc'; }
        field(107; "Country_Region Code"; code[20]) { ExternalName = 'Country_Region Code'; }
        field(108; "Pais"; text[50]) { ExternalName = 'Pais'; }
        field(109; "Item Disc_ Group"; code[20]) { ExternalName = 'Item Disc_ Group'; }
        field(110; "ClienteActividad_btc"; code[20]) { ExternalName = 'ClienteActividad_btc'; }
        field(111; "subcliente_btc"; code[20]) { ExternalName = 'subcliente_btc'; }
        field(112; "clientereporting_btc"; code[20]) { ExternalName = 'clientereporting_btc'; }
        field(113; "InsideSales_btc"; code[20]) { ExternalName = 'InsideSales_btc'; }
        field(114; "salesperson code"; code[20]) { ExternalName = 'salesperson code'; }

        field(50999; ID; Guid)
        {
            Caption = 'ID';
            ExternalName = 'ID';
            ExternalType = 'Uniqueidentifier';
        }
    }

    keys
    {
        key(pk; "Document No_", "Line No_")
        {
        }
    }
    trigger OnInsert()
    begin
        if IsNullGuid(Rec.ID) then
            Rec.ID := CreateGuid();
    end;

    var
        GenLedgerSetup: Record "General Ledger Setup";

    procedure CreateTableConnection()
    begin
        GenLedgerSetup.Get();
        IF HASTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI') THEN
            UNREGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');

        REGISTERTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI', GenLedgerSetup.AbertiaTABLECONNECTION());

        SETDEFAULTTABLECONNECTION(TABLECONNECTIONTYPE::ExternalSQL, 'ABERTIABI');
    end;

    procedure CreateSalesFacturas(TypeUpdate: Option Nuevo,Periodo,Todo)
    var
        Customer: Record Customer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        CountryRegion: Record "Country/Region";
        ABERTIASalesFacturas: Record "ABERTIA SalesFacturas";
        Suplemento: Integer;
        Window: Dialog;
    begin
        Window.Open('Nº Producto #1################');
        GenLedgerSetup.Get();
        SalesInvoiceHeader.Reset();
        ABERTIASalesFacturas.Reset();
        case TypeUpdate of
            TypeUpdate::Nuevo:
                begin
                    if ABERTIASalesFacturas.FindLast() then
                        SalesInvoiceHeader.SetFilter("No.", '%1..', ABERTIASalesFacturas."Document No_");
                end;
            TypeUpdate::Periodo:
                begin
                    SalesInvoiceHeader.SetRange("Posting Date", GenLedgerSetup."Allow Posting From", GenLedgerSetup."Allow Posting To");
                end;
        end;
        if SalesInvoiceHeader.FindFirst() then
            repeat
                Window.Update(1, SalesInvoiceHeader."No.");
                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                if SalesInvoiceLine.FindFirst() then
                    repeat
                        if not ABERTIASalesFacturas.Get(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.") then begin
                            ABERTIASalesFacturas.Init();
                            ABERTIASalesFacturas.ID := CreateGuid();
                        end;
                        ABERTIASalesFacturas."Document No_" := SalesInvoiceLine."Document No.";
                        ABERTIASalesFacturas."Line No_" := SalesInvoiceLine."Line No.";
                        ABERTIASalesFacturas."Sell-to Customer No_" := SalesInvoiceLine."Sell-to Customer No.";
                        ABERTIASalesFacturas."Type" := SalesInvoiceLine.Type;
                        ABERTIASalesFacturas."No_" := SalesInvoiceLine."No.";
                        ABERTIASalesFacturas."Location Code" := SalesInvoiceLine."Location Code";
                        ABERTIASalesFacturas."Posting Group" := SalesInvoiceLine."Posting Group";
                        ABERTIASalesFacturas."Shipment Date" := SalesInvoiceLine."Shipment Date";
                        ABERTIASalesFacturas."Description" := SalesInvoiceLine.Description;
                        ABERTIASalesFacturas."Description 2" := SalesInvoiceLine."Description 2";
                        ABERTIASalesFacturas."Unit of Measure" := SalesInvoiceLine."Unit of Measure";
                        ABERTIASalesFacturas."Quantity" := SalesInvoiceLine.Quantity;
                        ABERTIASalesFacturas."Unit Price" := SalesInvoiceLine."Unit Price";
                        ABERTIASalesFacturas."Unit Cost (LCY)" := SalesInvoiceLine."Unit Cost (LCY)";
                        ABERTIASalesFacturas."VAT _" := SalesInvoiceLine."VAT %";
                        ABERTIASalesFacturas."Line Discount _" := SalesInvoiceLine."Line Discount %";
                        ABERTIASalesFacturas."Line Discount Amount" := SalesInvoiceLine."Line Discount Amount";
                        ABERTIASalesFacturas."Amount" := SalesInvoiceLine.Amount;
                        ABERTIASalesFacturas."Amount Including VAT" := SalesInvoiceLine."Amount Including VAT";
                        ABERTIASalesFacturas."Allow Invoice Disc_" := SalesInvoiceLine."Allow Invoice Disc.";
                        ABERTIASalesFacturas."Gross Weight" := SalesInvoiceLine."Gross Weight";
                        ABERTIASalesFacturas."Net Weight" := SalesInvoiceLine."Net Weight";
                        ABERTIASalesFacturas."Units per Parcel" := SalesInvoiceLine."Units per Parcel";
                        ABERTIASalesFacturas."Unit Volume" := SalesInvoiceLine."Unit Volume";
                        ABERTIASalesFacturas."Appl_-to Item Entry" := SalesInvoiceLine."Appl.-to Item Entry";
                        ABERTIASalesFacturas."Shortcut Dimension 1 Code" := SalesInvoiceLine."Shortcut Dimension 1 Code";
                        ABERTIASalesFacturas."Shortcut Dimension 2 Code" := SalesInvoiceLine."Shortcut Dimension 2 Code";
                        ABERTIASalesFacturas."Customer Price Group" := SalesInvoiceLine."Customer Price Group";
                        ABERTIASalesFacturas."Job No_" := SalesInvoiceLine."Job No.";
                        ABERTIASalesFacturas."Work Type Code" := SalesInvoiceLine."Work Type Code";
                        ABERTIASalesFacturas."Shipment No_" := SalesInvoiceLine."Shipment No.";
                        ABERTIASalesFacturas."Shipment Line No_" := SalesInvoiceLine."Shipment Line No.";
                        ABERTIASalesFacturas."Order No_" := SalesInvoiceLine."Order No.";
                        ABERTIASalesFacturas."Order Line No_" := SalesInvoiceLine."Order Line No.";
                        ABERTIASalesFacturas."Bill-to Customer No_" := SalesInvoiceLine."Bill-to Customer No.";
                        ABERTIASalesFacturas."Inv_ Discount Amount" := SalesInvoiceLine."Inv. Discount Amount";
                        ABERTIASalesFacturas."Drop Shipment" := SalesInvoiceLine."Drop Shipment";
                        ABERTIASalesFacturas."Gen_ Bus_ Posting Group" := SalesInvoiceLine."Gen. Bus. Posting Group";
                        ABERTIASalesFacturas."Gen_ Prod_ Posting Group" := SalesInvoiceLine."Gen. Prod. Posting Group";
                        ABERTIASalesFacturas."VAT Calculation Type" := SalesInvoiceLine."VAT Calculation Type";
                        ABERTIASalesFacturas."Transaction Type" := SalesInvoiceLine."Transaction Type";
                        ABERTIASalesFacturas."Transport Method" := SalesInvoiceLine."Transport Method";
                        ABERTIASalesFacturas."Attached to Line No_" := SalesInvoiceLine."Attached to Line No.";
                        ABERTIASalesFacturas."Exit Point" := SalesInvoiceLine."Exit Point";
                        ABERTIASalesFacturas."Area" := SalesInvoiceLine."Area";
                        ABERTIASalesFacturas."Transaction Specification" := SalesInvoiceLine."Transaction Specification";
                        ABERTIASalesFacturas."Tax Category" := SalesInvoiceLine."Tax Category";
                        ABERTIASalesFacturas."Tax Area Code" := SalesInvoiceLine."Tax Area Code";
                        ABERTIASalesFacturas."Tax Liable" := SalesInvoiceLine."Tax Liable";
                        ABERTIASalesFacturas."Tax Group Code" := SalesInvoiceLine."Tax Group Code";
                        ABERTIASalesFacturas."VAT Clause Code" := SalesInvoiceLine."VAT Clause Code";
                        ABERTIASalesFacturas."VAT Bus_ Posting Group" := SalesInvoiceLine."VAT Bus. Posting Group";
                        ABERTIASalesFacturas."VAT Prod_ Posting Group" := SalesInvoiceLine."VAT Prod. Posting Group";
                        ABERTIASalesFacturas."Blanket Order No_" := SalesInvoiceLine."Blanket Order No.";
                        ABERTIASalesFacturas."Blanket Order Line No_" := SalesInvoiceLine."Blanket Order Line No.";
                        ABERTIASalesFacturas."VAT Base Amount" := SalesInvoiceLine."VAT Base Amount";
                        ABERTIASalesFacturas."Unit Cost" := SalesInvoiceLine."Unit Cost";
                        ABERTIASalesFacturas."System-Created Entry" := SalesInvoiceLine."System-Created Entry";
                        ABERTIASalesFacturas."Line Amount" := SalesInvoiceLine."Line Amount";
                        ABERTIASalesFacturas."VAT Difference" := SalesInvoiceLine."VAT Difference";
                        ABERTIASalesFacturas."VAT Identifier" := SalesInvoiceLine."VAT Identifier";
                        ABERTIASalesFacturas."IC Partner Ref_ Type" := SalesInvoiceLine."IC Partner Ref. Type";
                        ABERTIASalesFacturas."IC Partner Reference" := SalesInvoiceLine."IC Partner Reference";
                        ABERTIASalesFacturas."Prepayment Line" := SalesInvoiceLine."Prepayment Line";
                        ABERTIASalesFacturas."IC Partner Code" := SalesInvoiceLine."IC Partner Code";
                        ABERTIASalesFacturas."Posting Date" := SalesInvoiceLine."Posting Date";
                        ABERTIASalesFacturas."Pmt_ Discount Amount" := SalesInvoiceLine."Pmt. Discount Amount";
                        ABERTIASalesFacturas."Line Discount Calculation" := SalesInvoiceLine."Line Discount Calculation";
                        ABERTIASalesFacturas."Dimension Set ID" := SalesInvoiceLine."Dimension Set ID";
                        ABERTIASalesFacturas."Job Task No_" := SalesInvoiceLine."Job Task No.";
                        ABERTIASalesFacturas."Job Contract Entry No_" := SalesInvoiceLine."Job Contract Entry No.";
                        ABERTIASalesFacturas."Deferral Code" := SalesInvoiceLine."Deferral Code";
                        ABERTIASalesFacturas."Variant Code" := SalesInvoiceLine."Variant Code";
                        ABERTIASalesFacturas."Bin Code" := SalesInvoiceLine."Bin Code";
                        ABERTIASalesFacturas."Qty_ per Unit of Measure" := SalesInvoiceLine."Qty. per Unit of Measure";
                        ABERTIASalesFacturas."Unit of Measure Code" := SalesInvoiceLine."Unit of Measure Code";
                        ABERTIASalesFacturas."Quantity (Base)" := SalesInvoiceLine."Quantity (Base)";
                        ABERTIASalesFacturas."FA Posting Date" := SalesInvoiceLine."FA Posting Date";
                        ABERTIASalesFacturas."Depreciation Book Code" := SalesInvoiceLine."Depreciation Book Code";
                        ABERTIASalesFacturas."Depr_ until FA Posting Date" := SalesInvoiceLine."Depr. until FA Posting Date";
                        ABERTIASalesFacturas."Duplicate in Depreciation Book" := SalesInvoiceLine."Duplicate in Depreciation Book";
                        ABERTIASalesFacturas."Use Duplication List" := SalesInvoiceLine."Use Duplication List";
                        ABERTIASalesFacturas."Responsibility Center" := SalesInvoiceLine."Responsibility Center";
                        ABERTIASalesFacturas."Cross-Reference No_" := SalesInvoiceLine."Cross-Reference No.";
                        ABERTIASalesFacturas."Unit of Measure (Cross Ref_)" := SalesInvoiceLine."Unit of Measure (Cross Ref.)";
                        ABERTIASalesFacturas."Cross-Reference Type" := SalesInvoiceLine."Cross-Reference Type";
                        ABERTIASalesFacturas."Cross-Reference Type No_" := SalesInvoiceLine."Cross-Reference Type No.";
                        ABERTIASalesFacturas."Item Category Code" := SalesInvoiceLine."Item Category Code";
                        ABERTIASalesFacturas."Nonstock" := SalesInvoiceLine.Nonstock;
                        ABERTIASalesFacturas."Purchasing Code" := SalesInvoiceLine."Purchasing Code";
                        // ABERTIASalesFacturas."Product Group Code" := SalesInvoiceHeader.
                        ABERTIASalesFacturas."Appl_-from Item Entry" := SalesInvoiceLine."Appl.-from Item Entry";
                        ABERTIASalesFacturas."Return Reason Code" := SalesInvoiceLine."Return Reason Code";
                        ABERTIASalesFacturas."Allow Line Disc_" := SalesInvoiceLine."Allow Line Disc.";
                        ABERTIASalesFacturas."Customer Disc_ Group" := SalesInvoiceLine."Customer Disc. Group";
                        ABERTIASalesFacturas."Price description" := SalesInvoiceLine."Price description";
                        // ABERTIASalesFacturas."Pmt_ Disc_ Given Amount (Old)" := SalesInvoiceHeader.pmt
                        ABERTIASalesFacturas."EC _" := SalesInvoiceLine."EC %";
                        ABERTIASalesFacturas."EC Difference" := SalesInvoiceLine."EC Difference";
                        ABERTIASalesFacturas."Nombre Cliente" := SalesInvoiceHeader."Sell-to Customer Name";
                        ABERTIASalesFacturas."Payment Discount _" := SalesInvoiceHeader."Payment Discount %";
                        ABERTIASalesFacturas."AREAMANAGER" := SalesInvoiceHeader.AreaManager_btc;
                        ABERTIASalesFacturas."Post Code" := SalesInvoiceHeader."Sell-to Post Code";
                        ABERTIASalesFacturas."County" := SalesInvoiceHeader."Sell-to County";
                        ABERTIASalesFacturas."grupocliente_btc" := SalesInvoiceHeader.GrupoCliente_btc;
                        ABERTIASalesFacturas."Delegado_btc" := SalesInvoiceHeader.Delegado_btc;
                        ABERTIASalesFacturas."Country_Region Code" := SalesInvoiceHeader."Sell-to Country/Region Code";
                        if CountryRegion.get(SalesInvoiceHeader."Sell-to Country/Region Code") then
                            ABERTIASalesFacturas."Pais" := CountryRegion.Name;
                        // ABERTIASalesFacturas."Item Disc_ Group" := SalesInvoiceHeader.item
                        Customer.Get(SalesInvoiceHeader."Sell-to Customer No.");
                        ABERTIASalesFacturas."ClienteActividad_btc" := Customer.ClienteActividad_btc;
                        ABERTIASalesFacturas."subcliente_btc" := SalesInvoiceHeader.SubCliente_btc;
                        ABERTIASalesFacturas."clientereporting_btc" := SalesInvoiceHeader.ClienteReporting_btc;
                        ABERTIASalesFacturas."InsideSales_btc" := SalesInvoiceHeader.InsideSales_btc;
                        ABERTIASalesFacturas."salesperson code" := SalesInvoiceHeader."Salesperson Code";
                        if not ABERTIASalesFacturas.Insert() then
                            ABERTIASalesFacturas.Modify();
                    Until SalesInvoiceLine.next() = 0;
            Until SalesInvoiceHeader.next() = 0;
        Window.Close();
    end;
}