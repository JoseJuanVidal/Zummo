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
                AddItemPurchasePrice(ItemPurchasePrices, SelectItemPurchasePrices);
                SelectItemPurchasePrices.ItemPurchasePriceApproval(Approve);
            Until SelectItemPurchasePrices.next() = 0;
        // si el usuario es el aprobador, se envia email a los propietarios de table
        Item.Get(Rec."Item No.");
        ItemsRegistaprovals.RequestEmaiApprobalItemPurchasePrices(Item, ItemPurchasePrices);
    end;

    local procedure AddItemPurchasePrice(var ItemPurchasePrices: Record "ZM PL Item Purchase Prices"; SelectItemPurchasePrices: Record "ZM PL Item Purchase Prices")
    begin
        ItemPurchasePrices.Init();
        ItemPurchasePrices.TransferFields(SelectItemPurchasePrices);
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
}
