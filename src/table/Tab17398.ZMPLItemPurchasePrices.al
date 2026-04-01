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
        }
        field(2; "Vendor No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor No.', comment = 'ESP="Nº proveedor"';
            TableRelation = Vendor;
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
                    AddItemPurchasePrice(ItemPurchasePrices, SelectItemPurchasePrices);
                    SelectItemPurchasePrices.ItemPurchasePriceApproval(Approve);
                end;
            Until SelectItemPurchasePrices.next() = 0;
        // si el usuario es el aprobador, se envia email a los propietarios de table
        Item.Get(Rec."Item No.");
        ItemsRegistaprovals.RequestEmaiApprobalItemPurchasePrices(Item, ItemPurchasePrices);
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

    procedure ImportExcel()
    var
        Item: Record Item;
        Vendor: Record Vendor;
        tempPurchasePrice: Record "ZM PL Item Purchase Prices";
        ExcelBuffer: Record "Excel Buffer" temporary;
        TempNameValueBufferOut: Record "Name/Value Buffer" temporary;
        FileManagement: Codeunit "File Management";
        Text000: label 'Cargar Fichero de Excel';
        FileName: text;
        Sheetname: text;
        txtFechaFra: text;
        Fecha: date;
        Cantidad: Decimal;
        Lote: Decimal;
        Precio: Decimal;
        i: Integer;
        Rows: Integer;
        NVInStream: InStream;
    begin
        ExcelBuffer.DeleteAll();
        if not UploadIntoStream(Text000, '', 'Excel Files (*.xlsx)|*.*', FileName, NVInStream) then
            exit;
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
            ExcelBuffer.SetRange("Column No.", 2); // Nº proveedor
            if ExcelBuffer.FindSet() then begin
                if Vendor.Get(ExcelBuffer."Cell Value as Text") then begin
                    ExcelBuffer.SetRange("Column No.", 3); // Cod. producto
                    if ExcelBuffer.FindSet() then
                        if Item.Get(ExcelBuffer."Cell Value as Text") then begin
                            ExcelBuffer.SetRange("Column No.", 5); // Cantidad
                            if ExcelBuffer.FindSet() then
                                if not Evaluate(Cantidad, ExcelBuffer."Cell Value as Text") then
                                    Cantidad := 0;
                            ExcelBuffer.SetRange("Column No.", 6); // Precio
                            if ExcelBuffer.FindSet() then
                                if not Evaluate(Precio, ExcelBuffer."Cell Value as Text") then
                                    Precio := 0;
                            ExcelBuffer.SetRange("Column No.", 7); // Fecha inicial
                            if ExcelBuffer.FindSet() then
                                txtFechaFra := ExcelBuffer."Cell Value as Text";
                            Evaluate(Fecha, txtFechaFra);
                            ExcelBuffer.SetRange("Column No.", 9); // Lote
                            if ExcelBuffer.FindSet() then
                                if not Evaluate(Lote, ExcelBuffer."Cell Value as Text") then
                                    Lote := 0;

                            tempPurchasePrice.SetRange("Vendor No.", Vendor."No.");
                            tempPurchasePrice.SetRange("Item No.", Item."No.");
                            tempPurchasePrice.SetFilter("Starting Date", '%1..', Fecha);
                            if tempPurchasePrice.FindFirst() then
                                repeat
                                    if tempPurchasePrice."Status Approval" in [tempPurchasePrice."Status Approval"::" ", tempPurchasePrice."Status Approval"::Pending] then
                                        tempPurchasePrice.Delete();
                                Until tempPurchasePrice.next() = 0;
                            tempPurchasePrice.Init();
                            tempPurchasePrice."Record ID" := CreateGuid();
                            tempPurchasePrice."Vendor No." := Vendor."No.";
                            tempPurchasePrice.Validate("Item No.", Item."No.");
                            tempPurchasePrice."Date/Time Creation" := CreateDateTime(WorkDate(), time());
                            tempPurchasePrice."Starting Date" := Fecha;
                            tempPurchasePrice."Minimum Quantity" := Lote;
                            tempPurchasePrice."Direct Unit Cost" := Precio;
                            tempPurchasePrice."Unit of Measure Code" := Item."Base Unit of Measure";
                            tempPurchasePrice."Action Approval" := tempPurchasePrice."Action Approval"::New;
                            tempPurchasePrice."Status Approval" := tempPurchasePrice."Status Approval"::Pending;
                            tempPurchasePrice.Insert();

                            // buscamos si existe el movimiento pendiente y actual con unidad 1
                            CheckandAddPurchasePriceBase(tempPurchasePrice);
                        end;
                end;
            end;
        end;
    end;

    local procedure CheckandAddPurchasePriceBase(tempPurchasePrice: Record "ZM PL Item Purchase Prices")
    var
        ItemPurchasePrice: Record "ZM PL Item Purchase Prices";
    begin
        ItemPurchasePrice.SetRange("Vendor No.", tempPurchasePrice."Vendor No.");
        ItemPurchasePrice.SetRange("Item No.", tempPurchasePrice."Item No.");
        ItemPurchasePrice.setRange("Starting Date", tempPurchasePrice."Starting Date");
        ItemPurchasePrice.SetRange("Status Approval", tempPurchasePrice."Status Approval"::Pending);
        ItemPurchasePrice.SetRange("Minimum Quantity", 1);
        if not ItemPurchasePrice.FindFirst() then begin
            ItemPurchasePrice.Init();
            ItemPurchasePrice."Record ID" := CreateGuid();
            ItemPurchasePrice."Vendor No." := tempPurchasePrice."Vendor No.";
            ItemPurchasePrice.Validate("Item No.", tempPurchasePrice."Item No.");
            ItemPurchasePrice."Date/Time Creation" := CreateDateTime(WorkDate(), time());
            ItemPurchasePrice."Starting Date" := tempPurchasePrice."Starting Date";
            ItemPurchasePrice."Minimum Quantity" := 1;
            ItemPurchasePrice."Direct Unit Cost" := tempPurchasePrice."Direct Unit Cost";
            ItemPurchasePrice."Unit of Measure Code" := tempPurchasePrice."Unit of Measure Code";
            ItemPurchasePrice."Action Approval" := ItemPurchasePrice."Action Approval"::New;
            ItemPurchasePrice."Status Approval" := ItemPurchasePrice."Status Approval"::Pending;
            ItemPurchasePrice.Insert()
        end
    end;
}
