table 17400 "CRM productrelationships"
{
    Caption = 'Product relationships';
    Description = '';
    ExternalName = 'productsubstitute';
    TableType = CRM;

    fields
    {
        field(1; productsubstituteid; Guid)
        {
            Caption = 'productsubstituteid';
            Description = 'Unique identifier for entity instances';
            ExternalAccess = Insert;
            ExternalName = 'productsubstituteid';
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
            Description = 'Unique identifier of the user who created the record.';
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
            Description = 'Unique identifier of the user who modified the record.';
            ExternalAccess = Read;
            ExternalName = 'modifiedby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(6; CreatedOnBehalfBy; Guid)
        {
            Caption = 'Created By (Delegate)';
            Description = 'Unique identifier of the delegate user who created the record.';
            ExternalAccess = Read;
            ExternalName = 'createdonbehalfby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(7; ModifiedOnBehalfBy; Guid)
        {
            Caption = 'Modified By (Delegate)';
            Description = 'Unique identifier of the delegate user who modified the record.';
            ExternalAccess = Read;
            ExternalName = 'modifiedonbehalfby';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(13; statecode; Option)
        {
            Caption = 'Status';
            Description = 'Status of the Área Manager BC';
            ExternalAccess = Modify;
            ExternalName = 'statecode';
            ExternalType = 'Status';
            InitValue = " ";
            OptionCaption = ' ,Active,Inactive';
            OptionOrdinalValues = -1, 0, 1;
            OptionMembers = " ",Active,Inactive;
        }
        // field(14; statuscode; Option)
        // {
        //     Caption = 'Status Reason';
        //     Description = 'Reason for the status of the Área Manager BC';
        //     ExternalName = 'statuscode';
        //     ExternalType = 'Status';
        //     InitValue = " ";
        //     OptionCaption = ' ,Active,Inactive';
        //     OptionOrdinalValues = -1, 1, 2;
        //     OptionMembers = " ",Active,Inactive;
        // }
        field(15; VersionNumber; BigInteger)
        {
            Caption = 'Version Number';
            Description = 'Version Number';
            ExternalAccess = Read;
            ExternalName = 'versionnumber';
            ExternalType = 'BigInt';
        }
        field(16; ImportSequenceNumber; Integer)
        {
            Caption = 'Import Sequence Number';
            Description = 'Sequence number of the import that created this record.';
            ExternalAccess = Insert;
            ExternalName = 'importsequencenumber';
            ExternalType = 'Integer';
        }
        field(18; TimeZoneRuleVersionNumber; Integer)
        {
            Caption = 'Time Zone Rule Version Number';
            Description = 'For internal use only.';
            ExternalName = 'timezoneruleversionnumber';
            ExternalType = 'Integer';
            MinValue = -1;
        }
        field(19; UTCConversionTimeZoneCode; Integer)
        {
            Caption = 'UTC Conversion Time Zone Code';
            Description = 'Time zone code that was in use when the record was created.';
            ExternalName = 'utcconversiontimezonecode';
            ExternalType = 'Integer';
            MinValue = -1;
        }
        field(20; Direction; Option)
        {
            Caption = 'Direction';
            Description = 'Reason for the status of the Área Manager BC';
            ExternalName = 'direction';
            ExternalType = 'Picklist';
            InitValue = "Uni-Directional";
            OptionCaption = 'Uni-Directional,Bi-Directional';
            OptionOrdinalValues = 0, 1;
            OptionMembers = "Uni-Directional","Bi-Directional";
        }

        field(21; exchangerate; Decimal)
        {
            Caption = 'exchangerate';
            Description = '';
            ExternalName = 'exchangerate';
            ExternalType = 'decimal';
        }
        field(22; name; text[100])
        {
            Caption = 'name';
            Description = '';
            ExternalName = 'name';
            ExternalType = 'string';
        }
        field(23; ProductId; Guid)
        {
            Caption = 'Existing Product';
            Description = 'Choose the product to include on the quote to link the product''s pricing and other information to the quote.';
            ExternalName = 'productid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Product".ProductId;
        }
        field(24; salesrelationshiptype; Option)
        {
            Caption = 'salesrelationshiptype';
            Description = 'Reason for the status of the Área Manager BC';
            ExternalName = 'salesrelationshiptype';
            ExternalType = 'Picklist';
            InitValue = "Up-sell";
            OptionCaption = 'Up-sell,Cross-sell,Accessory,Substitute';
            OptionOrdinalValues = 0, 1, 2, 3;
            OptionMembers = "Up-sell","Cross-sell",Accessory,Substitute;
        }
        field(25; substitutedproductid; Guid)
        {
            Caption = 'Existing Product';
            Description = 'Choose the product to include on the quote to link the product''s pricing and other information to the quote.';
            ExternalName = 'substitutedproductid';
            ExternalType = 'Lookup';
            TableRelation = "CRM Product".ProductId;
        }
    }

    keys
    {
        key(Key1; productsubstituteid)
        {
        }
        // key(Key2; name)
        // {
        // }
    }
}

