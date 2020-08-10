codeunit 50113 "CambioDimensiones"
{
    Permissions = tabledata "Cust. Ledger Entry" = m, tabledata "Item Ledger Entry" = m, tabledata "Value Entry" = m,
        tabledata "Sales Shipment Header" = m, tabledata "Sales Shipment Line" = m, tabledata "Sales Invoice Header" = m,
        tabledata "Sales Invoice Line" = m, tabledata "G/L Entry" = m, tabledata "Sales Cr.Memo Header" = m,
        tabledata "Sales Cr.Memo Line" = m, tabledata "Cartera Doc." = m, tabledata "Posted Cartera Doc." = m,
        tabledata "Closed Cartera Doc." = m, tabledata "Return Shipment Header" = m, tabledata "Return Shipment Line" = m;

    trigger OnRun()
    begin
        IniciaCambioDimensiones();
    end;

    procedure IniciaCambioDimensiones()
    var
        recCustomer: Record Customer;
        recDefaultDim: Record "Default Dimension";
        recDimensionValue: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        GLSetup: Record "General Ledger Setup";
        cduDimMgt: Codeunit DimensionManagement;
        intDimSetId: Integer;
        GlobalDim1: code[20];
        GlobalDim2: code[20];
    begin
        recCustomer.Reset();
        if recCustomer.FindSet() then
            repeat
                // Borrar dimensiones excedentes
                recDefaultDim.Reset();
                recDefaultDim.SetRange("Table ID", Database::Customer);
                recDefaultDim.SetRange("No.", recCustomer."No.");
                recDefaultDim.SetFilter("Dimension Code", '%1|%2|%3|%4|%5|%6', 'AREA MANAGER', 'GRUPO-CLI', 'PAIS', 'PERFIL', 'SUB-CLI', 'DELEGACION');
                if recDefaultDim.FindFirst() then
                    recDefaultDim.DeleteAll();

                // Obtener nuevo dimension set id
                TempDimSetEntry.Reset();
                TempDimSetEntry.DeleteAll();
                intDimSetId := 0;

                recDefaultDim.Reset();
                recDefaultDim.SetRange("Table ID", Database::Customer);
                recDefaultDim.SetRange("No.", recCustomer."No.");
                if recDefaultDim.FindSet() then
                    repeat
                        if recDimensionValue.get(recDefaultDim."Dimension Code", recDefaultDim."Dimension Value Code") then begin
                            TempDimSetEntry.Init();
                            TempDimSetEntry."Dimension Code" := recDimensionValue."Dimension Code";
                            TempDimSetEntry."Dimension Value Code" := recDimensionValue.Code;
                            TempDimSetEntry."Dimension Value ID" := recDimensionValue."Dimension Value ID";
                            IF TempDimSetEntry.INSERT() THEN;
                        end;
                    until recDefaultDim.Next() = 0;

                TempDimSetEntry.Reset();
                if not TempDimSetEntry.IsEmpty() then begin
                    Clear(cduDimMgt);
                    intDimSetId := cduDimMgt.GetDimensionSetID(TempDimSetEntry);

                    // Actualizo las dimensiones globales del cliente
                    GLSetup.get();
                    GlobalDim1 := GetDimValueFromDimSetID(GLSetup."Global Dimension 1 Code", intDimSetId);
                    GlobalDim2 := GetDimValueFromDimSetID(GLSetup."Global Dimension 2 Code", intDimSetId);

                    recCustomer.Validate("Global Dimension 1 Code", GlobalDim1);
                    recCustomer.Validate("Global Dimension 2 Code", GlobalDim2);

                    recCustomer.Modify();

                    /*################################################################################################
                                        INICIO Modificar dimensiones de las tablas enlazadas
                    ################################################################################################*/

                    CustLedgerEntry(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");
                    SalesHeader(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");
                    SalesShipmentHeader(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");
                    SalesInvHeader(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");
                    SalesCrMemoHeader(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");
                    CarteraDoc(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");
                    PostedCarteraDoc(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");
                    ClosedCarteraDoc(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");
                    RetReceiptHeader(recCustomer."No.", intDimSetId, recCustomer."Global Dimension 1 Code", recCustomer."Global Dimension 2 Code");

                    /*################################################################################################
                                        FIN Modificar dimensiones de las tablas enlazadas
                    ################################################################################################*/
                end;
            until recCustomer.Next() = 0;
    end;

    local procedure RetReceiptHeader(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recRetReceiptHeader: Record "Return Receipt Header";
        recRetReceiptLine: Record "Return Receipt Line";
    begin
        recRetReceiptHeader.Reset();
        recRetReceiptHeader.SetRange("Sell-to Customer No.", pCodCliente);
        if recRetReceiptHeader.FindSet() then
            repeat
                recRetReceiptLine.Reset();
                recRetReceiptLine.SetRange("Document No.", recRetReceiptHeader."No.");
                if recRetReceiptLine.FindSet() then
                    repeat
                        recRetReceiptLine."Dimension Set ID" := pDimId;
                        recRetReceiptLine."Shortcut Dimension 1 Code" := pGlobal1;
                        recRetReceiptLine."Shortcut Dimension 2 Code" := pGlobal2;
                        recRetReceiptLine.Modify();
                    until recRetReceiptLine.Next() = 0;

                ItemLedgEntry(globalTipoMovProducto::Sale, globalTipoDocMovProducto::"Sales Return Receipt", recRetReceiptHeader."No.", pDimId, pGlobal1, pGlobal2);

                recRetReceiptHeader."Dimension Set ID" := pDimId;
                recRetReceiptHeader."Shortcut Dimension 1 Code" := pGlobal1;
                recRetReceiptHeader."Shortcut Dimension 2 Code" := pGlobal2;
                recRetReceiptHeader.Modify();
            until recRetReceiptHeader.Next() = 0;
    end;

    local procedure ClosedCarteraDoc(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recClosedCarteraDoc: Record "Closed Cartera Doc.";
    begin
        recClosedCarteraDoc.Reset();
        recClosedCarteraDoc.SetRange(Type, recClosedCarteraDoc.Type::Receivable);
        recClosedCarteraDoc.SetRange("Account No.", pCodCliente);
        if recClosedCarteraDoc.FindFirst() then begin
            recClosedCarteraDoc.modifyall("Dimension Set ID", pDimId);
            recClosedCarteraDoc.modifyall("Global Dimension 1 Code", pGlobal1);
            recClosedCarteraDoc.modifyall("Global Dimension 2 Code", pGlobal2);
        end;
    end;

    local procedure PostedCarteraDoc(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recPostCarteraDoc: Record "Posted Cartera Doc.";
    begin
        recPostCarteraDoc.Reset();
        recPostCarteraDoc.SetRange(Type, recPostCarteraDoc.Type::Receivable);
        recPostCarteraDoc.SetRange("Account No.", pCodCliente);
        if recPostCarteraDoc.FindFirst() then begin
            recPostCarteraDoc.modifyall("Dimension Set ID", pDimId);
            recPostCarteraDoc.modifyall("Global Dimension 1 Code", pGlobal1);
            recPostCarteraDoc.modifyall("Global Dimension 2 Code", pGlobal2);
        end;
    end;

    local procedure CarteraDoc(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recCarteraDoc: Record "Cartera Doc.";
    begin
        recCarteraDoc.Reset();
        recCarteraDoc.SetRange(Type, recCarteraDoc.Type::Receivable);
        recCarteraDoc.SetRange("Account No.", pCodCliente);
        if recCarteraDoc.FindFirst() then begin
            recCarteraDoc.modifyall("Dimension Set ID", pDimId);
            recCarteraDoc.modifyall("Global Dimension 1 Code", pGlobal1);
            recCarteraDoc.modifyall("Global Dimension 2 Code", pGlobal2);
        end;
    end;

    local procedure SalesCrMemoHeader(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recSalesCrMemoHdr: Record "Sales Cr.Memo Header";
        recSalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        recSalesCrMemoHdr.Reset();
        recSalesCrMemoHdr.SetRange("Sell-to Customer No.", pCodCliente);
        if recSalesCrMemoHdr.FindSet() then
            repeat
                recSalesCrMemoLine.Reset();
                recSalesCrMemoLine.SetRange("Document No.", recSalesCrMemoHdr."No.");
                if recSalesCrMemoLine.FindSet() then
                    repeat
                        recSalesCrMemoLine."Dimension Set ID" := pDimId;
                        recSalesCrMemoLine."Shortcut Dimension 1 Code" := pGlobal1;
                        recSalesCrMemoLine."Shortcut Dimension 2 Code" := pGlobal2;
                        recSalesCrMemoLine.Modify();
                    until recSalesCrMemoLine.Next() = 0;

                ItemLedgEntry(globalTipoMovProducto::Sale, globalTipoDocMovProducto::"Sales Credit Memo", recSalesCrMemoHdr."No.", pDimId, pGlobal1, pGlobal2);

                recSalesCrMemoHdr."Dimension Set ID" := pDimId;
                recSalesCrMemoHdr."Shortcut Dimension 1 Code" := pGlobal1;
                recSalesCrMemoHdr."Shortcut Dimension 2 Code" := pGlobal2;
                recSalesCrMemoHdr.Modify();

                GLEntry(recSalesCrMemoHdr."No.", recSalesCrMemoHdr."Posting Date", pDimId, pGlobal1, pGlobal2);
                ValueEntry(recSalesCrMemoHdr."No.", recSalesCrMemoHdr."Posting Date", pDimId, pGlobal1, pGlobal2);
            until recSalesCrMemoHdr.Next() = 0;
    end;

    local procedure GLEntry(pDocNo: code[20]; pFechaReg: Date; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recGlEntry: Record "G/L Entry";
    begin
        recGlEntry.Reset();
        recGlEntry.SetRange("Document No.", pDocNo);
        recGlEntry.SetRange("Posting Date", pFechaReg);
        if recGlEntry.FindFirst() then begin
            recGlEntry.ModifyAll("Dimension Set ID", pDimId);
            recGlEntry.ModifyAll("Global Dimension 1 Code", pGlobal1);
            recGlEntry.ModifyAll("Global Dimension 2 Code", pGlobal2);
        end;
    end;

    local procedure SalesInvHeader(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recSalesInvHeader: Record "Sales Invoice Header";
        recSalesInvLine: Record "Sales Invoice Line";
    begin
        recSalesInvHeader.Reset();
        recSalesInvHeader.SetRange("Sell-to Customer No.", pCodCliente);
        if recSalesInvHeader.FindSet() then
            repeat
                recSalesInvLine.Reset();
                recSalesInvLine.SetRange("Document No.", recSalesInvHeader."No.");
                if recSalesInvLine.FindSet() then
                    repeat
                        recSalesInvLine."Dimension Set ID" := pDimId;
                        recSalesInvLine."Shortcut Dimension 1 Code" := pGlobal1;
                        recSalesInvLine."Shortcut Dimension 2 Code" := pGlobal2;
                        recSalesInvLine.Modify();
                    until recSalesInvLine.Next() = 0;

                ItemLedgEntry(globalTipoMovProducto::Sale, globalTipoDocMovProducto::"Sales Invoice", recSalesInvHeader."No.", pDimId, pGlobal1, pGlobal2);

                recSalesInvHeader."Dimension Set ID" := pDimId;
                recSalesInvHeader."Shortcut Dimension 1 Code" := pGlobal1;
                recSalesInvHeader."Shortcut Dimension 2 Code" := pGlobal2;
                recSalesInvHeader.Modify();

                GLEntry(recSalesInvHeader."No.", recSalesInvHeader."Posting Date", pDimId, pGlobal1, pGlobal2);
                ValueEntry(recSalesInvHeader."No.", recSalesInvHeader."Posting Date", pDimId, pGlobal1, pGlobal2);
            until recSalesInvHeader.Next() = 0;
    end;

    local procedure ValueEntry(pDocNo: code[20]; pFechaReg: Date; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recValueEntry: Record "Value Entry";
    begin
        recValueEntry.Reset();
        recValueEntry.SetRange("Document No.", pDocNo);
        recValueEntry.SetRange("Posting Date", pFechaReg);
        if recValueEntry.FindFirst() then begin
            recValueEntry.ModifyAll("Dimension Set ID", pDimId);
            recValueEntry.ModifyAll("Global Dimension 1 Code", pGlobal1);
            recValueEntry.ModifyAll("Global Dimension 2 Code", pGlobal2);
        end;
    end;

    local procedure SalesShipmentHeader(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recSalesShptHdr: Record "Sales Shipment Header";
        recSalesShptLine: Record "Sales Shipment Line";
    begin
        recSalesShptHdr.Reset();
        recSalesShptHdr.SetRange("Sell-to Customer No.", pCodCliente);
        if recSalesShptHdr.FindSet() then
            repeat
                recSalesShptLine.Reset();
                recSalesShptLine.SetRange("Document No.", recSalesShptHdr."No.");
                if recSalesShptLine.FindSet() then
                    repeat
                        recSalesShptLine."Dimension Set ID" := pDimId;
                        recSalesShptLine."Shortcut Dimension 1 Code" := pGlobal1;
                        recSalesShptLine."Shortcut Dimension 2 Code" := pGlobal2;
                        recSalesShptLine.Modify();
                    until recSalesShptLine.Next() = 0;

                ItemLedgEntry(globalTipoMovProducto::Sale, globalTipoDocMovProducto::"Sales Shipment", recSalesShptHdr."No.", pDimId, pGlobal1, pGlobal2);

                recSalesShptHdr."Dimension Set ID" := pDimId;
                recSalesShptHdr."Shortcut Dimension 1 Code" := pGlobal1;
                recSalesShptHdr."Shortcut Dimension 2 Code" := pGlobal2;
                recSalesShptHdr.Modify();
            until recSalesShptHdr.Next() = 0;
    end;

    local procedure SalesHeader(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
    begin
        recSalesHeader.Reset();
        recSalesHeader.SetRange("Sell-to Customer No.", pCodCliente);
        if recSalesHeader.FindSet() then
            repeat
                recSalesLine.Reset();
                recSalesLine.SetRange("Document Type", recSalesHeader."Document Type");
                recSalesLine.SetRange("Document No.", recSalesHeader."No.");
                if recSalesLine.FindFirst() then
                    repeat
                        recSalesLine.Validate("Dimension Set ID", pDimId);
                        recSalesLine.Modify();
                    until recSalesLine.Next() = 0;

                recSalesHeader.validate("Dimension Set ID", pDimId);
                recSalesHeader.Modify();
            until recSalesHeader.Next() = 0;
    end;

    local procedure ItemLedgEntry(pEntryType: option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output"; pDocType: option " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly"; pNumDoc: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recItemLedgEntry: Record "Item Ledger Entry";
        recValueEntry: Record "Value Entry";
    begin
        recItemLedgEntry.Reset();
        recItemLedgEntry.SetRange("Entry Type", pEntryType);
        recItemLedgEntry.SetRange("Document Type", pDocType);
        recItemLedgEntry.SetRange("Document No.", pNumDoc);
        if recItemLedgEntry.FindSet() then
            repeat
                recValueEntry.Reset();
                recValueEntry.SetRange("Item Ledger Entry No.", recItemLedgEntry."Entry No.");
                if recValueEntry.FindFirst() then begin
                    recValueEntry.ModifyAll("Dimension Set ID", pDimId);
                    recValueEntry.ModifyAll("Global Dimension 1 Code", pGlobal1);
                    recValueEntry.ModifyAll("Global Dimension 2 Code", pGlobal2);
                end;

                recItemLedgEntry."Dimension Set ID" := pDimId;
                recItemLedgEntry."Global Dimension 1 Code" := pGlobal1;
                recItemLedgEntry."Global Dimension 2 Code" := pGlobal2;
                recItemLedgEntry.Modify();
            until recItemLedgEntry.Next() = 0;
    end;

    local procedure CustLedgerEntry(pCodCliente: code[20]; pDimId: Integer; pGlobal1: code[20]; pGlobal2: code[20])
    var
        recCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        recCustLedgerEntry.Reset();
        recCustLedgerEntry.SetRange("Customer No.", pCodCliente);
        if recCustLedgerEntry.FindFirst() then begin
            recCustLedgerEntry.ModifyAll("Dimension Set ID", pDimId);
            recCustLedgerEntry.ModifyAll("Global Dimension 1 Code", pGlobal1);
            recCustLedgerEntry.ModifyAll("Global Dimension 2 Code", pGlobal2);
        end;
    end;

    procedure GetDimValueFromDimSetID(DimCode: Code[20]; DimSetID: Integer): Code[20]
    var
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        IF DimCode = '' THEN
            EXIT;

        DimMgt.GetDimensionSet(TempDimSetEntry, DimSetID);

        TempDimSetEntry.RESET();
        TempDimSetEntry.SETRANGE("Dimension Code", DimCode);
        IF TempDimSetEntry.FINDFIRST() THEN
            EXIT(TempDimSetEntry."Dimension Value Code");
    end;

    var
        globalTipoMovProducto: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        globalTipoDocMovProducto: Option " ","Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Transfer Shipment","Transfer Receipt","Service Shipment","Service Invoice","Service Credit Memo","Posted Assembly";
}