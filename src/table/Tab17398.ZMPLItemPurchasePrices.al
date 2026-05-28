table 17398 "ZM PL Item Purchase Prices"
{
    DataClassification = CustomerContent;
    Caption = 'Item Purchases Prices', comment = 'ESP="Precios compra productos"';
    LookupPageId = "ZM PL Item Purchases Prices";
    DrillDownPageId = "ZM PL Item Purchases Prices";

    fields
    {
        field(1; "Item No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item No.', comment = 'ESP="Nº producto"';
            TableRelation = "ZM PL Items temporary";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                OnValidate_ItemNo();
            end;

            trigger OnLookup()
            begin
                OnLookup_ItemNo();
            end;
        }
        field(2; "Vendor No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.', comment = 'ESP="Nº proveedor"';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                OnValidate_VendorNo();
            end;
        }
        field(3; "Currency Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency Code', comment = 'ESP="Cód. divisa"';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date', comment = 'ESP="Fecha inicial"';
        }
        field(5; "Direct Unit Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Direct Unit Cost', comment = 'ESP="Coste unit. directo"';
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";
        }
        field(6; "Item Name"; text[100])
        {
            Caption = 'Item Name', comment = 'ESP="Nombre producto"';
            FieldClass = FlowField;
            CalcFormula = lookup(item.Description where("No." = field("Item No.")));
            Editable = false;

        }
        field(14; "Minimum Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Quantity', comment = 'ESP="Cantidad mínima"';
        }
        field(15; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date', comment = 'ESP="Fecha final"';
        }
        field(5400; "Unit of Measure Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure Code', comment = 'ESP="Cód. unidad medida"';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(5700; "Variant Code"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Variant Code', comment = 'ESP="Cód. variante"';
        }
        field(50020; "Record ID"; Guid)
        {
            DataClassification = CustomerContent;
            Caption = 'Record ID', comment = 'ESP="ID Registro"';
        }
        field(50021; "Status Approval"; Enum "Status Approval")
        {
            DataClassification = CustomerContent;
            Caption = 'Status Approval', comment = 'ESP="Estado Aprobación"';
        }
        field(50022; "Date Send Approval"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Send Approval', comment = 'ESP="Fecha envío Aprobación"';
        }
        field(50025; "Action Approval"; Enum "Action Approval")
        {
            DataClassification = CustomerContent;
            Caption = 'Action', comment = 'ESP="Acción"';
        }
        field(50030; "Date/Time Creation"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Date/Time Creation', comment = 'ESP="Fecha/Hora Creación"';
        }
        field(50040; "Vendor Item No."; text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Item No.', comment = 'ESP="Cód. producto proveedor"';
        }
        field(50050; "Lead Time Calculation"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Lead Time Calculation', comment = 'ESP="Plazo entrega (días)"';
        }
        field(50060; "Minimum Order Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Order Quantity', comment = 'ESP="Cantidad mínima pedido"';
        }
        field(50070; "Order Multiple"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Order Multiple', comment = 'ESP="Múltiplos de pedido"';
        }
        field(50080; "Vendor Name"; text[100])
        {
            Caption = 'Vendor Name', comment = 'ESP="Nombre proveedor"';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            Editable = false;
        }
        field(50090; Selected; Boolean)
        {
            Caption = 'Selected', comment = 'ESP="Seleccion"';
        }
    }

    keys
    {
        key(PK; "Record ID")
        {
            Clustered = true;
        }
        key(Key1; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
        }
        key(Key2; "Vendor No.", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {

        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }


    var
        PurchasePrice: Record "Purchase Price";
        ItemPurchasePrices: Record "ZM PL Item Purchase Prices";
        ItemsRegistaprovals: Codeunit "ZM PL Items Regist. aprovals";
        lblErrorDuplicate: Label 'The record already exists in table %1.', comment = 'ESP="Ya existe el registro en la tabla %1."';

    trigger OnInsert()
    begin
        if IsNullGuid(Rec."Record ID") then
            Rec."Record ID" := CreateGuid();
        if Rec."Date/Time Creation" = 0DT then
            Rec."Date/Time Creation" := CreateDateTime(Today(), Time());
        if "Status Approval" in [Rec."Status Approval"::" "] then
            Rec."Status Approval" := Rec."Status Approval"::Pending;
        if Rec."Unit of Measure Code" = '' then
            UpdateUnitOfMeasure();
        // comprobamos duplicados.
        CheckRecIsDuplicate();
    end;

    trigger OnModify()
    begin
        if Rec."Date/Time Creation" = 0DT then
            Rec."Date/Time Creation" := CreateDateTime(Today(), Time());

        // comprobamos duplicados.
        CheckRecIsDuplicate();
        CheckActionApproval();
    end;



    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
        CheckActionApproval();
    end;

    local procedure CheckRecIsDuplicate()
    var
        myInt: Integer;
    begin
        ItemPurchasePrices.Reset();
        ItemPurchasePrices.SetFilter("Record ID", '<>%1', Rec."Record ID");
        ItemPurchasePrices.SetRange("Item No.", Rec."Item No.");
        ItemPurchasePrices.SetRange("Vendor No.", Rec."Vendor No.");
        ItemPurchasePrices.SetRange("Starting Date", Rec."Starting Date");
        ItemPurchasePrices.SetRange("Currency Code", Rec."Currency Code");
        ItemPurchasePrices.SetRange("Variant Code", Rec."Variant Code");
        ItemPurchasePrices.SetRange("Unit of Measure Code", Rec."Unit of Measure Code");
        ItemPurchasePrices.SetRange("Minimum Quantity", Rec."Minimum Quantity");
        ItemPurchasePrices.SetRange("Status Approval", ItemPurchasePrices."Status Approval"::Pending);
        if ItemPurchasePrices.FindFirst() then
            Error(lblErrorDuplicate, Rec.TableCaption);
    end;

    procedure ItemPurchasePricesApproval(var SelectItemPurchasePrices: Record "ZM PL Item Purchase Prices"; Approve: Boolean)
    var
        Item: Record Item;
        ItemPurchasePrices: Record "ZM PL Item Purchase Prices" temporary;
    begin
        if SelectItemPurchasePrices.FindFirst() then
            repeat
                if Item.Get(SelectItemPurchasePrices."Item No.") then begin
                    // primero marcamos como fecha final todos los anteriores.
                    ItemPuchasePriceFinishDate(SelectItemPurchasePrices);

                    AddItemPurchasePrice(ItemPurchasePrices, SelectItemPurchasePrices);
                    SelectItemPurchasePrices.ItemPurchasePriceApproval(Approve);
                end;
            Until SelectItemPurchasePrices.next() = 0;
        // si el usuario es el aprobador, se envia email a los propietarios de table        
        ItemsRegistaprovals.RequestEmaiApprobalItemPurchasePrices(ItemPurchasePrices);
    end;

    local procedure ItemPuchasePriceFinishDate(SelectItemPurchasePrices: Record "ZM PL Item Purchase Prices")
    var
        PurchasePrices: Record "Purchase Price";
    begin
        PurchasePrices.Reset();
        PurchasePrices.SetRange("Item No.", SelectItemPurchasePrices."Item No.");
        PurchasePrices.SetRange("Ending Date", 0D);
        PurchasePrices.SetFilter("Starting Date", '<%1', SelectItemPurchasePrices."Starting Date");
        if PurchasePrices.FindFirst() then
            repeat
                PurchasePrices."Ending Date" := SelectItemPurchasePrices."Starting Date" - 1;
                PurchasePrices.Modify(false);
            Until PurchasePrices.next() = 0;

    end;

    local procedure AddItemPurchasePrice(var ItemPurchasePrices: Record "ZM PL Item Purchase Prices"; SelectItemPurchasePrices: Record "ZM PL Item Purchase Prices")
    begin
        ItemPurchasePrices.Init();
        ItemPurchasePrices.TransferFields(SelectItemPurchasePrices);
        if ItemPurchasePrices."Date/Time Creation" = 0DT then
            ItemPurchasePrices."Date/Time Creation" := CreateDateTime(Today(), Time());
        ItemPurchasePrices.Insert();
    end;

    procedure ItemPurchasePriceApproval(Approve: Boolean)
    begin
        ItemsRegistaprovals.ItemPurchasePricesApproval(Rec, Approve);
    end;

    local procedure CheckActionApproval()
    begin
        Rec."Action Approval" := Rec."Action Approval"::New;
        ItemPurchasePrices."Status Approval" := ItemPurchasePrices."Status Approval"::Pending;
        PurchasePrice.Reset();
        if PurchasePrice.Get(Rec."Item No.", Rec."Vendor No.", Rec."Starting Date", Rec."Currency Code", Rec."Variant Code", Rec."Unit of Measure Code", Rec."Minimum Quantity") then
            Rec."Action Approval" := Rec."Action Approval"::Modify;
    end;

    procedure ImportExcel(var tempPurchasePrice: Record "ZM PL Item Purchase Prices")
    var
        Item: Record Item;
        Vendor: Record Vendor;

        ExcelBuffer: Record "Excel Buffer" temporary;
        TempNameValueBufferOut: Record "Name/Value Buffer" temporary;
        FileManagement: Codeunit "File Management";
        Text000: label 'Cargar Fichero de Excel';
        FileName: text;
        Sheetname: text;
        ItemNo: text;
        VendorNo: text;
        Plazo: Text;
        PlazoFormula: DateFormula;
        PRODUCTOPROVEEDOR: Text;
        CANTIDADMINPEDIDO: Decimal;
        PEDIDOMULTIPLO: Decimal;
        txtFechaFra: text;
        Fecha: date;
        Cantidad: Decimal;
        Lote: Decimal;
        Precio: Decimal;
        i: Integer;
        ColLote: Integer;
        Rows: Integer;
        QtyMax: Decimal;
        PriceMax: Decimal;
        NVInStream: InStream;
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            Error(StrSubstNo('No se ha podido abrir %1', FileName));
        // if ExcelBuffer.GetSheetsNameListFromStream(NVInStream, TempNameValueBufferOut) then
        // if TempNameValueBufferOut.Count > 1 then begin
        Sheetname := ExcelBuffer.SelectSheetsNameStream(NVInStream);
        ExcelBuffer.Reset();
        ExcelBuffer.OpenBookStream(NVInStream, Sheetname);
        ExcelBuffer.ReadSheet();
        ExcelBuffer.SetRange("Column No.", 1);
        If ExcelBuffer.FindLast() then
            Rows := ExcelBuffer."Row No.";
        ExcelBuffer.Reset();

        for i := 2 to Rows do begin
            ExcelBuffer.SetRange("Row No.", i);
            ExcelBuffer.SetRange("Column No.", 1); // Cod. producto
            if ExcelBuffer.FindSet() then
                ItemNo := ExcelBuffer."Cell Value as Text";
            if ItemNo <> '' then begin
                Item.Get(ItemNo);
                ExcelBuffer.SetRange("Column No.", 3); // Nº proveedor
                if ExcelBuffer.FindSet() then
                    VendorNo := ExcelBuffer."Cell Value as Text";
                Vendor.Get(VendorNo);

                // ahora buscamos los datos de ficha principal
                ExcelBuffer.SetRange("Column No.", 4); // Plazo
                if ExcelBuffer.FindSet() then
                    if ExcelBuffer."Cell Value as Text" <> '' then begin
                        Plazo := ExcelBuffer."Cell Value as Text";
                        if Evaluate(PlazoFormula, Plazo) then
                            item.validate("Lead Time Calculation", PlazoFormula);
                    end;

                ExcelBuffer.SetRange("Column No.", 5); // Codido producto proveedor
                if ExcelBuffer.FindSet() then
                    if ExcelBuffer."Cell Value as Text" <> '' then begin
                        PRODUCTOPROVEEDOR := ExcelBuffer."Cell Value as Text";
                        if PRODUCTOPROVEEDOR <> '' then
                            Item."Vendor Item No." := PRODUCTOPROVEEDOR;
                    end;
                ExcelBuffer.SetRange("Column No.", 6); // Cantidad minima pedido
                if ExcelBuffer.FindSet() then
                    if ExcelBuffer."Cell Value as Text" <> '' then begin
                        if not Evaluate(CANTIDADMINPEDIDO, ExcelBuffer."Cell Value as Text") then
                            CANTIDADMINPEDIDO := 0;
                        if CANTIDADMINPEDIDO > 0 then
                            Item."Minimum Order Quantity" := CANTIDADMINPEDIDO;
                    end;
                ExcelBuffer.SetRange("Column No.", 7); // pedido multiplo
                if ExcelBuffer.FindSet() then
                    if ExcelBuffer."Cell Value as Text" <> '' then begin
                        if not Evaluate(PEDIDOMULTIPLO, ExcelBuffer."Cell Value as Text") then
                            PEDIDOMULTIPLO := 0;
                        if PEDIDOMULTIPLO > 0 then
                            Item."Order Multiple" := PEDIDOMULTIPLO;
                    end;
                Item.Modify();

                // bucle de posible lotes
                ColLote := 8;
                Lote := 0;
                Precio := 0;
                ExcelBuffer.SetRange("Column No.", ColLote); // Lote
                if ExcelBuffer.FindSet() then
                    if not Evaluate(Lote, ExcelBuffer."Cell Value as Text") then
                        Lote := 0;
                ExcelBuffer.SetRange("Column No.", ColLote + 1); // precio
                if ExcelBuffer.FindSet() then
                    if not Evaluate(Precio, ExcelBuffer."Cell Value as Text") then
                        Precio := 0;
                PriceMax := precio;
                QtyMax := Lote;
                repeat
                    if lote < QtyMax then begin
                        QtyMax := lote;
                        PriceMax := Precio;
                    end;
                    if (lote > 0) and (Precio > 0) then begin
                        tempPurchasePrice.Init();
                        tempPurchasePrice."Record ID" := CreateGuid();
                        tempPurchasePrice."Vendor No." := Vendor."No.";
                        tempPurchasePrice.Validate("Item No.", Item."No.");
                        tempPurchasePrice."Date/Time Creation" := CreateDateTime(WorkDate(), time());
                        tempPurchasePrice."Starting Date" := WorkDate();
                        tempPurchasePrice."Minimum Quantity" := Lote;
                        tempPurchasePrice."Direct Unit Cost" := Precio;
                        tempPurchasePrice."Unit of Measure Code" := Item."Base Unit of Measure";
                        tempPurchasePrice."Action Approval" := tempPurchasePrice."Action Approval"::New;
                        tempPurchasePrice."Status Approval" := tempPurchasePrice."Status Approval"::Pending;
                        tempPurchasePrice.Insert();
                    end;
                    ColLote += 2;
                    Lote := 0;
                    Precio := 0;
                    ExcelBuffer.SetRange("Column No.", ColLote); // Lote
                    if ExcelBuffer.FindSet() then
                        if not Evaluate(Lote, ExcelBuffer."Cell Value as Text") then
                            Lote := 0;
                    ExcelBuffer.SetRange("Column No.", ColLote + 1); // precio
                    if ExcelBuffer.FindSet() then
                        if not Evaluate(Precio, ExcelBuffer."Cell Value as Text") then
                            Precio := 0;
                until lote = 0;
                // buscamos si existe el movimiento pendiente y actual con unidad 1
                CheckandAddPurchasePriceBase(tempPurchasePrice, PriceMax);

            end;
        end;
    end;


    local procedure CheckandAddPurchasePriceBase(var tempPurchasePrice: Record "ZM PL Item Purchase Prices"; PriceMax: Decimal)
    var
        OrigItemPurchasePrice: Record "ZM PL Item Purchase Prices" temporary;
    begin
        OrigItemPurchasePrice := tempPurchasePrice;
        tempPurchasePrice.SetRange("Vendor No.", OrigItemPurchasePrice."Vendor No.");
        tempPurchasePrice.SetRange("Item No.", OrigItemPurchasePrice."Item No.");
        tempPurchasePrice.setRange("Starting Date", OrigItemPurchasePrice."Starting Date");
        tempPurchasePrice.SetRange("Status Approval", OrigItemPurchasePrice."Status Approval"::Pending);
        tempPurchasePrice.SetRange("Minimum Quantity", 1);
        if not tempPurchasePrice.FindFirst() then begin
            tempPurchasePrice.Init();
            tempPurchasePrice."Record ID" := CreateGuid();
            tempPurchasePrice."Vendor No." := OrigItemPurchasePrice."Vendor No.";
            tempPurchasePrice.Validate("Item No.", OrigItemPurchasePrice."Item No.");
            tempPurchasePrice."Date/Time Creation" := CreateDateTime(WorkDate(), time());
            tempPurchasePrice."Starting Date" := OrigItemPurchasePrice."Starting Date";
            tempPurchasePrice."Minimum Quantity" := 1;
            tempPurchasePrice."Direct Unit Cost" := PriceMax;
            tempPurchasePrice."Unit of Measure Code" := OrigItemPurchasePrice."Unit of Measure Code";
            tempPurchasePrice."Action Approval" := OrigItemPurchasePrice."Action Approval"::New;
            tempPurchasePrice."Status Approval" := OrigItemPurchasePrice."Status Approval"::Pending;
            tempPurchasePrice.Insert()
        end;
        tempPurchasePrice.Reset();
    end;

    local procedure UpdateUnitOfMeasure()
    var
        Item: Record Item;
        ItemsTemporary: Record "ZM PL Items Temporary";
    begin
        if Item.Get(Rec."Item No.") then begin
            Rec."Unit of Measure Code" := Item."Base Unit of Measure";
        end else begin
            ItemsTemporary.SetRange("Item No.", Rec."Item No.");
            if ItemsTemporary.FindLast() then
                Rec."Unit of Measure Code" := ItemsTemporary."Base Unit of Measure";
        end;
    end;

    local procedure OnValidate_VendorNo()
    var
        Vendor: Record Vendor;
    begin
        if Vendor.get(Rec."Vendor No.") then
            Rec."Currency Code" := Vendor."Currency Code";
    end;

    local procedure OnValidate_ItemNo()
    var
        myInt: Integer;
    begin

    end;

    local procedure OnLookup_ItemNo()
    var
        Item: Record Item;
        Itemstemporary: Record "ZM PL Items temporary";
    begin
        if Item.Get(Rec."Item No.") then
            Page.Run(0, Item)
        else begin
            if Itemstemporary.Get(Rec."Item No.") then;
            Page.Run(0, Itemstemporary);
        end;
    end;
}
