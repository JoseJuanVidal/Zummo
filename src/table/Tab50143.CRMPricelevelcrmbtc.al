table 50143 "CRM Pricelevel_crm_btc"
{
    Caption = 'CRM Pricelevel_btc';
    Description = 'Entity that defines pricing levels.';
    ExternalName = 'pricelevel';
    TableType = CRM;

    fields
    {
        field(1; PriceLevelId; Guid)
        {
            Caption = 'Price List';
            Description = 'Unique identifier of the price list.';
            ExternalAccess = Insert;
            ExternalName = 'pricelevelid';
            ExternalType = 'Uniqueidentifier';
        }
        field(2; CreatedOn; DateTime)
        {
            Caption = 'Created On';
            Description = 'Date and time when the record was created.';
            ExternalAccess = Read;
            ExternalName = 'createdon';
            ExternalType = 'DateTime';
        }
        field(3; CreatedBy; Guid)
        {
            Caption = 'Created By';
            Description = 'Unique identifier of the user who created the price list.';
            ExternalAccess = Read;
            ExternalName = 'createdby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(4; ModifiedOn; DateTime)
        {
            Caption = 'Modified On';
            Description = 'Date and time when the record was modified.';
            ExternalAccess = Read;
            ExternalName = 'modifiedon';
            ExternalType = 'DateTime';
        }
        field(5; ModifiedBy; Guid)
        {
            Caption = 'Modified By';
            Description = 'Unique identifier of the user who last modified the price list.';
            ExternalAccess = Read;
            ExternalName = 'modifiedby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(6; CreatedOnBehalfBy; Guid)
        {
            Caption = 'Created By (Delegate)';
            Description = 'Unique identifier of the delegate user who created the pricelevel.';
            ExternalAccess = Read;
            ExternalName = 'createdonbehalfby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(7; ModifiedOnBehalfBy; Guid)
        {
            Caption = 'Modified By (Delegate)';
            Description = 'Unique identifier of the delegate user who last modified the pricelevel.';
            ExternalAccess = Read;
            ExternalName = 'modifiedonbehalfby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(8; VersionNumber; BigInteger)
        {
            Caption = 'Version Number';
            Description = 'Version Number';
            ExternalAccess = Read;
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
        }
        field(9; ImportSequenceNumber; Integer)
        {
            Caption = 'Import Sequence Number';
            Description = 'Sequence number of the import that created this record.';
            ExternalAccess = Insert;
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
        }
        field(10; OverriddenCreatedOn; DateTime)
        {
            Caption = 'Record Created On';
            Description = 'Date and time that the record was migrated.';
            ExternalAccess = Insert;
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
        }
        field(11; TimeZoneRuleVersionNumber; Integer)
        {
            Caption = 'Time Zone Rule Version Number';
            Description = 'For internal use only.';
            ExternalName = 'timezoneruleversionnumber';
            ExternalType = 'Integer';
            MinValue = -1;
        }
        field(12; UTCConversionTimeZoneCode; Integer)
        {
            Caption = 'UTC Conversion Time Zone Code';
            Description = 'Time zone code that was in use when the record was created.';
            ExternalName = 'utcconversiontimezonecode';
            ExternalType = 'Integer';
            MinValue = -1;
        }
        field(13; Name; Text[100])
        {
            Caption = 'Name';
            Description = 'Name of the price list.';
            ExternalName = 'name';
            ExternalType = 'String';
        }
        field(14; BeginDate; DateTime)
        {
            Caption = 'Start Date';
            Description = 'Date on which the price list becomes effective.';
            ExternalName = 'begindate';
            ExternalType = 'DateTime';
        }
        field(15; Description; BLOB)
        {
            Caption = 'Description';
            Description = 'Description of the price list.';
            ExternalName = 'description';
            ExternalType = 'Memo';
            SubType = Memo;
        }
        field(16; EndDate; DateTime)
        {
            Caption = 'End Date';
            Description = 'Date that is the last day the price list is valid.';
            ExternalName = 'enddate';
            ExternalType = 'DateTime';
        }
        field(17; FreightTermsCode; Option)
        {
            Caption = 'Freight Terms';
            Description = 'Freight terms for the price list.';
            ExternalName = 'freighttermscode';
            ExternalType = 'Picklist';
            InitValue = DefaultValue;
            OptionCaption = 'Default Value';
            OptionOrdinalValues = 1;
            OptionMembers = DefaultValue;
        }
        field(18; PaymentMethodCode; Option)
        {
            Caption = 'Payment Method ';
            Description = 'Payment terms to use with the price list.';
            ExternalName = 'paymentmethodcode';
            ExternalType = 'Picklist';
            InitValue = DefaultValue;
            OptionCaption = 'Default Value';
            OptionOrdinalValues = 1;
            OptionMembers = DefaultValue;
        }
        field(19; ShippingMethodCode; Option)
        {
            Caption = 'Shipping Method';
            Description = 'Method of shipment for products in the price list.';
            ExternalName = 'shippingmethodcode';
            ExternalType = 'Picklist';
            InitValue = DefaultValue;
            OptionCaption = 'Default Value';
            OptionOrdinalValues = 1;
            OptionMembers = DefaultValue;
        }
        field(20; StateCode; Option)
        {
            Caption = 'Status ';
            Description = 'Status of the price list.';
            ExternalAccess = Modify;
            ExternalName = 'statecode';
            ExternalType = 'State';
            InitValue = Active;
            OptionCaption = 'Active,Inactive';
            OptionOrdinalValues = 0, 1;
            OptionMembers = Active,Inactive;
        }
        field(21; StatusCode; Option)
        {
            Caption = 'Status Reason';
            Description = 'Reason for the status of the price list.';
            ExternalName = 'statuscode';
            ExternalType = 'Status';
            InitValue = " ";
            OptionCaption = ' ,Active,Inactive';
            OptionOrdinalValues = -1, 100001, 100002;
            OptionMembers = " ",Active,Inactive;
        }
        field(22; ExchangeRate; Decimal)
        {
            Caption = 'Exchange Rate';
            Description = 'Shows the conversion rate of the record''s currency. The exchange rate is used to convert all money fields in the record from the local currency to the system''s default currency.';
            ExternalAccess = Read;
            ExternalName = 'exchangerate';
            ExternalType = 'Decimal';
        }
        field(23; TransactionCurrencyId; Guid)
        {
            Caption = 'Currency';
            Description = 'Unique identifier of the currency associated with the price level.';
            ExternalAccess = Insert;
            ExternalName = 'transactioncurrencyid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Transactioncurrency".TransactionCurrencyId;
        }
    }

    keys
    {
        key(Key1; PriceLevelId)
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

