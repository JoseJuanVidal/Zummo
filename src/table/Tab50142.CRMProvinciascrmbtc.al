table 50142 "CRM Provincias_crm_btc"
{
    Caption = 'Provincia BC';
    Description = '';
    ExternalName = 'bit_bcprovincia';
    TableType = CRM;

    fields
    {
        field(1; bit_bcprovinciaId; Guid)
        {
            Caption = 'Provincia BC';
            Description = 'Unique identifier for entity instances';
            ExternalAccess = Insert;
            ExternalName = 'bit_bcprovinciaid';
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
        field(8; OwnerId; Guid)
        {
            Caption = 'Owner';
            Description = 'Owner Id';
            ExternalName = 'ownerid';
            ExternalType = 'Owner';
            TableRelation = IF (OwnerIdType = CONST(systemuser)) "CRM Systemuser".SystemUserId
            ELSE
            IF (OwnerIdType = CONST(team)) "CRM Team".TeamId;
        }
        field(9; OwnerIdType; Option)
        {
            Description = 'Owner Id Type';
            ExternalName = 'owneridtype';
            ExternalType = 'EntityName';
            OptionMembers = " ",systemuser,team;
        }
        field(10; OwningBusinessUnit; Guid)
        {
            Caption = 'Owning Business Unit';
            Description = 'Unique identifier for the business unit that owns the record';
            ExternalAccess = Read;
            ExternalName = 'owningbusinessunit';
            ExternalType = 'Lookup';
            TableRelation = "CRM Businessunit".BusinessUnitId;
        }
        field(11; OwningUser; Guid)
        {
            Caption = 'Owning User';
            Description = 'Unique identifier for the user that owns the record.';
            ExternalAccess = Read;
            ExternalName = 'owninguser';
            ExternalType = 'Lookup';
            TableRelation = "CRM Systemuser".SystemUserId;
        }
        field(12; OwningTeam; Guid)
        {
            Caption = 'Owning Team';
            Description = 'Unique identifier for the team that owns the record.';
            ExternalAccess = Read;
            ExternalName = 'owningteam';
            ExternalType = 'Lookup';
            TableRelation = "CRM Team".TeamId;
        }
        field(13; statecode; Option)
        {
            Caption = 'Status';
            Description = 'Status of the Provincia BC';
            ExternalAccess = Modify;
            ExternalName = 'statecode';
            ExternalType = 'State';
            InitValue = " ";
            OptionCaption = ' ,Active,Inactive';
            OptionOrdinalValues = -1, 0, 1;
            OptionMembers = " ",Active,Inactive;
        }
        field(14; statuscode; Option)
        {
            Caption = 'Status Reason';
            Description = 'Reason for the status of the Provincia BC';
            ExternalName = 'statuscode';
            ExternalType = 'Status';
            InitValue = " ";
            OptionCaption = ' ,Active,Inactive';
            OptionOrdinalValues = -1, 1, 2;
            OptionMembers = " ",Active,Inactive;
        }
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
        field(17; OverriddenCreatedOn; DateTime)
        {
            Caption = 'Record Created On';
            Description = 'Date and time that the record was migrated.';
            ExternalAccess = Insert;
            ExternalName = 'overriddencreatedon';
            ExternalType = 'DateTime';
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
        field(20; bit_Nombre; Text[100])
        {
            Caption = 'Nombre';
            Description = 'Required name field';
            ExternalName = 'bit_nombre';
            ExternalType = 'String';
        }
        field(21; bit_Codigo; Text[100])
        {
            Caption = 'Código';
            Description = '';
            ExternalName = 'bit_codigo';
            ExternalType = 'String';
        }
        field(22; bit_bcpais; Guid)
        {
            Caption = 'País';
            Description = '';
            ExternalName = 'bit_bcpais';
            ExternalType = 'Lookup';
            TableRelation = "CRM Paises_crm_btc".bit_BCPaisId; // "CRM Paises_btc".bit_BCPaisId;
        }
    }

    keys
    {
        key(Key1; bit_bcprovinciaId)
        {
        }
        key(Key2; bit_Nombre)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; bit_Nombre)
        {
        }
    }
}

