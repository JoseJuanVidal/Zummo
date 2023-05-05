table 17402 "CRM Campaign"
{
    Caption = 'CRM Leads';
    Description = '';
    ExternalName = 'campaign';
    TableType = CRM;

    fields
    {
        field(1; campaignid; Guid)
        {
            Caption = 'campaignid';
            Description = 'Unique identifier for entity instances';
            ExternalAccess = Insert;
            ExternalName = 'campaignid';
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
        field(90; OwnerId; Guid)
        {
            Caption = 'Owner';
            Description = 'Enter the user or team who is assigned to manage the record. This field is updated every time the record is assigned to a different user.';
            ExternalName = 'ownerid';
            ExternalType = 'Owner';
        }
        field(50001; name; Text[100])
        {
            Caption = 'Name';
            Description = '';
            ExternalName = 'name';
            ExternalType = 'String';
        }
        field(50002; codename; Text[100])
        {
            Caption = 'Code Name';
            Description = '';
            ExternalName = 'codename';
            ExternalType = 'String';
        }
        field(50007; description; Text[100])
        {
            Caption = 'description';
            Description = '';
            ExternalName = 'description';
            ExternalType = 'String';
        }
    }

    keys
    {
        key(Key1; campaignid)
        {
        }
    }
}