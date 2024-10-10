table 17465 "ABERTIA SalesFacturas"
{
    Caption = 'ABERTIA SalesFacturas';
    Description = 'ABERTIA - actualizacion datos Facturas';
    ExternalName = 'SalesFacturas';
    ExternalSchema = 'dbo';
    TableType = ExternalSQL;

    fields
    {
        field(1; "Document No_"; code[20]) { ExternalName = 'Document No_'; }
        field(2; "Line No_"; code[20]) { ExternalName = 'Line No_'; }
        field(3; "Sell-to Customer No_"; code[20]) { ExternalName = 'Sell-to Customer No_'; }
        field(4; "Type"; code[20]) { ExternalName = 'Type'; }
        field(5; "No_"; code[20]) { ExternalName = 'No_'; }
        field(6; "Location Code"; code[20]) { ExternalName = 'Location Code'; }
        field(7; "Posting Group"; code[20]) { ExternalName = 'Posting Group'; }
        field(8; "Shipment Date"; code[20]) { ExternalName = 'Shipment Date'; }
        field(9; "Description"; code[20]) { ExternalName = 'Description'; }
        field(10; "Description 2"; code[20]) { ExternalName = 'Description 2'; }
        field(11; "Unit of Measure"; code[20]) { ExternalName = 'Unit of Measure'; }
        field(12; "Quantity"; code[20]) { ExternalName = 'Quantity'; }
        field(13; "Unit Price"; code[20]) { ExternalName = 'Unit Price'; }
        field(14; "Unit Cost (LCY)"; code[20]) { ExternalName = 'Unit Cost (LCY)'; }
        field(15; "VAT _"; code[20]) { ExternalName = 'VAT _'; }
        field(16; "Line Discount _"; code[20]) { ExternalName = 'Line Discount _'; }
        field(17; "Line Discount Amount"; code[20]) { ExternalName = 'Line Discount Amount'; }
        field(18; "Amount"; code[20]) { ExternalName = 'Amount'; }
        field(19; "Amount Including VAT"; code[20]) { ExternalName = 'Amount Including VAT'; }
        field(20; "Allow Invoice Disc_"; code[20]) { ExternalName = 'Allow Invoice Disc_'; }
        field(21; "Gross Weight"; code[20]) { ExternalName = 'Gross Weight'; }
        field(22; "Net Weight"; code[20]) { ExternalName = 'Net Weight'; }
        field(23; "Units per Parcel"; code[20]) { ExternalName = 'Units per Parcel'; }
        field(24; "Unit Volume"; code[20]) { ExternalName = 'Unit Volume'; }
        field(25; "Appl_-to Item Entry"; code[20]) { ExternalName = 'Appl_-to Item Entry'; }
        field(26; "Shortcut Dimension 1 Code"; code[20]) { ExternalName = 'Shortcut Dimension 1 Code'; }
        field(27; "Shortcut Dimension 2 Code"; code[20]) { ExternalName = 'Shortcut Dimension 2 Code'; }
        field(28; "Customer Price Group"; code[20]) { ExternalName = 'Customer Price Group'; }
        field(29; "Job No_"; code[20]) { ExternalName = 'Job No_'; }
        field(30; "Work Type Code"; code[20]) { ExternalName = 'Work Type Code'; }
        field(31; "Shipment No_"; code[20]) { ExternalName = 'Shipment No_'; }
        field(32; "Shipment Line No_"; code[20]) { ExternalName = 'Shipment Line No_'; }
        field(33; "Order No_"; code[20]) { ExternalName = 'Order No_'; }
        field(34; "Order Line No_"; code[20]) { ExternalName = 'Order Line No_'; }
        field(35; "Bill-to Customer No_"; code[20]) { ExternalName = 'Bill-to Customer No_'; }
        field(36; "Inv_ Discount Amount"; code[20]) { ExternalName = 'Inv_ Discount Amount'; }
        field(37; "Drop Shipment"; code[20]) { ExternalName = 'Drop Shipment'; }
        field(38; "Gen_ Bus_ Posting Group"; code[20]) { ExternalName = 'Gen_ Bus_ Posting Group'; }
        field(39; "Gen_ Prod_ Posting Group"; code[20]) { ExternalName = 'Gen_ Prod_ Posting Group'; }
        field(40; "VAT Calculation Type"; code[20]) { ExternalName = 'VAT Calculation Type'; }
        field(41; "Transaction Type"; code[20]) { ExternalName = 'Transaction Type'; }
        field(42; "Transport Method"; code[20]) { ExternalName = 'Transport Method'; }
        field(43; "Attached to Line No_"; code[20]) { ExternalName = 'Attached to Line No_'; }
        field(44; "Exit Point"; code[20]) { ExternalName = 'Exit Point'; }
        field(45; "Area"; code[20]) { ExternalName = 'Area'; }
        field(46; "Transaction Specification"; code[20]) { ExternalName = 'Transaction Specification'; }
        field(47; "Tax Category"; code[20]) { ExternalName = 'Tax Category'; }
        field(48; "Tax Area Code"; code[20]) { ExternalName = 'Tax Area Code'; }
        field(49; "Tax Liable"; code[20]) { ExternalName = 'Tax Liable'; }
        field(50; "Tax Group Code"; code[20]) { ExternalName = 'Tax Group Code'; }
        field(51; "VAT Clause Code"; code[20]) { ExternalName = 'VAT Clause Code'; }
        field(52; "VAT Bus_ Posting Group"; code[20]) { ExternalName = 'VAT Bus_ Posting Group'; }
        field(53; "VAT Prod_ Posting Group"; code[20]) { ExternalName = 'VAT Prod_ Posting Group'; }
        field(54; "Blanket Order No_"; code[20]) { ExternalName = 'Blanket Order No_'; }
        field(55; "Blanket Order Line No_"; code[20]) { ExternalName = 'Blanket Order Line No_'; }
        field(56; "VAT Base Amount"; code[20]) { ExternalName = 'VAT Base Amount'; }
        field(57; "Unit Cost"; code[20]) { ExternalName = 'Unit Cost'; }
        field(58; "System-Created Entry"; code[20]) { ExternalName = 'System-Created Entry'; }
        field(59; "Line Amount"; code[20]) { ExternalName = 'Line Amount'; }
        field(60; "VAT Difference"; code[20]) { ExternalName = 'VAT Difference'; }
        field(61; "VAT Identifier"; code[20]) { ExternalName = 'VAT Identifier'; }
        field(62; "IC Partner Ref_ Type"; code[20]) { ExternalName = 'IC Partner Ref_ Type'; }
        field(63; "IC Partner Reference"; code[20]) { ExternalName = 'IC Partner Reference'; }
        field(64; "Prepayment Line"; code[20]) { ExternalName = 'Prepayment Line'; }
        field(65; "IC Partner Code"; code[20]) { ExternalName = 'IC Partner Code'; }
        field(66; "Posting Date"; code[20]) { ExternalName = 'Posting Date'; }
        field(67; "Pmt_ Discount Amount"; code[20]) { ExternalName = 'Pmt_ Discount Amount'; }
        field(68; "Line Discount Calculation"; code[20]) { ExternalName = 'Line Discount Calculation'; }
        field(69; "Dimension Set ID"; code[20]) { ExternalName = 'Dimension Set ID'; }
        field(70; "Job Task No_"; code[20]) { ExternalName = 'Job Task No_'; }
        field(71; "Job Contract Entry No_"; code[20]) { ExternalName = 'Job Contract Entry No_'; }
        field(72; "Deferral Code"; code[20]) { ExternalName = 'Deferral Code'; }
        field(73; "Variant Code"; code[20]) { ExternalName = 'Variant Code'; }
        field(74; "Bin Code"; code[20]) { ExternalName = 'Bin Code'; }
        field(75; "Qty_ per Unit of Measure"; code[20]) { ExternalName = 'Qty_ per Unit of Measure'; }
        field(76; "Unit of Measure Code"; code[20]) { ExternalName = 'Unit of Measure Code'; }
        field(77; "Quantity (Base)"; code[20]) { ExternalName = 'Quantity (Base)'; }
        field(78; "FA Posting Date"; code[20]) { ExternalName = 'FA Posting Date'; }
        field(79; "Depreciation Book Code"; code[20]) { ExternalName = 'Depreciation Book Code'; }
        field(80; "Depr_ until FA Posting Date"; code[20]) { ExternalName = 'Depr_ until FA Posting Date'; }
        field(81; "Duplicate in Depreciation Book"; code[20]) { ExternalName = 'Duplicate in Depreciation Book'; }
        field(82; "Use Duplication List"; code[20]) { ExternalName = 'Use Duplication List'; }
        field(83; "Responsibility Center"; code[20]) { ExternalName = 'Responsibility Center'; }
        field(84; "Cross-Reference No_"; code[20]) { ExternalName = 'Cross-Reference No_'; }
        field(85; "Unit of Measure (Cross Ref_)"; code[20]) { ExternalName = 'Unit of Measure (Cross Ref_)'; }
        field(86; "Cross-Reference Type"; code[20]) { ExternalName = 'Cross-Reference Type'; }
        field(87; "Cross-Reference Type No_"; code[20]) { ExternalName = 'Cross-Reference Type No_'; }
        field(88; "Item Category Code"; code[20]) { ExternalName = 'Item Category Code'; }
        field(89; "Nonstock"; code[20]) { ExternalName = 'Nonstock'; }
        field(90; "Purchasing Code"; code[20]) { ExternalName = 'Purchasing Code'; }
        field(91; "Product Group Code"; code[20]) { ExternalName = 'Product Group Code'; }
        field(92; "Appl_-from Item Entry"; code[20]) { ExternalName = 'Appl_-from Item Entry'; }
        field(93; "Return Reason Code"; code[20]) { ExternalName = 'Return Reason Code'; }
        field(94; "Allow Line Disc_"; code[20]) { ExternalName = 'Allow Line Disc_'; }
        field(95; "Customer Disc_ Group"; code[20]) { ExternalName = 'Customer Disc_ Group'; }
        field(96; "Price description"; code[20]) { ExternalName = 'Price description'; }
        field(97; "Pmt_ Disc_ Given Amount (Old)"; code[20]) { ExternalName = 'Pmt_ Disc_ Given Amount (Old)'; }
        field(98; "EC _"; code[20]) { ExternalName = 'EC _'; }
        field(99; "EC Difference"; code[20]) { ExternalName = 'EC Difference'; }
        field(100; "Nombre Cliente"; code[20]) { ExternalName = 'Nombre Cliente'; }
        field(101; "Payment Discount _"; code[20]) { ExternalName = 'Payment Discount _'; }
        field(102; "AREAMANAGER"; code[20]) { ExternalName = 'AREAMANAGER'; }
        field(103; "Post Code"; code[20]) { ExternalName = 'Post Code'; }
        field(104; "County"; code[20]) { ExternalName = 'County'; }
        field(105; "grupocliente_btc"; code[20]) { ExternalName = 'grupocliente_btc'; }
        field(106; "Delegado_btc"; code[20]) { ExternalName = 'Delegado_btc'; }
        field(107; "Country_Region Code"; code[20]) { ExternalName = 'Country_Region Code'; }
        field(108; "Pais"; code[20]) { ExternalName = 'Pais'; }
        field(109; "Item Disc_ Group"; code[20]) { ExternalName = 'Item Disc_ Group'; }
        field(110; "ClienteActividad_btc"; code[20]) { ExternalName = 'ClienteActividad_btc'; }
        field(111; "subcliente_btc"; code[20]) { ExternalName = 'subcliente_btc'; }
        field(112; "clientereporting_btc"; code[20]) { ExternalName = 'clientereporting_btc'; }
        field(113; "InsideSales_btc"; code[20]) { ExternalName = 'InsideSales_btc'; }
        field(114; "salesperson code]"; code[20]) { ExternalName = 'salesperson code]'; }

        field(50999; ID; Guid)
        {
            Caption = 'ID';
            ExternalName = 'ID';
            ExternalType = 'Uniqueidentifier';
        }
    }

    keys
    {
        key(pk; No_)
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

    procedure CreateSalesItem()
    var
        Item: record Item;
        ABERTIASalesItem: Record "ABERTIA SalesItem";
        Suplemento: Integer;
        Window: Dialog;
    begin
        Window.Open('Nº Producto #1################');
        Item.Reset();
        ABERTIASalesItem.Reset();
        // GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if Item.FindFirst() then
            repeat
                Window.Update(1, Item."No.");
                item.CalcFields(desClasVtas_btc, desFamilia_btc, desGama_btc, desLineaEconomica_btc);
                if not ABERTIASalesItem.Get(Item."No.") then begin

                    ABERTIASalesItem.Init();
                    ABERTIASalesItem.ID := CreateGuid();
                end;
                ABERTIASalesItem."No_" := Item."No.";
                ABERTIASalesItem.ClasVtas_btc := Item.optClasVtas_btc;
                ABERTIASalesItem.Familia_btc := Item.optFamilia_btc;
                ABERTIASalesItem.Gama_btc := Item.optGama_btc;
                ABERTIASalesItem.Ordenacion_btc := Item.Ordenacion_btc;
                ABERTIASalesItem.ValidadoContabiliad_btc := Item.ValidadoContabiliad_btc;
                ABERTIASalesItem.OptClasVtas_btc := Item.OptClasVtas_btc;
                ABERTIASalesItem.OptFamilia_btc := Item.OptFamilia_btc;
                ABERTIASalesItem.OptGama_btc := Item.OptGama_btc;
                ABERTIASalesItem.ContraStock_BajoPedido := Item."ContraStock/BajoPedido";
                ABERTIASalesItem.PedidoMaximo := Item.PedidoMaximo;
                ABERTIASalesItem.selClasVtas_btc := Item.selClasVtas_btc;
                ABERTIASalesItem.selFamilia_btc := Item.selFamilia_btc;
                ABERTIASalesItem.selGama_btc := Item.selGama_btc;
                ABERTIASalesItem.selLineaEconomica_btc := Item.selLineaEconomica_btc;
                ABERTIASalesItem.ABC := Item.ABC;
                ABERTIASalesItem.TasaRAEE := Item.TasaRAEE;
                ABERTIASalesItem.ClasifVentas := Item.desClasVtas_btc;
                ABERTIASalesItem.Familia := Item.desFamilia_btc;
                ABERTIASalesItem.GAMA := Item.desGama_btc;
                ABERTIASalesItem.LineaEconomica := Item.desLineaEconomica_btc;
                ABERTIASalesItem.Canal := Item.Canal;
                if not ABERTIASalesItem.Insert() then
                    ABERTIASalesItem.Modify();

            Until Item.next() = 0;
        Window.Close();
    end;
}