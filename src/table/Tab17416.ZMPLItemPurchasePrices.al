table 17416 "ZM PL Item Purchase Prices"
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
        field(50001; "Status Approval"; Enum "Status Approval")
        {
            DataClassification = CustomerContent;
            Caption = 'Status Approval', comment = 'ESP="Estado Aprobación"';
        }
        field(50002; "Date Send Approval"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Send Approval', comment = 'ESP="Fecha envío Aprobación"';
        }
    }

    keys
    {
        key(PK; "Item No.", "Vendor No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {
            Clustered = true;
        }
        key(Key1; "Vendor No.", "Item No.", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity")
        {

        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}