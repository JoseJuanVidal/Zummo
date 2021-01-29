table 50146 "CRM Productos_crm_btc"
{
    Caption = 'CRM Productos_btc';
    Description = 'Information about products and their pricing information.';
    ExternalName = 'product';
    TableType = CRM;

    fields
    {
        field(1; ProductId; Guid)
        {
            Caption = 'Product';
            Description = 'Unique identifier of the product.';
            ExternalAccess = Insert;
            ExternalName = 'productid';
            ExternalType = 'Uniqueidentifier';
        }
        //2.-DefaultUoMScheduleId
        field(4; Name; Text[100])
        {
            Caption = 'Name';
            Description = 'Name of the product.';
            ExternalName = 'name';
            ExternalType = 'String';
        }
        field(6; PriceLevelId; Guid)
        {
            Caption = 'Default Price List';
            Description = 'Select the default price list for the product.';
            ExternalAccess = Modify;
            ExternalName = 'pricelevelid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Pricelevel".PriceLevelId;
        }
        field(10; Price; Decimal)
        {
            Caption = 'List Price';
            Description = 'List price for the product item. Used in price calculations.';
            ExternalName = 'price';
            ExternalType = 'Money';
        }
        field(14; CurrentCost; Decimal)
        {
            Caption = 'Current Cost';
            Description = 'Current cost for the product item. Used in price calculations.';
            ExternalName = 'currentcost';
            ExternalType = 'Money';
        }
        field(24; CreatedOn; DateTime)
        {
            Caption = 'Created On';
            Description = 'Date and time when the record was created.';
            ExternalAccess = Read;
            ExternalName = 'createdon';
            ExternalType = 'DateTime';
        }
        field(25; ModifiedOn; DateTime)
        {
            Caption = 'Modified On';
            Description = 'Date and time when the record was modified.';
            ExternalAccess = Read;
            ExternalName = 'modifiedon';
            ExternalType = 'DateTime';
        }
        field(26; CreatedBy; Guid)
        {
            Caption = 'Created By';
            Description = 'Unique identifier of the user who created the product.';
            ExternalAccess = Read;
            ExternalName = 'createdby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }

        field(28; ModifiedBy; Guid)
        {
            Caption = 'Modified By';
            Description = 'Unique identifier of the user who last modified the product.';
            ExternalAccess = Read;
            ExternalName = 'modifiedby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(30; VersionNumber; BigInteger)
        {
            Caption = 'Version Number';
            Description = 'Version Number';
            ExternalAccess = Read;
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
        }
        field(37; OverriddenCreatedOn; DateTime)
        {
            Caption = 'Record Created On';
            Description = 'Date and time that the record was migrated.';
            ExternalAccess = Insert;
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
        }
        field(38; TransactionCurrencyId; Guid)
        {
            Caption = 'Currency';
            Description = 'Unique identifier of the currency associated with the product.';
            ExternalName = 'transactioncurrencyid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Transactioncurrency".TransactionCurrencyId;
        }
        field(39; ExchangeRate; Decimal)
        {
            Caption = 'Exchange Rate';
            Description = 'Exchange rate for the currency associated with the product with respect to the base currency.';
            ExternalAccess = Read;
            ExternalName = 'exchangerate';
            ExternalType = 'Decimal';
        }
        field(40; UTCConversionTimeZoneCode; Integer)
        {
            Caption = 'UTC Conversion Time Zone Code';
            Description = 'Time zone code that was in use when the record was created.';
            ExternalName = 'utcconversiontimezonecode';
            ExternalType = 'Integer';
            MinValue = -1;
        }
        field(41; ImportSequenceNumber; Integer)
        {
            Caption = 'Import Sequence Number';
            Description = 'Sequence number of the import that created this record.';
            ExternalAccess = Insert;
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
        }
        field(42; TimeZoneRuleVersionNumber; Integer)
        {
            Caption = 'Time Zone Rule Version Number';
            Description = 'For internal use only.';
            ExternalName = 'timezoneruleversionnumber';
            ExternalType = 'Integer';
            MinValue = -1;
        }
        field(47; CreatedOnBehalfBy; Guid)
        {
            Caption = 'Created By (Delegate)';
            Description = 'Unique identifier of the delegate user who created the product.';
            ExternalAccess = Read;
            ExternalName = 'createdonbehalfby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(49; ModifiedOnBehalfBy; Guid)
        {
            Caption = 'Modified By (Delegate)';
            Description = 'Unique identifier of the delegate user who last modified the product.';
            ExternalAccess = Read;
            ExternalName = 'modifiedonbehalfby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }

        field(52; ProcessId; Guid)
        {
            Caption = 'Process Id';
            Description = 'Contains the id of the process associated with the entity.';
            ExternalName = 'processid';
            ExternalType = 'Uniqueidentifier';
        }
        field(53; StageId; Guid)
        {
            Caption = '(Deprecated) Stage Id';
            Description = 'Contains the id of the stage where the entity is located.';
            ExternalName = 'stageid';
            ExternalType = 'Uniqueidentifier';
        }
        field(57; VendorID; Text[100])
        {
            Caption = 'Vendor ID';
            Description = 'Unique identifier of vendor supplying the product.';
            ExternalName = 'vendorid';
            ExternalType = 'String';
        }
        field(58; TraversedPath; Text[250])
        {
            Caption = '(Deprecated) Traversed Path';
            Description = 'A comma separated list of string values representing the unique identifiers of stages in a Business Process Flow Instance in the order that they occur.';
            ExternalName = 'traversedpath';
            ExternalType = 'String';
        }

        field(59; ValidFromDate; Date)
        {
            Caption = 'Valid From';
            Description = 'Date from which this product is valid.';
            ExternalName = 'validfromdate';
            ExternalType = 'DateTime';
        }
        field(60; ValidToDate; Date)
        {
            Caption = 'Valid To';
            Description = 'Date to which this product is valid.';
            ExternalName = 'validtodate';
            ExternalType = 'DateTime';
        }

        field(44; CurrentCost_Base; Decimal)
        {
            Caption = 'Current Cost (Base)';
            Description = 'Value of the Current Cost in base currency.';
            ExternalAccess = Read;
            ExternalName = 'currentcost_base';
            ExternalType = 'Money';
        }
        field(5; DefaultUoMId; Guid)
        {
            Caption = 'Default Unit';
            Description = 'Default unit for the product.';
            ExternalName = 'defaultuomid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Uom".UoMId;
        }
        field(32; DefaultUoMScheduleId; Guid)
        {
            Caption = 'Unit Group';
            Description = 'Default unit group for the product.';
            ExternalName = 'defaultuomscheduleid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Uomschedule".UoMScheduleId;
        }
        field(7; Description; BLOB)
        {
            Caption = 'Description';
            Description = 'Description of the product.';
            ExternalName = 'description';
            ExternalType = 'Memo';
            SubType = Memo;
        }
        field(11; IsKit; Boolean)
        {
            Caption = 'Is Kit';
            Description = 'Information that specifies whether the product is a kit.';
            ExternalName = 'iskit';
            ExternalType = 'Boolean';
        }
        field(20; IsStockItem; Boolean)
        {
            Caption = 'Stock Item';
            Description = 'Information about whether the product is a stock item.';
            ExternalName = 'isstockitem';
            ExternalType = 'Boolean';
        }
        field(54; ParentProductId; Guid)
        {
            Caption = 'Parent';
            Description = 'Specifies the parent product family hierarchy.';
            ExternalName = 'parentproductid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Productos_crm_btc".ProductId; // "CRM Productos_btc".ProductId;
        }

        field(45; Price_Base; Decimal)
        {
            Caption = 'List Price (Base)';
            Description = 'Value of the List Price in base currency.';
            ExternalAccess = Read;
            ExternalName = 'price_base';
            ExternalType = 'Money';
        }
        field(56; ProductStructure; Option)
        {
            Caption = 'Product Structure';
            Description = 'Product Structure.';
            ExternalAccess = Insert;
            ExternalName = 'productstructure';
            ExternalType = 'Picklist';
            InitValue = Product;
            OptionCaption = 'Product,Product Family,Product Bundle';
            OptionOrdinalValues = 1, 2, 3;
            OptionMembers = Product,ProductFamily,ProductBundle;
        }
        field(12; ProductNumber; Text[100])
        {
            Caption = 'Product ID';
            Description = 'User-defined product ID.';
            ExternalName = 'productnumber';
            ExternalType = 'String';
        }
        field(8; ProductTypeCode; Option)
        {
            Caption = 'Product Type';
            Description = 'Type of product.';
            ExternalName = 'producttypecode';
            ExternalType = 'Picklist';
            InitValue = SalesInventory;
            OptionCaption = 'Sales Inventory,Miscellaneous Charges,Services,Flat Fees';
            OptionOrdinalValues = 1, 2, 3, 4;
            OptionMembers = SalesInventory,MiscellaneousCharges,Services,FlatFees;
        }
        field(9; ProductUrl; Text[250])
        {
            Caption = 'URL';
            Description = 'URL for the Website associated with the product.';
            ExtendedDatatype = URL;
            ExternalName = 'producturl';
            ExternalType = 'String';
        }
        field(18; QuantityDecimal; Integer)
        {
            Caption = 'Decimals Supported';
            Description = 'Number of decimal places that can be used in monetary amounts for the product.';
            ExternalName = 'quantitydecimal';
            ExternalType = 'Integer';
            MaxValue = 5;
            MinValue = 0;
        }
        field(19; QuantityOnHand; Decimal)
        {
            Caption = 'Quantity On Hand';
            Description = 'Quantity of the product in stock.';
            ExternalName = 'quantityonhand';
            ExternalType = 'Decimal';
        }
        field(13; Size; Text[200])
        {
            Caption = 'Size';
            Description = 'Product size.';
            ExternalName = 'size';
            ExternalType = 'String';
        }
        field(16; StandardCost; Decimal)
        {
            Caption = 'Standard Cost';
            Description = 'Standard cost for the product item. Used in price calculations.';
            ExternalName = 'standardcost';
            ExternalType = 'Money';
        }
        field(46; StandardCost_Base; Decimal)
        {
            Caption = 'Standard Cost (Base)';
            Description = 'Value of the Standard Cost in base currency.';
            ExternalAccess = Read;
            ExternalName = 'standardcost_base';
            ExternalType = 'Money';
        }
        field(27; StateCode; Option)
        {
            Caption = 'Status';
            Description = 'Status of the product.';
            ExternalName = 'statecode';
            ExternalType = 'State';
            InitValue = Draft;
            OptionCaption = 'Active,Retired,Draft,Under Revision';
            OptionOrdinalValues = 0, 1, 2, 3;
            OptionMembers = Active,Retired,Draft,UnderRevision;
        }
        field(29; StatusCode; Option)
        {
            Caption = 'Status Reason';
            Description = 'Reason for the status of the product.';
            ExternalName = 'statuscode';
            ExternalType = 'Status';
            InitValue = " ";
            OptionCaption = ' ,Active,Retired,Draft,Under Revision';
            OptionOrdinalValues = -1, 1, 2, 0, 3;
            OptionMembers = " ",Active,Retired,Draft,UnderRevision;
        }
        field(15; StockVolume; Decimal)
        {
            Caption = 'Stock Volume';
            Description = 'Stock volume of the product.';
            ExternalName = 'stockvolume';
            ExternalType = 'Decimal';
        }
        field(17; StockWeight; Decimal)
        {
            Caption = 'Stock Weight';
            Description = 'Stock weight of the product.';
            ExternalName = 'stockweight';
            ExternalType = 'Decimal';
        }
        field(21; SupplierName; Text[100])
        {
            Caption = 'Supplier Name';
            Description = 'Name of the product''s supplier.';
            ExternalName = 'suppliername';
            ExternalType = 'String';
        }
        field(22; VendorName; Text[100])
        {
            Caption = 'Vendor';
            Description = 'Name of the product vendor.';
            ExternalName = 'vendorname';
            ExternalType = 'String';
        }
        field(23; VendorPartNumber; Text[100])
        {
            Caption = 'Vendor Name';
            Description = 'Unique part identifier in vendor catalog of this product.';
            ExternalName = 'vendorpartnumber';
            ExternalType = 'String';
        }
        field(61; HierarchyPath; Text[250])
        {
            Caption = 'Hierarchy Path';
            Description = 'Hierarchy path of the product.';
            ExternalAccess = Read;
            ExternalName = 'hierarchypath';
            ExternalType = 'String';
        }

        field(51; EntityImageId; Guid)
        {
            ExternalAccess = Read;
            ExternalName = 'entityimageid';
            ExternalType = 'Uniqueidentifier';
        }
        field(200; IsReparented; Boolean)
        {
            Caption = 'Is Reparented';
            Description = '';
            ExternalName = 'isreparented';
            ExternalType = 'Boolean';
        }
    }

    keys
    {
        key(Key1; ProductId)
        {
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name)
        {
        }
    }
}

