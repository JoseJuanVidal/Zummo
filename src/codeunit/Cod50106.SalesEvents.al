codeunit 50106 "SalesEvents"
{
    Permissions = tabledata "Sales Shipment Header" = rm, tabledata "G/L Entry" = m, tabledata "Sales Invoice Header" = m, tabledata "Sales Cr.Memo Header" = m,
        tabledata "Sales Invoice Line" = m, tabledata "Sales Cr.Memo Line" = m, tabledata "Item Ledger Entry" = m, tabledata "Sales Shipment Line" = rmid,
        tabledata "Purch. Rcpt. Line" = rmid, tabledata "Value Entry" = rmid, tabledata "Post Value Entry to G/L" = rmid;

    [EventSubscriber(ObjectType::Page, Page::"Posted Purchase Receipt", 'OnAfterValidateEvent', 'Vendor Shipment No.', true, true)]
    local procedure P_136_OnAfterValidateEvent(var Rec: Record "Purch. Rcpt. Header"; var xRec: Record "Purch. Rcpt. Header")
    var
        recItemLedgEntry: Record "Item Ledger Entry";
    begin
        if (rec."Vendor Shipment No." <> '') and (rec."Vendor Shipment No." <> xRec."Vendor Shipment No.") then begin
            if Rec."No." = '' then
                exit;

            recItemLedgEntry.Reset();
            recItemLedgEntry.SetRange("Document No.", Rec."No.");
            recItemLedgEntry.SetRange("Posting Date", rec."Posting Date");
            if recItemLedgEntry.FindFirst() then
                recItemLedgEntry.ModifyAll("External Document No.", rec."Vendor Shipment No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Sales Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure ActualizarEmpleadoTab18OnBeforeInsertEvent(var Rec: Record "Sales Line")
    begin
        if rec.FechaAlta_btc = 0D THEN
            rec.FechaAlta_btc := Today;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Quantity', true, true)]
    //Autofacturas: Si es el propio cliente se emite facturas a costo.
    local procedure T37_OnAfterValidateEventQuantity(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if (Rec.Quantity <> xRec.Quantity) then
            if rec."Sell-to Customer No." = 'C00486' then begin
                if Rec."Unit Price" <> Rec."Unit Cost" then
                    Rec.Validate("Unit Price", Rec."Unit Cost");
            end;
    end;


    // Al registrar un documento de venta comprobamos que exista tipo de cambio
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure CU_80_OnBeforePostSalesDoc(VAR Sender: Codeunit "Sales-Post"; VAR SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        Location: record Location;  // R001
        SalesLine: Record "Sales Line";  //R001
        ErrorMsg: Label 'Warehouse %1 is configured to not allow "Send and Invoice completely", all lines are not sent completely.',
            Comment = 'ESP="El Almacén %1, esta configurado para no permitir "Enviar y Facturar completamente", todas las lineas no estan enviadas completamente."'; //R001
    begin
        // ZUMMO-JJV Cuando se registra una factura (Invoice=true), comprobar la numeración de el siguiente número con el historico de facturas
        // estan moviendose el siguiente numero de factura a una anterior.
        if not SalesHeader.IsTemporary and SalesHeader.Invoice then
            CheckSeriesNoInvovice(SalesHeader);

        // ====== SOTHIS , requrimiento de Maria Borrallo de no permitir registrar y facturar si 
        //  R001 - el cliente solicita que si el almacen de alguna linea es alguno no configurado para permitir 
        //        registrar , modo enviar y facturar, no permita FACTURAR
        // ==========================
        TestCamposPedidos(SalesHeader);
        TestTipoCambioDocumentVenta(SalesHeader);
        //IF (SalesHeader.Invoice) or (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) THEN begin
        GeneralLedgerSetup.FindFirst();
        if GeneralLedgerSetup.BloqueoVentas <> 0D THEN begin
            IF SalesHeader."Posting Date" < GeneralLedgerSetup.BloqueoVentas THEN
                Error('Período de facturación de ventas cerrada');
        END;
        //END;

        // +R001
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                begin
                    if SalesHeader.Invoice then begin
                        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                        SalesLine.SetRange("Document No.", SalesHeader."No.");
                        if SalesLine.findset() then
                            repeat
                                if Location.Get(SalesLine."Location Code") then
                                    if Location.RequiredShipinvoice then
                                        if SalesLine."Outstanding Quantity" > 0 then
                                            Error(ErrorMsg, Location.Code);
                            Until SalesLine.next() = 0;
                    end;
                end;
        end;
        // -R001
    end;

    local procedure CheckSeriesNoInvovice(SalesHeader: Record "Sales Header")
    var
        SalesInvHeader: Record "Sales Invoice Header";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        InvoiceNoSerie: code[20];
        Encontrado: Boolean;
        CountInc: Integer;
    begin
        // si ya tiene numero por un registro anterior
        if SalesHeader."Posting No." <> '' then
            exit;
        // pedimos el nuevo numero de serie, sin grabar que lo actualice
        InvoiceNoSerie := NoSeriesManagement.GetNextNo(SalesHeader."Posting No. Series", SalesHeader."Posting Date", false);
        if InvoiceNoSerie = '' then
            exit;
        //repeat
        Encontrado := false;
        if SalesInvHeader.Get(InvoiceNoSerie) then begin
            Encontrado := true;
            // si la encontramos en historico, grabamos ese numero y seguimos con el bucle
            InvoiceNoSerie := NoSeriesManagement.GetNextNo(SalesHeader."Posting No. Series", SalesHeader."Posting Date", true);
            // obtenemos la siguiente
            InvoiceNoSerie := NoSeriesManagement.GetNextNo(SalesHeader."Posting No. Series", SalesHeader."Posting Date", false);
            CountInc += 1;
        end
        //until (Encontrado = false) or (CountInc > 3);

    end;

    //No borre Pedido al Facturarlo
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', true, true)]
    local procedure CU_80_OnBeforeDeleteAfterPosting(VAR SalesHeader: Record "Sales Header"; VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR SkipDelete: Boolean; CommitIsSuppressed: Boolean);
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SkipDelete := true;
    end;

    // Al lanzar un documento de venta comprobamos que exista tipo de cambio
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeManualReleaseSalesDoc', '', true, true)]
    local procedure CU_414_OnBeforeManualReleaseSalesDoc(VAR SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        TestTipoCambioDocumentVenta(SalesHeader);
        TestCamposPedidos(SalesHeader); //Control campos obligatorios pedidos
    end;



    local procedure TestTipoCambioDocumentVenta(var SalesHeader: Record "Sales Header")
    var
        cduDivisas: Codeunit Funciones;
        fechaDivisa: Date;
        lbErrorDivisaErr: Label 'No exchange rate is found for currency: %1 and date: %2 %3: %4',
            comment = 'ESP="No se encuentra tipo de cambio para divisa: %1 y fecha: %2 %3: %4"';
    begin
        Clear(cduDivisas);

        if cduDivisas.GetActivaDivisasFechaEmision() then
            fechaDivisa := SalesHeader."Document Date"
        else
            fechaDivisa := SalesHeader."Posting Date";

        if not cduDivisas.ExisteTipoCambio(SalesHeader."Currency Code", fechaDivisa) then
            Error(StrSubstNo(lbErrorDivisaErr, SalesHeader."Currency Code", fechaDivisa, Format(SalesHeader."Document Type"), SalesHeader."No."));
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Blocked', true, true)]
    local procedure T_18_OnAfterValidateBlocked(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    begin
        if (Rec.Blocked <> xRec.Blocked) and (Rec.Blocked = Rec.Blocked::" ") then
            rec.CodMotivoBloqueo_btc := '';
    end;

    // Al registrar una factura de servicio con líneas de tipo cuenta, modificamos descripción del movimiento contable
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post", 'OnBeforePostWithLines', '', true, true)]
    local procedure CU_5980_OnBeforePostWithLines(var PassedServHeader: Record "Service Header"; var PassedServLine: Record "Service Line"; var PassedShip: Boolean; var PassedConsume: Boolean; var PassedInvoice: Boolean)
    var
        recServLine: Record "Service Line";
    begin
        recServLine.Reset();
        recServLine.SetRange("Document Type", PassedServHeader."Document Type");
        recServLine.SetRange("Document No.", PassedServHeader."No.");
        recServLine.setrange(Type, recServLine.Type::"G/L Account");
        recServLine.SetFilter(Description, '<>%1', '');
        recServLine.SetFilter("No.", '<>%1&<>%2', '7591000', '6021000');
        if recServLine.FindFirst() and (PassedServHeader."Posting Description" <> recServLine.Description) then
            PassedServHeader."Posting Description" := recServLine.Description;
    end;


    // Al registrar una factura de venta con líneas de tipo cuenta, modificamos descripción del movimiento contable
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', true, true)]
    local procedure CU_89_OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        recSalesLine: Record "Sales Line";
        SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
        AmountWithDiscountAllowed: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        SalesLine: record "Sales Line";
        InvoiceDiscountAmount: Decimal;
        Currency: record Currency;
    begin
        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", SalesHeader."No.");
        recSalesLine.setrange(Type, recSalesLine.Type::"G/L Account");
        recSalesLine.SetFilter(Description, '<>%1', '');
        recSalesLine.SetFilter("No.", '<>%1&<>%2', '7591000', '6021000');
        if recSalesLine.FindFirst() and (SalesHeader."Posting Description" <> recSalesLine.Description) then
            SalesHeader."Posting Description" := recSalesLine.Description;
        // 165118 - realizar el calculo de dto de factura, por si no estan las lineas correctas        
        if SalesHeader.DescuentoFactura <> 0 then begin
            Currency.InitRoundingPrecision;
            recSalesLine.reset;
            recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
            recSalesLine.SetRange("Document No.", SalesHeader."No.");
            recSalesLine.FindFirst();
            AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(recSalesLine);
            InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * SalesHeader.DescuentoFactura / 100, Currency."Amount Rounding Precision");
            SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        end;
    end;

    // Al registrar una factura de compra con líneas de tipo cuenta, modificamos la descripbión del movimiento contable  // ESTHER 165090
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    local procedure CU_90_OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        recPurchLine: Record "Purchase Line";
    begin
        recPurchLine.Reset();
        recPurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        recPurchLine.SetRange("Document No.", PurchaseHeader."No.");
        recPurchLine.setrange(Type, recPurchLine.Type::"G/L Account");
        recPurchLine.SetFilter("No.", '<>%1&<>%2', '7591000', '6021000');
        recPurchLine.SetFilter(Description, '<>%1', '');
        if recPurchLine.FindFirst() and (PurchaseHeader."Posting Description" <> recPurchLine.Description) then
            PurchaseHeader."Posting Description" := recPurchLine.Description;
    end;



    // Tener en cuenta las ofertas de venta en la hoja de planificación
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnBeforeBlanketOrderConsumpFind', '', true, true)]
    local procedure CU_99000854_OnBeforeBlanketOrderConsumpFind(var BlanketSalesLine: Record "Sales Line")
    var
    begin

        BlanketSalesLine.SetFilter("Document Type", '%1|%2', BlanketSalesLine."Document Type"::"Blanket Order", BlanketSalesLine."Document Type"::Quote);
        BlanketSalesLine.SetFilter(FechaFinValOferta_btc, '=%1|>=%2', 0D, WorkDate());
    end;

    // Si no tiene prioridad y es una oferta, establecemos la prioridad nosotros
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnAfterSetOrderPriority', '', true, true)]
    local procedure CU_99000854_OnAfterSetOrderPriority(var InventoryProfile: Record "Inventory Profile")
    begin
        if (InventoryProfile."Order Priority" = 0) and (InventoryProfile."Source Type" = DATABASE::"Sales Line") and (InventoryProfile."Source Order Status" = 0) then
            InventoryProfile."Order Priority" := 200;
    end;

    //Actualizar fecha de envío al calcular la hoja de planificación
    [EventSubscriber(ObjectType::Table, Database::"Inventory Profile", 'OnAfterTransferFromSalesLine', '', true, true)]
    local procedure T_99000853_OnAfterTransferFromSalesLine(var InventoryProfile: Record "Inventory Profile"; SalesLine: Record "Sales Line")
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        fechaEnvio: Date;
    begin
        if SalesLine."Document Type" = SalesLine."Document Type"::Quote then begin
            recSalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");

            if recSalesHeader.NumDias_btc > 0 then begin
                recSalesLine.Reset();
                recSalesLine.SetRange("Document Type", recSalesHeader."Document Type");
                recSalesLine.SetRange("Document No.", recSalesHeader."No.");
                recSalesLine.SetRange("Line No.", SalesLine."Line No.");
                if recSalesLine.FindFirst() then begin
                    //Días laborables
                    //fechaEnvio := CalcDate('<+' + format(recSalesHeader.NumDias_btc) + 'D>', WorkDate());
                    fechaEnvio := GetResFechaLaborables(recSalesHeader.NumDias_btc, WorkDate());

                    recSalesLine."Shipment Date" := fechaEnvio;
                    recSalesLine.Modify();
                end;
            end;
        end;
    end;

    //Al entrar en la oferta, actualizamos la fecha de envío de las líneas
    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnAfterGetRecordEvent', '', true, true)]
    local procedure P_41_OnAfterGetRecordEvent(var Rec: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        fechaEnvio: Date;
    begin
        if Rec.NumDias_btc = 0 then
            exit;
        //Días laborables
        //fechaEnvio := CalcDate('<+' + format(Rec.NumDias_btc) + 'D>', WorkDate());
        fechaEnvio := GetResFechaLaborables(rec.NumDias_btc, WorkDate());

        rec."Shipment Date" := fechaEnvio;

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", Rec."Document Type");
        recSalesLine.SetRange("Document No.", Rec."No.");
        if recSalesLine.FindFirst() then
            recSalesLine.modifyall("Shipment Date", fechaEnvio);
    end;



    //Rellenar la fecha final válida oferta al insertar la oferta
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure T_36_OnAfterInsertEvent(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        if Rec."Document Type" = Rec."Document Type"::Quote then begin
            //Días laborables
            rec."Quote Valid Until Date" := GetResFechaLaborables(5, WorkDate());

            if Rec.Modify() then;
        end;
    end;

    //Al validar el nº de días, cambiamos las fechas de envío
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'NumDias_btc', true, true)]
    local procedure T_36_OnAfterValidateNumDias_btc(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        recSalesLine: Record "Sales Line";
    begin
        if (Rec."Document Type" = Rec."Document Type"::Quote) and (rec.NumDias_btc <> 0) then begin
            rec.validate("Shipment Date", GetResFechaLaborables(rec.NumDias_btc, WorkDate()));
            if rec.Modify() then;

            recSalesLine.Reset();
            recSalesLine.SetRange("Document Type", Rec."Document Type");
            recSalesLine.SetRange("Document No.", Rec."No.");
            if recSalesLine.FindFirst() then
                recSalesLine.modifyall("Shipment Date", rec."Shipment Date");
        end;
    end;

    //Calcula una suma de fechas con días laborables
    procedure GetResFechaLaborables(pNumDias: Integer; pFecha: Date): Date
    var
        recDate: Record Date;
        fechaResult: Date;
        i: Integer;
        CalendarManegment: Codeunit "Calendar Management";
        textovacio: text;
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if pNumDias = 0 then
            exit(0D);
        SalesSetup.Get();
        recDate.Reset();
        recDate.SetRange("Period Type", recDate."Period Type"::Date);
        recDate.SetFilter("Period Start", '%1..', pFecha + 1);
        if recDate.FindSet() then
            repeat
                //if (recDate."Period No." <> 6) and (recDate."Period No." <> 7) then begin
                if not CalendarManegment.CheckDateStatus(SalesSetup.CalendarioOfertas, recDate."Period Start", textovacio) then begin
                    fechaResult := recDate."Period Start";
                    i += 1;
                end;
            until (recDate.Next() = 0) or (i >= pNumDias);

        exit(fechaResult);
    end;

    //OnAfterCopySellToCustomerAddressFieldsFromCustomer
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', true, true)]
    local procedure T_36_OnAfterCopySellToCustomerAddressFieldsFromCustomer(VAR SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer)
    begin
        SalesHeader."Transaction Specification" := SellToCustomer."Transaction Specification";
        SalesHeader."Transaction Type" := SellToCustomer."Transaction Type";
        SalesHeader."Transport Method" := SellToCustomer."Transport Method";
        SalesHeader."Exit Point" := SellToCustomer."Exit Point";
        SalesHeader."Shipment Method Code" := SellToCustomer."Shipment Method Code";
    end;

    //Precio personalizado en líneas de venta estándar
    [EventSubscriber(ObjectType::Table, Database::"Standard Customer Sales Code", 'OnBeforeApplyStdCodesToSalesLines', '', true, true)]
    local procedure T_172_OnBeforeApplyStdCodesToSalesLines(var SalesLine: Record "Sales Line"; StdSalesLine: Record "Standard Sales Line")
    begin
        if StdSalesLine.Precio_btc <> 0 then
            SalesLine.validate("Unit Price", StdSalesLine.Precio_btc);
    end;

    //Control campos obligatorios pedidos
    local procedure TestCamposPedidos(var pSalesHeader: Record "Sales Header")
    var
        lbConf: Label 'The total order amount is 0\Do you want to continue?', comment = 'ESP="El importe total del pedido es 0\¿Desea continuar?"';
    begin
        pSalesHeader.TESTFIELD("Payment Method Code");
        pSalesHeader.TESTFIELD("Payment Terms Code");
        pSalesHeader.TestField("Due Date");

        if pSalesHeader."Document Type" = pSalesHeader."Document Type"::Order then begin
            pSalesHeader.TestField(ClienteReporting_btc);
            pSalesHeader.TestField(AreaManager_btc);
            pSalesHeader.TestField(Delegado_btc);
            //pSalesHeader.TestField(InsideSales_btc);
            pSalesHeader.TestField(GrupoCliente_btc);
            pSalesHeader.TestField(Perfil_btc);
            pSalesHeader.TestField("Promised Delivery Date");
            pSalesHeader.TestField("Shipment Date");

            pSalesHeader.CalcFields(Amount);

            if pSalesHeader.Amount = 0 then
                if not Confirm(lbConf) then
                    Error('');
        end;
    end;



    //Control campos obligatorios pedidos (En la versión actual de zummo no existe evento al crear recepción de almacén)
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeActionEvent', 'Post', true, true)]
    local procedure Pag_50_OnBeforeActionEvent_Post(var Rec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.reset;
        SalesLine.SetRange("Document No.", Rec."No.");
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.Setrange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Qty. to Ship", '>0');
        if SalesLine.FindFirst() then
            exit;

        SalesLine.SetRange("Qty. to Ship");
        SalesLine.SetFilter("Qty. to Invoice", '>0');
        if SalesLine.FindFirst() then
            exit;

        if not Confirm('No hay producto, esta seguro que desea registrar?') then
            Error('Proceso cancelado');

    end;

    //Fechas pedido venta. Lo hacemos desde la page para no mostrar mensaje estándar
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Order Date', true, true)]
    local procedure T_36_OnBefreValidateOrderDate(VAR Rec: Record "Sales Header"; VAR xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if (rec."Order Date" <> xRec."Order Date") and (rec."Document Type" = rec."Document Type"::Order) then
            ValidaFechaAltaLinPedido(Rec);
    end;

    //Fechas pedido venta
    local procedure ValidaFechaAltaLinPedido(var pSalesHeader: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        lbConfirmQst: Label 'You have changed the registration date\Do you want to change the registration date also on the lines?',
            comment = 'ESP="Ha cambiado la fecha de alta\¿Desea cambiar la fecha de alta también en las líneas?"';
    begin
        pSalesHeader.TestStatusOpen();
        pSalesHeader.SetHideValidationDialog(true);

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", pSalesHeader."No.");
        recSalesLine.SetFilter("No.", '<>%1', '');
        if recSalesLine.FindFirst() then begin
            if not Confirm(lbConfirmQst) then
                exit;

            recSalesLine.ModifyAll(FechaAlta_btc, pSalesHeader."Order Date");
        end;
    end;
    //Fechas pedido venta. Lo hacemos desde la page para no mostrar mensaje estándar
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Shipment Date', true, true)]
    local procedure T_36_OnBefreValidateShipmentDate(VAR Rec: Record "Sales Header"; VAR xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if (rec."Shipment Date" <> xRec."Shipment Date") and (rec."Document Type" = rec."Document Type"::Order) then
            ValidaFechaEnvioLinPedido(Rec);
    end;

    //Fechas pedido venta
    local procedure ValidaFechaEnvioLinPedido(var pSalesHeader: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        lbConfirmQst: Label 'You have changed the shipment date\Do you want to change the registration date also on the lines?',
            comment = 'ESP="Ha cambiado la fecha de envío\¿Desea cambiar la fecha de envío también en las líneas?"';
    begin
        pSalesHeader.TestStatusOpen();
        pSalesHeader.SetHideValidationDialog(true);

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", pSalesHeader."No.");
        recSalesLine.SetFilter("No.", '<>%1', '');
        if recSalesLine.FindFirst() then begin
            if not Confirm(lbConfirmQst) then
                exit;

            recSalesLine.ModifyAll("Shipment Date", pSalesHeader."Shipment Date");
        end;
    end;
    //Fechas pedido venta. Lo hacemos desde la page para no mostrar mensaje estándar
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Requested Delivery Date', true, true)]
    local procedure T_36_OnBefreValidateRequestedDate(VAR Rec: Record "Sales Header"; VAR xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        // TODO error ventas al cambiar la fecha de request
        // if (rec."Requested Delivery Date" <> xRec."Requested Delivery Date") and (rec."Document Type" = rec."Document Type"::Order) then
        //     ValidaFechaRequeridaLinPedido(Rec);
    end;

    //Fechas pedido venta
    local procedure ValidaFechaRequeridaLinPedido(var pSalesHeader: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        lbConfirmQst: Label 'You have changed the requested delivey date\Do you want to change the registration date also on the lines?',
            comment = 'ESP="Ha cambiado la fecha de entrega requerida\¿Desea cambiar la fecha de entrega requerida también en las líneas?"';
    begin
        pSalesHeader.TestStatusOpen();
        pSalesHeader.SetHideValidationDialog(true);

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", pSalesHeader."No.");
        recSalesLine.SetFilter("No.", '<>%1', '');
        if recSalesLine.FindFirst() then begin
            if not Confirm(lbConfirmQst) then
                exit;

            recSalesLine.ModifyAll("Requested Delivery Date", pSalesHeader."Requested Delivery Date");
        end;
    end;
    //Fechas pedido venta. Lo hacemos desde la page para no mostrar mensaje estándar
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Promised Delivery Date', true, true)]
    local procedure T_36_OnBefreValidatePromisedDate(VAR Rec: Record "Sales Header"; VAR xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        // TODO error ventas al cambiar la fecha prometida
        // if (rec."Promised Delivery Date" <> xRec."Promised Delivery Date") and (rec."Document Type" = rec."Document Type"::Order) then
        //     ValidaFechaPrometidaLinPedido(Rec);
    end;

    //Fechas pedido venta
    local procedure ValidaFechaPrometidaLinPedido(var pSalesHeader: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        lbConfirmQst: Label 'You have changed the promised delivey date\Do you want to change the registration date also on the lines?',
            comment = 'ESP="Ha cambiado la fecha de entrega prometida\¿Desea cambiar la fecha de entrega prometida también en las líneas?"';
    begin
        pSalesHeader.TestStatusOpen();
        pSalesHeader.SetHideValidationDialog(true);

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", pSalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", pSalesHeader."No.");
        recSalesLine.SetFilter("No.", '<>%1', '');
        if recSalesLine.FindFirst() then begin
            if not Confirm(lbConfirmQst) then
                exit;

            recSalesLine.ModifyAll("Promised Delivery Date", pSalesHeader."Promised Delivery Date");
        end;
    end;



    //Validar productos
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterInsertEvent', '', true, true)]
    local procedure T_27_OnAfterInsertEvent(var Rec: Record Item; RunTrigger: Boolean)
    begin
        Rec.Validate(Blocked, true);
    end;

    //Guardar Nº asiento/factura
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure CU_80_OnAfterPostSalesDoc(VAR SalesHeader: Record "Sales Header"; VAR GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        recGlEntry: Record "G/L Entry";
        recSalesInvHeader: Record "Sales Invoice Header";
        recSalesCrMemHeader: Record "Sales Cr.Memo Header";
        ServiceHeader: Record "Service Header";
        Customer: Record Customer; //S20/00375
        ZummoInnICFunctions: Codeunit "Zummo Inn. IC Functions";
    begin
        //Si tiene Pedido de Servicio Asociado cambio estado a Finalizado y anoto numero de Albaran

        //Guardar Nº asiento/factura

        if (SalesInvHdrNo <> '') or (SalesCrMemoHdrNo <> '') then
            if SalesInvHdrNo <> '' then begin
                recSalesInvHeader.Get(SalesInvHdrNo);

                recGlEntry.Reset();
                recGlEntry.SetRange("Posting Date", recSalesInvHeader."Posting Date");
                recGlEntry.SetRange("Document No.", recSalesInvHeader."No.");
            end else begin
                recSalesCrMemHeader.Get(SalesCrMemoHdrNo);

                recGlEntry.Reset();
                recGlEntry.SetRange("Posting Date", recSalesCrMemHeader."Posting Date");
            end;
        if (SalesInvHdrNo <> '') or (SalesCrMemoHdrNo <> '') then
            if SalesInvHdrNo <> '' then begin

                recSalesInvHeader.Reset();
                recSalesInvHeader.SetRange("No.", SalesInvHdrNo);
                if not recSalesInvHeader.FindFirst() then
                    exit;

                Customer.get(recSalesInvHeader."Bill-to Customer No.");
                if not Customer.PermiteEnvioMail_btc then
                    exit;

                recSalesInvHeader.CorreoEnviado_btc := false;
                recSalesInvHeader.FacturacionElec_btc := true;
                recSalesInvHeader.Modify();
            end else begin

                recSalesCrMemHeader.Reset();
                recSalesCrMemHeader.SetRange("No.", SalesCrMemoHdrNo);
                if not recSalesCrMemHeader.FindFirst() then
                    exit;

                Customer.get(recSalesCrMemHeader."Bill-to Customer No.");
                if not Customer.PermiteEnvioMail_btc then
                    exit;

                recSalesCrMemHeader.get(SalesCrMemoHdrNo);
                recSalesCrMemHeader.CorreoEnviado_btc := false;
                recSalesCrMemHeader.FacturacionElec_btc := true;
                recSalesCrMemHeader.Modify();

            end;

        //ACV 27/06/22 Zummo IC - Enviar notificacion por correo al registrar albaran
        if SalesHeader."Source Purch. Order No" <> '' then
            if SalesShptHdrNo <> '' then
                ZummoInnICFunctions.SendMailOnPostShipment(SalesHeader, SalesShptHdrNo);

    end;

    //Descuento cargos producto
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', true, true)]
    local procedure T_37_OnAfterUpdateAmountsDone(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    var
        recItemCharge: Record "Item Charge";
    begin
        exit;
    end;



    //Personalizaciones servicios
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post (Yes/No)", 'OnAfterPost', '', true, true)]
    local procedure CU_5981_OnAfterPost(var PassedServiceHeader: Record "Service Header")
    var
        recServiceItemLine: Record "Service Item Line";
    begin
        if PassedServiceHeader."Document Type" = PassedServiceHeader."Document Type"::Order then begin
            recServiceItemLine.Reset();
            recServiceItemLine.SetRange("Document Type", PassedServiceHeader."Document Type");
            recServiceItemLine.SetRange("Document No.", PassedServiceHeader."No.");
            if recServiceItemLine.FindFirst() then
                recServiceItemLine.ModifyAll("Service Shelf No.", '');
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Service Item Line", 'OnAfterValidateEvent', 'Service Item No.', true, true)]
    local procedure ServiceItemLine_OnAfterValidateEvent_ServiceItemLineNo(var Rec: Record "Service Item Line"; var xRec: Record "Service Item Line"; CurrFieldNo: Integer)
    var
        ServiceItem: Record "Service Item";
    begin
        if Rec.IsTemporary then
            exit;
        if ServiceItem.Get(Rec."Service Item No.") then begin
            if ServiceItem."Mostrar aviso pedido servicio" then
                Message(ServiceItem."Aviso pedido servicio");
        end;
    end;



    //Comentarios lotes hist factura venta
    procedure CreaComentariosLoteHistFaVenta(var pSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        recSalesInvoiceLine: Record "Sales Invoice Line";
        RecMemLotes: Record MemEstadistica_btc temporary;
        recSalesInvLineAux: Record "Sales Invoice Line";
        NSerie_Lbl: Label 'Serial No.:', Comment = 'ESP="Nº de Serie:",FRA="Numéro de série:"';
        intNumLinea: integer;
    begin
        if pSalesInvoiceHeader.ComSerieLoteCreados_btc then
            exit;

        recSalesInvoiceLine.Reset();
        recSalesInvoiceLine.SetRange("Document No.", pSalesInvoiceHeader."No.");
        recSalesInvoiceLine.SetRange(Type, recSalesInvoiceLine.Type::Item);
        if recSalesInvoiceLine.FindSet() then
            repeat
                intNumLinea := recSalesInvoiceLine."Line No.";

                RecMemLotes.Reset();
                RecMemLotes.DeleteAll();
                RetrieveLotAndExpFromPostedInv(recSalesInvoiceLine.RowID1(), RecMemLotes);

                RecMemLotes.Reset();
                if RecMemLotes.FindSet() then
                    repeat
                        intNumLinea += 1;

                        recSalesInvLineAux.Init();
                        recSalesInvLineAux."Document No." := recSalesInvoiceLine."Document No.";
                        recSalesInvLineAux."Line No." := intNumLinea;
                        recSalesInvLineAux.Description := NSerie_Lbl + ' ' + RecMemLotes.NoSerie;
                        recSalesInvLineAux.LineaComentarioSerie := true;
                        recSalesInvLineAux.Insert();
                    until RecMemLotes.Next() = 0;
            until recSalesInvoiceLine.Next() = 0;

        pSalesInvoiceHeader.ComSerieLoteCreados_btc := true;
        pSalesInvoiceHeader.Modify();
    end;

    local procedure RetrieveLotAndExpFromPostedInv(InvoiceRowID: Text[250]; VAR RecMemEstadisticas: Record MemEstadistica_btc temporary)
    var
        ValueEntryRelation: Record "Value Entry Relation";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        NumMov: Integer;
    begin
        RecMemEstadisticas.RESET();
        RecMemEstadisticas.DELETEALL();
        NumMov := 1;

        ValueEntryRelation.SETCURRENTKEY("Source RowId");
        ValueEntryRelation.SETRANGE("Source RowId", InvoiceRowID);
        IF ValueEntryRelation.FINDFIRST() THEN
            REPEAT
                ValueEntry.GET(ValueEntryRelation."Value Entry No.");
                ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
                ItemLedgEntry.CALCFIELDS("Sales Amount (Actual)");
                RecMemEstadisticas.RESET();
                RecMemEstadisticas.SETRANGE(NoLote, ItemLedgEntry."Serial No.");
                IF NOT RecMemEstadisticas.FINDFIRST() THEN BEGIN
                    RecMemEstadisticas.INIT();
                    RecMemEstadisticas.NoMov := NumMov;
                    NumMov += 1;
                    RecMemEstadisticas.NoLote := ItemLedgEntry."Lot No.";
                    RecMemEstadisticas.NoSerie := ItemLedgEntry."Serial No.";
                    RecMemEstadisticas.Noproducto := ItemLedgEntry."Item No.";
                    RecMemEstadisticas.INSERT();
                END;
            UNTIL ValueEntryRelation.NEXT() = 0;
    end;

    //Cambiar fechas cartera doc al validar la de la cabecera
    [EventSubscriber(ObjectType::Page, Page::"Bill Groups", 'OnAfterValidateEvent', 'Posting Date', true, true)]
    local procedure P_7000009_OnAfterValidatePostingDate(var Rec: Record "Bill Group"; var xRec: Record "Bill Group")
    var
        recCarteraDoc: Record "Cartera Doc.";
        confirm_Lbl: Label 'Registration date changed\Do you want to update the lines?', Comment = 'ESP="Ha cambiado la fecha de registro\¿Desea actualizar las líneas?"';
    begin
        if (rec."Posting Date" <> xrec."Posting Date") and (rec."Posting Date" <> 0D) then
            if Confirm(confirm_Lbl) then begin
                recCarteraDoc.Reset();
                recCarteraDoc.SetRange(Type, recCarteraDoc.Type::Receivable);
                recCarteraDoc.SetRange("Collection Agent", recCarteraDoc."Collection Agent"::Bank);
                recCarteraDoc.SetRange("Bill Gr./Pmt. Order No.", rec."No.");
                if recCarteraDoc.FindFirst() then
                    recCarteraDoc.ModifyAll("Due Date", rec."Posting Date");
            end;
    end;

    [EventSubscriber(ObjectType::Page, page::"Payment Orders", 'OnBeforeActionEvent', 'Export', false, false)]
    local procedure PaymentOrders_OnBeforeActionEvent(var Rec: Record "Payment Order")
    var
        CarteraDoc: record "Cartera Doc.";
    begin
        CarteraDoc.Reset();
        CarteraDoc.SetRange(Type, CarteraDoc.Type::Payable);
        //CarteraDoc.SetRange("Collection Agent", CarteraDoc."Collection Agent"::Bank);
        CarteraDoc.SetRange("Bill Gr./Pmt. Order No.", rec."No.");
        CarteraDoc.SetFilter("Due Date", '<%1', Today);
        if CarteraDoc.FindFirst() then
            CarteraDoc.ModifyAll("Due Date", Today);
    end;

    //Validar % amortización
    [EventSubscriber(ObjectType::Table, Database::"FA Depreciation Book", 'OnAfterValidateEvent', 'FA Posting Group', true, true)]
    local procedure T_5612_OnAfterValidatePostingGroup(var Rec: Record "FA Depreciation Book"; var xRec: Record "FA Depreciation Book"; CurrFieldNo: Integer)
    var
        recFaPostingGroup: Record "FA Posting Group";
        confQst: Label 'The registration group has a depreciation percentage set up\Do you want to autocomplete the percentage in the fixed asset?',
            Comment = 'ESP="El grupo registro tiene configurado un porcentaje de amortización\¿Desea autocompletar el porcentaje en el activo fijo?"';
    begin
        if (rec."FA Posting Group" <> '') and
                (rec."FA Posting Group" <> xRec."FA Posting Group") and
                (recFaPostingGroup.Get(rec."FA Posting Group")) and
                (recFaPostingGroup.PorcAmort_btc <> 0) and
                (rec."Straight-Line %" = 0) then
            if Confirm(confQst) then
                rec.validate("Straight-Line %", recFaPostingGroup.PorcAmort_btc);
    end;

    //Replicar campos 50000 ventas
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', true, true)]
    local procedure T_36_OnAfterValidateCustomer(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        RecCustomer: record Customer;
    begin
        if (rec."Sell-to Customer No." <> '') and (rec."Sell-to Customer No." <> xRec."Sell-to Customer No.") then
            TraspasaCamposVentas(Rec, rec."Sell-to Customer No.");

        //Si el cliente tiene marcado "Alerta Maquina" que les salte un aviso
        IF RecCustomer.GET(rec."Sell-to Customer No.") then
            IF RecCustomer.AlertaMaquina <> '' then
                Message(RecCustomer.AlertaMaquina)
    end;

    // =============       T_5900_OnAfterValidateCustomer Alerta Mensaje productos de servicio        ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    [EventSubscriber(ObjectType::Table, Database::"Service Header", 'OnAfterValidateEvent', 'Customer No.', true, true)]
    local procedure T_5900_OnAfterValidateCustomer(var Rec: Record "Service Header"; var xRec: Record "Service Header"; CurrFieldNo: Integer)
    var
        RecCustomer: record Customer;
        lblMsg: Label 'Customer %1 %2 has an Alert.\%3', comment = 'ESP="El cliente %1 %2 tiene una Alerta.\%3"';
    begin
        //Si el cliente tiene marcado "Alerta Maquina" que les salte un aviso
        IF RecCustomer.GET(rec."Customer No.") then
            IF RecCustomer.AlertaPedidoServicio <> '' then
                Message(StrSubstNo(lblMsg, RecCustomer."No.", RecCustomer.Name, RecCustomer.AlertaPedidoServicio));
    end;


    local procedure TraspasaCamposVentas(var pSalesHeader: Record "Sales Header"; pCodCliente: Code[20])
    var
        recCustomer: Record Customer;
    begin
        if not recCustomer.get(pCodCliente) then
            exit;

        psalesheader.CentralCompras_btc := reccustomer.CentralCompras_btc;
        psalesheader.ClienteCorporativo_btc := reccustomer.ClienteCorporativo_btc;
        psalesheader.AreaManager_btc := reccustomer.AreaManager_btc;
        pSalesHeader.InsideSales_btc := recCustomer.InsideSales_btc;
        pSalesHeader.Canal_btc := recCustomer.Canal_btc;
        psalesheader.Delegado_btc := reccustomer.Delegado_btc;
        psalesheader.GrupoCliente_btc := reccustomer.GrupoCliente_btc;
        psalesheader.Perfil_btc := reccustomer.Perfil_btc;
        psalesheader.SubCliente_btc := reccustomer.SubCliente_btc;
        psalesheader.ClienteReporting_btc := reccustomer.ClienteReporting_btc;
        pSalesHeader."Sell-to Search Name" := recCustomer."Search Name";
    end;

    //Insertar descuentos personalizados al facturar líneas de albarán
    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLine', '', true, true)]
    local procedure T_111_OnBeforeInsertInvLineFromShptLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; SalesOrderLine: Record "Sales Line")
    begin
        SalesLine."DecLine Discount1 %_btc" := SalesShptLine."DecLine Discount1 %_btc";
        SalesLine."DecLine Discount2 %_btc" := SalesShptLine."DecLine Discount2 %_btc";
    end;

    //Al registrar factura obtener peso, bultos etc
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', TRUE, true)]
    local procedure CU_80_OnAfterPostSalesDoc2(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        recSalesInvLine: Record "Sales Invoice Line";
        recTemp: Record "Aging Band Buffer" temporary;
        recCabPedido: Record "Sales Header";
        recArchPedido: Record "Sales Header Archive";
        recSalesShptHeader: Record "Sales Shipment Header";
        recSalesInvHeader: Record "Sales Invoice Header";
        codAlb: Code[20];
        decBultos: Decimal;
        decPeso: Decimal;
        decPalets: Decimal;
    begin
        if SalesInvHdrNo = '' then
            exit;

        recTemp.Reset();
        recTemp.DeleteAll();

        recSalesInvLine.Reset();
        recSalesInvLine.SetRange("Document No.", SalesInvHdrNo);
        recSalesInvLine.SetFilter("Shipment No.", '<>%1', '');
        if recSalesInvLine.FindSet() then
            repeat
                if not recTemp.Get(recSalesInvLine."Shipment No.") then begin
                    recTemp.Init();
                    recTemp."Currency Code" := recSalesInvLine."Shipment No.";
                    recTemp.Insert();
                end;
            until recSalesInvLine.Next() = 0;


        recSalesInvLine.Reset();
        recSalesInvLine.SetRange("Document No.", SalesInvHdrNo);
        recSalesInvLine.SetFilter("Order No.", '<>%1', '');
        if recSalesInvLine.FindSet() then
            repeat
                codAlb := '';

                recCabPedido.Reset();
                recCabPedido.SetRange("Document Type", recCabPedido."Document Type"::Order);
                recCabPedido.SetRange("No.", recSalesInvLine."Order No.");
                if recCabPedido.FindFirst() then
                    codAlb := recCabPedido."Last Shipping No."
                else begin
                    recArchPedido.Reset();
                    recArchPedido.SetRange("Document Type", recArchPedido."Document Type"::Order);
                    recArchPedido.SetRange("No.", recSalesInvLine."Order No.");
                    if recArchPedido.FindLast() then
                        codAlb := recArchPedido."Last Shipping No.";
                end;

                if codAlb <> '' then
                    if not recTemp.Get(codAlb) then begin
                        recTemp.Init();
                        recTemp."Currency Code" := codAlb;
                        recTemp.Insert();
                    end;
            until recSalesInvLine.Next() = 0;

        decBultos := 0;
        decPalets := 0;
        decPeso := 0;

        recTemp.Reset();
        if recTemp.FindSet() then
            repeat
                if recSalesShptHeader.Get(recTemp."Currency Code") then begin
                    decBultos += recSalesShptHeader.NumBultos_btc;
                    decPeso += recSalesShptHeader.Peso_btc;
                    decPalets += recSalesShptHeader.NumPalets_btc;
                end;
            until recTemp.Next() = 0;

        if (decBultos <> 0) or (decPalets <> 0) or (decPeso <> 0) then begin
            recSalesInvHeader.Reset();
            recSalesInvHeader.SetRange("No.", SalesInvHdrNo);
            if recSalesInvHeader.FindFirst() then begin
                recSalesInvHeader.NumBultos_btc := decBultos;
                recSalesInvHeader.NumPalets_btc := decPalets;
                recSalesInvHeader.Peso_btc := decPeso;

                recSalesInvHeader.Modify();
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', true, true)]
    local procedure CDU_80_OnAfterPostLines(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; var SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean)
    var
        Item: Record Item;
        recItemJnlLine: Record "Item Journal Line";
        recSalesLine: Record "Sales Line";
        recTempEnsambladosDeshacer: Record "Aging Band Buffer" temporary;
        recItemLedgEntry: Record "Item Ledger Entry";
        recItLedgEntPostitivo: Record "Item Ledger Entry";
        recPostAss: Record "Posted Assemble-to-Order Link";
        intNumLinea: integer;
    begin
        // btc control de abonos y deshacer entradas de conjuntos
        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Return Order") and (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo") then
            exit;

        recTempEnsambladosDeshacer.Reset();
        recTempEnsambladosDeshacer.DeleteAll();

        recSalesLine.Reset();
        recSalesLine.SetRange("Document Type", SalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", SalesHeader."No.");
        recSalesLine.SetRange(Type, recSalesLine.Type::Item);
        recSalesLine.SetFilter("No.", '<>%1', '');
        if recSalesLine.FindSet() then
            repeat
                // controlar que el producto es de ensamblado, sino no hace nada
                // Email de abono FVA2209090, que hace un ajuste positivo de la lineas de ensamblado de otra línea
                if Item.Get(recSalesLine."No.") and (Item."Replenishment System" in [Item."Replenishment System"::Assembly]) then begin
                    if recItemLedgEntry.Get(recSalesLine."Appl.-from Item Entry") and (recItemLedgEntry."Document Type" = recItemLedgEntry."Document Type"::"Sales Shipment") then begin
                        recPostAss.Reset();
                        recPostAss.SetRange("Document Type", recPostAss."Document Type"::"Sales Shipment");
                        recPostAss.SetRange("Document No.", recItemLedgEntry."Document No.");
                        recPostAss.SetRange("Document Line No.", recItemLedgEntry."Document Line No.");
                        if recPostAss.FindSet() then
                            repeat
                                if not recTempEnsambladosDeshacer.Get(recPostAss."Assembly Document No.") then begin
                                    // Me quedo con los ensamblados afectados
                                    recTempEnsambladosDeshacer.Init();
                                    recTempEnsambladosDeshacer."Currency Code" := recPostAss."Assembly Document No.";
                                    recTempEnsambladosDeshacer.Insert();

                                    // Ajuste negativo al resultado del ensamblado
                                    recItemJnlLine.Reset();
                                    if recItemJnlLine.FindLast() then
                                        intNumLinea := recItemJnlLine."Line No." + 1000
                                    else
                                        intNumLinea := 10000;

                                    recItemJnlLine.Init();

                                    recItemJnlLine."Line No." := intNumLinea;
                                    recItemJnlLine.Validate("Posting Date", Today);
                                    recItemJnlLine."Entry Type" := recItemJnlLine."Entry Type"::"Negative Adjmt.";
                                    recItemJnlLine."Document No." := recPostAss."Assembly Document No.";
                                    recItemJnlLine.Validate("Item No.", recSalesLine."No.");
                                    recItemJnlLine.Validate("Location Code", recSalesLine."Location Code");

                                    if recSalesLine."Bin Code" <> '' then
                                        recItemJnlLine.Validate("Bin Code", recSalesLine."Bin Code");

                                    recItemJnlLine.Validate(Quantity, recSalesLine.Quantity);
                                    recItemJnlLine.validate("Unit of Measure Code", recSalesLine."Unit of Measure Code");

                                    recItLedgEntPostitivo.Reset();
                                    recItLedgEntPostitivo.SetRange("Entry Type", recItLedgEntPostitivo."Entry Type"::Sale);
                                    recItLedgEntPostitivo.SetRange("Item No.", recSalesLine."No.");
                                    recItLedgEntPostitivo.SetRange("Document Type", recItLedgEntPostitivo."Document Type"::"Sales Return Receipt");
                                    recItLedgEntPostitivo.SetRange("Document No.", ReturnReceiptHeader."No.");
                                    recItLedgEntPostitivo.SetRange(Open, true);
                                    if recItLedgEntPostitivo.FindFirst() then
                                        recItemJnlLine.Validate("Applies-to Entry", recItLedgEntPostitivo."Entry No.");

                                    codeunit.Run(codeunit::"Item Jnl.-Post Line", recItemJnlLine);
                                end;
                            until recPostAss.Next() = 0;
                    end;
                end;
            until recSalesLine.next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptLineInsert', '', true, true)]
    local procedure CDU_80_OnBeforeSalesShptLineInsert(var SalesShptLine: Record "Sales Shipment Line"; SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    var
        recSalesShptHeader: Record "Sales Shipment Header";
    begin
        recSalesShptHeader.Reset();
        recSalesShptHeader.SetRange("No.", SalesShptHeader."No.");
        if recSalesShptHeader.FindFirst() then begin
            recSalesShptHeader.Peso_btc += SalesShptLine."Gross Weight" * SalesShptLine.Quantity;
            recSalesShptHeader.Modify();
        end;
        // JJV 12/2/2021 actualizamos los campos de la linea de total Base linea y Total importe linea
        SalesShptLineInsertUpdateField(SalesShptLine, SalesLine)
    end;

    procedure SalesShptLineInsertUpdateModifyField(var SalesShptLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line")
    begin
        SalesShptLineInsertUpdateField(SalesShptLine, SalesLine);
        SalesShptLine.Modify();
        Commit();
    end;

    Local procedure SalesShptLineInsertUpdateField(var SalesShptLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";

    begin
        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;
        SalesShptLine.BaseImponibleLinea := (SalesShptLine.Quantity * SalesLine."Unit Price") -
            ((SalesShptLine.Quantity * SalesLine."Unit Price") * SalesLine."Line Discount %" / 100);
        if (SalesHeader.DescuentoFactura <> 0) and (SalesLine."Allow Invoice Disc.") then
            SalesShptLine.BaseImponibleLinea -= (SalesShptLine.BaseImponibleLinea * SalesHeader.DescuentoFactura / 100);
        SalesShptLine.TotalImponibleLinea := SalesShptLine.BaseImponibleLinea + (SalesShptLine.BaseImponibleLinea * SalesLine."VAT %" / 100);
    end;

    // =============     Añadimos en el historico de lineas de facturas los datos de clasificación para BI'S          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', true, true)]
    local procedure SalesPost_OnBeforeSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    begin
        if not SalesInvLine.IsTemporary then
            UpdateSalesInvoiceLine_ClasifItem(SalesInvLine);
    end;

    Local procedure UpdateSalesInvoiceLine_ClasifItem(var Rec: Record "Sales Invoice Line")
    var
        Item: Record Item;
    begin
        if item.Get(Rec."No.") then begin
            Item.CalcFields(desClasVtas_btc, desFamilia_btc, desGama_btc);
            Rec.selClasVtas_btc := Item.selClasVtas_btc;
            Rec.selFamilia_btc := Item.selFamilia_btc;
            Rec.selGama_btc := Item.selGama_btc;
            Rec.desClasVtas_btc := Item.desClasVtas_btc;
            Rec.desFamilia_btc := Item.desFamilia_btc;
            Rec.desGama_btc := Item.desGama_btc;
        end;
    end;

    procedure UpdateSalesInvoiceLine_ClasifItems()
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        Window: Dialog;
        lblWindow: Label 'Invoice no.: #1############################', comment = 'ESP="Factura Nº: #1############################"';
    begin
        Window.Open(lblWindow);
        if SalesInvoiceLine.FindFirst() then
            repeat
                Window.Update(1, SalesInvoiceLine."Document No.");
                UpdateSalesInvoiceLine_ClasifItem(SalesInvoiceLine);
                SalesInvoiceLine.Modify();
            Until SalesInvoiceLine.next() = 0;
        Window.Close();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesCrMemoLineInsert', '', true, true)]
    local procedure SalesPost_OnBeforeSalesCrMemoLineInsert(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean)
    begin
        if not SalesCrMemoLine.IsTemporary then
            UpdateSalesCRMemoLine_ClasifItem(SalesCrMemoLine);
    end;

    Local procedure UpdateSalesCRMemoLine_ClasifItem(var Rec: Record "Sales Cr.Memo Line")
    var
        Item: Record Item;
    begin
        if item.Get(Rec."No.") then begin
            Item.CalcFields(desClasVtas_btc, desFamilia_btc, desGama_btc);
            Rec.selClasVtas_btc := Item.selClasVtas_btc;
            Rec.selFamilia_btc := Item.selFamilia_btc;
            Rec.selGama_btc := Item.selGama_btc;
            Rec.desClasVtas_btc := Item.desClasVtas_btc;
            Rec.desFamilia_btc := Item.desFamilia_btc;
            Rec.desGama_btc := Item.desGama_btc;
        end;
    end;

    procedure UpdateSalesCRMemoLine_ClasifItems()
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        Window: Dialog;
        lblWindow: Label 'Invoice no.: #1############################', comment = 'ESP="Factura Nº: #1############################"';
    begin
        Window.Open(lblWindow);
        if SalesCrMemoLine.FindFirst() then
            repeat
                Window.Update(1, SalesCrMemoLine."Document No.");
                UpdateSalesCRMemoLine_ClasifItem(SalesCrMemoLine);
                SalesCrMemoLine.Modify();
            Until SalesCrMemoLine.next() = 0;
        Window.Close();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptLineInsert', '', true, true)]
    local procedure CDU_90_OnBeforePurchRcptLineInsert(VAR PurchRcptLine: Record "Purch. Rcpt. Line"; VAR PurchRcptHeader: Record "Purch. Rcpt. Header"; VAR PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean)
    var
        recSalesShptHeader: Record "Sales Shipment Header";
    begin

        // JJV 12/2/2021 actualizamos los campos de la linea de total Base linea y Total importe linea
        PurchRcptLineInsertUpdateField(PurchRcptLine, PurchLine)
    end;

    procedure PurchRcptLineInsertUpdateModifyField(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchLine: Record "Purchase Line")
    begin
        PurchRcptLineInsertUpdateField(PurchRcptLine, PurchLine);
        PurchRcptLine.Modify();
        Commit();
    end;

    local procedure PurchRcptLineInsertUpdateField(var PurchRcptLine: Record "Purch. Rcpt. Line"; PurchLine: Record "Purchase Line")
    begin
        PurchRcptLine.BaseImponibleLinea := (PurchRcptLine.Quantity * PurchLine."Direct Unit Cost") -
            ((PurchLine.Quantity * PurchLine."Direct Unit Cost") * PurchLine."Line Discount %" / 100);
        PurchRcptLine.TotalImponibleLinea := PurchRcptLine.BaseImponibleLinea + (PurchRcptLine.BaseImponibleLinea * PurchLine."VAT %" / 100);
    end;

    procedure GetTipoBloqueoProducto(pCodProducto: Code[20]; var StyleExpBloqueado: Text): Text
    var
        recItem: Record Item;
    begin
        if not recItem.get(pCodProducto) then
            exit('');

        if recItem.Blocked or recItem."Sales Blocked" then
            StyleExpBloqueado := 'Unfavorable';
        if recItem.Blocked then
            Exit('Bloqueado');

        if recItem."Sales Blocked" then
            exit('Bloqueado Ventas');

        exit('');
    end;

    // Al copiar líneas de venta, copiamos los campos personalizados
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertToSalesLine', '', true, true)]
    local procedure CDU_6620_OnBeforeInsertToSalesLine(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line"; FromDocType: Option; RecalcLines: Boolean; var ToSalesHeader: Record "Sales Header")
    begin
        if FromSalesLine."DecLine Discount1 %_btc" <> 0 then
            ToSalesLine.Validate("DecLine Discount1 %_btc", FromSalesLine."DecLine Discount1 %_btc");

        if FromSalesLine."DecLine Discount2 %_btc" <> 0 then
            ToSalesLine.Validate("DecLine Discount2 %_btc", FromSalesLine."DecLine Discount2 %_btc");


        if FromSalesLine.FechaAlta_btc <> 0D then
            ToSalesLine.FechaAlta_btc := FromSalesLine.FechaAlta_btc;

        if FromSalesLine.FechaFinValOferta_btc <> 0D then
            ToSalesLine.FechaFinValOferta_btc := FromSalesLine.FechaFinValOferta_btc;

        ToSalesLine.MotivoRetraso_btc := FromSalesLine.MotivoRetraso_btc;
        ToSalesLine."Tariff No_btc" := FromSalesLine."Tariff No_btc";
        ToSalesLine.TextoMotivoRetraso_btc := FromSalesLine.TextoMotivoRetraso_btc;
    end;

    // Al copiar cabecera copio los campos personalizados
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeModifySalesHeader', '', true, true)]
    local procedure CDU_6620_OnBeforeModifySalesHeader(var ToSalesHeader: Record "Sales Header"; FromDocType: Option; FromDocNo: Code[20]; IncludeHeader: Boolean; FromDocOccurenceNo: Integer; FromDocVersionNo: Integer)
    var
        OldSalesHeader: Record "Sales Header";
    begin
        if not IncludeHeader then
            exit;

        OldSalesHeader.Reset();
        OldSalesHeader.SetRange("Document Type", FromDocType);
        OldSalesHeader.SetRange("No.", FromDocNo);
        if not OldSalesHeader.FindFirst() then
            exit;

        ToSalesHeader.AreaManager_btc := OldSalesHeader.AreaManager_btc;
        ToSalesHeader.CentralCompras_btc := OldSalesHeader.CentralCompras_btc;
        ToSalesHeader.ClienteCorporativo_btc := OldSalesHeader.ClienteCorporativo_btc;
        ToSalesHeader.ClienteReporting_btc := OldSalesHeader.ClienteReporting_btc;
        ToSalesHeader.ComentarioInterno_btc := OldSalesHeader.ComentarioInterno_btc;
        ToSalesHeader.InsideSales_btc := OldSalesHeader.InsideSales_btc;
        ToSalesHeader.Delegado_btc := OldSalesHeader.Delegado_btc;
        ToSalesHeader.GrupoCliente_btc := OldSalesHeader.GrupoCliente_btc;
        ToSalesHeader.ImpresoAlmacen_btc := OldSalesHeader.ImpresoAlmacen_btc;
        ToSalesHeader.MotivoBloqueo_btc := OldSalesHeader.MotivoBloqueo_btc;
        ToSalesHeader.NumDias_btc := OldSalesHeader.NumDias_btc;
        ToSalesHeader."Sell-to Search Name" := OldSalesHeader."Sell-to Search Name";

        ToSalesHeader.Perfil_btc := OldSalesHeader.Perfil_btc;
        ToSalesHeader.SubCliente_btc := OldSalesHeader.SubCliente_btc;
        if ToSalesHeader.Modify() then;

    end;

    // cuando modifican una linea de la oferta/Pedido, cambiamos en la cabecera el campo de Aviso al salir del form
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', true, true)]
    local procedure T_36_OnAfterModifyEvent(var Rec: Record "Sales Line"; RunTrigger: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec.IsTemporary then
            exit;
        case Rec."Document Type" of
            Rec."Document Type"::Quote, Rec."Document Type"::Order:
                begin
                    if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then begin
                        if SalesHeader."Aviso Oferta bajo pedido" then begin
                            SalesHeader."Aviso Oferta bajo pedido" := false;
                            SalesHeader.Modify();
                        end;
                    end;
                end;
        end

    end;

    // Al crear cabecera ventas autorrellenar campo area
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', true, true)]
    local procedure T_36_OnBeforeInsertEvent(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var
        recSalesSetup: Record "Sales & Receivables Setup";
    begin
        recSalesSetup.Get();
        if recSalesSetup.CodProvinciaDefecto_btc <> '' then
            Rec.Area := recSalesSetup.CodProvinciaDefecto_btc;

        if Rec."Document Type" = rec."Document Type"::Order then
            rec.FechaAltaPedido := Today;
    end;

    /*  [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
      local procedure SalesLineOnAfterUpdateAmountsDone(VAR SalesLine: Record "Sales Line"; VAR xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
      var
          SalesHeader: Record "Sales Header";
          Item: Record Item;
          GLAccount: Record "G/L Account";
          Currency: record Currency;
          SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
          AmountWithDiscountAllowed: Decimal;
          DocumentTotals: Codeunit "Document Totals";
          InvoiceDiscountAmount: Decimal;
          LineAmountToInvoice: Decimal;
      begin
          // 165118 - Calcular a las lineas el dto de factura por importe aplicado en el campo Sales header 50199 % Dto Factura
          if SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.") then begin
              Currency.InitRoundingPrecision;
              // Calcular en la linea el descuento de pronto pago
              if SalesHeader.DescuentoProntoPago <> 0 then
                  SalesLine."Pmt. Discount Amount" := ROUND(((SalesLine."Line Amount" - SalesLine."Inv. Discount Amount") * SalesHeader.DescuentoProntoPago / 100)
                              , Currency."Amount Rounding Precision");
              if SalesHeader.DescuentoFactura <> 0 then begin
                  if SalesLine.Quantity <> 0 then begin
                      IF SalesHeader."Invoice Discount Calculation" = SalesHeader."Invoice Discount Calculation"::Amount then begin
                          case SalesLine.Type of
                              SalesLine.Type::Item:
                                  begin
                                      if item.get(SalesLine."No.") then begin
                                          if item."Allow Invoice Disc." then begin
                                              SalesLine."Inv. Discount Amount" := ROUND((SalesLine."Line Amount" * SalesHeader.DescuentoFactura / 100)
                                                          , Currency."Amount Rounding Precision");
                                              LineAmountToInvoice := ROUND(SalesLine."Line Amount" * SalesLine."Qty. to Invoice" / SalesLine.Quantity, Currency."Amount Rounding Precision");
                                              SalesLine."Inv. Disc. Amount to Invoice" := ROUND((LineAmountToInvoice * SalesHeader.DescuentoFactura / 100)
                                                                          , Currency."Amount Rounding Precision");
                                          end;
                                      end;
                                  end;
                                  SalesLine.Type::"G/L Account":
                                  begin
                                      if GLAccount.Get(SalesLine."No.")then begin 
                                          if GLAccount.InvoiceDiscountAllowed() then begin 
                                             SalesLine."Inv. Discount Amount" := ROUND((SalesLine."Line Amount" * SalesHeader.DescuentoFactura / 100)
                                                          , Currency."Amount Rounding Precision");
                                              LineAmountToInvoice := ROUND(SalesLine."Line Amount" * SalesLine."Qty. to Invoice" / SalesLine.Quantity, Currency."Amount Rounding Precision");
                                              SalesLine."Inv. Disc. Amount to Invoice" := ROUND((LineAmountToInvoice * SalesHeader.DescuentoFactura / 100)
                                                                          , Currency."Amount Rounding Precision");  
                                          end;
                                      end;
                                  end;
                          end;

                      end else begin

                      end;
                  end;

              end;
          end;
      end;*/

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterAssignGLAccountValues', '', false, false)]
    local procedure SalesLineOnAfterAssignGLAccountValues(VAR SalesLine: Record "Sales Line"; GLAccount: Record "G/L Account")
    var
        SalesHeader: Record "Sales Header";
        AccountTranslation: Record "Account Translation";
    begin
        //171241
        case SalesLine.Type of
            SalesLine.Type::"G/L Account":
                begin
                    if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                        if SalesHeader."Language Code" <> '' then
                            if AccountTranslation.GET(SalesLine."No.", SalesHeader."Language Code") then begin
                                SalesLine.Description := AccountTranslation.Description;
                                SalesLine."Description 2" := AccountTranslation."Description 2";
                            end;
                end;
        end;
    end;

    // Ticket INTRASTAT que se incluya los envios a paises union europea, en INTRASTAT, aunque direccion envio sea opción personalizada, no pone pais mov producto
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeGetCountryCode', '', True, True)]
    local procedure SalesPostOnBeforeGetCountryCode(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; VAR CountryRegionCode: Code[10]; VAR IsHandled: Boolean)
    Var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if SalesLine."Shipment No." <> '' then begin
            SalesShipmentHeader.GET(SalesLine."Shipment No.");
            if SalesShipmentHeader."Ship-to Code" = '' then
                if SalesHeader."Ship-to Country/Region Code" = SalesShipmentHeader."Ship-to Country/Region Code" then
                    exit;
            CountryRegionCode := SalesShipmentHeader."Ship-to Country/Region Code";
        end else begin
            if SalesHeader."Ship-to Code" = '' then
                if SalesHeader."Ship-to Country/Region Code" = SalesShipmentHeader."Ship-to Country/Region Code" then
                    exit;
            CountryRegionCode := SalesHeader."Ship-to Country/Region Code";
        end;
        IsHandled := true;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure T_32_OnAfterInsertEvent(var Rec: Record "Cust. Ledger Entry"; RunTrigger: Boolean)
    begin
        Rec.FechaVtoAsegurador := CalcDate('+60D', Rec."Due Date");
        rec.Modify();
    end;

    // ============= 15/12/2022     Control de Creación pedidos de Servicio         ====================
    // ==  
    // ==  cuando se crea un pedido de servicio, poner en dirección de envío la misma dirección de envio que la ficha de cliente
    // ==  
    // ======================================================================================================
    [EventSubscriber(ObjectType::Table, Database::"Service Header", 'OnAfterValidateEvent', 'Customer No.', true, true)]
    local procedure ServiceHeader_OnAfterValidateEvent_CustomerNo(var Rec: Record "Service Header"; var xRec: Record "Service Header"; CurrFieldNo: Integer)
    var
        Customer: Record Customer;
    begin
        if Rec.IsTemporary then
            exit;
        // buscamos el clientes y hacemos validate del campos "Ship-to Code"
        if Customer.Get(Rec."Customer No.") then
            if Customer."Ship-to Code" <> '' then
                if Rec."Ship-to Code" <> Customer."Ship-to Code" then
                    Rec.Validate("Ship-to Code", Customer."Ship-to Code");

    end;

    // =============     NORMATIVA PLASTICO          ====================
    // ==  
    // ==  Eventos respecto a la normativa de plastico
    // ==   Packing list - al registrar un pedido de venta y crear un albaran, si existe packing list creado lo pasamos al albaran y 
    // ==   y se elimina del pedido de venta
    // ==          SalesPost_OnAfterSalesShptHeaderInsert
    // ==  
    // ==  
    // ======================================================================================================

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptHeaderInsert', '', true, true)]
    // local procedure SalesPost_OnAfterSalesShptHeaderInsert(var SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; SuppressCommit: Boolean)
    // begin
    //     if SalesShipmentHeader.IsTemporary then
    //         exit;
    //     // cambiamos el packing list del pedido de venta al albaran        
    //     UpdatePackingListOrdertoShipment(SalesShipmentHeader, SalesHeader);

    // end;

    // local procedure UpdatePackingListOrdertoShipment(SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header")
    // var
    //     SalesOrderPacking: Record "ZM Sales Order Packing";
    //     SalesShipmentPacking: Record "ZM Sales Order Packing";
    // begin
    //     SalesShipmentPacking.Reset();
    //     SalesShipmentPacking.SetRange("Document type", SalesShipmentPacking."Document type"::"Sales Shipment");
    //     SalesShipmentPacking.SetRange("Document No.", SalesShipmentHeader."No.");
    //     SalesShipmentPacking.DeleteAll();

    //     SalesOrderPacking.Reset();
    //     SalesOrderPacking.SetRange("Document type", SalesOrderPacking."Document type"::Order);
    //     SalesOrderPacking.SetRange("Document No.", SalesHeader."No.");
    //     if SalesOrderPacking.FindFirst() then
    //         repeat
    //             SalesShipmentPacking.Init();
    //             SalesShipmentPacking.TransferFields(SalesOrderPacking);
    //             SalesShipmentPacking."Document type" := SalesShipmentPacking."Document type"::"Sales Shipment";
    //             SalesShipmentPacking."Document No." := SalesShipmentHeader."No.";
    //             SalesShipmentPacking.Insert();

    //         Until SalesOrderPacking.next() = 0;
    //     SalesOrderPacking.DeleteAll();
    // end;


    // =============     OnValidateNoOnBeforeUpdateDates          ====================
    // ==  
    // ==  Evento que capturamos al indicar el codigo en una linea de venta de factura,abono, oferta, etc. 
    // ==  CheckCustomerItemBlocked comprobamos si existe bloqueo
    // ==  CheckCustomerItemSalesPrice  comprobamos si el cliente tiene tarifa y el producto no tiene esa tarifa
    // ==  
    // ======================================================================================================

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnBeforeUpdateDates', '', true, true)]
    local procedure SalesLine_OnValidateNoOnBeforeInitRec(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CallingFieldNo: Integer)
    begin
        case SalesLine.Type of
            SalesLine.Type::Item:
                begin
                    case SalesLine."Document Type" of
                        SalesLine."Document Type"::Quote, SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice:
                            CheckCustomerItemBlocked(SalesLine);
                    end;
                    CheckCustomerItemSalesPrice(SalesLine);
                end;

        end;
    end;

    local procedure CheckCustomerItemBlocked(SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        CustomerItemBlocked: Record "ZM Customer Items blocked";
        lblError: Label 'El cliente %1 %2 tiene bloqueado la venta del producto %3 %4.\Pongase en contacto con administración', comment = 'ESP="El cliente %1 %2 tiene bloqueado la venta del producto %3 %4.\Pongase en contacto con administración"';
    begin
        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;
        CustomerItemBlocked.Reset();
        if CustomerItemBlocked.Get(SalesHeader."Sell-to Customer No.", SalesLine."No.") then
            if CustomerItemBlocked.Blocked then begin
                if Item.Get(SalesLine."No.") then;
                if Customer.Get(SalesHeader."Sell-to Customer No.") then;
                Error(lblError, SalesLine."Sell-to Customer No.", Customer.Name, SalesLine."No.", Item.Description);
            end;
    end;

    local procedure CheckCustomerItemSalesPrice(var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        Customer: Record Customer;
        UserSetup: Record "User Setup";
        SalesHeader: Record "Sales Header";
        SalesPrice: Record "Sales Price";
        SalesSetup: Record "Sales & Receivables Setup";
        lblMSG: Label 'El Cliente %1 %2 tiene asignada la lista de precios %3 y el producto %4 %5 no tiene tarifa.',
            comment = 'ESP="El Cliente %1 %2 tiene asignada la lista de precios %3 y el producto %4 %5 no tiene tarifa."';
    begin
        if not GuiAllowed then
            exit;
        SalesSetup.Get();

        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;
        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;
        if Customer."Customer Price Group" = '' then
            exit;
        if Item.Get(SalesLine."No.") then;
        if not CheckCustomerPriceGroup(SalesLine) then
            exit;
        SalesPrice.Reset();
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetRange("Sales Code", SalesLine."Customer Price Group");
        SalesPrice.SetRange("Item No.", SalesLine."No.");
        if not SalesPrice.FindFirst() then begin
            SalesLine.SinPrecioTarifa := true;
            if SalesSetup."Show Item alert without tariff" then begin
                if UserSetup.Get(UserId) then begin
                    if UserSetup."Venta productos sin tarifa" then
                        Message(lblMSG, Customer."No.", Customer.Name, Customer."Customer Price Group", Item."No.", Item.Description)
                    else
                        Error(lblMSG, Customer."No.", Customer.Name, Customer."Customer Price Group", Item."No.", Item.Description);
                end else
                    Error(lblMSG, Customer."No.", Customer.Name, Customer."Customer Price Group", Item."No.", Item.Description);
            end;
        end;
    end;

    procedure CheckCustomerPriceGroup(SalesLine: Record "Sales Line"): Boolean
    var
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        if CustomerPriceGroup.Get(SalesLine."Customer Price Group") then
            if CustomerPriceGroup."Block without Sales Items" then
                exit(true);
    end;


    // =============               ====================
    // ==  
    // ==  CUANDO SE REALIZA UN ABONO, QUE PONGA AUTOMATICAMENTE EL ALMACEN CONFIGURADO EN VENTAS
    // ==  
    // ==  recojer el evento de 
    // ======================================================================================================
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitHeaderDefaults', '', true, true)]
    local procedure SalesLine_OnAfterInitHeaderDefaults(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        case SalesLine."Document Type" of
            SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo":
                begin
                    SalesLine_AssignLocationAbono(SalesLine);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Copy Document Mgt.", 'OnAfterInsertToSalesLine', '', true, true)]
    local procedure CopyDocumentMgt_OnAfterInsertToSalesLine(var ToSalesLine: Record "Sales Line"; FromSalesLine: Record "Sales Line")
    begin
        case ToSalesLine."Document Type" of
            ToSalesLine."Document Type"::"Return Order", ToSalesLine."Document Type"::"Credit Memo":
                begin
                    if FromSalesLine.Type in [FromSalesLine.Type::Item] then
                        SalesLine_AssignLocationAbono(ToSalesLine);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Copy Document Mgt.", 'OnAfterCopySalesLineFromSalesLineBuffer', '', true, true)]
    local procedure CopyDocumentMgt_OnAfterCopySalesLineFromSalesLineBuffer(VAR ToSalesLine: Record "Sales Line"; FromSalesInvLine: Record "Sales Invoice Line";
        IncludeHeader: Boolean; RecalculateLines: Boolean; VAR TempDocSalesLine: Record "Sales Line"; ToSalesHeader: Record "Sales Header"; FromSalesLineBuf: Record "Sales Line")
    begin
        case ToSalesLine."Document Type" of
            ToSalesLine."Document Type"::"Return Order", ToSalesLine."Document Type"::"Credit Memo":
                begin
                    if FromSalesInvLine.Type in [FromSalesInvLine.Type::Item] then
                        SalesLine_AssignLocationAbono(ToSalesLine);
                end;
        end;
    end;

    local procedure SalesLine_AssignLocationAbono(var ToSalesLine: Record "Sales Line")
    var
        Item: Record Item;
        SalesSetup: Record "Sales & Receivables Setup";
        Location: Record Location;
    begin
        case ToSalesLine.Type of
            ToSalesLine.Type::Item:
                begin
                    SalesSetup.Get();
                    if SalesSetup."Location Code Credit Memo" <> '' then
                        if Location.Get(SalesSetup."Location Code Credit Memo") then
                            if not Location."Use As In-Transit" then begin
                                Item.Get(ToSalesLine."No.");
                                if Item.Type in [Item.Type::Inventory] then begin

                                    ToSalesLine.Validate("Location Code", SalesSetup."Location Code Credit Memo");
                                    ToSalesLine.Validate("Bin Code", SalesSetup."Bin Code Credit Memo");
                                    ChangeLocationReservationEntry(ToSalesLine);
                                end;
                            end;
                end;
        end;
    end;

    local procedure ChangeLocationReservationEntry(ToSalesLine: Record "Sales Line")
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source Subtype", ToSalesLine."Document Type");
        ReservationEntry.SetRange("Source ID", ToSalesLine."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", ToSalesLine."Line No.");
        ReservationEntry.ModifyAll("Location Code", ToSalesLine."Location Code");
    end;


    // =============     Funciones para crear linea de producto y de contrato          ====================
    // ==  
    // ==  Se venden una maquina y un SAT juntos, para que no aparezcan en el pedido de venta y factura
    // ==  se utiliza la opcion de relacionar una linea con la otra
    // ==  
    // ======================================================================================================
    procedure AddExplodeServiceContract(var Rec: Record "Sales Line")
    var
        GLAccount: Record "G/L Account";
        ServiceContractHeader: Record "Service Contract Header";
        ServiceContracts: page "Service Contract List";
        GLAccountNo: code[20];
        lblConfirm: Label '¿Desea añadir la linea de servicio %1 %2\del contrato %3\a la lineas %4 %5?',
            comment = 'ESP="¿Desea añadir la linea de servicio %1 %2\del contrato %3\a la lineas %4 %5?"';
    begin
        Rec.TestField(Type, Rec.Type::Item);
        GLAccountNo := GetServiceMgtSetupGLACcountExtension();
        GLAccount.Get(GLAccountNo);
        ServiceContractHeader.SetRange("Contract Type", ServiceContractHeader."Contract Type"::Contract);
        // se comenta porque cuando creamos el pedido de venta, todavia no esta creado el producto de servio
        // por lo que no se puede indicar que este firmado
        // ServiceContractHeader.SetRange(Status, ServiceContractHeader.Status::Signed);
        ServiceContracts.SetTableView(ServiceContractHeader);
        ServiceContracts.LookupMode(true);
        if ServiceContracts.RunModal() = Action::LookupOK then begin
            ServiceContracts.GetRecord(ServiceContractHeader);
            if confirm(lblConfirm, false, GLAccount."No.", GLAccount.Name, ServiceContractHeader."Contract No.", Rec."No.", Rec.Description) then begin
                AddToSalesLine(Rec, GLAccount, ServiceContractHeader);
                Rec.ParentLine := true;
                Rec.ParentItemNo := Rec."No.";
                Rec.ContractParent := true;
                Rec.Modify();
                Message('Creada linea de servicio del contrato %1', ServiceContractHeader."Contract No.");
            end;
        end;
    end;

    local procedure UpdateContractNoExtension(var Rec: Record "Sales Line"; ContractNo: code[29])
    var
        RefRecord: RecordRef;
        RefField: FieldRef;
    begin
        RefRecord.GetTable(Rec);
        if RefRecord.FieldExist(50651) then begin  // Service Contract No.
            RefField := RefRecord.Field(50651);
            RefField.Value := ContractNo;
            RefRecord.Modify();
        end
    end;

    local procedure AddToSalesLine(SalesLine: Record "Sales Line"; GLAccount: Record "G/L Account"; ServiceContractHeader: Record "Service Contract Header")
    var
        ToSalesLine: Record "Sales Line";
        NextLineNo: Integer;
    begin
        InsertLinesBetween(SalesLine, NextLineNo);

        ToSalesLine.INIT;
        //ToSalesLine := SalesLine;
        ToSalesLine."Document Type" := SalesLine."Document Type";
        ToSalesLine."Document No." := SalesLine."Document No.";
        ToSalesLine.Validate("Sell-to Customer No.", SalesLine."Sell-to Customer No.");
        ToSalesLine."Line No." := NextLineNo;
        ToSalesLine.Type := ToSalesLine.Type::"G/L Account";
        ToSalesLine.VALIDATE("No.", GLAccount."No.");
        ToSalesLine.Description := CopyStr(ServiceContractHeader.Description, 1, MaxStrLen(ToSalesLine.Description));
        ToSalesLine.VALIDATE(Quantity, SalesLine.Quantity);
        ToSalesLine."DecLine Discount1 %_btc" := SalesLine."DecLine Discount1 %_btc";
        ToSalesLine."DecLine Discount2 %_btc" := SalesLine."DecLine Discount2 %_btc";
        ToSalesLine.Validate("Line Discount %", SalesLine."Line Discount %");
        ToSalesLine.ParentLineNo := SalesLine."Line No.";
        ToSalesLine.Insert();
        UpdateContractNoExtension(ToSalesLine, ServiceContractHeader."Contract No.");
    end;

    local procedure InsertLinesBetween(Rec: Record "Sales Line"; var NextLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        lblError: Label 'No hay suficiente espacio para inserta una linea de venta, linea %1', comment = 'ESP="No hay suficiente espacio para inserta una linea de venta, linea %1"';
    begin
        SalesLine.SetRange("Document Type", Rec."Document Type");
        SalesLine.SetRange("Document No.", Rec."Document No.");
        SalesLine.SetFilter("Line No.", '%1..', Rec."Line No." + 1);
        IF SalesLine.FindFirst() THEN
            NextLineNo := Rec."Line No." + (SalesLine."Line No." - Rec."Line No.") DIV 2
        ELSE
            NextLineNo := Rec."Line No." + 10000;
        if NextLineNo = SalesLine."Line No." then
            error(LblError, Rec."Line No.");
    end;

    local procedure GetServiceMgtSetupGLACcountExtension(): code[20]
    var
        ServiceMgtSetup: Record "Service Mgt. Setup";
        RefRecord: RecordRef;
        RefField: FieldRef;
    begin
        // cambiamos de producto a cuenta contable, para que no salga en el BI Ventas
        ServiceMgtSetup.Get();
        RefRecord.GetTable(ServiceMgtSetup);
        if RefRecord.FieldExist(50670) then begin // 50670 - Cuenta Contable a devengar (antes 50690 =>cod. Producto contrato)
            RefField := RefRecord.Field(50670);
            RefField.TestField();
            exit(RefField.Value);
        end;
    end;
    // =============     Explode Production BOM SALES LINE          ====================
    // ==  
    // ==  Para productos con Lista de Materiales, se desplegan
    // ==  en el informe de factura, se muestra solo la linea principal e importe total de las lineas relacionadas
    // ==  
    // ==  07/01/2025 añadimos funcionalidad para que si la lista de precio esta marcada
    // ==  aplica el precio del producto teniendo en cuenta el precio del producto y el precio del Servicio (Item type <> inventory)
    // ==  
    // ==  
    // ======================================================================================================
    procedure Action_ExplodeProdBOM(var Rec: Record "Sales Line")
    var
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        ToSalesLine: Record "Sales Line";
        ProdBomHeader: Record "Production BOM Header";
        FromBOMComp: Record "Production BOM Line";
        ReservMgt: Codeunit "Reservation Management";
        UOMMgt: Codeunit "Unit of Measure Management";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        Text000: Label 'La lista de materiales no se puede desplegar en la línea de ventas porque está asociada al pedido de compra %1.'
                , comment = 'ESP="La lista de materiales no se puede desplegar en la línea de ventas porque está asociada al pedido de compra %1."';
        lblConfirmExplode: Label '¿Desea desplegar la lista de materiales de producción de %1 %2?', comment = 'ESP="¿Desea desplegar la lista de materiales de producción de %1 %2?"';
    begin
        Rec.TestField(Type, Rec.Type::Item);
        Rec.TestField("Quantity Shipped", 0);
        Rec.TestField("Return Qty. Received", 0);
        Rec.CalcFields("Reserved Qty. (Base)");
        Rec.TestField("Reserved Qty. (Base)", 0);
        ReservMgt.SetSalesLine(Rec);
        ReservMgt.SetItemTrackingHandling(1);
        ReservMgt.DeleteReservEntries(TRUE, 0);
        if Rec."Purch. Order Line No." <> 0 then
            ERROR(Text000, Rec."Purchase Order No.");
        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        SalesHeader.TESTFIELD(Status, SalesHeader.Status::Open);
        Item.Get(Rec."No.");
        Item.TestField("Production BOM No.");
        ProdBomHeader.Get(Item."Production BOM No.");
        ProdBomHeader.TestField(Status, ProdBomHeader.Status::Certified);
        if Confirm(lblConfirmExplode, false, Rec."No.", Rec.Description) then begin

            ToSalesLine := Rec;
            ToSalesLine.INIT;
            ToSalesLine.Description := Rec.Description;
            ToSalesLine."Description 2" := Rec."Description 2";
            ToSalesLine.ParentLine := true;
            ToSalesLine.ParentItemNo := Rec."No.";
            ToSalesLine.MODIFY;

            ExplodeProdBOMCompLines(SalesHeader, Rec, Item."Production BOM No.");
        end;
    end;

    local procedure ExplodeProdBOMCompLines(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; ProductionBOMNo: code[20])
    var
        Item: record Item;
        ItemTranslation: Record "Item Translation";
        ToSalesLine: Record "Sales Line";
        FromBOMComp: Record "Production BOM Line";
        UOMMgt: Codeunit "Unit of Measure Management";
        NextLineNo: Integer;
        NoOfBOMComp: Integer;
        LineSpacing: Integer;
        InsertLinesBetween: Boolean;
        lblError: Label 'No hay suficiente espacio para desplegar la lista de materiales.', comment = 'ESP="No hay suficiente espacio para desplegar la lista de materiales"';
    begin
        ToSalesLine.RESET;
        ToSalesLine.SETRANGE("Document Type", SalesLine."Document Type");
        ToSalesLine.SETRANGE("Document No.", SalesLine."Document No.");
        ToSalesLine := SalesLine;
        NextLineNo := SalesLine."Line No.";
        InsertLinesBetween := FALSE;
        if ToSalesLine.find('>') then
            if ToSalesLine."Attached to Line No." = SalesLine."Line No." then begin
                ToSalesLine.SETRANGE("Attached to Line No.", SalesLine."Line No.");
                ToSalesLine.FINDLAST;
                ToSalesLine.SETRANGE("Attached to Line No.");
                NextLineNo := ToSalesLine."Line No.";
                InsertLinesBetween := ToSalesLine.FIND('>');
            end else
                InsertLinesBetween := TRUE;
        FromBOMComp.SetRange("Production BOM No.", ProductionBOMNo);
        FromBOMComp.SetRange(Type, FromBOMComp.Type::Item);
        FromBOMComp.SetFilter("No.", '<>%1', '');
        NoOfBOMComp := FromBOMComp.Count;

        IF InsertLinesBetween THEN
            LineSpacing := (ToSalesLine."Line No." - NextLineNo) DIV (1 + NoOfBOMComp)
        ELSE
            LineSpacing := 10000;

        IF LineSpacing = 0 THEN
            ERROR(lblError);

        if FromBOMComp.FindFirst() then
            repeat
                ToSalesLine.INIT;
                NextLineNo := NextLineNo + LineSpacing;
                ToSalesLine."Line No." := NextLineNo;

                case FromBOMComp.Type OF
                    FromBOMComp.Type::" ":
                        ToSalesLine.Type := ToSalesLine.Type::" ";
                    FromBOMComp.Type::Item:
                        ToSalesLine.Type := ToSalesLine.Type::Item;
                end;
                IF ToSalesLine.Type <> ToSalesLine.Type::" " then begin
                    FromBOMComp.TESTFIELD("No.");
                    ToSalesLine.VALIDATE("No.", FromBOMComp."No.");
                    IF SalesHeader."Location Code" <> SalesLine."Location Code" THEN
                        ToSalesLine.VALIDATE("Location Code", SalesLine."Location Code");
                    IF FromBOMComp."Variant Code" <> '' THEN
                        ToSalesLine.VALIDATE("Variant Code", FromBOMComp."Variant Code");
                    IF ToSalesLine.Type = ToSalesLine.Type::Item THEN BEGIN
                        ToSalesLine."Drop Shipment" := SalesLine."Drop Shipment";
                        Item.GET(FromBOMComp."No.");
                        ToSalesLine.VALIDATE("Unit of Measure Code", FromBOMComp."Unit of Measure Code");
                        ToSalesLine."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, ToSalesLine."Unit of Measure Code");
                        ToSalesLine.VALIDATE(Quantity,
                          ROUND(
                            SalesLine."Quantity (Base)" * FromBOMComp."Quantity per" *
                            UOMMgt.GetQtyPerUnitOfMeasure(Item, ToSalesLine."Unit of Measure Code") /
                            ToSalesLine."Qty. per Unit of Measure",
                            0.00001));
                    END ELSE
                        ToSalesLine.VALIDATE(Quantity, SalesLine."Quantity (Base)" * FromBOMComp."Quantity per");

                    IF SalesHeader."Shipment Date" <> SalesLine."Shipment Date" THEN
                        ToSalesLine.VALIDATE("Shipment Date", SalesLine."Shipment Date");


                END;
                ToSalesLine."DecLine Discount1 %_btc" := SalesLine."DecLine Discount1 %_btc";
                ToSalesLine."DecLine Discount2 %_btc" := SalesLine."DecLine Discount2 %_btc";
                ToSalesLine.Validate("Line Discount %", SalesLine."Line Discount %");
                IF SalesHeader."Language Code" = '' THEN
                    ToSalesLine.Description := FromBOMComp.Description
                ELSE
                    IF NOT ItemTranslation.GET(FromBOMComp."No.", FromBOMComp."Variant Code", SalesHeader."Language Code") THEN
                        ToSalesLine.Description := FromBOMComp.Description;

                ToSalesLine.ParentLineNo := SalesLine."Line No.";
                ToSalesLine.Insert();

                ToSalesLine.VALIDATE("Qty. to Assemble to Order");

                IF (ToSalesLine.Type = ToSalesLine.Type::Item) AND (ToSalesLine.Reserve = ToSalesLine.Reserve::Always) THEN
                    ToSalesLine.AutoReserve;



                ToSalesLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
                ToSalesLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
                ToSalesLine."Dimension Set ID" := SalesLine."Dimension Set ID";
                ToSalesLine.MODIFY;


            Until FromBOMComp.next() = 0;
        // añadimos funcionalidad, para verificar si cambiamos algún precio
        UpdateUnitPricePriceGroup(SalesLine);

    end;

    local procedure UpdateUnitPricePriceGroup(var SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        ToSalesLine: Record "Sales Line";
        CustPriceGroup: Record "Customer Price Group";
        ItemListPrice: Dictionary of [code[20], Decimal];
        ItemNo: code[20];
        PriceAcum: Decimal;
        UnitPrice: Decimal;
        Count: Integer;
    begin
        if not CustPriceGroup.Get(SalesLine."Customer Price Group") then
            exit;
        if not CustPriceGroup."Aplicar Precio Total Servicio" then
            exit;
        ToSalesLine.SetRange("Document Type", SalesLine."Document Type");
        ToSalesLine.SetRange("Document No.", SalesLine."Document No.");
        ToSalesLine.SetRange(ParentLineNo, SalesLine."Line No.");
        if ToSalesLine.FindFirst() then
            repeat
                if Item.Get(ToSalesLine."No.") then
                    if Item.Type in [Item.Type::Inventory] then begin
                        ItemListPrice.Set(ToSalesLine."No.", 0);
                        Count += 1;
                    end else begin
                        PriceAcum := ToSalesLine."Unit Price";
                        ItemListPrice.Set(ToSalesLine."No.", ToSalesLine."Unit Price");

                    end;



            Until ToSalesLine.next() = 0;
        if ToSalesLine.FindFirst() then
            repeat
                UnitPrice := ItemListPrice.Get(ToSalesLine."No.");
                if UnitPrice = 0 then begin
                    ToSalesLine.Validate("Unit Price", Round(SalesLine."Unit Price" - PriceAcum / Count, 0.01));
                    ToSalesLine.Modify();
                end;
            Until ToSalesLine.next() = 0;

    end;

    // =============     FUNCIONES DE APROBACION PRECIOS Y DESCUENTOS          ====================
    // ==  
    // ==  Todo lo relativo al desarrollo de controles para poder editar y cambiar precios de productos 
    // ==  con tarifas y sin tarifas
    // ==  
    // ==  Maria y JL Lllego, el cliente tiene en condiciones de venta, una configuración de descuento
    // ==  si existe un cambio de estas condiciones, de ficha de cliente , dto1 y dto2, se tiene que aprobar la ficha de cliente
    // ==  Se tiene en cuenta y compara el dto maximo configurado en los descuentos:
    // ==       la lista de descuentos: Tipo de Ventas. : Cliente, Grupo dto Cliente, Todos los clientes
    // ==       la configuración de descuentos maximos por familias.
    // ==       si supera esos descuentos, necesitan aprobación 
    // ==     NOTA - Contemplar envío información a usuarios.
    // ==  
    // ==  Tenemos en cuenta los campos de importe lina
    // ==  
    // ==  Salesline."Inv. Discount Amount"
    // ==  SalesLine."Line Discount Amount"
    // ======================================================================================================

    procedure CheckSalesPriceItemNo(SalesLine: Record "Sales Line"): Boolean
    var
        SalesSetup: record "Sales & Receivables Setup";
        Customer: Record Customer;
        SalesPrice: Record "Sales Price";
    begin
        if not SalesSetup.Get() then
            exit;
        if not SalesSetup."Active Price/Discounts Control" then
            exit;
        if Customer.Get(SalesLine."Sell-to Customer No.") then
            if Customer."Allows change Prices/Dates" then
                exit;
        SalesPrice.Reset();
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetRange("Sales Code", SalesLine."Customer Price Group");
        SalesPrice.SetRange("Item No.", SalesLine."No.");
        SalesPrice.SetFilter("Unit Price", '>0');
        SalesPrice.SetFilter("Ending Date", '%1..', WorkDate());
        if SalesPrice.FindFirst() then
            exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales - Calc Discount By Type", 'OnAfterResetRecalculateInvoiceDisc', '', true, true)]
    local procedure SalesCalcDiscountByType_OnAfterResetRecalculateInvoiceDisct(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        IsMark: Boolean;
        lblMessage: Label 'Existen Líneas con descuentos que necesitan aprobación.\Es necesario la solicitud de aprobación.',
            Comment = 'ESP="Existen Líneas con descuentos que necesitan aprobación.\Es necesario la solicitud de aprobación."';
    begin
        if SalesHeader.IsTemporary then
            exit;
        if not GetFileExtensionActiveControlDtos then
            exit;
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Quote, SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice:
                begin
                    // if not (SalesHeader.Type in [SalesHeader.Type::Item]) then
                    // exit;
                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    if SalesLine.FindFirst() then
                        repeat
                            if SalesLine.Type in [SalesLine.Type::Item] then begin
                                if CheckDicountsSalesLine(SalesLine, True) then begin
                                    SalesLine.DiscountApprovalStatus := SalesLine.DiscountApprovalStatus::Pending;
                                    IsMark := true;
                                end else
                                    SalesLine.DiscountApprovalStatus := SalesLine.DiscountApprovalStatus::" ";
                                SalesLine.Modify();
                            end;
                        Until SalesLine.next() = 0;
                    if IsMark then
                        Message(lblMessage);
                end;
        end;
    end;


    // [EventSubscriber(ObjectType::Table, Database::"Sales Line",  , '', true, true)]
    // local procedure SalesLine_OnAfterUpdateAmountsDone(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    procedure ControlDiscountSalesLine(var SalesLine: Record "Sales Line"): Boolean
    var
        IsMark: Boolean;
        lblMessage: Label 'Producto: %1 \%2\Cantidad: %3\Precio: %4\Dto.: %5.\No cumple las condiciones de descuentos, necesita aprobación',
            comment = 'ESP="Producto: %1 \%2\Cantidad: %3\Precio: %4\Dto.: %5.\No cumple las condiciones de descuentos, necesita aprobación"';
    begin
        if SalesLine.IsTemporary then
            exit;
        if not (SalesLine.Type in [SalesLine.Type::Item]) then
            exit;
        case SalesLine."Document Type" of
            SalesLine."Document Type"::Quote, SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice:
                begin
                    IsMark := CheckDicountsSalesLine(SalesLine, False);
                    // if IsMark then
                    //     Message(lblMessage, SalesLine."No.", SalesLine.Description, SalesLine.Quantity, SalesLine."Unit Price", SalesLine."Line Discount %");
                    exit(IsMark);
                end;
        end;
    end;

    local procedure CheckDicountsSalesLine(var SalesLine: Record "Sales Line"; DiscountInvoice: Boolean) IsMark: Boolean;
    begin
        if not GetFileExtensionActiveControlDtos then
            exit;
        // if (SalesLine."Line Discount Amount" <> xSalesLine."Line Discount Amount") and
        //    (SalesLine."Inv. Discount Amount" <> xSalesLine."Inv. Discount Amount") then begin
        // hay una diferencia de descuentos. Si hay superior a margenes configurados, marcamos como pdtes aprobar
        // marcamos para no registrar y pedir aprobación POWERAUTOMATE (en Extension AUT)
        IsMark := IsDiscountApproval(SalesLine);
        MarkDiscountApprovalSalesLine(SalesLine, IsMark, DiscountInvoice);

        // end;
    end;

    local procedure IsDiscountApproval(SalesLine: Record "Sales Line"): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Item: Record Item;
        Familia: Record TextosAuxiliares;
        AmountDiscount: Decimal;
        GrossAmount: Decimal;
        DiscountLine: Decimal;
        AprobadodtoFicha: Boolean;
    begin
        // Primer la configuración Maxima de descuento permitido, mas restrictiva
        if not SalesSetup.Get() then
            exit;
        AmountDiscount := SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount";
        if AmountDiscount = 0 then
            exit;
        GrossAmount := SalesLine.Quantity * SalesLine."Unit Price";
        // evitamos error division por cero
        if GrossAmount = 0 then
            exit;
        DiscountLine := Round((1 - ((GrossAmount - AmountDiscount) / GrossAmount)) * 100, 1, '<');

        // Aqui miramos los campos de Customer (Dtos en familias)
        if CustomerDiscountFamilia(SalesLine, SalesLine."Line Discount %", AprobadodtoFicha) then
            exit(true);
        if AprobadodtoFicha then
            exit;
        // ahora miramos configuración del producto
        // si la familia tiene configuración de aprobación de producto
        if ItemPriceDiscount(SalesLine, SalesLine."Line Discount %") then
            exit(true);

    end;

    local procedure ItemPriceDiscount(SalesLine: Record "Sales Line"; DiscountLine: Decimal): Boolean
    var
        Item: Record Item;
        Customer: Record Customer;
        SalesLineDiscount: Record "Sales Line Discount";
    begin
        if not Customer.Get(SalesLine."Sell-to Customer No.") then
            exit;
        if not Item.Get(SalesLine."No.") then
            exit;
        SalesLineDiscount.Reset();
        SalesLineDiscount.SetFilter("Starting Date", '..%1|%2', WorkDate(), 0D);
        SalesLineDiscount.SetFilter("Ending Date", '%1..|%2', WorkDate(), 0D);
        // Articulo en concreto con Cliente en concreto
        SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::Item);
        SalesLineDiscount.SetRange(Code, SalesLine."No.");
        SalesLineDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type"::Customer);
        SalesLineDiscount.SetRange("Sales Code", SalesLine."Sell-to Customer No.");
        if SalesLineDiscount.FindFirst() then begin
            if DiscountLine > SalesLineDiscount."Line Discount %" then
                exit(true); // Pending approval
            exit(false);
        end;
        // Articulo en concreto con grupo descuento de cliente
        SalesLineDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type"::"Customer Disc. Group");
        SalesLineDiscount.SetRange("Sales Code", Customer."Customer Disc. Group");
        if SalesLineDiscount.FindFirst() then begin
            if DiscountLine > SalesLineDiscount."Line Discount %" then
                exit(true); // Pending approval
            exit(false);
        end;
        // Articulo en concreto con Todos los clientes
        SalesLineDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type"::"All Customers");
        SalesLineDiscount.SetRange("Sales Code");
        if SalesLineDiscount.FindFirst() then begin
            if DiscountLine > SalesLineDiscount."Line Discount %" then
                exit(true); // Pending approval
            exit(false);
        end;
        // Grupo descuento de Producto con Cliente
        SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::"Item Disc. Group");
        SalesLineDiscount.SetRange(Code, Item."Item Disc. Group");
        SalesLineDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type"::Customer);
        SalesLineDiscount.SetRange("Sales Code", SalesLine."Sell-to Customer No.");
        if SalesLineDiscount.FindFirst() then begin
            if DiscountLine > SalesLineDiscount."Line Discount %" then
                exit(true); // Pending approval
            exit(false);
        end;
        // Grupo descuento de Producto con grupo descuento de cliente
        SalesLineDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type"::"Customer Disc. Group");
        SalesLineDiscount.SetRange("Sales Code", Customer."Customer Disc. Group");
        if SalesLineDiscount.FindFirst() then begin
            if DiscountLine > SalesLineDiscount."Line Discount %" then
                exit(true); // Pending approval
            exit(false);
        end;
        // Grupo descuento de Producto con Todos los clientes
        SalesLineDiscount.SetRange("Sales Type", SalesLineDiscount."Sales Type"::"All Customers");
        SalesLineDiscount.SetRange("Sales Code");
        if SalesLineDiscount.FindFirst() then begin
            if DiscountLine > SalesLineDiscount."Line Discount %" then
                exit(true); // Pending approval
            exit(false);
        end;
    end;

    local procedure CustomerDiscountFamilia(SalesLine: Record "Sales Line"; DiscountLine: Decimal; var AprobadodtoFicha: Boolean): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        Item: Record Item;
        ItemClasificacion: Record TextosAuxiliares;
        DtoMaximoFamilia: Decimal;
    begin
        SalesSetup.Get();
        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;
        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;
        if not Item.Get(SalesLine."No.") then
            exit;

        ItemClasificacion.Reset();
        ItemClasificacion.SetRange(TipoTabla, ItemClasificacion.TipoTabla::ClasificacionVentas);
        ItemClasificacion.SetRange(TipoRegistro, ItemClasificacion.TipoRegistro::Tabla);
        ItemClasificacion.SetRange(NumReg, Item.selClasVtas_btc);
        if ItemClasificacion.FindFirst() then
            if (ItemClasificacion."Discount Type" in [ItemClasificacion."Discount Type"::" "]) then begin
                ItemClasificacion.SetRange(TipoTabla, ItemClasificacion.TipoTabla::Familia);
                ItemClasificacion.SetRange(TipoRegistro, ItemClasificacion.TipoRegistro::Tabla);
                ItemClasificacion.SetRange(NumReg, Item.selFamilia_btc);
                if not ItemClasificacion.FindFirst() then
                    exit;
            end;
        if (ItemClasificacion."Discount Type" in [ItemClasificacion."Discount Type"::" "]) then
            exit;

        case ItemClasificacion."Discount Type" of
            ItemClasificacion."Discount Type"::"Dto. Exprimidores":
                begin
                    if Customer."Dto. Exprimidores" = 0 then
                        exit;
                    DtoMaximoFamilia := Customer."Dto. Exprimidores";
                end;
            ItemClasificacion."Discount Type"::"Dto. Isla":
                begin
                    if Customer."Dto. Isla" = 0 then
                        exit;
                    DtoMaximoFamilia := Customer."Dto. Isla";
                end;
            ItemClasificacion."Discount Type"::"Dto. Repuestos":
                begin
                    if Customer."Dto. Repuestos" = 0 then
                        exit;
                    DtoMaximoFamilia := Customer."Dto. Repuestos";
                end;
            ItemClasificacion."Discount Type"::"Dto. Viva":
                begin
                    if Customer."Dto. Viva" = 0 then
                        exit;
                    DtoMaximoFamilia := Customer."Dto. Viva";
                end;
        end;
        // si tenemos familia, tenemos descuento cliente, miramos dtos por familia del cliente
        if (DiscountLine > DtoMaximoFamilia) then
            exit(true); // Pending approval

        if (DiscountLine > SalesSetup."Maximun Discounts Approval") and (DtoMaximoFamilia <= SalesSetup."Maximun Discounts Approval") then
            exit(true);
        if (DiscountLine <= DtoMaximoFamilia) and (DtoMaximoFamilia > 0) then
            AprobadodtoFicha := true;

    end;

    local procedure MarkDiscountApprovalSalesLine(var SalesLine: Record "Sales Line"; IsMark: Boolean; DiscountInvoice: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesLine2: Record "Sales Line";
        Objects: Record Object;
        NavObjects: Record "NAV App Object Metadata";
        vRecRef: RecordRef;
        vFieldRef: FieldRef;
        ExistObject: Boolean;
        Value: Integer;
    begin
        // por si llega al funciona, comprobamos que existe la tabla, sino no hacemos nada
        Objects.Reset();
        Objects.SetRange("Type", Objects.Type::Table);
        Objects.SetRange("ID", 16752);
        if Objects.FindFirst() then
            ExistObject := true;
        NavObjects.Reset();
        NavObjects.SetRange("Object Type", navObjects."Object Type"::Table);
        // Objects.SetRange("Company Name", CompanyName);
        NavObjects.SetRange("Object ID", 16752);
        if NavObjects.FindFirst() then
            ExistObject := true;
        if not ExistObject then
            exit;

        // comprobamos si hay mas lineas pendientes o no, para actualizar la cabecera
        SalesLine2.SetRange("Document Type", SalesLine."Document Type");
        SalesLine2.SetRange("Document No.", SalesLine."Document No.");
        SalesLine2.SetFilter(DiscountApprovalStatus, '%1|%2', SalesLine2.DiscountApprovalStatus::Pending, SalesLine2.DiscountApprovalStatus::Reject);
        if SalesLine2.FindFirst() then
            Value := 1
        else
            Value := 0;
        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            // field(50510; "Approval Status"; Enum "ZM Approval Status")
            // value(1; Pending)  value(2; Aproval) value(3; Paused) value(4; Reject)
            vRecRef.GetTable(SalesHeader);
            vFieldRef := vRecRef.Field(50510);
            vFieldRef.Value := Value;
            if not DiscountInvoice then
                vRecRef.Modify();
        end;
    end;

    procedure GetFileExtensionActiveControlDtos(): Boolean
    var
        Objects: Record Object;
        NavObjects: Record "NAV App Object Metadata";
        Funciones: Codeunit Funciones;
        Result: Boolean;
        vRecRef: RecordRef;
        ExistObject: Boolean;
    begin
        //AUT Approval permissions Setup (16752)
        // field 300 Aprobacion control de descuentos
        // activa la configuracion de control de descuentos
        Objects.Reset();
        Objects.SetRange("Type", Objects.Type::Table);
        Objects.SetRange("ID", 16752);
        if Objects.FindFirst() then
            ExistObject := true;
        NavObjects.Reset();
        NavObjects.SetRange("Object Type", navObjects."Object Type"::Table);
        // Objects.SetRange("Company Name", CompanyName);
        NavObjects.SetRange("Object ID", 16752);
        if NavObjects.FindFirst() then
            ExistObject := true;
        if not ExistObject then
            exit;

        vRecRef.Open(16752);
        if vRecRef.FindFirst() then begin
            exit(Funciones.GetExtensionFieldValueboolean(vRecRef.RecordId, 300, false));
        end;
    end;


    procedure ChangeValueEntryPostingDate(InitDate: Date; EndDate: Date; NewDate: date)
    var
        ValueEntry: Record "Value Entry";
        PostValueEntrytoGL: Record "Post Value Entry to G/L";
        Window: Dialog;
        lblWindows: Label 'Fecha Mov.: #1###############\Nº Mov.: #2###############', comment = 'ESP="Fecha Mov.: #1###############\Nº Mov.: #2###############"';
        lblConfirm: Label 'Se va a realizar el cambio de fechas de registros de los movimientos de valor desde %1 a %2, a fecha %3.\Nº Movimientos %4.\¿Desea continuar?',
            comment = 'ESP="Se va a realizar el cambio de fechas de registros de los movimientos de valor desde %1 a %2, a fecha %3.\Nº Movimientos %4.\¿Desea continuar?"';
    begin
        if InitDate = 0D then
            Error('Debe indicar una fecha inicial.');
        if EndDate = 0D then
            Error('Debe indicar una fecha final.');
        if NewDate = 0D then
            Error('Debe indicar una fecha registro.');
        PostValueEntrytoGL.SETRANGE("Posting Date", InitDate, EndDate);
        if not Confirm(lblConfirm, true, InitDate, EndDate, NewDate, PostValueEntrytoGL.Count) then
            exit;
        Window.Open(lblWindows);
        if PostValueEntrytoGL.FINDFIRST then
            repeat
                Window.UPDATE(1, PostValueEntrytoGL."Posting Date");
                ValueEntry.GET(PostValueEntrytoGL."Value Entry No.");
                ValueEntry."Posting Date Old" := ValueEntry."Posting Date";
                ValueEntry.ChangePostingDate := true;
                ValueEntry."Posting Date" := NewDate;
                ValueEntry.MODIFY;
                PostValueEntrytoGL."Posting Date" := NewDate;
                PostValueEntrytoGL.MODIFY;
            until PostValueEntrytoGL.NEXT = 0;
        Window.Close();
    end;

    procedure ResetValueEntryPostingDate()
    var
        ValueEntry: Record "Value Entry";
        PostValueEntrytoGL: Record "Post Value Entry to G/L";
        Window: Dialog;
        Contar: Integer;
        lblWindows: Label 'Fecha Mov.: #1###############\Nº Mov.: #2###############', comment = 'ESP="Fecha Mov.: #1###############\Nº Mov.: #2###############"';
        lblConfirm: Label 'Se van a retornar las fecha de los movimientos de valor %1.\¿Desea Continuar?', comment = 'ESP="Se van a retornar las fecha de los movimientos de valor %1.\¿Desea Continuar?"';
    begin
        Window.Open('Nº Mov.: #1###############');
        ValueEntry.SETRANGE(ChangePostingDate, true);
        IF ValueEntry.FINDFIRST THEN
            repeat

                Window.Update(1, ValueEntry."Entry No.");
                if ValueEntry."Posting Date Old" <> ValueEntry."Posting Date" then
                    Contar += 1;
            until ValueEntry.Next() = 0;
        Window.Close();

        if not Confirm(lblConfirm, true, Contar) then
            exit;
        Window.Open(lblWindows);
        IF ValueEntry.FINDFIRST THEN
            REPEAT
                if ValueEntry."Posting Date Old" <> ValueEntry."Posting Date" then begin
                    Window.UPDATE(1, ValueEntry."Posting Date");
                    Window.UPDATE(2, ValueEntry."Entry No.");
                    ValueEntry."Posting Date" := ValueEntry."Valuation Date";
                    ValueEntry.MODIFY;
                    PostValueEntrytoGL.SetRange("Value Entry No.", ValueEntry."Entry No.");
                    if PostValueEntrytoGL.FindFirst() then begin
                        PostValueEntrytoGL."Posting Date" := ValueEntry."Posting Date";
                        PostValueEntrytoGL.Modify();
                    end;
                end;
            UNTIL ValueEntry.NEXT = 0;
        Window.Close();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesLine_OnAfterValidateEvent_No(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Quote, Rec."Document Type"::Order:
                begin
                    if Rec.Type in [Rec.Type::Item] then
                        if Rec."No." <> xRec."No." then
                            MessageItemCommentLineAvisoVentas(Rec);
                end;

        end;
    end;
    // =============               ====================
    // ==  
    // ==  Comentarios en la ficha de producto que si tienen la marca de Aviso ventas, se muestran al seleccionarlo en documentos de ventas
    // ==  
    // ======================================================================================================
    local procedure MessageItemCommentLineAvisoVentas(SalesLine: Record "Sales Line")
    var
        Commentline: Record "Comment Line";
        MessageComment: text;
    begin
        Commentline.Reset();
        Commentline.SetRange("Table Name", Commentline."Table Name"::Item);
        Commentline.SetRange("No.", SalesLine."No.");
        Commentline.SetRange(AvisoVentas, true);
        if not Commentline.FindFirst() then
            exit;
        if Commentline.FindFirst() then
            repeat
                if MessageComment <> '' then
                    MessageComment += '\';
                MessageComment += Commentline.Comment;
            Until Commentline.next() = 0;
        if MessageComment <> '' then
            Message(MessageComment);
    end;

    // =============     RESTAURAR OFERTAS DE ARCHIVO          ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnBeforeRestoreSalesDocument', '', true, true)]
    local procedure ArchiveManagement_OnBeforeRestoreSalesDocument(var SalesHeaderArchive: Record "Sales Header Archive"; var IsHandled: Boolean)
    begin
        case SalesHeaderArchive."Document Type" of
            SalesHeaderArchive."Document Type"::Quote:
                CheckIsQuoteCreate(SalesHeaderArchive)
        end;
    end;

    local procedure CheckIsQuoteCreate(var SalesHeaderArchive: Record "Sales Header Archive")
    var
        SalesHeader: Record "Sales Header";
        lblConfirm: Label 'The %1 %2 does not exist.\¿Do you want to restore it anyway?', comment = 'ESP="La %1 %2 no existe.\¿Desea Restaurarla de todas maneras?"';
    begin
        if not SalesHeader.Get(SalesHeaderArchive."Document Type", SalesHeaderArchive."No.") then begin
            if not Confirm(lblConfirm, false, SalesHeaderArchive."Document Type", SalesHeaderArchive."No.") then
                exit;
            SalesHeader.Init();
            SalesHeader.TransferFields(SalesHeaderArchive);
            SalesHeader.Insert();
        end
    end;
}
