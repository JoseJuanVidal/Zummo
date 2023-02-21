table 17401 "CRM Leads"
{
    Caption = 'CRM Leads';
    Description = '';
    ExternalName = 'lead';
    TableType = CRM;

    fields
    {
        field(1; LeadId; Guid)
        {
            Caption = 'productsubstituteid';
            Description = 'Unique identifier for entity instances';
            ExternalAccess = Insert;
            ExternalName = 'leadid';
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
        field(90; OwnerId; Guid)
        {
            Caption = 'Owner';
            Description = 'Enter the user or team who is assigned to manage the record. This field is updated every time the record is assigned to a different user.';
            ExternalName = 'ownerid';
            ExternalType = 'Owner';
        }
        field(100; zum_areamanager; guid)
        {
            Caption = 'Área Manager BC';
            Description = '';
            ExternalName = 'zum_areamanager';
            ExternalType = 'Lookup';
            TableRelation = "CRM AreaManager_crm_btc".zum_bcareamanagerId;  // "CRM Area Manager_btc".zum_bcareamanagerId;
        }
        field(50001; companyname; Text[100])
        {
            Caption = 'Company Name';
            Description = '';
            ExternalName = 'companyname';
            ExternalType = 'String';
        }
        field(50002; firstname; Text[100])
        {
            Caption = 'First Name';
            Description = '';
            ExternalName = 'firstname';
            ExternalType = 'String';
        }
        field(50003; lastname; Text[100])
        {
            Caption = 'Last Name';
            Description = '';
            ExternalName = 'lastname';
            ExternalType = 'String';
        }
        field(50004; zum_ac_enlacemail; Text[100])
        {
            Caption = 'zum ac enlacemail';
            Description = '';
            ExternalName = 'zum_ac_enlacemail';
            ExternalType = 'String';
        }
        field(50005; zum_ac_areamanager; Text[100])
        {
            Caption = 'zum ac areamanager';
            Description = '';
            ExternalName = 'zum_ac_areamanager';
            ExternalType = 'String';
        }

    }

    keys
    {
        key(Key1; LeadId)
        {
        }
        // key(Key2; name)
        // {
        // }
    }
}