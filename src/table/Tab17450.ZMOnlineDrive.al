table 17450 "ZM Online Drive"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; id; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(2; name; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; description; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; driveType; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(5; createdDateTime; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(6; lastModifiedDateTime; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(7; webUrl; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(8; isFile; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(9; mimeType; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(10; size; BigInteger)
        {
            DataClassification = CustomerContent;
        }
        field(11; driveId; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(12; parentId; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
}