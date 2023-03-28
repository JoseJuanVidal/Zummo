codeunit 50102 "Integracion_crm_btc"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Integration Table Synch.", 'OnQueryPostFilterIgnoreRecord', '', true, true)]
    local procedure OnQueryPostFilterIgnoreRecord(SourceRecordRef: RecordRef; var IgnoreRecord: Boolean)
    var
        SalesQuoteAux: Record "STH Sales Header Aux";
        CRMQuoteDetail: Record "STH CRM Quotedetail";
        CRMIntegrationRecord: record "CRM Integration Record";
        SaleHeaderRecRef: RecordRef;
        DestinationFieldRef: FieldRef;
        AccountId: RecordId;
        NoQuote: code[20];
    begin
        case SourceRecordRef.Number of
            Database::"STH CRM Quotedetail":
                begin
                    // controlamos si el quote id está ya sincronizada, solo se actualizan los estado = activo
                    // poner los ID de cliente
                    SourceRecordRef.SETTABLE(CRMQuoteDetail);
                    DestinationFieldRef := SourceRecordRef.Field(3);
                    IF CRMIntegrationRecord.FindRecordIDFromID(CRMQuoteDetail.QuoteId, Database::"STH Sales Header Aux", AccountId) then begin
                        if SaleHeaderRecRef.get(AccountId) then begin
                            NoQuote := format(SaleHeaderRecRef.field(SalesQuoteAux.fieldNo("No.")));
                            if SalesQuoteAux.get(NoQuote) then begin
                                IgnoreRecord := false;
                                exit;
                            end;

                        end;
                    end;

                    IgnoreRecord := true;
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnBeforeTransferRecordFields', '', true, true)]
    local procedure OnBeforeTransferRecordFields(SourceRecordRef: RecordRef; VAR DestinationRecordRef: RecordRef)
    var
        txtTipo: Text;
    begin
        //error('pp');
        txtTipo := GetSourceDestCode(SourceRecordRef, DestinationRecordRef);
        CASE txtTipo OF
            'STH CRM Quote-Sales Header':
                ActualizarCamposOfertaCRM(SourceRecordRef, DestinationRecordRef);
            'STH CRM Quotedetail-Sales Line':
                ActualizarCamposLineasOfertaCRM(SourceRecordRef, DestinationRecordRef);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnAfterTransferRecordFields', '', true, true)]

    local procedure OnAfterTransferRecordFields(VAR SourceRecordRef: RecordRef; VAR DestinationRecordRef: RecordRef; VAR AdditionalFieldsWereModified: Boolean; DestinationIsInserted: Boolean)
    var
        txtTipo: Text;
    begin
        //error('pp');
        txtTipo := GetSourceDestCode(SourceRecordRef, DestinationRecordRef);
        CASE txtTipo OF
            'Customer-CRM Account_btc', 'Customer-CRM Account_crm_btc':
                AdditionalFieldsWereModified :=
                  ActualizarCamposCliente(SourceRecordRef, DestinationRecordRef);
            'Item-CRM Productos_btc', 'Item-CRM Productos_crm_btc':
                AdditionalFieldsWereModified :=
                      ActualizarCamposProducto(SourceRecordRef, DestinationRecordRef);
            'Customer Price Group-CRM Pricelevel_btc', 'Customer Price Group-CRM Pricelevel_crm_btc':
                AdditionalFieldsWereModified :=
                  ActualizarCamposTarifa(SourceRecordRef, DestinationRecordRef);
            'Sales Header-CRM Quote':
                AdditionalFieldsWereModified :=
                    ActualizarCamposOferta(SourceRecordRef, DestinationRecordRef);
            'Sales Header-STH CRM Quote':
                AdditionalFieldsWereModified :=
                    ActualizarCamposOfertaNew(SourceRecordRef, DestinationRecordRef);
            'Sales Header-CRM Salesorder_btc', 'Sales Header-CRM Salesorder_crm_btc':
                ActualizarCamposPedido(SourceRecordRef, DestinationRecordRef);
            'Sales Line-CRM Salesorderdetail_btc', 'Sales Line-CRM Salesorderdetail_crm_btc':
                ActualizarCamposLinPedido(SourceRecordRef, DestinationRecordRef);
            'Service Header-CRM Incident':
                ActualizarCamposPedidoServicio(SourceRecordRef, DestinationRecordRef);
            'Sales Line-STH CRM Quotedetail':
                AdditionalFieldsWereModified :=
                    ActualizarCamposLinOferta(SourceRecordRef, DestinationRecordRef);


            // De CRM a BC
            'CRM Account_btc-Customer':
                AdditionalFieldsWereModified :=
                  ActualizarCamposClienteCRM(SourceRecordRef, DestinationRecordRef);
            'STH CRM Quote-Sales Header':
                ActualizarCamposOfertaCRMDespues(SourceRecordRef, DestinationRecordRef);
            'STH CRM Quotedetail-Sales Line':
                ActualizarCamposLineasOfertaCRMDespues(SourceRecordRef, DestinationRecordRef);
        /* ponemos el evento en on OnBeforeTransferRecordFields antes de que se sincronizen los campos
  'STH CRM Quote-Sales Header':
      AdditionalFieldsWereModified :=
        ActualizarCamposOfertaCRM(SourceRecordRef, DestinationRecordRef);

'STH CRM Quotedetail-Sales Line':
   AdditionalFieldsWereModified :=
     ActualizarCamposLineasOfertaCRM(SourceRecordRef, DestinationRecordRef);*/

        //    'Sales Invoice Header-CRM Invoice':
        //        UpdateCRMInvoiceBeforeInsertRecord(SourceRecordRef, DestinationRecordRef); //VEr si hae falta esta llamada al std.
        //  'Sales Invoice Line-CRM Invoicedetail':
        //    UpdateCRMInvoiceDetailsBeforeInsertRecord(SourceRecordRef,DestinationRecordRef);//VEr si hae falta esta llamada al std.

        end;
    end;




    local procedure ActualizarCamposClienteCRM(SourceRecordRef: RecordRef; VAR DestinationRecordRef: RecordRef): Boolean
    var

        Customer: Record Customer;
        CRMAccount: Record "CRM Account_crm_btc";
        DestinationFieldRef: FieldRef;
        SourceFieldRef: FieldRef;
        AccountNumber: Code[20];
        NoSeriesMgt: codeunit NoSeriesManagement;
        CRMConnectionSetup: record "CRM Connection Setup";// "CRM Connection Setup";  
        bit_bcenviaralerp: Boolean;

    begin

        SourceFieldRef := SourceRecordRef.FIELD(CRMAccount.FIELDNO(bit_bcenviaralerp));
        bit_bcenviaralerp := SourceFieldRef.VALUE;
        SourceFieldRef := SourceRecordRef.FIELD(CRMAccount.FIELDNO(AccountNumber));
        AccountNumber := SourceFieldRef.VALUE;

        if (bit_bcenviaralerp) and (AccountNumber = '') then begin

            CRMConnectionSetup.get();
            if (CRMConnectionSetup."NºSerie Lead CRM" = '') then
                ERROR('Debe asignar número de serie a los Leads CRM');
            if (CRMConnectionSetup."Vendedor Defecto CRM" = '') then
                ERROR('Debe asignar un vendedor por defecto CRM');
            // Blocked - we're only handling from Active > Inactive meaning Blocked::"" > Blocked::"All"
            //   if AccountNumber <> 'PRUEBA' then exit;
            // if AccountNumber = '' then 
            AccountNumber := NoSeriesMgt.GetNextNo(CRMConnectionSetup."NºSerie Lead CRM", TODAY, true);


            IF AccountNumber <> '' THEN BEGIN
                DestinationFieldRef := DestinationRecordRef.FIELD(Customer.FIELDNO("No."));
                DestinationFieldRef.VALUE := AccountNumber;

                DestinationFieldRef := DestinationRecordRef.FIELD(Customer.FIELDNO("Salesperson Code"));
                DestinationFieldRef.VALUE := CRMConnectionSetup."Vendedor Defecto CRM";

                EXIT(TRUE);
            END;
        end;
    end;

    local procedure ActualizarCamposOfertaCRM(SourceRecordRef: RecordRef; VAR DestinationRecordRef: RecordRef): Boolean
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        CRMQuote: Record "STH CRM Quote";
        DestinationFieldRef: FieldRef;
        SourceFieldRef: FieldRef;
        Probabilidad: Option;
        NoSeriesMgt: codeunit NoSeriesManagement;
        CRMConnectionSetup: record "CRM Connection Setup";// "CRM Connection Setup";  
        bit_bcenviaralerp: Boolean;
        CRMIntegrationRecord: record "CRM Integration Record";
        CustRecRef: RecordRef;
        DestinationAccountFieldRef: FieldRef;
        AccountId: RecordId;
        CustNo: code[20];
    begin
        SourceRecordRef.SETTABLE(CRMquote);
        DestinationRecordRef.SETTABLE(SalesHeader);
        SourceFieldRef := SourceRecordRef.FIELD(CRMQuote.FIELDNO(Probabilidad));
        Probabilidad := SourceFieldRef.VALUE;
        DestinationAccountFieldRef := DestinationRecordRef.Field(2);
        CustRecRef.Open(18);

        DestinationFieldRef := DestinationRecordRef.Field(50050); // 50050; ofertaprobabilidad; 
        case Probabilidad of
            CRMQuote.Probabilidad::" ":
                DestinationFieldRef.Value := 0;
            //SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::" ";
            CRMQuote.Probabilidad::Baja:
                //SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::Baja;
                DestinationFieldRef.Value := 1;
            CRMQuote.Probabilidad::Media:
                //SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::Media;
                DestinationFieldRef.Value := 2;
            CRMQuote.Probabilidad::Alta:
                // SalesHeader.ofertaprobabilidad := SalesHeader.ofertaprobabilidad::Alta;
                DestinationFieldRef.Value := 3;
            else
                DestinationFieldRef.Value := 2;
        end;




        DestinationFieldRef := DestinationRecordRef.Field(50911); // OfertaSales
        DestinationFieldRef.Value := true;
        DestinationFieldRef := DestinationRecordRef.Field(50912); // 50912; "No contemplar planificacion"
        DestinationFieldRef.Value := true;

        // poner los ID de cliente
        IF CRMIntegrationRecord.FindRecordIDFromID(CRMquote.CustomerId, Database::"Customer", AccountId) then begin
            if CustRecRef.get(AccountId) then begin
                CustNo := format(CustRecRef.field(Customer.FieldNo("No.")));
                DestinationAccountFieldRef.validate(CustNo);
            end;
        end;

        Commit();

        EXIT(TRUE);
    end;

    local procedure ActualizarCamposOfertaCRMDespues(SourceRecordRef: RecordRef; VAR DestinationRecordRef: RecordRef): Boolean
    var
        DestinationFieldRef: fieldref;
    begin

        exit(true);
    end;

    local procedure ActualizarCamposLineasOfertaCRMDespues(SourceRecordRef: RecordRef; VAR DestinationRecordRef: RecordRef): Boolean
    var
        DestinationFieldRef: fieldref;
        SalesHeader: record "Sales Header";
        SalesLine: record "Sales Line";
    begin

        // Document Type
        DestinationFieldRef := DestinationRecordRef.Field(15);  // Quantity
        DestinationFieldRef.Validate(DestinationFieldRef.Value);
        DestinationRecordRef.SetTable(SalesLine);
        SalesLine.UpdateAmounts();  // JJV control de validate


        exit(true);
    end;

    local procedure ActualizarCamposLineasOfertaCRM(SourceRecordRef: RecordRef; VAR DestinationRecordRef: RecordRef): Boolean
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        Item: Record Item;
        CRMQuoteDetail: Record "STH CRM Quotedetail";
        DestinationRfSalesHeader: RecordRef;
        DestinationFieldRef: FieldRef;
        DestinationFieldRef2: FieldRef;
        SourceFieldRef: FieldRef;
        Probabilidad: Option;
        NoSeriesMgt: codeunit NoSeriesManagement;
        CRMConnectionSetup: record "CRM Connection Setup";// "CRM Connection Setup";  
        bit_bcenviaralerp: Boolean;
        CRMIntegrationRecord: record "CRM Integration Record";
        CustRecRef: RecordRef;
        SaleHeaderRecRef: RecordRef;
        ItemRecRef: RecordRef;
        DestinationAccountFieldRef: FieldRef;
        AccountId: RecordId;
        No: code[20];
        Lineno: integer;
    begin
        SourceRecordRef.SETTABLE(CRMQuoteDetail);
        DestinationRecordRef.SETTABLE(SalesLine);

        // Document Type
        DestinationFieldRef := DestinationRecordRef.Field(1);
        DestinationFieldRef.Value := SalesLine."Document Type"::Quote;

        // Document No.
        SalesHeader.Reset();
        SaleHeaderRecRef.Open(36);
        DestinationFieldRef := DestinationRecordRef.Field(3);
        IF CRMIntegrationRecord.FindRecordIDFromID(CRMQuoteDetail.QuoteId, Database::"Sales Header", AccountId) then begin
            if SaleHeaderRecRef.get(AccountId) then begin
                No := format(SaleHeaderRecRef.field(SalesHeader.fieldNo("No.")));
                DestinationFieldRef.validate(No);
            end;
        end;

        if No = '' then begin
            // buscar en la conexion el numero de cabecera
            CRMIntegrationRecord.SetRange("Table ID", 36);
            CRMIntegrationRecord.SetRange("CRM ID", CRMQuoteDetail.QuoteId);
            if CRMIntegrationRecord.FindSet() then begin
                if SaleHeaderRecRef.get(CRMIntegrationRecord.RecordId) then begin
                    No := format(SaleHeaderRecRef.field(SalesHeader.fieldNo("No.")));
                    DestinationFieldRef.validate(No);
                end;
            end;
        end;

        SalesHeader.GET(SalesHeader."Document Type"::Quote, No);

        if SalesLine."Line No." = 0 then begin
            SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine2.SetRange("Document No.", SalesHeader."No.");
            if SalesLine2.FindLast() then
                Lineno := SalesLine2."Line No." + 10000
            else
                Lineno := 10000;
            DestinationFieldRef := DestinationRecordRef.Field(4);   // Line No.        
            DestinationFieldRef.Value := Lineno;
        end;


        // Sell-to Customer No.
        CustRecRef.Open(18);
        DestinationFieldRef := DestinationRecordRef.Field(2);
        DestinationFieldRef.validate(SalesHeader."Sell-to Customer No.");

        // Item No.
        Item.Reset();
        ItemRecRef.Open(27);
        DestinationFieldRef := DestinationRecordRef.Field(6);  // No.
        IF CRMIntegrationRecord.FindRecordIDFromID(CRMQuoteDetail.ProductId, Database::"Item", AccountId) then begin
            if ItemRecRef.get(AccountId) then begin
                No := format(ItemRecRef.field(Item.fieldNo("No.")));
                if format(DestinationFieldRef.Value) <> No then begin
                    DestinationFieldRef2 := DestinationRecordRef.Field(5);  // Type
                    DestinationFieldRef2.Value := 2;

                    DestinationFieldRef.validate(No);
                end;
            end;
        end;

        // No contemplar planificacion
        DestinationFieldRef := DestinationRecordRef.Field(50912); // 50912; "No contemplar planificacion"
        DestinationFieldRef.Value := true;

        EXIT(TRUE);
    end;

    local procedure GetSourceDestCode(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef): Text
    begin
        IF (SourceRecordRef.
        NUMBER <> 0) AND (DestinationRecordRef.NUMBER <> 0) THEN
            EXIT(STRSUBSTNO('%1-%2', SourceRecordRef.Name(), DestinationRecordRef.Name()));
        EXIT('');
    end;


    local procedure ObtenerTotalPortes(SalesHeader: record "Sales Header") TotalPortes: Decimal
    var
        SalesLine: Record "Sales Line";
    begin
        //Calculo Portes
        TotalPortes := 0;
        SalesLine.RESET;
        SalesLine.SETRANGE(Type, SalesLine.Type::"G/L Account");
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::"G/L Account");
        SalesLine.SETRANGE("No.", '7591000');
        SalesLine.CALCSUMS(Amount);
        TotalPortes := SalesLine.Amount;
        Exit(TotalPortes);
    end;

    //Funciones Transfer Fields

    local procedure ActualizarCamposOferta(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var
        Oferta: Record "Sales Header";
        Customer: record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
        CustomerPriceGroupId: Guid;
        CRMquote: record "CRM Quote";
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        TypeHelper: Codeunit "Type Helper";
        CRMSynchHelper: Codeunit "CRM Synch. Helper";
        DestinationFieldRef: FieldRef;
        TotalPortes: Decimal;
        ShipmentMethod: Record "Shipment Method";
        CRMPricelevel: Record "CRM Pricelevel";
        CRMIntegrationRecord: record "CRM Integration Record";
        AccountId: Guid;
        OutOfMapFilter: boolean;
        CustomerHasChangedErr: Label 'No se puede crear una oferta en %2. El cliente del pedido de venta de %2 original %1 se cambió o ya no está emparejado.', comment = 'ESP="No se puede crear una oferta en %2. El cliente del pedido de venta de %2 original %1 se cambió o ya no está emparejado."';
    begin
        SourceRecordRef.SETTABLE(Oferta);
        DestinationRecordRef.SETTABLE(CRMquote);



        // Shipment Method Code -> go to table Shipment Method, and from there extract the description and add it to
        IF ShipmentMethod.GET(Oferta."Shipment Method Code") THEN BEGIN
            DestinationFieldRef := DestinationRecordRef.FIELD(CRMquote.FIELDNO(Description));
            TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef, ShipmentMethod.Description, TEXTENCODING::UTF16);
        END;

        DestinationRecordRef.SETTABLE(CRMquote);

        //Calculo Portes
        TotalPortes := ObtenerTotalPortes(Oferta);

        CRMquote.FreightAmount := 0;
        CRMquote.DiscountPercentage := 0;
        CRMquote.TotalTax := CRMquote.TotalAmount - CRMquote.TotalAmountLessFreight;
        CRMquote.TotalDiscountAmount := CRMquote.DiscountAmount + CRMquote.TotalLineItemDiscountAmount;
        CRMquote.FreightAmount := TotalPortes;
        //CRMquote.MODIFY;

        CRMquote.Name := Oferta."No.";
        Customer.GET(Oferta."Sell-to Customer No.");

        IF NOT CRMIntegrationRecord.FindIDFromRecordID(Customer.RECORDID, AccountId) THEN
            IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Customer, Customer.RECORDID, OutOfMapFilter) THEN
                ERROR(CustomerHasChangedErr, CRMquote.QuoteNumber, Customer."No.");
        CRMquote.CustomerId := AccountId;
        CRMquote.CustomerIdType := CRMquote.CustomerIdType::account;


        // IF NOT CRMSynchHelper.FindCRMPriceListByCurrencyCode(CRMPricelevel, Oferta."Currency Code") THEN
        //     CRMSynchHelper.CreateCRMPricelevelInCurrency(
        //       CRMPricelevel, Oferta."Currency Code", Oferta."Currency Factor");
        //CRMquote.PriceLevelId := CRMPricelevel.PriceLevelId;
        //END;


        CustomerPriceGroup.Reset();
        CustomerPriceGroup.SetRange(Code, Customer."Customer Price Group");
        if CustomerPriceGroup.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(CustomerPriceGroup.RECORDID, CustomerPriceGroupId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Customer Price Group", CustomerPriceGroup.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM CustomerPriceGroup: ' + Customer."No." + ' Dato: ' + CustomerPriceGroup.Code);
            CRMquote.PriceLevelId := CustomerPriceGroupId;
            AdditionalFieldsWereModified := TRUE;
        end;



        DestinationRecordRef.GETTABLE(CRMquote);





        // DestinationFieldRef := DestinationRecordRef.FIELD(CRMquote.FIELDNO(TransactionCurrencyId));
        // if CRMSynchHelper.UpdateCRMCurrencyIdIfChanged(CRMTransactioncurrency.ISOCurrencyCode, DestinationFieldRef) then
        //     AdditionalFieldsWereModified := true;

        // DestinationFieldRef := DestinationRecordRef.FIELD(CRMquote.FIELDNO(Description));
        // if TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef, CRMquote.Description, TEXTENCODING::UTF16) then
        //     AdditionalFieldsWereModified := true;



        //Si ha habido cambios obtengo registro
        //IF AdditionalFieldsWereModified THEN
        //    DestinationRecordRef.GETTABLE(CRMPricelevel_btc);
    end;

    local procedure ActualizarCamposOfertaNew(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var
        Oferta: Record "Sales Header";
        Customer: record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
        CustomerPriceGroupId: Guid;
        CRMquote: record "STH CRM Quote";
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        TypeHelper: Codeunit "Type Helper";
        CRMSynchHelper: Codeunit "CRM Synch. Helper";
        DestinationFieldRef: FieldRef;
        TotalPortes: Decimal;
        ShipmentMethod: Record "Shipment Method";
        CRMPricelevel: Record "CRM Pricelevel";
        CRMIntegrationRecord: record "CRM Integration Record";
        AccountId: Guid;
        OutOfMapFilter: boolean;
        CustomerHasChangedErr: Label 'No se puede crear una oferta en %2. El cliente del pedido de venta de %2 original %1 se cambió o ya no está emparejado.', comment = 'ESP="No se puede crear una oferta en %2. El cliente del pedido de venta de %2 original %1 se cambió o ya no está emparejado."';
    begin
        SourceRecordRef.SETTABLE(Oferta);
        DestinationRecordRef.SETTABLE(CRMquote);



        // Shipment Method Code -> go to table Shipment Method, and from there extract the description and add it to
        IF ShipmentMethod.GET(Oferta."Shipment Method Code") THEN BEGIN
            DestinationFieldRef := DestinationRecordRef.FIELD(CRMquote.FIELDNO(Description));
            TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef, ShipmentMethod.Description, TEXTENCODING::UTF16);
        END;

        DestinationRecordRef.SETTABLE(CRMquote);

        //Calculo Portes
        TotalPortes := ObtenerTotalPortes(Oferta);

        CRMquote.FreightAmount := 0;
        CRMquote.DiscountPercentage := 0;
        CRMquote.TotalTax := CRMquote.TotalAmount - CRMquote.TotalAmountLessFreight;
        CRMquote.TotalDiscountAmount := CRMquote.DiscountAmount + CRMquote.TotalLineItemDiscountAmount;
        CRMquote.FreightAmount := TotalPortes;
        //CRMquote.MODIFY;

        CRMquote.Name := Oferta."No.";
        Customer.GET(Oferta."Sell-to Customer No.");

        IF NOT CRMIntegrationRecord.FindIDFromRecordID(Customer.RECORDID, AccountId) THEN
            IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Customer, Customer.RECORDID, OutOfMapFilter) THEN
                ERROR(CustomerHasChangedErr, CRMquote.QuoteNumber, Customer."No.");
        CRMquote.CustomerId := AccountId;
        CRMquote.CustomerIdType := CRMquote.CustomerIdType::account;


        // IF NOT CRMSynchHelper.FindCRMPriceListByCurrencyCode(CRMPricelevel, Oferta."Currency Code") THEN
        //     CRMSynchHelper.CreateCRMPricelevelInCurrency(
        //       CRMPricelevel, Oferta."Currency Code", Oferta."Currency Factor");
        //CRMquote.PriceLevelId := CRMPricelevel.PriceLevelId;
        //END;


        CustomerPriceGroup.Reset();
        CustomerPriceGroup.SetRange(Code, Customer."Customer Price Group");
        if CustomerPriceGroup.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(CustomerPriceGroup.RECORDID, CustomerPriceGroupId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Customer Price Group", CustomerPriceGroup.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM CustomerPriceGroup: ' + Customer."No." + ' Dato: ' + CustomerPriceGroup.Code);
            CRMquote.PriceLevelId := CustomerPriceGroupId;
            AdditionalFieldsWereModified := TRUE;
        end;



        DestinationRecordRef.GETTABLE(CRMquote);





        // DestinationFieldRef := DestinationRecordRef.FIELD(CRMquote.FIELDNO(TransactionCurrencyId));
        // if CRMSynchHelper.UpdateCRMCurrencyIdIfChanged(CRMTransactioncurrency.ISOCurrencyCode, DestinationFieldRef) then
        //     AdditionalFieldsWereModified := true;

        // DestinationFieldRef := DestinationRecordRef.FIELD(CRMquote.FIELDNO(Description));
        // if TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef, CRMquote.Description, TEXTENCODING::UTF16) then
        //     AdditionalFieldsWereModified := true;



        //Si ha habido cambios obtengo registro
        //IF AdditionalFieldsWereModified THEN
        //    DestinationRecordRef.GETTABLE(CRMPricelevel_btc);
    end;


    local procedure ActualizarCamposPedidoServicio(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var

        CRMAccount: Record "CRM Account";
        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMPricelevel: Record "CRM Pricelevel";
        CRMIncident: Record "CRM Incident";
        Customer: Record Customer;
        ServiceHeader: Record "Service Header";
        ShipmentMethod: Record "Shipment Method";
        TypeHelper: Codeunit "Type Helper";
        DestinationFieldRef: FieldRef;
        AccountId: GUID;
        OutOfMapFilter: Boolean;
        CustomerHasChangedErr: Label 'No se puede crear un Ped.Servicio en %2. El cliente del pedido de %2 original %1 se cambió o ya no está emparejado.', comment = 'ESP="No se puede crear una Ped.Servicio en %2. El cliente del pedido %2 original %1 se cambió o ya no está emparejado."';
    begin
        SourceRecordRef.SETTABLE(ServiceHeader);

        // Shipment Method Code -> go to table Shipment Method, and from there extract the description and add it to
        IF ShipmentMethod.GET(ServiceHeader."Shipment Method Code") THEN BEGIN
            DestinationFieldRef := DestinationRecordRef.FIELD(CRMIncident.FIELDNO(Description));
            TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef, ShipmentMethod.Description, TEXTENCODING::UTF16);
        END;

        DestinationRecordRef.SETTABLE(CRMIncident);
        Customer.GET(ServiceHeader."Bill-to Customer No.");

        IF NOT CRMIntegrationRecord.FindIDFromRecordID(Customer.RECORDID, AccountId) THEN
            IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Customer, Customer.RECORDID, OutOfMapFilter) THEN
                ERROR(CustomerHasChangedErr, CRMIncident.Title, CRMProductName.SHORT);
        CRMIncident.CustomerId := AccountId;
        CRMIncident.CustomerIdType := CRMIncident.CustomerIdType::account;

        DestinationRecordRef.GETTABLE(CRMIncident);
    end;

    local procedure ActualizarCamposPedido(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var
        Pedido: Record "Sales Header";
        CRMsalesOrder: record "CRM Salesorder_crm_btc"; // "CRM Salesorder_btc";
        CRMTransactioncurrency: Record "CRM Transactioncurrency";

        TypeHelper: Codeunit "Type Helper";
        CRMSynchHelper: Codeunit "CRM Synch. Helper";
        DestinationFieldRef: FieldRef;
        TotalPortes: Decimal;
        ShipmentMethod: Record "Shipment Method";
        Customer: Record Customer;
        CRMPricelevel: Record "CRM Pricelevel";
        CRMIntegrationRecord: record "CRM Integration Record";
        AccountId: Guid;
        OutOfMapFilter: boolean;
        CustomerHasChangedErr: Label 'No se puede crear un Pedido en %2. El cliente del pedido de venta de %2 original %1 se cambió o ya no está emparejado.', comment = 'ESP="No se puede crear un Pedido en %2. El cliente del pedido de venta de %2 original %1 se cambió o ya no está emparejado."';
        SalesLine: Record "Sales Line";
        Salesperson: record "Salesperson/Purchaser";
        SalespersonId: Guid;
        CRMIntegrationTableSynch: Codeunit "CRM Integration Table Synch.";
        SourceLinesRecordRef: RecordRef;
    begin
        SourceRecordRef.SETTABLE(Pedido);
        DestinationRecordRef.SETTABLE(CRMsalesOrder);

        //******************* VENDEDOR DEFECTO ***************************************
        // Si no viene relleno pongo el de defecto
        // JJV quitamos error y ponemos control de poner e
        if Salesperson.GET(Pedido."Salesperson Code") then begin
            if IsNullGuid(CRMsalesOrder.OwnerId) then begin
                IF NOT CRMIntegrationRecord.FindIDFromRecordID(Salesperson.RECORDID, SalespersonId) THEN
                    IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Salesperson/Purchaser", Salesperson.RECORDID, OutOfMapFilter) THEN BEGIN
                        // si no encuentra owner ponemos el id del de setup
                        SalespersonId := 'db0ee768-6b7a-ea11-a812-000d3a2c3eaa';
                    END;
            end;
        end else
            SalespersonId := 'db0ee768-6b7a-ea11-a812-000d3a2c3eaa';
        //    ERROR('CRM Vendedor: ' + Customer."No." + ' Dato: ' + Salesperson.Code);
        CRMsalesOrder.OwnerId := SalespersonId;


        // Shipment Method Code -> go to table Shipment Method, and from there extract the description and add it to
        IF ShipmentMethod.GET(Pedido."Shipment Method Code") THEN BEGIN
            DestinationFieldRef := DestinationRecordRef.FIELD(CRMsalesOrder.FIELDNO(Description));
            TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef, ShipmentMethod.Description, TEXTENCODING::UTF16);
        END;

        DestinationRecordRef.SETTABLE(CRMsalesOrder);

        //Calculo Portes
        TotalPortes := ObtenerTotalPortes(Pedido);

        CRMsalesOrder.FreightAmount := 0;
        CRMsalesOrder.DiscountPercentage := 0;
        CRMsalesOrder.TotalTax := CRMsalesOrder.TotalAmount - CRMsalesOrder.TotalAmountLessFreight;
        CRMsalesOrder.TotalDiscountAmount := CRMsalesOrder.DiscountAmount + CRMsalesOrder.TotalLineItemDiscountAmount;
        CRMsalesOrder.FreightAmount := TotalPortes;
        //CRMquote.MODIFY;

        CRMsalesOrder.Name := Pedido."No.";
        Customer.GET(Pedido."Sell-to Customer No.");

        IF NOT CRMIntegrationRecord.FindIDFromRecordID(Customer.RECORDID, AccountId) THEN
            IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Customer, Customer.RECORDID, OutOfMapFilter) THEN
                ERROR(CustomerHasChangedErr, CRMsalesOrder.OrderNumber, Customer."No.");
        CRMsalesOrder.CustomerId := AccountId;
        CRMsalesOrder.CustomerIdType := CRMsalesOrder.CustomerIdType::account;
        IF NOT CRMSynchHelper.FindCRMPriceListByCurrencyCode(CRMPricelevel, Pedido."Currency Code") THEN
            CRMSynchHelper.CreateCRMPricelevelInCurrency(
              CRMPricelevel, Pedido."Currency Code", Pedido."Currency Factor");
        CRMsalesOrder.PriceLevelId := CRMPricelevel.PriceLevelId;



        //NOTA: Esta parte de las líneas ver si la dejo junta o por separado (se hace en CSIDE en After)
        SalesLine.SETRANGE("Document No.", Pedido."No.");
        IF NOT SalesLine.ISEMPTY THEN BEGIN
            SourceLinesRecordRef.GETTABLE(SalesLine);
            CRMIntegrationTableSynch.SynchRecordsToIntegrationTable(SourceLinesRecordRef, FALSE, FALSE);

            SalesLine.CALCSUMS("Line Discount Amount");
            CRMSalesorder.TotalLineItemDiscountAmount := SalesLine."Line Discount Amount";
        END;



        DestinationRecordRef.GETTABLE(CRMsalesOrder);


        //Si ha habido cambios obtengo registro
        //IF AdditionalFieldsWereModified THEN
        //    DestinationRecordRef.GETTABLE(CRMPricelevel_btc);
    end;

    local procedure ActualizarCamposLinPedido(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var

        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMSalesHeaderId: GUID;
        CRMSalesorderdetail: Record "CRM Salesorderdetail_crm_btc"; //"CRM Salesorderdetail_btc";
        CRMSalesOrder: Record "CRM Salesorder"; // "CRM Salesorder_btc";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        CRMProduct: Record "CRM Product";
        CRMProductId: GUID;
        NoCoupledSalesInvoiceHeaderErr: Label 'No se encuentra el Pedido %1 emparejado.', comment = 'ESP="No se encuentra el Pedido %1 emparejado."';
    begin
        SourceRecordRef.SETTABLE(SalesLine);
        DestinationRecordRef.SETTABLE(CRMSalesorderdetail);

        // Get the NAV and CRM invoice headers
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        IF NOT CRMIntegrationRecord.FindIDFromRecordID(SalesHeader.RECORDID, CRMSalesHeaderId) THEN
            ERROR(NoCoupledSalesInvoiceHeaderErr, CRMProductName.SHORT);

        // Initializo campos desde la cabecera
        CRMSalesorder.GET(CRMSalesHeaderId);
        //CRMSalesorderdetail.ActualDeliveryOn := CRMSalesorder.DateDelivered;
        CRMSalesorderdetail.SalesOrderId := CRMSalesorder.SalesOrderId;
        CRMSalesorderdetail.TransactionCurrencyId := CRMSalesorder.TransactionCurrencyId;
        CRMSalesorderdetail.ExchangeRate := CRMSalesorder.ExchangeRate;
        CRMSalesorderdetail.ShipTo_City := CRMSalesorder.ShipTo_City;
        CRMSalesorderdetail.ShipTo_Country := CRMSalesorder.ShipTo_Country;
        CRMSalesorderdetail.ShipTo_Line1 := CRMSalesorder.ShipTo_Line1;
        CRMSalesorderdetail.ShipTo_Line2 := CRMSalesorder.ShipTo_Line2;
        CRMSalesorderdetail.ShipTo_Line3 := CRMSalesorder.ShipTo_Line3;
        CRMSalesorderdetail.ShipTo_Name := CRMSalesorder.ShipTo_Name;
        CRMSalesorderdetail.ShipTo_PostalCode := CRMSalesorder.ShipTo_PostalCode;
        CRMSalesorderdetail.ShipTo_StateOrProvince := CRMSalesorder.ShipTo_StateOrProvince;
        CRMSalesorderdetail.ShipTo_Fax := CRMSalesorder.ShipTo_Fax;
        CRMSalesorderdetail.ShipTo_Telephone := CRMSalesorder.ShipTo_Telephone;

        CRMSalesorderdetail.TransactionCurrencyId := CRMSynchHelper.GetCRMTransactioncurrency(SalesHeader."Currency Code");
        IF SalesHeader."Currency Factor" = 0 THEN
            CRMSalesorderdetail.ExchangeRate := 1
        ELSE
            CRMSalesorderdetail.ExchangeRate := ROUND(1 / SalesHeader."Currency Factor");

        //Campos desde la LInea
        CRMSalesorderdetail.LineItemNumber := SalesLine."Line No.";
        CRMSalesorderdetail.Tax := SalesLine."Amount Including VAT" - SalesLine.Amount;
        //Datos del Prodcuto
        CRMProductId := FindCRMProductIdPedidos(SalesLine);
        IF ISNULLGUID(CRMProductId) THEN BEGIN
            // This will be created as a CRM write-in product
            CRMSalesorderdetail.IsProductOverridden := TRUE;
            CRMSalesorderdetail.ProductDescription :=
              STRSUBSTNO('%1 %2.', FORMAT(SalesLine."No."), FORMAT(SalesLine.Description));
        END ELSE BEGIN
            // There is a coupled product or resource in CRM, transfer data from there
            CRMProduct.GET(CRMProductId);
            CRMSalesorderdetail.ProductId := CRMProduct.ProductId;
            CRMSalesorderdetail.UoMId := CRMProduct.DefaultUoMId;
        END;
        //En las facturas se crea el Producto si no existe
        //CRMSynchHelper.CreateCRMProductpriceIfAbsent(CRMInvoicedetail);

        DestinationRecordRef.GETTABLE(CRMSalesorderdetail);
    end;

    local procedure ActualizarCamposLinOferta(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var

        CRMIntegrationRecord: Record "CRM Integration Record";
        CRMSalesHeaderId: GUID;
        CRMSalesorderdetail: Record "STH CRM Quotedetail";
        CRMSalesOrder: Record "CRM Quote";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        CRMProduct: Record "CRM Product";
        CRMProductId: GUID;
        NoCoupledSalesInvoiceHeaderErr: Label 'No se encuentra la Oferta %1 emparejado.', comment = 'ESP="No se encuentra la Oferta %1 emparejada."';
    begin
        SourceRecordRef.SETTABLE(SalesLine);
        DestinationRecordRef.SETTABLE(CRMSalesorderdetail);

        // Get the NAV and CRM invoice headers
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        IF NOT CRMIntegrationRecord.FindIDFromRecordID(SalesHeader.RECORDID, CRMSalesHeaderId) THEN
            ERROR(NoCoupledSalesInvoiceHeaderErr, CRMProductName.SHORT);

        // Initializo campos desde la cabecera
        CRMSalesorder.GET(CRMSalesHeaderId);
        //CRMSalesorderdetail.ActualDeliveryOn := CRMSalesorder.DateDelivered;
        CRMSalesorderdetail.QuoteId := CRMSalesorder.QuoteId;
        CRMSalesorderdetail.TransactionCurrencyId := CRMSalesorder.TransactionCurrencyId;
        CRMSalesorderdetail.ExchangeRate := CRMSalesorder.ExchangeRate;
        CRMSalesorderdetail.ShipTo_City := CRMSalesorder.ShipTo_City;
        CRMSalesorderdetail.ShipTo_Country := CRMSalesorder.ShipTo_Country;
        CRMSalesorderdetail.ShipTo_Line1 := CRMSalesorder.ShipTo_Line1;
        CRMSalesorderdetail.ShipTo_Line2 := CRMSalesorder.ShipTo_Line2;
        CRMSalesorderdetail.ShipTo_Line3 := CRMSalesorder.ShipTo_Line3;
        CRMSalesorderdetail.ShipTo_Name := CRMSalesorder.ShipTo_Name;
        CRMSalesorderdetail.ShipTo_PostalCode := CRMSalesorder.ShipTo_PostalCode;
        CRMSalesorderdetail.ShipTo_StateOrProvince := CRMSalesorder.ShipTo_StateOrProvince;
        CRMSalesorderdetail.ShipTo_Fax := CRMSalesorder.ShipTo_Fax;
        CRMSalesorderdetail.ShipTo_Telephone := CRMSalesorder.ShipTo_Telephone;

        CRMSalesorderdetail.TransactionCurrencyId := CRMSynchHelper.GetCRMTransactioncurrency(SalesHeader."Currency Code");
        IF SalesHeader."Currency Factor" = 0 THEN
            CRMSalesorderdetail.ExchangeRate := 1
        ELSE
            CRMSalesorderdetail.ExchangeRate := ROUND(1 / SalesHeader."Currency Factor");

        //Campos desde la LInea
        CRMSalesorderdetail.LineItemNumber := SalesLine."Line No.";
        CRMSalesorderdetail.Tax := SalesLine."Amount Including VAT" - SalesLine.Amount;
        //Datos del Prodcuto
        CRMProductId := FindCRMProductIdPedidos(SalesLine);
        IF ISNULLGUID(CRMProductId) THEN BEGIN
            // This will be created as a CRM write-in product
            CRMSalesorderdetail.IsProductOverridden := TRUE;
            CRMSalesorderdetail.ProductDescription :=
              STRSUBSTNO('%1 %2.', FORMAT(SalesLine."No."), FORMAT(SalesLine.Description));
        END ELSE BEGIN
            // There is a coupled product or resource in CRM, transfer data from there
            CRMProduct.GET(CRMProductId);
            CRMSalesorderdetail.ProductId := CRMProduct.ProductId;
            CRMSalesorderdetail.UoMId := CRMProduct.DefaultUoMId;
        END;
        //En las facturas se crea el Producto si no existe
        //CRMSynchHelper.CreateCRMProductpriceIfAbsent(CRMInvoicedetail);

        DestinationRecordRef.GETTABLE(CRMSalesorderdetail);
    end;



    local procedure FindCRMProductIdPedidos(SalesLine: Record "Sales Line") CRMID: GUID
    var

        CRMIntegrationRecord: Record "CRM Integration Record";
        Resource: Record Resource;
        OutOfMapFilter: Boolean;
        CannotFindSyncedProductErr: Label 'No se puede encontrar un producto sincronizado para %1.', comment = 'ESP="No se puede encontrar un producto sincronizado para %1."';
        CannotSynchProductErr: Label 'No se puede sincronizar el producto %1.', comment = 'ESP="No se puede sincronizar el producto %1."';

    begin
        CLEAR(CRMID);
        CASE SalesLine.Type OF
            SalesLine.Type::Item:
                CRMID := FindCRMProductIdForItem(SalesLine."No.");
            SalesLine.Type::Resource:
                BEGIN
                    Resource.GET(SalesLine."No.");
                    IF NOT CRMIntegrationRecord.FindIDFromRecordID(Resource.RECORDID, CRMID) THEN BEGIN
                        IF CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Resource, Resource.RECORDID, OutOfMapFilter) THEN
                            //ERROR(CannotSynchProductErr, Resource."No.");
                        IF NOT CRMIntegrationRecord.FindIDFromRecordID(Resource.RECORDID, CRMID) THEN;

                    END;
                END;
        END;
    end;

    local procedure FindCRMProductIdForItem(ItemNo: Code[20]) CRMID: GUID
    var

        Item: Record Item;
        CRMIntegrationRecord: Record "CRM Integration Record";
        OutOfMapFilter: Boolean;

        CannotFindSyncedProductErr: Label 'No se puede encontrar un producto sincronizado para %1.', comment = 'ESP="No se puede encontrar un producto sincronizado para %1."';
        CannotSynchProductErr: Label 'No se puede sincronizar el producto %1.', comment = 'ESP="No se puede sincronizar el producto %1."';


    begin
        Item.GET(ItemNo);
        IF NOT CRMIntegrationRecord.FindIDFromRecordID(Item.RECORDID, CRMID) THEN BEGIN
            IF CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Item, Item.RECORDID, OutOfMapFilter) THEN
                //ERROR(CannotSynchProductErr, Item."No.");
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(Item.RECORDID, CRMID) THEN;
            //ERROR(CannotFindSyncedProductErr);
        end;
    end;

    local procedure ActualizarCamposTarifa(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var
        CustomerPriceGroup: Record "Customer Price Group";
        CRMPricelevel_btc: record "CRM Pricelevel_crm_btc"; // "CRM Pricelevel_btc";
        CRMTransactioncurrency: Record "CRM Transactioncurrency";
        CRMIntegrationRecord: Record "CRM Integration Record";
        TypeHelper: Codeunit "Type Helper";
        CRMSynchHelper: Codeunit "CRM Synch. Helper";
        DestinationFieldRef: FieldRef;
        Currency: record Currency;
        CurrencyId: Guid;
        CodMoneda: COde[20];
        OutOfMapFilter: Boolean;
        SalesPrice: Record "Sales Price";
    begin
        SourceRecordRef.SETTABLE(CustomerPriceGroup);
        DestinationRecordRef.SETTABLE(CRMPricelevel_btc);

        //CheckCustPriceGroupForSync(CRMTransactioncurrency,CustomerPriceGroup);

        SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SETRANGE("Sales Code", CustomerPriceGroup.Code);
        IF SalesPrice.FINDFIRST THEN BEGIN
            CRMTransactioncurrency.GET(CRMSynchHelper.GetCRMTransactioncurrency(SalesPrice."Currency Code"));
            //CheckSalesPricesForSync(CustomerPriceGroup.Code,SalesPrice."Currency Code"); //Comprueba que sean todos iguales
        END ELSE
            CRMSynchHelper.FindNAVLocalCurrencyInCRM(CRMTransactioncurrency);

        CRMPricelevel_btc.TransactionCurrencyId := CRMTransactioncurrency.TransactionCurrencyId;

        //******************** MONEDA ********************
        // if (CustomerPriceGroup.Code = 'ZUMMO-INC') then CodMoneda := 'USD' else CodMoneda := 'EUR';
        // Currency.Reset();
        // Currency.SetRange(Code, CodMoneda);
        // if Currency.FindFirst() then begin
        //     IF NOT CRMIntegrationRecord.FindIDFromRecordID(Currency.RECORDID, CurrencyId) THEN
        //         IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Currency", Currency.RECORDID, OutOfMapFilter) THEN
        //             ERROR('CRM GrupoPreciosCliente: ' + CustomerPriceGroup.Code + ' Dato: ' + Currency.Code);
        //     CRMPricelevel_btc.TransactionCurrencyId := CurrencyId;
        //     AdditionalFieldsWereModified := TRUE;
        // end;


        // DestinationFieldRef := DestinationRecordRef.FIELD(CRMPricelevel_btc.FIELDNO(TransactionCurrencyId));
        // if CRMSynchHelper.UpdateCRMCurrencyIdIfChanged(CRMTransactioncurrency.ISOCurrencyCode, DestinationFieldRef) then
        //     AdditionalFieldsWereModified := true;

        DestinationFieldRef := DestinationRecordRef.FIELD(CRMPricelevel_btc.FIELDNO(Description));
        if TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef, CustomerPriceGroup.Description, TEXTENCODING::UTF16) then
            AdditionalFieldsWereModified := true;



        //Si ha habido cambios obtengo registro
        /// IF AdditionalFieldsWereModified THEN
        DestinationRecordRef.GETTABLE(CRMPricelevel_btc);
    end;

    // local procedure CheckSalesPricesForSync(CustomerPriceGroupCode: Code[10]; ExpectedCurrencyCode: Code[10])
    // var

    //     SalesPrice: Record "Sales Price";
    //     CRMUom: Record "CRM Uom";
    // begin

    //     SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
    //     SalesPrice.SETRANGE("Sales Code", CustomerPriceGroupCode);
    //     IF SalesPrice.FINDSET THEN
    //         REPEAT
    //             SalesPrice.TESTFIELD("Currency Code", ExpectedCurrencyCode);
    //             FindCRMProductIdForItem(SalesPrice."Item No.");
    //             FindCRMUoMIdForSalesPrice(SalesPrice, CRMUom);
    //         UNTIL SalesPrice.NEXT = 0;
    // end;

    local procedure ActualizarCamposProducto(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var
        CRMProductos_btc: Record "CRM Productos_crm_btc"; // "CRM Productos_btc";
        // CRMProduct: Record "CRM Product";
        CRMIntegrationRecord: Record "CRM Integration Record";
        TextosAuxiliares: Record TextosAuxiliares;
        Item: Record Item;
        TypeHelper: Codeunit "Type Helper";
        ProductId: GUID;
        TextosAuxiliaresId: Guid;
        CRMSynchHelper: codeunit "CRM Synch. Helper";
        OutOfMapFilter: boolean;

        SourceFieldRef: FieldRef;
        DestinationFieldRef: FieldRef;
        Blocked: boolean;
        Resource: Record Resource;
        GeneralLedgerSetup: Record "General Ledger Setup";
        UnitOfMeasureCodeFieldRef: FieldRef;
        UnitOfMeasureCode: Code[10];
        ProductTypeCode: Option;

        CRMUom: Record "CRM Uom";
        CRMUomschedule: Record "CRM Uomschedule";
        UnitofMeasure: record "Unit of Measure";
        UnidadId: Guid;

        CRMPricelevel: Record "CRM Pricelevel";
        CRMProductpricelevel: record "CRM Productpricelevel";
        Vendor: record Vendor;
        NewStateCode: option;
        CustomerPriceGroup: Record "Customer Price Group";
        CustomerPriceGroupId: Guid;
    begin

        SourceRecordRef.SETTABLE(Item);
        DestinationRecordRef.SETTABLE(CRMProductos_btc);


        //******************** UNIDAD ********************
        // UnitofMeasure.Reset();
        // UnitofMeasure.SetRange(Code, Item."Base Unit of Measure");
        // if UnitofMeasure.FindFirst() then begin
        //     IF NOT CRMIntegrationRecord.FindIDFromRecordID(UnitofMeasure.RECORDID, UnidadId) THEN
        //         IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Unit of Measure", UnitofMeasure.RECORDID, OutOfMapFilter) THEN
        //             ERROR('CRM Unidades: ' + Item."No." + ' Dato: ' + UnitofMeasure.Code);
        //     CRMProductos_btc.DefaultUoMScheduleId := UnidadId;
        //     CRMProductos_btc. := UnidadId;
        //     AdditionalFieldsWereModified := TRUE;
        //end;



        // Update CRM UoM ID, UoMSchedule Id. The CRM UoM Name and UoMScheduleName will be cascade-updated from their IDs by CRM
        IF SourceRecordRef.NUMBER = DATABASE::Item THEN BEGIN
            Blocked := SourceRecordRef.FIELD(Item.FIELDNO(Blocked)).VALUE;
            UnitOfMeasureCodeFieldRef := SourceRecordRef.FIELD(Item.FIELDNO("Base Unit of Measure"));
            ProductTypeCode := CRMProductos_btc.ProductTypeCode::SalesInventory;


        END;

        IF SourceRecordRef.NUMBER = DATABASE::Resource THEN BEGIN
            Blocked := SourceRecordRef.FIELD(Resource.FIELDNO(Blocked)).VALUE;
            UnitOfMeasureCodeFieldRef := SourceRecordRef.FIELD(Resource.FIELDNO("Base Unit of Measure"));
            ProductTypeCode := CRMProductos_btc.ProductTypeCode::Services;
        END;

        UnitOfMeasureCodeFieldRef.TESTFIELD;
        UnitOfMeasureCode := FORMAT(UnitOfMeasureCodeFieldRef.VALUE);

        CRMProductos_btc.QuantityDecimal := 2; //2 decimales por defecto
        if Item.Blocked or item."Sales Blocked" then
            CRMProductos_btc.StatusCode := CRMProductos_btc.StatusCode::Retired //CRMProductos_btc.StatusCode::Retired;
        else
            CRMProductos_btc.StatusCode := CRMProductos_btc.StatusCode::Active;//CRMProductos_btc.StatusCode::Active;

        // Get the unit of measure ID used in this product
        // On that unit of measure ID, get the UoMName, UomscheduleID, UomscheduleName and update them in the product if needed

        // GetValidCRMUnitOfMeasureRecords(CRMUom, CRMUomschedule, UnitOfMeasureCode);

        // // Update UoM ID if changed
        // IF  CRMProduct.DefaultUoMId <> CRMUom.UoMId THEN BEGIN
        //     CRMProduct.DefaultUoMId := CRMUom.UoMId;
        //     AdditionalFieldsWereModified := TRUE;
        // END;

        // // Update the Uomschedule ID if changed
        // IF CRMProduct.DefaultUoMScheduleId <> CRMUomschedule.UoMScheduleId THEN BEGIN
        //     CRMProduct.DefaultUoMScheduleId := CRMUomschedule.UoMScheduleId;
        //     AdditionalFieldsWereModified := TRUE;
        // END;


        // Update CRM Currency Id (if changed)
        GeneralLedgerSetup.GET;
        DestinationFieldRef := DestinationRecordRef.FIELD(CRMProductos_btc.FIELDNO(TransactionCurrencyId));
        IF CRMSynchHelper.UpdateCRMCurrencyIdIfChanged(FORMAT(GeneralLedgerSetup."LCY Code"), DestinationFieldRef) THEN
            AdditionalFieldsWereModified := TRUE;



        // Get the unit of measure ID used in this product
        // On that unit of measure ID, get the UoMName, UomscheduleID, UomscheduleName and update them in the product if needed
        //****** UOM ***********************************
        CRMSynchHelper.GetValidCRMUnitOfMeasureRecords(CRMUom, CRMUomschedule, UnitOfMeasureCode);
        // Update UoM ID if changed
        IF CRMProductos_btc.DefaultUoMId <> CRMUom.UoMId THEN BEGIN
            CRMProductos_btc.DefaultUoMId := CRMUom.UoMId;
            AdditionalFieldsWereModified := TRUE;
        END;
        // Update the Uomschedule ID if changed
        IF CRMProductos_btc.DefaultUoMScheduleId <> CRMUomschedule.UoMScheduleId THEN BEGIN
            CRMProductos_btc.DefaultUoMScheduleId := CRMUomschedule.UoMScheduleId;
            AdditionalFieldsWereModified := TRUE;
        END;



        // // If the CRMProduct price is negative, update it to zero (CRM doesn't allow negative prices)
        IF CRMProductos_btc.Price < 0 THEN
            CRMProductos_btc.Price := 0;

        // // If the CRM Quantity On Hand is negative, update it to zero
        IF CRMProductos_btc.QuantityOnHand < 0 THEN
            CRMProductos_btc.QuantityOnHand := 0;

        //ZZZ Que no cree Listas de Precio al sincroniazar el Producto
        // // Create or update the default price list
        // IF not (ISNULLGUID(CRMProductos_btc.ProductId)) THEN begin
        //     CRMSynchHelper.FindCRMDefaultPriceList(CRMPricelevel); //Obtengo la lista Precios Defecto
        //     IF CRMProductos_btc.PriceLevelId <> CRMPricelevel.PriceLevelId THEN BEGIN
        //         CRMProductos_btc.PriceLevelId := CRMPricelevel.PriceLevelId;
        //         AdditionalFieldsWereModified := TRUE;
        //     END;


        //     CRMProductpricelevel.SETRANGE(ProductId, CRMProductos_btc.ProductId);
        //     CRMProductpricelevel.SETRANGE(PriceLevelId, CRMProductos_btc.PriceLevelId);
        //     IF CRMProductpricelevel.FINDFIRST THEN
        //         EXIT(ActualizarCRMProductpricelevel(CRMProductpricelevel, CRMProductos_btc) OR AdditionalFieldsWereModified);

        //     WITH CRMProductpricelevel DO BEGIN
        //         INIT;
        //         PriceLevelId := CRMProductos_btc.PriceLevelId;
        //         UoMId := CRMProductos_btc.DefaultUoMId;
        //         UoMScheduleId := CRMProductos_btc.DefaultUoMScheduleId;
        //         ProductId := CRMProductos_btc.ProductId;
        //         Amount := CRMProductos_btc.Price;
        //         TransactionCurrencyId := CRMProductos_btc.TransactionCurrencyId;
        //         ProductNumber := CRMProductos_btc.ProductNumber;
        //         INSERT;
        //     END;
        // end;

        CustomerPriceGroup.Reset();
        CustomerPriceGroup.SetRange(Code, 'PVP');
        if CustomerPriceGroup.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(CustomerPriceGroup.RECORDID, CustomerPriceGroupId) THEN
                IF CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Customer Price Group", CustomerPriceGroup.RECORDID, OutOfMapFilter) THEN;
            // quitamos errores
            //ERROR('CRM CustomerPriceGroup: ' + Item."No." + ' Dato: ' + CustomerPriceGroup.Code);
            CRMProductos_btc.PriceLevelId := CustomerPriceGroupId;
            AdditionalFieldsWereModified := TRUE;
        end;


        // // Update the Vendor Name
        IF Vendor.GET(CRMProductos_btc.VendorPartNumber) THEN begin

            IF CRMProductos_btc.VendorName <> Vendor.Name THEN
                CRMProductos_btc.VendorName := Vendor.Name;
        end;

        // // Set the ProductTypeCode, to later know if this product came from an item or from a resource
        // We use ProductTypeCode::SalesInventory and ProductTypeCode::Services to trace back later,
        // where this CRM product originated from: a NAV Item, or a NAV Resource
        IF CRMProductos_btc.ProductTypeCode <> ProductTypeCode THEN
            CRMProductos_btc.ProductTypeCode := ProductTypeCode;


        // IF Blocked THEN
        //     NewStateCode := CRMProductos_btc.StateCode::Retired
        // ELSE
        //     NewStateCode := CRMProductos_btc.StateCode::Active;

        // IF NewStateCode <> CRMProductos_btc.StateCode THEN BEGIN
        //    
        //IF Blocked THEN
        //    CRMProductos_btc.StatusCode := CRMProductos_btc.StatusCode::Retired
        //ELSE
        CRMProductos_btc.StateCode := 0;//CRMProductos_btc.StateCode::Active;
        CRMProductos_btc.StatusCode := 1;//CRMProductos_btc.StatusCode::Active;
        //    end;
        //end;



        //******************** CAMPOS PROPIOS ITEM ********************
        //        TextosAuxiliares.Reset();
        // TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        // TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::AreaManager);
        // TextosAuxiliares.SetRange(NumReg, Customer.AreaManager_btc);
        // if TextosAuxiliares.FindFirst() then begin
        //     IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
        //         IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
        //             ERROR('CRM AreaManager: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
        //     CRMAccount2.zum_bcareamanager := TextosAuxiliaresId;


        //     AdditionalFieldsWereModified := TRUE;
        // end;

        //Si ha habido cambios obtengo registro
        // IF AdditionalFieldsWereModified THEN
        DestinationRecordRef.GETTABLE(CRMProductos_btc);
    end;

    local procedure ActualizarCRMProductpricelevel(VAR CRMProductpricelevel: Record "CRM Productpricelevel"; CRMProduct: Record "CRM Productos_crm_btc") AdditionalFieldsWereModified: Boolean
    begin
        WITH CRMProductpricelevel DO BEGIN
            IF PriceLevelId <> CRMProduct.PriceLevelId THEN BEGIN
                PriceLevelId := CRMProduct.PriceLevelId;
                AdditionalFieldsWereModified := TRUE;
            END;

            IF UoMId <> CRMProduct.DefaultUoMId THEN BEGIN
                UoMId := CRMProduct.DefaultUoMId;
                AdditionalFieldsWereModified := TRUE;
            END;

            IF UoMScheduleId <> CRMProduct.DefaultUoMScheduleId THEN BEGIN
                UoMScheduleId := CRMProduct.DefaultUoMScheduleId;
                AdditionalFieldsWereModified := TRUE;
            END;

            IF Amount <> CRMProduct.Price THEN BEGIN
                Amount := CRMProduct.Price;
                AdditionalFieldsWereModified := TRUE;
            END;

            IF TransactionCurrencyId <> CRMProduct.TransactionCurrencyId THEN BEGIN
                TransactionCurrencyId := CRMProduct.TransactionCurrencyId;
                AdditionalFieldsWereModified := TRUE;
            END;

            IF ProductNumber <> CRMProduct.ProductNumber THEN BEGIN
                ProductNumber := CRMProduct.ProductNumber;
                AdditionalFieldsWereModified := TRUE;
            END;

            IF AdditionalFieldsWereModified THEN
                MODIFY;
        END;
    end;

    local procedure ActualizarCamposCliente(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef) AdditionalFieldsWereModified: Boolean;
    var
        CRMAccount2: Record "CRM Account_crm_btc";
        CRMIntegrationRecord: Record "CRM Integration Record";
        TextosAuxiliares: Record TextosAuxiliares;
        Customer: Record Customer;
        Paises: Record "Country/Region";
        TypeHelper: Codeunit "Type Helper";
        AccountId: GUID;
        PaisesId: Guid;
        TextosAuxiliaresId: Guid;
        CRMSynchHelper: codeunit "CRM Synch. Helper";
        OutOfMapFilter: boolean;
        PaymentMethod: Record "Payment Method";
        PaymentMethodId: Guid;
        PaymentTerms: Record "Payment Terms";
        PaymentTermsId: Guid;
        SourceFieldRef: FieldRef;
        DestinationFieldRef: FieldRef;
        CRMPricelevel_btc: record "CRM Pricelevel_crm_btc"; // "CRM Pricelevel_btc";
        CustomerPriceGroup: Record "Customer Price Group";
        CustomerPriceGroupId: Guid;
        Provincia: record "Area";
        ProvinciaId: Guid;
        CRMConnectionSetup: record "CRM Connection Setup";
        Salesperson: record "Salesperson/Purchaser";
        SalespersonId: Guid;
        CodigosPostales: Record "Post Code";
        Update: Boolean;
    begin

        SourceRecordRef.SETTABLE(Customer);
        DestinationRecordRef.SETTABLE(CRMAccount2);

        CRMConnectionSetup.get();
        if (CRMConnectionSetup."NºSerie Lead CRM" = '') then
            ERROR('Debe asignar número de serie a los Leads CRM');


        // //Credito Interno
        // if Customer."Credito Maximo Interno_btc" > 0 then begin
        //     CRMAccount2.zum_Creditointerno := Customer."Credito Maximo Interno_btc";
        //     CRMAccount2.zum_creditointerno_Base := Customer."Credito Maximo Interno_btc";
        //     // DestinationFieldRef := DestinationRecordRef.FIELD(CRMAccount2.FIELDNO(zum_Creditointerno));
        //     // DestinationFieldRef.VALUE := Customer."Credito Maximo Interno_btc";
        //     // DestinationFieldRef := DestinationRecordRef.FIELD(CRMAccount2.FIELDNO(zum_creditointerno_Base));
        //     // DestinationFieldRef.VALUE := Customer."Credito Maximo Interno_btc";


        //CRMAccount2.customertypecode := CRMAccount2.customertypecode::Customer;

        //******************* VENDEDOR DEFECTO ***************************************
        //Si no viene relleno pongo el de defecto
        // JJV no esta posicionado el salesperson en un registro y si no existe lo pongo en ZUMMO
        if Salesperson.GET(Customer."Salesperson Code") then begin
            Update := false;
            if IsNullGuid(CRMAccount2.OwnerId) then begin
                IF CRMIntegrationRecord.FindIDFromRecordID(Salesperson.RECORDID, SalespersonId) THEN
                    Update := true
                ELSE
                    IF CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Salesperson/Purchaser", Salesperson.RECORDID, OutOfMapFilter) THEN
                        Update := true;
                //ERROR('CRM Vendedor: ' + Customer."No." + ' Dato: ' + Salesperson.Code);
                if Update then
                    CRMAccount2.OwnerId := SalespersonId;
            end;
        end;
        // - JJV
        // 27/12/2022 esto igual deberia estar por AREA MANAGER () nueva funcionalidad para permisos SALES
        if GetUpdateOwnerSales(Customer, SalespersonId) then begin
        end;

        //******************** PROVINCIA ********************
        Provincia.Reset();
        Provincia.SetRange(Code, copystr(Customer."Post Code", 1, 2));
        if Provincia.FindFirst() then begin
            IF CRMIntegrationRecord.FindIDFromRecordID(Provincia.RECORDID, ProvinciaId) THEN
                Update := true
            ELSE
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Area", Provincia.RECORDID, OutOfMapFilter) THEN
                    Update := true;
            if update then BEGIN
                //      ERROR('CRM Provincia: ' + Customer."No." + ' Dato: ' + Provincia.Code);
                if not IsNullGuid(ProvinciaId) then begin
                    CRMAccount2.bit_bcprovincia := ProvinciaId;
                    AdditionalFieldsWereModified := TRUE;
                end;
            END;
        end;

        //******************** PAIS ********************
        Paises.Reset();
        Paises.SetRange(Code, Customer."Country/Region Code");
        if Paises.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(Paises.RECORDID, PaisesId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Country/Region", Paises.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM Paises: ' + Customer."No." + ' Dato: ' + Paises.Code);
            CRMAccount2.bit_BCPais := PaisesId;
            CRMAccount2.Address1_Country := Paises.Name; //Campo std del CRM para el mapa

            AdditionalFieldsWereModified := TRUE;
        end;
        //******************** AREA MANAGER ********************
        TextosAuxiliares.Reset();
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::AreaManager);
        TextosAuxiliares.SetRange(NumReg, Customer.AreaManager_btc);
        if TextosAuxiliares.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM AreaManager: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
            CRMAccount2.zum_bcareamanager := TextosAuxiliaresId;

            AdditionalFieldsWereModified := TRUE;
        end;
        //******************** DELEGADO ********************
        TextosAuxiliares.Reset();
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::Delegado);
        TextosAuxiliares.SetRange(NumReg, Customer.Delegado_btc);
        Update := false;
        if TextosAuxiliares.FindFirst() then begin
            IF CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                Update := true
            ELSE
                IF CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                    Update := true;
            //ERROR('CRM Delegado: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
            if Update then begin
                CRMAccount2.zum_bcdelegado := TextosAuxiliaresId;
                AdditionalFieldsWereModified := TRUE;
            end;
        end;
        //******************** CLIENTE CORPORATIVO ********************
        TextosAuxiliares.Reset();
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::"Cliente Corporativo");
        TextosAuxiliares.SetRange(NumReg, Customer.ClienteCorporativo_btc);
        if TextosAuxiliares.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM ClienteCorporativo: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
            CRMAccount2.zum_bcclientecorporativo := TextosAuxiliaresId;
            AdditionalFieldsWereModified := TRUE;
        end;

        //******************** GRUPO CLIENTE  ********************
        TextosAuxiliares.Reset();
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::GrupoCliente);
        TextosAuxiliares.SetRange(NumReg, Customer.GrupoCliente_btc);
        if TextosAuxiliares.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM GrupoCliente: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
            CRMAccount2.zum_grupodecliente := TextosAuxiliaresId;
            AdditionalFieldsWereModified := TRUE;
        end;
        //******************** CLIENTE ACTIVIDAD  ********************
        TextosAuxiliares.Reset();
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::ClienteActividad);
        TextosAuxiliares.SetRange(NumReg, Customer.ClienteActividad_btc);
        if TextosAuxiliares.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM ClienteActividad: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
            CRMAccount2.zum_bcactividadcliente := TextosAuxiliaresId;
            AdditionalFieldsWereModified := TRUE;
        end;
        //******************** FORMA PAGO ********************
        PaymentMethod.Reset();
        PaymentMethod.SetRange(Code, Customer."Payment Method Code");
        if PaymentMethod.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(PaymentMethod.RECORDID, PaymentMethodId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Payment Method", PaymentMethod.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM PaymentMethod: ' + Customer."No." + ' Dato: ' + PaymentMethod.Code);
            CRMAccount2.bit_bcformadepago := PaymentMethodId;
            AdditionalFieldsWereModified := TRUE;
        end;
        //******************** TERMINOS PAGO ********************
        PaymentTerms.Reset();
        PaymentTerms.SetRange(Code, Customer."Payment Terms Code");
        if PaymentTerms.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(PaymentTerms.RECORDID, PaymentTermsId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Payment Terms", PaymentTerms.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM PaymentTerms: ' + Customer."No." + ' Dato: ' + PaymentMethod.Code);

            CRMAccount2.bit_bcterminosdepago := PaymentTermsId;
            AdditionalFieldsWereModified := TRUE;
        end;
        //******************** TARIFA ********************
        CustomerPriceGroup.Reset();
        CustomerPriceGroup.SetRange(Code, Customer."Customer Price Group");
        if CustomerPriceGroup.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(CustomerPriceGroup.RECORDID, CustomerPriceGroupId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"Customer Price Group", CustomerPriceGroup.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM CustomerPriceGroup: ' + Customer."No." + ' Dato: ' + CustomerPriceGroup.Code);
            CRMAccount2.DefaultPriceLevelId := CustomerPriceGroupId;
            AdditionalFieldsWereModified := TRUE;
        end;

        //******************** CANAL ********************  
        TextosAuxiliares.Reset();
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::Canal);
        TextosAuxiliares.SetRange(NumReg, Customer.Canal_btc);
        if TextosAuxiliares.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM Canal: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
            CRMAccount2.zum_canal := TextosAuxiliaresId;
            AdditionalFieldsWereModified := TRUE;
        end;

        //******************** MERCADO ********************  
        /* se quita porque segun el cliente tipo en SALES ya pone el dato segun clientetipo
         TextosAuxiliares.Reset();
         TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
         TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::Mercados);
         TextosAuxiliares.SetRange(NumReg, Customer.Mercado_btc);
         if TextosAuxiliares.FindFirst() then begin
             IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                 IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                     ERROR('CRM Mercado: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
             CRMAccount2.zum_mercado := TextosAuxiliaresId;
             AdditionalFieldsWereModified := TRUE;
         end;*/

        //******************** DISTRIBUIDOR ********************  
        /* NO EXISTE EL CAMPO DISTRIBUIDOR EN BC
        TextosAuxiliares.Reset();
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::);
        TextosAuxiliares.SetRange(NumReg, Customer.GrupoCliente_btc);
        if TextosAuxiliares.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM DISTRIBUIDOR: ' + Customer."No." + ' Dato: ' + TextosAuxiliares.NumReg);
            CRMAccount2.zum_canal := TextosAuxiliaresId;
            AdditionalFieldsWereModified := TRUE;
        end;*/

        //******************** CENTRAL DE COMPRAS ********************  
        // Option
        case Customer.CentralCompras_btc OF
            'EUROMADI':
                CRMAccount2.bit_centralcompras := CRMAccount2.bit_centralcompras::EUROMADI;
            'GRUPO IFA':
                CRMAccount2.bit_centralcompras := CRMAccount2.bit_centralcompras::"GRUPO IFA";
            else
                CRMAccount2.bit_centralcompras := CRMAccount2.bit_centralcompras::" ";
        end;

        //******************** SUBCLIENTE ********************  TODO
        // Option
        case Customer.SubCliente_btc OF
            'AHOLD':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::AHOLD;
            'AREAS':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::AREAS;
            'CASINO':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::CASINO;
            'CATALONIA':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::CATALONIA;
            'CHICK FIL A':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::"CHICK FIL A";
            'GUFRESCO':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::GUFRESCO;
            'INTERMARCHE':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::INTERMARCHE;
            'LECLERC':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::LECLERC;
            'MENSSANA':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::MENSSANA;
            'MONOPRIX':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::MONOPRIX;
            'RODILLA':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::RODILLA;
            'VIPS':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::VIPS;
            'WALMART':
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::WALMART;
            else
                CRMAccount2.bit_subclientebc := CRMAccount2.bit_subclientebc::" ";
        end;

        if UpdateBCCRMDtoAccounts(Customer, CRMAccount2) then
            Customer.Modify();


        //Si ha habido cambios obtengo registro
        IF AdditionalFieldsWereModified THEN
            DestinationRecordRef.GETTABLE(CRMAccount2);



    end;
    //Fin Funciones Transfer Fields

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Management", 'OnIsIntegrationRecord', '', true, true)]
    local procedure HandleOnIsIntegrationRecord(TableID: Integer; var isIntegrationRecord: Boolean)
    begin
        if TableID = DATABASE::TextosAuxiliares then //AreaManager,ClienteCorporaivo, GrupoCliente...
            isIntegrationRecord := true;
        if TableID = DATABASE::"Payment Method" then
            isIntegrationRecord := true;
        if TableID = DATABASE::"Payment Terms" then
            isIntegrationRecord := true;
        if TableID = DATABASE::"Item" then //Ya está en std pero para que quede claro
            isIntegrationRecord := true;
        if TableID = DATABASE::"Country/Region" then //Ya está en std pero para que quede claro
            isIntegrationRecord := true;
        if TableID = DATABASE::"Area" then //Provincias
            isIntegrationRecord := true;
        if TableID = DATABASE::"Service Header" then
            isIntegrationRecord := true;
        if TableID = DATABASE::"Service Line" then
            isIntegrationRecord := true;
        if TableID = DATABASE::"Sales Header" then //Ya está en std pero para que quede claro
            isIntegrationRecord := true;
        if TableID = DATABASE::"Sales Line" then //En Std es IntegrationChild y no va bien
            isIntegrationRecord := true;
        if TableID = DATABASE::"Sales Price" then
            isIntegrationRecord := true;
        if TableID = DATABASE::"STH Sales Header Aux" then
            isIntegrationRecord := true;
        if TableID = DATABASE::"STH Sales Line Aux" then
            isIntegrationRecord := true;

    end;



    local procedure ResetTarifasMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        CustomerPriceGroup: Record "Customer Price Group";
        CRMPricelevel_btc: Record "CRM Pricelevel_crm_btc"; // "CRM Pricelevel_btc";
    begin

        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::"Customer Price Group", DATABASE::"CRM Pricelevel_crm_btc",
        CRMPricelevel_btc.FIELDNO(PriceLevelId), CRMPricelevel_btc.FIELDNO(ModifiedOn),
                '', '', TRUE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
        CustomerPriceGroup.FIELDNO(Code),
          CRMPricelevel_btc.FIELDNO(PriceLevelId),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         CustomerPriceGroup.FIELDNO(Description),
          CRMPricelevel_btc.FIELDNO(Name),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;

    local procedure ResetDelegadosMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        TextosAuxiliares: Record TextosAuxiliares;
        CRMDelegado: Record "CRM Delegado_crm_btc"; // "CRM Delegado_btc";
    begin
        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::TextosAuxiliares, DATABASE::"CRM Delegado_crm_btc",
           CRMDelegado.FIELDNO(zum_bcdelegadoId), CRMDelegado.FIELDNO(ModifiedOn),
           '', '', TRUE);
        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Tipo Registro,Tipo,Nº) WHERE(Tipo Registro=FILTER(Delegado),Tipo=FILTER(Tabla))');
        IntegrationTableMapping.MODIFY;

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(NumReg),
          CRMDelegado.FIELDNO(zum_Codigo),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(Descripcion),
          CRMDelegado.FIELDNO(zum_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
        //ZZZ RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping, 30, EnqueueJobQueEntry, 720);
    end;

    local procedure ResetAreaManagerMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        TextosAuxiliares: Record TextosAuxiliares;
        CRMAreaManager: Record "CRM AreaManager_crm_btc"; // "CRM Area Manager_btc";
    begin
        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::TextosAuxiliares, DATABASE::"CRM AreaManager_crm_btc",
           CRMAreaManager.FIELDNO(zum_bcareamanagerId), CRMAreaManager.FIELDNO(ModifiedOn),
           '', '', TRUE);

        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Tipo Registro,Tipo,Nº) WHERE(Tipo Registro=FILTER(AreaManager),Tipo=FILTER(Tabla))');
        IntegrationTableMapping.MODIFY;

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(NumReg),
          CRMAreaManager.FIELDNO(zum_Codigo),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(Descripcion),
          CRMAreaManager.FIELDNO(zum_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;

    local procedure ResetClienteActividadMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        TextosAuxiliares: Record TextosAuxiliares;
        CRMActividadCliente: Record "CRM Cliente Actividad_crm_btc"; // "CRM Cliente Actividad_btc";
    begin

        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::TextosAuxiliares, DATABASE::"CRM Cliente Actividad_crm_btc",
           CRMActividadCliente.FIELDNO(zum_bcactividadclienteId), CRMActividadCliente.FIELDNO(ModifiedOn),
           '', '', TRUE);

        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Tipo Registro,Tipo,Nº) WHERE(Tipo Registro=FILTER(ClienteActividad),Tipo=FILTER(Tabla))');
        IntegrationTableMapping.MODIFY;

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(NumReg),
          CRMActividadCliente.FIELDNO(zum_Codigo),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(Descripcion),
          CRMActividadCliente.FIELDNO(zum_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;

    local procedure ResetClienteMercadosMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        TextosAuxiliares: Record TextosAuxiliares;
        CRMMercados: Record "CRM Mercados_crm_btc"; // "CRM Mercados_btc";
    begin

        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::TextosAuxiliares, DATABASE::"CRM Mercados_crm_btc",
           CRMMercados.FIELDNO(zum_MercadoId), CRMMercados.FIELDNO(ModifiedOn),
           '', '', TRUE);

        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Tipo Registro,Tipo,Nº) WHERE(Tipo Registro=FILTER(Mercados),Tipo=FILTER(Tabla))');
        IntegrationTableMapping.MODIFY;

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(NumReg),
          CRMMercados.FIELDNO(zum_MercadoId),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(Descripcion),
          CRMMercados.FIELDNO(zum_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;

    local procedure ResetFormasPagoMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        FormasPago: Record "Payment Method";
        CRMFormasPago_btc: Record "CRM FormasPago_crm_btc"; // "CRM FormasPago_btc";
    begin
        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::"Payment Method", DATABASE::"CRM FormasPago_crm_btc",
        CRMFormasPago_btc.FIELDNO(bit_bcformadepagoId), CRMFormasPago_btc.FIELDNO(ModifiedOn),
                '', '', TRUE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
        FormasPago.FIELDNO(Code),
          CRMFormasPago_btc.FIELDNO(bit_Codigo),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         FormasPago.FIELDNO(Description),
          CRMFormasPago_btc.FIELDNO(bit_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;

    local procedure ResetTerminosPagoMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        TerminosPago: Record "Payment Terms";
        CRMTerminosPago_btc: Record "CRM TerminosPago_crm_btc"; // "CRM TerminosPago_btc";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping, IntegrationTableMappingName,
          DATABASE::"Payment Terms", DATABASE::"CRM TerminosPago_crm_btc",
       CRMTerminosPago_btc.FIELDNO(bit_bcterminodepagoId), CRMTerminosPago_btc.FIELDNO(ModifiedOn),
               '', '', TRUE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
        TerminosPago.FIELDNO(Code),
          CRMTerminosPago_btc.FIELDNO(bit_Codigo),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TerminosPago.FIELDNO(Description),
          CRMTerminosPago_btc.FIELDNO(bit_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;

    local procedure ResetPaisesMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        Paises: Record "Country/Region";
        CRMPaises_btc: Record "CRM Paises_crm_btc"; // "CRM Paises_btc";
    begin
        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::"Country/Region", DATABASE::"CRM Paises_crm_btc",
        CRMPaises_btc.FIELDNO(bit_BCPaisId), CRMPaises_btc.FIELDNO(ModifiedOn),
                '', '', TRUE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
        Paises.FIELDNO(Code),
          CRMPaises_btc.FIELDNO(bit_CodigoISO),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         Paises.FIELDNO(Name),
          CRMPaises_btc.FIELDNO(bit_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;




    local procedure ResetProductosMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";


        CRMProductos_btc: Record "CRM Productos_crm_btc"; // "CRM Productos_btc";

        Item: record Item;
        ProductId: Guid;

    begin
        InsertIntegrationTableMapping(
       IntegrationTableMapping, IntegrationTableMappingName,
       DATABASE::Item, DATABASE::"CRM Productos_crm_btc",
       CRMProductos_btc.FIELDNO(ProductId), CRMProductos_btc.FIELDNO(ModifiedOn),
       '', '', TRUE);

        IntegrationTableMapping.SetTableFilter('');
        IntegrationTableMapping."Dependency Filter" := 'UNIT OF MEASURE';
        IntegrationTableMapping.MODIFY;

        // "No." > ProductNumber
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("No."),
          CRMProductos_btc.FIELDNO(ProductNumber),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Description > Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO(Description),
          CRMProductos_btc.FIELDNO(Name),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Unit Price > Price
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("Unit Price"),
          CRMProductos_btc.FIELDNO(Price),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Unit Cost > Standard Cost
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("Unit Cost"),
          CRMProductos_btc.FIELDNO(StandardCost),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Unit Cost > Current Cost
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("Unit Cost"),
          CRMProductos_btc.FIELDNO(CurrentCost),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Unit Volume > Stock Volume
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("Unit Volume"),
          CRMProductos_btc.FIELDNO(StockVolume),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Gross Weight > Stock Weight
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("Gross Weight"),
          CRMProductos_btc.FIELDNO(StockWeight),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Vendor No. > Vendor ID
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("Vendor No."),
          CRMProductos_btc.FIELDNO(VendorID),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Vendor Item No. > Vendor part number
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("Vendor Item No."),
          CRMProductos_btc.FIELDNO(VendorPartNumber),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Inventory > Quantity on Hand. If less then zero, it will later be set to zero
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO(Inventory),
          CRMProductos_btc.FIELDNO(QuantityOnHand),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Base Unit of Measure > DefaultUoMScheduleId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Item.FIELDNO("Base Unit of Measure"),
          CRMProductos_btc.FIELDNO(DefaultUoMScheduleId),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        //RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,30,EnqueueJobQueEntry,1440);

    end;

    local procedure ResetClienteCorporativoMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        TextosAuxiliares: Record TextosAuxiliares;
        CRMClienteCorporativo_btc: Record "CRM ClienteCorporativo_crm_btc"; // "CRM Cliente Corporativo_btc";
    begin
        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::TextosAuxiliares, DATABASE::"CRM ClienteCorporativo_crm_btc",
           CRMClienteCorporativo_btc.FIELDNO(zum_bcclientecorporativoId), CRMClienteCorporativo_btc.FIELDNO(ModifiedOn),
           '', '', TRUE);
        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Tipo Registro,Tipo,Nº) WHERE(Tipo Registro=FILTER(ClienteCorporativo),Tipo=FILTER(Tabla))');
        IntegrationTableMapping.MODIFY;

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(NumReg),
          CRMClienteCorporativo_btc.FIELDNO(zum_Codigo),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(Descripcion),
          CRMClienteCorporativo_btc.FIELDNO(zum_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;

    local procedure ResetGrupoCLienteMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        TextosAuxiliares: Record TextosAuxiliares;
        CRMGrupoCliente_btc: Record "CRM Grupo Cliente_crm_btc"; // "CRM Grupo Cliente_btc";
        CRMIntegrationRecord: Record "CRM Integration Record";
        MercadoCliente: Record TextosAuxiliares;
        MercadoClienteId: Guid;
        OutOfMapFilter: boolean;
    begin
        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::TextosAuxiliares, DATABASE::"CRM Grupo Cliente_crm_btc",
           CRMGrupoCliente_btc.FIELDNO(zum_bcgrupoclienteId), CRMGrupoCliente_btc.FIELDNO(ModifiedOn),
           '', '', TRUE);

        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Tipo Registro,Tipo,Nº) WHERE(Tipo Registro=FILTER(GrupoCliente),Tipo=FILTER(Tabla))');
        IntegrationTableMapping.MODIFY;

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(NumReg),
          CRMGrupoCliente_btc.FIELDNO(zum_Codigo),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         TextosAuxiliares.FIELDNO(Descripcion),
          CRMGrupoCliente_btc.FIELDNO(zum_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        //******************** MERCADOS ********************
        MercadoCliente.Reset();
        MercadoCliente.SetRange(TipoRegistro, MercadoCliente.TipoRegistro::Tabla);
        MercadoCliente.SetRange(TipoTabla, MercadoCliente.TipoTabla::Mercados);
        MercadoCliente.SetRange(NumReg, TextosAuxiliares.NumReg);
        if MercadoCliente.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(MercadoCliente.RECORDID, MercadoClienteId) THEN
                IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN
                    ERROR('CRM ClienteActividad: ' + TextosAuxiliares.NumReg + ' Dato: ' + MercadoCliente.NumReg);
            CRMGrupoCliente_btc.zum_Mercado := MercadoClienteId;

        end;
    end;

    local procedure ResetProvinciasMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        Provincias: Record "Area";
        CRMProvincias_btc: Record "CRM Provincias_crm_btc"; // "CRM Provincias_btc";
    begin
        InsertIntegrationTableMapping(
           IntegrationTableMapping, IntegrationTableMappingName,
           DATABASE::"Area", DATABASE::"CRM Provincias_crm_btc",
        CRMProvincias_btc.FIELDNO(bit_bcprovinciaId), CRMProvincias_btc.FIELDNO(ModifiedOn),
                '', '', TRUE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
        Provincias.FIELDNO(Code),
          CRMProvincias_btc.FIELDNO(bit_Codigo),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
         Provincias.FIELDNO(Text),
          CRMProvincias_btc.FIELDNO(bit_Nombre),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', FALSE, FALSE);
    end;

    local procedure ResetPedidosMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalesHeader: Record "Sales Header";
        CRMSalesorder: Record "CRM Salesorder_crm_btc"; // "CRM Salesorder_btc";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping, IntegrationTableMappingName,
          DATABASE::"Sales Header", DATABASE::"CRM Salesorder_crm_btc",
          CRMSalesorder.FIELDNO(SalesOrderId), CRMSalesorder.FIELDNO(ModifiedOn),
          '', '', TRUE);
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE(Status, SalesHeader.Status::Released);
        IntegrationTableMapping.SetTableFilter('');
        IntegrationTableMapping."Dependency Filter" := 'OPPORTUNITY';
        IntegrationTableMapping.Direction := IntegrationTableMapping.Direction::ToIntegrationTable;
        IntegrationTableMapping.MODIFY;

        // "No." > OrderNumber
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("No."),
          CRMSalesorder.FIELDNO(OrderNumber),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // OwnerId = systemuser
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          0, CRMSalesorder.FIELDNO(OwnerIdType),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          FORMAT(CRMSalesorder.OwnerIdType::systemuser), FALSE, FALSE);

        // Salesperson Code > OwnerId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Salesperson Code"),
          CRMSalesorder.FIELDNO(OwnerId),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);
        // SetIntegrationFieldMappingNotNull;

        // "Currency Code" > TransactionCurrencyId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Currency Code"),
          CRMSalesorder.FIELDNO(TransactionCurrencyId),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Ship-to Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Name"),
          CRMSalesorder.FIELDNO(ShipTo_Name),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Ship-to Address
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Address"),
          CRMSalesorder.FIELDNO(ShipTo_Line1),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Ship-to Address 2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Address 2"),
          CRMSalesorder.FIELDNO(ShipTo_Line2),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Ship-to City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to City"),
          CRMSalesorder.FIELDNO(ShipTo_City),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Ship-to Country/Region Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Country/Region Code"),
          CRMSalesorder.FIELDNO(ShipTo_Country),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Ship-to Post Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Post Code"),
          CRMSalesorder.FIELDNO(ShipTo_PostalCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Ship-to County"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to County"),
          CRMSalesorder.FIELDNO(ShipTo_StateOrProvince),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Shipment Date"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Last Shipment Date"),
          CRMSalesorder.FIELDNO(DateFulfilled),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Name"),
          CRMSalesorder.FIELDNO(BillTo_Name),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to Address
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Address"),
          CRMSalesorder.FIELDNO(BillTo_Line1),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to Address 2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Address 2"),
          CRMSalesorder.FIELDNO(BillTo_Line2),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to City"),
          CRMSalesorder.FIELDNO(BillTo_City),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to Country/Region Code
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Country/Region Code"),
          CRMSalesorder.FIELDNO(BillTo_Country),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Bill-to Post Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Post Code"),
          CRMSalesorder.FIELDNO(BillTo_PostalCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Bill-to County"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to County"),
          CRMSalesorder.FIELDNO(BillTo_StateOrProvince),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Amount > TotalAmountLessFreight
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO(Amount),
          CRMSalesorder.FIELDNO(TotalAmountLessFreight),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Amount Including VAT" > TotalAmount
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Amount Including VAT"),
          CRMSalesorder.FIELDNO(TotalAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Invoice Discount Amount" > DiscountAmount
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Invoice Discount Amount"),
          CRMSalesorder.FIELDNO(DiscountAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Shipping Agent Code > address1_shippingmethodcode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Shipping Agent Code"),
          CRMSalesorder.FIELDNO(ShippingMethodCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Payment Terms Code > paymenttermscode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Payment Terms Code"),
          CRMSalesorder.FIELDNO(PaymentTermsCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Requested Delivery Date" -> RequestDeliveryBy
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Requested Delivery Date"),
          CRMSalesorder.FIELDNO(RequestDeliveryBy),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        //RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping, 30, EnqueueJobQueEntry, 720);
        //BTC "No." -> Name
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesHeader.FIELDNO("No."),
         CRMSalesorder.FIELDNO(Name),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);
    end;

    local procedure ResetPedidosServicioMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        ServiceHeader: Record "Service Header";
        CRMIncident: Record "CRM Incident";
    begin
        InsertIntegrationTableMapping(
         IntegrationTableMapping, IntegrationTableMappingName,
         DATABASE::"Service Header", DATABASE::"CRM Incident",
        CRMIncident.FIELDNO(IncidentId), CRMIncident.FIELDNO(ModifiedOn),
         '', '', FALSE);

        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
        ServiceHeader.FIELDNO("No."),
         CRMIncident.FIELDNO(Title),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', FALSE, FALSE);

        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
        ServiceHeader.FIELDNO("Bill-to Customer No."),
         CRMIncident.FIELDNO(CustomerId),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', FALSE, FALSE);
        // RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,30,EnqueueJobQueEntry,720);

    end;

    local procedure ResetLineasPedidoMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalesLine: Record "Sales Line";
        CRMSalesorderdetail: Record "CRM Salesorderdetail_crm_btc"; // "CRM Salesorderdetail_btc";
    begin

        InsertIntegrationTableMapping(
         IntegrationTableMapping, IntegrationTableMappingName,
         DATABASE::"Sales Line", DATABASE::"CRM Salesorderdetail_crm_btc",
        CRMSalesorderdetail.FIELDNO(SalesOrderDetailId), CRMSalesorderdetail.FIELDNO(ModifiedOn),
         '', '', FALSE);
        IntegrationTableMapping."Dependency Filter" := 'SALESORDER-ORDER';
        IntegrationTableMapping.MODIFY;

        // Quantity -> Quantity
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO(Quantity),
         CRMSalesorderdetail.FIELDNO(Quantity),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        // "Line Discount Amount" -> "Manual Discount Amount"
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO("Line Discount Amount"),
         CRMSalesorderdetail.FIELDNO(ManualDiscountAmount),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        // "Unit Price" > PricePerUnit
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO("Unit Price"),
         CRMSalesorderdetail.FIELDNO(PricePerUnit),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        // TRUE > IsPriceOverridden
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         0,
         CRMSalesorderdetail.FIELDNO(IsPriceOverridden),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '1', TRUE, FALSE);

        // Amount -> BaseAmount
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO(Amount),
         CRMSalesorderdetail.FIELDNO(BaseAmount),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        // "Amount Including VAT" -> ExtendedAmount
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO("Amount Including VAT"),
         CRMSalesorderdetail.FIELDNO(ExtendedAmount),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

    end;

    local procedure ResetLineasOfertaMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalesLine: Record "Sales Line";
        CRMSalesorderdetail: Record "CRM Quotedetail";
    begin

        InsertIntegrationTableMapping(
         IntegrationTableMapping, IntegrationTableMappingName,
         DATABASE::"Sales Line", DATABASE::"CRM Quotedetail",
        CRMSalesorderdetail.FIELDNO(QuoteDetailId), CRMSalesorderdetail.FIELDNO(ModifiedOn),
         '', '', FALSE);
        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Tipo documento,Nº documento,Nº línea) WHERE(Tipo documento=FILTER(Oferta))');
        IntegrationTableMapping."Dependency Filter" := 'OFERTAS';
        IntegrationTableMapping.Direction := IntegrationTableMapping.Direction::ToIntegrationTable;

        IntegrationTableMapping.MODIFY;




        // Quantity -> Quantity
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO(Quantity),
         CRMSalesorderdetail.FIELDNO(Quantity),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        // "Line Discount Amount" -> "Manual Discount Amount"
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO("Line Discount Amount"),
         CRMSalesorderdetail.FIELDNO(ManualDiscountAmount),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        // "Unit Price" > PricePerUnit
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO("Unit Price"),
         CRMSalesorderdetail.FIELDNO(PricePerUnit),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        // TRUE > IsPriceOverridden
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         0,
         CRMSalesorderdetail.FIELDNO(IsPriceOverridden),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '1', TRUE, FALSE);

        // Amount -> BaseAmount
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO(Amount),
         CRMSalesorderdetail.FIELDNO(BaseAmount),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        // "Amount Including VAT" -> ExtendedAmount
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesLine.FIELDNO("Amount Including VAT"),
         CRMSalesorderdetail.FIELDNO(ExtendedAmount),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

    end;

    local procedure ResetOfertasMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalesHeader: Record "Sales Header";
        CRMquote: Record "CRM Quote";
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping, IntegrationTableMappingName,
          DATABASE::"Sales Header", DATABASE::"CRM Quote",
          CRMquote.FIELDNO(QuoteId), CRMquote.FIELDNO(ModifiedOn),
          '', '', TRUE);


        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SETRANGE(Status, SalesHeader.Status::Released);
        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Tipo documento,Nº) WHERE(Tipo documento=FILTER(Oferta))');
        IntegrationTableMapping."Dependency Filter" := 'OPPORTUNITY';
        IntegrationTableMapping.Direction := IntegrationTableMapping.Direction::ToIntegrationTable;
        IntegrationTableMapping.MODIFY;

        // "No." > OrderNumber
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("No."),
          CRMquote.FIELDNO(QuoteNumber),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // OwnerId = systemuser
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          0, CRMquote.FIELDNO(OwnerIdType),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          FORMAT(CRMquote.OwnerIdType::systemuser), FALSE, FALSE);

        // Salesperson Code > OwnerId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Salesperson Code"),
          CRMquote.FIELDNO(OwnerId),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);
        //SetIntegrationFieldMappingNotNull;

        // "Currency Code" > TransactionCurrencyId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Currency Code"),
          CRMquote.FIELDNO(TransactionCurrencyId),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Ship-to Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Name"),
          CRMquote.FIELDNO(ShipTo_Name),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Ship-to Address
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Address"),
          CRMquote.FIELDNO(ShipTo_Line1),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Ship-to Address 2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Address 2"),
          CRMquote.FIELDNO(ShipTo_Line2),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Ship-to City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to City"),
          CRMquote.FIELDNO(ShipTo_City),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Ship-to Country/Region Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Country/Region Code"),
          CRMquote.FIELDNO(ShipTo_Country),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Ship-to Post Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to Post Code"),
          CRMquote.FIELDNO(ShipTo_PostalCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Ship-to County"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Ship-to County"),
          CRMquote.FIELDNO(ShipTo_StateOrProvince),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Shipment Date"
        // InsertIntegrationFieldMapping(
        //   IntegrationTableMappingName,
        //   SalesHeader.FIELDNO("Last Shipment Date"),
        //   CRMquote.FIELDNO(DateFulfilled),
        //   IntegrationFieldMapping.Direction::ToIntegrationTable,
        //   '', TRUE, FALSE);

        // Bill-to Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Name"),
          CRMquote.FIELDNO(BillTo_Name),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to Address
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Address"),
          CRMquote.FIELDNO(BillTo_Line1),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to Address 2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Address 2"),
          CRMquote.FIELDNO(BillTo_Line2),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to City"),
          CRMquote.FIELDNO(BillTo_City),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Bill-to Country/Region Code
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Country/Region Code"),
          CRMquote.FIELDNO(BillTo_Country),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Bill-to Post Code"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to Post Code"),
          CRMquote.FIELDNO(BillTo_PostalCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Bill-to County"
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Bill-to County"),
          CRMquote.FIELDNO(BillTo_StateOrProvince),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Amount > TotalAmountLessFreight
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO(Amount),
          CRMquote.FIELDNO(TotalAmountLessFreight),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Amount Including VAT" > TotalAmount
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Amount Including VAT"),
          CRMquote.FIELDNO(TotalAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Invoice Discount Amount" > DiscountAmount
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Invoice Discount Amount"),
          CRMquote.FIELDNO(DiscountAmount),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Shipping Agent Code > address1_shippingmethodcode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Shipping Agent Code"),
          CRMquote.FIELDNO(ShippingMethodCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Payment Terms Code > paymenttermscode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Payment Terms Code"),
          CRMquote.FIELDNO(PaymentTermsCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Requested Delivery Date" -> RequestDeliveryBy
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          SalesHeader.FIELDNO("Requested Delivery Date"),
          CRMquote.FIELDNO(RequestDeliveryBy),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);
        //BTC "No." -> Name
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         SalesHeader.FIELDNO("No."),
         CRMquote.FIELDNO(Name),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);
        //RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping,30,EnqueueJobQueEntry,720);
    end;


    local procedure ResetClientesMapping(IntegrationTableMappingName: Code[20]; EnqueueJobQueEntry: Boolean)
    var

        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        SalesHeader: Record "Sales Header";
        CRMAccount_btc: Record "CRM Account_crm_btc";
        AccountId: Guid;
        Customer: Record Customer;
    begin
        InsertIntegrationTableMapping(
          IntegrationTableMapping, IntegrationTableMappingName,
          DATABASE::Customer, DATABASE::"CRM Account_crm_btc",
          CRMAccount_btc.FIELDNO(AccountId), CRMAccount_btc.FIELDNO(ModifiedOn),
          '', '', FALSE);

        IntegrationTableMapping.SetTableFilter('VERSION(1) SORTING(Nº) WHERE(Nº = FILTER(<>''''))');
        // IntegrationTableMapping.SetIntegrationTableFilter('VERSION(1) SORTING(Account) WHERE(Relationship Type=FILTER('' ''|Competitor|Consultant|Investor|Partner|Influencer|Press|Prospect|Reseller|Supplier|Vendor|Other),Código BC=FILTER(''''),bit_bcenviaralerp=FILTER(true))');
        IntegrationTableMapping.SetIntegrationTableFilter('VERSION(1) SORTING(Account) WHERE(Relationship Type=FILTER(<>3),Código BC=FILTER(''''),bit_bcenviaralerp=FILTER(true))');

        CRMAccount_btc.SETRANGE(StateCode, CRMAccount_btc.StateCode::Active);
        CRMAccount_btc.SETRANGE(CustomerTypeCode, CRMAccount_btc.CustomerTypeCode::Customer);

        IntegrationTableMapping."Dependency Filter" := 'SALESPEOPLE|CURRENCY';
        IntegrationTableMapping.Direction := IntegrationTableMapping.Direction::Bidirectional;
        IntegrationTableMapping.MODIFY;

        // OwnerIdType::systemuser
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          0, CRMAccount_btc.FIELDNO(OwnerIdType),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          FORMAT(CRMAccount_btc.OwnerIdType::systemuser), FALSE, FALSE);



        // Salesperson Code > OwnerId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Salesperson Code"),
          CRMAccount_btc.FIELDNO(OwnerId),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);
        // Name > Name
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO(Name),
          CRMAccount_btc.FIELDNO(Name),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Contact > Address1_PrimaryContactName
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO(Contact),
          CRMAccount_btc.FIELDNO(Address1_PrimaryContactName),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', FALSE, FALSE); // We do not validate contact name.

        // Address > Address1_Line1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO(Address),
          CRMAccount_btc.FIELDNO(Address1_Line1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Address 2 > Address1_Line2
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Address 2"),
          CRMAccount_btc.FIELDNO(Address1_Line2),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Post Code > Address1_PostalCode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Post Code"),
          CRMAccount_btc.FIELDNO(Address1_PostalCode),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // City > Address1_City
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO(City),
          CRMAccount_btc.FIELDNO(Address1_City),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Country > Address1_Country
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Country/Region Code"),
          CRMAccount_btc.FIELDNO(Address1_Country),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // County > Address1_StateOrProvince
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO(County),
          CRMAccount_btc.FIELDNO(Address1_StateOrProvince),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Email > EmailAddress1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("E-Mail"),
          CRMAccount_btc.FIELDNO(EMailAddress1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Fax No > Fax
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Fax No."),
          CRMAccount_btc.FIELDNO(Fax),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Home Page > WebSiteUrl
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Home Page"),
          CRMAccount_btc.FIELDNO(WebSiteURL),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Phone No. > Telephone1
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Phone No."),
          CRMAccount_btc.FIELDNO(Telephone1),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        // Shipment Method Code > address1_freighttermscode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Shipment Method Code"),
          CRMAccount_btc.FIELDNO(Address1_FreightTermsCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Shipping Agent Code > address1_shippingmethodcode
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Shipping Agent Code"),
          CRMAccount_btc.FIELDNO(Address1_ShippingMethodCode),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // Payment Terms Code > paymenttermscode
        // InsertIntegrationFieldMapping(
        //   IntegrationTableMappingName,
        //   Customer.FIELDNO("Payment Terms Code"),
        //   CRMAccount_btc.FIELDNO(PaymentTermsCode),
        //   IntegrationFieldMapping.Direction::ToIntegrationTable,
        //   '', TRUE, FALSE);

        // Credit Limit (LCY) > creditlimit
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Credit Limit (LCY)"),
          CRMAccount_btc.FIELDNO(CreditLimit),
          IntegrationFieldMapping.Direction::ToIntegrationTable,
          '', TRUE, FALSE);

        // "Primary Contact No." > PrimaryContactId
        InsertIntegrationFieldMapping(
          IntegrationTableMappingName,
          Customer.FIELDNO("Primary Contact No."),
          CRMAccount_btc.FIELDNO(PrimaryContactId),
          IntegrationFieldMapping.Direction::Bidirectional,
          '', TRUE, FALSE);

        //No. > AccountNumber
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         Customer.FIELDNO("No."),
         CRMAccount_btc.FIELDNO(AccountNumber),
         IntegrationFieldMapping.Direction::ToIntegrationTable,
         '', TRUE, FALSE);

        //VAT Registration No. > zum_Identificacionfiscal
        InsertIntegrationFieldMapping(
         IntegrationTableMappingName,
         Customer.FIELDNO("VAT Registration No."),
         CRMAccount_btc.FIELDNO(zum_Identificacionfiscal),
         IntegrationFieldMapping.Direction::Bidirectional,
         '', TRUE, FALSE);


        //Credito Interno
        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Credito Maximo Interno_btc"),
        CRMAccount_btc.FIELDNO(zum_Creditointerno),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);

        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Credito Maximo Interno_btc"),
        CRMAccount_btc.FIELDNO(zum_creditointerno_Base),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);

        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Credito Maximo Aseguradora_btc"),
        CRMAccount_btc.FIELDNO(zum_creditoaseguradora),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);
        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Credito Maximo Aseguradora_btc"),
        CRMAccount_btc.FIELDNO(zum_creditoaseguradora_Base),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);

        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Cred_ Max_ Int_ Autorizado Por_btc"),
        CRMAccount_btc.FIELDNO(zum_Creditoautorizadopor),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);


        //Descuento1
        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO(Descuento1_btc),
        CRMAccount_btc.FIELDNO(zum_descuento1),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);
        //Descuento2
        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO(Descuento2_btc),
        CRMAccount_btc.FIELDNO(zum_descuento2),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);
        //Prepago
        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO("Prepayment %"),
        CRMAccount_btc.FIELDNO(zum_Prepago),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);
        //Forma Pago solicitada CRM
        InsertIntegrationFieldMapping(
        IntegrationTableMappingName,
        Customer.FIELDNO(Formadepagosolicitada),
        CRMAccount_btc.FIELDNO(zum_Formadepagosolicitada),
        IntegrationFieldMapping.Direction::ToIntegrationTable,
        '', TRUE, FALSE);

        //FIN BTC
        // RecreateJobQueueEntryFromIntTableMapping(IntegrationTableMapping, 30, ShouldRecreateJobQueueEntry, 720);


    end;

    //Evento al pulsar DEfault
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnAfterResetCustomerAccountMapping', '', false, false)]
    local procedure InicilizarTablaMapeo(IntegrationTableMappingName: Code[20])
    // var
    //     IntegrationTableMapping: Record "Integration Table Mapping";
    //     IntegrationFieldMapping: Record "Integration Field Mapping";


    //     CRMAccount_btc: Record "CRM Account_btc";
    //     CRMFormasPago_btc: Record "CRM FormasPago_btc";
    //     CRMTerminosPago_btc: Record "CRM TerminosPago_btc";
    //     CRMSalesorder: record "CRM Salesorder";

    //     Customer: record Customer;
    //     SalesHeader: Record "Sales Header";

    //     CRMIncident: record "CRM Incident";
    //     IncidentId: Guid;
    //     ServiceHeader: Record "Service Header";
    //     CustomerId: Guid;

    //     SalesOrderDetailId: Guid;


    begin
        //Borro Sinc del standard que no voy a gastar

        // IntegrationTableMappingName := 'CUSTOMER';
        // IntegrationFieldMapping.SetRange("Integration Table Mapping Name", IntegrationTableMappingName);
        // IntegrationFieldMapping.DeleteAll();
        // IntegrationTableMapping.SetRange("Name", IntegrationTableMappingName);
        // IntegrationTableMapping.DeleteAll();

        // IntegrationTableMappingName := 'PAYMENT TERMS';
        // IntegrationFieldMapping.SetRange("Integration Table Mapping Name", IntegrationTableMappingName);
        // IntegrationFieldMapping.DeleteAll();
        // IntegrationTableMapping.SetRange("Name", IntegrationTableMappingName);
        // IntegrationTableMapping.DeleteAll();

        ReinicializarTablaSincronizacionCRM();



    end;


    procedure ReinicializarTablaSincronizacionCRM()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        IntegrationFieldMapping: Record "Integration Field Mapping";



    begin
        //Borro Sinc del standard que no voy a gastar

        // IntegrationTableMappingName := 'CUSTOMER';
        // IntegrationFieldMapping.SetRange("Integration Table Mapping Name", IntegrationTableMappingName);
        // IntegrationFieldMapping.DeleteAll();
        // IntegrationTableMapping.SetRange("Name", IntegrationTableMappingName);
        // IntegrationTableMapping.DeleteAll();

        // IntegrationTableMappingName := 'PAYMENT TERMS';
        // IntegrationFieldMapping.SetRange("Integration Table Mapping Name", IntegrationTableMappingName);
        // IntegrationFieldMapping.DeleteAll();
        // IntegrationTableMapping.SetRange("Name", IntegrationTableMappingName);
        // IntegrationTableMapping.DeleteAll();

        //*********************** TABLAS *************************
        ResetClientesMapping('CLIENTES', false);
        ResetOfertasMapping('OFERTAS', false);
        ResetLineasOfertaMapping('OFERTAS-LIN', false);
        ResetTarifasMapping('TARIFAS', false);
        ResetDelegadosMapping('DELEGADOS', false);
        ResetAreaManagerMapping('AREAMANAGER', false);
        ResetClienteActividadMapping('ACTIVIDADCLIENTE', false);
        ResetClienteMercadosMapping('MERCADOSCLIENTE', false);

        ResetFormasPagoMapping('FORMAS.PAGO', false);
        ResetTerminosPagoMapping('TERMINOS.PAGO', false);
        ResetPaisesMapping('PAISES', false);
        ResetClienteCorporativoMapping('CLIENTECORPORATIVO', false);
        ResetGrupoClienteMapping('GRUPOCLIENTE', false);
        ResetPaisesMapping('PAISES', false);
        ResetProvinciasMapping('PROVINCIAS', false);
        ResetPedidosMapping('PEDIDOS', false);
        ResetLineasPedidoMapping('PEDIDOS-LINEAS', false);
        ResetPedidosServicioMapping('PED.SERVICIO', false);
        ResetProductosMapping('PRODUCTOS', false);
        //***** TABLAS STD ****
        //SalesPeople
        //UOM
        //CURRENCY
        //RESOURCE-PRODUCT?
        //CONTACT
        //SALESPRC-PRODPRICE
        //CUSTPRCGRP-PRICE
        //POSTED SALESINV
        //POSTED-SALESLINE
        //SALESORDER-ORDER
        //SALESORDER-LINES


    end;


    local procedure InsertIntegrationTableMapping(VAR IntegrationTableMapping: Record "Integration Table Mapping"; MappingName: Code[20];
    TableNo: Integer; IntegrationTableNo: Integer; IntegrationTableUIDFieldNo: Integer; IntegrationTableModifiedFieldNo: Integer;
     TableConfigTemplateCode: Code[10]; IntegrationTableConfigTemplateCode: Code[10]; SynchOnlyCoupledRecords: Boolean);
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
        IntegrationTablePrefixTok: Text[30];
    begin
        SynchOnlyCoupledRecords := false;
        IntegrationTablePrefixTok := '';
        IntegrationTableMapping.CreateRecord(MappingName, TableNo, IntegrationTableNo, IntegrationTableUIDFieldNo,
          IntegrationTableModifiedFieldNo, TableConfigTemplateCode, IntegrationTableConfigTemplateCode,
          SynchOnlyCoupledRecords, IntegrationTableMapping.Direction::ToIntegrationTable, IntegrationTablePrefixTok);
    end;


    local procedure InsertIntegrationFieldMapping(IntegrationTableMappingName: Code[20]; TableFieldNo: Integer; IntegrationTableFieldNo: Integer; SynchDirection: Option; ConstValue: Text; ValidateField: Boolean; ValidateIntegrationTableField: Boolean)

    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        IntegrationFieldMapping.CreateRecord(IntegrationTableMappingName, TableFieldNo, IntegrationTableFieldNo, SynchDirection,
            ConstValue, ValidateField, ValidateIntegrationTableField);
    end;


    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Management", 'OnAfterAddToIntegrationPageList', '', true, true)]
    // local procedure HandleOnAfterAddToIntegrationPageList(var TempNameValueBuffer: Record "Name/Value Buffer"; var NextId: Integer)
    // begin
    //     TempNameValueBuffer.Init();
    //     TempNameValueBuffer.ID := NextId;
    //     NextId := NextId + 1;
    //     TempNameValueBuffer.Name := Format(Page::"Employee Card");
    //     TempNameValueBuffer.Value := Format(Database::"Employee");
    //     TempNameValueBuffer.Insert();
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lookup CRM Tables",  'OnLookupCRMTables', '', true, true)]
    // local procedure HandleOnLookupCRMTables(CRMTableID: Integer; NAVTableId: Integer; SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text; var Handled: Boolean)
    // begin
    //     if CRMTableID = Database::"CDS Worker" then
    //         Handled := LookupCDSWorker(SavedCRMId, CRMId, IntTableFilter);
    // end;

    // local procedure LookupCDSWorker(SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text): Boolean
    // var
    //     CDSWorker: Record "CDS Worker";
    //     OriginalCDSWorker: Record "CDS Worker";
    //     CDSWorkerList: Page "CDS Worker List";
    // begin
    //     if not IsNullGuid(CRMId) then begin
    //         if CDSWorker.Get(CRMId) then
    //             CDSWorkerList.SetRecord(CDSWorker);
    //         if not IsNullGuid(SavedCRMId) then
    //             if OriginalCDSWorker.Get(SavedCRMId) then
    //                 CDSWorkerList.SetCurrentlyCoupledCDSWorker(OriginalCDSWorker);
    //     end;

    //     CDSWorker.SetView(IntTableFilter);
    //     CDSWorkerList.SetTableView(CDSWorker);
    //     CDSWorkerList.LookupMode(true);
    //     if CDSWorkerList.RunModal = ACTION::LookupOK then begin
    //         CDSWorkerList.GetRecord(CDSWorker);
    //         CRMId := CDSWorker.WorkerId;
    //         exit(true);
    //     end;
    //     exit(false);
    // end;

    procedure ObtenerEmparejadosCRM(Codigo: Code[20])
    var

        RecordId: RecordID;
        IntegrationRecord: Record "Integration Record";
        TextosAuxiliares: Record TextosAuxiliares;
        pageItem: Page "Item Lookup";
        CRMIntegrationRecord: Record "CRM Integration Record";
        RecRef: RecordRef;
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        TempTextosAuxiliares: Record TextosAuxiliares;
        CrmId: GUID;
    begin
        //CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);

        //Codigo:='CGC314A20';
        TextosAuxiliares.SETRANGE(TipoTabla, TextosAuxiliares.TipoTabla::GrupoCliente);
        IF Codigo <> '' THEN
            TextosAuxiliares.SETRANGE(TextosAuxiliares.NumReg, Codigo);
        IF TextosAuxiliares.FINDSET THEN
            REPEAT
                RecordId := TextosAuxiliares.RECORDID;

                IntegrationRecord.SETCURRENTKEY("Table ID", "Record ID");
                IntegrationRecord.SETRANGE("Table ID", DATABASE::TextosAuxiliares);
                IntegrationRecord.SETRANGE("Record ID", RecordId);
                CLEAR(CrmId);
                IF IntegrationRecord.FINDFIRST THEN BEGIN
                    CRMIntegrationRecord.RESET;
                    CRMIntegrationRecord.SETRANGE("Integration ID", IntegrationRecord."Integration ID");
                    IF CRMIntegrationRecord.FINDLAST THEN
                        CrmId := CRMIntegrationRecord."CRM ID";
                    if Not (Confirm('Borrar %1 crm=%2?', true, TempTextosAuxiliares.NumReg, CrmId)) then exit;
                    CRMIntegrationRecord.Delete()
                END;
            // TempTextosAuxiliares.INIT;
            // TempTextosAuxiliares.COPY(TextosAuxiliares);
            // TempTextosAuxiliares.Descripcion := CrmId;
            // TempTextosAuxiliares.INSERT;
            UNTIL TextosAuxiliares.NEXT = 0;
        //   PAGE.RUN(PAGE::cliente a, TempItem);
    end;

    procedure RecreateJobQueueEntry(IntegrationTableMapping: record "Integration Table Mapping"; IntervalMinutes: Integer; ShouldRecreateJobQueueEntry: Boolean)
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueEntryNameTok: Label '%1: trabajo de sincronización de Dynamics 365 for Sales.';
    begin
        with JobQueueEntry do begin
            SetRange("Object Type to Run", "Object Type to Run"::Codeunit);
            SetRange("Object ID to Run", Codeunit::"Integration Synch. Job Runner");
            SetRange("Record ID to Process", IntegrationTableMapping.RecordId);
            if FindSet() then
                DeleteTask();

            InitRecurringJob(IntervalMinutes);
            "Object Type to Run" := "Object Type to Run"::Codeunit;
            "Object ID to Run" := Codeunit::"Integration Synch. Job Runner";
            "Record ID to Process" := IntegrationTableMapping.RecordId;
            "Run in User Session" := false;
            Priority := 1000;
            Description := COPYSTR(StrSubstNo(JobQueueEntryNameTok, IntegrationTableMapping.Name), 1, MaxStrLen(Description));
            "Maximum No. of Attempts to Run" := 10;
            //"Rerun Delay (sec.)" := 30;
            IF ShouldRecreateJobQueueEntry THEN
                CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry)
            ELSE
                INSERT(TRUE);
        end;
    end;

    // =============     Marcar Productos para la actualización en CRM Sales          ====================
    // ==  
    // == 
    // ==  
    // ======================================================================================================

    procedure UpdateItemsForCRM(NotExistOnly: Boolean)
    var
        CRMProductos_btc: Record "CRM Productos_crm_btc"; // "CRM Productos_btc";
        Item: Record Item;
        Updated: Boolean;
    begin
        if Item.FindFirst() then
            repeat
                case NotExistOnly of
                    true:  // solo añadir productos
                        begin
                            Item."CRM Updated" := CRMProductos_btc.Get(Item."No.");
                            Item.Modify();
                        end;
                    false:  // aqui hacemos que se añadan y actualizen
                        begin
                            Updated := false;
                            if CRMProductos_btc.Get(Item."No.") then begin
                                if Item.Description <> CRMProductos_btc.Name then
                                    Updated := true;
                                if Item."Unit Price" <> CRMProductos_btc.Price then
                                    Updated := true;
                                if Item."Unit Cost" <> CRMProductos_btc.StandardCost then
                                    Updated := true;
                                if Item."Unit Cost" <> CRMProductos_btc.CurrentCost then
                                    Updated := true;
                                if Item."Unit Volume" <> CRMProductos_btc.StockVolume then
                                    Updated := true;
                                if Item."Gross Weight" <> CRMProductos_btc.StockWeight then
                                    Updated := true;
                                if Item."Vendor Item No." <> CRMProductos_btc.VendorName then
                                    Updated := true;
                                if Item."Base Unit of Measure" <> CRMProductos_btc.DefaultUoMScheduleId then
                                    Updated := true;
                                Item."CRM Updated" := Updated;
                                Item.Modify();
                            end;
                        end;
                end;

            Until Item.next() = 0;
    end;

    var
        CRMProductName: Codeunit "CRM Product Name";
        CRMSynchHelper: Codeunit "CRM Synch. Helper";

    procedure UpdateOwneridAreaManager()
    var
        Customer: Record Customer;
        CRMAccount: Record "CRM Account_crm_btc";
        CRMAreaManager: Record "CRM AreaManager_crm_btc";
        NewUserId: Guid;
        Window: Dialog;
    begin
        if not Confirm('¿desea actualizar el Owner de los clientes de integracion BC en CRM?', false) then
            exit;
        Window.Open('#1###############\#2##########################################\#3####################################');
        //CRMAccount.SetRange(OwnerId, 'a4e5e921-6e7a-ea11-a811-000d3a2c3f51');
        if CRMAccount.FindFirst() then
            repeat
                // actualizamos el estado tambien
                CRMUpdateCustomerState(CRMAccount);

                if Customer.Get(CRMAccount.AccountNumber) then begin

                    Window.Update(1, Customer."No.");
                    Window.Update(2, Customer."Name");
                    // buscamos el AreaManager y le ponemos el ID de Systemuser
                    if GetUpdateOwnerSales(Customer, NewUserId) then begin
                        if not IsNullGuid(NewUserId) then begin
                            if NewUserId <> CRMAccount.OwnerId then begin
                                CRMAccount.OwnerId := NewUserId;
                                CRMAccount.Modify();
                            end;
                        end;
                    end;
                    UpdateAccountAreaManager(Customer, CRMAccount);
                end;
            until CRMAccount.next() = 0;
        Window.Close();
    end;

    local procedure UpdateAccountAreaManager(var Customer: Record customer; CRMAccount2: Record "CRM Account_crm_btc")
    var
        TextosAuxiliares: Record TextosAuxiliares;
        CRMIntegrationRecord: Record "CRM Integration Record";
        TextosAuxiliaresId: Guid;
        OutOfMapFilter: boolean;
    begin
        TextosAuxiliares.Reset();
        TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
        TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::AreaManager);
        TextosAuxiliares.SetRange(NumReg, Customer.AreaManager_btc);
        if TextosAuxiliares.FindFirst() then begin
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(TextosAuxiliares.RECORDID, TextosAuxiliaresId) THEN
                IF CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::TextosAuxiliares, TextosAuxiliares.RECORDID, OutOfMapFilter) THEN BEGIN
                    CRMAccount2.zum_bcareamanager := TextosAuxiliaresId;
                    CRMAccount2.Modify();
                END;
        end;
    end;

    procedure UpdateAccountAreaManager(AreaManager: Record TextosAuxiliares)
    var
        SalesPerson: Record "Salesperson/Purchaser";
        AreaManagerSalesPerson: Record TextosAuxiliares;
        Customer: Record Customer;
        CRMAccount: Record "CRM Account_crm_btc";
        CRMAreaManager: Record "CRM AreaManager_crm_btc";
        NewUserId: Guid;
    begin
        if not Confirm('¿Desea actualizar el Owner de los clientes de %1 en CRM?\%2', false, AreaManager.NumReg, AreaManager."CRM ID") then
            exit;
        Customer.Reset();
        Customer.SetRange(AreaManager_btc, AreaManager.NumReg);
        if Customer.FindFirst() then
            repeat
                if GetUpdateOwnerSales(Customer, NewUserId) then begin
                    if not IsNullGuid(NewUserId) then begin
                        CRMAccount.Reset();
                        CRMAccount.SetRange(AccountNumber, Customer."No.");
                        IF CRMAccount.FindFirst() then begin
                            // actualizamos el estado tambien
                            CRMUpdateCustomerState(CRMAccount);
                            if CRMAccount.OwnerId <> NewUserId then begin
                                CRMAccount.OwnerId := NewUserId;
                                CRMAccount.Modify();
                            end;
                            UpdateAccountAreaManager(Customer, CRMAccount);
                        end;
                    end;
                end;
            until Customer.next() = 0;
    end;

    procedure UpdateCustomerAccountAreaManager(Customer: Record Customer)
    var
        AreaManager: Record TextosAuxiliares;
        CRMAccount: Record "CRM Account_crm_btc";
        CRMAreaManager: Record "CRM AreaManager_crm_btc";
        NewUserId: Guid;
    begin
        // asiganamos el propietario
        if GetUpdateOwnerSales(Customer, NewUserId) then begin
            if not IsNullGuid(NewUserId) then begin
                if not Confirm('¿Desea actualizar el Owner %1 del cliente %2 en CRM?\%3', false, AreaManager.NumReg, Customer.Name, AreaManager."CRM ID") then
                    exit;

                CRMAccount.Reset();
                CRMAccount.SetRange(AccountNumber, Customer."No.");
                IF CRMAccount.FindFirst() then begin
                    // actualizamos el estado tambien
                    CRMUpdateCustomerState(CRMAccount);
                    UpdateAccountAreaManager(Customer, CRMAccount);
                    if CRMAccount.OwnerId <> NewUserId then begin
                        CRMAccount.OwnerId := NewUserId;
                        CRMAccount.Modify();
                    end;
                end;

            end;
        end;
    end;

    local procedure GetUpdateOwnerSales(Customer: Record Customer; var NewUserId: Guid) Encontrado: Boolean
    var
        SalesPerson: Record "Salesperson/Purchaser";
        AreaManager: Record TextosAuxiliares;

    begin
        clear(NewUserId);
        // si tienen un area manager, pero el propietario es otro, caso de Inside Sales 
        // se rellena el owner seria el area manager = sales person
        if Customer."Salesperson Code" <> '' then begin
            if SalesPerson.Get(Customer."Salesperson Code") then begin
                AreaManager.Reset();
                AreaManager.SetRange(TipoTabla, AreaManager.TipoTabla::AreaManager);
                AreaManager.SetRange(NumReg, SalesPerson.AreaManager_btc);
                if AreaManager.FindFirst() then begin
                    NewUserId := AreaManager."CRM ID";
                    Encontrado := true;
                end;
            end;
        end;
        if IsNullGuid(NewUserId) then begin
            AreaManager.Reset();
            AreaManager.SetRange(TipoTabla, AreaManager.TipoTabla::AreaManager);
            AreaManager.SetRange(NumReg, Customer.AreaManager_btc);
            if AreaManager.FindFirst() then begin
                NewUserId := AreaManager."CRM ID";
                Encontrado := true;
            end;
        end;
    end;

    local procedure DevuelveUserId(AreaManagerID: Text): Text
    var
        AreaManager: Record TextosAuxiliares;
    begin
        AreaManager.Reset();
        AreaManager.SetRange(TipoTabla, AreaManager.TipoTabla::AreaManager);
        AreaManager.SetRange(NumReg, AreaManagerID);
        if AreaManager.FindFirst() then
            exit(AreaManager."CRM ID");

    end;

    // =============     Funciones que actualizan en el Dyn 365 SALES - del Business Central          ====================
    // ==  
    // ==  Datos de productos bloqueados, se actualizan  (CRMUpdateItem)
    // ==  Datos de clientes bloqueados (CRMUpdateCustomer)
    // ==  
    // ======================================================================================================

    procedure CRMUpdateItems()
    var
        Item: Record Item;
        CRMProduct: record "CRM Product";
    begin
        CRMProduct.SETCURRENTKEY(ProductNumber);
        IF CRMProduct.FINDFIRST THEN
            REPEAT
                IF Item.GET(CRMProduct.ProductNumber) THEN BEGIN
                    IF Item."Sales Blocked" OR Item.Blocked THEN BEGIN
                        IF CRMProduct.StateCode <> CRMProduct.StateCode::Retired THEN BEGIN
                            CRMProduct.StateCode := CRMProduct.StateCode::Retired;
                            CRMProduct.MODIFY;
                        END;
                    END ELSE BEGIN
                        IF CRMProduct.StateCode <> CRMProduct.StateCode::Active THEN BEGIN
                            CRMProduct.StateCode := CRMProduct.StateCode::Active;
                            CRMProduct.MODIFY;
                        END;
                    END;
                END;

            UNTIL CRMProduct.NEXT = 0;
    end;

    procedure CRMUpdateCustomers()
    var
        CRMAccount: record "CRM Account_crm_btc";
    begin
        CRMAccount.SETCURRENTKEY(AccountNumber);
        IF CRMAccount.FINDFIRST THEN
            REPEAT

                CRMUpdateCustomerState(CRMAccount);

            UNTIL CRMAccount.NEXT = 0;
    end;

    procedure CRMUpdateCustomerState(var CRMAccount: record "CRM Account_crm_btc")
    var
        Customer: Record Customer;
    begin
        IF Customer.GET(CRMAccount.AccountNumber) THEN BEGIN
            IF Customer.Blocked in [Customer.Blocked::All, Customer.Blocked::Invoice] THEN BEGIN
                IF CRMAccount.StateCode <> CRMAccount.StateCode::Inactive THEN BEGIN
                    CRMAccount.StateCode := CRMAccount.StateCode::Inactive;
                    CRMAccount.MODIFY;
                END;
            END ELSE BEGIN
                IF CRMAccount.StateCode <> CRMAccount.StateCode::Active THEN BEGIN
                    CRMAccount.StateCode := CRMAccount.StateCode::Active;
                    CRMAccount.MODIFY;
                END;
            END;
        END;
    end;

    // =============               ====================
    // ==  
    // ==  comment 
    // ==  
    // ======================================================================================================
    procedure UpdateCRMSalesbyBCItemsRelations()
    var
        Item: Record Item;
        Ventana: Dialog;
    begin
        Ventana.Open('Producto #1###################\L.M.: #2###########################');
        Item.Reset();
        Item.SetRange(Blocked, false);
        Item.SetFilter("Replenishment System", '%1|%2', Item."Replenishment System"::Assembly, Item."Replenishment System"::"Prod. Order");
        Item.SetRange("Assembly BOM", true);
        if Item.FindFirst() then
            repeat
                UpdateCRMSalesbyBCItemRelations(Item, Ventana);

            until Item.Next() = 0;
        Ventana.Close();
    end;

    procedure UpdateCRMSalesbyBCItemRelations(Item: Record Item; var Ventana: Dialog)
    var
        BomComponent: Record "BOM Component";
        ProductionBOMLine: Record "Production BOM Line";
        CRMProduct: Record "CRM Product";
        CRMProductRelationShip: Record "CRM productrelationships";
        Productid: Guid;
        BomProductid: Guid;
    begin
        Item.TestField(Blocked, false);
        if not (Item."Replenishment System" in [Item."Replenishment System"::Assembly, Item."Replenishment System"::"Prod. Order"]) then
            exit;
        Ventana.Update(1, Item."No.");
        // buscamos la lista de productos y conseguimos los id de cada uno
        CRMProduct.Reset();
        CRMProduct.SetRange(ProductNumber, Item."No.");
        if CRMProduct.FindSet() then begin
            if CRMProduct.StateCode in [CRMProduct.StateCode::Active] then begin
                Productid := CRMProduct.ProductId;
                case Item."Replenishment System" of
                    Item."Replenishment System"::Assembly:
                        Begin
                            BomComponent.Reset();
                            BomComponent.SetRange("Parent Item No.", Item."No.");
                            BomComponent.SetRange(Type, BomComponent.Type::Item);
                            if BomComponent.FindFirst() then begin
                                Ventana.Update(2, BomComponent."No.");
                                // primero eliminamos todas las relaciones, lo hacemos en la misma funciona para no abrir mas conexiones con CRM
                                CRMProductRelationShip.Reset();
                                CRMProductRelationShip.SetRange(productid, Productid);
                                CRMProductRelationShip.DeleteAll();
                                repeat
                                    // obtenemos y creamos cada relacion de cada productoç
                                    CRMProduct.Reset();
                                    CRMProduct.SetRange(ProductNumber, BomComponent."No.");
                                    if CRMProduct.FindSet() then begin
                                        if CRMProduct.StateCode in [CRMProduct.StateCode::Active] then begin
                                            BomProductid := CRMProduct.ProductId;

                                            // creamos la nueva relación o modificar
                                            clear(CRMProductRelationShip);
                                            CRMProductRelationShip.Init();
                                            CRMProductRelationShip.productid := Productid;
                                            CRMProductRelationShip.substitutedproductid := BomProductid;
                                            CRMProductRelationShip.Direction := CRMProductRelationShip.Direction::"Uni-Directional";
                                            CRMProductRelationShip.salesrelationshiptype := CRMProductRelationShip.salesrelationshiptype::Accessory;
                                            CRMProductRelationShip.Insert();
                                        end else begin
                                            CRMProductRelationShip.Reset();
                                            CRMProductRelationShip.SetRange(productid, Productid);
                                            CRMProductRelationShip.DeleteAll();
                                        end;
                                    end;
                                Until (BomComponent.next() = 0) or (CRMProduct.StateCode <> CRMProduct.StateCode::Active);
                            end;
                        end;
                    Item."Replenishment System"::"Prod. Order":
                        Begin
                            ProductionBOMLine.Reset();
                            ProductionBOMLine.SetRange("Production BOM No.", Item."Production BOM No.");
                            ProductionBOMLine.SetRange(Type, ProductionBOMLine.Type::Item);
                            if ProductionBOMLine.FindFirst() then begin
                                Ventana.Update(2, ProductionBOMLine."No.");
                                // primero eliminamos todas las relaciones, lo hacemos en la misma funciona para no abrir mas conexiones con CRM
                                CRMProductRelationShip.Reset();
                                CRMProductRelationShip.SetRange(productid, Productid);
                                CRMProductRelationShip.DeleteAll();
                                repeat
                                    // obtenemos y creamos cada relacion de cada productoç
                                    CRMProduct.Reset();
                                    CRMProduct.SetRange(ProductNumber, ProductionBOMLine."No.");
                                    if CRMProduct.FindSet() then begin
                                        if CRMProduct.StateCode in [CRMProduct.StateCode::Active] then begin
                                            BomProductid := CRMProduct.ProductId;

                                            // creamos la nueva relación o modificar
                                            clear(CRMProductRelationShip);
                                            CRMProductRelationShip.Init();
                                            CRMProductRelationShip.productid := Productid;
                                            CRMProductRelationShip.substitutedproductid := BomProductid;
                                            CRMProductRelationShip.Direction := CRMProductRelationShip.Direction::"Uni-Directional";
                                            CRMProductRelationShip.salesrelationshiptype := CRMProductRelationShip.salesrelationshiptype::Accessory;
                                            CRMProductRelationShip.Insert();
                                        end else begin
                                            CRMProductRelationShip.Reset();
                                            CRMProductRelationShip.SetRange(productid, Productid);
                                            CRMProductRelationShip.DeleteAll();
                                        end;
                                    end;
                                Until (ProductionBOMLine.next() = 0);
                            end;
                        end;
                end;
            end
        end;
    end;

    // =============   TextosAuxiliaresControl            ====================
    // ==  
    // ==  Funcion para controlar los registros que se crean en CANAL, Actividad de cliente y Grupos de Clientes
    // ==  
    // ======================================================================================================

    procedure TextosAuxiliaresControl()
    var
        TextosAuxiliares: Record TextosAuxiliares;
        CRMCanal: Record "CRM Canal_crm_btc";
        CRMActividad: Record "CRM Cliente Actividad_crm_btc";
        CRMGrupoClientes: Record "CRM Grupo Cliente_crm_btc";
    begin
        // abrimos la conexión con el CRM SALES
        Codeunit.Run(Codeunit::"CRM Integration Management");
        // chequeamos que no se ha creado en CRM ningun registro que no este en BC
        // CANAL
        CRMCanal.Reset();
        if CRMCanal.FindFirst() then
            repeat
                TextosAuxiliares.Reset();
                TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
                TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::Canal);
                if not TextosAuxiliares.FindFirst() then begin
                    Message(CRMCanal.zum_Name);
                    //TODO CRMCanal.Delete();
                end;

            Until CRMCanal.next() = 0;
        // ACTIVIDAD
        CRMActividad.Reset();
        if CRMActividad.FindFirst() then
            repeat
                TextosAuxiliares.Reset();
                TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
                TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::ClienteActividad);
                if not TextosAuxiliares.FindFirst() then begin
                    Message(CRMActividad.zum_Nombre);
                    //TODO CRMActividad.Delete();
                end;

            Until CRMActividad.next() = 0;
        // GRUPO CLIENTES
        CRMGrupoClientes.Reset();
        if CRMGrupoClientes.FindFirst() then
            repeat
                TextosAuxiliares.Reset();
                TextosAuxiliares.SetRange(TipoRegistro, TextosAuxiliares.TipoRegistro::Tabla);
                TextosAuxiliares.SetRange(TipoTabla, TextosAuxiliares.TipoTabla::GrupoCliente);
                if not TextosAuxiliares.FindFirst() then begin
                    Message(CRMGrupoClientes.zum_Nombre);
                    //TODO CRMGrupoClientes.Delete();
                end;

            Until CRMGrupoClientes.next() = 0;
    end;


    // =============   PROCEDIMIENTO SINCRONIZACION ACCOUNT-CUSTOMER            ====================
    // ==  
    // ==  Funciones para actualizar datos de manera bi-direccional de los clientes de BC y clientes de SALES 
    // ==  
    // ==  UpdateAccountCRM - Actualizamos los datos del cliente de Sales desde BC
    // ==  
    // ==           Dtos de familias
    // ==  
    // ======================================================================================================
    procedure UpdateDtoAccountCRM(CustomerNo: code[20])
    var
        Customer: Record Customer;
        CRMAccount: Record "CRM Account_crm_btc";
    begin
        if not Customer.Get(CustomerNo) then
            exit;
        CRMAccount.SetRange(AccountNumber, Customer."No.");
        if CRMAccount.FindFirst() then begin
            // comprobamos si no tiene valores y cual ponemos
            if UpdateBCCRMDtoAccounts(Customer, CRMAccount) then
                Customer.Modify();

            CRMAccount.Modify();
        end
    end;

    local procedure UpdateBCCRMDtoAccounts(var Customer: Record Customer; var CRMAccount: Record "CRM Account_crm_btc") UpdateCustomer: Boolean
    begin
        case Customer."Dto. Exprimidores" of
            0:
                begin
                    if CRMAccount.Dto_exprimidores > 0 then begin
                        Customer."Dto. Exprimidores" := CRMAccount.Dto_exprimidores;
                        UpdateCustomer := true;
                    end;
                end;
            else begin
                CRMAccount.Dto_exprimidores := Customer."Dto. Exprimidores";
            end;
        end;
        case Customer."Dto. Isla" of
            0:
                begin
                    if CRMAccount.Dto_Isla > 0 then begin
                        Customer."Dto. Isla" := CRMAccount.Dto_Isla;
                        UpdateCustomer := true;
                    end;
                end;
            else begin
                CRMAccount.Dto_Isla := Customer."Dto. Isla";
            end;
        end;
        case Customer."Dto. Viva" of
            0:
                begin
                    if CRMAccount.Dto_Viva > 0 then begin
                        Customer."Dto. Viva" := CRMAccount.Dto_Viva;
                        UpdateCustomer := true;
                    end;
                end;
            else begin
                CRMAccount.Dto_Viva := Customer."Dto. Viva";
            end;
        end;
        case Customer."Dto. Repuestos" of
            0:
                begin
                    if CRMAccount.Dto_Repuestos > 0 then begin
                        Customer."Dto. Repuestos" := CRMAccount.Dto_Repuestos;
                        UpdateCustomer := true;
                    end;
                end;
            else begin
                CRMAccount.Dto_Repuestos := Customer."Dto. Repuestos";
            end;
        end;
    end;

    procedure UpdateDtoAccountsCRM(var Customer: Record Customer)
    var
        Window: Dialog;
        lblDialog: Label 'Cliente #1#### - #2########################################', comment = 'ESP="Cliente #1#### - #2########################################"';
    begin
        Window.Open(lblDialog);
        if Customer.FindFirst() then
            repeat
                Window.Update(1, Customer."No.");
                Window.Update(1, Customer.Name);
                UpdateDtoAccountCRM(Customer."No.");
            Until Customer.next() = 0;
        Window.Close();
    end;
}